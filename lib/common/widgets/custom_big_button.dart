import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';

class CustomBigButton extends StatelessWidget {
  CustomBigButton({
    Key key,
    this.text,
    this.onPressed,
    this.icon,
    this.width,
    this.height,
    this.backgroundColor,
    this.enabled = true,
    this.textStyle,
    this.buttonStyle,
    this.textColor,
    OutlinedBorder shape,
  })  : shape = shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.w),
              ),
            ),
        super(key: key);

  final String text;
  final VoidCallback onPressed;
  final Widget icon;
  final double width;
  final double height;
  final Color backgroundColor;
  final bool enabled;
  final TextStyle textStyle;
  final ButtonStyle buttonStyle;
  final Color textColor;
  final OutlinedBorder shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 60.w,
      height: height ?? 54.w,
      child: TextButton(
        child: Stack(
          children: [
            if (text != null) ...[
              Align(
                alignment:
                    icon != null ? Alignment.centerLeft : Alignment.center,
                child: Padding(
                  padding: icon != null
                      ? EdgeInsets.only(left: 16.w)
                      : EdgeInsets.zero,
                  child: Text(
                    text ?? '',
                    overflow: TextOverflow.fade,
                    style: textStyle ??
                        GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ],
            if (icon != null) ...[
              Align(
                alignment:
                    text != null ? Alignment.centerRight : Alignment.center,
                child: Padding(
                  padding: text != null
                      ? EdgeInsets.only(right: 16.w)
                      : EdgeInsets.zero,
                  child: Opacity(
                    opacity: enabled ? 1.0 : 0.5,
                    child: icon,
                  ),
                ),
              ),
            ],
          ],
        ),
        onPressed: enabled ? onPressed : null,
        style: buttonStyle ??
            TextButton.styleFrom(
              primary: enabled
                  ? textColor ?? Colors.white
                  : textColor?.withOpacity(0.5) ??
                      Colors.white.withOpacity(0.5),
              backgroundColor: enabled
                  ? backgroundColor ?? const Color(0xFF2A6D92)
                  : backgroundColor == Colors.transparent
                      ? Colors.transparent
                      : backgroundColor?.withOpacity(0.5) ??
                          const Color(0xFF2A6D92).withOpacity(0.5),
              shape: shape,
            ),
      ),
    );
  }
}
