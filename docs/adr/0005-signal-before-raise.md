# ADR-0005 — Liquid Connect desktop window policy: signal before you raise

- **Status:** Accepted. Supersedes ADR-0004 decisions 1 (in part), 3 (in part) and 4 (in part); ADR-0004 decisions 2, 5 and 6 stand unchanged.
- **Date:** 2026-07-29
- **Driver:** manual macOS testing of the ADR-0004 implementation. Two findings: the app takes the foreground away from the browser and never gives it back, and the Dock bounce is never seen.
- **Implemented by:** PRD to follow.

## Context

ADR-0004 shipped. Testing it on macOS surfaced two problems, one reported and one predicted by the ADR's own review notes.

**The app takes the foreground and keeps it.** With the SideSwap window open but behind a browser, a connect request raises the app to the front. The user accepts, and the app stays in front — because `_tookWindowOffScreen` is set from `isMinimized()` alone, so a window that was never minimized is never put back. The user is left in SideSwap having asked for nothing, and must click back to the browser by hand. The window did come forward, exactly as ADR-0004 intended; the intent was wrong.

**The bounce is invisible.** `requestUserAttention(.criticalRequest)` bounces until the *application* is activated, and the raise that follows it activates the application. The bounce is therefore cancelled by our own raise, a fraction of a second after it starts. ADR-0004's review notes already recorded this ("a bounce issued immediately before a forced activation is near-invisible") and the design kept the bounce anyway, as a hedge against a refused activation. Testing confirmed the prediction: in every case where the raise works, the bounce is never seen.

Both findings have the same root. ADR-0004 treated **raising the window** as the primary answer to "a request needs the user", and every other signal as decoration around it. But raising is the most invasive thing a desktop app can do — it takes the keyboard, the screen and the user's attention at once — and it is also the only one the app must then undo. Every hard part of ADR-0004 (the raise episode, window ownership, the expected-transition protocol, the settle timeout) exists solely to make that undo safe.

### The alternative that was never on the table

Nobody asked what happens if the app simply **does not raise** and signals instead. The Dock icon can bounce until the user comes, and it can carry a badge that says how many requests are waiting. Neither takes anything from the user, neither needs undoing, and the user decides when to switch. The original report — "the app never comes forward and gives no sign, so I have to hunt for it" — is answered by *the sign*, not by the coming forward.

## Decisions

### 1. The app signals; it raises only from the one state it can faithfully undo

On macOS the app raises the window in exactly one disposition: **minimized, on the active Space**. In every other disposition it signals and leaves the window alone.

| window disposition | on request arrival | on user resolution |
|---|---|---|
| minimized, active Space, not hidden | badge + bounce + raise | `minimize()` back |
| minimized, other Space | badge + bounce | — |
| hidden (Cmd-H), minimized or not | badge + bounce | — |
| visible, app inactive | badge + bounce | — |
| active | badge | — |

The dispositions are **not** mutually exclusive as measured, so the table is read in a fixed order, and that order is part of the decision:

1. **off the active Space** — wins over everything, including minimized. A miniaturized window still belongs to a Space, and deminiaturizing it pulls the user there.
2. **hidden (`NSApp.isHidden`)** — wins over minimized, and this ordering is forced by the same rule that drives the whole ADR. An app that is minimized *and* hidden would be raised by `restore()` → `show()` → `focus()`, which both de-miniaturizes **and** un-hides, while the only undo the app has is `minimize()` — leaving the app un-hidden, a state the user never chose. There is no exact inverse, so there is no raise.
3. **minimized**, then **visible-inactive**, then **active**.

