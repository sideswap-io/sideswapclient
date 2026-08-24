# Orchestrator Report — Autosign Critique

Date: 2026-04-09 22:24:56  
Feature: `001-autosign-notifications`  
Critique source: `critiques/critique-20260409-222206.md`

## Status

- Critique completed (product + engineering lenses).
- Existing artifacts kept read-only (`spec.md`, `plan.md` unchanged).
- Decision: **⚠️ PROCEED WITH UPDATES**.

## Blocking Findings (Must-Address Before Task Breakdown)

1. **Threshold governance gap (P1)**  
   `FR-004` uses hardcoded 100 USDT limit without explicit rationale/review gate.

2. **Silent behaviors need observability (P4 / X1)**  
   `FR-011` unknown-origin silent ignore and auth-cancel drop are correct UX-wise but currently under-instrumented operationally.

3. **Async receive-loop risk (E1)**  
   Making `_handleSignerRequest` async can affect message sequencing/backpressure semantics.

4. **Session race ambiguity (E2)**  
   Borderline-valid sign request can be dropped when session disappears around processing boundary; policy needs explicit wording.

5. **Pricing freshness ambiguity (E4)**  
   “Current market-rate source at request time” is underspecified without stale-price bound.

## Required Spec/Plan Updates

### `spec.md`

1. **FR-004**: add stale-price rule  
   If price snapshot age exceeds freshness bound (e.g. 60s), treat conversion as unavailable and follow autosign-off fallthrough path.

2. **FR-011**: keep silent UX, require internal diagnostics  
   Add requirement that unknown-origin silent ignore emits internal diagnostic signal/metric (no user notification).

3. **Clarification/edge policy**: session boundary behavior  
   Add explicit statement: if session is not active at processing start (or recheck point), request is intentionally ignored as stale/unauthorized.

4. **Success criteria**: governance + observability  
   Add metric for threshold review checkpoint (e.g. within 30 days) and metric for unknown-origin event observability readiness.

### `plan.md`

1. **Async sequencing contract**  
   Document `_recvMsg` serialization intent and expected tradeoff; add revalidation step before final accept/reject send after awaits.

2. **Operational instrumentation**  
   Add telemetry/log counters for:
   - unknown-origin silent ignore
   - auth-cancel/auth-failed autosign drops
   - stale/missing price fallthrough

3. **Testing boundary clarity**  
   Pin exact “100% coverage” scope to new/modified provider/config files; add mandatory manual matrix for wallet path edge cases.

## Non-Blocking Recommendations

- Define single canonical domain matcher rule (normalization vs exact byte match).
- Add kill-switch note for autosign path rollback safety.
- Move shared `SwaptionDomainItem` from desktop path to neutral shared location to reduce cross-platform coupling risk.

## Orchestrator Action

- Apply must-address updates to `spec.md` and `plan.md`.
- Re-run critique check after edits.
- Then proceed to task breakdown.

