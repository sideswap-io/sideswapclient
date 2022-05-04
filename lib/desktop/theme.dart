import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_radio_button.dart';
import 'package:sideswap/desktop/common/button/d_toggle_switch_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/common/d_focus.dart';
import 'package:sideswap/desktop/common/d_typography.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';

bool is10footScreen([double? width]) {
  width ??= ui.window.physicalSize.width;
  return width >= 11520;
}

extension BrightnessExtension on Brightness {
  bool get isLight => this == Brightness.light;
  bool get isDark => this == Brightness.dark;

  Brightness get opposite => isLight ? Brightness.dark : Brightness.light;
}

enum NavigationIndicators { sticky, end }

final desktopAppThemeProvider =
    ChangeNotifierProvider<DesktopAppTheme>((ref) => DesktopAppTheme(ref));

class DesktopAppTheme extends ChangeNotifier {
  final Ref ref;

  DesktopAppTheme(this.ref);

  ColorScheme _darkScheme = darkColorScheme;
  ColorScheme get darkScheme => _darkScheme;
  set darkScheme(ColorScheme value) {
    _darkScheme = value;
    notifyListeners();
  }

  Duration _fasterAnimationDuration = const Duration(milliseconds: 83);
  Duration get fasterAnimationDuration => _fasterAnimationDuration;
  set fasterAnimationDuration(Duration value) {
    _fasterAnimationDuration = value;
    notifyListeners();
  }

  Duration _fastAnimationDuration = const Duration(milliseconds: 167);
  Duration get fastAnimationDuration => _fastAnimationDuration;
  set fastAnimationDuration(Duration value) {
    _fastAnimationDuration = value;
    notifyListeners();
  }

  Duration _mediumAnimationDuration = const Duration(milliseconds: 250);
  Duration get mediumAnimationDuration => _mediumAnimationDuration;
  set mediumAnimationDuration(Duration value) {
    _mediumAnimationDuration = value;
    notifyListeners();
  }

  Duration _slowAnimationDuration = const Duration(milliseconds: 358);
  Duration get slowAnimationDuration => _slowAnimationDuration;
  set slowAnimationDuration(Duration value) {
    _slowAnimationDuration = value;
    notifyListeners();
  }

  Curve _animationCurve = Curves.easeInOut;
  Curve get animationCurve => _animationCurve;
  set animationCurve(Curve value) {
    _animationCurve = value;
    notifyListeners();
  }

