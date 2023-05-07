import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class AmpIdPanel extends StatelessWidget {
  const AmpIdPanel({
    super.key,
    required this.ampId,
    this.backgroundColor = SideSwapColors.blumine,
    this.icon,
    this.border,
    this.prefixTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    this.ampIdTextStyle = const TextStyle(
      fontSize: 14,
    ),
    this.width = 360,
    this.height = 36,
    this.onTap,
    this.copyIconWidth = 20,
    this.copyIconHeight = 20,
  });

  final double? width;
  final double? height;
  final String ampId;
  final Color backgroundColor;
  final Widget? icon;
  final BoxBorder? border;
  final TextStyle? prefixTextStyle;
  final TextStyle? ampIdTextStyle;
  final VoidCallback? onTap;
  final double copyIconWidth;
  final double copyIconHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: border,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 6),
          MouseRegion(
            cursor:
                onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                'AMP ID:',
                style: prefixTextStyle,
              ),
            ),
          ),
          const SizedBox(width: 8),
          MouseRegion(
            cursor:
                onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                ampId,
                style: ampIdTextStyle,
              ),
            ),
          ),
          if (icon == null) ...[
            const Spacer(),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                await copyToClipboard(
                  context,
                  ampId,
                );
              },
              icon: SvgPicture.asset(
                'assets/copy2.svg',
                width: copyIconWidth,
                height: copyIconHeight,
              ),
            )
          ] else ...[
            icon!,
          ]
        ],
      ),
    );
  }
}
