import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

  final _colorToggleBackground = const Color(0xFF043857);

  @override
  Widget build(BuildContext context) {
    final handleClick = onChanged != null ? () => onChanged!(!value) : null;
    final enabled = onChanged != null;

    Color buttonColor(bool value) {
      if (enabled) {
        return value ? const Color(0xFF1F7EB1) : _colorToggleBackground;
      }
      return value ? const Color(0x5F1F7EB1) : _colorToggleBackground;
    }

    Color textColor(bool value) {
      if (enabled) {
        return value ? const Color(0xFFFFFFFF) : const Color(0xFF709EBA);
      }
      return value ? const Color(0x5FFFFFFF) : const Color(0x5FCCCCCC);
    }

    return Container(
      decoration: BoxDecoration(
        color: _colorToggleBackground,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                ),
              ),
              Expanded(
                child: SwapButton(
                  color: buttonColor(value),
                  text: onText,
                  textColor: textColor(value),
                  onPressed: handleClick,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
