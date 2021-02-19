import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/screen_utils.dart';

class MaximizeListButton extends StatefulWidget {
  MaximizeListButton({
    Key key,
    @required this.isExpanded,
    this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;
  final bool isExpanded;

  @override
  _MaximizeListButtonState createState() => _MaximizeListButtonState();
}

class _MaximizeListButtonState extends State<MaximizeListButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.w,
      height: 13.h,
      child: FlatButton(
        onPressed: widget.onPressed,
        padding: EdgeInsets.zero,
        child: Transform(
          transform: Matrix4.rotationX((widget.isExpanded ? 0 : -2) * pi / 2),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/mini_button.svg',
            width: 22.w,
            height: 13.h,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
