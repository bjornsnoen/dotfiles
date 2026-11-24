# macOS installation

`install.conf.yaml` owns the shared links and tool/plugin setup once, alongside
the existing Linux package sections. Harmless Linux links are also created on
Mac; conditions protect the Mac shell override and exclude Linux-only setup
commands. `install.macos.conf.yaml` contains only Mac packages, destinations
and shell overrides, following the repository's auxiliary-profile pattern.

Both files are standalone Dotbot configurations. The existing `install` launcher
and Dotbot are unchanged; there is no preprocessing or cross-file YAML state.
Links stay top-level so `--only link` still works for either profile.

Install Apple's Command Line Tools, Homebrew and Python 3 yourself, and
initialize this repository's submodules. Then, from zsh in the repository:

```sh
eval "$(brew shellenv)"
./install -x -c install.macos.conf.yaml --plugin-dir modules/dotbot-brew &&
  ./install -x
```

Run the Mac profile first so packages and shell overrides are available to the
shared setup. The shared recipe retains its existing broken-symlink cleanup.
Regular-file conflicts stop installation rather than being force-overwritten;
existing symlinks can be relinked. Linux still uses the original `./install`
invocation and does not load the Homebrew plugin.

Shared zsh configuration is reused through its existing `.zshrc.local` hook.
The Mac-only `.zshenv` adds Homebrew discovery without putting its Python ahead
of an inherited virtual environment. Modern Bash and GNU readlink are linked
into `~/.local/bin` for the existing scripts. Existing custom certificate-bundle
variables are preserved; otherwise Homebrew's generated CA bundle is used.
Merge the Mac hook manually if you already have a regular `~/.zshrc.local`.

After IT changes trusted System Keychain CAs, run
`brew postinstall ca-certificates` yourself to refresh that bundle. Login
Keychain-only certificates are not included.

The shared Git config retains your personal identity. OpenCode's shared config
uses `HOME` for local paths. Its external shell-interpolation plugin and local
Ollama provider module still need to exist at the configured locations on each
machine. Debugger binaries and other external projects referenced by shared
configs also need to be installed separately.

The `macOS install` job in `.github/workflows/build_and_test.yaml` runs both
profiles on `macos-latest` with a temporary home directory. It checks installation,
not whether installed GUI applications launch. Its first run is still pending.
