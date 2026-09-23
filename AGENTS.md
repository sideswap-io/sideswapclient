@docs/TESTING.md

When committing via the Bash tool, never use PowerShell here-string syntax (@'...'@). Use POSIX-compatible heredocs or -m flags so commit subjects aren't mangled with stray '@ ' prefixes.
For mechanical pipelines (graphify update, dep bumps, commit/push), execute directly. Do not enter plan mode first.
Verify every subagent, review and adversarial finding against the source before you trust it. If a background review stalls or dies silently, detect it and re-invoke it; partial output is not a result.
Do not create new branches or assume branch-creation git policy unless explicitly requested; confirm the target branch (often main/master) before opening PRs.
When a skill asks you a question, surface your recommendation beside it.
Before deleting worktree directories on Windows, expect file locks from rust-analyzer/Gradle/Kotlin daemons; note manual cleanup rather than killing the user's editor without confirmation.

## Agent skills

### Issue tracker

Issues are tracked in this repo's GitHub Issues via the `gh` CLI. External PRs are not a triage surface. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` + `docs/adr/` at the repo root. See `docs/agents/domain.md`.

### Marionette

`marionette_mcp` drives the debug build through the Marionette binding registered in `lib/start_app.dart`. See `docs/agents/marionette.md`.
