# ADR-0013 — PIN setup has one busy state, and every field flag is derived from it

- **Status:** Accepted, v3. Both Codex passes applied — devil's advocate on v1, adversarial on v2 — plus one consultation the adversarial pass forced. Decision 17 is issue #245; decisions 1-16 are issue #246, blocked on it. See [Review notes](#review-notes).
- **Date:** 2026-08-25
- **Driver:** A user report against the desktop **Enable PIN protection** dialog. Pressing ENABLE disables the *confirm field* in both outcomes — matching PINs and mismatched PINs — selects the text inside it, and shrinks it. The mismatch case leaves the user unable to correct the PIN they were just told is wrong. Mobile shows the same lock-out on mismatch and nothing else.
- **Scope:** the PIN **setup** flow on both platforms — `lib/providers/pin_setup_provider.dart`, `lib/models/pin_models.dart`, `lib/desktop/onboarding/d_pin_setup.dart`, `lib/screens/onboarding/pin_setup.dart`, `lib/desktop/pin/widgets/d_pin_text_field.dart`, both PIN keyboards, and the `From_Msg.encryptPin` case in `lib/providers/wallet.dart` (decision 14). It also repairs three defects in `lib/providers/config_provider.dart` and `SideswapWallet.disablePinProtection` that the reviews exposed and that decision 14 would otherwise inherit (decision 17). The PIN **unlock** flow is touched in two places: the keyboard's new `enabled` parameter (decision 12), and the stored-blob repair that unlock depends on (decision 17).

## Context

Three unrelated defects sit on top of one another in this dialog. Separating them is the point of this ADR; every earlier attempt to describe the bug tangled them.

### 1. One flag, two jobs

`SecondPinEnabled.build()` (`pin_setup_provider.dart:132-138`) does two things:

```dart
// Rebuilds (and so resets to false) whenever pin setup advances.
ref.watch(pinSetupStateProvider);
return false;
```

and the flag is then driven imperatively from elsewhere — `setSecondPinEnabled(true)` at `:264` when the first PIN reaches six characters, `setSecondPinEnabled(false)` at `:294` when a backspace takes it below four.

So the flag answers *"is the first PIN long enough that confirming it is meaningful?"* and *"is the form idle?"* with one boolean, and the `watch` silently overrules the setter. Every disable symptom in the report is that collision:

- **mismatch** — `_onEnter` sets `PinSetupState.error`, the provider rebuilds, the confirm field goes dead;
- **server failure** — `onPinData` sets `PinSetupState.error`, same rebuild, same dead field, and `FirstPinEnabled` re-enables the *first* field while the confirm field stays dead;
- **success** — `_sendPin` sets `PinSetupState.done`, both fields go dead. This one is the wanted behaviour, reached by accident.

`FirstPinEnabled` (`:114-122`) has the same shape with a different condition.

### 2. Select-all on focus is a platform default, not our code

`EditableText._defaultSelectAllOnFocus` (`flutter/lib/src/widgets/editable_text.dart:2115-2128`) returns `true` on Windows, Linux and macOS, and `false` on Android and iOS. `_adjustedSelectionWhenFocused` (`:4963`) then selects the whole value whenever the field gains focus other than internally.

`d_pin_setup.dart:214` calls `secondPinFocusNode.requestFocus()` **inside the `Consumer` builder**, so every rebuild while `pinFieldState` is `second` re-requests focus. Pressing ENABLE moves focus to the button and the next rebuild pulls it back — and on Windows that selects the PIN. Mobile never shows it because the default is `false` there and `PinTextField` is `readOnly` besides.

### 3. `errorText` inside a fixed box, and a border that never renders

`DPinTextField` puts the `TextField` in `SizedBox(width: 344, height: 49)` and passes `errorText` into the decoration. `InputDecorator` fits the error line *inside* those 49 pixels, so the input frame shrinks by exactly the height of the message.

The same line hides a second defect. `input_decorator.dart:2366` selects `decoration.focusedErrorBorder` when the field is focused **and** has an error. `DSideSwapInputDecoration` never overrides it and `DPinTextField` never passes it, so the red `focusedBorder` the code builds at `d_pin_text_field.dart:78-86` is unreachable while `errorText` is set. The error border users were meant to see has never rendered.

### 4. The height budget, measured

Measured with `TextPainter` against the real `assets/fonts/Roboto/` faces at width 344, not estimated:

| Quantity | Value |
|---|---|
| Label at size 15 / weight 500 | 18 px, one line |
| Column content today | 388 px inside `SizedBox(height: 458)` |
| Slack today | 70 px |
| Worst error message across all nine locales | 2 lines |
| Two-line reserve plus an 8 px gap | 36 px |
| Slack after the reserve | 34 px |

