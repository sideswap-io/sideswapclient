import 'package:flutter/material.dart';

extension MultiThemeColorExtension on ThemeData {
  Color get background => Color(0x30000000);

  Color get grayColor => Color(0xFFFFFFFF);
  Color get volumeColor => Color(0xFF00c5ff);
  Color get linesColor => Color(0xFF2B6F95);

  Color get primaryGreen => Color(0xFF2ee6d4);
  Color get primaryRed => Color(0xFFff6562);
  Color get secondaryGreen => Color(0xFF00c5ff);
  Color get secondaryRed => Color(0xFF00c5ff);

  Color get hoverIndicatorBackgroundColor => Color(0xFF4C525E);
  Color get digalogColor => Color(0xFF23282D);
  Color get lightGold => Color(0xFF494537);
  Color get gold => Color(0xFFF0B90A);
  Color get hoverIndicatorTextColor => Color(0xFFFFFFFF);
  Color get scaleNumbersColor => Color(0xFF848E9C);
  Color get currentPriceColor => Color(0xFF000000);
}
