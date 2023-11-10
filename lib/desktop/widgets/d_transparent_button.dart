// Desktop widget to detect click (without padding and UI)
import 'package:flutter/widgets.dart';

class DTransparentButton extends StatelessWidget {
  const DTransparentButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed,
      child: child,
    );
  }
}