Only `pl.json`'s `"Błąd podczas ustawiania nowego PIN-u - błąd frazy mnemonicznej"` needs the second line. `ar`, `ur` and `zh` were measured against the test fallback face, since Roboto carries no glyphs for them; all three fit one line and their glyphs are narrower than Latin.

### 5. Prior art already in the repo

`lib/desktop/pin/d_pin_protection.dart:100-142` — the **unlock** dialog — already does what this ADR prescribes for setup. It passes `errorMessage: ''` to `DPinTextField`, renders the message itself, and reserves `SizedBox(height: 74)` in **both** arms of the `switch` so the box never changes height. It also disables its field on `PinProtectionState.waiting()`. The name `waiting` and the constant-reserve shape are taken from there rather than invented.

### 6. The client answers exactly once, in order, and blocks while it does

Verified in `sideswap_rust` (`origin` = `sideswap-io/sideswap_rust`, `main` at `612474f`, fetched and level with `origin/main`), because the whole of decision 14 rests on it:

- The worker is a single-threaded loop taking one message at a time (`sideswap_client/src/worker.rs:4024`), and `EncryptPin` dispatches to `process_encrypt_pin` (`:3117`), which is **synchronous**.
- `process_encrypt_pin` (`:2437-2453`) ends in one `self.ui.send(...)` placed *outside* the `match`, so the `Ok` arm and the `Err` arm both answer. There is no path that returns without a reply.
- Two `EncryptPin` requests therefore cannot be in flight at once. The second is not even dequeued until the first has answered, and replies come back in request order.
- The HTTP agent is built with `ureq::AgentBuilder::new()` and no read timeout (`sideswap_common/src/pin.rs:47-62`). A hung PIN server blocks `process_encrypt_pin`, which blocks the **entire** worker loop — no websocket traffic, no timers, nothing. "The reply never arrives" is therefore the same event as "the client is wedged", not a PIN-screen-local problem. The Flutter isolate keeps drawing, because the worker is behind FFI on its own thread.
- Neither direction carries a correlation id (`sideswap_client/proto/sideswap.proto:272`, `:485`).

### 7. Three defects in how PIN protection is stored

Found by the reviews, all pre-existing, all in the path decision 14 rewrites.

1. **A new blob is never persisted over an old one.** `_setPinData` reads what is already stored and returns without writing when it is not empty (`config_provider.dart:492-495`).
2. **Disabling PIN protection leaves the blob behind.** `disablePinProtection` sets `usePinProtection: false` and re-encrypts the mnemonic, and never clears the stored blob (`wallet.dart:1775-1802`).
3. **The flag is persisted before the blob.** `_writeSettings` awaits `_setUsePinProtection` and only then `_setPinData` (`config_provider.dart:183-184`).

Together they lose wallets. Disable PIN protection, enable it again with a different PIN: the in-memory blob updates so the session works, (1) refuses the write, and after the next app start the configuration loads the **old** blob. The new PIN fails against it, and three failures take `onPinDecrypted` to `settingsDeletePromptConfirm` (`pin_protection_provider.dart:228-233`). (3) is the same outcome from a crash between two `await`s. And the state to fear in all of them is one state: `usePinProtection == true` beside a blob that is missing or stale, because `sendDecryptPin` logs `pinData is empty!` and returns without sending (`wallet.dart:1754-1760`) — an unlock screen that waits for a reply nobody will send.

`walletPinEnable` (`wallet.dart:1035`) reaches that state directly: it enables protection with no blob at all. It has no callers, and it is deleted rather than repaired.

### 8. Neither keyboard has a disabled state

`DPinKeyboard` and `PinKeyboard` wire every button to `keyPressed(index)` unconditionally. In the unlock flow `PinProtectionHelper.onKeyEntered` (`pin_protection_provider.dart:110-114`) already returns early while `waiting`, so the keys are inert there and only the appearance lies. Setup gets the equivalent guard from decisions 1, 4 and 14.

## Decisions

### 1. `firstPinEnabled` and `secondPinEnabled` are derived, with no setters

```
formBusy         = a setup attempt is outstanding      // decision 4
firstPinEnabled  = !formBusy
secondPinEnabled = firstPin.length >= minPinLength && !formBusy
```

Both keep their present provider names and their `bool` type, so no widget call site changes shape. `setFirstPinEnabled` and `setSecondPinEnabled` are removed. A single provider returning a record was rejected: it would rewrite all four widget call sites and rebuild both `Consumer`s on every change unless each site added `.select`, which is the verbosity the record was meant to remove.

