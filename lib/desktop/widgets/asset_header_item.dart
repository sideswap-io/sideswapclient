import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class AssetHeaderitem extends StatelessWidget {
  const AssetHeaderitem({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 12, color: SideSwapColors.cornFlower),
    );
  }
}
