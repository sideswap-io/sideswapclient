# ADR-0001 — Peg-in copy refresh and the instant-credit zero state

- **Status:** Accepted
- **Date:** 2026-07-14
- **Branch:** `pegin-copy-update`, based on `fixes-14.07.26` (a new branch was **explicitly requested** by the user; `AGENTS.md` otherwise forbids creating one unasked)
- **Driver:** appdev handover from Pavel (`tasks/appdev_pegin_release.md`, points 1–2) plus the translation patch `pegin_strings_all_languages_rebased.patch` (9 locales)
- **Reviewed by:** two adversarial Codex passes. Pass 1, devil's advocate (session `019f619d`) — findings 1–4 folded in; finding 5 (branch policy) rejected as a false positive, since the user explicitly asked for the branch. Pass 2, adversarial (session `019f61a8`) — **falsified decision 3 outright** (rewritten below) and one test-isolation defect; it independently confirmed decisions 1, 2, 4, 6 and 7 against source.

## Context

The peg-in engine is changing. The user-facing copy is rewritten to describe the new rules: **instant credit** after 2 Bitcoin confirmations up to a limit, **up to 103 confirmations** above it, a flat **300-sat** network fee. The old copy's "6-hour re-quote", "7-day-old address" and flat "102 confirmations" rules are gone.

A translation patch delivers the new strings for all nine locales and applies cleanly. What it does **not** deliver is the Dart change the new copy assumes: a distinct screen state for when the *instant credit limit* is zero. Today a zero limit renders as "For peg-ins below **0.0 BTC**…" — the nonsense line the community complained about.

The peg-in explanatory copy exists twice, near-identically copy-pasted: `PegInDescription` (mobile, `lib/screens/receive/widgets/peg_in_widget.dart:235`) and `DPegInDescription` (desktop, `lib/screens/pegs/d_peg_in_out.dart:341`).

Terms used here are defined in [`CONTEXT.md`](../../CONTEXT.md).

## Decisions

### 1. The third bullet needs no rewiring

The first version of the patch turned `PEGIN_RELEASED_END` into `" {} BTC."` — a placeholder — which would have collided with the existing `PEGIN_LESS_AMOUNT` span and rendered a literal `{}` plus a doubled amount. The patch was corrected before implementation: `PEGIN_RELEASED_END` is now `"."`, so the existing composition (`PEGIN_RELEASED` + `PEGIN_LESS_AMOUNT(limit)` + `PEGIN_RELEASED_END`) renders correctly with no Dart change:

> • Network fee: 300 sats. Instant credit limit: 0.1 BTC.

We keep the limit in the third bullet rather than taking Pavel's optional "drop the amount, render `PEGIN_FEE_LINE` there instead" route, because the bullet as-is matches the resulting-screen spec that webdev and the FAQ are written against.

### 2. The zero-state rule lives in the repository, as a boolean

`AbstractPegRepository` gains `bool instantCreditAvailable()`, returning `pegSubscribedValues.pegInWalletBalance > 0` — plus the readiness flag from decision 3.

**Why not let the widget check the number?** `pegInWalletBalance()` returns a *formatted, locale-aware String* (`extractValue` → `amountToMobileFormatted`), which cannot be reliably compared against zero — `'0'`, `'0.00'`, `'0,00'` and `''` (asset not loaded) are all reachable. The raw int is not otherwise exposed.

**Why a bool, not the raw int?** The rule ("instant credit exists iff the limit is above zero") is domain logic and belongs in one place, not duplicated across two screens. Providers are the one part of this repo under a 100 %-coverage gate, so the rule lands where it is cheapest to test.

**Only one implementer exists** (`PegRepository`, `pegs_provider.dart:43`). `MockPegRepository` (`test/providers/swap_providers_test.dart:43`) is a `mocktail` `Mock`, so a new abstract method does not break it.

### 3. "Not loaded yet" is a third state that renders nothing

`PegSubscribedValues` starts at `pegInWalletBalance = 0` (Freezed `@Default(0)`); the real value only arrives with `From_SubscribedValue` (`pegs_provider.dart:225`). *Not loaded* and *genuinely zero* are therefore indistinguishable by value — so we distinguish them by a flag:

```dart
// PegSubscribedValues
@Default(false) bool pegInWalletBalanceLoaded,
```

set to `true` inside the existing `if (subscribedValue.hasPegInWalletBalance())` guard (`pegs_provider.dart:232`). `AbstractPegRepository` exposes it. **Until it is true, the info block renders nothing at all.**

**This reverses an earlier decision in this ADR's own drafting, and the reason is worth recording.** The two-state design ("treat not-loaded as zero") was chosen on the argument that a third state would need a *loading* string, and no such key exists in any of the nine locales. That argument was simply wrong: the third state renders **nothing**, and nothing needs no translation.