### 2. The confirm field's threshold is symmetric at six

The field opens at six characters and closes below six. The old asymmetry — open at six (`:263`), close below four (`:292`) — left the field live under a four-character first PIN, and six is the only number the screen's own label `Set your PIN (6-8 digits)` states.

### 3. Shortening the first PIN clears the confirm PIN

Whenever the confirm field closes because the first PIN got shorter, its text is cleared. Keeping it would let a confirmation of the *old* PIN stand beside a *new* first PIN, unseen.

The clear stays where it already is: the explicit `setSecondPin('')` inside `_onBackspace` (`pin_setup_provider.dart:293`), with its threshold moved from four to `minPinLength`. Every route that shortens the first PIN goes through it, the desktop field included — `onDesktopKeyChanged` replays a removal as one `keyPressed(9)` per old character (`pin_keyboard_provider.dart:52-70`). Naming it matters because `secondPinEnabled` is now derived and has no transition to hang a side effect on; without this sentence the clear would be improvised as a `ref.listen` at implementation time.

### 4. The outstanding attempt is the only record of being busy; `PinSetupState` loses `done` and gains nothing

There is exactly one place that says a round trip is in progress: the attempt token of decision 14. `PinSetupState` is reduced to `idle | error(message)` and describes only what the *form* has to say. `formBusy` reads the token and nothing else.

Two facts for one thing is the defect this ADR opens by condemning (context 1), and a `waiting` member beside the token would be exactly that — with nothing keeping them equal. It would also be wrong at the moment it mattered most: `initPinSetupSettings()` calls `_clearStates()`, which invalidates `pinSetupStateProvider` back to `idle` (`pin_setup_provider.dart:217-226`), so re-entering the screen with an attempt still outstanding would show a form that looks ready and then refuse to send. Reading the token instead makes decision 14's re-entry behaviour fall out rather than needing to be arranged.

`_prepareToSendPin` opens the attempt **before** the biometric check, not after it, so the `await isAuthenticated()` gap is inside the lock rather than beside it.

`done` goes, and **both** of its writers go with it:

- `_sendPin` sets it at `:399` the moment `sendEncryptPin` returns true, and nothing clears it until the reply lands. That write is today's de-facto busy state — it is what disables both fields for the whole round trip — and the attempt token takes it over.
- `_done()` sets it at `:212` only for `_clearStates()` to invalidate it back to `idle` six lines later, so that write was never observable in a widget. It goes with nothing to replace it.

Its production readers — `FirstPinEnabled` (`:119`) and the `_onEnter` guard (`:314`) — read the token instead. Keeping an unread member of a sealed class would add a `switch` arm no test can reach, and `docs/TESTING.md` forbids hiding that with `// coverage:ignore`.

### 5. A mismatch keeps both PINs, the focus, and the caret

Text stays in both fields. Focus stays in the confirm field with the caret at the end of the value. The user fixes a wrong digit with backspace instead of retyping. `SecondPinNotifier.setSecondPin` already returns the state to `idle` on the first keystroke, so the message clears itself; that behaviour is kept.

### 6. A server failure keeps both PINs and unlocks both fields

Both fields re-open with their text intact and the message below the confirm field. Pressing ENABLE again retries with no retyping, because the PIN the user entered was never the problem.

### 7. The message stays fixed and translated; the server's text goes to the log only

`wallet.dart:565` carries `from.encryptPin.error` into `PinDataState.error`; `onPinData` keeps discarding it in favour of `'Error setup new PIN code'.tr()`. The reserve in decision 8 is sized against the known set of messages, and surfacing an untranslated server string of unknown length would break that guarantee. The three pre-existing messages stay distinct: mismatch, mnemonic error, biometric failure.

### 8. The desktop error message lives outside the field's fixed box, and its space is always reserved

`DPinTextField` stops taking `errorMessage` and stops setting `errorText`; it keeps `error`, which drives the red `focusedBorder` — reachable again once `errorText` is gone. `d_pin_setup.dart` renders the message itself under the confirm field, in a box of constant height sized for **two lines plus an 8 px gap**, present whether or not there is a message. The first field gets no reserve; it never shows a message.

This is `d_pin_protection.dart`'s shape (context 5) with the line count measured rather than guessed.

### 9. Focus has one owner and one trigger

