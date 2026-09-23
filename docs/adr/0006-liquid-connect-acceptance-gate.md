# ADR-0006 — Liquid Connect: every user-driven acceptance passes an authentication gate and a pending re-check

- **Status:** Accepted. Implementation pending — PRD #186 (`ready-for-human`).
- **Date:** 2026-08-13
- **Driver:** a user report that approving a Liquid Connect sign request on mobile never asked for a PIN or fingerprint, while a swap in the same app did. Grilled into a decision tree, then reviewed adversarially.
- **Reviewed by:** two Codex passes (devil's advocate on v1, adversarial on v2) — see [Review notes](#review-notes).
- **Supersedes nothing.** Related: [ADR-0004](0004-liquid-connect-desktop-window-policy.md) (resolution reasons), [ADR-0005](0005-signal-before-raise.md).
- **Amended by:** [ADR-0009](0009-liquid-connect-acceptance-attempt-identity.md) supersedes part of decision 4 and refines decision 2. [ADR-0010](0010-liquid-connect-local-expiry.md) supersedes part of decision 5, refines decision 7, and falsifies text inside decisions 2 and 3 and in the Consequences below. Decisions 2, 3, 4, 5 and 7 each carry a pointer of its own — read the pointer before acting on the decision.
- **One measurement below is now known to be wrong**, and it is load-bearing for decision 2's identity argument: notification ids do **not** restart after `clearAll()`. The notifier instance survives `ref.invalidateSelf()`, so its `_id` counter keeps going. See ADR-0010 measurement 5 and issue #211. The identity check stays — it is correct either way — but nothing may be reasoned from a reset that does not happen. **#211 also settles the counter itself: it stays monotonic for the notifier's lifetime, with no reset mechanism.** Of the two ways to close the gap — make the code match the documents, or the documents match the code — the second was taken: a counter that only ever goes up is the weaker assumption and needs no machinery to hold. Recorded on the field itself — `Notifications._id` in `lib/providers/notifications_provider.dart` — which is where a future change keyed on the notification id would look.

## Context

Five code paths can send `To_SignerResponse(accept: true)` in the shipped app: the mobile sign dialog, the mobile connect dialog, the desktop sign item, the desktop connect item, and the autosign fast path in the request delivery boundary. The first four are user decisions; the fifth is not.

Only three of the four user paths had an authentication gate. `SwaptionSignRequestDialog.onAllow` had none — it built the response and sent it synchronously, in the same microtask as the button press. `SwaptionConnectDialog.onAllow` had the gate but popped `true` outside it, and `SwaptionNotificationListener` maps that pop result to the resolution reason: a cancelled PIN prompt therefore recorded the request as *accepted by user* while nothing had been sent to the origin.

The gate was not designed away. It was removed as collateral: `e386f22f` deliberately moved authentication off the autosign signing path onto the autosign checkbox — an autosign that prompts is not an autosign — and `0a85b06b`, 85 minutes later, also stripped `isAuthenticated()` from the manual mobile sign dialog. No spec, clarification or review covers that second removal. Desktop was untouched. It survived four months, on one platform, with no record that a decision had been made.

That is the reason this ADR exists, and the reason its central decision is phrased as an invariant rather than as "restore the gate on mobile". A future reader can violate "restore the gate" without noticing; violating decision 1 below is visible in a diff.

### What the measurements showed

Nine facts constrain the design, and each one killed an option that looked reasonable. Rust citations are against `sideswap-io/sideswap_rust` at `f53ba9d` (2026-08-12) — the original. A separate `sideswap_rust_private` test repo exists locally with an older architecture; nothing here is measured against it.

- **`isAuthenticated()` is not an unconditional prompt** (`lib/providers/wallet.dart:1659-1688`). With PIN protection it delegates to `pinBlockadeUnlocked()`; with biometrics it decrypts via `decryptBiometric`; with neither it silently `decryptFallback`s and returns whether the mnemonic validates. For an empty encrypted mnemonic — Jade — it returns `true` immediately, under a comment reading "Temporary workaround for Jade". So "gate it" and "always prompt" are different requirements.
- **The wire format cannot express a third outcome.** `SignerResponse` is `required string req_id` plus `required bool accept` (`sideswap_rust/sideswap_client/proto/sideswap.proto:391-394`). Telling an origin "the user failed authentication" as distinct from "the user refused" needs a protocol change in the Rust client, the Liquid Connect backend and the origin SDK.
- **A response for an already-resolved request dies silently.** `ui_response` (`sideswap_client/src/worker/wallet_connect.rs:338-400`) tests `req_id` with `connect_core.get_login_request(...).is_some()` then `get_sign_request(...).is_some()`, and has **no trailing `else`**. No `unwrap`, no `expect`, no log line on that branch. `try_sign_pset` looks the request up with `.ok_or_else(|| anyhow!("request already removed"))?` (`:151-164`), also graceful. The panic hook does `std::process::abort()` (`sideswap_common/src/panic_handler.rs:1-7`), but this path never reaches a panicking primitive.
- **The Rust client holds no deadline and enforces none.** `WalletConnectCore` (`sideswap_common/src/wallet_connect.rs:79-96`) stores no timestamp for any request, and the module contains no timer, tick input, or expiry sweep. Expiry is entirely the server's: the wallet learns of it only as an incoming `LoginRequestRemoved` / `SignRequestRemoved` notification, which is what produces `SignerCancel`. `docs/connect.md` models expiry as a transition owned by the server actor.
- **Nothing on the Rust side re-validates a deadline when an acceptance arrives.** A late acceptance is forwarded to the server unconditionally, gated only on the id still being in the local map (`sideswap_common/src/wallet_connect.rs:383-416`). So the app's re-check is load-bearing rather than a belt over a Rust brace.
- **The TTL is a server-supplied relative duration, passed through unmodified.** `ttl_milliseconds: login_request.ttl.as_millis()` (`sideswap_client/src/worker/wallet_connect.rs:196`, `:218`), taken verbatim from the server notification. Being relative rather than an absolute deadline, transport and queueing latency before display are not subtracted.
- **The local TTL is therefore counted from receipt.** `createdAt` is `DateTime.now()` at the moment `addNotification` runs (`lib/providers/notifications_provider.dart:135`, `:161`). A phone that was offline or backgrounded starts its countdown late, so the local clock is systematically more generous than the server's.
- **The TTL cannot be absent in practice.** `required uint64 ttl_milliseconds = 3` inside `SignerRequest` (`sideswap_client/proto/sideswap.proto:859`), and `ttl: DurationMs` — not `Option` — on both Rust request types (`sideswap_api/src/connect_api.rs:19-32`). The Dart side nonetheless models it as optional: `signRequest.hasTtlMilliseconds() ? Option.of(...) : none()` (`lib/providers/notifications_provider.dart:136-138`, `:162-164`), and `SignRequestNotificationTtl.build` returns `none()` before creating its `Timer.periodic` (`:443-450`), so such a request would start no countdown. That branch is defensive, not reachable through the current protocol. (`required` constrains presence, not value: a zero TTL is representable.)
- **`none()` from the TTL provider is ambiguous.** It is returned for a request with no TTL, for a request that is gone, and for a request cancelled remotely. A re-check written against that provider cannot distinguish "no deadline" from "deadline passed".

## Decisions

### 1. Every acceptance driven by a user action passes `isAuthenticated()`

`To_SignerResponse(accept: true)` originating in a user action is sent only after `isAuthenticated()` has returned `true`. This holds on both platforms and for both request kinds.

**Autosign is the single exception, and it is not a hole.** Autosign authenticates once, at the checkbox that enables it, and the signing itself is silent by design — that silence is the feature. An autosigned request never reaches a dialog: `_handleSignerRequest` calls `addNotification` on every branch except the one where autosign is on and the USD limit check passes, and that branch sends directly and returns.

The gate is expressed as an early return rather than a widening `if`, so that the acceptance path reads top-to-bottom with no branch spanning it. Desktop uses the widening form today; the two are behaviourally identical and desktop is not rewritten for style.

### 2. After the gate returns, the request is re-checked as still pending — and the widget is checked before either

> **Refined by [ADR-0009](0009-liquid-connect-acceptance-attempt-identity.md) and [ADR-0010](0010-liquid-connect-local-expiry.md).** The three-step order below — liveness, then identity, then state — and its reason both stand. ADR-0009 moved where the liveness guard lives: the acceptance path no longer runs in a widget, so `context.mounted` became `ref.mounted` on the notifier. ADR-0010 falsifies the residual-gap sentence below: local expiry is no longer applied by a widget-scheduled microtask but by a timer in the notifier, so the residue is that timer's scheduling latency, which is unbounded under load rather than a microtask long. Also note, against the identity argument below: notification ids do **not** in fact restart after `clearAll()` — the notifier instance survives `invalidateSelf` — so the `reqId` comparison defends against something that cannot happen. It stays, because it is correct either way.

Awaiting authentication opens a window in which the request can be resolved underneath the prompt — its TTL can elapse, or the origin can withdraw it. Before sending, the acceptance path confirms the request is still pending.

**Three things must happen in this order, and the order is the decision.**

1. **`context.mounted` first.** `WidgetRef.read` asserts its widget is still mounted and throws `StateError` otherwise, so a re-check written before the mounted guard throws exactly in the case it exists to handle. Every post-await use of `ref` *or* `context` sits behind the guard, in all four call sites. The existing mobile connect callback violates this today.
2. **Then identity, not just presence.** The entry is fetched with the notifier's own `getNotification(id)` and its `reqId` is compared against the one captured before the await. ~~The local id is a counter (`_id`) on a notifier that `clearAll()` invalidates, so ids restart from zero and a bare integer match can address a different request across notifier generations.~~ **Measured false — see ADR-0010 measurement 5 and #211: the notifier instance survives `invalidateSelf`, so `_id` keeps counting.** The identity check stands anyway, on the ground that a bare integer is not an identity and `reqId` is the strongest one the protocol offers.
3. **Then state.** The entry must not be in the cancelled state.

**The check is presence-and-identity, not TTL arithmetic.** A TTL comparison would miss remote cancel entirely, and reading the TTL provider cannot distinguish "no deadline" from "deadline passed" — it answers `none()` for a request with no TTL, for a request that is gone, and for a request cancelled remotely. Presence separates those cases without ambiguity.

The residual gap is honest and small: local expiry is applied by a widget-scheduled microtask, so a request can be present for a microtask longer than its deadline. A response sent into that gap is dropped by the Rust client.

### 3. Route teardown is by identity, not by stack position

> **Partly falsified by [ADR-0010](0010-liquid-connect-local-expiry.md).** The sentence below reading "The TTL effects in the two child dialogs record the resolution and stop touching navigation" describes effects ADR-0010 decision 5 deletes: the expiry is recorded by the notifier now, and the teardown follows from the request leaving the pending set exactly as this decision requires. The decision itself — teardown by identity, from one place — stands.

`Navigator.pop` removes the topmost route of its navigator, not the route that owns the context it was given. Authentication is itself a route on the same root navigator — `PinProtection` is shown with `showDialog` — so a programmatic `pop` issued while the PIN prompt is up takes the **prompt**, not the request dialog. The gate then reports failure, the acceptance path correctly sends nothing, and the request dialog is left on screen with its request already removed: an empty modal the user has to dismiss by hand.

So programmatic teardown uses `removeRoute` with the route captured by the dialog that owns it, and it lives in exactly one place — `SwaptionDialog`, which owns the route — triggered by the request leaving the pending set. The TTL effects in the two child dialogs record the resolution and stop touching navigation.

**The rule that decides which paths may still pop: a path that crossed no `await` may pop; a path that crossed one must remove by identity.** The close affordance and the device back button are reachable only while the dialog is topmost, and nothing intervenes between the decision and the pop, so they pop directly. The acceptance path crossed the gate, and "the dialog is topmost again afterwards" would hold only because single-flight prevented a second prompt — binding route correctness to button-disabling correctness is the shape of the original defect. It removes by identity.

**Whether the request is still pending is answered by a provider, not by the widget.** A family keyed by `(notificationId, reqId)` yields `Option<NotificationData>`: the entry while it is pending, and nothing once it is absent, cancelled, or carrying a different request id — the last covering an id paired with a request it does not address. The dialog renders while it is present and tears its route down when it is not; it computes no predicate of its own.

This placement is the decision, not an implementation detail. In a widget, reaching for the notifier with `read` instead of subscribing with `watch` compiles, reads correctly, and fails silently as "the dialog never closes" — the exact symptom being fixed. In a provider, under this repo's 100 % provider coverage gate, the same mistake fails a test. The existing derivations from the notification list in the same file are the prior art for the shape.

This also makes biometric and PIN wallets behave alike, where previously only PIN pushed a competing route.

### 4. Mobile stops encoding the resolution in the navigation result

> **Partly superseded by [ADR-0009](0009-liquid-connect-acceptance-attempt-identity.md).** The single-flight guard described below as "a flag set synchronously before the first `await` [that] disables the acceptance control" no longer lives in the widget: an acceptance attempt is identified by the request id and outlives every widget that observes it. Everything else in this decision stands.

`pop(result)` is the wrong carrier for a resolution, and the reason is the same as decision 3: the result goes to whatever route is on top. The consequences are not theoretical.

- **It bypasses the gate this ADR exists to install.** `onPinBlockade` returns the dialog's pop result (`lib/app_main.dart:156-164`). Two taps on Allow start two acceptance callbacks, each pushing its own PIN route. The user completes the top one; that callback sends, then calls `pop(true)` — which lands on the *other*, unfinished PIN route and completes it with `true`. The second `isAuthenticated()` returns true having never been answered, and a second acceptance goes out.
- **It mislabels programmatic teardown.** `removeRoute` completes the route's future with `null`, and the listener maps anything other than `true` to *rejected by user* — so an expiry would be recorded a second time under the wrong reason.

So every resolution path records its own reason explicitly, the way desktop already does: acceptance calls `removeNotification(reason: acceptedByUser)`, user rejection `rejectedByUser`, expiry `expired`. The close affordance keeps sending `accept: false` as it does today and now records the reason alongside it — the same shape as desktop's Cancel, which sends the rejection and removes with `rejectedByUser` in one place. Route teardown then follows from the request leaving the pending set, under decision 3.

`SwaptionNotificationListener` stops translating pop results. Its predicate becomes: **the dialog closed and the request is still in the pending set → record *rejected by user***, ignoring the navigation result entirely. That predicate is sound because every path records its reason *before* its route goes away, so by the time the dialog's future completes, an anticipated closure has already left the pending set. **That ordering is a standing condition of this design, not an incidental property.** What remains for the safety net is closures nobody planned.

**The send and the record must stay in one synchronous block.** `sendMsg` is `void` (`lib/providers/wallet.dart:211`), so today nothing can interleave between `sendMsg(accept: true)` and `removeNotification(reason: acceptedByUser)`. That is what keeps the converse of decision 1 true — an acceptance that was sent is always recorded as accepted. Introduce an `await` between them and the widget can unmount in the gap, the record is skipped, and the safety net below then records the request as *rejected by user* after the origin has already been told yes. Anyone making `sendMsg` asynchronous must revisit this.

**A single-flight guard is part of this decision, not an optimisation.** A flag set synchronously before the first `await` disables the acceptance control until the attempt finishes, on both platforms. Removing the pop result stops the second callback from being *authenticated* for free; only single-flight stops two prompts from being raised at all.

**The dialog binds to an immutable `(notificationId, reqId)` passed in, never to the mutable global selection.** `_announceRequest` calls `setState(notificationId)` on `showNotificationMenuProvider` for every incoming mobile request (`lib/providers/notifications_provider.dart:204`), and `SwaptionDialog` derives its content from that selector — so a second request arriving today silently repoints an open dialog at different content while the user is looking at it.

This reverses an earlier decision to leave the two platforms' recording mechanisms different on the grounds that the mobile one worked. It does not: it is the carrier for all three defects above.

### 5. On mobile, one request is presented at a time, oldest first

> **Partly superseded by [ADR-0010](0010-liquid-connect-local-expiry.md).** The sentence below reading "the countdown provider only runs its timer while something watches it — so a queued request does not expire while it waits" is no longer true: local expiry is recorded by the notifier, unconditionally, so a queued request expires where it stands. The deadline check before presentation stays, as a guard against the gap between the deadline and the sweep firing. Everything else in this decision stands.

Binding a dialog to an immutable identity stops a second request from repointing an open one. On its own that trades a silent defect for a visible one: instead of the content changing under the reader, a second dialog opens on top of it — and a request the user is about to approve can be covered a moment before they tap.

Both are the same failure. So mobile presents one request at a time. While a dialog is open, an arriving request joins the pending set, raises its badge and its OS notification, and waits. The next dialog opens only once the current request is resolved — by acceptance, rejection, expiry or remote cancel.

**Oldest first.** A request carries a deadline, so a queue served newest-first systematically starves the request with the least time left. Serving oldest-first spends the queue in the order the deadlines fall.

**A queued request is checked against its deadline before its dialog opens**, and if the deadline has passed it is removed as *expired* without ever being shown. This is not hypothetical: the countdown provider only runs its timer while something watches it, and on mobile only the open dialog does — so a queued request does not expire while it waits. Without the check it would be presented, evaluate as expired on its first frame, and vanish; a dialog too brief to read or dismiss is worse than no dialog.

Desktop is unaffected: it presents its requests as a list, where simultaneity is the point.

### 6. Neither a failed gate nor a failed re-check sends anything — but they differ in what stays on screen

The origin learns nothing in either case. It cannot be told anything more specific — the wire format has two fields — and sending `accept: false` instead would be indistinguishable from a refusal while also destroying the retry the user still has in front of them.

The two failures are not the same event, and conflating them produces an untestable rule:

- **The gate failed while the request is still pending.** Nothing is sent and nothing is closed. On mobile the dialog stays open and the user may authenticate again, or leave through the close (X) affordance or the device back button; both of those send an explicit `accept: false`, as they already do. There is no Cancel button in either mobile dialog. On desktop the item stays in the panel.
- **The re-check failed because the request was resolved.** Nothing is sent, and the request's UI is already going away under decision 3 — it is not the acceptance path's job to keep it alive.

No feedback is shown on gate failure, on either platform — a user who has just dismissed their own biometric prompt knows why nothing happened.

The structural consequence matters more than the behavioural one: with `pop(true)` unreachable without a successful gate, the resolution reason *accepted by user* cannot be recorded on mobile unless an acceptance was actually sent.

### 7. The local TTL is a hint to the user, not an authority over the request

> **Refined by [ADR-0010](0010-liquid-connect-local-expiry.md).** The rule below stands — a request with a TTL is removed locally at `ttl <= 0` with reason *expired*, and the local clock is a hint rather than an authority. Three things change. The removal is **unconditional** and is recorded by the notifier, not by whichever widget happens to be mounted. The comparison behind `ttl <= 0` becomes millisecond-precise, so the removal happens *at* the deadline instead of up to a second before it — the truncating `.inSeconds` comparison this decision was written against turned out to put a second of indeterminacy in the middle of the mechanism. And a request whose deadline has already passed when it arrives — a TTL of zero, and only that — is dropped at delivery without entering the pending set at all.

The countdown tells the user roughly how long they have. It is not the deadline the system enforces — and the measurements make that literal rather than rhetorical: the Rust client stores no timestamps and runs no expiry at all. The server withdraws expired requests, the Rust client relays the withdrawal as `SignerCancel`, and that is what actually resolves the request as *remote cancel*. The app's countdown is a second, independent clock that started later and enforces nothing outside the app.

Two behaviours follow, and both are deliberate:

- A request **with** a TTL is removed locally at `ttl <= 0`, with reason *expired*.
- A request **without** a TTL waits for the user rather than being expired locally. There is no deadline to enforce and none is invented.

**The second is defensive, not a protocol rule.** `ttl_milliseconds` is `required` on the wire, so the current producer cannot emit a request without one; the Dart side nonetheless models it as optional and this decision states what that branch does. It is not a promise that such a request exists, and "waits for the user" is not "waits forever" — it can still leave through remote cancel, a user action, desktop *Clear all*, or the notifier being disposed.

Rejected: making the app extend, refresh or freeze the countdown while an authentication prompt is up. That would put the app's clock in charge of a deadline the server owns, and a user who misses the window simply retries from the web page — which is where they are already looking.

### 8. Desktop is modified here, against the initial scope

The work was framed as restoring mobile to desktop parity, with desktop untouched. Decision 2 breaks that frame: desktop has the gate but not the re-check, so the same window exists there, and on desktop it is provably reachable — `pinBlockadeUnlocked()` is an ordinary Flutter route, so timers keep running underneath it.

Fixing only mobile would leave the correct platform carrying the defect while the ADR that exists to prevent exactly that asymmetry sits in the same commit.

## Consequences

- Mobile sign acquires an `await` between the button press and the send that it did not have. The re-check closes most of the window, but not all of it, and the residue is **not** absorbed by the Rust client. ~~Local expiry is applied by a widget-scheduled microtask, so the app can still consider a request pending for a moment past its own deadline~~ **(superseded by ADR-0010 decision 1: expiry is recorded by a timer in the notifier, so the residue is that timer's scheduling delay, unbounded under load rather than a microtask long)**; and because the Rust client keeps no deadline, it forwards such an acceptance to the server whenever the server has not already withdrawn the request. Only an acceptance for a request the *server* has withdrawn is silently dropped. The honest statement is that a locally late acceptance may reach the server, which then decides.
- One new provider: the family that answers whether a given `(notificationId, reqId)` is still pending. It carries the lookup that would otherwise sit in widget code, and falls under the 100 % provider coverage gate — which is the point.
- Seven sites change: the two mobile acceptance callbacks and the two mobile close callbacks, the two desktop acceptance buttons, and `SwaptionDialog` (immutable identity plus the route-teardown effect). ~~The two mobile TTL effects lose their `onClose(cancel: false)` call~~ **(superseded by ADR-0010 decision 5, which deletes those effects entirely)**, and `SwaptionNotificationListener` gains both the serialisation guard and its narrowed safety-net predicate.
- Decision 3 is mobile-only. Desktop renders its requests as items in a panel, not as routes, so it has no route to tear down and no competing prompt route to protect.
- The re-check uses the notifier's existing `getNotification(int id)` accessor rather than a local `firstWhereOrNull`, so no import is added on either platform.
- The two platforms converge on one mechanism: every resolution path names its own reason. `SwaptionNotificationListener` keeps only its safety-net role. This is a larger diff than the gate alone, and it is the reason decision 4 exists as a decision rather than as an implementation note.
- Acceptance controls gain a busy state on both platforms. Any test that taps twice expecting two sends is asserting the defect.
- "A request without a TTL is not expired locally" is currently emergent — it falls out of the order of two statements in `SignRequestNotificationTtl.build` and is asserted nowhere. Decision 7 makes it a rule, so it needs a test, written as "no expiry is recorded", not as "it never leaves".
- The mobile close (X) and device-back affordances keep their current behaviour of sending an explicit rejection. Neither mobile dialog has a Cancel button; desktop does. Any copy that says "Cancel" about mobile is wrong.

## What this ADR does not settle

- **Whether a remote-initiated signature should prompt unconditionally**, regardless of the local PIN setting. It does not today: a wallet with neither PIN nor biometrics passes the gate in silence, and Jade passes it immediately. Making remote-initiated acceptance always challenge the user needs a new primitive and a decision about wallets that hold no secret to challenge.
- **Whether gate failure deserves visible feedback.** Deliberately not added, for parity. If a manual pass shows the Allow button reads as dead, that is a separate change with a real observation behind it.
- `DNotificationSignPopup` (`lib/desktop/widgets/d_notifications.dart:1266-1446`) is never instantiated anywhere in `lib/`. Its three `To_SignerResponse` sites are unreachable, and it is gated by Jade one-time authorization rather than by `isAuthenticated()` — so it neither satisfies nor violates decision 1 while it stays dead.
- **A connect request withdrawn while the socket is down is never reconciled.** On re-login the Rust client diffs `sign_requests` against the server's fresh list (`sideswap_common/src/wallet_connect.rs:180-205`), but `LoginResp` carries no `login_requests` field (`sideswap_api/src/connect_api.rs:83-87`), so there is no equivalent sweep for connect requests and `Disconnected` pushes no effects. A `LoginRequestRemoved` that the server sent while the socket was down produces no `SignerCancel` after reconnect. Decision 2 detects remote cancel through the notification's absence, so within that window it cannot: the entry is still there. A narrower residue than a design flaw, but real, and it lives in the Rust client rather than here.
- **Active `request_id` uniqueness is a Rust invariant this ADR relies on and does not establish.** `LoginRequestCreated` / `SignRequestCreated` insert unconditionally and always push an add effect (`sideswap_common/src/wallet_connect.rs:267-274`, `:283-290`); only the re-login resync dedups, and only for sign requests (`:198-204`). So a second request reusing a live `request_id` would overwrite the Rust map entry while the app gained a *second* notification — and accepting the first would sign the second's PSET, since only `reqId` crosses the wire. Decision 2's identity check cannot detect this: both notifications carry the same `reqId`, which is the strongest identity the protocol offers. Whether the server ever reuses a live id is not determinable from either repository. This is pre-existing, independent of the gate, and belongs to the Rust client.
- **Whether a mobile biometric prompt suspends the Dart event loop.** If it does, local expiry cannot fire while the prompt is up and decision 2's mobile half guards a state that cannot occur — which is not a reason to drop it, since the desktop half is provably reachable and both share one shape. A manual pass answers it; nothing here depends on the answer.

## Review notes

Findings from the two review passes that **changed** the design, rather than confirming it. Each was verified against source before being accepted; the ones that did not survive verification are listed too, because a future reader will otherwise rediscover them.

Devil's advocate, on the first version:

- Reading `ref` after the await before checking `context.mounted` throws `StateError` exactly in the case the re-check exists to handle → the ordering in decision 2.
- `Navigator.pop` takes the top route, and authentication is a route on the same root navigator → decision 3. Without it, a PIN wallet whose request expired mid-prompt was left with an empty modal.
- ~~`clearAll()` ends in `ref.invalidateSelf()`, restarting the notification id counter, so an integer match is not an identity~~ → the `reqId` comparison in decision 2. **The premise was measured false (#211): `invalidateSelf` rebuilds the element without replacing the notifier riverpod caches against it, so `_id` survives the call and keeps counting.** The comparison stays on the half of the argument that survives — a bare integer is not an identity, and the request id is the strongest one the protocol offers — rather than on a reset that never happens.
- "On gate failure the dialog never closes" is false when the failure *is* the request having resolved → the split in decision 6.
- `ttl_milliseconds` is `required` on the wire, so the no-TTL branch is defensive rather than a protocol rule → the reframing in decision 7.

Adversarial, on the second version:

- `onPinBlockade` returns the dialog's pop result, so one acceptance callback's `pop(true)` completes another's unfinished PIN route as a success → decision 4. This was the most serious finding in either pass: the fix as designed could bypass the gate it was installing.
- `removeRoute` completes the route future with `null`, which the listener mapped to *rejected by user* → the safety-net predicate in decision 4.
- `_announceRequest` repoints the global notification selection on every new mobile request, so an open dialog silently changes content → the immutable identity in decision 3, and decision 5.
- "A locally late acceptance is dropped by the Rust client" is only true once the *server* has withdrawn the request; the Rust client keeps no deadline → corrected in Consequences.

Findings that did **not** survive verification:

- That `remove_login_request` removes from the wrong map and so breaks remote cancel for connect requests. True of a local `sideswap_rust_private` test repo, not of the original — where the function removes from `login_requests` and always emits `SignerCancel`. Rust facts were re-measured against `f53ba9d` after this.
- That `try_sign_pset` panics on the acceptance path. It looks the request up with `.ok_or_else(...)?`; the nearby `expect` is on signer construction and unrelated to expiry.
- That the send-then-record sequence can be interrupted by an unmount. `sendMsg` is synchronous, so it cannot — recorded as a standing condition in decision 4 rather than as a defect.
