import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';

class DTextIconContainer extends StatelessWidget {
  const DTextIconContainer({
    super.key,
    this.text,
    this.onPressed,
    this.trailingIcon,
  });

  final String? text;
  final VoidCallback? onPressed;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        color: SideSwapColors.chathamsBlue,
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: switch (text) {
              final text? => Text(text),
              _ => const SizedBox(),
            },
          ),
          const SizedBox(width: 8),
          switch (trailingIcon) {
            final trailingIcon? => trailingIcon,
            _ => DIconButton(
                icon: const Icon(
                  Icons.close,
                  color: SideSwapColors.freshAir,
                  size: 18,
                ),
                onPressed: onPressed,
              ),
          },
        ],
      ),
    );
  }
}
