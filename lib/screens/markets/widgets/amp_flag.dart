import 'package:flutter/widgets.dart';

class AmpFlag extends StatelessWidget {
  const AmpFlag({
    super.key,
    this.width = 39,
    this.height = 20,
    this.decoration,
    this.margin = const EdgeInsets.only(left: 8),
    this.padding = const EdgeInsets.all(0),
    this.textStyle = const TextStyle(
      color: Color(0xFF73A6C5),
      fontSize: 12,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
    ),
  });

  final double? width;
  final double? height;
  final Decoration? decoration;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: decoration ??
          ShapeDecoration(
            color: const Color(0x664893BC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'AMP',
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
