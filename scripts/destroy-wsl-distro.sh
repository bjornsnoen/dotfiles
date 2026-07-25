#!/usr/bin/env bash
# Securely destroy a WSL distro, then unregister it.
#
# Why bare-mount + blkdiscard, and NOT overwriting the .vhdx file:
#   * Overwriting the .vhdx *file* directly from inside WSL fails with EACCES:
#     the file is accessed over drvfs and the host holds it open. sudo can't
#     help -- it's a Windows sharing lock, not a Linux permission.
#   * `wsl --mount --vhd --bare` hands the disk to the VM as a block device,
#     the sanctioned path to get exclusive block access while WSL runs.
#   * A full dd over the block device would balloon the dynamic VHDX to its
#     full virtual size (e.g. 1T) on the host. blkdiscard DEALLOCATES every
#     block instead: reads return zero afterwards, the VHDX shrinks rather
#     than grows, and it's near-instant.
#
# Gotcha handled below: if a previous run was interrupted after the bare-mount
# but before the unmount, the disk stays attached. Re-attaching then fails with
# ERROR_SHARING_VIOLATION. We detect that, try to detach and retry; if WSL has
# lost track of the attachment entirely (a "zombie", only clearable by
# `wsl --shutdown`), we say so instead of failing cryptically.
#
# blkdiscard is a logical wipe (blocks deallocated + zero-on-read), then the
# file is deleted by --unregister. Against opportunistic snooping -- plus
# BitLocker underneath -- that is sufficient. It is NOT a guaranteed physical
# overwrite of freed SSD cells; pass --overwrite for a random pass first
# (bounded to the current allocated size to avoid a runaway balloon).
#
# DESTRUCTIVE AND IRREVERSIBLE. Run from a *different* distro than the target.
set -euo pipefail

overwrite=0
usage() { echo "usage: $0 [--overwrite] <distro-name>"; }
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage; exit 0 ;;
        --overwrite) overwrite=1; shift ;;
        --) shift; break ;;
        -*) echo "error: unknown option '$1'" >&2; usage >&2; exit 2 ;;
        *) break ;;
    esac
done
[[ $# -eq 1 ]] || { usage >&2; exit 2; }
target="$1"

here=$(dirname "$(readlink -f "$0")")
map="$here/wsl-disk-map"
[[ -x "$map" ]] || { echo "error: $map not found" >&2; exit 1; }

if [[ "${WSL_DISTRO_NAME:-}" == "$target" ]]; then
    echo "error: refusing to destroy the distro this script is running in" >&2
    exit 1
fi

if ! wsl.exe --list --quiet </dev/null | tr -d '\0\r' | grep -qxF -- "$target"; then
    echo "error: '$target' is not a registered distro" >&2
    exit 1
fi

# Terminate so the VHDX detaches and lists as (stopped).
wsl.exe --terminate "$target" </dev/null >/dev/null 2>&1 || true

vhdx=$("$map" | sed -n "s/^-[[:space:]]\+[^[:space:]]\+[[:space:]]\+$target (stopped)[[:space:]]\+//p")
[[ -n "$vhdx" ]] || { echo "error: could not resolve VHDX for '$target'" >&2; exit 1; }
file=$(wslpath -u "${vhdx#\\\\?\\}" 2>/dev/null || true)
alloc=0
[[ -f "$file" ]] && alloc=$(stat -c %s "$file")

echo "Target distro : $target"
echo "VHDX          : $vhdx"
echo "On-disk size  : $(numfmt --to=iec "$alloc")"
echo "Method        : $([[ $overwrite -eq 1 ]] && echo 'random overwrite + blkdiscard' || echo 'blkdiscard (deallocate)')"
echo
echo "This IRREVERSIBLY wipes the disk, then unregisters '$target'."
read -r -p "Type the distro name to confirm: " answer
[[ "$answer" == "$target" ]] || { echo "aborted." >&2; exit 1; }

# Attach the vhdx bare, returning wsl.exe's real exit code (no pipe masking it)
# and stashing its (CR/NUL-stripped) message in ATTACH_MSG.
ATTACH_MSG=""
do_attach() {
    # tr strips the UTF-16 NUL/CR bytes *inside* the substitution so bash never
    # sees them (avoids the "ignored null byte" warning). pipefail (set above)
    # makes the pipeline surface wsl.exe's non-zero exit even though tr succeeds.
    ATTACH_MSG=$(wsl.exe --mount --vhd --bare "$vhdx" </dev/null 2>&1 | tr -d '\0\r'); local rc=$?
    return $rc
}
is_violation() { grep -qiE 'sharing.?violation|being used by another process' <<<"$ATTACH_MSG"; }

# Attach bare and detect the new /dev/sdX by diffing lsblk.
before=$(lsblk -dn -o NAME | sort)
if do_attach; then
    :
elif is_violation; then
    # Interrupted prior run left the disk attached. Try to detach and retry.
    echo "note: '$target' disk is already attached (orphan from an interrupted run); detaching..." >&2
    wsl.exe --unmount "$vhdx" </dev/null >/dev/null 2>&1 || true
    sleep 1
    before=$(lsblk -dn -o NAME | sort)
    if ! do_attach; then
        if is_violation; then
            cat >&2 <<EOF

error: '$target' disk is stuck as a zombie bare-mount that WSL no longer
tracks (leftover from an interrupted run; 'wsl --unmount' can't find it).
Only a full restart clears it. From a Windows terminal run:
    wsl --shutdown
then re-run this script. (Note: this also stops the distro you're in.)
EOF
        else
            echo "error: attach failed: $ATTACH_MSG" >&2
        fi
        exit 1
    fi
else
    echo "error: attach failed: $ATTACH_MSG" >&2
    exit 1
fi
sleep 1
new=$(comm -13 <(echo "$before") <(lsblk -dn -o NAME | sort))

cleanup() { wsl.exe --unmount "$vhdx" </dev/null >/dev/null 2>&1 || true; }
trap cleanup EXIT

if [[ -z "$new" || $(wc -l <<<"$new") -ne 1 ]]; then
    echo "error: expected exactly one new device, got: ${new:-none}" >&2
    exit 1
fi
dev="/dev/$new"
echo "Attached as $dev"

if [[ $overwrite -eq 1 && $alloc -gt 0 ]]; then
    # Overwrite only the currently-allocated span (front of the disk) so the
    # VHDX balloons to at most ~alloc, not its full virtual size. dd hitting
    # end-of-device (ENOSPC) is fine.
    echo ">> random overwrite: first $(numfmt --to=iec "$alloc")"
    sudo dd if=/dev/urandom of="$dev" bs=4M count="$alloc" \
        iflag=count_bytes,fullblock oflag=direct status=progress 2>&1 |
        grep -v 'No space left on device' || true
    sync
fi

echo ">> blkdiscard $dev"
sudo blkdiscard -f "$dev"
sync

wsl.exe --unmount "$vhdx" </dev/null
trap - EXIT

wsl.exe --unregister "$target" </dev/null
echo "done: '$target' wiped and unregistered."
