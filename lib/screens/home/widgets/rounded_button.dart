import 'package:flutter/material.dart';

import 'package:sideswap/common/screen_utils.dart';

class RoundedButton extends StatefulWidget {
  const RoundedButton({
    Key? key,
    this.onTap,
    this.color = const Color(0xFF0D5574),
    this.child,
    this.width,
    this.heigh,
    this.borderRadius,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Color? color;
  final Widget? child;
  final double? width;
  final double? heigh;
  final BorderRadiusGeometry? borderRadius;

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  late double _width;
  late double _height;
  late BorderRadiusGeometry _borderRadius;

  @override
  void initState() {
    super.initState();
    _width = widget.width ?? 42.h;
    _height = widget.heigh ?? 42.h;
    _borderRadius = widget.borderRadius ?? BorderRadius.circular(42.w);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.color,
      borderRadius: _borderRadius,
      child: InkWell(
        onTap: widget.onTap,
        customBorder: widget.borderRadius == null ? const CircleBorder() : null,
        child: SizedBox(
          width: _width,
          height: _height,
          child: Center(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
