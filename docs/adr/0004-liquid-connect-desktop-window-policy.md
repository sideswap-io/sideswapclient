# ADR-0004 — Liquid Connect desktop window policy: raise from the delivery boundary

- **Status:** Accepted, then **superseded in part by [ADR-0005](0005-signal-before-raise.md)** (2026-07-29). Decisions 1, 3 and 4 below are narrowed there: the app now raises the window only from a minimized state on the active Space, and signals instead in every other disposition. Decisions 2, 5 and 6 stand.
- **Date:** 2026-07-28
- **Driver:** a user report that on macOS an incoming Liquid Connect sign request never brings the minimized app forward, while accepting one immediately minimizes it again — so the app "is almost always minimized". Grilled into a decision tree, then twice reviewed adversarially.
- **Reviewed by:** two Codex passes (devil's advocate on v1, adversarial on v2) — see the end of this file.
- **Implemented by:** PRD #165, slices #166–#170.

## Context

Liquid Connect's intended desktop flow is: the minimized app comes forward when a request arrives, the user accepts or rejects, the app minimizes again so the user can carry on in the browser. Only the second half worked.

An auto-raise already existed, in a hook effect in the desktop notifications toolbar widget keyed on whether any notification is active. It did nothing. The obvious explanations — a missing `focus()` call, a macOS activation policy, missing notification permissions — were all wrong, and each would have produced a plausible fix that did not work.

### The measurement

A probe application (macOS 26.x, Flutter 3.44.8, `window_manager` 0.5.2) minimized itself, then took two paths to raising the window: a state change (the widget path) and a direct call from a timer.

| t | event | observed |
|---|---|---|
| 3.16 s | app minimizes itself | — |
| 8.16 s | `setState` called — the widget path | **no build ran** |
| 9–17 s | 1 s heartbeat timer | keeps ticking; build count stays at 1 |
| 13.16 s | window state sampled | `minimized=true visible=false focused=false` |
| 18.16 s | `restore` → `show` → `focus` called from a timer | — |
| 18.43 s | — | **build #2 runs**, 0.27 s after the window was restored |
| 23.16 s | window state sampled | `minimized=false visible=true focused=true` |

**A minimized macOS window produces no frames.** No frame means no rebuild, so a provider-driven widget effect cannot run while minimized — it runs only once the user has already reopened the window by hand, which is exactly too late. The Dart event loop is unaffected: the heartbeat kept ticking, so the request itself does reach the app.

Three further facts fell out of the same probe and the plugin sources, and each one killed a design that looked reasonable:

- `isMinimized()` sampled immediately after `minimize()` still returns `false` — miniaturize is asynchronous. A single sample taken right after a transition cannot be trusted.
- `WindowListener`'s callbacks (`onWindowRestore`, `onWindowFocus`, `onWindowMinimize`) take **no arguments**, on all three desktops. A `restore()` the app issued itself is indistinguishable from the user restoring the window.
- `window_manager`'s `isFocused()` is `mainWindow.isKeyWindow`, which is **not** `NSApp.isActive`. Window focus and application activity are different predicates, and AppKit's attention API cares about the latter.

## Decisions

### 1. The window raise lives at the request delivery boundary, not in the widget tree

Raising moves into the provider that receives the signer request and already posts the OS notification. The old effect in the notifications toolbar widget is removed rather than kept as a fallback: it is dead in the only case that matters, and two sources of truth for one policy is how the next change gets made in the wrong place.

This is the decision most at risk of being quietly undone. A future reader will see window code in a provider, think it belongs in the widget that renders the notifications, and move it back. The table above is the reason it must not be moved back.

A second, independent defect the same change fixes: the old effect was keyed on a **boolean** ("any active notifications"), so a second request arriving while one was pending never raised the window on any platform.

### 2. Ownership is an explicit, best-effort protocol — not an observation

The app may only minimize a window it raised itself. "Was it minimized when the request arrived?" is not sufficient: the sample is racy right after a transition, and the user may take the window over afterwards.

So the app tracks a **raise episode** with **window ownership**, and because the platform reports transitions without their cause, it marks each command it issues as an *expected transition* and matches incoming callbacks against it. Only an **unmatched** transition counts as user-originated and revokes ownership. Establishing ownership waits for the raise's postconditions to settle under a bounded timeout — a window manager may legitimately refuse activation, and the episode must not hang.

This is deliberately best-effort. It is recorded here so nobody later reads the matching logic as a correctness guarantee and builds something load-bearing on top of it.

### 3. Minimizing is tied to the resolution reason, not to the list being empty

The app minimizes back only when the transition that empties the **episode's** unresolved set is *accepted by user* or *rejected by user*, ownership still holds, and no unmatched user transition intervened.

Two rejected alternatives:

- **"Minimize when the notification list is empty."** Wrong invariant: cancelled entries linger in the raw list until a later microtask removes them, and an unrelated older notification would block the minimize forever.
- **"Minimize on every resolution, as today."** That is the behaviour the user complained about — including a request expiring untouched, which yanks the window away with no user action at all.

**User-visible consequence:** TTL expiry and remote cancel no longer minimize the window. An app raised for a request that then expires stays up. This is intended, and belongs in release notes.

### 4. The Dock bounce is macOS-only, and its activity check lives in Swift

`requestUserAttention` with the critical type, issued only when the app is not active. AppKit's header says to call it only then, and "not active" means `NSApp.isActive` — which Dart cannot ask for, since the Dart-side query reports window key-ness. The check therefore happens in Swift, atomically with issuing the request; the returned request id round-trips to Dart, is stored before the raise, and is explicitly cancelled when the window gains focus.

Windows and Linux issue no attention call. The platform difference is expressed through an injected capability object, never a runtime platform check inside provider logic — the coverage gate runs on Windows, and a `Platform.is*` branch there is an uncoverable branch.

### 5. The always-on-top toggle stays on Windows and Linux

The current widget code toggles `setAlwaysOnTop(true)` then `(false)` after showing. The probe proved it unnecessary on macOS, so it is dropped there. It is **kept** on Windows and Linux: it is shipped behaviour, plausibly a z-order workaround under focus-stealing prevention, and a macOS probe is not evidence about other platforms. Unification here means one policy path, not one identical command sequence.

### 6. The banner-click path keeps its own policy

Clicking the OS notification keeps its existing sequence and never establishes ownership. An explicit user click is not an unsolicited event, and must not earn the app the right to minimize the window later.

## Consequences

- Window policy lives in one service behind one provider, mocked at a single seam in provider tests — the same shape as the existing local notification service, which injects its plugin and a platform flag.
- Every notification removal must carry its reason, which touches the accept, reject, expiry and remote-cancel paths.
- The Swift handler is outside Dart coverage tooling entirely. It is verified by a manual macOS pass, not by the coverage gate, and the pass must cover: minimized / occluded / hidden with Cmd-H / another Space; bounce present in background and absent when frontmost; two overlapping requests; expiry; remote cancel; manual window takeover mid-request.
- Scope is a running process whose window is minimized, hidden, occluded, or on another Space. A **closed** window is out of scope: the macOS and Windows runners both quit on last-window-close. The Linux runner is expected to behave the same way; unverified.

## What this ADR does not settle

The original report has two halves and this ADR diagnoses one. The user also reported no notification at all. The OS notification is submitted from the delivery boundary, off the widget tree, so frame starvation cannot explain its absence. Slice #168 adds submission instrumentation only — and a successful submission proves Notification Center accepted the request, **not** that a banner was displayed. If a signed build with permissions granted and Focus off still shows no banner, that is a separate investigation.

## Review notes

Findings from the two review passes that changed the design, rather than confirming it:

- A single "we raised it" boolean cannot express ownership across asynchronous transitions → replaced by the episode model (decision 2).
- "Minimize when the notification list is empty" contradicts "never minimize on expiry" → resolved by making resolution reason-bearing (decision 3).
- A bounce issued immediately before a forced activation is near-invisible, and `isFocused()` is not application activity → the Swift-side check and the attention-id round trip (decision 4).
- Dropping the always-on-top toggle everywhere rested on macOS-only evidence (decision 5).
- Two existing tests assert the cancel-path shadowing bug as expected behaviour, so fixing it is not a one-line change (slice #166).
