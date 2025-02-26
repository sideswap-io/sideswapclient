import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_check_box_row.dart';

class SettingsCheckbox extends StatelessWidget {
  const SettingsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return CustomCheckBoxRow(
      size: 24,
      radius: const Radius.circular(12),
      frameChecked: SideSwapColors.brightTurquoise,
      frameUnchecked: const Color(0xFF046C93),
      backgroundChecked: SideSwapColors.brightTurquoise,
      backgroundUnchecked: Colors.transparent,
      icon: const Icon(Icons.check, size: 16),
      value: value,
      onChanged: onChanged,
      child: title,
    );
  }
}
