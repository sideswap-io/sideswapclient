import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/common/d_focus.dart';
import 'package:sideswap/desktop/theme.dart';

class DToggleSwitchButton extends StatelessWidget {
  const DToggleSwitchButton({
    Key? key,
    required this.checked,
    required this.onChanged,
    this.width = 460,
    this.height = 36,
    required this.checkedName,
    required this.uncheckedName,
    this.style,
    this.semanticLabel,
  }) : super(key: key);

  final bool checked;
  final ValueChanged<bool>? onChanged;
  final double width;
  final double height;
  final String checkedName;
  final String uncheckedName;
  final DToggleSwitchThemeData? style;
  final String? semanticLabel;

  bool get isDisabled => onChanged == null;

  @override
  Widget build(BuildContext context) {
    final DToggleSwitchThemeData toggleSwitchStyle =
        DToggleSwitchTheme.of(context).merge(style);
    return DHoverButton(
      onPressed: isDisabled ? null : () => onChanged!(!checked),
      builder: (context, states) {
        return Semantics(
          checked: checked,
          label: semanticLabel,
          child: DFocusBorder(
            focused: states.isFocused,
            child: Container(
              decoration: checked
                  ? toggleSwitchStyle.checkedDecoration?.resolve(states)
                  : toggleSwitchStyle.uncheckedDecoration?.resolve(states),
              child: Stack(
                children: [
                  AnimatedContainer(
                    width: width - 4,
                    height: height - 2,
                    duration: toggleSwitchStyle.animationDuration!,
                    curve: toggleSwitchStyle.animationCurve!,
                    alignment: (checked
                        ? Alignment.centerLeft
                        : Alignment.centerRight),
                    child: Container(
                      width: (width - 4) / 2,
                      decoration: checked
                          ? toggleSwitchStyle.checkedThumbDecoration
                              ?.resolve(states)
                          : toggleSwitchStyle.uncheckedThumbDecoration
                              ?.resolve(states),
                    ),
                  ),
                  SizedBox(
                    width: width - 4,
                    height: height - 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          checkedName,
                          style: checked
                              ? toggleSwitchStyle.checkedTextStyle1
                                  ?.resolve(states)
                              : toggleSwitchStyle.uncheckedTextStyle1
                                  ?.resolve(states),
                        ),
                        Text(
                          uncheckedName,
                          style: checked
                              ? toggleSwitchStyle.checkedTextStyle2
                                  ?.resolve(states)
                              : toggleSwitchStyle.uncheckedTextStyle2
                                  ?.resolve(states),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DToggleSwitchTheme extends InheritedTheme {
  const DToggleSwitchTheme({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

  final DToggleSwitchThemeData data;

  static Widget merge({
    Key? key,
    required DToggleSwitchThemeData data,
    required Widget child,
  }) {
    return Builder(builder: (BuildContext context) {
      return DToggleSwitchTheme(
        key: key,
        data: DToggleSwitchTheme.of(context).merge(data),
        child: child,
      );
    });
  }

  static DToggleSwitchThemeData of(BuildContext context) {
    final container = ProviderContainer();
    return DToggleSwitchThemeData.standard()
        .merge(container.read(desktopAppThemeProvider).toggleSwitchTheme);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DToggleSwitchTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(DToggleSwitchTheme oldWidget) {
    return oldWidget.data != data;
  }
}

@immutable
class DToggleSwitchThemeData with Diagnosticable {
  final ButtonState<Decoration?>? checkedThumbDecoration;
  final ButtonState<Decoration?>? uncheckedThumbDecoration;

  final ButtonState<Decoration?>? checkedDecoration;
  final ButtonState<Decoration?>? uncheckedDecoration;

  final ButtonState<TextStyle?>? checkedTextStyle1;
  final ButtonState<TextStyle?>? uncheckedTextStyle1;

  final ButtonState<TextStyle?>? checkedTextStyle2;
  final ButtonState<TextStyle?>? uncheckedTextStyle2;

  final Duration? animationDuration;
  final Curve? animationCurve;

  DToggleSwitchThemeData({
    this.checkedThumbDecoration,
    this.uncheckedThumbDecoration,
    this.checkedDecoration,
    this.uncheckedDecoration,
    this.animationDuration,
    this.animationCurve,
    this.checkedTextStyle1,
    this.uncheckedTextStyle1,
    this.checkedTextStyle2,
    this.uncheckedTextStyle2,
  });

  factory DToggleSwitchThemeData.standard() {
    const defaultDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
    final container = ProviderContainer();
    final fastAnimationDuration =
        container.read(desktopAppThemeProvider).fastAnimationDuration;
    final animationCurve =
        container.read(desktopAppThemeProvider).animationCurve;

    return DToggleSwitchThemeData(
      checkedDecoration: ButtonState.resolveWith((states) {
        return defaultDecoration.copyWith(
          color: !states.isDisabled
              ? states.isHovering
                  ? states.isPressing
                      ? const Color(0xFF062D44).lerpWith(Colors.black, 0.2)
                      : const Color(0xFF062D44).lerpWith(Colors.black, 0.1)
                  : const Color(0xFF062D44)
              : Colors.white.withOpacity(0.1),
          border: Border.all(
            width: 2,
            color: Colors.transparent,
          ),
        );
      }),
      uncheckedDecoration: ButtonState.resolveWith((states) {
        return defaultDecoration.copyWith(
          color: !states.isDisabled
              ? states.isHovering
                  ? states.isPressing
                      ? const Color(0xFF062D44).lerpWith(Colors.black, 0.2)
                      : const Color(0xFF062D44).lerpWith(Colors.black, 0.1)
                  : const Color(0xFF062D44)
              : Colors.white.withOpacity(0.1),
          border: Border.all(
            width: 2,
            color: Colors.transparent,
          ),
        );
      }),
      animationDuration: fastAnimationDuration,
      animationCurve: animationCurve,
      checkedThumbDecoration: ButtonState.resolveWith((states) {
        return BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: !states.isDisabled
              ? states.isHovering
                  ? states.isPressing
                      ? const Color(0xFF1B8BC8).lerpWith(Colors.black, 0.2)
                      : const Color(0xFF1B8BC8).lerpWith(Colors.black, 0.1)
                  : const Color(0xFF1B8BC8)
              : const Color(0xFF1B8BC8).lerpWith(Colors.white, 0.1),
        );
      }),
      uncheckedThumbDecoration: ButtonState.resolveWith((states) {
        return BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: !states.isDisabled
              ? states.isHovering
                  ? states.isPressing
                      ? const Color(0xFF1B8BC8).lerpWith(Colors.black, 0.2)
                      : const Color(0xFF1B8BC8).lerpWith(Colors.black, 0.1)
                  : const Color(0xFF1B8BC8)
              : const Color(0xFF1B8BC8).lerpWith(Colors.white, 0.1),
        );
      }),
      checkedTextStyle1: ButtonState.resolveWith((states) {
        return GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        );
      }),
      uncheckedTextStyle1: ButtonState.resolveWith((states) {
        return GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF78AECC),
        );
      }),
      checkedTextStyle2: ButtonState.resolveWith((states) {
        return GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF78AECC),
        );
      }),
      uncheckedTextStyle2: ButtonState.resolveWith((states) {
        return GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        );
      }),
    );
  }

  static DToggleSwitchThemeData lerp(
    DToggleSwitchThemeData? a,
    DToggleSwitchThemeData? b,
    double t,
  ) {
    return DToggleSwitchThemeData(
      animationCurve: t < 0.5 ? a?.animationCurve : b?.animationCurve,
      animationDuration: lerpDuration(a?.animationDuration ?? Duration.zero,
          b?.animationDuration ?? Duration.zero, t),
      checkedThumbDecoration: ButtonState.lerp(a?.checkedThumbDecoration,
          b?.checkedThumbDecoration, t, Decoration.lerp),
      uncheckedThumbDecoration: ButtonState.lerp(a?.uncheckedThumbDecoration,
          b?.uncheckedThumbDecoration, t, Decoration.lerp),
      checkedDecoration: ButtonState.lerp(
          a?.checkedDecoration, b?.checkedDecoration, t, Decoration.lerp),
      uncheckedDecoration: ButtonState.lerp(
          a?.uncheckedDecoration, b?.uncheckedDecoration, t, Decoration.lerp),
      checkedTextStyle1: ButtonState.lerp(
          a?.checkedTextStyle1, b?.checkedTextStyle1, t, TextStyle.lerp),
      uncheckedTextStyle1: ButtonState.lerp(
          a?.uncheckedTextStyle1, b?.uncheckedTextStyle1, t, TextStyle.lerp),
      checkedTextStyle2: ButtonState.lerp(
          a?.checkedTextStyle2, b?.checkedTextStyle2, t, TextStyle.lerp),
      uncheckedTextStyle2: ButtonState.lerp(
          a?.uncheckedTextStyle2, b?.uncheckedTextStyle2, t, TextStyle.lerp),
    );
  }

  DToggleSwitchThemeData merge(DToggleSwitchThemeData? style) {
    return DToggleSwitchThemeData(
      animationCurve: style?.animationCurve ?? animationCurve,
      animationDuration: style?.animationDuration ?? animationDuration,
      checkedThumbDecoration:
          style?.checkedThumbDecoration ?? checkedThumbDecoration,
      uncheckedThumbDecoration:
          style?.uncheckedThumbDecoration ?? uncheckedThumbDecoration,
      checkedDecoration: style?.checkedDecoration ?? checkedDecoration,
      uncheckedDecoration: style?.uncheckedDecoration ?? uncheckedDecoration,
      checkedTextStyle1: style?.checkedTextStyle1 ?? checkedTextStyle1,
      uncheckedTextStyle1: style?.uncheckedTextStyle1 ?? uncheckedTextStyle1,
      checkedTextStyle2: style?.checkedTextStyle2 ?? checkedTextStyle2,
      uncheckedTextStyle2: style?.uncheckedTextStyle2 ?? uncheckedTextStyle2,
    );
  }
}
