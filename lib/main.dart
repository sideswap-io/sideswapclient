import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/app_main.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/common/utils/build_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (notificationServiceAvailable()) {
    await Firebase.initializeApp();
  }

  FlavorConfig(
    flavor: Flavor.production,
    values: FlavorValues(
      enableOnboardingUserFeatures: false,
      enableNetworkSettings: true,
    ),
  );

  runApp(
    const AppMain(),
  );
}
