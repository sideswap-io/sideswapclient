---
name: fix-provider-user
description: Riverpod provider test-coverage fix pipeline (writer/tester/reviewer to 100%). Triggers: "fix coverage", "fix-provider", coverage_progress.json queue.
---

# Fix Provider (User-Driven)

User picks providers, orchestrator runs the pipeline. Differs from the automated test plan — here lib/ changes are authorized and user confirms each step.

Full pipeline diagram: `references/pipeline.md`

## Invocation

- `/fix-provider-user` — auto-select easiest provider from work queue
- `/fix-provider-user <provider.dart>` — fix specific provider

## Auto-Selection Priority

Pick from `coverage_progress.json` work queue (status=needs-fix), ordered by:
1. Highest coverage% first (closest to 100%)
2. Lowest retry count
3. test-only > lib-change-required (check INDEX.md)

## Pipeline Overview

```
Select → Gather → Present (WAIT) → Writer (mechanical→structural) → Test
├─ PASS → Review R1 → Simplify → Fix if needed → Re-test → Review R2 → Finalize
├─ FAIL → Diagnosis → Fix → Re-test → Review R1 → Simplify → Fix → Re-test → Review R2 → Finalize
└─ 2× FAIL → escalate to user (manual fix / different strategy / retry Writer / abort)
```

**Counters:**
- **Review round** = number of times step 7 (Review) has executed for this provider. Max 2.
- **Fail counter** = consecutive FAILs from any test step (5 or 10). Resets on any PASS. At 2 → escalate.

## Token Optimization: Scripts vs Subagents

| Step | Script | Returns |
|------|--------|---------|
| Gather | `${CLAUDE_SKILL_DIR}/scripts/gather_provider_data.py` | Metadata: uncovered lines, coverage%, has_codegen, fix proposal summary |
| Test | `tools/scripts/run_tester.py --integrity` | PASS/FAIL, coverage%, uncovered_lines |
| Validate | `${CLAUDE_SKILL_DIR}/scripts/validate_fix.py` | analyze_errors, warnings, integrity_violations, all_clear |

Subagents (Writer, Reviewer, Fix) read lib/ and test/ files in their own context. Orchestrator never loads full file contents.

## lib/ Change Checkpoint

Whenever a fix requires lib/ changes:
1. Show exact changes to user
2. **WAIT for user decision:**
   - **OK** — proceed
   - **different approach** — user's alternative
   - **retry** — return to Writer (max 1×, then must choose OK or alternative)

## Step Details

### 0. Coverage Baseline (orchestrator)

Check lcov freshness before anything else:
```bash
stat coverage/lcov.info 2>/dev/null
```
If missing or older than 1 hour → run:
```bash
python tools/scripts/coverage_baseline.py
```
Creates/updates `coverage_progress.json`. If the file doesn't exist, `coverage_baseline.py` creates it on first run.

### 1. Select provider

If no argument: run `python tools/scripts/coverage_baseline.py --stats-only`, pick easiest per Auto-Selection Priority.
If argument: use specified provider.

**Early exit:** If all providers in `coverage_progress.json` have status=done and full project coverage is 100% → report "All providers at 100% coverage" and stop. Do not proceed to step 2.

### 2. Gather data (orchestrator Bash)
```bash
python ${CLAUDE_SKILL_DIR}/scripts/gather_provider_data.py <project_root> <provider>.dart
```
Reads coverage from existing lcov. **Does not run tests.** Returns metadata JSON (uncovered lines with code snippets, coverage%, has_codegen, fix proposal summary). Does not return full file contents.

### 2a. Deep dive (orchestrator, optional)

After gather, ask user: **"Deep dive? (docs-mcp, existing tests, fix proposal → test-only 100% feasibility)"**

