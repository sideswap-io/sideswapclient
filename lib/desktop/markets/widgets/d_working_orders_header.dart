import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class DWorkingOrdersHeader extends StatelessWidget {
  const DWorkingOrdersHeader({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: SideSwapColors.cornFlower, fontSize: 12),
    );
  }
}
