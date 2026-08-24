# Implementation tasks: Autosign for connected sites (001-autosign-notifications)

Ordered checklist for implementers. Spec: [spec.md](./spec.md). Plan: [plan.md](./plan.md).

**Checklist traceability:** Each open item in [checklists/implementation.md](./checklists/implementation.md) and [checklists/security.md](./checklists/security.md) is covered by acceptance criteria below (`impl CHKnnn` / `sec CHKnnn`).

---

### TASK-001: Persist `autosignDomains` on `SideswapSettings`

**File(s):** `lib/providers/config_provider.dart`, `lib/providers/config_provider.freezed.dart` (generated), `test/providers/config_provider_test.dart`

**Depends on:** none

**Spec refs:** FR-002, FR-003, SC-004, impl CHK004 (persistence ordering context), impl CHK016 (test scope)

**Description:**

- Add `@Default({}) Map<String, bool> autosignDomains` to **`SideswapSettings`** (both `empty` and any factory paths that must round-trip; mirror how optional JSON-backed models like `stokrSettingsModel` integrate).
- Add a **SharedPreferences string key** constant on `SideswapSettings` (e.g. `autosign_domains`) storing **JSON object** `{"example.com": true, ...}`; implement `_autosignDomains` / `_setAutosignDomains` (or equivalent) following `_stokrSettings` / `_setStokrSettings` style: read `jsonDecode`, normalize to `Map<String, bool>`, write `jsonEncode`.
- Wire **`Configuration._readSettings`** / **`_saveSettings`** to include the new field.
- Expose notifier API used by autosign provider later, e.g. **`setAutosignDomains(Map<String, bool>)`** or **`setAutosignForDomain(String domain, bool enabled)`** + **`removeAutosignDomain(String domain)`** that **`copyWith`** the map (immutable update; removing key = implicit false per FR-002).
- After **freezed** / **`@freezed`** edits: run **`dart run build_runner build --delete-conflicting-outputs`** (or project-standard command).

**Acceptance criteria:**

- [x] `autosignDomains` defaults to empty map when prefs key absent (FR-002).
- [x] `fromJson`/`toJson` via prefs: seed JSON in tests, read `configurationProvider`, assert map equality; mutate via notifier, flush async saves, assert written string round-trips (FR-003, SC-004).
- [x] No regression on existing settings keys.
- [x] impl CHK016: tests extend **only** `config_provider_test.dart` for this field (not full-file coverage mandate).
- [x] Generated freezed/g files committed and analyzer-clean.

**Test coverage:** `config_provider_test.dart` — new tests exclusively for `autosignDomains` read/write round-trip and default.

---

### TASK-002: `autosignProvider` notifier (Riverpod codegen)

**File(s):** `lib/providers/autosign_provider.dart`, `lib/providers/autosign_provider.g.dart` (generated), `test/providers/autosign_provider_test.dart`

**Depends on:** TASK-001

**Spec refs:** FR-002, FR-003, FR-008, FR-009, FR-010, SC-001, SC-004, impl CHK009, impl CHK011, sec CHK012

**Description:**

- Create **`@riverpod`** class **Notifier** (codegen, auto-dispose) whose state is the logical autosign map, **delegating persistence** to **`configurationProvider.notifier`** (single source of truth in `SideswapSettings`).
- Public API: **`bool isAutosign(String domain)`** (false if key absent); **`Future<void> setAutosign(String domain, bool value)`** (persist `true` or remove key on `false` per FR-002); **`Future<void> removeAutosign(String domain)`** (always remove key — used on disconnect).
- On **`build()`**, `ref.watch(configurationProvider)` and derive read model; after config changes triggered by this notifier, state must **update without app restart** (FR-009).
- Run **`build_runner`** after adding annotations.

**Acceptance criteria:**

- [x] `isAutosign` / `setAutosign` / `removeAutosign` behave as specified; map mutations persist via configuration (FR-003, FR-008).
- [x] UI-driven toggles reflected on next read without restart (FR-009); impl CHK011 satisfied for autosign control consistency with persisted settings.
- [x] impl CHK009 / FR-010: document in code that **wallet must not** cache autosign for the whole handler via stale closure — wallet task reads preference at **handler entry**; provider API is still consistent for UI.
- [x] sec CHK012: API is **per-domain string key** only; no cross-domain mutation.