If user approves:
1. Search docs-mcp-server for testing patterns related to the provider's static deps (e.g., rootBundle, Navigator, WebSocket)
2. Search existing test files for similar mocking patterns (Grep for key classes/fakes)
3. Read fix proposal if exists (`fix_proposal_path` from gather)
4. Compare approaches: test-only vs lib-change, feasibility of each
5. Present findings summary with recommendation
6. **WAIT for user decision** on approach before proceeding to step 3

If user declines → proceed directly to step 3.

### 3. Present options

Show user (from gather metadata):
- Uncovered lines with code snippets
- Available approaches (test-only, lib change options)
- Complexity estimate
- If dead code / untestable lines: ask user how to approach
- **WAIT for user decision before proceeding**

### 4. Writer (split by complexity)

**Quick mode:** if ≤3 uncovered lines → skip split, send all to one sonnet agent. Saves subagent overhead.

**Normal mode:** Orchestrator classifies each uncovered area:
- **[mechanical]** — simple setState, toString, single-branch logic, no provider deps beyond the notifier itself
- **[structural]** — multiple provider watches, Option.match chains, complex setup, ref.listen patterns

**4a. Mechanical writes (haiku agent)** — run first.
**4b. Structural writes (sonnet agent)** — run after 4a on already-updated file.

Skip the other step if all items are one type.

**No test file yet** (`test_exists: false` from gather): Writer creates the file from scratch — include full boilerplate (imports, main group, logger setup from `references/writer-patterns.md`).

**All agents:**
- **Task-driven execution:** Create ALL tasks first (one per test group). Work task-by-task: read target lines → edit → re-read to confirm → mark completed.
- Read `references/docs-mcp.md` and `references/writer-patterns.md` (subagent reads these itself)
- **Invoke the `provider-test-standards` skill via the Skill tool before starting** — for naming, structure, what to test/delete
- No self-check loop — Tester handles testing
- Exact lib/ changes (if authorized by user)

**Codegen providers** (when `has_codegen: true` from gather):
- Run `dart run build_runner build` before writing tests — generated files must be current
- After any lib/ changes to freezed/g.dart models: re-run `build_runner` before test
- Ignore uncovered lines in `.freezed.dart` / `.g.dart` — don't write tests for generated code

### 5. Test + Integrity (orchestrator Bash)
```bash
python tools/scripts/run_tester.py <provider>.dart --integrity
```
Returns JSON with tests_passed, integrity_violations, coverage_pct, uncovered_lines.

### 6. Verdict routing

- **PASS** → Quality review (step 7)
- **FAIL** → Diagnosis (step 6a)

**Fail counter:** track consecutive FAILs from any test step (5 or 10). After 2× FAIL → **escalate to user**: show test output, ask for decision (manual fix / different strategy / retry Writer / abort). Reset counter on any PASS.

### 6a. Diagnosis (subagent code-reviewer, sonnet)

Diagnose root cause, provide actionable feedback with exact API calls and signatures. Use docs-mcp-server (see `references/docs-mcp.md`).

Present diagnosis to user as numbered bullets (root cause + proposed fix per failing test, with exact API calls). **WAIT for confirmation** before launching Fix.

If fix requires lib/ changes → lib/ Change Checkpoint.

After fix → Re-test → on PASS → Review (step 7) → Simplify (step 8).

### 7. Quality review (subagent code-reviewer, sonnet)

Review ALL changed files (lib/ provider + test). **Invoke the `provider-test-standards` skill via the Skill tool before starting** — for naming, structure, what to test/delete. Criteria for tests: duplicates, trivial tests, addTearDown, table-driven, naming, assertion quality. Criteria for lib/: code quality, unnecessary complexity, missing edge cases, dead code. Classify each issue as `[mechanical]` or `[structural]`.

**Exact API requirement:** When suggesting override changes, provide exact method name AND full signature. Search docs-mcp-server (see `references/docs-mcp.md`) before suggesting.

**Round-specific behavior:**
- **Round 1:** fresh review, no prior context.
- **Round 2:** pass changes-already-applied list (format below). Max 2 rounds total — after round 2, present remaining issues, user decides to fix or finalize.

