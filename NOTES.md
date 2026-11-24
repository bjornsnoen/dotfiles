# Development setup

## macOS corporate certificates

The auxiliary Mac profile in `install.macos.conf.yaml` installs Homebrew's `ca-certificates` and runs `brew postinstall ca-certificates`. Homebrew builds a PEM bundle containing trusted System Keychain CAs alongside Mozilla roots. The Mac-only files in `platform/macos/` select that bundle unless a custom certificate-bundle variable is already set. Shared links and setup remain in `install.conf.yaml`; Linux shell files are unchanged by Mac support. See `platform/macos/README.md` for the two-step installation.

After IT installs or rotates a corporate CA in the System Keychain, refresh the bundle:

```sh
brew postinstall ca-certificates
```

Open a new shell after the initial install. This is a generated bundle, not live Keychain access; certificates installed only in the login Keychain are not included. Applications that ignore these environment variables need their own configuration. TLS verification stays enabled.

## Yarn

`config/yarn/yarnrc.yml` sets modern Yarn (2+) defaults: Plug'n'Play and dependency archives on local disk. Project configuration can override these defaults. Yarn Classic (1.x) ignores this file; its existing local cache and version are unchanged. Packages that need unpacking or native builds can still write to the project's `.yarn/unplugged`.

## Java build tuning — deferred

Leave Maven and Gradle configuration unchanged until testing a representative Java project.

- Keep Maven's `~/.m2/repository` and Gradle's `~/.gradle` on local disk; these are already the defaults.
- Evaluate global Gradle build caching (`org.gradle.caching=true`). It reuses outputs but still writes them into the project's build directory.
- Test a global Gradle init script for relocating build output to separate local directories per project. Check plugin compatibility and project-cache placement too; no per-repository bind mounts.
- Consider Maven Daemon (`mvnd`) for repeated builds. It does not relocate `target/`, and Maven has no general build-directory override in user `settings.xml`.
- Benchmark installation, compilation, tests, incremental builds, and cleanup before choosing further changes.
