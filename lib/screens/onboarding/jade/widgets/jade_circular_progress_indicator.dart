import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class JadeCircularProgressIndicator extends StatelessWidget {
  const JadeCircularProgressIndicator({super.key, this.showLogo = false});

  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              backgroundColor: SideSwapColors.chathamsBlue,
              color: SideSwapColors.brightTurquoise,
              strokeWidth: 2,
            ),
          ),
          ...switch (showLogo) {
            true => [
              Center(
                child: SvgPicture.asset(
                  'assets/jade.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
            _ => [const SizedBox()],
          },
        ],
      ),
    );
  }
}