- `DPinTextField` forwards its own `autofocus` parameter to the `TextField` instead of the hard-coded `true` that made both fields fight for focus at open. Only the first field passes `true`.
- `TextField` gets `selectAllOnFocus: false` explicitly, on both fields. Stating it beats inheriting it: the behaviour is then identical on every platform and independent of a Flutter default that has changed before.
- The `requestFocus()` call at `d_pin_setup.dart:214` — a side effect executed during `build` — is deleted.
- A `ref.listen(pinSetupStateProvider)` returns focus to the confirm field once, on the transition into `error`. That is the single explicit trigger replacing the implicit one.

**The request is scheduled with `addPostFrameCallback`, not issued inside the listener.** Riverpod notifies listeners synchronously from the notifier's write (`riverpod-3.4.2/lib/src/core/element.dart:903-915`), so on the busy-to-`error` transition the listener runs while the `TextField` is still built with `enabled: false`. A disabled `TextField` sets `canRequestFocus = widget.canRequestFocus && _isEnabled` (`flutter/lib/src/material/text_field.dart:1282`, re-applied in `didUpdateWidget` at `:1318`), and `FocusNode._doRequestFocus` returns without acting when that flag is false (`flutter/lib/src/widgets/focus_manager.dart:1177-1182`). Issued inline, the one explicit trigger would be a silent no-op on exactly the path it exists for. The callback runs after the rebuild that re-enables the field, and re-checks `context.mounted` first.

The idle-to-`error` transition — a mismatch — never disabled the field, so it would work either way. Both go through the same scheduled path; a rule with two arms would be a second mechanism to keep correct.

### 10. The keyboard shows the same state as the fields, button by button

Both keyboards take `enabled`, defaulting to `true`, and each button renders its own disabled appearance. The grid is not dimmed as one block. On desktop `DCustomTextBigButton(enabled: false)` already yields `ButtonStates.disabled` through `DButton`, but `DPinKeyboard`'s own `border` and `textStyle` resolvers (`d_pin_keyboard.dart:60-77`) ignore the state set and must branch on `states.isDisabled`. On mobile the `InkWell` needs `onTap: null` and its own disabled colours.

### 11. Nothing else marks progress

No spinner, no overlay. Dimmed fields and dimmed keys are the whole signal, which is what the unlock dialog does today. The one addition is text: decision 14's threshold message, which is a recovery instruction rather than an indicator of progress, and which appears only in a state that will not clear itself.

### 12. The unlock screens pass `enabled` too

`d_pin_protection.dart` and `pin_protection.dart` pass `enabled: pinProtectionState != const PinProtectionState.waiting()`. Behaviour there does not change — `onKeyEntered` already ignores keys while `waiting` (context 8) — only the appearance stops lying. Checked before deciding: the unlock flow has no Jade-specific path (`isJadeWalletProvider` is read only by `isBiometricAvailable`, which unlock never reads), and `firstLaunchStateProvider` selects nothing there but the accept button's label.

### 13. BACK stays live while an attempt is outstanding

Blocking BACK was rejected: nothing bounds the wait, so with BACK gone a wedged client turns the dialog into a room with no door. What a *late* reply then does is decision 14 — leaving BACK live is not the same as letting the reply act, and here it does not even mean the attempt is over.

### 14. One attempt at a time, and every reply is applied in full

A **setup attempt** is one send of one PIN. At most one may be outstanding. The outstanding attempt is held as a token in a `keepAlive` provider of its own — outside `pinHelperProvider`, which is `isAutoDispose: true` (`pin_setup_provider.g.dart:496`), and outside every screen-scoped provider. `_clearStates()`, `initPinSetupSettings()`, screen teardown and BACK do not touch it. Only a reply clears it, and only after decision 17's commit has succeeded. Ending the process destroys it, and destroys the client's delivery epoch with it.

**Exclusivity is what supplies identity.** The wire carries no correlation id (context 6), so nothing in a reply says which send produced it. With one attempt outstanding there is nothing to disambiguate: the reply can only belong to it. This is [ADR-0009](0009-liquid-connect-acceptance-attempt-identity.md) decision 1 reached by a different route — the attempt is still the identity, but here it is made unique rather than tagged.

**No reply is ever discarded.** A successful reply is committed in full — blob stored and protection enabled, as one operation — whatever screen is showing and whether or not the user has left. Discarding was the first design and it is wrong twice over: the encrypted blob is the only thing that can open a wallet whose protection is on, so a design that can drop it while enabling protection destroys wallets (context 7); and the client answers every request (context 6), so there is nothing to discard except an answer we asked for.

Consequently:

