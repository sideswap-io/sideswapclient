import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sideswap/screens/flavor_config.dart';

/// Pops the route [child] sits in when the user presses Enter on desktop.
///
/// The focus node the key handling needs belongs to this widget's [State], so
/// it lives exactly as long as the route does and is disposed with it — on a
/// button, on the barrier, and on Esc alike. A node built inside a
/// `showDialog` builder would instead be rebuilt per builder run and never
/// disposed (ADR-0011 decision 6).
class EnterToDismiss extends StatefulWidget {
  const EnterToDismiss({super.key, required this.child});

  final Widget child;

  @override
  State<EnterToDismiss> createState() => _EnterToDismissState();
}

class _EnterToDismissState extends State<EnterToDismiss> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onKeyEvent(KeyEvent event) {
    if (FlavorConfig.isDesktop &&
        event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: widget.child,
    );
  }
}
