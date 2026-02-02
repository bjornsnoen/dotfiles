# Repository Guidelines

## ⚠️ CRITICAL: Installation Command Restrictions

**AGENTS MUST NEVER EXECUTE `./install` OR ANY DOTBOT INSTALL COMMANDS DIRECTLY!**

- The `./install` command runs lengthy operations (package installations, plugin syncs, shell initialization) that WILL timeout in agent execution environments
- These commands can take several minutes and may require user interaction or system-level permissions
- **ONLY the human user should run `./install` commands manually in their terminal**
- Agents should inform the user to run `./install` themselves after making configuration changes, but NEVER execute it
- If symlinks need to be created for testing/verification purposes, create them manually with explicit `ln -sf` commands instead

## Project Structure & Module Organization
- `install` drives Dotbot with `install.conf.yaml` (default), plus variants like `install.wayland.conf.yaml` and `install.ubuntu.conf.yaml` for platform-specific links and packages.
- `dotbot/` is a submodule; Dotbot plugins live in `dotbot-*` directories. Keep new automation in the matching config file rather than inlined shell.
- Desktop and shell configs sit under `hypr/`, `waybar/`, `awesome/`, `kitty/`, `tmux.conf`, `zshrc`, `aliases`, and `direnv/`; editor config is in `nvim/` with plugin pins in `nvim/lazy-lock.json`.
- Apps and helpers include `gnome-setup.py`, `polybar/*.sh`, `wayland/*` overrides, and `fonts/` for local fonts. Place new app configs under `~/.config`-style mirrors to match the existing linking pattern.

## Build, Test, and Development Commands
- `./install` — run the default Dotbot playbook to sync links, packages, and plugins.
- `./install -c install.wayland.conf.yaml` (or `install.ubuntu.conf.yaml`) — apply a different profile; keep commands idempotent because installs may be rerun.
- `nvim --headless '+Lazy! sync' +qa` — refresh Neovim plugins and lockfile after changing `nvim/lua/plugins/*` or `nvim/lazy-lock.json`.
- `python gnome-setup.py` — apply GNOME keybindings; re-run after edits to confirm settings land without errors.

## Coding Style & Naming Conventions
- YAML: two-space indent; group related tasks (links, shell, git) together and keep platform-specific steps in the matching `install.*.conf.yaml`.
- Shell: bash with `set -e` when scripting; quote expansions, prefer long-form flags, and keep one action per line for readability.
- Python: format with Black (line length 110 from `pyproject.toml`); favor f-strings and keep helpers small (see `gsettings` in `gnome-setup.py`).
- Lua (Neovim/Awesome): four-space indent, single quotes, modules return tables; keep plugin declarations consistent with existing structure and update `nvim/lazy-lock.json` when versions change.

## Testing Guidelines
- Run the relevant install profile in a disposable session (`./install` or the `-c` variant) to ensure links resolve and package managers are available.
- After Neovim changes, run the headless sync above and open `:checkhealth` in a fresh session to verify LSPs and plugins load.
- For shell or Python edits, execute the script directly to confirm it exits cleanly; avoid introducing commands that assume unavailable system packages.
- Manually reload affected apps (kitty, tmux, Waybar/Hyprland/Awesome) to confirm visual changes and keybindings work.

## Commit & Pull Request Guidelines
- Use short, imperative subjects (e.g., `Add atuin config`, `Fix c# lsp`) consistent with existing history; avoid noise in the body unless needed.
- Note which profile you tested (default/Wayland/Ubuntu) and any manual steps required post-merge (e.g., restarting a service).
- Commit lockfile updates alongside plugin/config changes (especially `nvim/lazy-lock.json`).
- PRs should summarize the intent, highlight user-facing changes (screenshots for bar/window manager tweaks), and mention any new dependencies or secrets avoided.