Steps 1 and 2 are **not measurable from Dart**: a minimized window already reports `visible=false` (ADR-0004's own measurement, `minimized=true visible=false focused=false`), so `isVisible()` cannot separate "minimized" from "minimized and hidden", and `isOnActiveSpace` is not exposed by `window_manager` at all. Both therefore come from **one native query** returning the macOS-side disposition (`isOnActiveSpace`, `NSApp.isHidden`) in a single hop, evaluated before any window command is issued.

That query is a **bounded predicate**: a thrown `PlatformException`, a `MissingPluginException` on a build without the handler, a `null` or wrong-typed result, **and a reply that never arrives** all resolve to the fallback. The timeout matters more than the others — the service serializes every episode mutation behind one chain (`desktop_window_service.dart:172-179`), so an unanswered platform hop would strand not just this delivery but every later command, including the `abandonEpisode()` that `clearAll()` queues. The existing `kOwnershipSettleTimeout` does not cover this; it guards the post-raise transition wait only.

The subject throughout is the app's **main window** — the one `window_manager` drives. Multiple windows and a second display under "Displays have separate Spaces" are out of scope: the wallet has one main window, and the native query reads that window.

The rule behind the table: **the app may undo only what it can undo exactly.** `minimize()` is the precise inverse of `restore()`. Nothing is the precise inverse of "took the foreground from whichever app had it" — the candidate undos are `NSApp.deactivate()`, which does not say who gets activated next, `NSApp.hide(nil)`, which hides more than the raise ever showed, and re-activating a remembered `NSRunningApplication`, which needs macOS 14 API and has an unverified answer under App Sandbox. All three were considered and all three are approximations. So the app does not take the foreground in the first place.

The second rule: **an unsolicited event may not move the user between Spaces.** A `deminiaturize` of a window belonging to another Space pulls the user off a full-screen app. So the raise is additionally gated on `NSWindow.isOnActiveSpace`, checked natively — `window_manager` does not expose it.

`isOnActiveSpace` for a *miniaturized* window is not documented, and the answer was not assumed: if the native check fails or the channel refuses, the app **raises**, falling back to the shipped behaviour. A missing raise next to a missing badge would leave the user with no signal at all, which is the failure this whole line of work exists to fix. The predicate's real behaviour is a named item in the manual macOS pass.

### 2. The bounce moves out of the raise path and becomes the primary signal

`requestUserAttention` is issued at the **request delivery boundary** whenever the platform reports the application inactive — not, as before, only when a raise is about to happen.

The invariant is **"one attention request outstanding while the app is inactive"**, not "one per delivered request". A second request arriving while a bounce is already running does not issue another: only one id can be held, and cancelling withdraws exactly that one, so a second request would strand the first with nothing able to stop it (`desktop_window_service.dart:382-388`). The bounce already means "something needs you", and it does not mean it twice as loudly for two things. The count is what the badge is for. In the one disposition that still raises, the attention request is still issued first and is still killed by the activation moments later; that ordering is kept deliberately (ADR-0004 decision 4: an id arriving after the focus event can never be cancelled) and the wasted bounce is the price of one uniform rule.

Consequence in the code: the window listener's lifetime can no longer be the raise episode's, because a bounce now happens with no episode open. It lives as long as **an outstanding attention request or an open episode**.

### 3. A pending badge on the app icon, driven by the pending set

The app icon carries the number of requests awaiting a user decision. It is **not** an attention marker: it survives activation and is cleared only when the pending set empties — for any resolution reason, including expiry and remote cancel. No badge is shown at zero.

An attention-marker badge (cleared when the user looks at the app) was rejected: it would share the bounce's lifetime exactly, and would therefore be invisible in precisely the cases where the bounce already is. The badge answers a different question — *what is still waiting for me* — which is why it is worth its own native code.

**What is counted, exactly:** notification entries in the notifier's list that are **not** in the cancelled state. Not the window service's `_unresolvedRequestIds`, and the two can legitimately differ in cardinality:

- A signer request carrying **both** a connect and a sign payload appends two list entries under one id (`notifications_provider.dart:63-133`), while the window service holds one id in a `Set<int>`. Both entries appear and disappear together, so the badge is briefly "2" for what is one decision. Accepted: the user does see two cards.
- `clearAll()` empties the notifier synchronously but abandons the raise episode through an unawaited command (`notifications_provider.dart:273-286`), so for that interval the badge reads zero while the window service still holds ids.

The notifier is therefore the **single authority** for the badge, and the window service's set is explicitly not a second source of truth for it. That is the point of driving the badge from the delivery boundary: the pending set is the notifier's own state, while the window service's ids exist to serve the raise episode.

**Lifecycle, not just mutation.** Counting at `addNotification` and `removeNotification` is not enough on its own:

- `clearAll()` does not assign state — it calls `ref.invalidateSelf()` (`notifications_provider.dart:286`), and the badge is imperative, so nothing would push the new zero. It sets the badge to zero explicitly, alongside the `abandonEpisode()` it already queues.
- The badge is **reconciled from `state` when the notifier is built**, not assumed to start empty. The badge lives on the process's Dock tile, so a notifier rebuilt after invalidation would otherwise inherit a stale count it never wrote.
- On provider disposal the badge is cleared: a count with nothing left to resolve it is worse than none.

Cancelled entries are excluded **at the moment the cancellation is recorded**, not when the later microtask removes them (`notifications_provider.dart:237-270`). Counting raw list length would make the badge claim a decision is still awaited from a request the origin has already withdrawn — and the microtask re-reads `state`, so its timing is not something the badge should depend on.

### 4. Platform reach: seams for three desktops, implementation for macOS

The badge seam and its capability flag are written for all three desktops; only macOS is implemented. The costs are not comparable:

- **macOS** — `NSApp.dockTile.badgeLabel`, one case in an existing channel.
- **Windows** — no text badge exists. `ITaskbarList3::SetOverlayIcon` takes an `HICON`, so a digit must be shipped as a rendered icon or drawn with GDI, and the runner has no method channel at all today.
- **Linux** — the Unity `com.canonical.Unity.LauncherEntry` DBus signal addresses a `.desktop` file id, and this repo ships none: `deploy/build_linux.sh` copies a raw bundle directory. The badge would have nothing to attach to until packaging is decided, and the signal is honoured only by some desktop environments.

### 5. Windows and Linux keep the shipped behaviour, unchanged

They raise from any disposition where the window is not already in front of the user, and minimize back only when it was minimized — which is exactly what the ADR-0004 implementation already does.

**Unchanged behaviour, not unchanged code.** Windows and Linux run the same service, and decision 2 changes that service's shared state machine: attention can now exist without an episode, and the window listener's lifetime changes with it. Their arm is therefore a **behaviour-preserving refactor** and needs regression coverage saying so — the existing cross-platform tests stay and are not rewritten away along with the macOS ones.

This is a **deliberate divergence** from macOS, and it follows from the same principle rather than contradicting it: *signal by the least invasive means the platform offers.* macOS offers a badge and a bounce, so it does not need to take the foreground. Windows and Linux offer neither — a taskbar flash (`FlashWindowEx`) and a GTK urgency hint exist, but the first needs a COM channel the runner does not have and the second is ignored under Wayland — so raising remains their only working signal. The accepted cost: on Windows and Linux the app still takes the foreground and does not give it back.

## Consequences

- The raise episode, window ownership and the expected-transition protocol all survive, but now guard a single disposition. `_tookWindowOffScreen` collapses: an episode can only ever open from a minimized window.
- Existing behaviour tests in `test/providers/desktop_window_service_test.dart` that assert a raise from a non-minimized disposition are **rewritten, not extended** — they assert behaviour this ADR deliberately reverses.
- A macOS user working in a browser with SideSwap visible behind it now gets a bouncing Dock icon and a badge instead of a window in their face. This is a user-visible change and belongs in release notes, alongside the ADR-0004 change it builds on.
- Manual macOS pass gains two items: what `isOnActiveSpace` returns for a miniaturized window, and that the bounce is now actually seen when no raise follows.
- The unresolved half of the original report is untouched: whether the OS banner is ever displayed on macOS is still not diagnosed, and the badge does not substitute for it — a badge is only seen by someone looking at the Dock.

## Accepted risks

Raised in adversarial review against this decision tree, weighed, and accepted rather than answered. Recorded so a future reader does not have to rediscover them.

- **A Dock the user cannot see is not the app's problem to solve — decided, not merely accepted.** A full-screen app hides the Dock, an auto-hidden Dock hides it by default, and on a multi-display setup it lives on one screen. In those configurations both signals go unseen, the app no longer raises, and since requests carry a TTL an unseen request can expire untouched. Both review rounds named this as the sharpest objection to the whole approach, and it is answered rather than hedged: a user who has hidden their Dock or gone full-screen has chosen where their attention goes, and an app is not entitled to override that choice by seizing the screen. No compensating raise, no second signal, no configuration detection. The consequence is understood and owned.
- **A minimized window on another Space no longer comes forward**, which is the state the original report was about. The Space rule wins over the minimized rule on purpose (decision 1), so that case is now signal-only. If a user habitually parks the wallet on its own Space, this is a regression against ADR-0004 for them specifically.
- **The failure fallback restores the removed behaviour.** If the native Space check throws or the channel is missing, the app raises. A native regression would therefore reinstate exactly what this ADR removes, quietly. The alternative — never raise when unsure — was rejected because it can leave the user with no signal at all if the badge is also failing. The check is a named item in the manual pass for this reason.
- **This reverses a decision that shipped one day earlier.** The evidence gathered is a defect in one disposition (window open behind a browser) plus a predicted-and-confirmed invisible bounce; the reversal extends beyond that disposition to every non-minimized one. The narrower fix — keep raising in all dispositions, add a foreground-return for the non-minimized ones — was considered first and rejected because no faithful foreground-return exists (decision 1).
- **Capability defaults are covered the way `docs/TESTING.md` prescribes, not exempted.** `_defaultCapabilities()` reads `Platform.isMacOS` (`desktop_window_service.dart:121-126`) and its two arms are asserted by platform-scoped tests (`desktop_window_service_test.dart:1129-1180`) — the `testOn:` pattern the testing standard names for exactly this case. New flags join the same factory and the same tests. What the coverage gate genuinely requires is that every *policy* branch be reachable on Windows through the injected capability object, and that is what the injection exists for. Worth stating plainly because it looks like an exception and is not one.

## What this ADR does not settle

- Returning the foreground to the app that had it. Rejected here because raising was removed instead, which makes the question moot on macOS. It becomes live again if Windows or Linux ever get a badge, since raising is only their fallback until then.
- Windows taskbar flashing and the Linux urgency hint, both still out of scope.
- Whether the bounce should be replaced by something quieter. Kept as-is, since it now runs in the cases where it works.
