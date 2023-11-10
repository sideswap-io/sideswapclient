import 'package:enum_to_string/enum_to_string.dart';

enum Flavor {
  fdroid,
  production,
}

class FlavorValues {
  bool enableOnboardingUserFeatures;
  bool enableNetworkSettings;
  bool enableJade;
  bool enableLocalEndpoint;
  bool isDesktop;
  bool isFdroid;

  FlavorValues({
    required this.enableOnboardingUserFeatures,
    required this.enableNetworkSettings,
    required this.enableJade,
    required this.enableLocalEndpoint,
    this.isDesktop = false,
    this.isFdroid = false,
  });
}

class FlavorConfig {
  final Flavor flavor;
  final FlavorValues values;
  final String name;
  static late FlavorConfig _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) {
    return _instance = FlavorConfig._internal(
        flavor, values, EnumToString.convertToString(flavor));
  }

  FlavorConfig._internal(this.flavor, this.values, this.name);

  static FlavorConfig get instance => _instance;
  static bool get isProduction => _instance.flavor == Flavor.production;
  static bool get isFdroid => _instance.values.isFdroid;
  static bool get enableOnboardingUserFeatures =>
      _instance.values.enableOnboardingUserFeatures;
  static bool get enableNetworkSettings =>
      _instance.values.enableNetworkSettings;
  static bool get isDesktop => _instance.values.isDesktop;
  static bool get enableJade => _instance.values.enableJade;
  static bool get enableLocalEndpoint => _instance.values.enableLocalEndpoint;
}
