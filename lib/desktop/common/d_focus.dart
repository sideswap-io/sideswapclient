import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/theme.dart';

class DFocusBorder extends ConsumerWidget {
  const DFocusBorder({
    super.key,
    required this.child,
    this.focused = true,
    this.style,
    this.renderOutside,
    this.useStackApproach = true,
  });

  final Widget child;
  final bool focused;
  final DFocusThemeData? style;
  final bool? renderOutside;
  final bool useStackApproach;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      FlagProperty('focused', value: focused, ifFalse: 'unfocused'),
    );
    properties.add(DiagnosticsProperty<DFocusThemeData>('style', style));
    properties.add(
      FlagProperty(
        'renderOutside',
        value: renderOutside,
        ifFalse: 'render inside',
      ),
    );
    properties.add(
      FlagProperty(
        'useStackApproach',
        value: useStackApproach,
        defaultValue: true,
        ifFalse: 'use border approach',
      ),
    );
  }

  static Widget buildBorder(
    BuildContext context,
    DFocusThemeData style,
    bool focused,
    Duration fasterAnimationDuration,
    Curve animationCurve, [
    Widget? child,
  ]) {
    return IgnorePointer(
      child: AnimatedContainer(
        duration: fasterAnimationDuration,
        curve: animationCurve,
        decoration: style.buildPrimaryDecoration(focused),
        child: DecoratedBox(
          decoration: style.buildSecondaryDecoration(focused),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fasterAnimationDuration =
        ref.watch(desktopAppThemeNotifierProvider).fasterAnimationDuration;
    final animationCurve =
        ref.watch(desktopAppThemeNotifierProvider).animationCurve;

    final style = DFocusTheme.of(context).merge(this.style);
    final double borderWidth =
        (style.primaryBorder?.width ?? 0) + (style.secondaryBorder?.width ?? 0);
    if (useStackApproach) {
      final renderOutside = this.renderOutside ?? style.renderOutside ?? true;
      final clipBehavior = renderOutside ? Clip.none : Clip.hardEdge;
      return Stack(
        fit: StackFit.passthrough,
        clipBehavior: clipBehavior,
        children: [
          child,
          Positioned.fill(
            left: renderOutside ? -borderWidth : 0,
            right: renderOutside ? -borderWidth : 0,
            top: renderOutside ? -borderWidth : 0,
            bottom: renderOutside ? -borderWidth : 0,
            child: buildBorder(
              context,
              style,
              focused,
              fasterAnimationDuration,
              animationCurve,
            ),
          ),
        ],
      );
    } else {
      return buildBorder(
        context,
        style,
        focused,
        fasterAnimationDuration,
        animationCurve,
        child,
      );
    }
  }
}

class DFocusTheme extends InheritedWidget {
  const DFocusTheme({super.key, required this.data, required super.child});

  final DFocusThemeData data;

  static DFocusThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<DFocusTheme>();
    final container = ProviderContainer();
    final focusThemeData =
        container.read(desktopAppThemeNotifierProvider).focusThemeData;
    return focusThemeData.merge(theme?.data);
  }

  @override
  bool updateShouldNotify(DFocusTheme oldWidget) => oldWidget.data != data;
}

class DFocusThemeData with Diagnosticable {
  final BorderRadius? borderRadius;
  final BorderSide? primaryBorder;
  final BorderSide? secondaryBorder;
  final Color? glowColor;
  final double? glowFactor;
  final bool? renderOutside;

  const DFocusThemeData({
    this.borderRadius,
    this.primaryBorder,
    this.secondaryBorder,
    this.glowColor,
    this.glowFactor,
    this.renderOutside,
  }) : assert(glowFactor == null || glowFactor >= 0);

  static DFocusThemeData _getInheritedThemeData(BuildContext context) {
    final DFocusTheme? theme =
        context.dependOnInheritedWidgetOfExactType<DFocusTheme>();
    final container = ProviderContainer();
    final themeFocusTheme =
        container.read(desktopAppThemeNotifierProvider).focusThemeData;
    return theme?.data ?? themeFocusTheme;
  }

  static DFocusThemeData of(BuildContext context) {
    final container = ProviderContainer();
    final accentColor =
        container
            .read(desktopAppThemeNotifierProvider)
            .darkScheme
            .primary
            .toAccentColor();
    return DFocusThemeData(
      glowColor: Colors.transparent,
      glowFactor: is10footScreen() ? 2.0 : 0.0,
      primaryBorder: BorderSide(width: 1, color: accentColor.normal),
      secondaryBorder: BorderSide.none,
      renderOutside: false,
    ).merge(_getInheritedThemeData(context));
  }

  factory DFocusThemeData.standard({
    required Color primaryBorderColor,
    required Color secondaryBorderColor,
    required Color glowColor,
  }) {
    return DFocusThemeData(
      borderRadius: BorderRadius.zero,
      primaryBorder: BorderSide(width: 2, color: primaryBorderColor),
      secondaryBorder: BorderSide(width: 1, color: secondaryBorderColor),
      glowColor: glowColor,
      glowFactor: 0.0,
      renderOutside: true,
    );
  }

  static DFocusThemeData lerp(
    DFocusThemeData? a,
    DFocusThemeData? b,
    double t,
  ) {
    return DFocusThemeData(
      borderRadius: BorderRadius.lerp(a?.borderRadius, b?.borderRadius, t),
      primaryBorder: BorderSide.lerp(
        a?.primaryBorder ?? BorderSide.none,
        b?.primaryBorder ?? BorderSide.none,
        t,
      ),
      secondaryBorder: BorderSide.lerp(
        a?.secondaryBorder ?? BorderSide.none,
        b?.secondaryBorder ?? BorderSide.none,
        t,
      ),
      glowColor: Color.lerp(a?.glowColor, b?.glowColor, t),
      glowFactor: lerpDouble(a?.glowFactor, b?.glowFactor, t),
      renderOutside: t < 0.5 ? a?.renderOutside : b?.renderOutside,
    );
  }

  DFocusThemeData merge(DFocusThemeData? other) {
    if (other == null) return this;
    return DFocusThemeData(
      primaryBorder: other.primaryBorder ?? primaryBorder,
      secondaryBorder: other.secondaryBorder ?? secondaryBorder,
      borderRadius: other.borderRadius ?? borderRadius,
      glowFactor: other.glowFactor ?? glowFactor,
      glowColor: other.glowColor ?? glowColor,
      renderOutside: other.renderOutside ?? renderOutside,
    );
  }

  BoxDecoration buildPrimaryDecoration(bool focused) {
    return BoxDecoration(
      borderRadius: borderRadius,
      border: Border.fromBorderSide(
        !focused ? BorderSide.none : primaryBorder ?? BorderSide.none,
      ),
      boxShadow:
          focused && glowFactor != 0 && glowColor != null
              ? [
                BoxShadow(
                  offset: const Offset(1, 1),
                  color: glowColor!,
                  spreadRadius: glowFactor!,
                  blurRadius: glowFactor! * 2.5,
                ),
                BoxShadow(
                  offset: const Offset(-1, -1),
                  color: glowColor!,
                  spreadRadius: glowFactor!,
                  blurRadius: glowFactor! * 2.5,
                ),
                BoxShadow(
                  offset: const Offset(-1, 1),
                  color: glowColor!,
                  spreadRadius: glowFactor!,
                  blurRadius: glowFactor! * 2.5,
                ),
                BoxShadow(
                  offset: const Offset(1, -1),
                  color: glowColor!,
                  spreadRadius: glowFactor!,
                  blurRadius: glowFactor! * 2.5,
                ),
              ]
              : null,
    );
  }

  BoxDecoration buildSecondaryDecoration(bool focused) {
    return BoxDecoration(
      borderRadius: borderRadius,
      border: Border.fromBorderSide(
        !focused ? BorderSide.none : secondaryBorder ?? BorderSide.none,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<BorderSide>(
        'primaryBorder',
        primaryBorder,
        ifNull: 'No primary border',
      ),
    );
    properties.add(
      DiagnosticsProperty<BorderSide>(
        'secondaryBorder',
        secondaryBorder,
        ifNull: 'No secondary border',
      ),
    );
    properties.add(
      DiagnosticsProperty<BorderRadius>(
        'borderRadius',
        borderRadius,
        defaultValue: BorderRadius.zero,
      ),
    );
    properties.add(DoubleProperty('glowFactor', glowFactor, defaultValue: 0.0));
    properties.add(
      ColorProperty('glowColor', glowColor, defaultValue: Colors.transparent),
    );
    properties.add(
      FlagProperty(
        'renderOutside',
        value: renderOutside,
        defaultValue: true,
        ifFalse: 'renderInside',
      ),
    );
  }
}
