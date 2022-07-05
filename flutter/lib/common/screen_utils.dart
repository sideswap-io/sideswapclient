import 'package:flutter_screenutil/flutter_screenutil.dart' hide SizeExtension;
import 'package:sideswap/screens/flavor_config.dart';

import '../screens/flavor_config.dart';

class SideSwapScreenUtil {
  const SideSwapScreenUtil();
  static double get screenHeight => ScreenUtil().screenHeight;
  static double get screenWidth => ScreenUtil().screenWidth;
  static double get screenHeightPx => ScreenUtil().screenHeight;
  static double get screenWidthPx => ScreenUtil().screenWidth;
  static double get scaleWidth => ScreenUtil().scaleWidth;
  static double get scaleHeight => ScreenUtil().scaleHeight;
}

extension DoubleSizeExtension on num {
  double get w => FlavorConfig.isDesktop
      ? toDouble()
      : ScreenUtil().setWidth(this).toDouble();
  double get h => FlavorConfig.isDesktop
      ? toDouble()
      : ScreenUtil().setHeight(this).toDouble();
  double get sp =>
      FlavorConfig.isDesktop ? toDouble() : ScreenUtil().setSp(this).toDouble();
  double get ssp =>
      FlavorConfig.isDesktop ? toDouble() : ScreenUtil().setSp(this).toDouble();
  double get r =>
      FlavorConfig.isDesktop ? toDouble() : ScreenUtil().radius(this);
}
