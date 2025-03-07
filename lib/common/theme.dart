import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/button_styles.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/desktop/markets/widgets/order_row_element.dart';

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
    thickness: WidgetStatePropertyAll(3),
    radius: Radius.circular(2),
    thumbVisibility: WidgetStatePropertyAll(true),
    thumbColor: WidgetStatePropertyAll(SideSwapColors.ceruleanFrost),
    trackColor: WidgetStatePropertyAll(SideSwapColors.jellyBean),
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
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400, // normal
      fontFamily: 'Roboto',
      color: Colors.white,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      fontFamily: 'Roboto',
      color: Colors.white,
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
          side: const WidgetStatePropertyAll(
            BorderSide(color: SideSwapColors.brightTurquoise),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: SideSwapColors.brightTurquoise),
            ),
          ),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 16)),
        ),
      );

  /// Theme Extensions
  ///
  Iterable<ThemeExtension<dynamic>>? get themeExtensions {
    return [
      orderRowElementStyle(),
      coloredContainerStyle(),
      workingOrderItemCancelButtonStyle(),
      sideswapCancelButtonStyle(),
      sideswapOkButtonStyle(),
      marketAssetRowStyle(),
      marketColorsStyle(),
      customBackButtonStyle(),
    ];
  }

  CustomBackButtonStyle customBackButtonStyle() {
    return CustomBackButtonStyle.standard();
  }

  OrderRowElementStyle orderRowElementStyle() {
    return OrderRowElementStyle(
      padding: const EdgeInsets.only(left: 12, top: 12),
      textColor: SideSwapColors.cornFlower,
    );
  }

  MarketColorsStyle marketColorsStyle() {
    return MarketColorsStyle(
      sellColor: SideSwapColors.bitterSweet,
      buyColor: SideSwapColors.turquoise,
    );
  }

  ColoredContainerStyle coloredContainerStyle() {
    return ColoredContainerStyle(
      backgroundColor: SideSwapColors.navyBlue,
      borderColor: SideSwapColors.navyBlue,
      horizontalPadding: 12,
    );
  }

  WorkingOrderItemCancelButtonStyle workingOrderItemCancelButtonStyle() {
    return WorkingOrderItemCancelButtonStyle(
      style: TextButton.styleFrom(
        backgroundColor: SideSwapColors.blueSapphire,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  SideswapNoButtonStyle sideswapCancelButtonStyle() {
    return SideswapNoButtonStyle(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: EdgeInsets.zero,
        minimumSize: Size(100, 45),
      ),
    );
  }

  SideswapYesButtonStyle sideswapOkButtonStyle() {
    return SideswapYesButtonStyle(
      style: TextButton.styleFrom(
        backgroundColor: SideSwapColors.brightTurquoise,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: EdgeInsets.zero,
        minimumSize: Size(100, 45),
      ),
    );
  }

  MarketAssetRowStyle marketAssetRowStyle() {
    return MarketAssetRowStyle(
      labelStyle: textTheme.titleSmall?.copyWith(
        color: SideSwapColors.brightTurquoise,
      ),
      errorLabelStyle: textTheme.titleSmall?.copyWith(
        color: SideSwapColors.bitterSweet,
      ),
      amountStyle: textTheme.titleSmall,
      errorAmountStyle: textTheme.titleSmall?.copyWith(
        color: SideSwapColors.bitterSweet,
      ),
      tickerStyle: textTheme.titleSmall,
      errorTickerStyle: textTheme.titleSmall?.copyWith(
        color: SideSwapColors.bitterSweet,
      ),
      conversionStyle: textTheme.titleSmall?.copyWith(
        fontSize: 13,
        color: SideSwapColors.halfBaked,
      ),
    );
  }
}