- **A second ENABLE while a token is outstanding sends nothing.** Re-entering setup with an attempt still outstanding shows the fields and keys dimmed and says an earlier attempt is still running, rather than presenting a form that looks ready. This is honest about the client, which would queue the second request behind the first anyway.
- **BACK does not clear the token.** Leaving a screen cannot cancel a request the client already holds. Clearing it would let a second attempt start and then let the first attempt's reply be taken for the second's — the exact failure this decision exists to prevent.
- **A reply with no token outstanding changes nothing** — not the blob, not the flags, not the page, not the form. Under context 6 it cannot happen; it is defined so that it is defined, and it is logged.
- **A late success still enables the PIN it was sent with**, after the user has left the screen, and says so. That is the price of never discarding, and it is the right price: the alternative is a stored PIN the app has no blob for.

**The timer changes the message and nothing else.** After the wait passes a threshold the copy becomes *"This is taking longer than usual. Close and reopen the app before trying again."* It does not clear the token, does not re-enable the fields and does not discard anything. It exists because the only state that produces it is a wedged client (context 6), and a wedged client will not recover on its own — while the Flutter isolate stays alive and can still say so.

### 15. Any exception on the send path is a failure outcome

`_prepareToSendPin` is `void ... async` and `_onEnter` calls it without `await`, so an exception inside it has no receiver. Two are reachable: `sendMsg` throws `ClientNotInitializedException` when the client id is zero (`wallet.dart:211-219`), and `isAuthenticated` awaits `decryptBiometric`, `decryptFallback` and the PIN dialog, any of which can throw (`wallet.dart:1651-1679`). With decision 4 opening the attempt before the biometric check, an unhandled throw would leave the token outstanding, and with it both fields and every key dimmed for the life of the process — a regression the draft introduced.

So the send path catches, logs, releases the token — nothing left the app, so nothing is owed a reply — and, after the liveness check of decision 16, sets `error`. A throw *after* the request left cannot happen: `sendMsg` is the last statement on the path, and everything that can throw runs before it.

### 16. The desktop setup screen keeps its helper alive, and the helper checks it is still alive

`pinHelperProvider` is auto-dispose. Mobile holds it up with `ref.listen(pinHelperProvider, (_, _) {})` (`pin_setup.dart:21`); the desktop screen has no equivalent and reads it only from callbacks, so its `Ref` can be disposed underneath `_prepareToSendPin`'s `await isAuthenticated()`. `DPinSetupContent` gains the same listen.

That is not sufficient on its own and is not treated as if it were. BACK during the biometric prompt unmounts the screen and disposes the provider anyway, and ADR-0009 already records that `keepAlive` does not survive an explicit `invalidate` either. So `_prepareToSendPin` re-checks `ref.mounted` after the await, before it touches any state — liveness first, then identity (decision 14), then state, which is ADR-0006 decision 2's order and ADR-0009's restatement of it.

Liveness and identity answer different questions and cannot contradict. `ref.mounted` asks whether *this helper* may still write state; the token asks whether *this reply* belongs to the attempt that is outstanding. A dead `ref` stops the send before the request leaves, so the token is released and no reply is ever owed. A live `ref` with a token outstanding is the ordinary case. The token is released on exactly the paths where the send does not happen, which is what keeps the two rules from disagreeing.

### 17. The blob and the flag are written together, and in the safe order

Three repairs to what context 7 measured, plus one operation that makes the pair inseparable in memory:

1. **`activatePinProtection(pinData)`** on the configuration notifier sets the blob, `usePinProtection: true` and `useBiometricProtection: false` in **one** `copyWith`, so one state change and one persist round carry the whole transition. `onPinData` calls it instead of `setPinData` followed by `enablePinProtection()`. The two-call shape is what let them diverge.
2. **`_setPinData` compares instead of refusing.** Its early return at `config_provider.dart:492-495` skips the write whenever *any* blob is already stored, which was added deliberately — `d57042fa`, "pin data is saved only once" — because `_writeSettings` re-runs every key on every settings change, and re-writing an unchanged blob is waste. The intent is kept and the defect removed by narrowing the condition: skip only when the stored blob **equals** the new one. A different blob is written.
3. **`_writeSettings` persists `_setPinData` before `_setUsePinProtection`.** Interrupted, that order leaves a fresh blob with protection still off, which is harmless. The present order leaves protection on beside a stale blob, which is the wallet-losing state.
4. **`disablePinProtection` clears the blob, as a second state change after the flag is off.** One fixed key order cannot be safe in both directions — enabling wants blob-then-flag, disabling wants flag-then-blob — so disabling takes two persist rounds. Interrupted between them it leaves protection off beside a blob nobody reads, which is harmless. Inside the first round the mnemonic is re-encrypted for fallback *before* the flag drops, so no window exists in which neither credential opens the wallet.

