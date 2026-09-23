# ADR-0010 — Liquid Connect: a request expires whether or not anything is looking at it

- **Status:** Accepted. Implementation pending — issue #210.
- **Date:** 2026-08-18
- **Driver:** a user report on desktop. A sign request arrives, the panel opens itself, the user clicks outside and the panel closes; the bell keeps its dot long after the countdown would have run out, and reopening the panel shows the request for a fraction of a second before it vanishes.
- **Relationship to ADR-0006:** this ADR **supersedes ADR-0006 decision 5** in the part that reads "the countdown provider only runs its timer while something watches it … so a queued request does not expire while it waits" — that stops being true, and the guard the sentence justified stays for a different reason, stated in decision 6 below. It **refines ADR-0006 decision 7**: the rule "a request with a TTL is removed locally at `ttl <= 0`, with reason *expired*" stands, and so does its conclusion that the local clock is a hint rather than the authority; what is new is that the removal is **unconditional**, recorded by the notifier rather than by whichever widget happens to be mounted, and that it now happens at the deadline rather than up to a second before it. It also **falsifies text inside ADR-0006 decisions 2 and 3 and its Consequences**, all of which describe the widget-scheduled expiry that decision 5 below removes; pointers are added at each site. ADR-0009 stands in full.
- **A warning about the phrase "one writer":** decision 5 is named that and does not mean it literally. The sweep is the only *unconditional* writer of an expiry; decision 6 keeps a guard that also records one, inside a window the sweep cannot close. Read both decisions or neither.
- **Reviewed by:** three adversarial passes in fresh contexts — two in-session (correctness, state-and-integration, spec-compliance, plus a concurrency lens each) and one by Codex — with every finding re-verified at its citation, one of them by running the code. See [Review notes](#review-notes). The second pass reversed the scope: an earlier draft fenced the truncating comparison off as out of scope, and six of its findings turned out to be that fence. The third found no defect in that reversal and six overclaims around it; it could not read issue #210, so the acceptance criteria have had one hostile pass rather than two.

## Context

ADR-0006 decision 7 settled what a local TTL means: a hint to the user, counted from receipt, with no authority over a deadline the server owns. It also settled what happens when the hint runs out — the request leaves the pending set with reason *expired*.

What it did not settle, because nobody noticed there was a question, is **who performs that removal**. Today the answer is: the widget that happens to be on screen. `SignRequestNotificationTtl` (`lib/providers/notifications_provider.dart:521-522`) is autoDispose and creates its `Timer.periodic` inside `build` (`:569`), so it counts only while something watches it — and the only things that watch it are four widgets. Each of those four records the expiry itself when the count reaches zero.

Close the desktop panel and nothing watches. The countdown stops, the entry stays in the list, and every consumer of "what is still pending" goes on answering with a request whose deadline went by minutes ago. Reopen the panel and the item mounts, evaluates as expired on its first frame and disappears — the flash the user reported.

The flash is the least of it. The stale entry is read by three consumers, and only one of them is a view.

### What the measurements showed

1. **Expiry is recorded by widgets, in four places.** `lib/desktop/widgets/d_notifications.dart:714-719` (sign item) and `:1062-1067` (connect item); `lib/screens/swaption/swaption_dialogs.dart:211-220` (connect dialog) and `:433-440` (sign dialog). All four are `useEffect`s keyed on the countdown. A fifth site also records *expired* — `lib/listeners/swaption_notification_listener.dart:67-73` — but not from a countdown: it is the guard mobile already has for the case this ADR generalises, and decision 6 keeps it.
2. **Three consumers of the pending set go stale, and one of them is not a view.**
   - `activeNotifications` (`:409`) — a `bool`, not a count. It draws the dot on the toolbar bell (`d_notifications.dart:183`) **and** drives the panel's own opening and closing (`:131`, `:144`, `:153`), so it is two behaviours, not one.
   - `pendingBadgeCount` (`:369`) — the count on the process's app icon, written through `DesktopWindowService.setPendingBadge` (`lib/providers/desktop_window_service.dart:427`) at every list boundary (`_updateBadge`, `:104`).
   - **The raise episode.** `removeNotification` is what calls `onRequestResolved` (`:282`), which is what reaches `_resolve` (`desktop_window_service.dart:439`). No removal means no `_resolve`: `_unresolvedRequestIds` keeps the id, `_episodeOpen` stays `true`, `_cancelAttention()` (`:457`, `:498`) never runs, and `_syncListener` keeps a window listener registered — for the rest of the session, or until an unrelated real resolution happens to empty the set. This is the consumer that kills the "let the panel filter expired entries when it opens" shape outright: a panel that never opens filters nothing, and the episode is not a thing the panel can reach.
3. **`Duration.inSeconds` truncates toward zero, and both predicates use it.** `requestDeadlinePassed` (`:393-406`) and `SignRequestNotificationTtl.updateState` (`:590`) both compare `.inSeconds <= 0`, deliberately matched "second-for-second". A request with 900 ms left is therefore already expired by both, and one with exactly 1000 ms left is not. Everything awkward about an earlier draft of this ADR came from treating that as fixed — see decision 2.
4. **The clock skew runs one way; the truncation runs the other.** `ttl_milliseconds` is a relative duration passed through unmodified, and `createdAt` is stamped with `DateTime.now()` at the moment `addNotification` runs (`:135`, `:161`); transport latency is not subtracted. So the local *deadline* lands at `receipt + ttl = issue + latency + ttl`, at or after the server's `issue + ttl`. The local *removal* lands up to 999 ms before that deadline, and therefore before the server's whenever the request arrived in under a second. Neither direction is bounded overall: a slow transport puts the removal arbitrarily late, and the truncation puts it up to a second early.
5. **The notifier survives `clearAll()`.** `clearAll()` ends in `ref.invalidateSelf()` (`:346`), but riverpod caches the notifier instance per element and never resets it (`riverpod-3.4.2/lib/src/core/provider/notifier_provider.dart:549`, `classListenable.result ??=`, with no reset anywhere in the package). Measured on this lockfile: the instance is identical across the call and its element stays mounted. The `onDispose` callbacks registered during the build *do* run — the badge test at `test/providers/notifications_provider_test.dart:2646` asserts the two zeros that proves it — so a timer cancelled in `onDispose` is genuinely cancelled. What does **not** happen is a crash: a timer that is *not* cancelled fires into a live notifier and sweeps the next generation's entries silently.
6. **A zero TTL is representable.** `required uint64 ttl_milliseconds` constrains presence, not value (ADR-0006 measurements). Because `createdAt` is stamped on arrival, that is the only way a request can be past its deadline at the moment it is received.
7. **`connect` and `sign` are a protobuf `oneof`.** One message cannot carry both, which `nextPendingRequest`'s own doc comment records (`:481-487`). `addNotification` nonetheless appends from both branches (`:127-128`, `:152-153`) and would produce two entries under one id, so everything this ADR says about that case is defensive in the way the existing code already says it is.
8. **`removeNotification` removes by id, not by entry** (`:272`). Two entries sharing an id go together, and they carry two different `createdAt` stamps, so they do not share a deadline. Defensive per the `oneof` above, and constraining anyway: a sweep cannot be specified as "remove each entry whose deadline has passed" when the only removal primitive is coarser than an entry.
9. **A cancelled entry can never be recorded as expired today.** `SignRequestNotificationTtl.build` returns `none()` for one (`:546-553`), so no widget effect ever reaches zero for a cancelled entry — while `requestDeadlinePassed` (`:393-406`) does not look at the state at all. Anything reusing that predicate inherits the wider behaviour unless it filters.
10. **The desktop app-icon badge is desktop-only.** Both the write in `build` (`:79`) and `_updateBadge`'s effect are behind `FlavorConfig.isDesktop` (`:70`); mobile has no such badge, so on mobile the stale entry is visible only through the presentation queue.

## Decisions

### 1. Local expiry is a fact about the request, recorded by the notifier

When a request's deadline passes, `Notifications` removes it with reason *expired*. Unconditionally: no widget has to be mounted, no panel open, no provider watched.

**"When the deadline passes" names the trigger, not the instant.** The removal runs on a timer callback, so it happens at the first moment the scheduler delivers one after the deadline — decision 6 calls that delay unbounded under load, and it is. What decision 2 makes millisecond-precise is *where the boundary sits*, not *how promptly it is crossed*. Nothing in this ADR promises the second. The rule ADR-0006 decision 7 wrote down is unchanged; what changes is that it now holds at all times rather than while somebody is looking.

**This does not make the local TTL an authority.** The local deadline lands at or after the server's, because the countdown starts at receipt and the server's at issue. The app's removal is therefore an approximation of a withdrawal the server owns and has usually already performed — not a retraction the app decides. How loose the approximation is has no bound in either direction: a slow transport puts the local deadline arbitrarily after the server's (measurement 4), and the scheduling delay puts the removal arbitrarily after that. An earlier draft claimed the removal could never be early, and a later one claimed the error was bounded by a second; both were false and both are recorded in the Review notes. What decision 2 buys is a boundary that is exact and shared, not an error that is small.

**Rejected: keeping the entry and adding a third `NotificationItemState.expired()`** — visible in the panel, no longer counted as pending, removed only by `SignerCancel` or a user action. `pendingBadgeCount`'s doc comment anticipates a third state, so the shape is available. It leaves the user a dead row with no affordance to clear it in exactly the case where no `SignerCancel` is coming — ADR-0006 records a connect request withdrawn while the socket was down, for which none is ever produced, because `LoginResp` carries no `login_requests` field for the re-login resync to diff. An entry waiting for a message that will not come waits for the session.

**Rejected: narrowing the predicates instead of removing the entry** — teaching `activeNotifications` and `pendingBadgeCount` to skip expired entries and leaving the list alone. Both become functions of wall-clock time that nothing recomputes, so without a ticker the dot never goes out; with a ticker this is decision 2 plus a dead entry. And neither touches the raise episode, which is not derived from those predicates at all.

### 2. The deadline comparison becomes millisecond-precise, for every caller at once

`requestDeadlinePassed` stops asking `endTimestamp.difference(now).inSeconds <= 0` and starts asking whether `now` has reached `endTimestamp`.

**The shared artefact is a predicate over a receipt instant and a TTL, not over an entry.** `requestDeadlinePassed` keeps its signature and becomes a thin wrapper that unpacks `createdAt` and `ttlMilliseconds` out of a `NotificationData` and delegates. The delivery check in decision 4 has no entry to unpack, so it calls the inner predicate directly with the instant it is about to stamp as `createdAt` — the same instant, not a second `DateTime.now()`. The arming in decision 3 needs the boundary as a *time* rather than as a boolean, so it takes it from the same pair.

That is three shapes of one fact, and naming them is the point: an implementer told only "one expression, every caller" has to invent the seam, and the two places most likely to diverge are exactly the boundary comparison and which `now` the delivery check stamps.

This is a change to shipped behaviour and it is the pivot of this ADR, so the reasoning is set out rather than asserted.

**The truncation is not a rounding detail; it is a second of indeterminacy in the middle of the mechanism.** `Duration.inSeconds` truncates toward zero, so the current predicate answers "expired" from 999 ms before the deadline. Everything that made an earlier draft of this ADR awkward followed from accepting that:

- the arming instant became unnameable — not `createdAt + ttl`, which is a second late, and not `createdAt + ttl − 1 s`, which is the one instant where the predicate still answers false, leaving no writable third expression;
- "drop the request that arrived already expired" silently meant "drop every request with under a second of TTL", which is a policy nobody chose;
- a request with 1000–1999 ms of TTL was admitted, raised the window, opened the panel and was swept 0–999 ms later — the exact outcome decision 4 exists to prevent, for a whole second of TTL values just above its threshold;
- the log line was required to state "by how much the deadline had passed" for requests whose deadline had not passed;
- the item would have vanished while its countdown still rendered `1` — not the behaviour today, where one widget both renders and removes from the same sample and so always shows `0`, but the behaviour that draft would have produced, because its sweep fired on its own schedule a second before the display reached zero;
- and the criterion that would have caught a wrong arming could not be written, because no real `Timer` can land on the single microsecond where the two candidate armings differ.

With a millisecond comparison all six dissolve at once: the arming instant *is* the deadline, the drop covers exactly the requests that are actually past it, the elapsed amount in the log is non-negative, and the countdown reaches zero before the entry goes.

**The behavioural change to existing callers is small and in the user's favour.** All four widget countdowns keep rendering `.inSeconds`, so the displayed number does not change; what changes is that a request is no longer treated as expired while up to 999 ms of its window remains. Nobody loses a request they could have acted on — they gain, at most, a second.

**Rejected: leaving the comparison alone and recording its consequences honestly.** That was the previous draft. It is defensible and it is cheaper, but it writes a second of indeterminacy into the definition of a fact this ADR exists to make definite, and it leaves the mechanism's central rule without a test that can fail.

**Rejected: changing the comparison only for the new callers.** Two predicates for one question, disagreeing for a second at the boundary, is worse than either alone.

### 3. One single-shot timer, armed at the deadline, rearmed after every fire

The notifier owns exactly one `Timer`, set for the earliest deadline not yet passed among the entries the sweep would act on, and cancelled in `onDispose` — which `clearAll()`'s `invalidateSelf` reaches (measurement 5). The cancellation is not optional, and the consequence of forgetting it is not a crash: the notifier is still alive, so a stray timer sweeps the *next* generation of entries in silence.

**Rearming has exactly two triggers.** (a) Once at the end of every sweep, **whether or not that sweep removed anything**; (b) once after any other change to the list. Nothing else rearms.

The "whether or not it removed anything" is load-bearing. A fire that removes nothing produces no state change, so a design that rearms only on state changes strands the timer — and that fire is reachable: a backwards wall-clock correction (NTP, a manual change, a laptop waking with a corrected clock) puts `DateTime.now()` behind where the arming assumed it would be, and every entry on the list is then stranded for the rest of the session. That is the defect this ADR exists to remove, reintroduced through the mechanism meant to fix it.

**The sweep rearms once, at the end — and so does every other multi-removal path.** Each `removeNotification` assigns `state` (`:272`), so trigger (b) read naively fires once per removal, over a half-emptied list. That is true of the sweep, and equally true of `cancelNotification`, whose microtask removes in a `forEach` (`:306-325`). The rule is per operation, not per assignment.

**The sweep skips entries in the cancelled state, and so does the arming.** A cancelled entry is leaving as *remote cancel*, under a resolution the server performed; recording it as *expired* would replace a known cause with a guessed one, and the reason is what ADR-0004's window policy turns on. Both halves must filter alike: an arming computed over a list the sweep will refuse to act on schedules a fire that can only be a no-op.

**An empty list arms nothing**, and a deadline already in the past arms `Duration.zero` rather than a negative delay.

**The sweep snapshots the list before mutating it.** `removeNotification` rewrites `state`.

**Two clocks cannot drift apart** — neither decrements; both recompute from `createdAt + ttl` against `DateTime.now()` whenever asked. A timer that fires late is a late notice, not an accumulated error. What they *can* differ in is sampling phase, which decision 2 addresses by making the sweep and the display agree at zero rather than a second apart.

**Rejected: a timer per entry.** N registrations to cancel under one disposal, and lifecycle bookkeeping in a notifier that holds none today.

**Rejected: a one-second periodic ticker.** Simplest to write, and it wakes the process every second for the life of the app whether or not anything carries a TTL.

**Rejected: an additional sweep on `AppLifecycleState.resumed`.** A suspended process does not run its timers, and both platforms suspend — mobile in the background, desktop across sleep and hibernation. The timer still fires on wake and still computes the right answer, because the state is derived from timestamps rather than decremented; the cost is lateness, not wrongness. Mobile has no app-icon badge, and the only mobile consumer that would notice is the presentation queue, which decision 6 guards. The rearm-after-every-fire rule is what makes a late or misaimed fire recover on its own.

### 4. A request that is already past its deadline on arrival is dropped at delivery

`addNotification` decides this on the `From_SignerRequest`, once, at the top of the method — before the id counter moves, before the window raise (`:122`), and before either payload branch. `requestDeadlinePassed` cannot be called there — it takes a `NotificationData` and no entry exists yet — so this calls the inner predicate decision 2 names, with the receipt instant it is about to stamp as `createdAt`.

The placement is about the raise, not about both payloads: the raise sits between the top of the method and either `if`, so a per-branch check is a check made after the window is already up. Both branches from one message is defensive anyway (measurement 7).

If the deadline has passed: no entry, no OS notification, no window raise, no badge write, and **no resolution reason** — the request never entered the pending set, so it never left it. Nothing is sent to the origin, which matches ADR-0006 decision 6's shape: the wire has two fields and neither of them says this. The vocabulary word is *dropped at delivery*, deliberately not *rejected by user*, which names a user action that sends `accept: false`.

**Under decision 2 this covers a TTL of zero and nothing else**, because `createdAt` is stamped on arrival. That is the whole scope, and it is stated because the previous draft's threshold was a second wide by accident.

**A short but live TTL still produces a brief panel, and that is deliberate.** A request arriving with 1200 ms left is not expired; it raises the window, opens the panel, counts down and goes. Suppressing it would need a floor, and a floor invents a deadline the server did not give — which ADR-0006 decision 7 forbids in those words. The user sees a countdown rather than a flash, which is the difference that matters.

**It is logged, at warning level**, with the request id, the origin and by how much the deadline had passed — a quantity that is now always non-negative. A request that vanishes with no record is indistinguishable from one that never arrived, and this is the one path where the app discards a request without the user ever having a chance at it.

### 5. One unconditional writer, and one guard that can still write

The four widget effects that record expiry are removed. Expiry is recorded by the sweep, and the request disappears from the panel and from the mobile dialog because it left the pending set, not because the element removed itself.

**"One writer" is not literally true and must not be written as if it were.** Decision 6 keeps `SwaptionNotificationListener`'s removal, which also records *expired*. The rule that holds is a division of labour: **the sweep is the only writer that runs unconditionally, and the guard writes only inside the window the sweep has not reached yet.** It says what to do if a third candidate ever appears — legitimate only as a guard over a window the sweep provably cannot close.

**The division is asymmetric, and honestly so.** The sweep's behaviour can be asserted with nothing mounted, where the guard cannot reach; the converse does not hold, because the guard runs its check on every loop turn and would mask a sweep that had been deleted entirely. Coverage of the sweep therefore has to come from the provider suite, not from the mobile presentation tests.

**`SignRequestNotificationTtl` keeps one job: the number on the screen.** Its `none()` still means three things — no deadline, no such entry, entry cancelled — and this decision does not disambiguate it. What changes is that nothing removes anything on its say-so, so the ambiguity is answered by a renderer with one answer for all three.

### 6. The mobile presentation guard stays, as a race guard

`SwaptionNotificationListener` keeps its `requestDeadlinePassed` check before opening a dialog (`lib/listeners/swaption_notification_listener.dart:67-73`). The code is unchanged; its justification is not, and the comment carrying the old one (`:61-66`) must be rewritten, because a reader who acts on "the countdown only runs while something watches it" will be acting on something this ADR made false.

What it guards now is the gap between the deadline passing and the sweep timer actually firing. The timer is scheduled, not instantaneous, and under load the scheduling delay is unbounded. In that gap `nextPendingRequest` still answers with an expired entry, and presenting it would produce the dialog-too-brief-to-read that ADR-0006 decision 5 exists to prevent.

The test that covers it is `test/widgets/swaption_notification_listener_test.dart:411-433`, and it asserts an exact ordered pair of removals. That assertion depends on the listener's loop being synchronous through its `continue` and therefore beating a `Timer(Duration.zero)` to the entry — an ordering the design relies on, stated here so it is not rediscovered as a flake.

### 7. Both platforms

The writer is in the notifier, so this is not a desktop fix with a mobile side-effect. On mobile a request waiting its turn in the presentation queue now expires where it stands, instead of waiting for a dialog that would have shown it only to remove it. That is intended, and it was not part of the reported symptom, so it is called out rather than left to be discovered.

## Consequences

- The bell dot, the app-icon badge and the raise episode all follow the deadline now — the episode as far as an expiry can take it: `_resolve` returns early while any id is still unresolved (`desktop_window_service.dart:449-451`), so an episode holding one TTL-bearing and one TTL-less request still waits for the second, which nothing local will expire.
- A shipped comparison changes for four existing callers. Nothing they display changes; a request stops being treated as expired while up to a second of its window remains.
- `Notifications` acquires the first piece of lifecycle state it has ever held — one timer — and with it a disposal obligation. Getting it wrong fails silently, because the notifier outlives `clearAll()` (measurement 5).
- Four widget effects go. `signRequestNotificationTtlProvider` keeps all four watchers; only what they do at zero changes. No import goes with them: `notification_removal_reason.dart` is still needed for the `rejectedByUser` arms in both files (`swaption_dialogs.dart:193`, `:415`; `d_notifications.dart:697-701`).
- Existing tests change. Two assert the mobile dialog's expiry effect directly (`test/widgets/swaption_dialogs_test.dart:436`, `:454`) and go with it; a third (`:473`) asserts the route teardown that followed from the removal and needs its trigger moved rather than deleted. The harness they share overrides `build()` without calling `super.build()` (`:64-65`), so whether the sweep runs under it depends on where the arming lives — three further suites subclass `Notifications` the same way and drive `setEntries` (`_SeededNotifications` in `test/providers/notifications_provider_test.dart`, `test/providers/signer_acceptance_provider_test.dart` and `test/widgets/d_notifications_test.dart`).
- The two desktop widget effects have no test coverage today — `test/widgets/d_notifications_test.dart` sets no `ttlMilliseconds` anywhere — so their deletion costs nothing there.
- The window is never minimized by a background expiry, because `_resolvedByUser` already excludes *expired*. A user working in another application sees the badge and the dot go out and their window stay where it is.
- ADR-0006 decisions 2, 3, 5 and 7 and its Consequences all carry text this change falsifies. Pointers are added to the decisions, and the two Consequences bullets that assert the widget-scheduled microtask are struck through in place rather than left standing under a note.

## What this ADR does not settle

- **Whether the app should tell the origin anything about a dropped or locally expired request.** It cannot: `SignerResponse` is a request id and a boolean, and `accept: false` would be a refusal the user never made. Unchanged from ADR-0006 decision 6.
- **What a request with no TTL does.** Nothing here touches it: it starts no countdown, is never armed, is never swept, and waits for the user, remote cancel, *Clear all*, or disposal — ADR-0006 decision 7, unchanged.
- **Notification ids do not restart after `clearAll()`, contrary to what four documents and four code comments say.** Measurement 5 shows the notifier instance survives `invalidateSelf`, and `_id` is a field on it — measured, the counter goes 1 → 2 across the call rather than back to 1. ADR-0006 decision 2, ADR-0009, `CONTEXT.md`'s *Acceptance attempt* entry and the doc comments on `pendingRequest` and `nextPendingRequest` all state the opposite and reason from it. The direction is benign — comparing `reqId` stays correct, it simply defends against something that cannot happen — so nothing here depends on the answer, and it is tracked separately as #211 rather than fixed in passing. **Settled by #211**: the documents were corrected to match the code, the counter stays monotonic with no reset mechanism, and a provider test now measures it — so the surfaces named above no longer say what this entry says they say. The tally in this bullet was itself off, in the direction that flatters it: the claim sat in **nine** hand-written comments across seven files, not four, and `nextPendingRequest`'s doc comment never carried it at all. #211 corrected the nine that did.
- **Whether the panel should distinguish "expired while you were away" from "never arrived".** It does not, and after decision 1 there is nothing left on screen to distinguish.

## Review notes

Findings from the two adversarial passes that **changed** the design or the argument. Each was verified at its citation before being accepted; the ones that did not survive verification are listed too, because a future reader will otherwise rediscover them.

First pass:

- **"A local removal can never be early" is false.** The predicate truncates, so the removal fires before the local deadline, and therefore before the server's for any request that arrived in under a second. This was the sentence that made decision 1 look free.
- **A zero TTL is not the only TTL that arrives expired** under the truncating predicate — everything from 0 to 999 ms is.
- **"One writer" contradicted the decision that keeps the mobile guard.** Replaced with the division of labour.
- **The rearm trigger was stated two incompatible ways**, and the "rearm on every list change" reading strands the timer permanently after a backwards wall-clock correction.
- **The rearm would have run once per removal**, from inside the sweep, over a half-swept list.
- **`removeNotification` removes by id, not by entry**, so "sweep every expired entry" is not expressible with the primitive available.
- **The both-payloads rationale described a wire state the `oneof` forbids**, which the source file itself records.
- **Nothing said what the sweep does with a cancelled entry**, and reusing the predicate would have made a cancelled entry recordable as *expired* for the first time.
- **Existing tests assert the effects decision 5 deletes**, in a file the accompanying issue never named.

Second pass — it reversed the scope rather than refining it:

- **The truncating comparison was fenced off as out of scope, and six findings turned out to be that fence**: an unnameable arming instant, a drop scope a second wider than anyone chose, a 1000–1999 ms window that reproduced the very flash decision 4 prevents, a log line required to report a negative elapsed time, a countdown that vanishes reading `1`, and an acceptance criterion that no real timer can fail. Decision 2 now removes the fence instead of documenting around it.
- **"It fires into a notifier that is gone" is false.** riverpod caches the notifier per element and never resets it; measured on this lockfile, the instance is identical across `clearAll()` and the element stays mounted. The failure mode is a silent cross-generation sweep, not a crash — and the acceptance criterion built on the crash was vacuous.
- **The same measurement falsifies "ids restart after `clearAll()`"**, which ADR-0006, ADR-0009, the glossary and four code comments all asserted at the time. Recorded in *What this ADR does not settle* and tracked separately; #211 has since corrected every one of them.
- **ADR-0006 decisions 2 and 3 were declared untouched while this change falsifies text inside both**, as does its Consequences section. Pointers and in-place corrections added.
- **The glossary's *Pending set* entry says a request enters it on arrival**, which *dropped at delivery* contradicts two paragraphs below it.
- **"within a second on either side" is false on the late side** — the scheduling delay is unbounded, and a transport slower than a second breaks the bound on its own.
- **The `cancelNotification` microtask has the same N-removals shape as the sweep**, and only the sweep was covered by the rule.
- Several citations were off by one or pointed at a guard rather than the call it guards; two of the three test line numbers in the accompanying issue were blank lines, and one of the three tests did not assert what it was said to assert.

Third pass (Codex) — no new design defect; six overclaims in the prose around decision 2:

- **"Expiry happens at the deadline" is an overclaim.** Decision 2 fixes where the boundary sits; the removal still runs on a timer callback whose delay decision 6 calls unbounded. Corrected in decision 1 and in the glossary.
- **Decision 1 pointed at decision 2 for a bound that decision 2 does not supply.** Two successive drafts claimed a bound — "never early", then "within a second either way" — and neither holds. There is no bound in either direction; what the change buys is an exact shared boundary, not a small error.
- **"One expression, every caller" was not implementable verbatim**, because the delivery check has no entry to pass. The seam is now named: an inner predicate over a receipt instant and a TTL, with `requestDeadlinePassed` as its wrapper, and the delivery check passing the same instant it stamps as `createdAt`.
- **ADR-0006's Consequences were said to be "corrected in place" and were not** — the two bullets asserting the widget-scheduled microtask still stood, under a note rather than struck through. Now struck through in place.
- **The glossary still carried the falsified `clearAll()` restart claim**, which #211 tracks but does not make true. Corrected in `CONTEXT.md` and in ADR-0006 decision 2, with #211 keeping the rest.
- **The "vanishes while rendering `1`" bullet was read as a claim about today's code** by a third consecutive reader. It was always a claim about the rejected draft; the sentence now says so.

Findings that did **not** survive verification:

- That decision 4 imposes the TTL floor it rejects. Refusing to deliver a short-TTL request is not inventing a deadline for it; the real finding was the understated scope, since removed by decision 2.
- That the acceptance criterion for the both-payloads drop cannot be exercised at all. The input is unreachable on the wire but reachable in tests — `test/providers/notifications_provider_test.dart:106-124` already stubs a message with both.
- That the sweep's `onRequestResolved` can land inside a raise that is still settling and leave the window up. `_serialized` orders it correctly; what was real was the 1000–1999 ms window, which decision 2 closes.
- That decision 1's removal can be defeated because the acceptance path sends without comparing a deadline. True of the code — `lib/providers/signer_acceptance_provider.dart:96` asks `pendingRequestProvider`, not the TTL — but it is ADR-0006 decision 2 working as designed: "The check is presence-and-identity, not TTL arithmetic", with its reason recorded there. Not a defect this ADR introduces.
- That the item disappears while its countdown reads `1` in the shipped app. It does not: one widget renders and removes from the same sample. The claim was about the rejected draft, and the text now scopes it.
