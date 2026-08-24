# ADR-0002 — Wallet descriptor export for watch-only wallets

- **Status:** Accepted
- **Date:** 2026-07-21
- **Branch:** `descriptors-export` (explicitly created by the user; protobuf regeneration commit `431833a0` is already on it)
- **Driver:** `tasks/ui_descriptor_export.txt` — expose the two CT descriptors that `sideswap_rust` commit `6f85e856` now sends on `Login` success, so users can load a watch-only wallet in LWK
- **Reviewed by:** two Codex passes.
  - Pass 1, devil's advocate (12 findings) — folded in: Jade gate added (was: ungated), invalid payload clears the provider (was: leave-as-is), copy/share confirmation warning added, `goBack()` and route-test coverage added, LTR rendering for RTL locales added, debug-log and clipboard exposure made explicit. Rejected after source verification: the keyboard-shortcut "focus-gate bypass" (key events do not reach an unfocused window; gate added anyway as one-line defense-in-depth) and the late-Login race as a blocker (pre-existing, documented pattern — see decision 9).
  - Pass 2, adversarial, fresh thread (4 falsifications, all source-verified) — folded in: the Jade gate is honestly described as a **five-minute unlock lease** (decision 3, rewritten); the desktop settings dialog needs a **layout change** for the new row (decision 2); the desktop **`mapStatus()`** switch joins the navigation plan (decision 4); the test plan was rewritten around the fact that `wallet.dart` is nowhere near 100% coverage and `wallet_test.dart` has none of the coverage the first draft claimed — the gate moves into its own fully-covered provider file and the `wallet.dart` deviation is recorded (decision 8). It also confirmed decisions 1, 5, 6.1, 7 (translations), 9 and 10 under attempted falsification, and downgraded the Rust-redaction claim to externally-verified-only (decision 7).

## Context

The bundled Rust client now answers a successful login with `From.Login.LoginInfo`, carrying `native_segwit_descriptor` (`ct(slip77(…),elwpkh(…))`, derivation 84') and `nested_segwit_descriptor` (`ct(slip77(…),elsh(wpkh(…)))`, derivation 49'). The regenerated Dart protobuf (`From_Login_LoginInfo`, `thirdparty/sideswap_protobuf/lib/src/sideswap.pb.dart:5424`) is already committed. The Dart side currently ignores the success payload entirely (`_handleLogin`, `lib/providers/wallet.dart:1966` — the success branch never reads `login.success`).

A wallet descriptor is not a spending secret — it reveals the wallet's complete past and future transaction history, nothing more. The app already frames exactly this in its Liquid Connect consent copy ("Sharing watch-only access (descriptor/xpub and Liquid master blinding key) reveals your full past and future activity"). Terms are defined in [`CONTEXT.md`](../../CONTEXT.md#wallet-descriptors).

## Decisions

### 1. Descriptors live in a new nullable `keepAlive` provider

New file `lib/providers/wallet_descriptors_provider.dart`, modelled on `AmpIdNotifier` (`lib/providers/amp_id_provider.dart`; same keepAlive/set/invalidate shape, nullable state instead of `''`): `@Riverpod(keepAlive: true)`, state `WalletDescriptors?` where `WalletDescriptors` is a small freezed value type with two non-nullable `String` fields. Default state `null` = **not loaded**.

- Set from `_handleLogin`'s success branch — the only writer.
- **Set only when both incoming strings are non-empty; an invalid payload (either string empty) actively clears the state back to `null`** (decision 6) — a previously populated value never survives a later invalid delivery.
- Cleared with `ref.invalidate(walletDescriptorsProvider)` added to `cleanAppStates()` (`wallet.dart:1552`), alongside `ampIdProvider`, so descriptors never survive logout/wallet deletion in memory.

**Rejected — extending `ServerLoginStateLogin`:** every watcher of `serverLoginProvider` would carry the sensitive strings in a widely-watched state object, and its existing test surface (`test/providers/connection_state_providers_test.dart`) would grow for no benefit.

