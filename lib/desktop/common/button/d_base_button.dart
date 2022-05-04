import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/d_focus.dart';
import 'package:sideswap/desktop/theme.dart';

abstract class DBaseButton extends ConsumerStatefulWidget {
  const DBaseButton({
    Key? key,
    required this.onPressed,
    required this.onLongPress,
    this.onTapUp,
    this.onTapDown,
    this.onTapCancel,
    required this.style,
    required this.focusNode,
    required this.autofocus,
    required this.child,
    this.cursor,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final VoidCallback? onTapUp;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapCancel;
  final DButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Widget child;
  final MouseCursor? cursor;

  @protected
  DButtonStyle defaultStyleOf(BuildContext context);

  @protected
  DButtonStyle? themeStyleOf(BuildContext context);

  bool get enabled => onPressed != null || onLongPress != null;

  @override
  _BaseButtonState createState() => _BaseButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
    properties.add(
        DiagnosticsProperty<DButtonStyle>('style', style, defaultValue: null));
    properties.add(DiagnosticsProperty<FocusNode>('focusNode', focusNode,
        defaultValue: null));
  }
}

class _BaseButtonState extends ConsumerState<DBaseButton> {
  @override
  Widget build(BuildContext context) {
    final fasterAnimationDuration =
        ref.watch(desktopAppThemeProvider).fasterAnimationDuration;
    final fastAnimationDuration =
        ref.watch(desktopAppThemeProvider).fastAnimationDuration;
    final animationCurve = ref.watch(desktopAppThemeProvider).animationCurve;

    final ThemeData theme = Theme.of(context);

    final DButtonStyle? widgetStyle = widget.style;
    final DButtonStyle? themeStyle = widget.themeStyleOf(context);
    final DButtonStyle defaultStyle = widget.defaultStyleOf(context);

    T? effectiveValue<T>(T? Function(DButtonStyle? style) getProperty) {
      final T? widgetValue = getProperty(widgetStyle);
      final T? themeValue = getProperty(themeStyle);
      final T? defaultValue = getProperty(defaultStyle);
      return widgetValue ?? themeValue ?? defaultValue;
    }

    final Widget result = DHoverButton(
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      onPressed: widget.onPressed,
      onLongPress: widget.onLongPress,
      onTapCancel: widget.onTapCancel,
      onTapDown: widget.onTapDown,
      onTapUp: widget.onTapUp,
      cursor: widget.cursor,
      builder: (context, states) {
        T? resolve<T>(
            ButtonState<T>? Function(DButtonStyle? style) getProperty) {
          return effectiveValue(
            (DButtonStyle? style) => getProperty(style)?.resolve(states),
          );
        }

        final double? resolvedElevation =
            resolve<double?>((DButtonStyle? style) => style?.elevation);
        final TextStyle? resolvedTextStyle =
            resolve<TextStyle?>((DButtonStyle? style) => style?.textStyle);
        final Color? resolvedBackgroundColor =
            resolve<Color?>((DButtonStyle? style) => style?.backgroundColor);
        final Color? resolvedForegroundColor =
            resolve<Color?>((DButtonStyle? style) => style?.foregroundColor);
        final Color? resolvedShadowColor =
            resolve<Color?>((DButtonStyle? style) => style?.shadowColor);
        final EdgeInsetsGeometry resolvedPadding = resolve<EdgeInsetsGeometry?>(
                (DButtonStyle? style) => style?.padding) ??
            EdgeInsets.zero;
        final BorderSide? resolvedBorder =
            resolve<BorderSide?>((DButtonStyle? style) => style?.border);
        final OutlinedBorder resolvedShape =
            resolve<OutlinedBorder?>((DButtonStyle? style) => style?.shape) ??
                const RoundedRectangleBorder();

        final EdgeInsetsGeometry padding = resolvedPadding
            .add(EdgeInsets.symmetric(
              horizontal: theme.visualDensity.horizontal,
              vertical: theme.visualDensity.vertical,
            ))
            .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);
        final double? iconSize = resolve<double?>((style) => style?.iconSize);
        Widget result = PhysicalModel(
          color: Colors.transparent,
          shadowColor: resolvedShadowColor ?? Colors.black,
          elevation: resolvedElevation ?? 0.0,
          borderRadius: resolvedShape is RoundedRectangleBorder
              ? resolvedShape.borderRadius is BorderRadius
                  ? resolvedShape.borderRadius as BorderRadius
                  : BorderRadius.zero
              : BorderRadius.zero,
          child: AnimatedContainer(
            duration: fasterAnimationDuration,
            curve: animationCurve,
            decoration: ShapeDecoration(
              shape: resolvedShape.copyWith(side: resolvedBorder),
              color: resolvedBackgroundColor,
            ),
            padding: padding,
            child: IconTheme.merge(
              data: IconThemeData(
                color: resolvedForegroundColor,
                size: iconSize ?? 14.0,
              ),
              child: AnimatedDefaultTextStyle(
                duration: fastAnimationDuration,
                curve: animationCurve,
                style: (resolvedTextStyle ?? const TextStyle())
                    .copyWith(color: resolvedForegroundColor),
                textAlign: TextAlign.center,
                child: widget.child,
              ),
            ),
          ),
        );
        return DFocusBorder(child: result, focused: states.isFocused);
      },
    );

    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      child: result,
    );
  }
}