**Changes-already-applied format** (passed to reviewer in round 2):
```
Changes already applied (do not re-report):
- L45: added addTearDown for container
- L92: assertion changed to hasLength(1)
```

Present results to user as numbered list with this format:

**Important (1-N):**
N. **[type]** `file.dart:line-range`. Description of the issue — one sentence with context.

**Suggestions (N+1-M):**
N+1. **[type]** `file.dart:line-range`. Description — one sentence.

After the list, add **Orchestrator recommendation** — for each issue state: fix / skip with brief reason.

- **No important issues** → Finalize
- **Important issues** → **WAIT for user decision** which to fix

### 8. Simplify (subagent code-simplifier, model inherited)

Run after Review on **both** PASS and FAIL→fix→retest paths — but **only once** (after review round 1). Round 2 skips Simplify and goes straight to Finalize or Fix.

Reviews changed files (lib/ provider + test) for reuse, quality, efficiency. Issues merged with review issues into a single combined list for the Fix step. Tag as `[mechanical]`/`[structural]`.

### 9. Fix issues (split by complexity)

Orchestrator splits user-selected issues:

**9a. Mechanical fixes (haiku agent)** — run first.
**9b. Structural fixes (sonnet agent)** — run after 9a.

Skip the other step if all issues are one type.

**Both agents:**
- **Task-driven execution:** same as Writer (step 4)
- Use docs-mcp-server (see `references/docs-mcp.md`)
- Watch for coverage regression when deleting tests

After fixing:
```bash
python ${CLAUDE_SKILL_DIR}/scripts/validate_fix.py <project_root> <provider>.dart
```

### 10. Re-test (orchestrator Bash)
```bash
python tools/scripts/run_tester.py <provider>.dart --integrity
```
- **PASS** → if round 1: Simplify (step 8) → Review round 2 (step 7). If round 2: Finalize.
- **FAIL** → fail counter check (step 6). If <2: diagnoza → fix → re-test. If >=2: escalate.

### Finalize
```bash
PYTHONIOENCODING=utf-8 python tools/scripts/update_memory.py <provider>.dart done --coverage 100
rm tools/prompts/fixes/<stem>_fix.md          # if exists
rm tools/prompts/fixes/<stem>_fail_fix.md     # if exists
```
Refresh sideswap docs in background:
```
mcp__docs-mcp-server__refresh_version(library: "sideswap")
```

### Report (orchestrator Bash)
```bash
PYTHONUTF8=1 python ${CLAUDE_SKILL_DIR}/scripts/format_report.py <provider>.dart <coverage_pct> \
  --fixed "L45 addTearDown" "L92 hasLength(1)" \
  --skipped "L60-80 table-driven refactor"
```
**WAIT for user** — do not auto-commit.

## Subagent Models

| Role | Model | Type | Max invocations |
|------|-------|------|-----------------|
| Writer mechanical | haiku | general-purpose | 1 |
| Writer structural | sonnet | general-purpose | 1 |
| Diagnosis | sonnet | superpowers:code-reviewer | 1 |
| Quality review | sonnet | superpowers:code-reviewer | 2 (round 1 + 2) |
| Simplify | inherited | code-simplifier | 1 |
| Fix mechanical | haiku | general-purpose | 2 (after R1 + R2) |
| Fix structural | sonnet | general-purpose | 2 (after R1 + R2) |

Scripts (orchestrator, no subagent):

| Script | Purpose |
|--------|---------|
| `${CLAUDE_SKILL_DIR}/scripts/gather_provider_data.py` | Metadata gathering |
| `tools/scripts/run_tester.py --integrity` | Test + coverage |
| `${CLAUDE_SKILL_DIR}/scripts/validate_fix.py` | Dart analyze + integrity |
| `${CLAUDE_SKILL_DIR}/scripts/format_report.py` | Final report formatting |
