import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({
    super.key,
    this.backgroundColor = SideSwapColors.prussianBlue,
    this.borderRadius = 8,
    this.width = 142,
    this.height = 35,
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

  final double width;
  final double height;
  final Color backgroundColor;
  final double borderRadius;
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
  SwitchButtonState createState() => SwitchButtonState();
}

class SwitchButtonState extends State<SwitchButton> {
  late double switchWidth = (widget.width - 3 * widget.borderWidth) / 2;
  late double switchHeight = widget.height - 2 * widget.borderWidth;
  bool enabled = true;

  @override
  void initState() {
    super.initState();
    enabled = widget.onToggle != null;
  }

  @override
  void didUpdateWidget(SwitchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.onToggle != widget.onToggle) {
      enabled = widget.onToggle != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultActiveTextStyle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: widget.fontSize ?? 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );

    final defaultInactiveTextStyle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: widget.fontSize ?? 14,
      fontWeight: FontWeight.w500,
      color: SideSwapColors.ceruleanFrost,
    );

    var activeTextStyle = (enabled
            ? widget.activeTextStyle
            : widget.activeTextStyle?.copyWith(
                color: widget.activeTextStyle?.color?.withOpacity(0.2))) ??
        (enabled
            ? defaultActiveTextStyle
            : defaultActiveTextStyle.copyWith(
                color: SideSwapColors.ceruleanFrost));

    return GestureDetector(
      onTap: () {
        if (enabled && widget.onToggle != null) {
          widget.onToggle!(!widget.value);
        }
      },
      child: Opacity(
        opacity: enabled ? 1 : 1,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              width: widget.borderWidth,
              color: widget.borderColor,
            ),
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            color: widget.backgroundColor,
          ),
          child: Row(
            children: [
              if (widget.value) ...[
                widget.inactiveToggle ??
                    SwithButtonInactiveToggle(
                      switchWidth: switchWidth,
                      switchHeight: switchHeight,
                      inactiveToggleBackground: widget.inactiveToggleBackground,
                      activeText: widget.activeText,
                      inactiveText: widget.inactiveText,
                      switchValue: widget.value,
                      inactiveTextStyle:
                          widget.inactiveTextStyle ?? defaultInactiveTextStyle,
                    ),
                const Spacer(),
                widget.activeToggle ??
                    SwitchButtonActiveToggle(
                      switchWidth: switchWidth,
                      switchHeight: switchHeight,
                      borderRadius: widget.borderRadius,
                      borderWidth: widget.borderWidth,
                      enabled: enabled,
                      activeText: widget.activeText,
                      inactiveText: widget.inactiveText,
                      switchValue: widget.value,
                      activeToggleBackground: widget.activeToggleBackground,
                      activeTextStyle: activeTextStyle,
                    ),
              ] else ...[
                widget.activeToggle ??
                    SwitchButtonActiveToggle(
                      switchWidth: switchWidth,
                      switchHeight: switchHeight,
                      borderRadius: widget.borderRadius,
                      borderWidth: widget.borderWidth,
                      enabled: enabled,
                      activeText: widget.activeText,
                      inactiveText: widget.inactiveText,
                      switchValue: widget.value,
                      activeToggleBackground: widget.activeToggleBackground,
                      activeTextStyle: activeTextStyle,
                    ),
                const Spacer(),
                widget.inactiveToggle ??
                    SwithButtonInactiveToggle(
                      switchWidth: switchWidth,
                      switchHeight: switchHeight,
                      inactiveToggleBackground: widget.inactiveToggleBackground,
                      activeText: widget.activeText,
                      inactiveText: widget.inactiveText,
                      switchValue: widget.value,
                      inactiveTextStyle:
                          widget.inactiveTextStyle ?? defaultInactiveTextStyle,
                    ),
              ]
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
    required this.switchWidth,
    required this.switchHeight,
    required this.borderRadius,
    required this.borderWidth,
    required this.enabled,
    required this.activeText,
    required this.inactiveText,
    required this.switchValue,
    required this.activeToggleBackground,
    this.activeTextStyle,
  });

  final double switchWidth;
  final double switchHeight;
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
        borderRadius:
            BorderRadius.all(Radius.circular(borderRadius - borderWidth)),
        color: enabled
            ? activeToggleBackground
            : SideSwapColors.navyBlue.withOpacity(0.2),
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
    required this.switchWidth,
    required this.switchHeight,
    required this.inactiveToggleBackground,
    required this.activeText,
    required this.inactiveText,
    required this.switchValue,
    this.inactiveTextStyle,
  });

  final double switchWidth;
  final double switchHeight;
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
