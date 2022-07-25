import 'package:flutter/material.dart';

final Map<int, Color> _customAppMaterialColor = {
  50: const Color.fromRGBO(19, 85, 121, .1),
  100: const Color.fromRGBO(19, 85, 121, .2),
  200: const Color.fromRGBO(19, 85, 121, .3),
  300: const Color.fromRGBO(19, 85, 121, .4),
  400: const Color.fromRGBO(19, 85, 121, .5),
  500: const Color.fromRGBO(19, 85, 121, .6),
  600: const Color.fromRGBO(19, 85, 121, .7),
  700: const Color.fromRGBO(19, 85, 121, .8),
  800: const Color.fromRGBO(19, 85, 121, .9),
  900: const Color.fromRGBO(19, 85, 121, 1),
};

final customAppColor = MaterialColor(0xFF135579, _customAppMaterialColor);

final appTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: customAppColor,
  scaffoldBackgroundColor: const Color(0xFF135579),
  textSelectionTheme: const TextSelectionThemeData(
    selectionHandleColor: Color(0xFFA8D6EA),
  ),
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontFamily: 'Corben',
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: Colors.black,
    ),
  ),
);

const mainDecoration = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF003E78), Color(0xFF000E3F)]));

const fontBigTitle = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w400,
  fontSize: 32,
);

const fontNormal = TextStyle(
  fontFamily: 'SF Pro Text',
  fontWeight: FontWeight.w400,
  fontSize: 16,
);

final fontNormalGray = fontNormal.merge(const TextStyle(color: Colors.grey));

const fontSwapAssetTicker = TextStyle(
  fontFamily: 'Roboto',
  color: Color(0xFFFFFFFF),
  fontWeight: FontWeight.w400,
  fontSize: 22,
);

const fontSwapAssetAmount = fontSwapAssetTicker;

const colorPanels = Color(0xFF003E78);
