// Desktop widget to detect click (without padding and UI)
import 'package:flutter/widgets.dart';

class DTransparentButton extends StatelessWidget {
  const DTransparentButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: child,
      onTap: onPressed,
    );
  }
}