The two-state design was then falsified outright by the second adversarial pass. Gating on the peg-in *address* is not enough, because the address and the balance arrive in **independent** server messages — `From_Msg.peginWaitTx` (`wallet.dart:424`) and `From_Msg.subscribedValue` (`wallet.dart:818`). Whenever the address wins the race, the zero state flashes — **on mobile too**, despite its `CircularProgressIndicator` gate (`peg_in_widget.dart:35-37`). The `loaded` flag is the only signal that actually tracks the thing being displayed.

It also subsumes the worse, *permanent* case: an offline desktop session, where `DPegInDescription()` renders unconditionally (`d_peg_in_out.dart:164`) while `setActivePage` early-returns on `!serverConnected` (`pegs_provider.dart:70`), so no subscription ever arrives. Under the two-state design that session would have shown "Instant credit temporarily unavailable" **forever**. Under this one it shows nothing — as it should, and as it already does for the address.

**Superseded:** an interim decision to gate `DPegInDescription` on `recvAddress != null`. The `loaded` flag is a strictly more precise signal for the same failure, so the address gate is dropped rather than kept alongside — one readiness rule, one branch to test.

**Residual dependency, called out for Pavel:** if the new engine ever *omits* `peg_in_wallet_balance` in a state where instant credit is in fact available, this design shows "temporarily unavailable" wrongly and permanently. **Correctness hinges on the server sending that field whenever instant credit is available** — confirm against the new engine.

### 4. The exact composition of each state

`balance == 0` and `serverFeePercent == 0` are **independent** conditions; a zero limit implies nothing about the fee. The block is therefore:

| Row | Not loaded | Instant credit available | Instant credit unavailable |
|---|---|---|---|
| `PEGIN_1STLINE` (address auto-generated) | — | shown | **shown** — true regardless |
| `PEGIN_2NDLINE` (unique address, revisitable) | — | shown | **shown** — true regardless |
| `PEGIN_CONVERSION_RATE` | — | shown iff percent ≠ 0 | **shown iff percent ≠ 0** — own independent rule |
| `PEGIN_LESS*` / `PEGIN_GREATER*` / `PEGIN_RELEASED*` (3 amount bullets) | — | shown | hidden |
| `PEGIN_INSTANT_UNAVAILABLE` | — | hidden | shown |
| `PEGIN_FEE_LINE` | — | hidden | shown |

The not-loaded column is empty by construction: the widget returns early (decision 3), so *nothing* renders — not an empty bullet list, not a placeholder.

The 300-sat fee is disclosed in **both** live states — via the third bullet when instant credit is available, via `PEGIN_FEE_LINE` when it is not. The two are not redundant with each other; each covers the state the other omits.

### 5. The copy is extracted into one shared widget

New `PegInInfoLines` owns the whole bulleted block and the zero/non-zero branch. Both `PegInDescription` (mobile) and `DPegInDescription` (desktop) render it; their containers (padding, background) and bullet spacing (8 px mobile vs 11 px desktop) stay with the callers, passed in as parameters.

This kills the copy-paste, puts the new branch in exactly one place, and makes it testable by a small widget test instead of two heavyweight screen tests.

### 6. The conversion-rate row: one formula, hidden at zero

The shared widget computes **`100 - pegInServerFeePercent`, and hides the row when that percent is 0.** It reads `pegInServerFeePercentProvider` directly and looks at neither `swapType` nor `swapDeliverAsset`.

This is the only formula that makes sense for a block that talks exclusively about peg-in, and it is what **both platforms already compute in practice**:

- Desktop branches on `swapType` (`d_peg_in_out.dart:351`), but `DPegInDescription` only ever renders inside `DPegIn`, which only renders when `swapType == pegIn` (`d_peg_in_out.dart:60-61`) — the peg-out branch is **dead**.
- Mobile branches on `swapDeliverAsset.assetId == liquidAssetId` (`peg_in_widget.dart:245-250`), but on the *receive peg-in* screen the delivered asset is BTC, so it takes the peg-in branch — the Liquid branch is copy-paste **cruft**.

Two real defects are fixed in passing:

- Mobile's guard reads `(pegInServerFeePercent == 0 || pegInServerFeePercent == 0)` — **the same operand twice**, where the second was meant to be `pegOutServerFeePercent`.
- Mobile shows "**Conversion rate: 0.00 %**" whenever the percent is 0 or not yet loaded; desktop already hides the row. That is the same class of bug as "below 0.0 BTC", which is what this release exists to kill.

**This is a user-visible change on mobile beyond the copy refresh** and is called out as such, and needs the on-device check `docs/TESTING.md` requires.

### 7. The orphaned tooltip key is deleted from all nine locales

