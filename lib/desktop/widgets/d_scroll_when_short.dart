import 'package:flutter/widgets.dart';

/// Which widget of a desktop surface owns the surface's scrollable.
///
/// A surface has exactly one scroll owner. Nested scrollables swallow the
/// wheel — Flutter stops propagating to the parent while the inner one can
/// still move — so a second owner is a dead zone rather than a safety net.
/// See [ADR-0014](../../../docs/adr/0014-desktop-minimum-window-height.md)
/// decision 9.
enum ScrollOwner {
  /// The wrapper scrolls its content: it lays the content out through both a
  /// `Flexible(fit: FlexFit.loose)` and a `SingleChildScrollView`.
  ///
  /// Both halves are required. `Flexible` alone squeezes the content and
  /// silently clips it. `FlexFit.loose` is what keeps the common case
  /// unchanged: with room to spare the content takes its natural height, the
  /// scroll view has zero extent, and there is no scrollbar and no scroll
  /// gesture.
  wrapper,

  /// The wrapper supplies the `Flexible` half only and adds no scroll view of
  /// its own, so the content is given the room it has and lays itself out in
  /// it.
  ///
  /// Content that owns a scrollable then scrolls itself. Content that flexes
  /// to the room instead -- a `Spacer()` inside a popup that declares its
  /// height -- keeps the layout it has, which a wrapper-side scroll view would
  /// break by handing it an unbounded height. Such content has no owner at
  /// all, so it clips at the floor exactly as it does today; ADR-0014
  /// decision 9 records which surfaces those are.
  child,
}

/// Lays [child] out at [height], the height it was designed for, and scrolls
/// it when the parent is shorter. A parent at least [height] tall gets a
/// plain [height]-tall box with nothing to scroll, so surfaces designed for
/// the default window keep their layout there and become scrollable on a
/// laptop whose work area is smaller.
///
/// The tree has the same shape whether or not it scrolls, so a window resized
/// across the design height keeps the child's state (form fields, focus,
/// navigation) instead of re-inflating it. Never replace this with
/// `height < floor ? SingleChildScrollView(child) : child`.
///
/// Two preconditions, and each call site is tested against both:
///
/// - **The parent's height must be bounded.** Under an unbounded parent this
///   widget collapses to [height] and does nothing.
/// - **[child] must not outgrow [height].** The fixed [SizedBox] clips content
///   that grows past it — a longer translation, a larger font — and the scroll
///   extent is computed from the box, not from what overflows it. Where the
///   content can grow, give it a *minimum* design height and let the scroll
///   body take its natural size instead.
class DScrollWhenShort extends StatelessWidget {
  const DScrollWhenShort({
    super.key,
    required this.height,
    required this.child,
  });

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: SizedBox(height: height, child: child),
    );
  }
}
