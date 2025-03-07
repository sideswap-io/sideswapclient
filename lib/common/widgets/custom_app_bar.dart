import 'package:flutter/material.dart';

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
      flexibleSpace: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title ?? '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      actions: [
        ...switch (showTrailingButton) {
          true => [trailingWidget ?? SizedBox()],
          _ => [const SizedBox()],
        },
      ],
      leading: CustomBackButton(
        icon: Icons.arrow_back_ios,
        onPressed: onPressed,
        style: Theme.of(
          context,
        ).extension<CustomBackButtonStyle>()!.copyWith(color: backButtonColor),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
