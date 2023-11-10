import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';

class MakeOrderButton extends StatelessWidget {
  const MakeOrderButton({
    super.key,
    required this.isSell,
    this.onPressed,
  });

  final bool isSell;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = isSell ? sellColor : buyColor;
    return DCustomFilledBigButton(
      width: 344,
      height: 44,
      onPressed: onPressed,
      style: DButtonStyle(
        padding: ButtonState.all(EdgeInsets.zero),
        textStyle: ButtonState.all(
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ButtonState.resolveWith((states) {
          if (states.isDisabled) {
            return color.lerpWith(Colors.black, 0.3);
          }
          if (states.isPressing) {
            return color.lerpWith(Colors.black, 0.2);
          }
          if (states.isHovering) {
            return color.lerpWith(Colors.black, 0.1);
          }
          return color;
        }),
        foregroundColor: ButtonState.resolveWith(
          (states) {
            if (states.isDisabled) {
              return Colors.white.lerpWith(Colors.black, 0.3);
            }
            return Colors.white;
          },
        ),
        shape: ButtonState.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
        border: ButtonState.resolveWith((states) {
          return const BorderSide(color: Colors.transparent, width: 1);
        }),
      ),
      child: Text(
        'Continue'.tr().toUpperCase(),
      ),
    );
  }
}