**Test coverage:** **`test/providers/autosign_provider_test.dart`** — **100% line coverage** of `autosign_provider.dart`: override `sharedPreferencesProvider` / `configurationProvider` as needed; verify mutations, persistence delegation, `removeAutosign` removes key, `setAutosign(..., false)` clears key.

---

### TASK-003: USD notional threshold helper

**File(s):** `lib/providers/autosign_provider.dart` (helper inlined as top-level function), `test/providers/autosign_provider_test.dart`

**Depends on:** none (independent of config/autosign map; implement before or parallel to TASK-002)

**Spec refs:** FR-004, FR-012, SC-002, impl CHK001, impl CHK005, impl CHK007, impl CHK008, impl CHK014, impl CHK015, sec CHK002, sec CHK008, sec CHK009, sec CHK013, sec CHK014

**Description:**

- Implement **pure testable function** **`isSignRequestWithinAutosignUsdLimit`** in `autosign_provider.dart` with named parameters `{pricesUsd, assets, liquidAssetId, sign}` returning:
  - **`null`** (eligible) iff **every** monetary value component converts to USD notional using `pricesUsd` map and **each** is **≤ 100** (100.01 → ineligible; exactly 100 → eligible). Per-component checks, not summed total (impl CHK008, sec CHK009).
  - **`AutosignFallthrough`** (ineligible) with specific reason: `.emptyPayload` (no components), `.unknownAsset` (assetId empty or missing from assets map), `.zeroQuantity` (amount zero/negative), `.missingPrice` (no price for asset), `.overLimit` (component > 100 USDT).
- **Enumerate components** (impl CHK001): each **`sign.recipients[]`**, **`sign.networkFee`** with asset id from `liquidAssetId` param. **`sign.balances[]` excluded** — these are full UTXO inputs, not transfer amounts; including them would incorrectly cap autosign based on wallet balance rather than the actual outgoing value.
- Convert smallest-unit integers to human quantity via `assets[assetId]?.precision` (same as `assetUtilsProvider`); multiply by `pricesUsd[assetId]` for USD notional.
- On non-null result, caller `logger.w(reason.description)` (FR-012c) — helper returns reason only; wallet logs.
- *(Note: explicit 60-second price staleness check not implemented — prices refresh every ~10 s via server timer; missing price surfaces as `.missingPrice` → correct fallthrough.)*

**Acceptance criteria:**

- [x] All value components from `From_SignerRequest_Sign` covered (impl CHK001).
- [x] Only **`portfolioPricesProvider`** used for USD notional (impl CHK007).
- [x] Per-component **≤ 100** rule with boundary tests 100 vs 100.01 (impl CHK008, sec CHK009).
- [x] Empty sign payload (no components) → `AutosignFallthrough.emptyPayload`.
- [x] impl CHK014 / SC-002: helper behavior matches FR-004 eligibility (null = all convert + each ≤ cap).
- [x] impl CHK015 / sec CHK014: wallet logs `logger.w(reason.description)` on ineligible path (verified in TASK-004; helper returns non-null).

**Test coverage:** `test/providers/autosign_provider_test.dart` — 100% line coverage. Cases pin specific `AutosignFallthrough` values: **missing price → `.missingPrice`**, **unknown asset → `.unknownAsset`**, **zero quantity → `.zeroQuantity`**, **over limit → `.overLimit`**, **empty payload → `.emptyPayload`**, **exactly 100 → null**, **all components pass → null**.

---

### TASK-004: Wallet sign-request handling — FR-011, autosign, auth, responses

**File(s):** `lib/providers/wallet.dart`

**Depends on:** TASK-002, TASK-003

**Spec refs:** FR-004, FR-005, FR-006, FR-010, FR-011, FR-012, SC-002, SC-003, impl CHK005, impl CHK009, impl CHK010, impl CHK015, impl CHK017, sec CHK002, sec CHK003, sec CHK005, sec CHK006, sec CHK007, sec CHK008, sec CHK010, sec CHK011, sec CHK013, sec CHK015

**Description:**

