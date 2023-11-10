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
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: SideSwapColors.navyBlue)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  _assetIcon,
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
                      _title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _subTitle,
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
              _message,
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
      onTap: () {
        _onPressed.call();
      },
    );
  }
}
