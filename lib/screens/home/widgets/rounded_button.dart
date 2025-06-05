import 'package:flutter/material.dart';

class RoundedButton extends StatefulWidget {
  const RoundedButton({
    super.key,
    this.onTap,
    this.color = const Color(0xFF0D5574),
    this.child,
    this.width,
    this.height,
    this.borderRadius,
  });

  final VoidCallback? onTap;
  final Color? color;
  final Widget? child;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  RoundedButtonState createState() => RoundedButtonState();
}

class RoundedButtonState extends State<RoundedButton> {
  late double _width;
  late double _height;
  late BorderRadius _borderRadius;

  @override
  void initState() {
    super.initState();
    _width = widget.width ?? 42;
    _height = widget.height ?? 42;
    _borderRadius = widget.borderRadius ?? BorderRadius.circular(42);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.color,
      borderRadius: _borderRadius,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: widget.borderRadius,
        customBorder: widget.borderRadius == null ? const CircleBorder() : null,
        child: SizedBox(
          width: _width,
          height: _height,
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
