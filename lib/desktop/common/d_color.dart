import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/theme.dart';

class AccentColor extends ColorSwatch<String> {
  final String primary;
  final Map<String, Color> swatch;
  AccentColor(this.primary, this.swatch)
    : super(swatch[primary]!.toARGB32(), swatch);

  Color get darkest => swatch['darkest'] ?? darker;
  Color get darker => swatch['darker'] ?? dark;
  Color get dark => swatch['dark'] ?? normal;
  Color get normal => swatch['normal']!;
  Color get light => swatch['light'] ?? normal;
  Color get lighter => swatch['lighter'] ?? light;
  Color get lightest => swatch['lightest'] ?? lighter;

  static AccentColor lerp(AccentColor? a, AccentColor? b, double t) {
    final darkest = Color.lerp(a?.darkest, b?.darkest, t);
    final darker = Color.lerp(a?.darker, b?.darker, t);
    final dark = Color.lerp(a?.dark, b?.dark, t);
    final light = Color.lerp(a?.light, b?.light, t);
    final lighter = Color.lerp(a?.lighter, b?.lighter, t);
    final lightest = Color.lerp(a?.lightest, b?.lightest, t);
    return AccentColor('normal', {
      if (darkest != null) 'darkest': darkest,
      if (darker != null) 'darker': darker,
      if (dark != null) 'dark': dark,
      'normal': Color.lerp(a?.normal, b?.normal, t)!,
      if (light != null) 'light': light,
      if (lighter != null) 'lighter': lighter,
      if (lightest != null) 'lightest': lightest,
    });
  }

  static Color resolve(Color resolvable, BuildContext context) {
    return (resolvable is AccentColor)
        ? resolvable.resolveFrom(context)
        : resolvable;
  }

  Color resolveFrom(BuildContext context, [Brightness? bright]) {
    final container = ProviderContainer();
    final themeBrightness =
        container.read(desktopAppThemeNotifierProvider).brightness;
    final brightness = bright ?? themeBrightness;
    return resolveFromBrightness(brightness);
  }

  Color resolveFromBrightness(Brightness brightness, {int level = 0}) {
    switch (brightness) {
      case Brightness.light:
        return level == 0
            ? light
            : level == 1
            ? lighter
            : lightest;
      case Brightness.dark:
        return level == 0
            ? dark
            : level == 1
            ? darker
            : darkest;
    }
  }

  Color resolveFromReverseBrightness(Brightness brightness, {int level = 0}) {
    switch (brightness) {
      case Brightness.dark:
        return level == 0
            ? light
            : level == 1
            ? lighter
            : lightest;
      case Brightness.light:
        return level == 0
            ? dark
            : level == 1
            ? darker
            : darkest;
    }
  }
}

extension ColorExtension on Color {
  AccentColor toAccentColor({
    double darkestFactor = 0.38,
    double darkerFactor = 0.30,
    double darkFactor = 0.15,
    double lightFactor = 0.15,
    double lighterFactor = 0.30,
    double lightestFactor = 0.38,
  }) {
    return AccentColor('normal', {
      'darkest': lerpWith(Colors.black, darkestFactor),
      'darker': lerpWith(Colors.black, darkerFactor),
      'dark': lerpWith(Colors.black, darkFactor),
      'normal': this,
      'light': lerpWith(Colors.white, lightFactor),
      'lighter': lerpWith(Colors.white, lighterFactor),
      'lightest': lerpWith(Colors.white, lightestFactor),
    });
  }

  Color basedOnLuminance({
    Color darkColor = Colors.black,
    Color lightColor = Colors.white,
  }) {
    return computeLuminance() < 0.5 ? lightColor : darkColor;
  }

  Color lerpWith(Color color, double t) {
    return Color.lerp(this, color, t)!;
  }
}
