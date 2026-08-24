---
name: fix-integration
description: Provider fix-and-test pipeline (briefing → implementation → writer → propagate). Triggers: "start fix for X", "implement fix X", "run tests for X".
---

# Fix Integration Skill

Trigger: user says "start fix for X" / "implement fix X" / "run tests for X".

---

## Step 1 — Briefing (header only)

Read `tools/prompts/fixes/<provider_stem>_fix.md` up to and including the `---` separator only.
Display:

```
Fix: <title>
Status: <status> | Complexity: <complexity> | Breaking changes: <breaking_changes>
Reason: <reason>
Codegen needed: <codegen>
Unlocks: <N from INDEX.md Unlocks column, or — if not listed>
```

Ask:

> **Who implements?**
> **A** — Claude (reads full fix, implements lib/, creates PR)
> **C** — You (read fix yourself, implement, signal when done)
>
> Or: **S** — show full fix file

---

## Step 2A — Claude implements

1. Read full `_fix.md`
2. Create branch: `fix/<provider_stem>`
3. Implement lib/ changes exactly as specified in `## Proposed Fix`
4. Run `flutter analyze` on changed files — fix any errors
5. Commit: `Fix: <provider_stem> — <one-line reason>`
6. Create PR — body: what changed, breaking changes Y/N, codegen needed Y/N
7. Tell user: "PR ready — after merge say 'run tests for <provider_stem>'"

---

## Step 2C — Human implements

Tell user:
> "Read `tools/prompts/fixes/<provider_stem>_fix.md`.
> When done and committed, say: 'run tests for <provider_stem>'"

Wait for signal.

---

## Step 3 — Run writer (both paths)

Triggered by: "run tests for X" / "merge done" / similar signal.

1. Verify lib/ change exists: `git diff HEAD~1 -- lib/` — confirm relevant file changed
2. Mark assignment in INDEX.md assignments section as `in-progress`
3. Spawn writer agent following **Section 4 of `tools/prompts/plans/provider-test-plan.md`**
   Pass: provider stem, path to `_fix.md`, path to `_fail_fix.md` if exists
4. After writer returns:
   - `done` → delete `_fail_fix.md` if exists; mark assignment `done`; run `python tools/scripts/index_fixes.py`; go to Step 4
   - `partial/blocked` → delete `_fail_fix.md` if exists; update `**Status:**` and `**Reason:**` in `_fix.md` to reflect only remaining blockers (remove resolved ones); mark assignment `partial`; run `python tools/scripts/index_fixes.py`
   - `fail` → writer wrote `_fail_fix.md`; mark assignment `fail`; ask: retry A / retry C / skip?

---

## Step 4 — Propagate pattern (after `done` only)

Extract the core fix pattern from `## Proposed Fix` section (one sentence: what was changed and how).

Scan all other `_fix.md` files in `tools/prompts/fixes/` — read headers only (stop at `---`).
For each file whose `**Reason:**` describes the same root cause (same blocker type, e.g. logger injection, rootBundle injection):

1. Read the full file
2. Append to `## Proposed Fix` section:

```
> **Pattern established:** See `<solved_provider_stem>_fix.md` — <one-line description of the solution>.
```

3. Update `**Status:**` in header to `open` if it was `blocked` and this pattern directly resolves it.

Report to user: "Updated N related fix files with pattern reference."

---

## Fallback

**2A fails:** "Cannot safely implement this change. Switch to Option C?"

**Writer fails after retry:** "Writer did not reach 100% after 2 attempts. Options: retry A / retry C / skip"

---

## Token rules

- Step 1: read header only (stop at `---`)
- Step 2A: read full file only when implementing
- Writer instructions live in `provider-test-plan.md` Section 4 — do not duplicate here
