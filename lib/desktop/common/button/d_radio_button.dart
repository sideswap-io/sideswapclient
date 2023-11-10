import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/common/d_focus.dart';
import 'package:sideswap/desktop/theme.dart';

class DRadioButton extends ConsumerWidget {
  const DRadioButton({
    super.key,
    required this.checked,
    required this.onChanged,
    this.style,
    this.content,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  });

  final bool checked;
  final ValueChanged<bool>? onChanged;
  final DRadioButtonThemeData? style;
  final Widget? content;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(FlagProperty('checked', value: checked, ifFalse: 'unchecked'))
      ..add(FlagProperty('disabled',
          value: onChanged == null, ifFalse: 'enabled'))
      ..add(ObjectFlagProperty.has('style', style))
      ..add(
          FlagProperty('autofocus', value: autofocus, ifFalse: 'manual focus'))
      ..add(StringProperty('semanticLabel', semanticLabel));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = DRadioButtonTheme.of(context).merge(this.style);
    final fastAnimationDuration =
        ref.watch(desktopAppThemeProvider).fastAnimationDuration;
    final animationCurve = ref.watch(desktopAppThemeProvider).animationCurve;

    return DHoverButton(
      autofocus: autofocus,
      focusNode: focusNode,
      onPressed: onChanged == null ? null : () => onChanged!(!checked),
      builder: (context, state) {
        final BoxDecoration decoration = (checked
                ? style.checkedDecoration?.resolve(state)
                : style.uncheckedDecoration?.resolve(state)) ??
            const BoxDecoration(shape: BoxShape.circle);
        Widget child = AnimatedContainer(
          duration: fastAnimationDuration,
          curve: animationCurve,
          height: 20,
          width: 20,
          decoration: decoration.copyWith(color: Colors.transparent),

          /// We need two boxes here because flutter draws the color
          /// behind the border, and it results in an weird effect. This
          /// way, the inner color will only be rendered within the
          /// bounds of the border.
          child: AnimatedContainer(
            duration: fastAnimationDuration,
            curve: animationCurve,
            decoration: BoxDecoration(
              color: decoration.color ?? Colors.transparent,
              shape: decoration.shape,
            ),
          ),
        );
        if (content != null) {
          child = Row(mainAxisSize: MainAxisSize.min, children: [
            child,
            const SizedBox(width: 6.0),
            content!,
          ]);
        }
        return Semantics(
          label: semanticLabel,
          selected: checked,
          child: DFocusBorder(focused: state.isFocused, child: child),
        );
      },
    );
  }
}

class DRadioButtonTheme extends InheritedTheme {
  const DRadioButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final DRadioButtonThemeData data;

  static Widget merge({
    Key? key,
    required DRadioButtonThemeData data,
    required Widget child,
  }) {
    return Builder(builder: (BuildContext context) {
      return DRadioButtonTheme(
        key: key,
        data: _getInheritedThemeData(context).merge(data),
        child: child,
      );
    });
  }

  static DRadioButtonThemeData _getInheritedThemeData(BuildContext context) {
    final DRadioButtonTheme? theme =
        context.dependOnInheritedWidgetOfExactType<DRadioButtonTheme>();
    final container = ProviderContainer();
    final themeRadioButtonTheme =
        container.read(desktopAppThemeProvider).radioButtonTheme;
    return theme?.data ?? themeRadioButtonTheme;
  }

  static DRadioButtonThemeData of(BuildContext context) {
    final container = ProviderContainer();
    final accentColor = container
        .read(desktopAppThemeProvider)
        .darkScheme
        .primary
        .toAccentColor();
    final brightness = container.read(desktopAppThemeProvider).brightness;
    return DRadioButtonThemeData.standard(
            accentColor: accentColor, brightness: brightness)
        .merge(
      _getInheritedThemeData(context),
    );
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return DRadioButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(DRadioButtonTheme oldWidget) =>
      data != oldWidget.data;
}

@immutable
class DRadioButtonThemeData with Diagnosticable {
  final ButtonState<BoxDecoration?>? checkedDecoration;
  final ButtonState<BoxDecoration?>? uncheckedDecoration;

  const DRadioButtonThemeData({
    this.checkedDecoration,
    this.uncheckedDecoration,
  });

  factory DRadioButtonThemeData.standard(
      {AccentColor? accentColor, Brightness? brightness}) {
    final container = ProviderContainer();
    final themeAccentColor = container
        .read(desktopAppThemeProvider)
        .darkScheme
        .primary
        .toAccentColor();
    final themeBrightness = container.read(desktopAppThemeProvider).brightness;

    return DRadioButtonThemeData(
      checkedDecoration: ButtonState.resolveWith((states) {
        return BoxDecoration(
          border: Border.all(
            color: !states.isDisabled
                ? accentColor?.light ?? themeAccentColor.light
                : brightness?.isLight ?? themeBrightness.isLight
                    ? const Color.fromRGBO(0, 0, 0, 0.2169)
                    : const Color.fromRGBO(255, 255, 255, 0.1581),
            width: !states.isDisabled
                ? states.isHovering && !states.isPressing
                    ? 3.4
                    : 5.0
                : 4.0,
          ),
          shape: BoxShape.circle,
          color: !states.isDisabled
              ? brightness?.isLight ?? themeBrightness.isLight
                  ? Colors.white
                  : Colors.black
              : brightness?.isLight ?? themeBrightness.isLight
                  ? Colors.white
                  : const Color.fromRGBO(255, 255, 255, 0.5302),
        );
      }),
      uncheckedDecoration: ButtonState.resolveWith((states) {
        final container = ProviderContainer();
        final inactiveBackgroundColor =
            container.read(desktopAppThemeProvider).inactiveBackgroundColor;
        final accentColor =
            container.read(desktopAppThemeProvider).darkScheme.primary;
        final borderInputColor =
            container.read(desktopAppThemeProvider).borderInputColor;
        final brightness = container.read(desktopAppThemeProvider).brightness;

        final backgroundColor = inactiveBackgroundColor;
        return BoxDecoration(
          color: states.isPressing
              ? backgroundColor
              : states.isHovering
                  ? backgroundColor.withOpacity(0.8)
                  : backgroundColor.withOpacity(0.0),
          border: Border.all(
            width: states.isPressing ? 4.5 : 1,
            color: !states.isDisabled
                ? states.isPressing
                    ? accentColor
                    : borderInputColor
                : brightness.isLight
                    ? const Color.fromRGBO(0, 0, 0, 0.2169)
                    : const Color.fromRGBO(255, 255, 255, 0.1581),
          ),
          shape: BoxShape.circle,
        );
      }),
    );
  }

  static DRadioButtonThemeData lerp(
      DRadioButtonThemeData? a, DRadioButtonThemeData? b, double t) {
    return DRadioButtonThemeData(
      checkedDecoration: ButtonState.lerp(
          a?.checkedDecoration, b?.checkedDecoration, t, BoxDecoration.lerp),
      uncheckedDecoration: ButtonState.lerp(a?.uncheckedDecoration,
          b?.uncheckedDecoration, t, BoxDecoration.lerp),
    );
  }

  DRadioButtonThemeData merge(DRadioButtonThemeData? style) {
    return DRadioButtonThemeData(
      checkedDecoration: style?.checkedDecoration ?? checkedDecoration,
      uncheckedDecoration: style?.uncheckedDecoration ?? uncheckedDecoration,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonState<BoxDecoration?>?>(
        'checkedDecoration', checkedDecoration));
    properties.add(DiagnosticsProperty<ButtonState<BoxDecoration?>?>(
        'uncheckedDecoration', uncheckedDecoration));
  }
}
