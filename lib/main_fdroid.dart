import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/app_main.dart';
import 'package:sideswap/screens/flavor_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig(
    flavor: Flavor.fdroid,
    values: FlavorValues(
      enableOnboardingUserFeatures: false,
      enableNetworkSettings: true,
    ),
  );

  runApp(
    const AppMain(),
  );
}
