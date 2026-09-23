# ADR-0014 — The desktop window has a floor of its own, and every surface is built to it

- **Status:** Draft, v3. Both Codex passes applied — devil's advocate on v1, adversarial on v2. See [Review notes](#review-notes).
- **Date:** 2026-09-04
- **Driver:** On a 1366x768 laptop the desktop window is taller than the screen's work area. The bottom navigation bar ends up under the taskbar, and the app looks like it does not fit. Two pull requests attacked this — #253 (window sizing) and #254 (screen layout) — and both are superseded by this ADR.
- **Vocabulary:** *work area*, *chrome*, *supported floor*, *design height*, *surface*, *scroll owner* and *pinned action* are defined in [CONTEXT.md](../../CONTEXT.md#desktop-window-and-layout). Issues and tests use those words.
- **Scope:** `lib/start_app.dart` and a new `lib/desktop/desktop_window_size.dart`; the three shared surface wrappers `DContentDialog`, `SideSwapPopupPage` and `DPopupWithClose`; the 18 surfaces that declare a height above the floor; the 8 dialogs that declare no height bound at all; and the four desktop pages `DHome`, `DMarkets`, `DInstantSwap`, `DPegInOut`.

## Context

### What is wrong today

`lib/start_app.dart:91-114` is the whole of the desktop window policy:

```dart
// min app width is 1072 (for some reason 16px is cutted o_O)
appScreenSize = const Size(1088, 880);

// workaround for potato laptop resolution 1366x768
final currentScreen = await window_size.getCurrentScreen();
if (currentScreen != null) {
  if (currentScreen.frame.size.height < 880) {
    // a bit lower app height - we don't want to reduce it more
    appScreenSize = const Size(1088, 768);
  }
}

final windowOptions = WindowOptions(
  size: appScreenSize,
  minimumSize: appScreenSize,
  skipTaskbar: false,
  center: true,
);
```

Five defects sit in those 20 lines.

1. **The comparison mixes two unit systems.** `currentScreen.frame` is `MONITORINFO.rcMonitor` in *physical* pixels (`window_size/windows/window_size_plugin.cpp:72-89`), and the literal `880` on the line above is a *logical* height that `window_manager` multiplies by `devicePixelRatio` natively. On a 1920x1080 display at 150% the physical height is 1080, the test `1080 < 880` fails, and the window opens at 1088x880 logical = 1632x1320 physical on a 1080-tall screen.

2. **It reads `frame`, not the work area.** The taskbar is never subtracted. At 1366x768 at 100% the workaround does fire and produces 1088x768, which is still taller than the roughly 720 px work area.

3. **`minimumSize` equals the launch size.** The window can never be made *smaller* than the size it opened at. Enlarging, maximizing and restoring all work today — the minimum is a lower bound, not a fixed size — but shrinking does not. This is what makes the defect unrecoverable for the user rather than merely ugly.

4. **The size is computed exactly once.** There is no `setSize`, `setMinimumSize`, `setBounds`, `onWindowResize` or `onWindowMoved` anywhere in `lib/` — verified by grep over `lib/**/*.dart`.

5. **The size and the position are chosen from two different monitors.** `window_size.getCurrentScreen()` reports the monitor holding the native window, which `windows/runner/main.cpp:67` creates at `origin(10, 10)` — the primary display. `center: true` resolves through `calc_window_position.dart:12-20`, which picks the display containing the **mouse cursor**. `waitUntilReadyToShow` sizes before it centres (`window_manager.dart:135-147`). A large primary plus a small cursor display therefore sizes for the primary and centres the oversized result on the secondary.

### What the screens assume

The desktop screens are laid out for the 1088x880 window, which gives an 840 px client area on Windows. Fixed chrome takes 114 px of it: the top toolbar is `Container(height: 34)` (`lib/desktop/desktop_wallet_main.dart:104`), the bottom navigation bar is `Container(height: 56)` (`lib/desktop/d_main_bottom_navigation_bar.dart:26`), and the page gets `kPageDefaultVerticalPadding = 24.0` of top padding (`lib/desktop/widgets/sideswap_scaffold_page.dart:7`).

Below that, heights are hard-coded almost everywhere. There is not one `LayoutBuilder`, `IntrinsicHeight` or `AspectRatio` in `lib/desktop`. The only viewport-aware code in the desktop tree is a *width* breakpoint at `lib/desktop/widgets/sideswap_scaffold_page.dart:143-151`, and it never fires on the main wallet screens.

The one deliberate overflow strategy in the repo is `lib/desktop/settings/d_settings.dart:56-65`: a `Column(mainAxisSize: MainAxisSize.min)` under a `ConstrainedBox(maxHeight: 664)`, with the scroll region in a `Flexible(fit: FlexFit.loose)` and the pinned Delete row unflexed. Its doc comment at `:28-32` states the intent: the scroll region is a safety net, not the normal state.

### Why the superseded pull requests do not settle it

**#253** reads the work area and converts it. Its two pure functions are good code, and decision 5 keeps their *shape*, but decision 4 removes the need for the conversion they perform. It does not touch `minimumSize: appScreenSize`, so it keeps defects 3, 4 and 5.

**#254** makes five screens scroll through a new `DScrollWhenShort`. Three problems:

- It reaches 5 of the 64 surfaces built on the three wrappers.
- Uniform scrolling puts the primary action below the fold. `lib/desktop/main/d_send_popup.dart:263` declares a height of 710 and puts **ADD MORE OUTPUTS** and **REVIEW** at the bottom of its `Column`, behind a `Spacer()` (`:357-395`). On a short window the user must scroll to send a transaction.
- Its `DContentDialog` change wraps `content` in a `Flexible` with no scroll view under it, so a content taller than the dialog is squeezed and silently clipped. Its own test blesses that: `test/desktop/common/dialog/d_content_dialog_test.dart:64-66` asserts the content ends up between 500 and 712 px and calls it a pass.

An earlier version of #254 applied an app-wide `FittedBox` render transform. It was rejected in review for mispositioning seven overlay anchors and for remounting the Navigator when the scale crossed 1.0. **No version of this work reintroduces a render transform.**

## Decisions

### 1. The supported floor is 620 x 1072 logical pixels of client area

Every desktop surface must be usable in a client area 620 logical pixels tall and 1072 wide.

Height, derived from the worst supported case. Every chrome figure below has a source:

| Case | Work area | Chrome | Client |
| --- | --- | --- | --- |
| 1366x768, Windows 11, 48 px taskbar | 720 | 40 | 680 |
| 1366x768, Windows 10, 40 px taskbar | 728 | 40 | 688 |
| **1280x720, Windows 11, 48 px taskbar** | 672 | 40 | **632** |
| 1366x768, GNOME on Yaru, 27 px top bar | 741 | 46 | 695 |
| 1366x768, KDE, 44 px bottom panel, server-side title bar | 724 | 30 | 694 |
| 1440x900, macOS, menu bar and dock | 815 | 28 | 787 |

Sources: the Windows frame of 40 px is this repo's own `min app width is 1072` comment plus its 1088 outer width (`lib/start_app.dart:92`); the 48 px taskbar is Microsoft layout guidance, not an API guarantee. The GTK header bar of 46 px is Ubuntu Yaru's declared height (40 px in compact mode), and the header bar is outside the Flutter client area because `linux/my_application.cc:53-58` installs it through `gtk_window_set_titlebar` while the `FlView` is the container child (`:73`).

**1280x720 on Windows is the binding case, at 632 px.** No Linux desktop measured here goes lower. 620 clears every row with 12 px to spare. A floor of 640 fails 1280x720; a floor of 688 fails the headline 1366x768 case it was chosen for.

Width is 1072 because that is what the screens are built for. **1024x768 and every smaller width are explicitly unsupported**, and so is any work area narrower than 1072 plus chrome. Supporting them means redesigning every desktop page for a narrower layout; that is a separate project.

The floor is a floor, not a target. Nothing opens at it, and decision 13 tests every surface at the design height precisely so the floor cannot quietly become the design target.

### 2. The launch size and the minimum size are two independent numbers

- **Launch size** = `min(1088x880, work area of the target display)`, per axis, as an **outer window** figure.
- **Minimum size** = the floor of decision 1 plus chrome (decision 5), capped by decision 6.

Decoupling them is what makes the window recoverable. A user who drags the window to a smaller display, or whose screen resolution changes, can always resize it back into view.

**The launch size is an outer target on every platform, and Linux needs a correction to make it one.** `window_manager`'s `setSize` reaches `gtk_window_resize` on Linux (`window_manager_plugin.cc:287-289`), which GTK documents as targeting the size *excluding* the client-side decorations. Requesting a height equal to the work area therefore produces an outer window taller than the work area by the header bar. On Linux the request is `workArea - decoration`, using the same measurement decision 5 makes.

### 3. `center: true` stays, and the sizing display is chosen the way the centring display is

The work area comes from the display that `calcWindowPosition` will centre on: the one containing the mouse cursor, found by containment against `visiblePosition` and `size`, falling back to the primary display (`calc_window_position.dart:8-20`). Sizing and placement then agree by construction, and single-monitor launch placement does not change at all.

An earlier draft replaced `center: true` with an explicit `setBounds`. **That is worse, and it is rejected.** The two coordinate systems involved do not agree on a mixed-DPI Windows desktop:

- `screen_retriever_windows_plugin.cpp:118-124` divides each monitor's `rcWork` by *that monitor's* DPI scale;
- `screen_retriever_windows_plugin.cpp:196-202` divides the physical cursor point by the *current Flutter view's* device pixel ratio;
- `window_manager.cpp:745-762` multiplies a `setBounds` position by that same current ratio.

A 1920-wide primary at 100% with a secondary at 150% reports the secondary's origin as logical x=1280, and a window placed there lands at physical x=1376 — back on the primary. This inconsistency is in the plugins and is **present today** in `calcWindowPosition`. This ADR does not fix it and must not claim to; it is recorded in section 14 as a candidate issue. Choosing the same display for sizing keeps the ADR from making it worse.

> **Amended by [#261](../../issues/261) (2026-09-09):** On Windows and macOS the launch no longer centres through the plugin. A new runner channel, `app.sideswap.io/launch_placement`, answers two questions: the work area of the display under the cursor in that display's own logical units, and — given the logical window size — that display's centred rectangle, written in physical pixels by the same native call that selects the monitor. The two are separate hops, because the window's own setup runs between them, so the runner **latches** the display the first answer named and the second reuses it. The cursor may cross a boundary in the gap; the size and the placement may not disagree because of it.
>
> **This honours the rejection above rather than overriding it.** What decision 3 rejects is `window_manager.setBounds`, whose failure mode is the three conversions quoted above: a display origin divided by that display's scale, a cursor divided by the current view's ratio, and a position multiplied back by that same current ratio. The channel performs none of them. It is the "native monitor-under-cursor query in physical coordinates" that section 14 states a real fix requires, and it is the precondition that section names. macOS never had the Windows failure mode — AppKit points are one unit across every screen — but it has its own: `screen_retriever` flips a display's position with the first screen's height while it flips the cursor with the minimum `maxY` across all screens. The channel removes that conversion too, because only a size crosses it.
>
> Three things are unchanged. The sizing display and the placement display are still the same display by construction — now because the latch above makes them one display, rather than because `desktopDisplayFor` mirrors `calcWindowPosition`. `desktopWindowSizeFor` and `desktopMinimumSizeFor` keep their contracts and their inputs, because the work area the channel reports is what `screen_retriever` reports for that monitor, field for field (decision 4). And `center: true` survives as the documented fallback: a channel that throws, or answers unusably, takes the launch through the whole pre-#261 path, and the reason is logged.
>
> **The placement reports whether it landed.** Windows clamps a programmatic `SetWindowPos` to the window's minimum track size, which `window_manager` scales by the device pixel ratio of the *creating* view, and a move across a DPI boundary raises `WM_DPICHANGED`, which the runner honours over the rectangle just written. Both settle once the move has landed, so the native side writes the rectangle, reads it back, and retries; what it answers is whether the window is where it was asked to be. A false answer takes the launch to the fallback below, with the reason logged. A placement silently refused would otherwise be indistinguishable from one that worked.
>
> Linux is untouched. Placement there is a request the window manager may ignore (section 14), so Linux keeps `center: true` and `desktopDisplayFor`.
>
> **The uniform-scale guard of [ADR-0016](0016-desktop-window-geometry-persistence.md) decision 3 stays.** Lifting it needs a native operation for the *restore* path — an absolute placement of stored bounds, not a centring — and no acceptance criterion of #261 describes one. ADR-0016 decision 3 ("#261 lifts the guard") and its rejected alternative ("A mixed-DPI desktop never restores until #261 lands") are therefore stale as of this change; the guard is a candidate issue of its own.

### 4. The work area comes from `screen_retriever`, and `window_size` leaves `lib/`

`screen_retriever` is already a dependency (transitive, through `window_manager`) and already reports the work area in logical pixels, so the physical-to-logical conversion #253 performs is not needed:

- Windows: `screen_retriever_windows_plugin.cpp:118-124` divides `MONITORINFO.rcWork` by the monitor's DPI scale.
- Linux: `screen_retriever_linux_plugin.cc:55-70` returns `gdk_monitor_get_workarea`, which GDK reports in application pixels.
- macOS: `NSScreen.visibleFrame` in points (`ScreenRetrieverMacosPlugin.swift`).

Use **only** `visibleSize` and `visiblePosition`. `Display.size` from the Windows plugin is computed as `rcMonitor.right/scale - rcWork.left/scale` (`:130-135`), which is not the monitor size on a non-primary display.

`window_size` then has no caller. It is a git pin at a 2020 commit with exactly one call site (`lib/start_app.dart:96`), and its Linux monitor scan is wrong besides: `window_size_plugin.cc:148-149` bounds `y` by `frame.y + frame.width` instead of `frame.height`, so vertically stacked monitors are misidentified. It is removed from `pubspec.yaml`.

**An unknown work area falls back to the floor, not to the design size.** `desktopWindowSizeFor(null)` in #253 returns the full 1088x880, which on a missing or malformed report reproduces the oversized-window failure — a fail-open fallback wearing a fail-closed name. A window smaller than it needs to be is one the user can enlarge. The report and the fallback taken are both logged.

The clamp itself survives from #253, and so do the three properties that made it reviewable: it takes a plain `Size?` rather than a plugin object, it clamps per axis, and it is a public top-level function tested directly. Widening a production member's visibility for a test is banned by `docs/TESTING.md`, and a public top-level function is the prescribed alternative.

### 5. The floor is expressed in client pixels, and converted per platform

`setMinimumSize` takes the **outer** window size; decision 1 is a **client** size. The difference is the OS chrome, and no single rule covers all three desktops.

- **Windows and macOS: measure it.** `chrome = await windowManager.getSize() - MediaQuery.sizeOf(context)`. On Windows `getBounds` is `GetWindowRect` divided by `devicePixelRatio` (`window_manager.cpp:718-740`), so the difference is the real frame.
- **Linux: ask the toolkit.** `window_manager` exposes `getTitleBarHeight()`, which reads `gtk_widget_get_allocated_height` of the actual title bar widget (`window_manager_plugin.cc:535-544`). `linux/my_application.cc:43-58` installs a `GtkHeaderBar` only on GNOME and Wayland; on other X11 desktops the decoration is server-side and lies **outside** the GDK window, so no allowance is wanted there — adding one would count the frame twice.

  The plugin gives the right answer in both cases, verified in its source. The app never calls `setTitleBarStyle`, and `window_manager_plugin_init` (`:950`) is empty, so `title_bar_style_` is null and the guard `g_strcmp0(self->title_bar_style_, "hidden") != 0` is true. On a server-side-decoration desktop `gtk_window_get_titlebar` returns null, and `gtk_widget_get_allocated_height(NULL)` returns 0 through GTK's `g_return_val_if_fail` rather than crashing. So the allowance is the header bar height where there is one and 0 where the frame is outside the window — which is correct — at the cost of one GLib `CRITICAL` line in the log on the server-side path. Treat that log line as expected, not as a defect to chase.

  A subtraction of `getSize() - MediaQuery.sizeOf(context)` does **not** work on Linux: `getBounds` is `gtk_window_get_size` (`window_manager_plugin.cc:262-274`), which GTK documents as excluding client-side decorations, so the difference is near zero.

**The measurement is guarded, not assumed.** The window is shown before `runApp` (`lib/start_app.dart:111`, `:142`), so the user or a session manager can maximize it before the first frame. Before measuring, query `isMaximized`, `isMinimized` and `isFullScreen` and defer while any is true. Require two consecutive equal samples. Reject a result outside a per-axis plausibility band and keep the platform constant. Until a measurement is accepted, the bootstrap minimum is the platform constant: `Size(1088, 660)` on Windows.

### 6. The effective minimum is capped to the work area

`setMinimumSize` is never given a size larger than the target display's work area.

A fixed 660 px outer minimum on a screen whose work area is 648 px is a window that cannot be shrunk to fit its own screen — the class of bug this ADR exists to remove, reintroduced by a large taskbar. The conflict starts as soon as the reserved area exceeds `screenHeight - (floor + chrome)`, which on 1366x768 is 108 px.

So the applied minimum is `min(floor + chrome, work area)`, per axis. When the cap binds, the machine is below the supported floor: log it plainly, and let the window be smaller than any surface was built for. Everything still scrolls; nothing is unreachable.

The cap and decision 7 pull against each other, and the direction is chosen deliberately. Launch on a screen whose work area is 648 px, then move to a larger display: the minimum stays at 648, below the floor, and the user can shrink into a window no surface is built for. That is accepted. A window that is too small is one the user can enlarge; a window that is too large for its screen is the trap this ADR exists to remove.

### 7. Nothing resizes or repositions the window after launch

The window is sized and placed once, and the user owns it from then on. Recovery from a smaller display is the user's resize, which decisions 2 and 6 make possible.

An earlier draft added a `didChangeMetrics` observer that re-applied `setMinimumSize` when the device pixel ratio changed, on the belief that `window_manager` freezes the DPI it was given. **That belief is false.** `window_manager_plugin.cpp:141-145` refreshes `pixel_ratio_` from `WM_DPICHANGED`:

```cpp
if (message == WM_DPICHANGED) {
  window_manager->pixel_ratio_ =
      (float)LOWORD(wParam) / USER_DEFAULT_SCREEN_DPI;
  window_manager->ForceChildRefresh();
}
```

and `WM_GETMINMAXINFO` (`:190-205`) reads the refreshed value. The delegate is registered in the plugin constructor (`:107-110`). Windows keeps the physical floor correct across a DPI change by itself.

Moving the window with `setBounds` on a display change is a different proposal, and it is rejected: it moves the user's window without being asked and needs a policy for when that is allowed.

### 8. A surface pins its actions and scrolls its body

- `content` is laid out through `Flexible(fit: FlexFit.loose)` **and** a `SingleChildScrollView`. Both halves are required. `Flexible` alone squeezes and silently clips — that is the #254 defect.
- `actions` is unflexed and always visible. The title stays outside the scroll body too; only `content` scrolls.

`FlexFit.loose` is what keeps the common case unchanged: with room to spare the child takes its natural height, the scroll view has zero extent, and there is no scrollbar and no scrollable gesture. This is `lib/desktop/settings/d_settings.dart:56-65` promoted from one screen to the wrapper.

`DContentDialog` already has the three slots (`title`, `content`, `actions`). `DPopupWithClose` has only `child` and gains an `actions` slot.

Consequences for the surfaces:

- **18 surfaces** declare a height above the floor and move their primary controls into the `actions` slot: `d_select_inputs_popup.dart:37` (808), `d_settings.dart:49` (760), `d_license.dart:18` (752), `d_limit_panel_review_order_dialog.dart:53` (733), `d_send_popup.dart:263` (710), `d_payment_select_asset.dart:34` (710), `d_settings_licenses.dart:152` (696), `d_settings_logs.dart:86` (693), `d_settings_about_us.dart:31` (693), `d_send_popup.dart:455` (675), `d_tx_popup.dart:29` and `:191` (660), `d_pin_setup.dart:81` (645), `d_settings_network_access.dart:43` (635), `d_settings_default_currency.dart:28` (635), `d_network_access_onboarding.dart:23` (635), `d_edit_order_dialog.dart:290` (635), `d_asset_info.dart:74` (632).
- **8 dialogs** declare no height bound at all; their `Column(mainAxisSize: MainAxisSize.min)` grows without limit and nothing clips it. Each gains a `maxHeight`.

> **Amended by #267 (2026-09-08):** The markets order form is the one surface whose primary action is not pinned. On both of its tabs CONTINUE sits at the end of the scroll body, the body sizes to its content, and the form shows a scrollbar thumb whenever it can scroll. Measured on the live app at the floor on 2026-09-08: the form has about 188 px, and a pinned band costs 50 of them. Pinned, the limit tab leaves 125 px of body and cuts the price field; a pinned market tab would leave about 138 px and put all three quote rows (Deliver, Receive, Price) behind the scroll. The quote is what the user accepts, so it outranks the button. The rejected "uniform scrolling" alternative fails on discoverability only where nothing shows that the form scrolls; the scrollbar thumb carries that job here. The exception is scoped to this form: dialogs keep their `actions` slot, and the pages of decision 11 keep their pinned action. This reverts the limit-tab pin from PR #265.

### 9. Wrapper-managed scrolling ends as the default, and a self-scrolling body says so explicitly

A surface has exactly one scroll owner. Nine surfaces already own theirs:

`d_settings.dart:56`, `d_settings_licenses.dart:183` (a controller-owned always-visible `Scrollbar`), `d_wallet_descriptors.dart:202`, `d_select_inputs_popup.dart:328`, `d_send_popup.dart:646`, `payment_select_asset.dart:136`, `d_license.dart:48`, `d_settings_view_backup.dart:143`, `d_settings_default_currency.dart:62`.

Nested scrollables swallow the wheel: Flutter stops propagating to the parent while the inner scrollable can still move, so a second owner is not a safety net — it is a dead zone.

The wrapper therefore takes `scrollOwner`, an enum, and **the correct value ends as the default**:

- `ScrollOwner.wrapper` — the wrapper scrolls `content`. This is what an ordinary surface wants, and it becomes the default value.
- `ScrollOwner.child` — the content owns its scrollable; the wrapper supplies the `Flexible` half only. Set deliberately, on the nine surfaces above.
- `ScrollOwner.legacy` — today's behaviour, unchanged. It exists only during the migration and is the default until the last call site leaves it.

An opt-in flag with the unsafe behaviour as its default would make correctness depend on 47 call sites remembering a negative rule. The `legacy` default inverts that: it is a temporary state the migration removes, and flipping it is one line with the whole suite behind it.

> **Amended by #259 (2026-09-07):** `ScrollOwner.legacy` is deleted and `wrapper` is the default. The migration did not leave every surface explicit, so four popups that flex to a declared height through a `Spacer()` — `side_swap_scaffold.dart:69`, `d_export_csv_popup.dart:28`, `d_open_tx_import.dart:97`, `d_notifications.dart:1654` — now state `ScrollOwner.child`. `child` therefore reads as *the wrapper supplies the `Flexible` half and no scroll view of its own*: content that owns a scrollable scrolls, and content that flexes to its declared height keeps that layout. Those four own no scrollable and still cannot scroll at the floor; #268 sweeps them.

### 10. No fix may switch the shape of the widget tree on a height threshold

`height < 620 ? SingleChildScrollView(child) : child` re-inflates the subtree every time the window crosses the threshold, discarding form state, focus and scroll positions. This is the same failure that made the `FittedBox` version of #254 unacceptable.

`DScrollWhenShort` from #254 is salvaged for exactly this property: it always returns `SingleChildScrollView(child: SizedBox(height: height, child: child))`, so nothing remounts, and `primary: false` keeps it from taking the primary scroll controller.

Two preconditions, stated in its doc comment and tested at every call site:

- **The parent's height must be bounded.** Under an unbounded parent it collapses to the design height and does nothing.
- **The content must not exceed the design height.** The fixed `SizedBox` clips content that grows past it — a longer translation, a larger font — and the scroll extent is computed from the box, not from what overflows it. Where content can grow, give it a *minimum* design height and let the scroll body take its natural size instead.

The Navigator is separately safe: `lib/providers/warmup_app_provider.dart:54-57` supplies a `GlobalKey<NavigatorState>` from a `keepAlive` provider, used at `lib/desktop/desktop_root_widget.dart:99-104`. A `GlobalKey` carries its state across a reparent.

### 11. The pages get a compact layout at the floor, not only a scrollbar

A 620 px client leaves `620 - 34 - 56 - 24 = 506` px of page content. Fitting geometrically is not the same as being usable, and four pages fail the second test:

- **`DHome`** — `DTxAndOrdersPanel` carries `minHeight: 227` (`d_tx_and_orders_panel.dart:53`) and is *not* `Flexible` in the page column (`d_home.dart:17-24`), while the assets panel is. The assets panel is therefore left about 199 px: a 58 px header (`d_assets_panel_header.dart:19`) and two 53 px rows (`d_asset_list_tile.dart:39`). The wallet shows two assets.
- **`DMarkets`** — the order form is a fixed 331 px (`market_order_panel.dart:355`) with about 160 px to live in, so over 230 px of the trading form scrolls while the 227 px history panel stays fully visible.
- **`DInstantSwap`** — needs `28 + 561 = 589` px; the primary action sits 83 px below the fold.
- **`DPegInOut`** — 680 px, of which 174 scroll, and `SwapBottomButton` is at the bottom behind a `Spacer()` (`d_peg_in_out.dart:405`).

So the pages take the same treatment the surfaces do:

- The transactions-and-orders panel gives height instead of taking it. On `DHome` that is a swap of which panel is `Flexible`; on `DMarkets` the panel and the order column share the shortfall.
- The primary action of `DInstantSwap` and `DPegInOut` is pinned outside the scroll body, the way `actions` is in a dialog.

Acceptance is stated as a task, not as a geometry: at the floor, a user can place an order, swap, peg out and answer a sign request **without first discovering a hidden control**.

> **Amended by #267 (2026-09-08):** On `DMarkets` the task reads: at the floor the user sees the quote rows and a scrollbar thumb on the order form, and reaches CONTINUE with one wheel scroll. The form's CONTINUE is the exception to decision 8; see the amendment there.

### 12. Delivery is vertical slices behind an unchanged default

The wrapper API of decision 9 is additive and default-preserving, so nothing has to land at once. Landing it all in one change would be roughly 28 production files and 55 files with tests — large enough for scroll ownership, action extraction, translation and provider state to hide one another in review.

The order:

1. The three wrappers gain `scrollOwner` (default `legacy`), the `actions` slot on `DPopupWithClose`, and `DScrollWhenShort`, with wrapper tests on a synthetic body. Nothing else changes; no existing test moves.
2. The 18 surfaces above the floor, migrated by family (settings, onboarding, markets, send/transactions), each family with its tests.
3. The 8 unbounded dialogs gain a height bound.
4. The four pages — decision 11.
5. The `scrollOwner` default flips to `wrapper` once nothing is left on `legacy`.
6. The window policy — decisions 2, 3, 4, 5, 6, 7. **This is the enabling change and it lands last**: it is what lets the user shrink the window, and shipping it earlier would expose exactly the layouts that are not ready.

**#233 is independent and does not gate any of this.** An earlier draft claimed the window cannot be resized today; that is wrong, because `minimumSize` is a lower bound and enlarging, maximizing and restoring already trigger the remove-and-recreate at `lib/desktop/widgets/d_notifications.dart:122-128`. `CONTEXT.md:82` records a measurement showing the resize does not throw or strand a click catcher. It should be fixed by re-anchoring the existing entry (`markNeedsBuild()` against an offset in a `ValueNotifier`) rather than removing it.

### 13. The test matrix is small enough to be written

Three levels, so the total is proportionate to the 355 `testWidgets` cases the suite has today:

- **Per wrapper, once each, on a synthetic body:** the design height, the natural height plus and minus one pixel (the transition where scrolling starts), and the floor. The ±1 case belongs here and only here — on a real surface the natural height depends on provider state, locale and font metrics, and the requirement would be approximated or skipped.
- **Per surface (26):** the design client height of 840 px, where the surface's own scroll owner has zero extent and the layout is unchanged; and the floor of 620x1072, where there is no vertical overflow and the `actions` row is `hitTestable()` and its callback fires when tapped. Both in the surface's tallest realistic provider state.
- **Per page (4):** the same two sizes, plus the task assertion of decision 11.

That is about 70 new cases.

Three cautions the harness imposes:

- **Assert the surface's own scroll owner**, found through a public finder, not "the one `Scrollable` in the tree". Several surfaces legitimately contain more than one.
- **`test/helpers/ignore_overflow.dart` makes a naive "no overflow" assertion vacuous.** Capture vertical overflow explicitly and filter, at most, known horizontal block-font noise.
- **`--no-test-assets` gives the wrong font metrics.** `test/widgets/d_settings_test.dart:72` works around it with a 0.3 text scale, which cannot prove production text fit. A layout test at the floor bounds the box, not the glyphs; the text fit is what the on-device check is for.

The manual check is 1366x768 at 100%, 1280x720 at 100% and 1920x1080 at 150% on Windows, one GNOME and one non-GNOME Linux desktop, and macOS: every page and popup reachable, every primary action visible without scrolling, scrollbars only where the window is short.

### 14. What this ADR deliberately does not decide

Each is a candidate issue, not a gap to fill here:

- **The plugins' mixed-DPI coordinate inconsistency** (decision 3). Present today; a real fix needs a native monitor-under-cursor query in physical coordinates. Answered by [#261](../../issues/261), which adds that query as a runner channel on Windows and macOS; see the amendment to decision 3.
- **Window geometry is never persisted.** Every launch recentres rather than restoring the user's last size and monitor. This would also be the better answer to "which display did the user mean". Answered by [ADR-0016](0016-desktop-window-geometry-persistence.md) and issue #284, which stores the geometry and restores it only where the whole window stays visible.
- **A work-area change after launch** — the taskbar growing, a panel appearing, the resolution dropping — is not detected. Decision 6 caps the minimum at launch only.
- **Maximized and full-screen** states are excluded from the chrome measurement rather than handled.
- **Linux placement is a request, not a guarantee.** `setBounds` reaches `gtk_window_move`, which a window manager may ignore.
- **The desktop `--mobileMode` path** (`lib/start_app.dart:76-90`) still couples `minimumSize` to a fixed 400x800.

## Consequences

- The window opens unchanged on any screen with room, and within the work area on any screen without one.
- The size and the position come from one display, so a multi-monitor launch cannot size for one screen and place on another.
- The user can shrink the window to the floor on every platform, and can recover a window that no longer fits. On a machine below the floor the minimum yields rather than trapping the window.
- The `window_size` git pin leaves the project.
- 26 surfaces and 4 pages are touched by hand; the wrappers carry the rest, and the correct behaviour ends as the default.
- Scrollbars appear only where a window is genuinely shorter than a surface was designed for, and no primary action ever hides behind one.
- Nothing is scaled. There is no render transform anywhere in the result.
- 1024x768 and narrower is stated as unsupported rather than left ambiguous.

## Alternatives rejected

- **An app-wide `FittedBox`.** The first version of #254. Seven overlay anchors transformed twice, a Navigator remount when the scale crosses 1.0, hairlines and 10 pt text sub-pixel at 1366x768 at 100%, and no lower bound on the scale.
- **Uniform scrolling, no pinned actions.** #254 as it stands. Cheap, but it puts the primary action of the send flow below the fold. It replaces a visible defect with an invisible one. Reopened for one surface, the markets order form, by #267; see the amendment to decision 8.
- **Geometric fit alone, with no compact page layout.** Passes every test in decision 13's first two levels and leaves a wallet showing two assets. Rejected in favour of decision 11.
- **A floor of 640 or 688 px.** Both fail cases in decision 1's own table.
- **Per-screen redesign to fit the floor without scrolling.** Correct for the 18 surfaces above it, but nothing then holds the line: the next content change crosses it again with no mechanism to notice.
- **A `didChangeMetrics` observer re-applying the minimum on a DPI change.** The defect it fixed does not exist (decision 7).
- **Replacing `center: true` with an explicit `setBounds`.** Worse on mixed-DPI Windows (decision 3). Superseded on Windows and macOS by the native placement channel of #261, which is not a `setBounds`; see the amendment to decision 3.
- **Measuring the chrome on Linux the way Windows measures it.** `gtk_window_get_size` excludes the decorations being measured, and a fixed 50 px allowance double-counts a server-side frame (decision 5).
- **Keeping `window_size` for the work area.** It needs a conversion `screen_retriever` has already done, it disagrees with the display `center: true` uses, and its Linux monitor scan has a `frame.width`/`frame.height` bug.
- **An opt-in wrapper scroll flag.** Leaves the unsafe behaviour as the default for ever (decision 9).
- **Landing the wrappers and every migration as one change.** Unnecessary once the API is default-preserving, and unreviewable at 55 files (decision 12).

## Work

| # | Issue | Blocked by |
| --- | --- | --- |
| 1 | The three wrappers: `scrollOwner`, the `actions` slot, `DScrollWhenShort` — decisions 8, 9, 10 | — |
| 2 | The 18 surfaces above the floor migrate to pinned actions, by family | 1 |
| 3 | The 8 unbounded dialogs gain a height bound | 1 |
| 4 | The four desktop pages: compact layout and pinned primary actions — decision 11 | 1 |
| 5 | The `scrollOwner` default flips to `wrapper` | 2, 3, 4 |
| 6 | Window sizing, target display, minimum policy and the work-area cap — decisions 2–7 | 5 |
| 7 | #233 — the overlay panels re-anchor instead of being rebuilt | — |

Pull requests #253 and #254 are closed as superseded. The code named in decisions 4, 8 and 10 is quoted in the issue bodies so it is not invented a second time.

## Review notes

Every finding below was re-verified against the source before it was applied.

**v1 → v2, Codex devil's advocate.**

- **The DPI observer was deleted.** Its premise — that `window_manager` freezes `pixel_ratio_` — is false (`window_manager_plugin.cpp:141-145`).
- **The floor moved from 640 to 620.** v1's table omitted 1280x720 and treated the GTK work area as the client area.
- **A width floor was added.** v1 never stated one.
- **The work area moved to `screen_retriever`, and the target display is chosen once.**
- **The unknown-work-area fallback changed from the design size to the floor.**
- **The chrome measurement became per-platform.**
- **The work order was reversed and #233 unblocked.**
- **The wrapper and its migrations were bound into one change**, and three test cautions were added.
- **`DScrollWhenShort` gained two stated preconditions.**

**v2 → v3, Codex adversarial.**

- **Decision 11 is new.** v2 proved the pages fit and never asked whether they work: at the floor `DHome` shows two assets, `DMarkets` scrolls 230 px of trading form, and two pages hide their primary action.
- **`center: true` is kept.** v2's explicit `setBounds` is wrong on mixed-DPI Windows, because the cursor point and the display origins are divided by different scales.
- **The launch size became an outer target,** with a Linux correction: `gtk_window_resize` excludes the decorations, so v2's request would still overflow the GTK work area.
- **Decision 6 is new — the minimum is capped to the work area.** v2's fixed minimum could exceed the work area on a machine with a large taskbar and trap the window: the very bug being fixed.
- **The Linux chrome allowance became `getTitleBarHeight()` with a server-side-decoration branch.** v2's flat 50 px double-counts an out-of-window frame and ignores that Yaru declares 46 px, 40 in compact mode.
- **The chrome measurement gained enforced preconditions** — state checks and two stable samples — rather than asserted ones.
- **The wrapper scroll body went from opt-in to a `legacy` default that flips**, so the correct behaviour ends as the default instead of depending on 47 call sites.
- **Delivery went from one change to vertical slices,** which the default-preserving API makes possible.
- **The surface count went from 13 to 18** once the floor moved to 620, and the existing-scroll-owner list from six to nine.
- **The test matrix was restructured.** v2's "natural height ±1" is not writable against a real surface; it moved to the wrappers, on a synthetic body.
- **Decision 1's table rows are now sourced,** and the unsourced two-panel GTK row was replaced by measured GNOME and KDE cases. The binding case turns out to be Windows at 1280x720, not Linux.

Counts re-derived: 18 surfaces above 620, 8 unbounded dialogs, 9 existing scroll owners, 64 wrapper-built surfaces (38 `DContentDialog` + 9 `SideSwapPopupPage` + 17 `DPopupWithClose`).
