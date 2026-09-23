# ADR-0009 — Liquid Connect: an acceptance attempt belongs to the request, not to the widget that started it

- **Status:** Accepted and implemented — issue #192, closed 2026-08-17.
- **Amended by:** [ADR-0011](0011-focus-node-ownership.md) falsifies two statements about `DHoverButton` inside this ADR — one measurement and one stated reason — because #205 landed after this ADR was written. Pointers are added at both sites. No decision here changes.
- **Date:** 2026-08-17
- **Driver:** #192, found during the adversarial review of #187 and confirmed against source during triage. The desktop notification panel binds list elements to the list index, so the acceptance state that #187 introduced does not follow the request it belongs to.
- **Relationship to ADR-0006:** this ADR **supersedes ADR-0006 decision 4** in the part that places the single-flight flag in the widget ("A flag set synchronously before the first `await` disables the acceptance control"), and **refines ADR-0006 decision 2** by relocating its liveness guard rather than removing it: the acceptance path no longer runs in a widget, so `context.mounted` is replaced by `ref.mounted` on the notifier. **Decision 2's three-step order — liveness, then identity, then state — stands unchanged, and so does its reason**: reading through a disposed `ref` throws exactly in the case the re-check exists to handle. Every other ADR-0006 decision stands, decision 1 (the gate) and decision 6 (neither failure sends anything) most of all.
- **Reviewed by:** two Codex passes (devil's advocate on v1, adversarial on v2) — see [Review notes](#review-notes).

## Context

ADR-0006 installed an authentication gate on every user-driven acceptance, a pending re-check behind it, and a single-flight guard so one press cannot start two attempts. All three were placed in the widget that owns the approval control, and on mobile that placement is sound: decision 5 presents one request at a time, and decision 4 binds the dialog to an immutable `(notificationId, reqId)`, so the widget element **is** the request for as long as the request exists.

Desktop presents its requests as a list, and there the placement does not hold. `NotificationMenu`'s `itemBuilder` returns an unkeyed `Column` (`lib/desktop/widgets/d_notifications.dart:328-361`) and `addNotification` prepends (`lib/providers/notifications_provider.dart:128-142`, `:152-168`), so element identity is positional. A prepend moves every entry onto the next element; a removal moves every entry that was below it. Either way the acceptance state stays where it was while the request it belongs to moves.

The failure is not that the state is wrong in some detail. It is that the state was keyed to the wrong thing. That is why this ADR moves the state rather than repairing the list: a list whose elements follow their requests is a good idea on its own merits, and it is tracked as #203, but it must not be what makes an acceptance arrive.

### What the measurements showed

Each of these killed an option that looked reasonable.

- **`isAuthenticated()` takes no `BuildContext`.** It reads configuration and delegates to `pinBlockadeUnlocked()` (`lib/providers/wallet.dart:1651-1654`), which dispatches to a callback registered on the helper (`lib/providers/pin_protection_provider.dart:90-99`). **The callback itself is widget-owned** — it closes over a root widget's context and awaits `showDialog` (`lib/app_main.dart:147-164` on mobile, `lib/desktop/desktop_root_widget.dart:37-54` on desktop). So the PIN route belongs to the root widget both before and after this ADR; what changes is only which code awaits it. "The gate must be called from the widget that owns the control" was never true, and no route ownership moves.
- **The pending re-check is already a provider.** `pendingRequestProvider(notificationId, reqId)` (`lib/providers/notifications_provider.dart:436-461`) answers ADR-0006 decision 2's identity-and-state question, and #188 put it there. Moving the acceptance out of the widget therefore adds no lookup; it removes the widget from between two things that already live outside it.
- **`keepAlive` is not a lifetime guarantee.** Riverpod disposes a provider *immediately* on explicit invalidation whatever its `keepAlive` — "Calling [invalidate] will cause the provider to be disposed immediately" (`riverpod-3.4.2/lib/src/core/ref.dart:317`) — and `Ref.mounted` (`:112`) exists precisely so a continuation can test for it after an await. So `keepAlive` buys survival of the *watcher* going away, which is what this ADR needs, and nothing else. It is not a licence to drop the liveness check.
- **Four distinct element-churn sequences drop or corrupt an acceptance**, and they need only a second entry in the panel. A removal below the in-flight item unmounts its element and the `context.mounted` guard then silently sends nothing; a prepend of a *different* kind does the same at index 0; a prepend of the *same* kind repurposes the element, so a fresh request inherits a busy control while the in-flight attempt keeps running against the old request's captured ids; and an element created fresh at a shifted index starts with `acceptInFlight == false`, re-enabling a control whose attempt is still outstanding.
- **The panel is destroyed for reasons that have nothing to do with the list.** The overlay entry is removed and rebuilt whenever `MediaQuery` size changes (`lib/desktop/widgets/d_notifications.dart:114-120`), and collapsed whenever nothing is left pending (`:122-136`), and toggled by the toolbar button (`:183-185`). All three destroy every item element. So even a list whose elements followed their requests would not make widget-held acceptance state safe.
- **A request carrying both payloads is two entries sharing one id and one request id.** `addNotification` increments `_id` once and uses it for the connect entry and the sign entry alike, with `signRequest.reqId` for both (`lib/providers/notifications_provider.dart:106-181`). `removeNotification(int id)` then removes both, because it filters the list by id (`:271-286`). Any identity scheme has to be stated against that fact rather than assume entries are distinct.
- **The panel's resolution-driven collapse already follows the pending set.** `activeNotifications` is true while any entry is in the `empty` state (`lib/providers/notifications_provider.dart:409-420`), and the effect keyed on it collapses the panel when it goes false (`lib/desktop/widgets/d_notifications.dart:122-136`). Resolving one of several pending requests does not change it, so the effect does not run — which is exactly the wanted behaviour, and it is already built.
- **Disabling a control takes its focus away immediately.** `FocusableActionDetector` sets `Focus.canRequestFocus` to false when disabled, and the setter unfocuses on the spot: `if (hasFocus && !value) unfocus(...)` (`flutter/lib/src/widgets/focus_manager.dart:549`). So any rule phrased as "restore focus if it is still inside this item" evaluates *after* the disable has already moved it, and would refuse exactly the restoration it exists to perform.
- **A button's focus node outlives the request it was showing.** `DHoverButtonState` binds `node = widget.focusNode ?? _createFocusNode()` in `initState` and has no `didUpdateWidget` (`lib/desktop/common/button/d_hover_button.dart:63`, `:109-112`). An element repurposed to another request therefore keeps the node, and keyboard focus sitting on Cancel or on the approval control carries over to a request the user has not read. Handing the button a request-keyed node does not help, because the state ignores the new one — the item has to drop the focus itself. **(No longer true since #205, closed 2026-08-17: `DHoverButtonState` now resolves its effective node through a getter evaluated on every read, so a node supplied after mount is adopted — `lib/desktop/common/button/d_hover_button.dart:62-63`. The measurement stands as the state of the code when this ADR was written, and the decision it supports is unaffected; see the pointer under decision 5.)**
- **`onTap` is one callback with three consumers.** It is the outside-click catcher (`lib/desktop/widgets/d_notifications.dart:250`), and it is handed to both item widgets (`:341`, `:351`), which call it from Cancel and from the acceptance (`:599`, `:673`, `:988`, `:1062`). So "the panel collapses when a request is resolved" and "the panel collapses when the user clicks away" are the same wire today, and separating them is a precondition for changing either.

## Decisions

### 1. The identity of an acceptance attempt is the request id

An attempt in flight is recorded against `reqId`, not against `(notificationId, reqId)` and not against a widget element.

`notificationId` is a local presentation counter that carries no identity of its own — monotonic for the notifier's lifetime, and meaningless beyond arrival order (`Notifications._id` in `lib/providers/notifications_provider.dart`, #211). `reqId` is what crosses the wire and what an acceptance is *about*: one `To_SignerResponse(reqId, accept: true)` answers one request. Keying a wire-level guard by a presentation id is the same category error this ADR exists to correct, one level up.

Two consequences follow, and both are wanted:

- **If one request id is ever live under two entries, one attempt disables both controls.** ADR-0006 records that active `request_id` uniqueness is a Rust invariant it relies on and does not establish; if the server reissues a live id, the app holds two entries for one request and accepting either signs the other's PSET. Keyed by the pair, the press would disable only the entry pressed and leave its twin armed. Keyed by the request id, both go quiet. Neither key *resolves* the collision — that needs an identity the protocol does not carry — but one of them refuses to compound it.
- **After `clearAll()`, a re-delivered request id is refused until the outstanding attempt finishes.** The counter goes on counting across the call, so the same request arrives under a new local id while an attempt for that request id is still at the gate. The new entry's control is busy until the old attempt resolves, which is exactly what single-flight is for: two prompts for one wire request are what the rule forbids, and the fact that the app now files the request under a different local number does not make them two requests. Transient, self-correcting, and deliberately conservative.

A request carrying both a connect and a sign payload is unaffected either way: its two entries share both the id and the request id.

**This deliberately puts a second identity shape in the vocabulary**, beside `pendingRequestProvider`'s `(notificationId, reqId)`, and the split is the decision rather than an inconsistency to tidy away. *Whether an entry is still pending* is a fact about what the panel is showing, so it is keyed by the entry. *Whether an attempt is running* is a fact about the request, so it is keyed by the request.

### 2. The acceptance runs outside the widget, and the widget is not a party to it once it starts

The gate, the pending re-check, the send and the record move into a notifier. The approval control does one thing: it asks for an acceptance and reads back whether one is running.

The method returns nothing. A returned outcome would restore the dependency this ADR removes — "for the UI to react, the element must survive the await" — narrower than today, because only a panel collapse would hang on it, but identical in shape, and a future reader cannot be expected to hold the distinction between the `await` that is allowed and the one that is not. The rule is therefore without exception: **once the gate is crossed, the widget is no longer a party.**

Mobile keeps its dialog and its hook, but the hook becomes an adapter that calls the same method. Its own sequencing disappears. Mobile does not have the defect — one request at a time, immutable identity — and the change is therefore not a fix there but a convergence: ADR-0006 decision 4 already committed both platforms to one mechanism, and two mechanisms would mean the next person to change the acceptance path has to find and change both.

**ADR-0006 decision 2's ordering survives intact, with its first step re-pointed.** Liveness, then identity, then state. Liveness is now `ref.mounted` on the notifier rather than `context.mounted` on the element, for the same reason as before — reading through a disposed `ref` throws exactly in the case being guarded — and it is checked after the gate returns, before anything else is read. What is gone is not the guard but its coupling to a list element: a notification item unmounting is no longer one of the things that can fail it.

ADR-0006 decision 4's standing condition is untouched and still load-bearing: the send and the record stay in one synchronous block, because `sendMsg` is `void` and an `await` opened between them would let an acceptance reach the origin unrecorded.

### 3. The in-flight state outlives every widget that observes it, and nothing invalidates it

The notifier holding it is `keepAlive`, because without that the set is disposed when its last watcher goes — and its last watcher going is precisely the event this ADR defends against. An autodisposed guard would be discarded at the moment it is needed and reconstructed empty, which is the current defect with a new home.

`keepAlive` does not extend to explicit invalidation, so the rest of the lifetime is a **contract rather than a framework guarantee**, and it is written here because it cannot be read off the type:

- **Nothing invalidates this notifier.** Not `clearAll()`, which invalidates only `notificationsProvider` (`lib/providers/notifications_provider.dart:346`); not a wallet reset, which resets neither (`lib/providers/wallet.dart:1553`). Anyone adding an invalidation is changing this decision, and must say what happens to an attempt that is at the gate when it lands.
- **Its `build()` watches nothing.** `ref.mounted` goes false when the element is disposed *and* when a rebuild replaces its `Ref`, and a rebuild follows any watched dependency changing. A notifier that watched the notification list would therefore invalidate its own in-flight attempt every time a request arrived — the defect this ADR removes, rebuilt out of provider parts. Every collaborator is read inside `accept`, none in `build`.
- **Tearing down the root container abandons the attempt**, `keepAlive` or not (`flutter_riverpod-3.4.2/lib/src/core/provider_scope.dart`). The app creates one unkeyed root scope per platform and never replaces it (`lib/start_app.dart:164`, `:185`), so this is a statement about what would break rather than a live hazard.
- **An attempt is removed from the set when the gate returns**, on every outcome, in a `finally`. Nothing else clears it: not a removal from the list, not a collapse, not the list notifier being invalidated underneath it.
- **A gate that never returns leaves its control busy, and that is the chosen failure.** `finally` runs on completion, not on abandonment, so a prompt that is neither answered nor dismissed strands the entry. Releasing the guard on a timer instead would re-arm a control while a prompt is still on screen, which is the two-prompt defect this rule exists to stop. A stuck control is recoverable by the user; a duplicate signature is not.
- **`clearAll()` under an outstanding attempt is defined and needs no special case.** The list is rebuilt empty, so the post-gate re-check finds no entry and sends nothing; the set entry is released by the `finally` as usual.

### 4. Resolving a request does not collapse the panel while another is still pending

Resolving the last one does, because the pending set empties and the panel has nothing left to show. The invariant is about *one of several*, not about resolution as such.

This follows from decision 2 rather than being added on top of it: with the acceptance out of the widget there is nowhere left to call `onTap` from, and the effect keyed on `activeNotifications` already collapses the panel when the last pending request resolves. Cancel loses its `onTap` call for the same reason — "rejecting collapses the panel, accepting does not" is not defensible.

**The collapse callback is no longer handed to the items at all.** Once the four call sites are gone the parameter is unused, so it is removed from both item widgets and from the two construction sites. That is what makes the rule structural instead of conventional: a child has nothing to collapse the panel with.

The rule is about *resolution*, and says nothing about the other two ways the panel closes, both of which are unchanged: the toolbar button toggles it (`lib/desktop/widgets/d_notifications.dart:183-185`), and the outside-click catcher would if it worked (see [What this ADR does not settle](#what-this-adr-does-not-settle)).

One case is stated so it is not mistaken for a regression: if the only entries left are ones cancelled remotely, `activeNotifications` is already false and the panel collapses over them. Those entries are informational, not pending.

### 5. Focus belongs to the request: it is captured before the disable, restored only if unclaimed, and dropped when the element changes request

#187 made the item re-request focus when its attempt ends, so a retry after a failed gate is reachable from the keyboard. In a list that same effect pulls focus off a control the user has since tabbed to on another item. Two separate rules follow, and both are stated because each was got wrong in an earlier draft.

**Capture before, not test after.** Whether this item owned focus is recorded synchronously *before* the control is disabled, because the disable takes the focus away in the same turn (`canRequestFocus = false` unfocuses). On release, focus is restored only if it was captured **and** nothing else has claimed it since. A rule phrased as "restore if focus is still inside this item" refuses every restoration, including the one after a failed gate that ADR-0006 decision 6 leaves the user to retry.

**Focus does not ride along to another request.** When the item's `reqId` changes — an element repurposed by a prepend or a removal — the item drops any focus its subtree holds instead of handing it to the new request. Without this, the panel staying open under decision 4 leaves a control armed on a request the user never read, and a repeated Enter rejects it, or raises the gate for it. That is a regression decision 4 would otherwise introduce: today the collapse takes the misbound focus away as a side effect.

**The item owns a focus node over its own subtree**, because the buttons do not expose theirs — `DHoverButtonState` keeps its node private and never adopts a new one. Both rules above are answered against that node, not against the controls.

> **Premise amended by [ADR-0011](0011-focus-node-ownership.md).** The reason given above — that the buttons never adopt a node — stopped being true when #205 landed (`lib/desktop/common/button/d_hover_button.dart:62-63`). **The decision stands**: the item still owns a node over its subtree, and both rules are still answered against it. What is now available, and is what "What this ADR does not settle" already anticipated, is the simplification of replacing the item's explicit focus drop with a request-keyed node handed to the button. That is a follow-up nobody has claimed, not a correction to anything below.

This is the whole of what this ADR does about focus. Focus that does not survive an *arrival that rebuilds the element* is a different failure — the node is destroyed with the element — and it belongs to the list-identity work in #203.

### 6. A gate that throws is a gate that failed

`isAuthenticated()` is a `Future<bool>` with no non-throwing guarantee: it crosses a platform channel for biometrics and a decryption for the fallback, and not every failure there is converted to a result. The acceptance path catches, logs, sends nothing, closes nothing and releases the guard — the same observable outcome as a returned `false`, which is what ADR-0006 decision 6 already specifies for a user who dismissed their own prompt.

The alternative — letting it propagate — is worse than it looks here specifically: the call is deliberately unawaited under decision 2, so an escaping error surfaces as an unhandled asynchronous error rather than at a call site anyone is watching, while the control stays busy for a request that is still pending.

This does not widen decision 6. Nothing is told to the origin, and nothing new appears on screen.

## Consequences

- One new `keepAlive` notifier, with the acceptance sequence and the in-flight set, under the 100 % provider coverage gate. It is the first place in the app where the notification path depends on `walletProvider`, and therefore on PIN and biometrics; that dependency is why it is a new notifier rather than a method on `Notifications`, which is `keepAlive`, already carries four responsibilities and has a 2 688-line test file.
- The desktop items lose their acceptance sequence, their `acceptInFlight` hook and their `onTap` parameter, and gain a read of the in-flight set. The mobile hook keeps its name and its call site and loses its body.
- The multi-item scenarios that motivate this ADR become provider tests: the list mutates while an attempt for a request id is outstanding. The one claim that stays in the widget — a control reads the in-flight set by its **own** request id, so an element repurposed to another request shows that request's state — is testable by rebuilding a single item with a different entry, without driving the real panel.
- Any test that asserts an acceptance is dropped when its element goes away is asserting the defect.
- `pendingRequestProvider` acquires a caller with different lifetime assumptions: it is read from a notifier rather than watched by a widget. It is a plain derivation of the list, so this is a read, not a subscription, and nothing about it changes.
- ADR-0006's seven changed sites are re-cut. The two desktop acceptance buttons and the two mobile acceptance callbacks become calls; the sequence they contained exists once.
- A liveness guard remains on the acceptance path, so "the re-check needs no guard now" is wrong in review. It moved; it did not go.
- Decision 4 removes the collapse that was incidentally cleaning up misbound keyboard focus, so decision 5's second rule ships with it rather than after it. They are one change: a panel that stays open is only safe if focus does not outlive the request under it.
- The items gain a focus node of their own, which is new surface. Its two behaviours — restore after a failed gate, drop on a request change — are both testable by rebuilding one item with a different entry, without driving the real panel.

## What this ADR does not settle

- **Whether a list element follows its request.** It does not, and after this ADR nothing about an acceptance depends on it. What remains is keyboard focus, which is destroyed with its element on every arrival. Fixing it needs the list children keyed by notification id **and** `findChildIndexCallback` on the sliver — a key without it is worse than none, because `SliverMultiBoxAdaptorElement.performRebuild` relocates a keyed child only through `delegate.findIndexByKey` and otherwise deactivates it — **and** it needs `firstChildKey` to stop hanging on the inner item under `index == 0`, or relocation will destroy the very element it moves. Tracked as #203.
- **Whether clicking outside the panel closes it.** It does not, and not intermittently: the catcher is `Positioned` with every offset null, which makes it a *non-positioned* stack child (`rendering/stack.dart`), measured under `constraints.loosen()` by `RenderStack._computeSize` while the `Overlay` gives the entry tight constraints (`widgets/overlay.dart:1478-1482`); a childless `RenderProxyBoxWithHitTestBehavior` then takes `constraints.smallest`, so the catcher is 0×0 at the top-left corner. What users read as "sometimes it closes" is the panel collapsing on its own when the pending set empties. Tracked separately. Recorded here because the fix has a real choice inside it: `translucent` does not buy a single click, since the gesture arena gives the win to the first member and members are ordered top-down along the hit-test path (`gestures/arena.dart`, `// First member wins.`), so a control underneath is rejected either way. Dismiss-and-swallow is both the honest description and the desktop convention. Tracked as #204.
- **Whether the overlay entry should be rebuilt on every `MediaQuery` size change.** It is (`lib/desktop/widgets/d_notifications.dart:114-120`), which destroys every item element on a window resize. After this ADR that costs no acceptance, but it still costs keyboard focus — the same consequence as an arrival. Tracked as #233; the list-identity work in #203 does not cover it, and never named it.
- **What a logout or a wallet reset does to a pending request or to an outstanding attempt.** Neither is cleared today: `cleanAppStates()` resets several wallet stores and touches neither the notification list nor this notifier (`lib/providers/wallet.dart:1553`). That is pre-existing and independent of where the acceptance lives, and inventing a disposition here would be inventing it for the notification list too.
- **Whether `DHoverButton` handles a changed focus node.** It does not, and its disposal accounting is wrong in both directions: `node` is bound once in `initState` with no `didUpdateWidget`, and `dispose` frees it only when `widget.focusNode == null` *at that moment* — so a node supplied after mount leaks the internally created one, and a node withdrawn after mount frees the caller's (`lib/desktop/common/button/d_hover_button.dart:63`, `:109-112`). It is the root of the desktop button family, so it is fixed on its own rather than inside this work; decision 5 is written not to depend on it. Once it is fixed, the item's explicit focus drop could be replaced by a request-keyed node — a simplification, not a requirement. Tracked as #205.
- **Whether the two entries of a dual-payload request should be separable.** They share an id and a request id, so no scheme in the app can tell them apart; it needs an identity the protocol does not carry. Unchanged from ADR-0006.

## Review notes

Findings from the review passes that **changed** the design, rather than confirming it. Each was verified against source before being accepted; the ones that did not survive verification are listed too, because a future reader will otherwise rediscover them.

Devil's advocate, on the first version:

- `keepAlive` does not survive explicit invalidation — Riverpod disposes on `invalidate` regardless, and `Ref.mounted` exists for exactly this continuation problem. The first version claimed the set "outlives every widget" as if that were a framework guarantee → the lifetime contract in decision 3, and the `ref.mounted` relocation in decision 2.
- "There is no widget on this path" was false: the PIN prompt is raised by a callback closing over a *root* widget's context. The true claim is narrower and better — the root widget owns the route before and after, so no route ownership moves → the first measurement bullet.
- "Keyed by the pair, one attempt disables neither control" was simply wrong: it would disable the entry that was pressed. The argument survives on the twin being left armed → decision 1, restated.
- A `finally` does not run for a future that never completes → the stuck-control clause in decision 3, stated as the chosen failure rather than left implicit.
- "The panel collapses only when nothing is left pending" over-claimed: the toolbar button still toggles it → decision 4 narrowed to resolution-driven collapse.
- "An arrival or a removal moves every request" over-claimed: a removal moves only the entries below it → Context.
- Citations corrected: `isAuthenticated` is at `wallet.dart:1651`, and the dual-payload removal is `removeNotification` at `notifications_provider.dart:271`, not inside `addNotification`.

Adversarial, on the second version — aimed at the repairs above:

- **Decision 4 introduces a focus regression that decision 5 as drafted did not cover.** With the panel no longer collapsing, a control that keeps focus while its element is repurposed is left armed on a request the user never read; a repeated Enter rejects it, or raises the gate for it. Today the collapse removes the misbound focus as a side effect. → decision 5's second rule, shipped with decision 4 rather than deferred to #203.
- **"Restore focus if it is still inside the item" is self-defeating**, because disabling the control unfocuses it first (`focus_manager.dart:549`). → the capture-before-disable rule in decision 5.
- **A request-keyed focus node would not fix either**, because `DHoverButtonState` binds its node in `initState` and never adopts a new one. → the item owns a node over its own subtree, and `DHoverButton` is tracked as its own defect in #205 rather than repaired here.
- **`ref.mounted` also goes false on a rebuild**, which follows any watched dependency changing — so a notifier that watched the list would invalidate its own attempts on every arrival. → the "`build()` watches nothing" clause in decision 3, plus root-container teardown named explicitly.
- **A thrown gate had no policy.** Nothing would be sent or closed, so ADR-0006 decision 6 held, but an unawaited call would surface an unhandled asynchronous error while the control stayed busy. → decision 6.
- **"Resolving never collapses the panel" still over-claimed**: resolving the *last* pending request does collapse it. → decision 4 restated as "while another is still pending".
- **`CONTEXT.md` listed clicking outside as one of the user's ways to close the panel**, which this ADR simultaneously proves does not work. → the glossary now says intended and tracked, not available.

Findings that did **not** survive verification:

- That `reqId`-only keying is wrong across a `clearAll()` generation because it blocks a re-delivered request under its new local id. It does block it, and that is the rule working: single-flight forbids a second prompt for one wire request, and refiling it under a new local number does not make it two requests → written into decision 1 rather than fixed.
- That moving the caller into a notifier changes route ownership or the `onPinBlockade` result path that ADR-0006 decision 4 calls its most serious finding. The callback and its `showDialog` are unchanged, and PIN success still pops its own route. Mobile's immutable `(notificationId, reqId)` binding, its route teardown by identity and the listener's safety-net ordering all survive the adapter.
- That the desktop-only branches would need platform-scoped tests. `FlavorConfig` is an application flavour, not `dart:io Platform`, so both values are set directly in an ordinary test — prior art in `test/providers/notifications_provider_test.dart`.
- That a mobile biometric prompt could return while the native prompt is still up. The Android channel completes only from the success and error callbacks.
