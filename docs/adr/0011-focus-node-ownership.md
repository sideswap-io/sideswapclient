# ADR-0011 — A focus node has one owner, and the signature says who it is

- **Status:** Accepted. Decisions 1–6 implemented by #215 and #217; decision 7 pending — issue #216.
- **Date:** 2026-08-19
- **Driver:** #214. The Receive amount field on the peg screens builds a fresh `FocusNode` on every rebuild, so it drops the caret mid-entry. That is the second recurrence of the same theme in two days: #205 fixed the first one in the desktop button family. Neither issue wrote the rule down, and the repo holds five mutually inconsistent answers to "who owns this node".
- **Scope:** every widget in this repo that accepts, creates, or reads a `FocusNode`. Both widget families — `HookWidget`/`HookConsumerWidget` and `StatefulWidget` — are covered, because the defect has now appeared in both.
- **Relationship to ADR-0009:** ADR-0009 decision 5 says the notification item owns a focus node over its own subtree *because* `DHoverButtonState` never adopts a caller's node. #205 has since landed and that premise is gone; ADR-0009 carries a pointer at the site. The decision itself is unaffected — this ADR does not reopen it.
- **Reviewed by:** two Codex passes over the design brief — devil's advocate on v1, adversarial on v2 — with every finding re-verified at its citation before acceptance. See [Review notes](#review-notes).

## Context

A `FocusNode` is a `ChangeNotifier` with a lifetime. Whoever creates it must dispose it, and whoever is handed one must not. Flutter's own widgets follow that rule strictly: `TextField` creates an internal node only when the caller supplies none, and disposes only that one (`flutter/lib/src/material/text_field.dart:1154`, `:1367`). Nothing in this repo stated the equivalent rule for our widgets, so each one answered it separately.

### What the measurements showed

Five different strategies were in production when this ADR was written, with nothing
marking which was correct for which case. **The `file:line` citations in this
subsection are a pre-#215 snapshot and are deliberately not updated** — they are
the evidence the decisions were made from. Every citation elsewhere in this
document points at current code.

1. **A conditional hook.** `focusNode ?? useFocusNode()` in four shared field widgets — `market_order_panel.dart:476` (class `MarketAmountPanel`, declared `:423`), `dropdown_amount_text_field.dart:63`, `share_copy_scan_textformfield.dart:77`, `ticker_amount_textfield.dart:69`. `flutter_hooks` identifies hooks by call order within `build` (`flutter_hooks-0.21.3+1/README.md:146`), so a caller that flips `focusNode` between null and non-null across rebuilds of the *same* instance breaks hook order at runtime. No caller does that today, which is the only reason it has never fired.
2. **A node built inside `build`.** `swap_side_amount.dart:280` — `focusNode ?? FocusNode()`. A widget probe confirmed the consequence: focus the field, force one rebuild, and the node identity has changed and the field is unfocused. `EditableText` detaches the old attachment when the node changes (`flutter/lib/src/widgets/focus_scope.dart:646`), and detaching a focused node unfocuses it (`flutter/lib/src/widgets/focus_manager.dart:223`). Exactly one caller reaches it — `swap_receive_amount.dart:80`, which supplies no node — and that is #214.
3. **Nullable, forwarded straight through.** `market_amount_text_field.dart:178` hands its `FocusNode?` to `TextField` untouched, so Flutter owns the fallback. Correct, and the cheapest option — but only available to a widget that never touches the node itself.
4. **A private `State` field.** `lib/common/widgets/sideswap_slider/sideswap_slider.dart:60` creates its node once and disposes it at `:80`. Correct, and the right shape for a widget nobody coordinates focus with.
5. **The #205 shape.** `d_hover_button.dart:57` keeps `_internalNode`, `:62-63` resolves the effective node through a getter evaluated on every read — which is what adopts a node supplied after mount — and `:132-134` disposes the internal node only. `didUpdateWidget` (`:115`) does **not** migrate or transfer focus; it clears one cached highlight flag.

The four widgets in (1) cannot move to (3), because each touches its node: `market_order_panel.dart:487` (`requestFocus`), `dropdown_amount_text_field.dart:71` and `ticker_amount_textfield.dart:75` (`addListener`), `share_copy_scan_textformfield.dart:88` (`unfocus`, `canRequestFocus`).

Optionality is also mostly fictional. Of those four, only `ShareCopyScanTextFormField` is used both ways (`whom_to_pay_text_field.dart:22` supplies nothing, `swap_side_amount.dart:336` supplies a node). `MarketAmountPanel.focusNode` has never been supplied by anyone — its sole construction is `market_order_panel.dart:363`, argument-free. `DropdownAmountTextField` and `TickerAmountTextField` are always given one.

