import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';

enum ResultPageType {
  success,
  error,
}

class ResultPage extends StatelessWidget {
  const ResultPage({
    super.key,
    this.header = '',
    this.description = '',
    this.descriptionWidget,
    this.buttonText = '',
    this.onPressed,
    required this.resultType,
    this.visibleSecondButton = false,
    this.secondButtonText = '',
    this.onSecondButtonPressed,
    this.topPadding,
    this.buttonBackgroundColor = SideSwapColors.brightTurquoise,
    this.buttonSide,
  });

  final String header;
  final String description;
  final Widget? descriptionWidget;
  final String buttonText;
  final Color buttonBackgroundColor;
  final BorderSide? buttonSide;
  final VoidCallback? onPressed;
  final ResultPageType resultType;
  final bool visibleSecondButton;
  final String secondButtonText;
  final VoidCallback? onSecondButtonPressed;
  final double? topPadding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: topPadding ?? 40),
            child: Container(
              width: 166,
              height: 166,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: resultType == ResultPageType.success
                      ? SideSwapColors.brightTurquoise
                      : SideSwapColors.bitterSweet,
                  style: BorderStyle.solid,
                  width: 6,
                ),
              ),
              child: Center(
                child: resultType == ResultPageType.success
                    ? SvgPicture.asset(
                        'assets/success.svg',
                        width: 51,
                        height: 51,
                        colorFilter: const ColorFilter.mode(
                            Color(0xFFCAF3FF), BlendMode.srcIn),
                      )
                    : SvgPicture.asset(
                        'assets/error.svg',
                        width: 51,
                        height: 51,
                        colorFilter: const ColorFilter.mode(
                            SideSwapColors.bitterSweet, BlendMode.srcIn),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Text(
              header,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: description.isNotEmpty
                ? Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  )
                : descriptionWidget ?? Container(),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: visibleSecondButton ? 0 : 40),
            child: CustomBigButton(
              width: double.infinity,
              height: 54,
              text: buttonText,
              backgroundColor: buttonBackgroundColor,
              side: buttonSide,
              onPressed: onPressed,
            ),
          ),
          Visibility(
            visible: visibleSecondButton,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 40),
              child: CustomBigButton(
                width: double.infinity,
                height: 54,
                text: secondButtonText,
                backgroundColor: Colors.transparent,
                onPressed: onSecondButtonPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
