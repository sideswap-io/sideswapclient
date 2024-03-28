import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_radio_button.dart';
import 'package:sideswap/desktop/common/button/d_toggle_switch_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/common/d_focus.dart';
import 'package:sideswap/desktop/common/d_typography.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';

part 'theme.g.dart';

bool is10footScreen([double? width]) {
  width ??= WidgetsBinding
          .instance.platformDispatcher.implicitView?.physicalSize.width ??
      0;
  return width >= 11520;
}

extension BrightnessExtension on Brightness {
  bool get isLight => this == Brightness.light;
  bool get isDark => this == Brightness.dark;

  Brightness get opposite => isLight ? Brightness.dark : Brightness.light;
}

enum NavigationIndicators { sticky, end }

@riverpod
class DesktopAppThemeNotifier extends _$DesktopAppThemeNotifier {
  @override
  DesktopAppTheme build() {
    return DesktopAppTheme(ref);
  }
}

class DesktopAppTheme {
  final Ref ref;

  DesktopAppTheme(this.ref);

  ColorScheme _darkScheme = darkColorScheme;
  ColorScheme get darkScheme => _darkScheme;
  set darkScheme(ColorScheme value) {
    _darkScheme = value;
    ref.notifyListeners();
  }

  Duration _fasterAnimationDuration = const Duration(milliseconds: 83);
  Duration get fasterAnimationDuration => _fasterAnimationDuration;
  set fasterAnimationDuration(Duration value) {
    _fasterAnimationDuration = value;
    ref.notifyListeners();
  }

  Duration _fastAnimationDuration = const Duration(milliseconds: 167);
  Duration get fastAnimationDuration => _fastAnimationDuration;
  set fastAnimationDuration(Duration value) {
    _fastAnimationDuration = value;
    ref.notifyListeners();
  }

  Duration _mediumAnimationDuration = const Duration(milliseconds: 250);
  Duration get mediumAnimationDuration => _mediumAnimationDuration;
  set mediumAnimationDuration(Duration value) {
    _mediumAnimationDuration = value;
    ref.notifyListeners();
  }

  Duration _slowAnimationDuration = const Duration(milliseconds: 358);
  Duration get slowAnimationDuration => _slowAnimationDuration;
  set slowAnimationDuration(Duration value) {
    _slowAnimationDuration = value;
    ref.notifyListeners();
  }

  Curve _animationCurve = Curves.easeInOut;
  Curve get animationCurve => _animationCurve;
  set animationCurve(Curve value) {
    _animationCurve = value;
    ref.notifyListeners();
  }

  ThemeMode _mode = ThemeMode.dark;
  ThemeMode get mode => _mode;
  set mode(ThemeMode mode) {
    _mode = mode;
    ref.notifyListeners();
  }

