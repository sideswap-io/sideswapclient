import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

final mobileAppThemeProvider =
    AutoDisposeStateProvider<MobileThemeData>((ref) => MobileThemeData(ref));

class MobileThemeData {
  final Ref ref;

  MobileThemeData(this.ref);

  ThemeData themeData() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: SideSwapColors.chathamsBlue,
        brightness: Brightness.dark,
        background: SideSwapColors.prussianBlue,
      ),
      scaffoldBackgroundColor: SideSwapColors.chathamsBlue,
      textSelectionTheme: textSelectionTheme(),
      textTheme: textTheme(),
      cardColor: SideSwapColors.blumine,
    );
  }

  TextSelectionThemeData textSelectionTheme() {
    return const TextSelectionThemeData(
      selectionHandleColor: SideSwapColors.regentStBlue,
    );
  }

  TextTheme textTheme({TextTheme? value}) {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Corben',
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: Colors.white,
        letterSpacing: 0.22,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
        color: Colors.white,
        height: 1.22,
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
        color: Colors.white,
      ),
    ).merge(value);
  }
}
