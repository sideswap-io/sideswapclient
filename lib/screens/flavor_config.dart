import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';

enum Flavor {
  fdroid,
  production,
}

class FlavorValues {
  bool enableOnboardingUserFeatures;
  FlavorValues({
    @required this.enableOnboardingUserFeatures,
  });
}

class FlavorConfig {
  final Flavor flavor;
  final FlavorValues values;
  final String name;
  static FlavorConfig _instance;

  factory FlavorConfig({
    @required Flavor flavor,
    @required FlavorValues values,
  }) {
    _instance ??= FlavorConfig._internal(
        flavor, values, EnumToString.convertToString(flavor));
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.values, this.name);

  static FlavorConfig get instance => _instance;
  static bool isProduction() => _instance.flavor == Flavor.production;
  static bool isFdroid() => _instance.flavor == Flavor.fdroid;
}