- Change **`_handleSignerRequest`** to **`Future<void> _handleSignerRequest(From_SignerRequest signerRequest)`** and in **`_recvMsg`** `case From_Msg.signerRequest:` use **`await _handleSignerRequest(from.signerRequest);`**.
- **`hasConnect()`:** keep **existing** behavior only — **`addNotification(signerRequest)`** with all current desktop/mobile side effects; **no** FR-011 change, **no** autosign (plan).
- **`hasSign()` branch:**
  1. **FR-011 (impl CHK005, impl CHK010, sec CHK002, sec CHK003, sec CHK005, sec CHK008):** Resolve **`swaptionSessionProvider`**; require **exact string equality** **`SwaptionSession.domain == signerRequest.origin`** for **at least one** session. If none: **do not** send **`To_SignerResponse`**, **do not** call **`addNotification`**, **`logger.w`** (FR-012a), return.
  2. **FR-010 / sec CHK011:** At **handler entry** (after connect early-exit, before autosign branch), read **`ref.read(autosignProvider.notifier)`** (or equivalent) **`isAutosign(signerRequest.origin)`** once into a **local bool**; use only that for this invocation.
  3. If **autosign false:** existing **`addNotification(signerRequest)`** path (full parity with today’s sign notifications).
  4. If **autosign true:** call **`isSignRequestWithinAutosignUsdLimit(...)`** (named params). If **non-null:** **`logger.w(reason.description)`** (FR-012c), then **same** **`addNotification`** as autosign-off (FR-004 fallthrough; sec CHK013).
  5. If **true:** **`await isAuthenticated()`** (existing `SideswapWallet.isAuthenticated`). If **false** (cancel / fail / grouped per sec CHK010): **do not** send **`To_SignerResponse`**, **do not** **`addNotification`**, **`logger.w`** (FR-012b; sec CHK006, sec CHK007, sec CHK013, sec CHK015). If **true:** build **`To()`** with **`signerResponse = To_SignerResponse(reqId: signerRequest.reqId, accept: true)`** and **`sendMsg`**; **do not** call **`addNotification`**; **do not** trigger desktop local notification or mobile **`showNotificationMenuProvider`** (FR-005, FR-006, SC-003).
- **impl CHK017 / User Story 2:** Each request handled independently; no batching.
- **English** short comments; **no** autosign-specific user-visible UI on any branch (FR-004).

**Acceptance criteria:**

- [x] Connect vs sign branching correct; sign path implements FR-011 before notification/autosign (sec CHK003).
- [x] Unknown origin: no response, no notification, `logger.w` (FR-011, FR-012a, sec CHK005).
- [x] Autosign accept: only `To_SignerResponse(accept: true)`; no notification list entry; no desktop show/restore or mobile menu popup (FR-005, FR-006, SC-003).
- [x] Auth cancel/fail on autosign path: no `To_SignerResponse`, no notification, `logger.w` (FR-004, FR-012b, sec CHK006, sec CHK007).
- [x] Autosign preference read once at handler entry (FR-010, sec CHK011).
- [x] Domain match is **exact** `session.domain == signerRequest.origin` (impl CHK005).

**Test coverage:** **manual only** — **no** `wallet.dart` unit tests (project constraint).

---

### TASK-005: Remove autosign on session disconnect (ordering)

**File(s):** `lib/providers/wallet.dart`

**Depends on:** TASK-002

**Spec refs:** FR-007, SC-005, impl CHK004, sec CHK013

**Description:**

- In **`_handleSessionRemoved`**, **before** **`swaptionSessionProvider.notifier.removeSessions(sessionRemoved.sessionId)`**, look up **`SwaptionSession`** with that **`sessionId`** in **`ref.read(swaptionSessionProvider)`**, read **`domain`**, then call **`ref.read(autosignProvider.notifier).removeAutosign(domain)`** (no-op if domain missing from map).
- Then call existing **`removeSessions`** (impl CHK004: **domain lookup before session list mutation**).

**Acceptance criteria:**

- [x] `removeAutosign` always runs **before** `removeSessions` for that id (impl CHK004, FR-007, SC-005).
- [x] If session not found (edge race), still **`removeSessions`**; **`removeAutosign`** best-effort with resolved domain only (document in short comment if needed).

**Test coverage:** **manual only**.

---

### TASK-006: Autosign checkbox on `SwaptionDomainItem` + i18n

