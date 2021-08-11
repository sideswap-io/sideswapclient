import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sideswap/common/screen_utils.dart';

class MaximizeListButton extends StatefulWidget {
  const MaximizeListButton({
    Key? key,
    this.onPressed,
    required this.position,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final double position;

  @override
  _MaximizeListButtonState createState() => _MaximizeListButtonState();
}

class _MaximizeListButtonState extends State<MaximizeListButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(48.w),
        child: SizedBox(
          width: 48.w,
          height: 48.w,
          child: Center(
            child: Transform(
              transform: Matrix4.rotationX(widget.position * pi),
              alignment: Alignment.center,
              child: Transform(
                transform: Matrix4.rotationX(pi),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/mini_button.svg',
                  width: 22.w,
                  height: 13.h,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