  TextDirection _textDirection = TextDirection.ltr;
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection direction) {
    _textDirection = direction;
    ref.notifyListeners();
  }

  Color? _scaffoldBackgroundColor = Colors.transparent;
  Color? get scaffoldBackgroundColor => _scaffoldBackgroundColor;
  set scaffoldBackgroundColor(Color? value) {
    _scaffoldBackgroundColor = value;
    ref.notifyListeners();
  }

  VisualDensity? _visualDensity = VisualDensity.adaptivePlatformDensity;
  VisualDensity? get visualDensity => _visualDensity;
  set visualDensity(VisualDensity? value) {
    _visualDensity = value;
    ref.notifyListeners();
  }

  DTypography _typography =
      DTypography.standard(brightness: Brightness.light, color: Colors.white);
  DTypography get typography => _typography;
  set typography(DTypography value) {
    _typography = value;
    ref.notifyListeners();
  }

  String? _fontFamily = 'Roboto';
  String? get fontFamily => _fontFamily;
  set fontFamily(String? value) {
    _fontFamily = value;
    ref.notifyListeners();
  }

  DFocusThemeData _focusThemeData = DFocusThemeData(
    glowColor: Colors.transparent,
    glowFactor: is10footScreen() ? 2.0 : 0.0,
    primaryBorder:
        const BorderSide(width: 1, color: SideSwapColors.brightTurquoise),
    secondaryBorder: BorderSide.none,
    renderOutside: false,
  );
  DFocusThemeData get focusThemeData => _focusThemeData;
  set focusThemeData(DFocusThemeData value) {
    _focusThemeData = value;
    ref.notifyListeners();
  }

  Color? _menuColor = SideSwapColors.chathamsBlue;
  Color? get menuColor => _menuColor;
  set menuColor(Color? value) {
    _menuColor = value;
    ref.notifyListeners();
  }

  Color? _shadowColor = Colors.transparent;
  Color? get shadowColor => _shadowColor;
  set shadowColor(Color? value) {
    _shadowColor = value;
    ref.notifyListeners();
  }

  Color? _micaBackgroundColor = const Color(0xFF1E6389);
  Color? get micaBackgroundColor => _micaBackgroundColor;
  set micaBackgroundColor(Color? value) {
    _micaBackgroundColor = value;
    ref.notifyListeners();
  }

  Color _inactiveBackgroundColor = const Color(0xFF608FAA);
  Color get inactiveBackgroundColor => _inactiveBackgroundColor;
  set inactiveBackgroundColor(Color value) {
    _inactiveBackgroundColor = value;
    ref.notifyListeners();
  }

  Color _disabledColor = const Color(0xFF86A2BE);
  Color get disabledColor => _disabledColor;
  set disabledColor(Color value) {
    _disabledColor = value;
    ref.notifyListeners();
  }

  Color borderInputColor = const Color.fromRGBO(0, 0, 0, 0.4458);

  Brightness _brightness = Brightness.dark;
  Brightness get brightness => _brightness;
  set brightness(Brightness value) {
    _brightness = value;
    ref.notifyListeners();
  }

  DContentDialogThemeData _dialogTheme = const DContentDialogThemeData();
  DContentDialogThemeData get dialogTheme => _dialogTheme;
  set dialogTheme(DContentDialogThemeData value) {
    _dialogTheme = value;
    ref.notifyListeners();
  }

  DContentDialogThemeData _defaultDialogTheme = const DContentDialogThemeData(
    padding: EdgeInsets.zero,
    titlePadding: EdgeInsets.only(top: 24, bottom: 28, left: 24, right: 24),
    bodyPadding: EdgeInsets.zero,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      color: SideSwapColors.blumine,
    ),
  );
  DContentDialogThemeData get defaultDialogTheme => _defaultDialogTheme;
  set defaultDialogTheme(DContentDialogThemeData value) {
    _defaultDialogTheme = value;
    ref.notifyListeners();
  }

  ScrollbarThemeData? _scrollbarTheme = const ScrollbarThemeData(
    thickness: MaterialStatePropertyAll(4),
    thumbColor: MaterialStatePropertyAll(SideSwapColors.ceruleanFrost),
    trackColor: MaterialStatePropertyAll(SideSwapColors.jellyBean),
  );

  ScrollbarThemeData? get scrollbarTheme => _scrollbarTheme;
  set scrollbarTheme(ScrollbarThemeData? value) {
    _scrollbarTheme = value;
    ref.notifyListeners();
  }

  DToggleSwitchThemeData _toggleSwitchTheme = DToggleSwitchThemeData();
  DToggleSwitchThemeData get toggleSwitchTheme => _toggleSwitchTheme;
  set toggleSwitchTheme(DToggleSwitchThemeData value) {
    _toggleSwitchTheme = value;
    ref.notifyListeners();
  }

  DRadioButtonThemeData _radioButtonTheme =
      DRadioButtonThemeData(checkedDecoration: ButtonState.resolveWith(
    (states) {
      return BoxDecoration(
        color: !states.isDisabled
            ? const Color(0xFF144866)
            : const Color(0xFF144866).lerpWith(Colors.black, 0.3),
        shape: BoxShape.circle,
        border: Border.all(
          color: !states.isDisabled
              ? SideSwapColors.brightTurquoise
              : SideSwapColors.brightTurquoise.lerpWith(Colors.black, 0.3),
          width: !states.isDisabled
              ? states.isHovering && !states.isPressing
                  ? 3.4
                  : 5.0
              : 4.0,
        ),
      );
    },
  ), uncheckedDecoration: ButtonState.resolveWith(
    (states) {
      return BoxDecoration(
        color: states.isPressing
            ? const Color(0xFF292929)
            : states.isHovering
                ? const Color(0xFF292929).withOpacity(0.8)
                : const Color(0xFF292929).withOpacity(0.0),
        shape: BoxShape.circle,
        border: Border.all(
          width: states.isPressing ? 4.5 : 1,
          color: !states.isDisabled
              ? states.isPressing
                  ? const Color.fromRGBO(255, 255, 255, 0.5442)
                  : const Color.fromRGBO(255, 255, 255, 0.5442)
              : const Color.fromRGBO(0, 0, 0, 0.2169),
        ),
      );
    },
  ));

  DRadioButtonThemeData get radioButtonTheme => _radioButtonTheme;
  set radioButtonTheme(DRadioButtonThemeData value) {
    _radioButtonTheme = value;
    ref.notifyListeners();
  }

  DButtonStyle? get mainBottomNavigationBarButtonStyle =>
      _buttonThemeData.defaultButtonStyle?.merge(
        DButtonStyle(
          border: ButtonState.all(BorderSide.none),
          textStyle: ButtonState.all(
            const TextStyle(
              fontSize: 10,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              height: 0.12,
              letterSpacing: 0.16,
            ),
          ),
        ),
      );

  DButtonStyle? get buttonWithoutBorderStyle =>
      _buttonThemeData.defaultButtonStyle?.merge(
        DButtonStyle(
          border: ButtonState.all(BorderSide.none),
          textStyle: ButtonState.all(
            const TextStyle(),
          ),
        ),
      );

  DButtonThemeData _buttonThemeData = DButtonThemeData(
    iconButtonStyle: DButtonStyle(
      backgroundColor: ButtonState.resolveWith((states) {
        if (states.isDisabled) {
          return Colors.transparent.lerpWith(Colors.black, 0.3);
        }
        if (states.isPressing) {
          return Colors.transparent.lerpWith(Colors.black, 0.2);
        }
        if (states.isHovering) {
          return Colors.transparent.lerpWith(Colors.black, 0.1);
        }
        return Colors.transparent;
      }),
      iconSize: ButtonState.all(18),
    ),
    defaultButtonStyle: DButtonStyle(
      border: ButtonState.resolveWith((states) {
        if (states.isDisabled) {
          return BorderSide(
              color: SideSwapColors.brightTurquoise.lerpWith(Colors.black, 0.1),
              width: 1);
        }
        if (states.isPressing) {
          return BorderSide(
              color:
                  SideSwapColors.brightTurquoise.lerpWith(Colors.black, 0.15),
              width: 1);
        }
        if (states.isHovering) {
          return BorderSide(
              color: SideSwapColors.brightTurquoise.lerpWith(Colors.black, 0.1),
              width: 1);
        }
        return const BorderSide(
            color: SideSwapColors.brightTurquoise, width: 1);
      }),
      backgroundColor: ButtonState.resolveWith((states) {
        if (states.isDisabled) {
          return Colors.transparent.lerpWith(Colors.black, 0.1);
        }
        if (states.isPressing) {
          return Colors.transparent.lerpWith(Colors.black, 0.15);
        }
        if (states.isHovering) {
          return Colors.transparent.lerpWith(Colors.black, 0.1);
        }
        return Colors.transparent;
      }),
      foregroundColor: ButtonState.resolveWith(
        (states) {
          if (states.isDisabled) {
            return Colors.white.lerpWith(Colors.black, 0.3);
          }
          return SideSwapColors.brightTurquoise;
        },
      ),
      shadowColor: ButtonState.all(Colors.transparent),
      padding: ButtonState.all(EdgeInsets.zero),
      textStyle: ButtonState.all(
        const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      shape: ButtonState.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
    ),
    filledButtonStyle: DButtonStyle(
      padding: ButtonState.all(EdgeInsets.zero),
      textStyle: ButtonState.all(
        const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      backgroundColor: ButtonState.resolveWith((states) {
        if (states.isDisabled) {
          return SideSwapColors.brightTurquoise.lerpWith(Colors.black, 0.3);
        }
        if (states.isPressing) {
          return SideSwapColors.brightTurquoise.lerpWith(Colors.black, 0.2);
        }
        if (states.isHovering) {
          return SideSwapColors.brightTurquoise.lerpWith(Colors.black, 0.1);
        }
        return SideSwapColors.brightTurquoise;
      }),
      foregroundColor: ButtonState.resolveWith(
        (states) {
          if (states.isDisabled) {
            return Colors.white.lerpWith(Colors.black, 0.3);
          }
          return Colors.white;
        },
      ),
      shape: ButtonState.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      border: ButtonState.resolveWith((states) {
        return const BorderSide(color: Colors.transparent, width: 1);
      }),
    ),
  );

  DButtonThemeData get buttonThemeData => _buttonThemeData;
  set buttonThemeData(DButtonThemeData value) {
    _buttonThemeData = value;
    ref.notifyListeners();
  }

  TextTheme get textTheme => darkTextTheme;

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
}

TextTheme get darkTextTheme {
  return const TextTheme(
    displaySmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700, // bold
      fontFamily: 'Roboto',
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400, // normal
      fontFamily: 'Roboto',
      color: Colors.white,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700, // bold
      fontFamily: 'Roboto',
      color: Colors.white,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400, // normal
      fontFamily: 'Roboto',
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400, // normal
      fontFamily: 'Roboto',
      color: Colors.white,
    ),
  );
}

ColorScheme get darkColorScheme {
  return ColorScheme.fromSwatch(
    primarySwatch: SideSwapColors.blumine,
    accentColor: SideSwapColors.brightTurquoise,
    cardColor: SideSwapColors.blumine,
    backgroundColor: SideSwapColors.prussianBlue,
    errorColor: SideSwapColors.bitterSweet,
    brightness: Brightness.dark,
  );
}

AccentColor get systemAccentColor {
  return AccentColor('normal', const <String, Color>{
    'darkest': Color(0xff004a83),
    'darker': Color(0xff005494),
    'dark': Color(0xff0066b4),
    'normal': Color(0xff0078d4),
    'light': Color(0xff268cda),
    'lighter': Color(0xff4ca0e0),
    'lightest': Color(0xff60abe4),
  });
}
