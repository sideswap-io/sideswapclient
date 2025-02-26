import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MaximizeListButton extends StatefulWidget {
  const MaximizeListButton({super.key, this.onPressed, required this.position});

  final VoidCallback? onPressed;
  final double position;

  @override
  MaximizeListButtonState createState() => MaximizeListButtonState();
}

class MaximizeListButtonState extends State<MaximizeListButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(48),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Transform(
              transform: Matrix4.rotationX(widget.position * pi),
              alignment: Alignment.center,
              child: Transform(
                transform: Matrix4.rotationX(pi),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/mini_button.svg',
                  width: 22,
                  height: 13,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
