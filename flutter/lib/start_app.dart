import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sideswap/app_main.dart';
import 'package:sideswap/common/utils/build_config.dart';
import 'package:sideswap/common_platform.dart';
import 'package:sideswap/desktop/desktop_app_main.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:args/args.dart';
import 'package:window_manager/window_manager.dart';

bool _isDesktop() {
  return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}

bool _isMobile() {
  return Platform.isAndroid || Platform.isIOS;
}

Future<void> startApp(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_isDesktop()) {
    await windowManager.ensureInitialized();
  }

  var runMobile = false;
  final parser = ArgParser();
  parser.addOption('mode');
  final results = parser.parse(args);
  if (results['mode'] == 'mobile') {
    runMobile = true;
  }

  if (runMobile && _isDesktop() || _isMobile()) {
    if (_isDesktop()) {
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
  final sharedPrefs = await SharedPreferences.getInstance();

  if (runMobile && _isDesktop() || _isMobile()) {
    if (notificationServiceAvailable()) {
      await commonPlatform.firebaseInitializeApp();
    }

    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableOnboardingUserFeatures: false,
        enableNetworkSettings: true,
      ),
    );

    runApp(
      ProviderScope(overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ], child: const AppMain()),
    );
    return;
  }

  FlavorConfig(
    flavor: Flavor.production,
    values: FlavorValues(
      enableOnboardingUserFeatures: false,
      enableNetworkSettings: true,
      isDesktop: _isDesktop(),
    ),
  );

  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPrefs),
  ], child: const DesktopAppMain()));
}
