# Local OpenCode plugins

These plugins target OpenCode **2.0.27**. Its published `@opencode/plugin`
contract uses `provider.transform`, `provider.models.set`, `agent.transform`,
`permission.hook('evaluate')`, and `tool.hook('execute.before')`. At migration
time, the main V2 plugins page described a different catalog API; the dedicated
migration guide and release-matched package declarations matched this release.

Each module exports a structural `{ id, setup }` definition. Imports from
`@opencode/plugin` are type-only, so these local plugins need no new runtime
dependencies (the existing V1 `@opencode-ai/plugin` package is not used).
External discovery/probes run before synchronous, replayable transforms.
The guard uses the intercepted session's directory, not the plugin load location.

The Ollama plugin retains the provider package configured in `opencode.json`.
The compaction plugin retains the existing cloud/local health-check policy;
it is not a retry handler for failed compaction requests.

Run regression tests with Node 22.18+:

```sh
node --test config/opencode/plugin/tests/plugins.test.mjs
```

The tests mock network requests and use forbidden-path strings only; they do not
create or read secret files. Typecheck against `@opencode/plugin@2.0.27` with
TypeScript's strict mode and Node typings when changing these contracts.

Dotbot links each plugin individually. Run `./install` yourself after deploying
these dotfiles on another machine; agents must not run it. Verify activation with
`opencode plugin list` after the watched files reload, restarting the service
manually if needed.
