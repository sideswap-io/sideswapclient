import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/common/d_focus.dart';
import 'package:sideswap/desktop/theme.dart';

class DSettingsRadioButton extends HookConsumerWidget {
  const DSettingsRadioButton({
    super.key,
    required this.checked,
    required this.onChanged,
    this.content,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.trailingIcon = false,
  });

  final bool checked;
  final ValueChanged<bool>? onChanged;
  final Widget? content;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool trailingIcon;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(FlagProperty('checked', value: checked, ifFalse: 'unchecked'))
      ..add(FlagProperty('disabled',
          value: onChanged == null, ifFalse: 'enabled'))
      ..add(
          FlagProperty('autofocus', value: autofocus, ifFalse: 'manual focus'))
      ..add(StringProperty('semanticLabel', semanticLabel));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fastAnimationDuration =
        ref.watch(desktopAppThemeProvider).fastAnimationDuration;
    final animationCurve = ref.watch(desktopAppThemeProvider).animationCurve;

    return DHoverButton(
      autofocus: autofocus,
      focusNode: focusNode,
      onPressed: onChanged == null ? null : () => onChanged!(!checked),
      builder: (context, state) {
        final settingsRadioButtonStyle =
            DSettingsRadioButtonThemeData.standard();

        final BoxDecoration decoration = (checked
                ? settingsRadioButtonStyle.checkedDecoration?.resolve(state)
                : settingsRadioButtonStyle.uncheckedDecoration
                    ?.resolve(state)) ??
            const BoxDecoration(shape: BoxShape.circle);

        Widget child = AnimatedContainer(
            duration: fastAnimationDuration,
            curve: animationCurve,
            height: 20,
            width: 20,
            decoration: decoration.copyWith(color: Colors.transparent),
            child: AnimatedContainer(
              duration: fastAnimationDuration,
              curve: animationCurve,
              decoration: BoxDecoration(
                color: decoration.color ?? Colors.transparent,
                shape: decoration.shape,
              ),
              child: checked
                  ? Icon(
                      Icons.done,
                      size: state.isHovering ? 14 : 12,
                    )
                  : null,
            ));
        if (content != null) {
          child = Container(
            decoration: BoxDecoration(
              border: checked
                  ? Border.all(color: Colors.transparent)
                  : Border.all(color: const Color(0xFF327FA9)),
              color: (checked
                      ? settingsRadioButtonStyle.checkedBackground
                          ?.resolve(state)
                      : settingsRadioButtonStyle.uncheckedBackground
                          ?.resolve(state)) ??
                  Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            width: double.infinity,
            height: 44,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 16),
                child,
                const SizedBox(width: 10.0),
                content!,
                if (trailingIcon) ...[
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.chevron_right,
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          );
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

class DSettingsRadioButtonThemeData with Diagnosticable {
  final ButtonState<BoxDecoration?>? checkedDecoration;
  final ButtonState<BoxDecoration?>? uncheckedDecoration;
  final ButtonState<Color?>? checkedBackground;
  final ButtonState<Color?>? uncheckedBackground;

  const DSettingsRadioButtonThemeData({
    this.checkedBackground,
    this.uncheckedBackground,
    this.checkedDecoration,
    this.uncheckedDecoration,
  });

  factory DSettingsRadioButtonThemeData.standard() {
    return DSettingsRadioButtonThemeData(
        checkedDecoration: ButtonState.resolveWith((states) {
      return const BoxDecoration(
        shape: BoxShape.circle,
        color: SideSwapColors.brightTurquoise,
      );
    }), uncheckedDecoration: ButtonState.resolveWith((states) {
      return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: const Color(0xFF327FA9),
            width: states.isPressing
                ? 4
                : states.isHovering
                    ? 2
                    : 1),
      );
    }), checkedBackground: ButtonState.resolveWith((states) {
      if (states.isPressing) {
        return SideSwapColors.chathamsBlue.lerpWith(Colors.black, 0.2);
      }

      if (states.isHovering) {
        return SideSwapColors.chathamsBlue.lerpWith(Colors.black, 0.1);
      }

      return SideSwapColors.chathamsBlue;
    }), uncheckedBackground: ButtonState.resolveWith((states) {
      if (states.isPressing) {
        return Colors.transparent.lerpWith(Colors.black, 0.2);
      }

      if (states.isHovering) {
        return Colors.transparent.lerpWith(Colors.black, 0.1);
      }

      return Colors.transparent;
    }));
  }
}
