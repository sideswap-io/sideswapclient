# Pre-Implementation Review — Round 3

**Feature**: Autosign for Connected Sites
**Artifacts reviewed**: spec.md, plan.md, tasks.md, checklists/requirements.md, checklists/security.md, checklists/implementation.md, .specify/memory/constitution.md
**Review model**: claude-sonnet-4-6
**Generating model**: claude-sonnet-4-6 (prior sessions)

## Summary

| Dimension | Verdict | Issues |
|-----------|---------|--------|
| Spec-Plan Alignment | PASS | 0 |
| Plan-Tasks Completeness | PASS | 0 |
| Dependency Ordering | PASS | 0 |
| Parallelization Correctness | PASS | 0 |
| Feasibility & Risk | PASS | 0 |
| Constitution & Standards Compliance | PASS | Constitution is placeholder — effective gates verified from spec/plan |
| Implementation Readiness | PASS | 0 |

**Overall**: READY

## Findings

### Critical (FAIL — must fix before implementing)

None.

### Warnings (WARN — recommend fixing, can proceed)

None. All Round 2 WARNs are resolved:

- **Test specificity**: All failure-path tests now assert pinned `AutosignFallthrough` enum values — `.missingPrice`, `.unknownAsset`, `.zeroQuantity`, `.overLimit`, `.emptyPayload` — rather than bare `isNotNull`. Verified in `test/providers/autosign_provider_test.dart`.
- **Stale dartdoc**: `isSignRequestWithinAutosignUsdLimit` dartdoc now correctly describes `null` (eligible) / `AutosignFallthrough` (ineligible) return semantics and shows `assetUtilsProvider.assets` in the example call.

### Round 2 FAIL — verified resolved

**tasks.md alignment with AutosignFallthrough semantics**: Fully fixed in commit `dd5d4125`.

- TASK-003: description now uses `null` (eligible) / `AutosignFallthrough` (ineligible) semantics; all `true`/`false` return language removed.
- TASK-003 acceptance criteria: `emptyPayload`, null-eligible language correct; no `→ false/true` test bullets remain.
- TASK-004 step 4: correctly uses `non-null → logger.w(reason.description)` then `addNotification`; no staleness/timestamp language.
- TASK-007: coverage target lists `AutosignFallthrough` enum; manual matrix scenario 3 references `.missingPrice`, not "older than 60s".
- Summary table row for TASK-003: now reads `USD notional threshold helper (AutosignFallthrough? return)`; "price snapshot time" removed.
- TASK-002 annotation: now `@riverpod` (auto-dispose, codegen); stale `@Riverpod(keepAlive: true)` removed.

### Observations (informational)

1. **Constitution is a placeholder**: `.specify/memory/constitution.md` contains only template markers — no project-specific principles. Not a blocker.

2. **plan.md stale "60 s staleness" paragraph**: `plan.md` still contains superseded guidance about treating price snapshots as stale after 60 s. Informational only — tasks.md is the implementer authority. Optional cleanup.

3. **Security checklist items unchecked**: All `checklists/security.md` items are `[ ]` — these are pre-implementation requirement-quality questions, all answered by spec.md FR-004/007/010/011/012. Not a gap.

## Recommended Actions

- [ ] Optional: Remove stale "60 s staleness" paragraph from `plan.md` so it doesn't mislead future readers. Not required before implementation.
- [ ] Optional: Fill in or remove the constitution template.
- [ ] Proceed to Phase 8: Implement.