## Decisions

### 1. The signature states the ownership

A widget's `focusNode` parameter is not a convenience switch. Its presence, nullability and requiredness are the declaration of who owns the node, and they are chosen from the tree in decisions 2–5 — not from what is convenient at the first call site.

### 2. A widget that only forwards the node takes `FocusNode?` and forwards it

If the widget never reads or mutates the node — no `addListener`, no `requestFocus`, no `unfocus`, no `canRequestFocus` — it declares `FocusNode?` and passes it straight to the `TextField` (or `Focus`, or `FocusableActionDetector`) beneath it. Flutter creates and disposes the fallback. The widget owns nothing and disposes nothing. Prior art: `market_amount_text_field.dart:178`.

### 3. A widget that touches the node and is never given one owns a private node and exposes no parameter

A parameter nobody passes is not an extension point; it is an untested code path plus, in the hooks case, a conditional hook. The widget creates its node privately — `useFocusNode()` in a hooks widget, a `State` field in a `StatefulWidget` — and offers no way in. When a parent later needs to coordinate focus, the parameter is added then, together with the caller that justifies it. Prior art: `lib/common/widgets/sideswap_slider/sideswap_slider.dart:60`, `:80`.

### 4. A widget that touches the node and is always given one requires it

`required FocusNode focusNode`. No fallback, no nullability, nothing to dispose. This is the honest signature for a widget whose focus is coordinated by its parent, and it removes the fallback branch that no test could otherwise cover.

### 5. A widget genuinely used both ways takes `FocusNode?` and creates its fallback unconditionally

In a hooks widget:

```dart
final internalNode = useFocusNode();          // always called
final node = focusNode ?? internalNode;       // selection unchanged
```

The hook is never inside a `??`, a conditional, or a loop. It costs one unused node per instance when the caller supplies its own; that is the price of a signature that cannot break hook order.

In a `StatefulWidget`, the same rule takes the #205 shape: a private `_internalNode` field created lazily, an effective-node getter resolved on **every read** so a node supplied after mount is adopted rather than ignored, and a `dispose` that frees the internal node and never the caller's (`d_hover_button.dart:57`, `:62-63`, `:132-134`). Any cached UI state derived from the node, and any child state keyed to it, must be reset or re-keyed when the effective node changes — `DHoverButton` does both (`:115-128` clears the cached focus highlight; `:139` keys the detector on the node), and that part is widget-specific, not boilerplate.

### 6. A `FocusNode` is never constructed in `build`, and never constructed to be thrown away

Two forms of the same mistake:

- `FocusNode()` evaluated during `build` — or during a builder callback that `build` re-invokes, such as a `showDialog` builder — allocates a node per invocation, disposes none of them, and silently re-binds whatever was focused. #214 is one instance; `dialog_presenter.dart:188` and `:295` are two more.
- `FocusScope.of(context).requestFocus(FocusNode())` as a way to drop focus (`swap_receive_amount.dart:127`). It allocates a node to express something `FocusScope.of(context).unfocus()` expresses with none. Use `unfocus()`.

### 7. Anything that captures the effective node is keyed on it, cleans up after itself, and syncs on attach

Ownership alone does not make focus wiring correct. An effect or memoized closure that captures the effective node must:

- key on it and on every prop its body reads — `[node, ...props]`, never `const []`;
- return a cleanup that removes exactly what it registered, using a named function so `removeListener` receives the same reference;
- run its sync body once immediately after (re)attaching, so the state it feeds reflects the node's actual state rather than a value carried over from before the re-run.