**Rejected — two bare `String` providers (`''` = absent):** an empty string cannot distinguish *not loaded* from *present but empty*; ADR-0001's zero-vs-not-loaded lesson applies verbatim.

### 2. Settings entry on both platforms, disabled until loaded

> **Refined by [ADR-0003](0003-descriptor-export-ui-refinements.md):** the desktop dialog is now content-sized (not a fixed 582px scroll area), and the settings entry is repositioned — desktop: directly above Network Access; mobile: directly after the biometric/PIN column.

New entry **"Export watch-only descriptors"** in mobile `lib/screens/settings/settings.dart` and desktop `lib/desktop/settings/d_settings.dart`, wired to the **already-existing but never-used** `export` icon types (`SettingsButtonType.export` → `assets/settings_export.svg`, `DSettingsButtonIcon.export` — both confirmed unreferenced).

**While `walletDescriptorsProvider` is `null`, the button is disabled** — the descriptors screen is unreachable without data, so it needs no empty/loading state at all. `SettingsButton`/`DSettingsButton` currently have no disabled state; both gain one (no action + dimmed visuals — `onPressed: null` alone would not read as disabled, since both widgets hard-code active-looking text/icon colors). This is a deliberate scope increase over rendering-nothing-on-null, chosen by the user.

**Desktop layout change required:** `DSettings` lays its rows out in a fixed, non-scrollable `SizedBox(height: 582)` (`lib/desktop/settings/d_settings.dart:49-53`). With the debug-flavor local-endpoint row present, the current rows already nearly fill it; adding the descriptors row overflows. The dialog content becomes scrollable (or the box grows to fit the worst-case row set) as part of this change — adding the button alone is not enough.

### 3. Access gate copies the recovery-phrase pattern, with a Jade-lease branch — in its own provider file

The gate logic lives in a **new provider file** (not in `wallet.dart` — see decision 8 for why), shaped like `settingsViewBackup()` (`wallet.dart:1490`) and reaching its dependencies through existing public providers (`configurationProvider`, `pinProtectionHelperProvider`, `jadeLockRepositoryProvider`, `encryptionRepositoryProvider` from `lib/providers/encryption_providers`, `pageStatusProvider`):

| Config | Gate |
|---|---|
| PIN protection on | `pinProtectionHelperProvider.pinBlockadeUnlocked()` — fully generic, reused verbatim |
| Jade wallet, PIN off | **Jade unlock lease**: `jadeLockRepository.isUnlocked()` → enter; not held → `refreshJadeLockState()` (device unlock prompt), same pattern that gates trading actions (`lib/screens/markets/market_swap_page.dart:44-56`) |
| Software wallet, PIN off | biometric/fallback decrypt of the stored mnemonic, decrypt-and-compare, exactly as the backup view does |

**What the Jade branch actually guarantees (adversarial-pass correction):** `JadeLockState` is app-side cached state on a **five-minute lease** — a successful `jadeUnlock` flips it to unlocked and a `RestartableTimer` only re-locks it five minutes after the last refresh (`lib/providers/jade_provider.dart:165-184, 237-239, 250-262`). It does **not** re-check device presence or the device's current lock state; within the lease window the device may be locked or unplugged and the gate still passes. This is accepted deliberately: the very same lease authorizes trading actions, which move funds — a strictly stronger capability than reading history. Describing it as "requires the device present and unlocked" (this ADR's own earlier draft) was wrong; it requires *a Jade unlock within the last five minutes*.

A Jade login has no mnemonic in the app, so the existing biometric/fallback branch has nothing to decrypt; the unlock lease is the authorization mechanism the app already trusts for its most sensitive actions, and it is reused here. Every path to the descriptors screen therefore has *some* gate.

