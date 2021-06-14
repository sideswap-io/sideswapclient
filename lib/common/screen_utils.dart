import 'package:flutter_screenutil/flutter_screenutil.dart' hide SizeExtension;

class SideSwapScreenUtil {
  static double get screenHeight => ScreenUtil().screenHeight;
  static double get screenWidth => ScreenUtil().screenWidth;
  static double get screenHeightPx => ScreenUtil().screenHeight;
  static double get screenWidthPx => ScreenUtil().screenWidth;
}

extension DoubleSizeExtension on num {
  double get w => ScreenUtil().setWidth(this).toDouble();
  double get h => ScreenUtil().setHeight(this).toDouble();
  double get sp => ScreenUtil().setSp(this).toDouble();
  double get ssp => ScreenUtil().setSp(this).toDouble();
}
