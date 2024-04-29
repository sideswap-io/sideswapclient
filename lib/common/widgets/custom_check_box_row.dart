import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class CustomCheckBoxRow extends StatefulWidget {
  const CustomCheckBoxRow({
    super.key,
    required this.onChanged,
    required this.child,
    this.frameChecked = const Color(0xFFB1EDFF),
    this.frameUnchecked = SideSwapColors.brightTurquoise,
    this.backgroundChecked = SideSwapColors.brightTurquoise,
    this.backgroundUnchecked = const Color(0xFF357CA4),
    this.radius,
    this.size,
    this.icon,
    required this.value,
    this.padding,
  });

  final ValueChanged<bool> onChanged;
  final Widget child;
  final Color frameChecked;
  final Color frameUnchecked;
  final Color backgroundChecked;
  final Color backgroundUnchecked;
  final Radius? radius;
  final double? size;
  final Widget? icon;
  final bool value;
  final EdgeInsetsGeometry? padding;

  @override
  CustomCheckBoxRowState createState() => CustomCheckBoxRowState();
}

class CustomCheckBoxRowState extends State<CustomCheckBoxRow>
    with TickerProviderStateMixin {
  late Radius radius;
  late double size;
  late Widget icon;

  bool? value;

  late AnimationController frameColorController;
  late Animation<Color?> frameColorAnimation;
  late CurvedAnimation frameColorCurve;

  late AnimationController backgroundColorController;
  late Animation<Color?> backgroundColorAnimation;
  late CurvedAnimation backgroundColorCurve;

  late AnimationController fadeController;
  late Animation<double?> fadeAnimation;
  late CurvedAnimation fadeCurve;

  @override
  void initState() {
    super.initState();

    value = widget.value;

    radius = widget.radius ?? const Radius.circular(4);
    size = widget.size ?? 16;
    icon = widget.icon ??
        const Icon(
          Icons.check,
          size: 13,
        );

    frameColorController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    frameColorCurve =
        CurvedAnimation(parent: frameColorController, curve: Curves.easeOut);
    frameColorAnimation =
        ColorTween(begin: widget.frameUnchecked, end: widget.frameChecked)
            .animate(frameColorCurve)
          ..addListener(() {
            setState(() {});
          });

    backgroundColorController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    backgroundColorCurve = CurvedAnimation(
        parent: backgroundColorController, curve: Curves.easeOut);
    backgroundColorAnimation = ColorTween(
            begin: widget.backgroundUnchecked, end: widget.backgroundChecked)
        .animate(backgroundColorCurve)
      ..addListener(() {
        setState(() {});
      });

    fadeController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    fadeCurve = CurvedAnimation(parent: fadeController, curve: Curves.easeOut);
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(fadeController)
      ..addListener(() {
        setState(() {});
      });

    animate();
  }

  @override
  void dispose() {
    frameColorController.dispose();
    backgroundColorController.dispose();
    fadeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomCheckBoxRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      value = widget.value;
      animate();
    }
  }

  void animate() {
    if (value == true) {
      frameColorController.forward();
      backgroundColorController.forward();
      fadeController.forward();
    } else {
      frameColorController.reverse();
      backgroundColorController.reverse();
      fadeController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
        setState(() {});
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: frameColorAnimation.value ?? Colors.transparent,
                    ),
                    borderRadius: BorderRadius.all(
                      radius,
                    ),
                    color: backgroundColorAnimation.value ?? Colors.transparent,
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: fadeAnimation.value ?? .0,
                      child: icon,
                    ),
                  ),
                ),
              ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}
