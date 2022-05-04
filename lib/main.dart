import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sideswap/app_main.dart';
import 'package:sideswap/common/utils/build_config.dart';
import 'package:sideswap/desktop/desktop_app_main.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:args/args.dart';
import 'package:window_manager/window_manager.dart';

bool isDesktop() {
  return Platform.isLinux ||
      Platform.isMacOS ||
      Platform.isWindows ||
      Platform.isFuchsia;
}

bool isMobile() {
  return Platform.isAndroid || Platform.isIOS;
}

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isDesktop()) {
    await windowManager.ensureInitialized();
  }

  var runMobile = false;
  final parser = ArgParser();
  parser.addOption('mode');
  final results = parser.parse(args);
  if (results['mode'] == 'mobile') {
    runMobile = true;
  }

  if (runMobile && isDesktop() || isMobile()) {
    if (isDesktop()) {
      windowManager.waitUntilReadyToShow().then((_) async {
        // Hide window title bar
        // await windowManager.setTitleBarStyle('hidden');
        await windowManager.setMinimumSize(const Size(400, 800));
        await windowManager.setSize(const Size(400, 800));
        await windowManager.center();
        await windowManager.show();
        await windowManager.setSkipTaskbar(false);
      });
    }
  } else {
    windowManager.waitUntilReadyToShow().then((_) async {
      // Hide window title bar
      // await windowManager.setTitleBarStyle('hidden');
      await windowManager.setMinimumSize(const Size(1072, 880));
      await windowManager.setSize(const Size(1072, 880));
      await windowManager.center();
      await windowManager.show();
      await windowManager.setSkipTaskbar(false);
    });
  }

  await EasyLocalization.ensureInitialized();

  if (runMobile && isDesktop() || isMobile()) {
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
    return;
  }

  FlavorConfig(
    flavor: Flavor.production,
    values: FlavorValues(
      enableOnboardingUserFeatures: false,
      enableNetworkSettings: true,
      isDesktop: isDesktop(),
    ),
  );

  runApp(const DesktopAppMain());
}
