# ADR-0016 — The desktop window remembers its geometry, and the launch restores it only where the window stays visible

Issue: #284. Amends the candidate list in [ADR-0014](0014-desktop-minimum-window-height.md) section 14.

## Context

Every desktop launch centres the window on the display under the cursor at the size [ADR-0014](0014-desktop-minimum-window-height.md) computes for that display's work area. The app never reads the window bounds back, so the user's last size, position and monitor are lost on every restart. ADR-0014 section 14 records this as a candidate rather than a gap it fills.

Three facts constrain the answer.

### The plugin coordinate problem

`window_manager` multiplies a position given to `setBounds` by the current view's device pixel ratio, and divides by that ratio in `getBounds`. The window is created on the primary display. A position saved on a secondary display with another scale factor therefore lands wrong. #261 delivers a native placement channel in physical coordinates that removes the problem; this change does not wait for it.

### A stored value can describe a desktop that no longer exists

A user unplugs a monitor. A user changes the display layout. A user docks a laptop. The stored rectangle then names a place no display covers. A launch that trusts it opens a window the user cannot see and cannot reach, which is worse than losing the position.

### ADR-0014 decision 7 says nothing observes the window after launch

Decision 7 rejects a resize observer and rejects moving the window on a display change. This change adds the first listener over move and resize events. The tension is real and it is reconciled below rather than coded around.

## Decisions

### 1. The geometry is stored through `Configuration`, like every other setting

`SideswapSettings` gains one optional `DesktopWindowGeometry` field and one key constant. `Configuration` gets a setter, a read helper and a write helper, following the `networkSettingsModel` round trip field for field: `jsonEncode(model.toJson())` on the way out, `jsonDecode` guarded by a `try` on the way in.

Nothing outside `Configuration` reads or writes `SharedPreferences`, and the rule holds at launch as well. The launch path reads the geometry through the provider.

### 2. Visible means: the whole rectangle lies inside one work area of one present display

Containment is inclusive on every edge, so a window sized exactly to its work area restores. A window that straddles two monitors is not visible and does not restore, even where the two work areas together cover it. A work area the platform reports as degenerate is skipped by the scan rather than treated as a failure.

### 3. A uniform-scale guard stands in for #261

The geometry restores only when every present display reports the same scale factor. `screen_retriever` reports `Display.scaleFactor` as `num?`; a display that reports none fails the guard. On a mixed-DPI desktop the launch takes the fallback path and logs the reason. #261 lifts the guard.

> **Amended by [#261](../../issues/261) (2026-09-09): the guard stays.** #261 landed the native placement channel, and it replaces the *centring* fork only. The restore fork still goes through `windowManager.setBounds`, which multiplies by the current view's ratio, so a stored position on a display of another scale still lands wrong. Lifting the guard needs a native operation for absolute bounds, which no acceptance criterion of #261 describes. Read the three forward references below — in the context, in the rejected alternatives and in the follow-up table — as naming that later change, not this one. See [ADR-0014](0014-desktop-minimum-window-height.md) decision 3 and its #261 amendment.

### 4. The fallback path is today's launch, unchanged and complete

On any rejection the app selects the display under the cursor with the primary as fallback, recomputes the size from that display's work area exactly as ADR-0014 does, centres the window, and does not maximize. The stored geometry is ignored entirely on that path: not the size, not the position, not the maximized flag.

### 5. Maximized is a flag beside the normal bounds

The visibility check runs on the normal bounds. When it passes, the launch applies the bounds and then maximizes. Un-maximizing therefore returns the window to the stored normal bounds. A maximized window never overwrites the stored bounds with its maximized rectangle: the recorder sets the flag and keeps the bounds it already has.

### 6. Full-screen and minimized states never reach the store

A full-screen window and a minimized window say nothing about the normal bounds. The recorder reads both states before it reads the bounds and returns without writing.

### 7. The write is debounced, and the close path is not changed

Move, resize, maximize and unmaximize restart one debounce timer. The close event captures once, without the timer. The close path keeps the plain close; it does not become a prevent-close flow. A crash or a killed process therefore loses at most one debounce interval, which is the accepted cost of not holding the window open on quit.

The recorder also drops a capture whose result equals the stored value, so an event burst that ends where it started writes nothing.

### 8. The launch reads the store before the window is shown

`SharedPreferences` and one `ProviderContainer` are built before the window setup. The same container backs the app through `UncontrolledProviderScope`, so the launch read and the running app share one `Configuration`. Showing the window after `runApp` was rejected: it would delay the window by the existing two-second startup delay.

### 9. `deleteConfig` keeps the geometry

Window placement is a property of the machine, not of the wallet, so it survives deleting the wallet the way `env` does.

### 10. The stored bounds are the display identity

The model carries an optional display id, and the restore decision never reads it. An id is not stable across a replug on Windows, so gating on it would refuse a restore that decision 2 accepts. The bounds are already virtual-desktop coordinates, so they name the display by construction. The field stays on the model as a diagnostic slot for the native placement channel #261 adds; the recorder leaves it unset.

### 11. Reconciling ADR-0014 decision 7

Decision 7 forbids the app from *moving or resizing* the window after launch, because that acts on the user's window without being asked. This change never calls `setBounds` after launch. It only reads the window state in order to store it. The prohibition stands; what changes is that the window lifecycle now has a read-only observer.

### 12. Mobile is untouched

The field exists on the shared model and stays at its default there. The desktop `--mobileMode` path is unchanged.

## Consequences

- The window reopens where the user left it on the common case: one desktop, one scale factor, an unchanged layout.
- A user who changes the display layout always gets a visible window, because the stored value is a hint the launch is free to drop.
- A mixed-DPI desktop never restores until #261 lands. The log line says so.
- The settings store gains one key. The full-write design of `Configuration` is unchanged; the debounce is what keeps the cost acceptable.
- The launch order changes: the settings store is read before the window is shown rather than two seconds after it.

## Alternatives rejected

- **Waiting for #261.** It makes the common single-scale desktop wait for a native channel it does not need.
- **Restoring without a visibility check.** It is the defect this ADR exists to avoid: an unreachable window after a layout change.
- **Gating the restore on a stored display id.** Unstable across a replug, and redundant beside decision 2.
- **A prevent-close flow that flushes on quit.** It holds the window open on the one path where the user asked for it to go away, to save at most one debounce interval.
- **Persisting full-screen.** An app that reopens full-screen with no chrome is hard to leave, and the state says nothing about the bounds.
- **Writing only the changed keys.** Rejected twice already; a separate candidate issue.

## Work

| # | Issue | Blocked by |
| --- | --- | --- |
| 1 | This change: store, pure decision, recorder, launch wiring | — |
| 2 | #261 — the native placement channel that lifts the uniform-scale guard | — |
