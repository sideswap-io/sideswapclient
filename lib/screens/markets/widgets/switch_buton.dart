import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class SwitchButton extends HookConsumerWidget {
  const SwitchButton({
    super.key,
    this.backgroundColor = SideSwapColors.prussianBlue,
    this.borderRadius = 8,
    this.buttonBorderRadius = 6,
    this.width,
    this.height,
    required this.value,
    this.onToggle,
    this.borderColor = SideSwapColors.prussianBlue,
    this.borderWidth = 2,
    this.activeToggle,
    this.inactiveToggle,
    this.activeToggleBackground = SideSwapColors.navyBlue,
    this.inactiveToggleBackground = SideSwapColors.prussianBlue,
    this.activeText = '',
    this.inactiveText = '',
    this.activeTextStyle,
    this.inactiveTextStyle,
    this.fontSize,
  });

  final double? width;
  final double? height;
  final Color backgroundColor;
  final double borderRadius;
  final double buttonBorderRadius;
  final bool value;
  final void Function(bool)? onToggle;
  final Color borderColor;
  final double borderWidth;
  final Widget? activeToggle;
  final Widget? inactiveToggle;
  final Color activeToggleBackground;
  final Color inactiveToggleBackground;
  final String activeText;
  final String inactiveText;
  final TextStyle? activeTextStyle;
  final TextStyle? inactiveTextStyle;
  final double? fontSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = onToggle != null;

    final defaultActiveTextStyle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: fontSize ?? 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );

    final defaultInactiveTextStyle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: fontSize ?? 14,
      fontWeight: FontWeight.w500,
      color: SideSwapColors.ceruleanFrost,
    );

    final internalActiveTextStyle =
        (enabled
            ? activeTextStyle
            : activeTextStyle?.copyWith(
              color: activeTextStyle?.color?.withValues(alpha: 0.2),
            )) ??
        (enabled
            ? defaultActiveTextStyle
            : defaultActiveTextStyle.copyWith(
              color: SideSwapColors.ceruleanFrost,
            ));

    final switchWidth = width == null ? null : (width! / 2) - borderWidth;
    final switchHeight = height == null ? null : height! - borderWidth;

    return GestureDetector(
      onTap: () {
        if (enabled && onToggle != null) {
          onToggle!(!value);
        }
      },
      child: Opacity(
        opacity: enabled ? 1 : 1,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: borderWidth, color: borderColor),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            color: backgroundColor,
          ),
          child: Row(
            children: [
              if (value) ...[
                Flexible(
                  child:
                      inactiveToggle ??
                      SwithButtonInactiveToggle(
                        switchWidth: switchWidth,
                        switchHeight: switchHeight,
                        inactiveToggleBackground: inactiveToggleBackground,
                        activeText: activeText,
                        inactiveText: inactiveText,
                        switchValue: value,
                        inactiveTextStyle:
                            inactiveTextStyle ?? defaultInactiveTextStyle,
                      ),
                ),
                Flexible(
                  child:
                      activeToggle ??
                      SwitchButtonActiveToggle(
                        switchWidth: switchWidth,
                        switchHeight: switchHeight,
                        borderRadius: buttonBorderRadius,
                        borderWidth: borderWidth,
                        enabled: enabled,
                        activeText: activeText,
                        inactiveText: inactiveText,
                        switchValue: value,
                        activeToggleBackground: activeToggleBackground,
                        activeTextStyle: internalActiveTextStyle,
                      ),
                ),
              ] else ...[
                Flexible(
                  child:
                      activeToggle ??
                      SwitchButtonActiveToggle(
                        switchWidth: switchWidth,
                        switchHeight: switchHeight,
                        borderRadius: buttonBorderRadius,
                        borderWidth: borderWidth,
                        enabled: enabled,
                        activeText: activeText,
                        inactiveText: inactiveText,
                        switchValue: value,
                        activeToggleBackground: activeToggleBackground,
                        activeTextStyle: internalActiveTextStyle,
                      ),
                ),
                Flexible(
                  child:
                      inactiveToggle ??
                      SwithButtonInactiveToggle(
                        switchWidth: switchWidth,
                        switchHeight: switchHeight,
                        inactiveToggleBackground: inactiveToggleBackground,
                        activeText: activeText,
                        inactiveText: inactiveText,
                        switchValue: value,
                        inactiveTextStyle:
                            inactiveTextStyle ?? defaultInactiveTextStyle,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SwitchButtonActiveToggle extends StatelessWidget {
  const SwitchButtonActiveToggle({
    super.key,
    this.switchWidth,
    this.switchHeight,
    required this.borderRadius,
    required this.borderWidth,
    required this.enabled,
    required this.activeText,
    required this.inactiveText,
    required this.switchValue,
    required this.activeToggleBackground,
    this.activeTextStyle,
  });

  final double? switchWidth;
  final double? switchHeight;
  final double borderRadius;
  final double borderWidth;
  final bool enabled;
  final String activeText;
  final String inactiveText;
  final bool switchValue;
  final Color activeToggleBackground;
  final TextStyle? activeTextStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: switchWidth,
      height: switchHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius - borderWidth),
        ),
        color:
            enabled
                ? activeToggleBackground
                : SideSwapColors.navyBlue.withValues(alpha: 0.2),
      ),
      child: Center(
        child: Text(
          switchValue ? activeText : inactiveText,
          style: activeTextStyle,
        ),
      ),
    );
  }
}

class SwithButtonInactiveToggle extends StatelessWidget {
  const SwithButtonInactiveToggle({
    super.key,
    this.switchWidth,
    this.switchHeight,
    required this.inactiveToggleBackground,
    required this.activeText,
    required this.inactiveText,
    required this.switchValue,
    this.inactiveTextStyle,
  });

  final double? switchWidth;
  final double? switchHeight;
  final Color inactiveToggleBackground;
  final String activeText;
  final String inactiveText;
  final bool switchValue;
  final TextStyle? inactiveTextStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: switchWidth,
      height: switchHeight,
      color: inactiveToggleBackground,
      child: Center(
        child: Text(
          switchValue ? inactiveText : activeText,
          style: inactiveTextStyle,
        ),
      ),
    );
  }
}
