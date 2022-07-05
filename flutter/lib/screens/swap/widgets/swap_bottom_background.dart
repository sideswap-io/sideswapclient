import 'package:flutter/material.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/flavor_config.dart';

class SwapBottomBackground extends StatelessWidget {
  const SwapBottomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: FlavorConfig.isDesktop ? 234.h : 205.h),
      child: Container(
        color: const Color(0xFF1C6086),
      ),
    );
  }
}