**Rejected — hiding the entry for Jade (like the mnemonic button's `!isJadeWallet`):** watch-only export is *most* useful precisely for a hardware wallet; cutting Jade off would gut the primary use case.

**Rejected — ungated Jade entry (the original grill decision, reversed by the devil's advocate pass):** "no mnemonic to protect" explains why the *mnemonic* branch can't run, not why *no* gate is due — descriptor export is classified sensitive-like-recovery-phrase in `CONTEXT.md`, and an existing Jade authorization mechanism was available.

**Rejected — PIN-only gating for everyone:** weaker than the existing mnemonic protection for software wallets with only biometrics enabled, and inconsistent with the app's one established "reveal sensitive data" pattern.

### 4. The screen shows both descriptors: copy + QR everywhere, share on mobile

> **Superseded in part by [ADR-0003](0003-descriptor-export-ui-refinements.md):** the QR codes are removed (both platforms); the truncated preview now uses `MiddleEllipsisText`. Copy/share, the LTR wrapper, and the desktop focus-gate are retained. The QR-payload test in decision 8 is removed with the QR.

One screen per platform, prior art `settings_view_backup.dart` / `d_settings_view_backup.dart`:

- Two sections, **Native segwit** and **Nested segwit**, each with a truncated text preview, a Copy button, and a QR code (`qr_flutter`, pattern from `lib/screens/receive/widgets/qr_receive_address.dart`; a ~230-char descriptor is well within QR capacity).
- Mobile adds a Share action (`share_plus`, wrapper pattern in `lib/common/helpers.dart:258`).
- Desktop copy is gated on window focus via the `isCopyEnabled`/`WindowListener` pattern from `d_settings_view_backup.dart` — **including inside the keyboard-shortcut `Action`**, unlike the backup-view prior art where only the visible button checks the flag. (The claimed "bypass" is theoretical — an unfocused window receives no key events — but the extra check costs one line.)
- **Copy/share confirmation warning:** the first copy or share per screen visit shows a confirmation dialog stating the descriptor will enter the system clipboard / OS share sheet and persist there outside the app's control. Deterministic, widget-testable; chosen over best-effort timed clipboard clearing, whose platform traps (Android 12+ clipboard-read toast, timers not firing in background, racing user's later clipboard content) outweigh its value — and which cannot cover share at all.
- Descriptor previews are wrapped in an explicit LTR `Directionality` (prior art `lib/screens/onboarding/first_launch_page.dart:90`) so descriptor syntax renders correctly under the RTL locales (`ar`, `ur`).
- Warning text above the sections: *"Anyone with these descriptors can see your full transaction history and future activity, but cannot spend your funds. Share them only with wallets you trust."*

Navigation is the mechanical prior-art path, in **four** switches plus `goBack()` (the adversarial pass caught that three is not enough): new `Status.settingsDescriptors` (`wallet_page_status_provider.dart`), new `RouteName` constant, then entries in (1) the mobile page-stack switch (`route_providers.dart:216` analogue), (2) the **`mapStatus()`** `pushNamedAndRemoveUntil` switch driven by the desktop route listener (`route_providers.dart:419-479` — its `_ =>` fallback logs `Unhandled $status`, which is where the new status would silently land otherwise), (3) the desktop `RawDialogRoute` switch (`route_providers.dart:552` analogue), and a `goBack()` branch — the new status joins the settings-detail group returning to `Status.settingsPage` (`wallet.dart:1258-1265`); without it the screen falls into the `Unhandled goBack status` fallback (`wallet.dart:1295-1297`).

### 5. Strings are literal-English keys, translated into all nine locales in the same PR

New keys (= their English text, easy_localization convention): "Export watch-only descriptors", "Wallet descriptors", the warning sentence, "Native segwit", "Nested segwit". Existing keys `Copy`/`COPY`/`Share` are reused. All nine locale files (`ar,en,es,pl,pt,ru,sv,ur,zh`) receive translated values in the same change — no English-fallback debt.

**Flagged:** Arabic and Urdu word order (RTL) needs a native-speaker sanity check we cannot provide — same reservation ADR-0001 recorded.

### 6. Empty descriptor strings are treated as not loaded — and clear any prior value

The provider only accepts a payload where both strings are non-empty; an invalid payload **sets the state to `null`** (it does not merely "stay" null — a populated value from an earlier login is wiped), and the settings button disables again. `required` proto fields are not a Dart-side invariant — the generated accessors happily return `''` for absent fields (`sideswap.pb.dart:5473,5482`) — so the guard is real insurance, not dead code. `null` deliberately covers both *not yet received* and *invalid payload*: with the Rust library bundled (no version skew possible), a distinguishable "malformed" UI state would be an unreachable third branch; a disabled entry is the chosen, sufficient outcome for both.

### 7. `logger.d(login)` stays as-is

After the change, `_handleLogin`'s entry log would print both descriptors — this was investigated and deliberately left alone:

- `CustomLogger` (git package `sideswap_logger`) builds its `Logger` without a filter, so the `logger` package's default `DevelopmentFilter` applies: **release builds emit nothing** (verified against `logger` 2.7.0 — logging happens only inside `assert`).
- The logs a user can share from the Logs screen are `sideswap.log`/`sideswap_prev.log` — the **Rust client's** files, where the descriptor commit redacts both descriptors (`redact_from_msg` in `sideswap_client/src/utils.rs`). **Externally verified only:** this was checked against the upstream diff at <https://github.com/sideswap-io/sideswap_rust/commit/6f85e856271ad5b070ecb8641dce892e411bf674> during this design session; the Rust repo is not checked out locally, so the claim is not reproducible from this repository alone.
- The Dart-side file sink (`sideswap_ui.log`) only exists in `kDebugMode` on desktop.

**Explicitly accepted exposure:** a desktop *debug* build persists descriptors in plaintext to the developer's own `sideswap_ui.log`. That file never exists in release builds and is never reachable from the Logs screen; redaction would add noise for no user-facing gain.

### 8. Tests — and the `wallet.dart` coverage conflict

`docs/TESTING.md` requires every provider file to be at 100% line and branch coverage after any change. The adversarial pass established that this is **unsatisfiable for `wallet.dart` within this feature**: the file is ~1,300 lines with only vestigial coverage today, and `test/providers/wallet_test.dart` currently tests construction/initial state only — it has **no** `_handleLogin`, `settingsViewBackup`, `goBack` or cleanup coverage (this ADR's first draft wrongly claimed otherwise). Bringing the whole file to 100% is a separate undertaking.

**Resolution (user decision): minimise the `wallet.dart` delta and put the new logic where 100% is achievable.**

- The **gate** (`settingsViewDescriptors()` logic, decision 3) lands in a **new provider file**, not in `wallet.dart` — new files carry no legacy-coverage debt, so the 100% rule applies to them cleanly.
- `wallet.dart` is touched in exactly three places: the descriptor write in `_handleLogin`'s success branch, the `goBack()` branch, and the `ref.invalidate` in `cleanAppStates()`. These changed lines get targeted tests; **the file-level 100% rule is knowingly deviated from for `wallet.dart`'s pre-existing uncovered lines**, and this ADR is the record of that deviation.

Test surface:

- **`test/providers/wallet_descriptors_provider_test.dart`** (new, 100% line and branch): initial `null`; set with both strings → state present; set with either string empty → `null`; **populated → invalid payload → cleared to `null`** (the transition, not just the initial state); invalidate → back to `null`. `ProviderContainer.test` + `ProviderListener` + `verifyInOrder`, template `test/providers/amp_id_provider_test.dart`.
- **Gate provider test** (new file, 100% line and branch): PIN on → unlocked/refused; Jade lease held → navigate / not held → `refreshJadeLockState` invoked, no navigation; software wallet → biometric match navigates, mismatch does not; each branch asserted via `pageStatusProvider` transitions with mocked `pinProtectionHelperProvider`/`jadeLockRepositoryProvider`/encryption seams.
- **`test/providers/wallet_test.dart`** (existing, targeted additions for the changed lines only): `_handleLogin` success writes descriptors / invalid payload clears them; the new `goBack()` branch (`settingsDescriptors` → `settingsPage`); `cleanAppStates()` invalidates the descriptors provider.
- **`test/providers/route_providers_test.dart`** (existing, enumerated by convention): the new status joins the mobile page-stack tests (`:317` group), the desktop dialog-route tests (`:436` group), the status-to-route mapping (`:601` group) — **and the `mapStatus()` switch coverage** (decision 4).
- **Widget tests** (one per behavioural branch): settings button disabled at `null` vs enabled when loaded; descriptors screen renders both sections with the expected values; copy/share confirmation dialog shown on first action and not on the second; desktop copy disabled when window unfocused (button *and* shortcut action); descriptor preview renders LTR under an RTL locale (`ar`); QR widget carries the exact descriptor string as payload. Localization loaded per test (`Localization.load` in `setUp`, not `setUpAll` — shared-singleton rule).
- **Manual on-device check** (user-visible UI): entry visibility and gating for software + Jade wallets (device locked and unlocked), QR scannability into LWK, share sheet on mobile, logout → re-login, wallet deletion → new wallet (button returns to disabled until the new login lands).

### 9. The late-Login race is accepted as a pre-existing pattern

The receive pipeline does not serialise messages (`wallet.dart:245-249` — an explicit TODO documents and accepts this), and `_handleLogin` carries no session correlation. A theoretically late `Login` success arriving after logout would repopulate the descriptors — but it would *equally* set `serverLoginProvider` to logged-in and `firstLaunchStateProvider` to empty, because descriptors are written in the very same branch. The descriptors are exactly as stale as the app's entire login state, never more. Fixing this means serialising the pipeline or adding login-generation correlation for **all** handlers — a separate, app-wide task already tracked by the existing TODO; a descriptors-only correlation mechanism would be an inconsistent one-off. Accepted, not fixed here.

### 10. Clipboard/share persistence is mitigated by warning, not prevented

Once copied or shared, a descriptor lives in the OS clipboard/share target beyond the app's reach — same as today's mnemonic copy (a strictly stronger secret). The confirmation warning (decision 4) makes that explicit to the user; timed clipboard clearing was rejected (platform traps listed in decision 4).

## Out of scope, deliberately

- Amp/AMP-account descriptors — the server sends only the two singlesig accounts.
- Screenshot/FLAG_SECURE hardening of the new screen — the recovery-phrase screen has none either; if that protection is ever added, both screens should get it together.
- Persisting descriptors to config/disk — they are re-delivered on every login; memory-only is strictly safer.

## Consequences and unverified assumptions

- `SettingsButton`/`DSettingsButton` gain a disabled state, and the desktop settings dialog gains a scrollable (or resized) content area — small API/layout changes touching shared widgets.
- Every path to the descriptors screen is gated (app PIN, Jade unlock lease, or biometric/fallback mnemonic decrypt) — there is no ungated path after the devil's-advocate reversal of the original Jade decision. The Jade gate is a five-minute lease, not a live device check — the same strength that gates trading (decision 3).
- `wallet.dart` remains below 100% coverage after this change — a documented deviation from `docs/TESTING.md`, bounded by pushing all new logic into fully-covered new files (decision 8).
- **Unverified:** translated copy quality for `ar`/`ur` (native check needed; LTR rendering of the descriptor strings themselves is covered by decision 4 + widget test).
- **Unverified:** whether one process lifetime can switch between two *different stored wallets* such that stale descriptors could briefly outlive a wallet switch; mitigated by `cleanAppStates()` invalidation, clear-on-invalid-payload, plus overwrite-on-login, but not exhaustively traced.
