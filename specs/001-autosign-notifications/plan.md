# Implementation Plan: Autosign for connected sites

**Branch**: `001-autosign-notifications` | **Date**: 2026-04-09 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `specs/001-autosign-notifications/spec.md`

## Summary

Add a per-domain **Autosign** checkbox for Liquid Connect sessions. When enabled, **sign** requests from that domain are auto-accepted **only if** FR-011 (active session + origin match), FR-004 (every value component priced via current `pricesUsd` and each ≤ 100 USD notional), and authentication succeed; **no** notification row, **no** desktop restore/show, **no** mobile menu popup for those accepts. Persist preferences in **`SideswapSettings`** / **SharedPreferences**; remove preference on **any** session end. **Connect** requests unchanged (always manual).

## Technical Context

**Language/Version**: Dart / Flutter (SDK per `pubspec.yaml`)  
**Primary Dependencies**: Riverpod codegen, freezed, shared_preferences, decimal, protobuf  

| Item | Value |
|------|--------|
| **Language** | Dart / Flutter |
| **State management** | Riverpod + `riverpod_annotation` / `build_runner` code generation; **all new providers** use `@Riverpod` + `.g.dart` |
| **Primary dependencies** | `freezed`, `shared_preferences`, `decimal`, existing protobuf (`From_SignerRequest`, `To_SignerResponse`) |
| **Storage** | `SharedPreferences` via `configurationProvider` / `SideswapSettings` (same pattern as other JSON-backed settings) |
| **Testing** | `flutter_test` + `mocktail`; **no tests** for `wallet.dart`; tests only for **new/modified** provider/config/helper files; **100% coverage** on those |
| **Target platform** | Desktop (Windows / Linux / macOS) + mobile (Android / iOS) |
| **Project type** | Single Flutter app (`lib/`, `test/`) |
| **Performance** | No hot-path requirements; sign requests are low frequency |
| **Constraints** | English comments only; short inline comments; no autosign-specific UI on fall-through (FR-004) |
| **Scale** | Map size bounded by concurrent session count |

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

`.specify/memory/constitution.md` is still a **placeholder template** (no project-specific principles). **Effective gates** for this feature:

- Follow functional requirements in `spec.md` (FR-001–FR-011, SC-001–SC-005).
- Respect stack rules from task brief: codegen Riverpod, no `wallet.dart` tests, provider tests only where implementation lives.

**Post-design:** Research closed all technical unknowns (`research.md`); no constitution violations identified.

## Architecture decisions (locked)

1. **`lib/providers/autosign_provider.dart`** — `@Riverpod(keepAlive: true)` notifier exposing logical API: `isAutosign(String domain)`, `setAutosign(String domain, bool)`, `removeAutosign(String domain)`; state backed by **`configurationProvider`** field **`Map<String, bool> autosignDomains`** on **`SideswapSettings`**, JSON in SharedPreferences.
2. **Auto-accept location:** `SideswapWallet._handleSignerRequest` (made `async`) — after FR-011 guard and reading **current** autosign flag at handler entry, if autosign path applies: `await isAuthenticated()`; on success send `To_SignerResponse(accept: true)`; **do not** call `notificationsProvider.addNotification` or desktop/mobile notification side effects; on auth cancel/fail: **drop** (no response, no notification). `_recvMsg` calls this with `await`; messages from server are delivered serially by the isolate so sequencing is preserved — the only interleaving risk is the PIN UI duration, which is acceptable (user interaction pauses that message slot only).
3. **USD / USDT cap:** Per-component notional using **`portfolioPricesProvider`** (`pricesUsd`); human-quantity from smallest-unit ints using **asset precision** (same semantics as sign UI). Threshold **100** per component (hardcoded). See `research.md`.
4. **UI:** **`Checkbox`** on **`SwaptionDomainItem`** in `lib/desktop/widgets/d_swaption_connections_button.dart` (shared by desktop overlay and `swaption_sessions_dialog.dart`).
5. **Disconnect cleanup:** `_handleSessionRemoved` — lookup **`domain`** by **`sessionId`** in `swaptionSessionProvider` **before** `removeSessions`, then **`removeAutosign(domain)`**.

## Project Structure

### Documentation (this feature)

```text
specs/001-autosign-notifications/
├── plan.md           # This file
├── research.md       # Phase 0
├── data-model.md     # Phase 1
├── quickstart.md     # Phase 1
└── tasks.md          # Phase 2 (speckit.tasks — not produced here)
```

**Contracts:** Skipped — purely internal Flutter/protobuf behavior; requirements captured in spec + `data-model.md`.

### Source code (repository root)

```text
lib/
├── providers/
│   ├── autosign_provider.dart          # NEW (+ autosign_provider.g.dart)
│   ├── config_provider.dart            # MODIFY: SideswapSettings + prefs I/O
│   ├── wallet.dart                     # MODIFY: _handleSignerRequest, _handleSessionRemoved
│   ├── swaption_session_providers.dart # READ-ONLY reference for domain/sessionId
│   ├── notifications_provider.dart      # READ-ONLY (avoid split unless refactor needed)
│   ├── pin_protection_provider.dart    # READ-ONLY (via isAuthenticated)
│   └── balances_provider.dart / portfolio_prices_providers.dart / wallet_assets_providers.dart
│       # READ-ONLY for pricing / precision patterns
├── desktop/widgets/
│   └── d_swaption_connections_button.dart  # MODIFY: SwaptionDomainItem checkbox
└── screens/home/widgets/
    └── swaption_sessions_dialog.dart       # Uses SwaptionDomainItem — no structural change if checkbox is inside item

test/providers/
├── autosign_provider_test.dart       # NEW
└── config_provider_test.dart         # MODIFY for autosignDomains persistence
```

