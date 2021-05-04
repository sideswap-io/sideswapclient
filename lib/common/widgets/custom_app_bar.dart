import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final VoidCallback onPressed;
  final Color backButtonColor;
  final PreferredSizeWidget bottom;
  final double toolbarHeight;
  final Color backgroundColor;
  final bool rightCloseButton;
  final VoidCallback onRightCloseButtonPressed;

  CustomAppBar({
    this.title,
    this.onPressed,
    this.backButtonColor,
    this.bottom,
    this.toolbarHeight = 50,
    this.backgroundColor = Colors.transparent,
    this.rightCloseButton = false,
    this.onRightCloseButtonPressed,
  }) : preferredSize = Size.fromHeight(
            toolbarHeight + (bottom?.preferredSize?.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      centerTitle: false,
      automaticallyImplyLeading: false,
      flexibleSpace: title != null
          ? Stack(
              children: [
                if (rightCloseButton) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 4.h + MediaQuery.of(context).padding.top,
                          right: 22.w),
                      child: CustomBackButton(
                        width: 18.w,
                        height: 18.w,
                        buttonType: CustomBackButtonType.close,
                        color: backButtonColor,
                        onPressed: onRightCloseButtonPressed,
                      ),
                    ),
                  ),
                ],
                SafeArea(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 260.w,
                      child: Text(
                        title ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
      leading: CustomBackButton(
        onPressed: onPressed,
        color: backButtonColor,
      ),
    );
  }

  @override
  final Size preferredSize;
}