  ThemeMode _mode = ThemeMode.dark;
  ThemeMode get mode => _mode;
  set mode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }

  TextDirection _textDirection = TextDirection.ltr;
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection direction) {
    _textDirection = direction;
    notifyListeners();
  }

  Color? _scaffoldBackgroundColor = Colors.transparent;
  Color? get scaffoldBackgroundColor => _scaffoldBackgroundColor;
  set scaffoldBackgroundColor(Color? value) {
    _scaffoldBackgroundColor = value;
    notifyListeners();
  }

  VisualDensity? _visualDensity = VisualDensity.adaptivePlatformDensity;
  VisualDensity? get visualDensity => _visualDensity;
  set visualDensity(VisualDensity? value) {
    _visualDensity = value;
    notifyListeners();
  }

  DTypography _typography =
      DTypography.standard(brightness: Brightness.light, color: Colors.white);
  DTypography get typography => _typography;
  set typography(DTypography value) {
    _typography = value;
    notifyListeners();
  }

  String? _fontFamily = 'Roboto';
  String? get fontFamily => _fontFamily;
  set fontFamily(String? value) {
    _fontFamily = value;
    notifyListeners();
  }

  DFocusThemeData _focusThemeData = DFocusThemeData(
    glowColor: Colors.transparent,
    glowFactor: is10footScreen() ? 2.0 : 0.0,
    primaryBorder: const BorderSide(width: 1, color: Color(0xFF00C5FF)),
    secondaryBorder: BorderSide.none,
    renderOutside: false,
  );
  DFocusThemeData get focusThemeData => _focusThemeData;
  set focusThemeData(DFocusThemeData value) {
    _focusThemeData = value;
    notifyListeners();
  }

  Color? _menuColor = const Color(0xFF135579);
  Color? get menuColor => _menuColor;
  set menuColor(Color? value) {
    _menuColor = value;
    notifyListeners();
  }

  Color? _shadowColor = Colors.transparent;
  Color? get shadowColor => _shadowColor;
  set shadowColor(Color? value) {
    _shadowColor = value;
    notifyListeners();
  }

  Color? _micaBackgroundColor = const Color(0xFF1E6389);
  Color? get micaBackgroundColor => _micaBackgroundColor;
  set micaBackgroundColor(Color? value) {
    _micaBackgroundColor = value;
    notifyListeners();
  }

  Color _inactiveBackgroundColor = const Color(0xFF608FAA);
  Color get inactiveBackgroundColor => _inactiveBackgroundColor;
  set inactiveBackgroundColor(Color value) {
    _inactiveBackgroundColor = value;
    notifyListeners();
  }

  Color _disabledColor = const Color(0xFF86A2BE);
  Color get disabledColor => _disabledColor;
  set disabledColor(Color value) {
    _disabledColor = value;
    notifyListeners();
  }

  Color borderInputColor = const Color.fromRGBO(0, 0, 0, 0.4458);

  Brightness _brightness = Brightness.dark;
  Brightness get brightness => _brightness;
  set brightness(Brightness value) {
    _brightness = value;
    notifyListeners();
  }

  DContentDialogThemeData _dialogTheme = const DContentDialogThemeData();
  DContentDialogThemeData get dialogTheme => _dialogTheme;
  set dialogTheme(DContentDialogThemeData value) {
    _dialogTheme = value;
    notifyListeners();
  }

  DContentDialogThemeData _settingsDialogTheme = const DContentDialogThemeData(
    padding: EdgeInsets.zero,
    titlePadding: EdgeInsets.only(top: 24, bottom: 28, left: 24, right: 24),
    bodyPadding: EdgeInsets.zero,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      color: Color(0xFF1C6086),
    ),
  );
  DContentDialogThemeData get settingsDialogTheme => _settingsDialogTheme;
  set settingsDialogTheme(DContentDialogThemeData value) {
    _settingsDialogTheme = value;
    notifyListeners();
  }

  // TODO: fix
  // ScrollbarThemeData? _scrollbarTheme =
  //     const ScrollbarThemeData().merge(const ScrollbarThemeData(
  //   scrollbarColor: Color(0xFF2F8FC5),
  //   scrollbarPressingColor: Color(0xFF2F8FC5),
  //   thickness: 4,
  //   hoveringThickness: 4,
  //   minThumbLength: 83,
  // ));
  // ScrollbarThemeData? get scrollbarTheme => _scrollbarTheme;
  // set scrollbarTheme(ScrollbarThemeData? value) {
  //   _scrollbarTheme = value;
  //   notifyListeners();
  // }

  DToggleSwitchThemeData _toggleSwitchTheme = DToggleSwitchThemeData();
  DToggleSwitchThemeData get toggleSwitchTheme => _toggleSwitchTheme;
  set toggleSwitchTheme(DToggleSwitchThemeData value) {
    _toggleSwitchTheme = value;
    notifyListeners();
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
              ? const Color(0xFF00C5FF)
              : const Color(0xFF00C5FF).lerpWith(Colors.black, 0.3),
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
    notifyListeners();
  }

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
              color: const Color(0xFF00C5FF).lerpWith(Colors.black, 0.1),
              width: 1);
        }
        if (states.isPressing) {
          return BorderSide(
              color: const Color(0xFF00C5FF).lerpWith(Colors.black, 0.15),
              width: 1);
        }
        if (states.isHovering) {
          return BorderSide(
              color: const Color(0xFF00C5FF).lerpWith(Colors.black, 0.1),
              width: 1);
        }
        return const BorderSide(color: Color(0xFF00C5FF), width: 1);
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
          return const Color(0xFF00C5FF);
        },
      ),
      shadowColor: ButtonState.all(Colors.transparent),
      padding: ButtonState.all(EdgeInsets.zero),
      textStyle: ButtonState.all(
        GoogleFonts.roboto(
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
        GoogleFonts.roboto(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      backgroundColor: ButtonState.resolveWith((states) {
        if (states.isDisabled) {
          return const Color(0xFF00C5FF).lerpWith(Colors.black, 0.3);
        }
        if (states.isPressing) {
          return const Color(0xFF00C5FF).lerpWith(Colors.black, 0.2);
        }
        if (states.isHovering) {
          return const Color(0xFF00C5FF).lerpWith(Colors.black, 0.1);
        }
        return const Color(0xFF00C5FF);
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
    notifyListeners();
  }
}

ColorScheme get darkColorScheme {
  return ColorScheme.fromSwatch(
      accentColor: const Color(0xFF00C5FF), brightness: Brightness.dark);
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
