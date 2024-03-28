import 'package:flutter/material.dart';

extension MultiThemeColorExtension on ThemeData {
  Color get background => const Color(0x30000000);

  Color get grayColor => const Color(0xFFFFFFFF);
  Color get volumeColor => const Color(0xFF00c5ff);
  Color get linesColor => const Color(0xFF2B6F95);

  Color get primaryGreen => const Color(0xFF2ee6d4);
  Color get primaryRed => const Color(0xFFff6562);
  Color get secondaryGreen => const Color(0xFF00c5ff);
  Color get secondaryRed => const Color(0xFF00c5ff);

  Color get hoverIndicatorBackgroundColor => const Color(0xFF4C525E);
  Color get digalogColor => const Color(0xFF23282D);
  Color get lightGold => const Color(0xFF494537);
  Color get gold => const Color(0xFFF0B90A);
  Color get hoverIndicatorTextColor => const Color(0xFFFFFFFF);
  Color get scaleNumbersColor => const Color(0xFF848E9C);
  Color get currentPriceColor => const Color(0xFF000000);
}
