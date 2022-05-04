import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';

class DToggleButton extends StatelessWidget {
  const DToggleButton({
    Key? key,
    required this.offText,
    required this.onText,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String offText;
  final String onText;

  final _colorToggleBackground = const Color(0xFF043857);
  final _colorToggleOn = const Color(0xFF1F7EB1);
  final _colorToggleTextOn = const Color(0xFFFFFFFF);
  final _colorToggleTextOff = const Color(0xFF709EBA);

  @override
  Widget build(BuildContext context) {
    final handleClick = onChanged != null ? () => onChanged!(!value) : null;
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
                  color: !value ? _colorToggleOn : _colorToggleBackground,
                  text: offText,
                  textColor: !value ? _colorToggleTextOn : _colorToggleTextOff,
                  onPressed: handleClick,
                ),
              ),
              Expanded(
                child: SwapButton(
                  color: value ? _colorToggleOn : _colorToggleBackground,
                  text: onText,
                  textColor: value ? _colorToggleTextOn : _colorToggleTextOff,
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
