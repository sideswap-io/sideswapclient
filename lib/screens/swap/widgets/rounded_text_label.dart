import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class RoundedTextLabel extends StatelessWidget {
  const RoundedTextLabel({
    super.key,
    required this.text,
    this.color = SideSwapColors.regentStBlue,
    this.allRectRadius = false,
    this.height,
  });

  final String text;
  final Color color;
  final bool allRectRadius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        height: height ?? 26,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: allRectRadius ? const Radius.circular(16) : Radius.zero,
            topRight: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
            bottomLeft: const Radius.circular(12),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xFF05202F),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
