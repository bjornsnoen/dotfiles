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
ENV_KEY_RE = re.compile(r"^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=")
ENV_DIRECTIVE_RE = re.compile(r"^\s*_\.(file|path|python\.venv)\s*=")
SECTION_RE = re.compile(r"^\s*\[([^\]]+)\]\s*$")
TOML_BARE_KEY_RE = re.compile(r"^[A-Za-z0-9_-]+$")
EXPORT_ASSIGNMENT_RE = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*)=(.*)$")
SHELL_VAR_RE = re.compile(r"\$(?:[A-Za-z_][A-Za-z0-9_]*|\{[A-Za-z_][A-Za-z0-9_]*\})")
OLD_POETRY_VENV_PATH = (
    "{{ exec(command='poetry env use $(uv python find) >/dev/null && poetry env info --path') }}"
)
POETRY_OR_UV_VENV_PATH = (
    "{{ exec(command='"
    "if poetry env use $(uv python find) >/dev/null 2>&1; "
    "then poetry env info --path; else printf .venv; fi"
    "') }}"
)


@dataclass(frozen=True)
class EnvrcData:
    path: Path
    aliases: dict[str, str]
    env: dict[str, str]
    paths: list[str]
    dotenv_files: list[str]
    poetry: bool
    uv: bool
    unsupported: list[str]


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


def parse_envrc(envrc_path: Path) -> EnvrcData:
    aliases: dict[str, str] = {}
    env: dict[str, str] = {}
    paths: list[str] = []
    dotenv_files: list[str] = []
    poetry = False
    uv = False
    unsupported: list[str] = []

    for lineno, raw_line in enumerate(
        envrc_path.read_text(encoding="utf-8", errors="replace").splitlines(), start=1
    ):
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

        if line.startswith("export "):
            try:
                parts = shlex.split(line[len("export ") :], posix=True, comments=False)
            except ValueError:
                unsupported.append(f"{envrc_path}:{lineno}: could not parse export")
                continue
            for part in parts:
                m = EXPORT_ASSIGNMENT_RE.match(part)
                if not m:
                    unsupported.append(f"{envrc_path}:{lineno}: skipped export without assignment")
                    continue
                env[m.group(1)] = m.group(2)
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

        if line.startswith("PATH_add "):
            try:
                parts = shlex.split(line, posix=True, comments=False)
            except ValueError:
                unsupported.append(f"{envrc_path}:{lineno}: could not parse PATH_add")
                continue
            paths.extend(parts[1:])
            continue

        if line.startswith("dotenv"):
            try:
                parts = shlex.split(line, posix=True, comments=False)
            except ValueError:
                unsupported.append(f"{envrc_path}:{lineno}: could not parse dotenv")
                continue
            dotenv_files.extend(parts[1:] or [".env"])
            continue

        if line in {". .env", ". ./.env", "source .env", "source ./.env"}:
            dotenv_files.append(".env")
            continue

        if line in {"layout poetry", "layout_poetry"}:
            poetry = True
            continue

        if line in {"layout uv", "layout_uv"}:
            uv = True
            continue

        if line in {"if [ -f .env ]; then", "if [[ -f .env ]]; then", "set -a", "set +a", "fi"}:
            continue

        unsupported.append(f"{envrc_path}:{lineno}: skipped {line!r}")

    return EnvrcData(
        path=envrc_path,
        aliases=aliases,
        env=env,
        paths=_dedupe(paths),
        dotenv_files=_dedupe(dotenv_files),
        poetry=poetry,
        uv=uv,
        unsupported=unsupported,
    )


def _dedupe(values: list[str]) -> list[str]:
    seen: set[str] = set()
    result: list[str] = []
    for value in values:
        if value in seen:
            continue
        seen.add(value)
        result.append(value)
    return result


