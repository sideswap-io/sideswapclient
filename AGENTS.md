@docs/TESTING.md

When committing via the Bash tool, never use PowerShell here-string syntax (@'...'@). Use POSIX-compatible heredocs or -m flags so commit subjects aren't mangled with stray '@ ' prefixes.
For mechanical pipelines (graphify update, dep bumps, commit/push) execute directly — do NOT enter plan mode first.
Before trusting a background Codex/adversarial review claim, re-verify findings against source; if a background review process stalls or dies silently, detect it and re-invoke rather than trusting partial output.
Do not create new branches or assume branch-creation git policy unless explicitly requested; confirm the target branch (often main/master) before opening PRs.
When invoking the work-on / grill-with-docs skills, surface recommendations alongside questions and verify all subagent/review findings against source before trusting them.
Before deleting worktree directories on Windows, expect file locks from rust-analyzer/Gradle/Kotlin daemons; note manual cleanup rather than killing the user's editor without confirmation.

## Agent skills

### Issue tracker

Issues are tracked in this repo's GitHub Issues via the `gh` CLI. External PRs are not a triage surface. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` + `docs/adr/` at the repo root. See `docs/agents/domain.md`.
