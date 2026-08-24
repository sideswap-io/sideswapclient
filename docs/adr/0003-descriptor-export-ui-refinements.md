# ADR-0003 — Descriptor export UI refinements

- **Status:** Accepted
- **Date:** 2026-07-23
- **Branch:** `descriptors-export`
- **Driver:** on-device review by the user of the shipped descriptor-export feature (ADR-0002, five merged PR slices). Seven UI/UX corrections, grilled into a decision tree.
- **Relationship to ADR-0002:** this ADR **supersedes ADR-0002 decision 4** (QR is removed) and **refines ADR-0002 decision 2** (desktop layout is now content-sized, not "scrollable or grown to a fixed height"). All other ADR-0002 decisions stand.
- **Reviewed by:** two Codex passes (devil's advocate, then adversarial) — see the end of this file.

## Context

The watch-only descriptor export feature (ADR-0002) shipped across PR slices #149–#158. Reviewing it on-device, the user asked for seven changes. Two of them were reported as "the code says X but I see Y" — and were **real rendering bugs** whose source *looked* correct, so the root cause is recorded here to stop a future reader from "reverting the fix back to the broken-but-plausible code."

The affected surfaces:
- **Settings screens** — `lib/screens/settings/settings.dart` (mobile), `lib/desktop/settings/d_settings.dart` (desktop).
- **Descriptor screen** — `lib/screens/settings/wallet_descriptors_screen.dart` (mobile, `WalletDescriptorsScreen`), `lib/desktop/settings/d_wallet_descriptors.dart` (desktop, `DWalletDescriptors`).
- **Copy/share confirmation dialog** — `showDescriptorCopyConfirmationDialog` in `wallet_descriptors_screen.dart`, a single function **shared by both platforms** (the desktop screen imports and calls it).

Colour vocabulary used below (`lib/common/sideswap_colors.dart`): **`brightTurquoise` `#00C5FF`** is the app's dominant CTA-button background (44 call sites; it is the desktop filled-button default in `lib/desktop/theme.dart`). **`chathamsBlue` `#135579`** is a darker navy used for surfaces (app bars, the descriptor preview box). **`blumine` `#1C6086`** is the confirmation dialog's background.

## Decisions

### 1. "Export watch-only descriptors" moves directly above Network Access

The settings entry moves from its current position (above the security rows) to sit **immediately above the Network Access row** — one rule that holds for every wallet type:

- **Desktop — all wallet types:** Export is the row **immediately above Network Access**. For a non-Jade wallet the PIN protection row sits directly above Network, so this places Export **directly below PIN** (the user's original "below PIN protection" ask) *and* directly above Network. For a Jade wallet there is no PIN row (`!isJade`-gated) — Export still sits directly above Network. The **"Jade device" row is left where it is** (late in the list, after Language: `d_settings.dart:161`); Export is deliberately *not* tied to it.
- **Mobile — all wallet types:** **move** (do not duplicate) the existing Export widget to sit **immediately after the complete biometric/PIN `Column`**. The positive anchor is "after the security column," *not* "before Network Access" — Network is flavor-gated (`if (FlavorConfig.enableNetworkSettings)`, `settings.dart:192`) and may be absent; when present it follows Export, otherwise Language does. For non-Jade this places Export below PIN; for a Jade wallet where both security rows collapse to `SizedBox()` (`settings.dart:131-157, 169-187`), the order is `About us → Export → (Network Access if enabled, else Language)`.

Rationale: the rule is a positive anchor — **desktop: directly above the (unconditional) Network Access row; mobile: directly after the biometric/PIN column** — which satisfies the "below PIN protection" intent wherever a PIN row exists, keeps Export in a stable position, and never leaves it orphaned for Jade (ADR-0002 decision 3 requires export to stay available for Jade — its *primary* use case). It deliberately does **not** group Export into a top-of-list "security cluster": on desktop Jade the only security-analog row ("Jade device") is late, and anchoring Export to Network instead of chasing that row is the honest, minimal choice (Codex devil's-advocate correction). The old Export instance is removed in the same edit — no duplication.

### 2. Desktop settings dialog is content-sized, not fixed-height (refines ADR-0002 decision 2)

`DSettings` used a fixed `SizedBox(height: 582)` wrapping `Expanded(SingleChildScrollView(...))` with a scrollbar. The user wants all rows visible at once, no scrollbar.

A **fixed height increase was rejected**: the visible row set depends on wallet type (non-Jade shows recovery + PIN; Jade shows neither but adds "Jade device"), so any single hard-coded height leaves empty space for one wallet type and is re-broken by every future row.

**Decision:** make the content **size to itself**, but via the specific restructure below — *not* a bare `mainAxisSize.min`. The current layout is `Center → SizedBox(height: 582) → Column → [Expanded(SingleChildScrollView(rows)), pinned Delete row]` (`d_settings.dart:51-55`). Naively dropping the fixed height and setting the outer `Column` to `mainAxisSize.min` **crashes**: an `Expanded` inside an unbounded-height `Column` throws "RenderFlex … unbounded height" (the `DContentDialog` shell is itself `mainAxisSize.min` and lays its content out non-flex, so it supplies no bounded height — corrected after the Codex adversarial pass). The correct minimal restructure:

- Replace `SizedBox(height: 582)` with a body `ConstrainedBox(maxHeight: 582)` (the dialog's `maxHeight: 678` minus the ~96px title block; the exact cap is measured at implementation time).
- Set the inner `Column(mainAxisSize: MainAxisSize.min)`.
- Replace `Expanded(child: SingleChildScrollView(...))` with `Flexible(fit: FlexFit.loose, child: SingleChildScrollView(...))`.
- Keep the Delete-wallet row as the second, non-flex child so it stays pinned.

(A cleaner but wider alternative is to make `DContentDialog` allocate its content through `Flexible`, removing the need to duplicate the title-height math.) Result: the dialog shrinks to its natural content height per wallet type; the scroll view engages **only** if a row set exceeds the cap. Whether the normal / `--localEndpoint` row sets fit without scrolling is an empirical, measured outcome at implementation — if a realistic set still exceeds the cap, the dialog's `maxHeight` is raised rather than reintroducing a permanent scrollbar.

### 3 + 4. The copy/share confirmation dialog conforms to app dialog conventions

`showDescriptorCopyConfirmationDialog` is a raw Material `AlertDialog` shown via `showDialog`, **shared by mobile and desktop**. Two defects:

- **Width (desktop):** the dialog has no width constraint, so its long single-sentence warning stretches it to nearly the full window width. Every other app dialog caps at **`maxWidth: 580`** (`DContentDialog` standard; the recovery-phrase dialog and the descriptor screen both already use it). Fix: set **`AlertDialog(constraints: const BoxConstraints(maxWidth: 580))`** — the `AlertDialog.constraints` property caps the **dialog shell** and is passed through to `Dialog` (verified against `dialog.dart:85,261`). A `ConstrainedBox` on `content` does **not** achieve this — it only bounds the body, leaving the shell ~628px and the title/actions unconstrained (corrected from an earlier draft after the Codex pass). On mobile 580 exceeds the device width, so the cap is a harmless no-op there — one fix covers both platforms.
- **Invisible actions:** `Cancel` and `Copy` are bare `TextButton`s with no style, so they inherit `colorScheme.primary` (`chathamsBlue #135579`) as foreground, rendered on the dialog's `blumine #1C6086` fill — navy text on near-identical navy, ~1:1 contrast. Fix: give **both** buttons a filled **`brightTurquoise`** background with white text.

**Decision:** keep the shared `AlertDialog` (do not split into per-platform dialogs); cap it with `AlertDialog(constraints: BoxConstraints(maxWidth: 580))`; keep Cancel and Copy as the two `actions` entries — Material lays `actions` out in an `OverflowBar` that stacks them vertically on a narrow width, so two filled buttons will **not** overflow (do not replace `actions` with a custom `Row`, which would reintroduce that risk); style both as filled `brightTurquoise` + white. Dialog background stays `blumine`.

Note: two equally-weighted filled buttons for a Cancel/Confirm pair is deliberate here (the user's explicit call) — the priority is that both are legible against the blue dialog fill.

### 5. Both QR codes are removed; the preview uses `MiddleEllipsisText` (supersedes ADR-0002 decision 4)

ADR-0002 decision 4 specified "copy + QR everywhere." **The QR is removed** from both screens. Concretely (cleanup list completed after the Codex pass):

- Delete the `DescriptorQrCode` class (`wallet_descriptors_screen.dart:228-246`) and both its instantiations (mobile `:171`, desktop `d_wallet_descriptors.dart:291`), plus the `qrKey` parameter plumbing on both sections (mobile `:116,:126`, desktop `:217,:229`) and the spacers left where the QR sat.
- Remove the `qr_flutter` import from the two descriptor files **and** from both widget-test files (`test/widgets/wallet_descriptors_screen_test.dart:7`, `test/widgets/d_wallet_descriptors_test.dart:10`); delete the QR-payload assertions in both tests (`DescriptorQrCode` / `QrImageView`, mobile test `:130-147`, desktop test `:157-173` — these implement ADR-0002 decision 8's "QR carries the exact descriptor string as payload").
- **Keep `qr_flutter` in `pubspec.yaml`** — it is still used by the receive/peg screens; only the descriptor files stop importing it.

**Why the QR went:** a watch-only wallet descriptor (~230 chars) is loaded into desktop software (LWK and similar) by **copy/paste**, not by scanning a phone screen with a camera. The QR added vertical bulk and a white scan card to a screen whose real workflow is "read the label, press Copy." Removing it makes the two descriptors fit without scrolling and removes a code path (and its tests) that served a workflow nobody uses.

The descriptor preview `Text` (`maxLines: 1`, tail `TextOverflow.ellipsis`) is replaced with **`MiddleEllipsisText`** (`lib/common/widgets/middle_elipsis_text.dart`), which truncates in the middle (`ct(slip77(ab…xyz)`) so both the descriptor's script-type prefix and its tail stay visible — more useful than showing only the head. It is kept inside the existing `chathamsBlue` box and the `Directionality(TextDirection.ltr)` wrapper (the LTR force from ADR-0002 decision 4 remains necessary under RTL locales), styled 14px white, single line.

### 6. Desktop descriptor Copy button matches the copy-mnemonic button — and stops stretching

The per-section desktop Copy button was reported as "wide and stretched," yet the source (`DButton` inside `Align(alignment: Alignment.centerRight)`) *looks* narrow. **Root cause (corrected after the Codex pass):** `DButton` itself imposes no width (`d_base_button.dart`, `d_button_theme.dart`). The stretch comes from the button's **child** `Row` (`d_wallet_descriptors.dart:322`), which has no `mainAxisSize` and so defaults to `MainAxisSize.max`: wrapped in `Align(centerRight)` it is handed a finite (bounded) loose maximum and fills it, so the button renders full-width. The copy-mnemonic button (`d_settings_view_backup.dart`) is narrow because it sits in `Row(mainAxisAlignment: MainAxisAlignment.end, [DButton])`, which hands the `DButton` **unbounded** horizontal constraints — the inner max-`Row` then has nothing to fill and shrinks to content. Two fixes work: **(a)** wrap in an outer `Row(mainAxisAlignment.end)` like copy-mnemonic (chosen — matches the prior art exactly); or **(b)** set the inner `Row(mainAxisSize: MainAxisSize.min)` and keep `Align`.

**Decision:** replace `Align(centerRight, DButton)` with `Row(mainAxisAlignment: MainAxisAlignment.end, [DButton])` (fixes the stretch, right-aligns like copy-mnemonic — **not** centered, resolving the "wyśrodkowany" ambiguity in favour of the actual copy-mnemonic layout); swap the Material `Icon(Icons.copy)` for the SVG `assets/copy3.svg` used by copy-mnemonic; and give it a `brightTurquoise` fill + white text. The blue fill is a deliberate divergence from copy-mnemonic's neutral `DButton` colour, chosen for consistency with decisions 4 and 7 (all descriptor actions are the same blue).

**Disabled-state caveat (Codex adversarial correction):** the desktop copy button is focus-gated (`onPressed: null` when the window is unfocused — ADR-0002 decision 4). The blue must be applied via a **state-aware** filled style — the desktop theme's `filledButtonStyle` already resolves to `brightTurquoise` when enabled and a dimmed colour when disabled (`d_button_theme.dart`, `theme.dart:630`) — **not** an unconditional `ButtonState.all(brightTurquoise)`, which would paint the disabled (unfocused) button as if it were still enabled. Prefer routing the button through the existing filled-button style over hard-coding the colour.

### 7. Mobile Share/Copy buttons actually right-align, and turn blue

The mobile actions were reported as left-aligned despite the code saying `Wrap(alignment: WrapAlignment.end)`. **Root cause:** `WrapAlignment.end` only distributes children within the `Wrap`'s own width, but a `Wrap` shrink-wraps to its content and the parent `Column(crossAxisAlignment: CrossAxisAlignment.start)` pins that content-width block to the left — so `WrapAlignment.end` has no free space to act on and the buttons sit left.

**Decision:** wrap the actions in `Align(alignment: Alignment.centerRight)` (mirroring the desktop pattern) — or give the `Wrap` full width — so the block genuinely right-aligns; keep the Share→Copy order. Replace the transparent `OutlinedButton.icon` pair with **filled** buttons: `brightTurquoise` background, white icon + label.

## Supersession / refinement summary

| ADR-0002 item | This ADR |
|---|---|
| Decision 4 — "copy + QR everywhere, share on mobile" | **Superseded** — QR removed (decision 5); copy/share/LTR retained; preview now `MiddleEllipsisText` |
| Decision 4 — desktop copy focus-gate + button | Retained; button restyled (decision 6) |
| Decision 2 — desktop dialog "scrollable or resized to fit" | **Refined** — content-sized (`mainAxisSize.min`) with scroll+`maxHeight` as safety net only (decision 2) |
| Decision 2 — settings entry present on both platforms | Retained; entry **repositioned** — desktop: directly above Network Access; mobile: directly after the biometric/PIN column (decision 1) |
| Decision 8 — QR payload test in the test surface | **Removed** with the QR (decision 5) |

## Test surface changes

- **Removed:** the `DescriptorQrCode` / `QrImageView` payload assertions and their `qr_flutter` imports in **both** widget-test files (`test/widgets/wallet_descriptors_screen_test.dart`, `test/widgets/d_wallet_descriptors_test.dart`) — this is ADR-0002 decision 8's QR-payload test.
- **Updated / added (behavioural branch per `docs/TESTING.md`):**
  - Settings: on **desktop**, the export entry renders **immediately above Network Access** for both wallet types (non-Jade: directly below PIN; Jade: "Jade device" stays late and Export is **not** asserted relative to it). On **mobile**, export renders immediately after the biometric/PIN column, followed by Network Access (or Language when Network is flavor-disabled). Export is still disabled when `walletDescriptorsProvider` is `null`.
  - Desktop sizing (decision 2): assert the software vs Jade dialogs shrink to different natural heights; the normal and `--localEndpoint` row sets produce zero scroll extent; an artificially taller row set scrolls while the Delete-wallet row stays pinned; and no flex/overflow exception is thrown. The existing `test/widgets/d_settings_test.dart` currently asserts the local-endpoint case *scrolls* — it is updated to the new content-sized behaviour.
  - Descriptor screen: no QR widget is present; the preview is a `MiddleEllipsisText` carrying the full descriptor string; still wrapped LTR under an RTL locale (`ar`).
  - Confirmation dialog: Cancel and Copy are present and legible (filled style, not bare `TextButton`); the confirm path returns `true`, cancel/dismiss returns `false`/`null` (unchanged behaviour, restyled surface).
  - Desktop Copy button and mobile Share/Copy buttons: the alignment fixes are layout/visual and are covered by widget-tree assertions on the wrapping `Row`/`Align` where practical; the colour/icon changes are visual-only.
- These are UI-surface changes; no provider logic changes, so `docs/TESTING.md`'s 100% provider-coverage gate is unaffected.

## Out of scope, deliberately

- No change to `CONTEXT.md` — these are UI/visual decisions and introduce no new or altered domain term.
- No change to the access gate, the descriptors provider, navigation, or the late-Login race (ADR-0002 decisions 1, 3, 6, 9 stand).
- `brightTurquoise` vs `chathamsBlue`: buttons use `brightTurquoise` (the CTA convention); the descriptor preview box keeps `chathamsBlue` (a surface, not a button).

## Codex review log

**Pass 1 — devil's advocate (source-verified).** Five findings, all confirmed against source and folded in:
1. Decision 6 root cause was overstated — the stretch is the button's child `Row(mainAxisSize: max)` filling `Align`'s bounded width, not `DButton` itself. Rationale corrected; the chosen outer-`Row` fix still holds (an inner `mainAxisSize.min` is the alternative).
2. Decisions 3+4 — a `maxWidth` on the dialog *content* does not cap the shell (~628px). Corrected to `AlertDialog(constraints: BoxConstraints(maxWidth: 580))`; buttons kept as `actions` (Material `OverflowBar` prevents narrow-width overflow).
3. Decision 1 — mobile placement was underspecified and the desktop "security cluster" rationale was misleading (Jade's row is late). Rewritten to the single rule "immediately above Network Access"; user chose to leave "Jade device" in place.
4. Decision 5 — cleanup list was incomplete: added the `qrKey` plumbing and both widget-test files; recorded that `qr_flutter` stays in `pubspec.yaml` (used elsewhere).
5. Decision 7 and the `MiddleEllipsisText` swap were attacked and **held up** — the `Wrap`→`Align(centerRight)` fix and the bounded-width guarantee are correct.

**Pass 2 — adversarial, on the revised tree (source-verified).** Five findings, all confirmed and folded in:
1. **Critical** — decision 2 as first revised would crash: dropping `SizedBox(582)` leaves `Expanded` in an unbounded-height `Column`. Rewritten with the concrete `ConstrainedBox(maxHeight) + mainAxisSize.min + Flexible(loose)` restructure and the pinned Delete row.
2. **High** — decision 1's "above Network Access" is undefined on mobile when Network is flavor-disabled (`settings.dart:192`). Re-anchored positively to "after the biometric/PIN column," with move-not-duplicate made explicit.
3. **High** — the test-surface section still asserted "Export below Jade device," contradicting the revised decision 1. Test assertions rewritten to "Export immediately above Network Access"; summary row corrected.
4. **Medium** — decision 2 lacked a behavioural test and the existing `d_settings_test.dart` asserts the old scroll behaviour. Added sizing/scroll tests and flagged the existing test for update.
5. **Medium** — an unconditional `brightTurquoise` on the focus-gated desktop copy button would break its disabled visual. Added the state-aware-style caveat (decision 6).

**Held up under pass 2:** `AlertDialog(constraints: maxWidth: 580)` applies (no competing `dialogTheme`/`DContentDialog` wraps the raw `showDialog`); the QR cleanup scope is complete (no route/golden/shared-key-constant references beyond the two production files and two widget tests).
