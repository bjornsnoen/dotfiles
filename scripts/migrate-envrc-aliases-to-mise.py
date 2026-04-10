#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import re
import shlex
import sys
from dataclasses import dataclass
from pathlib import Path


ENVRC_FILENAME = ".envrc"
MISE_FILENAME = "mise.toml"


SKIP_DIRS = {
    ".git",
    ".direnv",
    "node_modules",
    ".venv",
    "venv",
    "__pycache__",
}


ALIAS_KEY_RE = re.compile(r"^\s*([A-Za-z0-9_-]+)\s*=")
SECTION_RE = re.compile(r"^\s*\[([^\]]+)\]\s*$")


@dataclass(frozen=True)
class EnvrcAliases:
    path: Path
    aliases: dict[str, str]


def iter_envrc_files(root: Path) -> list[Path]:
    envrcs: list[Path] = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        if ENVRC_FILENAME in filenames:
            envrcs.append(Path(dirpath) / ENVRC_FILENAME)
    return sorted(envrcs)


def iter_parent_envrc_files(root: Path, *, stop_at: Path) -> list[Path]:
    root = root if root.is_dir() else root.parent
    envrcs: list[Path] = []
    for d in [root, *root.parents]:
        if (d / ENVRC_FILENAME).is_file():
            envrcs.append(d / ENVRC_FILENAME)
        if d == stop_at:
            break
    return envrcs


def _unquote(s: str) -> str:
    s = s.strip()
    if len(s) >= 2 and ((s[0] == s[-1] == "'") or (s[0] == s[-1] == '"')):
        return s[1:-1]
    return s


def parse_envrc_aliases(envrc_path: Path) -> EnvrcAliases:
    aliases: dict[str, str] = {}
    for raw_line in envrc_path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue

        if line.startswith("export_alias "):
            try:
                parts = shlex.split(line, posix=True)
            except ValueError:
                continue
            if len(parts) < 3:
                continue
            name = parts[1]
            cmd = " ".join(parts[2:]).strip()
            if name and cmd:
                aliases[name] = cmd
            continue

        if line.startswith("alias "):
            rest = line[len("alias ") :].strip()
            if "=" not in rest:
                continue
            name, value = rest.split("=", 1)
            name = name.strip()
            value = _unquote(value)
            if name and value:
                aliases[name] = value
            continue

    return EnvrcAliases(path=envrc_path, aliases=aliases)


def toml_escape_basic_string(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"')


def upsert_shell_alias_section(
    mise_path: Path, new_aliases: dict[str, str], *, overwrite: bool, dry_run: bool
) -> tuple[bool, list[str]]:
    changed = False
    notes: list[str] = []

    if mise_path.exists():
        lines = mise_path.read_text(encoding="utf-8", errors="replace").splitlines(keepends=True)
    else:
        lines = []

    section_start = None
    section_end = None

    for idx, line in enumerate(lines):
        m = SECTION_RE.match(line)
        if not m:
            continue
        section = m.group(1).strip()
        if section == "shell_alias":
            section_start = idx
            for j in range(idx + 1, len(lines)):
                if SECTION_RE.match(lines[j]):
                    section_end = j
                    break
            if section_end is None:
                section_end = len(lines)
            break

    if section_start is None:
        if lines and not lines[-1].endswith("\n"):
            lines[-1] += "\n"
        if lines and lines[-1].strip():
            lines.append("\n")
        lines.append("[shell_alias]\n")
        section_start = len(lines) - 1
        section_end = len(lines)
        changed = True

    existing_keys: set[str] = set()
    for line in lines[section_start + 1 : section_end]:
        if line.lstrip().startswith("#") or not line.strip():
            continue
        km = ALIAS_KEY_RE.match(line)
        if km:
            existing_keys.add(km.group(1))

    to_add: list[tuple[str, str]] = []
    for name, cmd in sorted(new_aliases.items()):
        if name in existing_keys and not overwrite:
            notes.append(f"{mise_path.parent}: kept existing shell_alias {name!r}")
            continue
        to_add.append((name, cmd))

    if not to_add:
        return (changed, notes)

    insert_at = section_end
    new_lines: list[str] = []
    for name, cmd in to_add:
        new_lines.append(f'{name} = "{toml_escape_basic_string(cmd)}"\n')
    lines[insert_at:insert_at] = new_lines
    changed = True

    if dry_run:
        return (changed, notes + [f"{mise_path}: would add {len(to_add)} alias(es)"])

    mise_path.write_text("".join(lines), encoding="utf-8")
    return (changed, notes + [f"{mise_path}: added {len(to_add)} alias(es)"])


def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(
        description="Migrate alias declarations in .envrc into mise.toml [shell_alias]."
    )
    p.add_argument("root", nargs="?", default=".", help="Root directory to scan (default: .)")
    p.add_argument(
        "--parents",
        default=True,
        action=argparse.BooleanOptionalAction,
        help="Also check parent directories up to $HOME for .envrc (default: true).",
    )
    p.add_argument(
        "--overwrite",
        action="store_true",
        help="Overwrite existing [shell_alias] keys in mise.toml (default: keep existing).",
    )
    p.add_argument(
        "--dry-run",
        action="store_true",
        help="Print what would change without writing files.",
    )
    args = p.parse_args(argv)

    root = Path(args.root).expanduser().resolve()
    envrc_paths = iter_envrc_files(root)
    if args.parents:
        home = Path.home().resolve()
        stop_at = home if home in [root, *root.parents] else Path(root.anchor or "/").resolve()
        envrc_paths.extend(iter_parent_envrc_files(root, stop_at=stop_at))
        envrc_paths = sorted(set(envrc_paths))
    if not envrc_paths:
        print(f"No {ENVRC_FILENAME} files found under {root}")
        return 0

    total_envrc = 0
    total_aliases = 0
    touched = 0

    for envrc_path in envrc_paths:
        total_envrc += 1
        parsed = parse_envrc_aliases(envrc_path)
        if not parsed.aliases:
            continue

        total_aliases += len(parsed.aliases)
        mise_path = envrc_path.parent / MISE_FILENAME
        changed, notes = upsert_shell_alias_section(
            mise_path, parsed.aliases, overwrite=args.overwrite, dry_run=args.dry_run
        )
        for n in notes:
            print(n)
        if changed:
            touched += 1

    print(
        f"Scanned {total_envrc} {ENVRC_FILENAME} file(s), found {total_aliases} alias(es), "
        f"touched {touched} {MISE_FILENAME} file(s)."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