**Structure decision:** Single Flutter tree; feature touches **providers**, **one shared widget file**, and **wallet** orchestration only.

## Component list

| Component | Responsibility |
|-----------|----------------|
| **`SideswapSettings.autosignDomains`** | Canonical persisted map domain → bool |
| **`Autosign` notifier (generated)** | CRUD + read helpers for UI and wallet |
| **`signRequestAutosignUsd*` helper** | Given `From_SignerRequest_Sign` + `Ref`, return whether **all** components convert and ≤ 100; **null/false** = fall through (testable with `ProviderContainer` overrides) |
| **`SideswapWallet._handleSignerRequest`** | Branch connect vs sign; FR-011; autosign + threshold + auth; send protobuf responses |
| **`SideswapWallet._handleSessionRemoved`** | Domain cleanup + existing session removal |
| **`SwaptionDomainItem`** | Checkbox + `setAutosign` |
| **Translations** | Label for autosign (e.g. `.tr()`) |

## Implementation phases

### Phase 0 — Research ✅

Output: `research.md` (USDT/USD pricing, `isAuthenticated`, FR-011 gap, keepAlive, async handler, component list).

### Phase 1 — Design ✅

Output: `data-model.md`, `quickstart.md`, this `plan.md`. Agent context script executed (`update-agent-context.ps1 -AgentType claude`).

### Phase 2 — Implementation (next; not in this command)

Suggested order:

1. Config field + prefs + `build_runner` + `config_provider_test` updates.
2. `autosign_provider` + tests (100%).
3. USD threshold helper + tests (inject `Ref` or test via container with overrides).
4. Wallet `_handleSignerRequest` / `_handleSessionRemoved` (manual / integration verification; **no** unit tests per brief).
5. UI checkbox + translation.
6. Full `flutter test` / analyzer; manual smoke on desktop + mobile sessions list.

## Key implementation notes

- **FR-011:** Implement **before** autosign and **before** `addNotification` for **sign**. On failure: **silent ignore** — no `To_SignerResponse` sent, no notification shown. Unknown origins are discarded entirely. Emit `logger.w(...)` on ignore (FR-012).
- **FR-012 (diagnostics):** Add `logger.w(...)` for: unknown-origin ignore, auth-cancel/fail drop, stale-price fallthrough. Use existing `logger` instance (same pattern as rest of wallet.dart).
- **Pricing staleness:** Treat `portfolioPricesProvider` snapshot as stale if older than 60 s; fall through to autosign-off path. Track snapshot timestamp alongside the price map or use a dedicated staleness flag.
- **FR-004 fall-through:** Identical path to “autosign off” → existing `addNotification` (including desktop local notification + mobile `showNotificationMenuProvider` behavior).
- **FR-004 auth failure:** **Drop** — no `To_SignerResponse` sent, no `addNotification`. Same as FR-011 silent ignore: server receives no response and will time out the request.
- **Connect requests:** Do **not** apply autosign; keep current `addNotification` for `hasConnect()`.
- **Domain matching:** Prefer **exact** `SwaptionSession.domain == signerRequest.origin` unless a single normalization helper already exists (search before inventing).
- **`_recvMsg`:** Use `await _handleSignerRequest(from.signerRequest);` inside `case From_Msg.signerRequest:`.

## Testing strategy

| Area | Approach |
|------|----------|
| `autosign_provider` | Mock / override `configurationProvider` or `SharedPreferences`; assert map mutations and persistence callbacks |
| `config_provider` | Extend existing tests: seed JSON for new key, expect read/write round-trip |
| USD helper | `ProviderContainer` with `portfolioPricesProvider`, `assetUtilsProvider`, `liquidAssetIdStateProvider` overrides; table-driven cases: missing price, >100, multi-component, fee-only |
| `wallet.dart` | **Excluded** per brief — rely on manual / integration |
| USD threshold helper | Test stale-price path (timestamp > 60 s → fallthrough) |

**Coverage scope (100%):** `autosign_provider.dart`, `config_provider.dart` (new field), USD threshold helper. Wallet paths verified via manual test matrix: FR-011 ignore, auth-cancel drop, stale-price fallthrough, normal notification fallthrough, successful auto-accept.
**Domain matching:** Use exact string equality (`SwaptionSession.domain == signerRequest.origin`). No URL normalization unless server delivers inconsistent formats (document if discovered during implementation).

## Risks & mitigations

| Risk | Mitigation |
|------|------------|
| `pricesUsd` stale vs “at request time” | Prices refresh on timer + server push; use **current** map at handler entry (matches spec). |
| `origin` vs `domain` mismatch | Document string format from server; add logging in debug if reject spikes. |
| Concurrent sign + toggle | Spec: read preference at **handler entry** — single read at start of `_handleSignerRequest`. |
| Async `_recvMsg` ordering | Rare reordering of `From` messages; acceptable; document if QA sees edge cases. |

## Complexity Tracking

No extra complexity beyond justified feature surface; table **empty**.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| — | — | — |

---

## Re-report for orchestrator

- **BRANCH:** `001-autosign-notifications`
- **IMPL_PLAN:** `H:\Projects\SideSwap\sideswap\specs\001-autosign-notifications\plan.md`
- **FEATURE_SPEC:** `H:\Projects\SideSwap\sideswap\specs\001-autosign-notifications\spec.md`
- **SPECS_DIR:** `H:\Projects\SideSwap\sideswap\specs\001-autosign-notifications`
- **Artifacts:** `plan.md`, `research.md`, `data-model.md`, `quickstart.md`