`walletPinEnable` (`wallet.dart:1035`) is deleted. It enables protection with no blob, and nothing calls it.

A single combined preferences record was rejected: it is the stronger design, but migrating four live keys sits in the unlock path of every installed wallet, and that is a decision to take on its own evidence rather than as a rider on this one.

## Consequences

- `lib/providers/pin_setup_provider.dart` is under `lib/providers/**`, so it carries **100% line and branch coverage** in the same change (`docs/TESTING.md`). `test/providers/pin_setup_provider_test.dart` exercises the removed setters in roughly fifty places and is rewritten alongside.
- `PinSetupState` loses `done` and gains nothing, leaving `idle | error(message)`; the busy fact moves to the attempt token's own provider. `pin_models.freezed.dart` is regenerated.
- `wallet.dart`'s `From_Msg.encryptPin` case stops writing configuration and only forwards (decisions 14 and 17), so it is covered by the same change.
- `lib/providers/config_provider.dart` is under `lib/providers/**` as well, so decision 17's changes carry the same 100% line and branch bar.
- **Widget tests are new work, and the parent screens carry as many branches as the leaf widgets.** `docs/TESTING.md` requires an explicit test per behavioural branch, and a keyboard that renders its own disabled state proves nothing about whether each screen hands it the right `enabled`. The matrix is:
  - **Leaf widgets** — `DPinTextField` (select-all off, no `errorText`, constant height, red border present on `error`), `DPinKeyboard` and `PinKeyboard` (each button's enabled and disabled rendering).
  - **The two setup screens**, desktop and mobile, across idle / attempt-outstanding / `error`: both fields' enabled state, the keyboard's enabled state, the message's presence and the reserve's constant height.
  - **The two unlock screens**, desktop and mobile, across `idle` / `waiting`: the keyboard's enabled state, which decision 12 introduces and nothing asserts today. `test/widgets/pin_protection_init_test.dart` covers mobile only and asserts only that mounting throws nothing (`:56-126`), so it is extended rather than relied on, and a desktop counterpart is added.
  - **The busy-to-`error` focus transition**, asserting focus lands in the confirm field with a collapsed caret at the end — the case decision 9's post-frame rule exists for.
  - **Decision 14**: a reply arriving with a token outstanding commits in full; a reply arriving with none changes no configuration, no page and no form; a second ENABLE while a token is outstanding sends nothing through the mocked wallet; BACK leaves the screen and re-entry still shows the outstanding attempt; the threshold message appears without releasing the token or re-enabling anything. Time is advanced with a fake clock, and every assertion is against public provider state, rendered output, or the outbound message the mock recorded — never against the token's number.
  - **Decision 15**: a thrown authentication and a thrown send each release the token and set `error`, and the form is usable again afterwards.
  - **Decision 17**: rebuild the configuration provider over the same `SharedPreferences` and assert what survived. A new blob replaces an old one; disabling clears the blob and never leaves protection on without one; and the enable transition is one state change, asserted by listening to `configurationProvider` and counting emissions of the pair, not of an internal field.
  - **The measurement behind decision 8** becomes a test rather than a scratch file: the reserve is at least as tall as the tallest message across every locale in `assets/translations/`, laid out in the real Roboto faces.
- `selectAllOnFocus: false` is passed explicitly, so its test needs no `testOn: 'windows'` gate. Asserting the *unfixed* default would have needed one.
- The mobile `PinTextField` keeps its `errorMessage` parameter — `pin_protection.dart:151` still supplies it. Decision 8 removes the parameter from the **desktop** widget only.
- The mobile setup screen keeps its `SizedBox(height: error ? 160 : 61)`. It grows outward and a `Spacer` absorbs the growth, so the field never shrinks and the keyboard never moves. Not a defect; left alone.

## What this ADR does not settle

- **A recovery from a wedged client that is not an app restart.** Decision 14's timer says to restart and nothing more. It is the honest answer while `process_encrypt_pin` blocks the whole worker loop with no read timeout (context 6), because there is nothing left in the client to ask. The real repair is a timeout on the `ureq` agent in `sideswap_rust`, which would turn a hang into an ordinary error reply — a change in another repository, on evidence this ADR does not hold.
- **A progress indicator.** Decision 11 matches the unlock dialog. If either screen ever gets one, both should.
- **A single combined preferences record for the blob and the flag.** Decision 17 makes the pair safe with ordering and a two-step disable. One record would make it safe by construction, and it needs a migration of four live keys in the unlock path of every installed wallet. Recorded so the ordering rule is read as a deliberate second-best rather than as the end of the question.
- **`_setPinData`'s remaining shape.** Decision 17 removes its refusal to overwrite. It does not revisit the field-completeness guard beside it, which treats `hmac` as optional — matching the proto, where `hmac` is `optional` and the other three are `required` (`sideswap.proto:485-495`).
- **The mobile error box's `160` and `61`.** Magic numbers with no measurement behind them. They are not misbehaving, so they are not touched.
- **The competing focus mechanisms in the setup screens.** Decision 9 removes the build-phase side effect and gives the error transition an explicit owner. It does not rework the focus-node listeners that write `pinFieldState` back through `Future.microtask`, nor decide whether `pinFieldState` should be derived from focus rather than driving it.
- **The PIN keyboard has no owner, and one key press can be counted twice.** Every screen that uses a PIN keyboard subscribes to `pinKeyStream` in a `useEffect` that returns no cleanup — `d_pin_setup.dart:92-98`, `pin_setup.dart:27-34`, `d_pin_protection.dart:51-57`, `pin_protection.dart:104-110`. The stream is a `PublishSubject`, which delivers to every listener, and `test/widgets/pin_protection_init_test.dart:99-126` establishes that two unlock bodies can be mounted at once. In that overlap one tap is appended twice. **Pre-existing, not introduced here, and not repaired here**: decision 10 gives the keyboard an `enabled` flag and decision 12 passes it from two more screens, and neither adds a subscriber or changes when one is made. Recorded rather than fixed because the repair is a change of ownership — a direct `onKey` callback in place of the global broadcast — with its own blast radius across four screens. Tracked as #247.

## Review notes

Three passes, run in the order the driver asked for: devil's advocate on v1, adversarial on v2, and one consultation the adversarial pass forced. Findings from them that **changed** this ADR, rather than confirming it. Each was re-verified at its citation before acceptance; the ones that did not survive verification are listed too, because a future reader will otherwise rediscover them.

### Devil's advocate, on v1

- **The one explicit focus trigger would have been a silent no-op.** The draft issued `requestFocus` inside the `ref.listen` body. Riverpod notifies synchronously and a disabled `TextField` refuses focus, so on `waiting -> error` — the only path the trigger exists for — nothing would have happened. Decision 9's post-frame paragraph exists because of this, and the citations in it are the ones the finding named, re-read.
- **`done`'s account was factually wrong.** The draft described one writer and called it unobservable. `_sendPin` is a second writer (`:399`) and it is precisely the state rendered for the whole round trip. Decision 4 now replaces both writes explicitly and says which one the attempt token inherits. The decision did not change; its stated reason did, and a wrong reason is what a later reader would have acted on.
- **A late reply can turn PIN protection on with the wrong PIN.** The draft's decision 13 called the consequence a surprising navigation. It is worse: `wallet.dart:573` stores the data and `onPinData` enables protection, so an abandoned attempt's reply can enable a PIN the user replaced. Decision 14 exists because of this finding, and the finding also killed the cheap version of it — a `waiting` check does not discriminate between two attempts, only between an attempt and none.
- **The glossary forbade what the ADR does.** `CONTEXT.md` said never to share a state name between a mismatch and a server failure; the ADR shares one. Resolved against the glossary, not the ADR: decisions 5 and 6 answer the two identically, so a separate variant would add a `switch` arm that no branch reads differently and that 100% branch coverage would then demand a vacuous test for. The glossary entry now states the shared resting state and the different route into it.
- **The test list mistook leaf coverage for branch coverage.** Testing that a keyboard renders a disabled key proves nothing about whether four screens hand it the right flag. The consequences section now names the parent matrix, and records that `pin_protection_init_test.dart` is mobile-only and asserts only that mounting throws nothing.
- **`pinHelperProvider` is auto-dispose and desktop does not hold it up.** Raised as an unconfirmed suspicion; confirmed at `pin_setup_provider.g.dart:496` against `pin_setup.dart:21`. Decision 15 exists because of it.

- **Accepted as true, deliberately not fixed:** the uncancelled `pinKeyStream` subscriptions. Real, pre-existing, and recorded above under what this ADR does not settle. It does not make decision 12 wrong — the finding's own claim was that decision 12 "extends the shared keyboard", and what decision 12 passes is a rendering flag, not a subscriber.
### Adversarial, on v2

- **Two records of one fact.** v2 read busy-ness from `PinSetupState.waiting` in decision 1 and held the attempt token in a `keepAlive` provider in decision 14, with nothing keeping them equal — the defect context 1 exists to condemn, reintroduced two decisions later. Re-entering the setup screen would have shown a ready-looking form that then refused to send, because `_clearStates()` resets the state and does not touch the token. Decision 4 now removes `waiting` from the model entirely and makes the token the single source. This reverses part of an earlier answer in the design session, deliberately.
- **Decision 3 had nowhere to live.** With `secondPinEnabled` derived, "the field closed, so clear its text" has no transition to hang on. The decision now names `_onBackspace` as the site, which is where the clear already is.
- **The `_setPinData` guard was deliberate, not an oversight.** It arrived with `d57042fa` to stop redundant writes. v2 removed it on inference. Decision 17 item 2 now narrows it rather than deleting it, which keeps the original intent.
- **Decision 14 invented an identity the wire does not carry.** v2 said `onPinData` compares "the reply's captured id" — and `onPinData` receives only a `PinDataState`. `To_EncryptPin` carries `pin` and `mnemonic`; `From_EncryptPin` carries `error` or `data` (`sideswap.pb.dart:2821`, `:5742`). The decision as written could not be implemented. It is replaced by exclusivity, which supplies identity without a tag.
- **The new `waiting` state had unhandled exceptional exits.** `sendMsg` throws when the client id is zero; `isAuthenticated` awaits three things that can throw; `_prepareToSendPin` is unawaited. v2 would have stranded a dimmed form on any of them. Decision 15 exists because of this.
- **Confirmed and recorded, not changed:** no production reader is lost by moving `setPinData` — `pinDataState` is read only by `sendDecryptPin` (`wallet.dart:1754`) — and removing `done` breaks no route, listener or exit state. The recounts held: nine locale files, 388 px of content, 46 setter call sites in the provider test.

### Consultation, after the adversarial pass

The first repair for the identity hole was a timeout that **discarded** a late reply. The driver rejected it on the grounds that throwing away the blob could lock the wallet, and asked for the client to be checked before anything else was decided.

- **The stated reason was wrong; the instinct was right.** An atomic discard — no blob *and* no protection — leaves `usePinProtection` false and the wallet openable through `mnemonicEncrypted` (`wallet.dart:1049-1075`, `:1651-1679`). But the state the reasoning was reaching for is real and reachable by three other routes, and it is what context 7 now records. The rule that came out of it — the blob and the flag are written together or not at all — is decision 17.
- **Checking the client removed the need for the timeout entirely.** `process_encrypt_pin` answers every request exactly once, and the worker loop is single-threaded, so replies cannot be lost, reordered, or overlapped (context 6). A design defending against a lost reply was defending against nothing. What the check *did* find is that a hung PIN server wedges the whole client, which is why decision 14's timer says "restart the app" and does nothing else.
- **The consultation also surfaced the three storage defects**, which the driver then asked to be repaired here rather than deferred. Decision 17.

### Not accepted

- **Not accepted: that decision 8's measurement has no artifact.** The measurement was run before the ADR was written, with `TextPainter` against the real `assets/fonts/Roboto/` faces over every file in `assets/translations/`. The scratch file was deleted, which is the reviewer's actual objection and a fair one; the consequences section now makes the measurement a test in the change rather than a number in a document.

## Related

- [ADR-0006](0006-liquid-connect-acceptance-gate.md) — decision 2's order, liveness then identity then state, which decision 15 restates for this flow.
- [ADR-0008](0008-wallet-unlock-locked-screen.md) — the unlock flow, whose constant-height error reserve this ADR copies. Its `PinProtectionState.waiting()` stays where it is: unlock has no second record of being busy, so the objection decision 4 raises against a `waiting` member does not apply there.
- [ADR-0009](0009-liquid-connect-acceptance-attempt-identity.md) — decision 14 is its decision 1 applied to PIN setup: the attempt is the identity, not the screen. It also records why `keepAlive` is not a lifetime guarantee, which decision 15 depends on.
- #245 — decision 17 and the `walletPinEnable` deletion, split out because it damages users on the shipped build.
- #246 — decisions 1-16, blocked on #245.
- #247 — the keyboard-ownership defect this ADR records but does not repair.
- `sideswap_rust` — `sideswap_client/src/worker.rs` and `sideswap_common/src/pin.rs`. Decision 14 depends on properties of that code, restated in context 6. A change to the worker's threading, or to `process_encrypt_pin`'s reply discipline, invalidates the exclusivity argument and should bring this ADR back open.
- [ADR-0011](0011-focus-node-ownership.md) — focus-node ownership. Decision 9 here is consistent with it and does not amend it: `DPinTextField` takes a `FocusNode?` it only forwards, which is ADR-0011 decision 2.
