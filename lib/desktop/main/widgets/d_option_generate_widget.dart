import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/theme.dart';

class DOptionGenerateWidget extends ConsumerWidget {
  const DOptionGenerateWidget({
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
  Widget build(BuildContext context, WidgetRef ref) {
    final bgColor = isSelected ? SideSwapColors.navyBlue : Colors.transparent;
    final accentColor =
        isSelected ? Colors.white : SideSwapColors.ceruleanFrost;
    return DCustomTextBigButton(
      width: 247,
      height: 270,
      onPressed: onPressed,
      style: ref
          .watch(desktopAppThemeProvider)
          .buttonThemeData
          .defaultButtonStyle
          ?.merge(
            DButtonStyle(
              padding: ButtonState.all(EdgeInsets.zero),
              border: ButtonState.all(BorderSide.none),
              shape: ButtonState.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
              backgroundColor: ButtonState.resolveWith((states) {
                if (states.isDisabled) {
                  return bgColor.lerpWith(Colors.black, 0.3);
                }
                if (states.isPressing) {
                  return bgColor.lerpWith(Colors.black, 0.2);
                }
                if (states.isHovering) {
                  return bgColor.lerpWith(Colors.black, 0.1);
                }
                return bgColor;
              }),
            ),
          ),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SvgPicture.asset(
              assetIcon,
              colorFilter: ColorFilter.mode(accentColor, BlendMode.srcIn),
              width: 44,
              height: 44,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: accentColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: accentColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Spacer(),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: accentColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