All three parts are load-bearing. `ticker_amount_textfield.dart:75` and `dropdown_amount_text_field.dart:71` violate the first two, so their listeners outlive the widget and decide from props captured on the first build (#216). `share_copy_scan_textformfield.dart:83` violates the first through `useCallback(fn)` with no key list, which in `flutter_hooks` defaults to `const []` — it permanently captures the first node and controller while the `TextField` at `:148-151` receives the current ones.

## Consequences

- Four widgets change signature (#215): `MarketAmountPanel` loses the parameter, `TickerAmountTextField` and `DropdownAmountTextField` require the node, `ShareCopyScanTextFormField` keeps it optional with an unconditional fallback. No constructor call site needs editing — a statement about compilation, not a claim of behavioural identity; the tests establish behaviour.
- `focusNode ?? useFocusNode()` becomes a pattern that review rejects on sight. After #215 it has zero occurrences, so any reappearance is a new one.
- A widget that legitimately needs both modes pays one unused `FocusNode` per instance. Accepted: the alternative is a signature whose safety depends on every present and future caller keeping nullness constant. The cost is per instance, so a chain of two such widgets pays it twice: on the peg Receive path `swap_side_amount.dart` and `ShareCopyScanTextFormField` each hold one unused node behind the address field that `swap_receive_amount.dart` supplies.
- `SwapSideAmount.receiveAddressFocusNode` stays `FocusNode?` with an unconditional fallback. #219 deferred that signature to #215; the measurement is that one of its four callers supplies the node (`swap_receive_amount.dart:109`) and three do not, which is decision 5 exactly.
- The rule is deliberately unhelpful about redesigns. Decisions 2–5 classify what a widget does today; they do not ask whether a widget *should* touch its node. Lifting focus handling into `Focus(onFocusChange:)` or into the parent would move a widget between branches, and that is a design change to argue on its own merits, not a consequence of this ADR.

## What this ADR does not settle

- **Whether these widgets should touch their nodes at all.** Each of the four could stop — `Focus(onFocusChange:)` for the two that only observe focus, lifting the focus command to the parent for `MarketAmountPanel`. That would move them to decision 2, which is strictly simpler. Not proposed here, because the fix that closes #214 and #216 does not need it and the redesign has its own risk.

  **Deliberately unticketed.** It is a design fork with no decision behind it, and an issue that only says "decide this" is a queue for a conversation, not work. The trigger for reopening it is the landing of #215 and #216: at that point the four widgets have their final signatures and their listener wiring is correct, so what remains of the node handling is visible and the question can be answered against code rather than against a plan. Whoever reopens it should reopen it as a decision — an amendment to this ADR — and not as an implementation issue.
- **`market_order_panel.dart:463`.** It registers an unremoved listener, but on `amountController`, with correct dependencies and no captured props, on a hook-owned controller that dies with the widget. It retains nothing beyond the widget's own lifetime, so decision 7's cleanup requirement — written for nodes that outlive the widget — buys nothing here. Left alone deliberately, and recorded so the next reader does not rediscover it as a defect.
- **`share_copy_scan_textformfield.dart:99`.** A `const []` effect with no listener that *increments* `suffixCounter` from callback nullness, which `:124` turns into a width. Latent, because both callers keep that nullness constant for the instance's lifetime. It is called out because the obvious repair is wrong: adding dependencies to an incrementing effect double-counts. It needs replacing with a derived value, or leaving alone — not a dependency list.
- **Focus traversal, autofocus policy, and who gets focus on screen entry.** Untouched. This ADR is about the lifetime and identity of the node, not about where focus goes.

## Review notes

Findings from the two Codex passes that **changed** this ADR, rather than confirming it. Each was re-verified at its citation before acceptance; the ones that did not survive verification are listed too, because a future reader will otherwise rediscover them.

- **The rule tree had no branch for "touches the node, nobody supplies one".** That is `MarketAmountPanel` exactly — the case the first draft resolved ad hoc. Decision 3 exists because of this finding, and `sideswap_slider.dart:60` turned out to be prior art already in the repo.
- **The effect rule covered listeners only.** `useCallback` with no key list has the same failure and was invisible to the draft. Decision 7 is phrased over *anything* that captures the effective node because of this.
- **The listener fix was incomplete.** Keying the effect and adding cleanup still leaves `hasFocus` / `visibleHintText` stale until the next focus event, because a re-run re-attaches without reconciling. The third clause of decision 7 exists because of this.
- **The #205 recipe was described wrongly.** The first draft credited `didUpdateWidget` with adopting the node. It does not; the resolving getter does, and `didUpdateWidget` only clears a cached highlight. Decision 5 states the mechanism correctly, and the "cached state and node-keyed children" sentence exists because that part is not boilerplate.
- **Not accepted: `market_order_panel.dart:463` as an instance of the listener defect.** Its dependencies are correct, it captures no props, and its controller is hook-owned. Recorded above under what this ADR does not settle.
- **Not accepted: that #214's regression test depends on the provider transition it describes.** The probe forces the rebuild through a `ValueNotifier` fed to `balance`, with no provider involved.

## Related

- #205 — the first recurrence, in the desktop button family. Closed; its shape is decision 5's `StatefulWidget` arm.
- #214 — the live bug that drove this ADR, and the first of decision 6's three sites.
- #215 — implements decisions 1–5 across the four shared field widgets, and this ADR.
- #216 — implements decision 7 for the two focus listeners.
- #218 — the suffix-width effect named above under what this ADR does not settle.
- #217 — implements decision 6 for the *other* two sites: the two dialog builders and the throwaway-node unfocus. It does not touch `swap_side_amount.dart`, which is #214's.