def toml_escape_basic_string(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"')


def toml_key(key: str) -> str:
    if TOML_BARE_KEY_RE.match(key):
        return key
    return f'"{toml_escape_basic_string(key)}"'


def toml_string(s: str) -> str:
    return f'"{toml_escape_basic_string(s)}"'


def toml_string_array(values: list[str]) -> str:
    return "[" + ", ".join(toml_string(value) for value in values) + "]"


def toml_bool(value: bool) -> str:
    return "true" if value else "false"


def get_section_bounds(lines: list[str], section_name: str) -> tuple[int | None, int | None]:
    for idx, line in enumerate(lines):
        m = SECTION_RE.match(line)
        if not m:
            continue
        section = m.group(1).strip()
        if section != section_name:
            continue
        for j in range(idx + 1, len(lines)):
            if SECTION_RE.match(lines[j]):
                return idx, j
        return idx, len(lines)
    return None, None


def read_mise_lines(mise_path: Path) -> list[str]:
    if mise_path.exists():
        return mise_path.read_text(encoding="utf-8", errors="replace").splitlines(keepends=True)
    return []


def write_mise_lines(mise_path: Path, lines: list[str], *, dry_run: bool) -> None:
    if not dry_run:
        mise_path.write_text("".join(lines), encoding="utf-8")


def ensure_section(lines: list[str], section_name: str) -> tuple[int, int, bool]:
    section_start, section_end = get_section_bounds(lines, section_name)
    if section_start is not None and section_end is not None:
        return section_start, section_end, False

    if lines and not lines[-1].endswith("\n"):
        lines[-1] += "\n"
    if lines and lines[-1].strip():
        lines.append("\n")
    lines.append(f"[{section_name}]\n")
    section_start = len(lines) - 1
    section_end = len(lines)
    return section_start, section_end, True


def upsert_settings_section(
    mise_path: Path, settings: dict[str, bool], *, overwrite: bool, dry_run: bool
) -> tuple[bool, list[str]]:
    changed = False
    notes: list[str] = []
    lines = read_mise_lines(mise_path)
    section_start, section_end, created = ensure_section(lines, "settings")
    changed = changed or created

    existing_keys: dict[str, int] = {}
    for idx in range(section_start + 1, section_end):
        line = lines[idx]
        if line.lstrip().startswith("#") or not line.strip():
            continue
        km = ENV_KEY_RE.match(line)
        if km:
            existing_keys[km.group(1)] = idx

    insert_at = section_end
    new_lines: list[str] = []

    for name, value in sorted(settings.items()):
        line = f"{toml_key(name)} = {toml_bool(value)}\n"
        if name in existing_keys:
            old_idx = existing_keys[name]
            if overwrite and lines[old_idx] != line:
                lines[old_idx] = line
                changed = True
            elif not overwrite:
                notes.append(f"{mise_path.parent}: kept existing setting {name!r}")
            continue
        new_lines.append(line)

    if new_lines:
        lines[insert_at:insert_at] = new_lines
        changed = True

    if changed:
        write_mise_lines(mise_path, lines, dry_run=dry_run)
        action = "would update" if dry_run else "updated"
        notes.append(f"{mise_path}: {action} [settings]")

    return changed, notes


def upsert_env_section(
    mise_path: Path,
    new_env: dict[str, str],
    new_paths: list[str],
    new_dotenv_files: list[str],
    poetry: bool,
    uv: bool,
    *,
    overwrite: bool,
    dry_run: bool,
) -> tuple[bool, list[str]]:
    changed = False
    notes: list[str] = []
    lines = read_mise_lines(mise_path)
    section_start, section_end, created = ensure_section(lines, "env")
    changed = changed or created

    existing_env_keys: dict[str, int] = {}
    existing_directives: dict[str, int] = {}
    for idx in range(section_start + 1, section_end):
        line = lines[idx]
        if line.lstrip().startswith("#") or not line.strip():
            continue
        km = ENV_KEY_RE.match(line)
        if km:
            existing_env_keys[km.group(1)] = idx
            continue
        dm = ENV_DIRECTIVE_RE.match(line)
        if dm:
            existing_directives[dm.group(1)] = idx

    insert_at = section_end
    new_lines: list[str] = []

    for name, value in sorted(new_env.items()):
        line = f"{toml_key(name)} = {toml_string(value)}\n"
        if name in existing_env_keys:
            if overwrite:
                old_idx = existing_env_keys[name]
                if lines[old_idx] != line:
                    lines[old_idx] = line
                    changed = True
                continue
            notes.append(f"{mise_path.parent}: kept existing env {name!r}")
            continue
        new_lines.append(line)

    if new_dotenv_files:
        line = f"_.file = {toml_string_array(new_dotenv_files)}\n"
        if "file" in existing_directives:
            if overwrite:
                old_idx = existing_directives["file"]
                if lines[old_idx] != line:
                    lines[old_idx] = line
                    changed = True
            else:
                notes.append(f"{mise_path.parent}: kept existing env _.file")
        else:
            new_lines.append(line)

    if new_paths:
        line = f"_.path = {toml_string_array(new_paths)}\n"
        if "path" in existing_directives:
            if overwrite:
                old_idx = existing_directives["path"]
                if lines[old_idx] != line:
                    lines[old_idx] = line
                    changed = True
            else:
                notes.append(f"{mise_path.parent}: kept existing env _.path")
        else:
            new_lines.append(line)

    if poetry or uv:
        if poetry:
            line = f"_.python.venv = {{ path = {toml_string(POETRY_OR_UV_VENV_PATH)}, create = true }}\n"
        else:
            line = '_.python.venv = { path = ".venv", create = true }\n'
        if "python.venv" in existing_directives:
            old_idx = existing_directives["python.venv"]
            old_line = lines[old_idx]
            if overwrite:
                if lines[old_idx] != line:
                    lines[old_idx] = line
                    changed = True
            elif OLD_POETRY_VENV_PATH in old_line:
                lines[old_idx] = line
                changed = True
            else:
                notes.append(f"{mise_path.parent}: kept existing env _.python.venv")
        else:
            new_lines.append(line)

    if new_lines:
        lines[insert_at:insert_at] = new_lines
        changed = True

    if changed:
        write_mise_lines(mise_path, lines, dry_run=dry_run)
        action = "would update" if dry_run else "updated"
        notes.append(f"{mise_path}: {action} [env]")

    return changed, notes


def upsert_shell_alias_section(
    mise_path: Path, new_aliases: dict[str, str], *, overwrite: bool, dry_run: bool
) -> tuple[bool, list[str]]:
    changed = False
    notes: list[str] = []
    lines = read_mise_lines(mise_path)
    section_start, section_end, created = ensure_section(lines, "shell_alias")
    changed = changed or created

    existing_keys: dict[str, int] = {}
    for offset, line in enumerate(lines[section_start + 1 : section_end], start=section_start + 1):
        if line.lstrip().startswith("#") or not line.strip():
            continue
        km = ALIAS_KEY_RE.match(line)
        if km:
            existing_keys[km.group(1)] = offset

    to_add: list[tuple[str, str]] = []
    for name, cmd in sorted(new_aliases.items()):
        line = f"{toml_key(name)} = {toml_string(cmd)}\n"
        if name in existing_keys:
            if overwrite:
                old_idx = existing_keys[name]
                if lines[old_idx] != line:
                    lines[old_idx] = line
                    changed = True
                continue
            notes.append(f"{mise_path.parent}: kept existing shell_alias {name!r}")
            continue
        to_add.append((name, cmd))

    if not to_add:
        if changed:
            write_mise_lines(mise_path, lines, dry_run=dry_run)
            action = "would update" if dry_run else "updated"
            notes.append(f"{mise_path}: {action} [shell_alias]")
        return (changed, notes)

    insert_at = section_end
    new_lines: list[str] = []
    for name, cmd in to_add:
        new_lines.append(f"{toml_key(name)} = {toml_string(cmd)}\n")
    lines[insert_at:insert_at] = new_lines
    changed = True

    write_mise_lines(mise_path, lines, dry_run=dry_run)
    action = "would add" if dry_run else "added"
    return (changed, notes + [f"{mise_path}: {action} {len(to_add)} alias(es)"])


def delete_envrc(envrc_path: Path, *, dry_run: bool) -> str:
    if dry_run:
        return f"{envrc_path}: would delete"
    envrc_path.unlink()
    return f"{envrc_path}: deleted"


def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(
        description="Migrate .envrc environment exports and aliases into mise.toml."
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
        help="Overwrite existing [env] and [shell_alias] keys in mise.toml (default: keep existing).",
    )
    p.add_argument(
        "--dry-run",
        action="store_true",
        help="Print what would change without writing files.",
    )
    p.add_argument(
        "--delete-envrc",
        action="store_true",
        help="Delete each .envrc after writing its mise.toml. Files with unsupported lines are kept.",
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
    total_env_vars = 0
    total_aliases = 0
    total_paths = 0
    total_dotenv_files = 0
    total_poetry = 0
    total_uv = 0
    touched = 0
    deleted = 0

    for envrc_path in envrc_paths:
        total_envrc += 1
        parsed = parse_envrc(envrc_path)

        total_env_vars += len(parsed.env)
        total_aliases += len(parsed.aliases)
        total_paths += len(parsed.paths)
        total_dotenv_files += len(parsed.dotenv_files)
        total_poetry += int(parsed.poetry)
        total_uv += int(parsed.uv)
        mise_path = envrc_path.parent / MISE_FILENAME

        settings_changed = False
        settings_notes: list[str] = []
        if any(SHELL_VAR_RE.search(value) for value in parsed.env.values()):
            settings_changed, settings_notes = upsert_settings_section(
                mise_path,
                {"env_shell_expand": True},
                overwrite=args.overwrite,
                dry_run=args.dry_run,
            )

        env_changed, env_notes = upsert_env_section(
            mise_path,
            parsed.env,
            parsed.paths,
            parsed.dotenv_files,
            parsed.poetry,
            parsed.uv,
            overwrite=args.overwrite,
            dry_run=args.dry_run,
        )
        alias_changed = False
        alias_notes: list[str] = []
        if parsed.aliases:
            alias_changed, alias_notes = upsert_shell_alias_section(
                mise_path, parsed.aliases, overwrite=args.overwrite, dry_run=args.dry_run
            )

        for n in [*settings_notes, *env_notes, *alias_notes]:
            print(n)
        for warning in parsed.unsupported:
            print(f"warning: {warning}")

        changed = settings_changed or env_changed or alias_changed
        if changed:
            touched += 1

        if args.delete_envrc:
            if parsed.unsupported:
                print(f"{envrc_path}: kept because unsupported lines were found")
            elif changed or mise_path.exists():
                print(delete_envrc(envrc_path, dry_run=args.dry_run))
                deleted += 1

    print(
        f"Scanned {total_envrc} {ENVRC_FILENAME} file(s), found {total_env_vars} env var(s), "
        f"{total_paths} PATH_add entry(s), {total_dotenv_files} dotenv file(s), "
        f"{total_poetry} poetry layout(s), {total_uv} uv layout(s), {total_aliases} alias(es), "
        f"touched {touched} {MISE_FILENAME} file(s), deleted {deleted} {ENVRC_FILENAME} file(s)."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
