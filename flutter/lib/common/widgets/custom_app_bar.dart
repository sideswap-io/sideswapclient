import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onPressed;
  final Color? backButtonColor;
  final PreferredSizeWidget? bottom;
  final double toolbarHeight;
  final Color backgroundColor;
  final bool showTrailingButton;
  final VoidCallback? onTrailingButtonPressed;
  final Widget? trailingWidget;

  const CustomAppBar({
    super.key,
    this.title,
    this.onPressed,
    this.backButtonColor,
    this.bottom,
    this.toolbarHeight = kToolbarHeight,
    this.backgroundColor = Colors.transparent,
    this.showTrailingButton = false,
    this.onTrailingButtonPressed,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      centerTitle: false,
      automaticallyImplyLeading: false,
      flexibleSpace: title != null
          ? SafeArea(
              child: SizedBox(
                height: preferredSize.height,
                child: Stack(
                  children: [
                    if (showTrailingButton) ...[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: trailingWidget != null ? 10.w : 22.w,
                          ),
                          child: trailingWidget != null
                              ? Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(42.w),
                                  child: InkWell(
                                    onTap: onTrailingButtonPressed,
                                    borderRadius: BorderRadius.circular(42.w),
                                    child: Container(
                                      width: 48.w,
                                      height: 48.w,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: trailingWidget,
                                      ),
                                    ),
                                  ),
                                )
                              : CustomBackButton(
                                  width: 18.w,
                                  height: 18.w,
                                  buttonType: CustomBackButtonType.close,
                                  color: backButtonColor ?? Colors.white,
                                  onPressed: onTrailingButtonPressed,
                                ),
                        ),
                      ),
                    ],
                    SafeArea(
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
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
                ),
              ),
            )
          : null,
      leading: CustomBackButton(
        onPressed: onPressed,
        color: backButtonColor ?? Colors.white,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
