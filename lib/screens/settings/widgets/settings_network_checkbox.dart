import 'package:flutter/material.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_check_box.dart';

class SettingsNetworkCheckbox extends StatelessWidget {
  const SettingsNetworkCheckbox({
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
    return CustomCheckBox(
      size: 24.w,
      radius: Radius.circular(12.w),
      frameChecked: const Color(0xFF00C5FF),
      frameUnchecked: const Color(0xFF046C93),
      backgroundChecked: const Color(0xFF00C5FF),
      backgroundUnchecked: Colors.transparent,
      icon: Icon(
        Icons.check,
        size: 16.w,
      ),
      value: value,
      onChanged: onChanged,
      child: title,
    );
  }
}
