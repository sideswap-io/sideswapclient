import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class OptionGenerateWidget extends StatelessWidget {
  const OptionGenerateWidget(
      {super.key,
      required bool isSelected,
      required String assetIcon,
      required String title,
      required String subTitle,
      required String message,
      required VoidCallback onPressed})
      : _isSelected = isSelected,
        _assetIcon = assetIcon,
        _title = title,
        _subTitle = subTitle,
        _message = message,
        _onPressed = onPressed;

  final bool _isSelected;
  final String _assetIcon;
  final String _title;
  final String _subTitle;
  final String _message;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    final bgColor = _isSelected ? SideSwapColors.navyBlue : Colors.transparent;
    final accentColor =
    _isSelected ? Colors.white : SideSwapColors.ceruleanFrost;
    return Expanded(
        child: InkWell(
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: bgColor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  _assetIcon,
                  colorFilter: ColorFilter.mode(accentColor, BlendMode.srcIn),
                  width: 44,
                  height: 44,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  _subTitle,
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
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          onTap: () => _onPressed.call(),
        ));
  }
}
