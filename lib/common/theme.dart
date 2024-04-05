import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/sideswap_colors.dart';

part 'theme.g.dart';

@riverpod
class MobileAppThemeNotifier extends _$MobileAppThemeNotifier {
  @override
  MobileThemeData build() {
    return MobileThemeData(ref);
  }
}

class MobileThemeData {
  final Ref ref;

  MobileThemeData(this.ref);

  Color? _scaffoldBackgroundColor = Colors.transparent;
  Color? get scaffoldBackgroundColor => _scaffoldBackgroundColor;
  set scaffoldBackgroundColor(Color? value) {
    _scaffoldBackgroundColor = value;
    ref.notifyListeners();
  }

  ColorScheme _darkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: SideSwapColors.chathamsBlue,
    accentColor: SideSwapColors.brightTurquoise,
    cardColor: SideSwapColors.blumine,
    backgroundColor: SideSwapColors.prussianBlue,
    errorColor: SideSwapColors.bitterSweet,
    brightness: Brightness.dark,
  );

  ThemeMode _mode = ThemeMode.dark;
  ThemeMode get mode => _mode;
  set mode(ThemeMode mode) {
    _mode = mode;
    ref.notifyListeners();
  }

  ColorScheme get darkScheme => _darkColorScheme;
  set darkScheme(ColorScheme value) {
    _darkColorScheme = value;
    ref.notifyListeners();
  }

  Brightness _brightness = Brightness.dark;
  Brightness get brightness => _brightness;
  set brightness(Brightness value) {
    _brightness = value;
    ref.notifyListeners();
  }

  ScrollbarThemeData _scrollbarTheme = const ScrollbarThemeData(
    thickness: MaterialStatePropertyAll(3),
    radius: Radius.circular(2),
    thumbVisibility: MaterialStatePropertyAll(true),
    thumbColor: MaterialStatePropertyAll(SideSwapColors.ceruleanFrost),
    trackColor: MaterialStatePropertyAll(SideSwapColors.jellyBean),
  );

  ScrollbarThemeData get scrollbarTheme => _scrollbarTheme;
  set scrollbarTheme(ScrollbarThemeData value) {
    _scrollbarTheme = value;
    ref.notifyListeners();
  }

  TextSelectionThemeData _textSelectionTheme = const TextSelectionThemeData(
    selectionHandleColor: SideSwapColors.chathamsBlueDark,
    selectionColor: SideSwapColors.chathamsBlueDark,
    cursorColor: SideSwapColors.chathamsBlueDark,
  );

  TextSelectionThemeData get textSelectionTheme => _textSelectionTheme;
  set textSelectionTheme(TextSelectionThemeData value) {
    _textSelectionTheme = value;
    ref.notifyListeners();
  }

  TextTheme get textTheme => _darkTextTheme;
  set textTheme(TextTheme value) {
    textTheme = value;
    ref.notifyListeners();
  }

  TextTheme get _darkTextTheme => const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Corben',
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.normal,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
          color: Colors.white,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
          color: Colors.white,
        ),
      );

  TextButtonThemeData get textButtonTheme => _textButtonTheme;
  set textButtonTheme(TextButtonThemeData value) {
    _textButtonTheme = value;
    ref.notifyListeners();
  }

  TextButtonThemeData _textButtonTheme = const TextButtonThemeData();

  TextButtonThemeData firstLaunchNetworkSettingsButtonTheme =
      TextButtonThemeData(
    style: ButtonStyle(
      side: const MaterialStatePropertyAll(
        BorderSide(color: SideSwapColors.brightTurquoise),
      ),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: SideSwapColors.brightTurquoise),
        ),
      ),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
      textStyle: const MaterialStatePropertyAll(
        TextStyle(fontSize: 16),
      ),
    ),
  );
}
