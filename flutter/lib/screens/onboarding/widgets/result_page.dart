import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';
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
    this.buttonBackgroundColor = const Color(0xFF00C5FF),
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
            padding: EdgeInsets.only(top: topPadding ?? 100.h),
            child: Container(
              width: 166.w,
              height: 166.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: resultType == ResultPageType.success
                      ? const Color(0xFF00C5FF)
                      : const Color(0xFFFF7878),
                  style: BorderStyle.solid,
                  width: 6,
                ),
              ),
              child: Center(
                child: resultType == ResultPageType.success
                    ? SvgPicture.asset(
                        'assets/success.svg',
                        width: 51.w,
                        height: 51.w,
                        color: const Color(0xFFCAF3FF),
                      )
                    : SvgPicture.asset(
                        'assets/error.svg',
                        width: 51.w,
                        height: 51.w,
                        color: const Color(0xFFFF7878),
                      ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 32.h),
            child: Text(
              header,
              style: GoogleFonts.roboto(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: description.isNotEmpty
                ? Text(
                    description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  )
                : descriptionWidget ?? Container(),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: visibleSecondButton ? 0 : 40.h),
            child: CustomBigButton(
              width: double.infinity,
              height: 54.h,
              text: buttonText,
              backgroundColor: buttonBackgroundColor,
              side: buttonSide,
              onPressed: onPressed,
            ),
          ),
          Visibility(
            visible: visibleSecondButton,
            child: Padding(
              padding: EdgeInsets.only(top: 16.h, bottom: 40.h),
              child: CustomBigButton(
                width: double.infinity,
                height: 54.h,
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