The key `"Larger peg-in transactions may need 102 confirmations before your L-BTC are released."` is **not referenced by any Dart code**. History says why: it was rendered by a peg-info popup that was already disabled in `swap.dart` (`// Popups disabled for now`; the `useState(true)` guard meant the `useEffect` never fired), and the dead code was removed in **f77df5b4** (2026-03-25) — `peg_info_presenter.dart`, `show_peg_info_widget.dart`, the `hidePegInInfo`/`hidePegOutInfo` config flags and their call sites.

Pavel's handover still describes this as a live "Tooltip dialog" and his patch dutifully updates the string. We apply the patch (so the tree matches what he sent), then **delete the key** from all nine files — and tell him the popup no longer exists, so he can decide whether it should come back as its own task or whether he meant the web/FAQ.

The deletion was verified to be mechanically safe: **no** easy_localization codegen (`LocaleKeys` / `CodegenLoader` appear nowhere), **no** locale-parity or key-ordering test, and `pubspec.yaml:130` ships the whole directory as an asset rather than enumerating keys.

**Rejected:** restoring the popup. It was switched off deliberately before it was deleted; reviving it is a design decision, not a copy fix, and is out of scope for points 1–2.

### 8. Tests

Per `docs/TESTING.md`:

**Provider** (`test/providers/pegs_provider_test.dart`, must stay at 100 % line **and branch**): every new branch gets both sides — `instantCreditAvailable()` for `pegInWalletBalance > 0` → `true` and `== 0` → `false`; the `loaded` flag for the `hasPegInWalletBalance()` guard both taken and not taken. Driven through the existing `PegSubscribedValues` fixture seam.

**Widget** (`test/widgets/peg_in_info_lines_test.dart` — the repo's **first** widget test): one test per behavioural branch —
1. not loaded → nothing renders;
2. instant credit available → three amount bullets, no `PEGIN_INSTANT_UNAVAILABLE`;
3. instant credit unavailable → `PEGIN_INSTANT_UNAVAILABLE` + `PEGIN_FEE_LINE`, no amount bullets;
4. conversion percent ≠ 0 → row present, carrying the `100 - percent` value;
5. conversion percent == 0 → row absent;
   with both intro lines present in every *loaded* case.

**Localization harness**: `Localization.load(const Locale('en'), translations: Translations({...}))` with a map of the peg-in keys, so `.tr(args:)` interpolates for real and assertions can check rendered copy including the amount. Prior art is `test/providers/markets_provider_test.dart:43-56` — but it loads in `setUpAll`, and `Localization` is a **shared singleton**. `docs/TESTING.md:24-31` requires shared stores reset in `setUp`, not `setUpAll`, so the new test loads it **per test**. (Without a translations map, `.tr()` returns the bare key — `test/providers/utils_provider_test.dart:31` — a weaker but valid fallback.)

**Assertion surface**: the amount bullets are `RichText`/`TextSpan`, not plain `Text` — assert against the composed span text, not `find.text`.

**Manual**: on-device check of the mobile conversion-rate change and of all three peg-in states.

### 9. Delivery

Branch `pegin-copy-update` off `fixes-14.07.26`, explicitly requested by the user. Committed locally; no push and no PR until asked. Documentation (this ADR + `CONTEXT.md`) is committed and pushed separately, ahead of the implementation.

Commits are kept separable so the discretionary work can be dropped without reverting the copy fix:
1. translations patch + orphaned-key deletion,
2. `instantCreditAvailable()` + the `loaded` flag + the zero state (the required change),
3. `PegInInfoLines` extraction + conversion-rate unification (the discretionary change).

## Out of scope, deliberately

- **`swap_side_amount.dart:392,398`** renders two more peg-in blurbs from old literal-English keys ("Your SideSwap wallet will auto-generate a L-BTC address…"), both marked `// TODO (malcolmpl): remove`. The patch does not touch them. They carry no confirmation counts or fees, so they do not contradict the new copy — only the phrasing is stale. Noted, not changed.
- Points 3–5 of the handover (peg-in count tracking in the balance bot, the open questions for webdev, release timing) are not app changes.

## Consequences and unverified assumptions

- One place — `PegInInfoLines` — now decides what the peg-in screens say. Any future copy state is one branch there, not two.
- `AbstractPegRepository` is the only thing that knows what "instant credit is available" means.
- **Unverified:** that the new engine always sends `peg_in_wallet_balance` when instant credit is available (see decision 3). Ask Pavel.
- **Unverified:** that no other SideSwap client consumes these shared locale JSON files and relies on the deleted key.
- **Unverified:** the Arabic and Urdu word order around the amount placeholder (RTL). Pavel's own handover flags this as the fragile part and asks for a native sanity check; we cannot provide one.
