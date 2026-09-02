import 'package:flutter/widgets.dart';

/// Lays [child] out at [height], the height it was designed for, and scrolls
/// it when the parent is shorter. A parent at least [height] tall gets a
/// plain [height]-tall box with nothing to scroll, so screens designed for
/// the default window keep their layout there and become scrollable on a
/// laptop whose work area is smaller.
///
/// The tree has the same shape whether or not it scrolls, so a window resized
/// across the design height keeps the child's state (form fields, focus,
/// navigation) instead of re-inflating it.
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
