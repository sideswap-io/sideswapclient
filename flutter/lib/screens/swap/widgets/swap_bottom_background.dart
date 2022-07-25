import 'package:flutter/material.dart';

class SwapBottomBackground extends StatelessWidget {
  const SwapBottomBackground({
    super.key,
    required this.middle,
  });

  final double middle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: middle),
      child: Container(
        color: const Color(0xFF1C6086),
      ),
    );
  }
}