**File(s):** `lib/desktop/widgets/d_swaption_connections_button.dart`, `assets/translations/en.json` (+ **all** other `assets/translations/*.json` files that mirror keys for **Liquid Connect** strings, same pattern as `"No active sessions"`)

**Depends on:** TASK-002

**Spec refs:** FR-001, FR-002, FR-008, FR-009, SC-001, impl CHK002, impl CHK003, impl CHK011, impl CHK012, impl CHK013

**Description:**

- In **`SwaptionDomainItem`**, add a **`Checkbox`** row (or aligned control) labeled with **`.tr()`** (e.g. key **`Autosign`** or **`Liquid Connect: Autosign`** — pick one string, consistent with nearby keys).
- **`value`:** `ref.watch` / read **`autosignProvider`** → **`isAutosign(swaptionSession.domain)`**.
- **`onChanged`:** call **`setAutosign(swaptionSession.domain, value ?? false)`**.
- **No structural changes** to **`swaption_sessions_dialog.dart`** if it already embeds **`SwaptionDomainItem`** (it does).
- impl CHK002: same widget on **desktop overlay and mobile dialog** via shared `SwaptionDomainItem`.
- impl CHK012: checkbox toggle only — **no** extra confirmation dialog (Assumptions / spec).
- impl CHK013: control reachable in **two interactions** from sessions list context (verify during manual pass in TASK-007).

**Acceptance criteria:**

- [x] Checkbox visible for every session row on desktop + mobile entry points using this widget (FR-001, impl CHK002).
- [x] Immediate UI update (FR-008, FR-009, impl CHK011).
- [x] English string in **en.json**; other locale files updated with same key (project convention; impl CHK003).

**Test coverage:** manual / widget optional (not required by brief); provider logic covered in TASK-002.

---

### TASK-007: Verification, coverage gates, manual matrix

**File(s):** none (commands + optional `specs/001-autosign-notifications/manual-test-results.md` **only if** team wants a written log — **otherwise** record matrix in PR description; default: **PR / commit message notes**, no new doc unless repo convention requires)

**Depends on:** TASK-001–TASK-006

**Spec refs:** SC-001–SC-005, FR-012, impl CHK013–CHK016, sec CHK014–CHK015

**Description:**

- Run **`flutter analyze`** — **zero errors**.
- Run **`flutter test`** — all pass.
- Confirm **100% coverage** (per `flutter test --coverage` / lcov) on:
  - `lib/providers/autosign_provider.dart`
  - **New** `autosignDomains` code paths in `lib/providers/config_provider.dart` only
  - `lib/providers/autosign_provider.dart` (threshold helper + `AutosignFallthrough` enum)
- Execute and **document** manual matrix (5 scenarios):
  1. **FR-011 ignore** — origin with no matching session: no notification, no response (observe logs / server timeout as expected).
  2. **Auth-cancel drop** — autosign on, under threshold, cancel PIN/biometric: no notification, no `To_SignerResponse`, `logger.w`.
  3. **Missing-price fallthrough** — autosign on, asset with no price in `portfolioPricesProvider` (e.g. connect before prices load): normal sign notification path, `logger.w` with `.missingPrice` description.
  4. **Normal notification fallthrough** — autosign off or over threshold / missing price: same as today’s sign notification.
  5. **Successful auto-accept** — autosign on, under threshold, auth success: accepted silently, no notification, no window/menu side effects.

**Acceptance criteria:**

- [x] Analyzer clean; full test suite green.
- [x] Coverage targets met for scoped files (impl CHK016).
- [x] Manual matrix **recorded** (PR body or agreed artifact) with pass/fail notes (SC-001–SC-005 alignment).

**Test coverage:** aggregate automated + manual as above.

---

## Summary table

| Task ID   | Title                                      |
|-----------|---------------------------------------------|
| TASK-001  | Persist `autosignDomains` on `SideswapSettings` |
| TASK-002  | `autosignProvider` notifier (Riverpod codegen) |
| TASK-003  | USD notional threshold helper (`AutosignFallthrough?` return) |
| TASK-004  | Wallet sign-request handling (async, FR-011, autosign) |
| TASK-005  | Remove autosign on session disconnect       |
| TASK-006  | Autosign checkbox + i18n on `SwaptionDomainItem` |
| TASK-007  | Verification, coverage gates, manual matrix |
