# Security & Trust Requirements Quality Checklist: Autosign for Connected Sites

**Purpose**: Validate completeness, clarity, and testability of security- and trust-related requirements (not implementation behavior).

**Created**: 2026-04-09

**Feature**: [spec.md](../spec.md)

**Depth**: Standard (PR-reviewer level) · **Audience**: Developer implementing the feature + reviewer · **Focus**: Security & trust, silent/drop behavior, threshold rationale, auth failure paths, FR-011 vs explicit decline, toggle/auth-flow edge cases

---

## Requirement completeness

- [ ] CHK001 - Is a requirements-level trust model documented (who is trusted, for what actions, and under which session/identity binding), beyond stating that a checkbox exists? [Completeness, Gap]
- [ ] CHK002 - Are requirements explicit that only sign requests from an identity matching an active approved session may proceed to autosign or normal notification flows, and that others are out of band? [Completeness, Spec §FR-011]
- [ ] CHK003 - Is the need to add an origin/session guard when absent from the codebase stated as mandatory in requirements rather than optional? [Completeness, Spec §FR-011]
- [ ] CHK004 - Are internal diagnostic requirements for security-relevant events (silent ignore, auth drop, pricing fallthrough) listed without leaving categories undefined? [Completeness, Spec §FR-012]

## Requirement clarity

- [ ] CHK005 - Are “silent ignore” outcomes for unknown or non-matching origin/domain specified with unambiguous client-observable semantics (no notification, no user-visible surface) distinct from server-protocol semantics? [Clarity, Spec §FR-011]
- [ ] CHK006 - Does FR-004 state unambiguously whether any `To_SignerResponse` is sent when the user cancels unlock or authentication fails on the autosign path, versus omitting a response entirely? [Ambiguity, Spec §FR-004]
- [ ] CHK007 - Are “no response sent” for FR-011 and “drop” on auth failure in FR-004 written so they cannot be read as requiring an explicit decline response? [Clarity, Consistency, Spec §FR-011, Spec §FR-004]
- [ ] CHK008 - Is the “session active at processing start = authorized; disappearance during processing is a race” rule expressed as a single, implementable authorization invariant? [Clarity, Spec §FR-011]
- [ ] CHK009 - Is the 100 USDT limit scoped in requirements with explicit per-component semantics, currency/notional definition (USDT vs USD proxy), and iteration boundary (hardcoded, future configurability out of scope)? [Clarity, Spec §FR-004, Spec §FR-004b, Assumptions]

## Scenario & edge-case coverage

- [ ] CHK010 - Are authentication failure sub-scenarios (e.g., explicit cancel vs failed biometric vs other failure modes) either enumerated with identical required handling or justified as intentionally grouped under one phrase? [Coverage, Spec §FR-004]
- [ ] CHK011 - Are requirements defined for autosign preference changes while a sign request is already in an in-flight authentication/unlock flow, or is only the handler-entry read of preference specified? [Gap, Edge Case, Spec §FR-010]
- [ ] CHK012 - Are cross-site isolation requirements (per-site keying, no interaction between concurrent sites) stated with identity keys explicit enough to derive acceptance scenarios? [Coverage, Edge Cases, Spec §FR-003, Spec §FR-011]

## Consistency & measurability

- [ ] CHK013 - Are silent-drop and silent-ignore requirements consistent with “no normal notification” and “no autosign-specific UI” constraints across FR-004, FR-005, FR-012, and edge-case notes? [Consistency, Spec §FR-004, Spec §FR-005, Spec §FR-012]
- [ ] CHK014 - Can “emit `logger.w`” for FR-012 categories be objectively assessed as satisfied without defining expected log identifiers, fields, or correlation keys? [Measurability, Ambiguity, Spec §FR-012]
- [ ] CHK015 - Does the specification address whether silently ignored or dropped requests imply any normative server-side contract, or only client-side silence? [Gap, Spec §FR-011, Spec §FR-004]

## Notes

- Items reference [Spec §FR-XXX] or [Gap]/[Ambiguity] per Speckit checklist rules; they evaluate requirements text, not code.
