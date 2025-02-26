import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';

class DToggleButton extends StatelessWidget {
  const DToggleButton({
    super.key,
    required this.offText,
    required this.onText,
    required this.value,
    this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String offText;
  final String onText;

  @override
  Widget build(BuildContext context) {
    final handleClick = onChanged != null ? () => onChanged!(!value) : null;
    final enabled = onChanged != null;
    const colorToggleBackground = SideSwapColors.prussianBlue;

    Color buttonColor(bool value) {
      if (enabled) {
        return value ? const Color(0xFF1F7EB1) : colorToggleBackground;
      }
      return value ? const Color(0x5F1F7EB1) : colorToggleBackground;
    }

    Color textColor(bool value) {
      if (enabled) {
        return value
            ? const Color(0xFFFFFFFF)
            : SideSwapColors.airSuperiorityBlue;
      }
      return value ? const Color(0x5FFFFFFF) : const Color(0x5FCCCCCC);
    }

    return Container(
      decoration: const BoxDecoration(
        color: colorToggleBackground,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SwapButton(
                  color: buttonColor(!value),
                  text: offText,
                  textColor: textColor(!value),
                  onPressed: handleClick,
                  textStyle: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(fontSize: 13),
                ),
              ),
              Expanded(
                child: SwapButton(
                  color: buttonColor(value),
                  text: onText,
                  textColor: textColor(value),
                  onPressed: handleClick,
                  textStyle: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(fontSize: 13),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
