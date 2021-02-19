import 'package:flutter/material.dart';
import 'package:sideswap/common/screen_utils.dart';

final Map<int, Color> _customAppMaterialColor = {
  50: Color.fromRGBO(19, 85, 121, .1),
  100: Color.fromRGBO(19, 85, 121, .2),
  200: Color.fromRGBO(19, 85, 121, .3),
  300: Color.fromRGBO(19, 85, 121, .4),
  400: Color.fromRGBO(19, 85, 121, .5),
  500: Color.fromRGBO(19, 85, 121, .6),
  600: Color.fromRGBO(19, 85, 121, .7),
  700: Color.fromRGBO(19, 85, 121, .8),
  800: Color.fromRGBO(19, 85, 121, .9),
  900: Color.fromRGBO(19, 85, 121, 1),
};

final customAppColor = MaterialColor(0xFF135579, _customAppMaterialColor);

final appTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: customAppColor,
  scaffoldBackgroundColor: Color(0xFF135579),
  textSelectionTheme: TextSelectionThemeData(
    selectionHandleColor: Color(0xFFA8D6EA),
  ),
  textTheme: TextTheme(
    headline1: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: Colors.black,
    ),
  ),
);

final mainDecoration = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF003E78), Color(0xFF000E3F)]));

final fontBigTitle = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w400,
  fontSize: 32,
);

final fontNormal = TextStyle(
  fontFamily: 'SF Pro Text',
  fontWeight: FontWeight.w400,
  fontSize: 16,
);

final fontNormalGray = fontNormal.merge(TextStyle(color: Colors.grey));

final fontSwapAssetTicker = TextStyle(
  fontFamily: 'Roboto',
  color: Color(0xFFFFFFFF),
  fontWeight: FontWeight.w400,
  fontSize: 22.w,
);

final fontSwapAssetAmount = fontSwapAssetTicker;

final colorPanels = Color(0xFF003E78);
