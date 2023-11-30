import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class OptionGenerateWidget extends StatelessWidget {
  const OptionGenerateWidget({
    super.key,
    required this.isSelected,
    required this.assetIcon,
    required this.title,
    required this.subTitle,
    required this.message,
    this.onPressed,
  });

  final bool isSelected;
  final String assetIcon;
  final String title;
  final String subTitle;
  final String message;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? SideSwapColors.navyBlue : Colors.transparent;
    final accentColor =
        isSelected ? Colors.white : SideSwapColors.ceruleanFrost;
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            width: 1.0,
            style: BorderStyle.solid,
            color: SideSwapColors.navyBlue,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  assetIcon,
                  colorFilter: ColorFilter.mode(accentColor, BlendMode.srcIn),
                  width: 44,
                  height: 44,
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text(
              message,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: accentColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
