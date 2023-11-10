import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sideswap/app_main.dart';
import 'package:sideswap/common/utils/build_config.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/desktop_app_main.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:args/args.dart';
import 'package:sideswap_notifications/sideswap_notifications.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_size/window_size.dart' as window_size;

bool _isMobile() {
  return Platform.isAndroid || Platform.isIOS;
}

bool _isDesktop() {
  return !isMobile();
}

Future<void> startApp(List<String> args, {bool isFdroid = false}) async {
  logger.d('Starting app');
  WidgetsFlutterBinding.ensureInitialized();

  if (_isDesktop()) {
    await windowManager.ensureInitialized();
  }

  // arguments are used only in desktop version!
  final parser = ArgParser();
  parser.addFlag('mobileMode', abbr: 'm');
  parser.addFlag('localEndpoint', abbr: 'E');
  parser.addFlag('onboardingUserFeatures', abbr: 'O');
  parser.addFlag('networkSettings', abbr: 'n', defaultsTo: true);
  parser.addFlag('enableJade', abbr: 'j', defaultsTo: true);

  final results = parser.parse(args);

  final runMobile = results['mobileMode'] as bool;
  final enableLocalEndpoint = results['localEndpoint'] as bool;
  final onboardingUserFeatures = results['onboardingUserFeatures'] as bool;
  final networkSettings = results['networkSettings'] as bool;
  final enableJade = results['enableJade'] as bool;

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
    var appScreenSize = const Size(1072, 880);

    // workaround for potato laptop resolution 1366x768
    final currentScreen = await window_size.getCurrentScreen();
    if (currentScreen != null) {
      if (currentScreen.frame.size.height < 880) {
        // a bit lower app height - we don't want to reduce it more
        appScreenSize = const Size(1072, 768);
      }
    }

    windowManager.waitUntilReadyToShow().then((_) async {
      // Hide window title bar
      // await windowManager.setTitleBarStyle('hidden');
      await windowManager.setMinimumSize(appScreenSize);
      await windowManager.setSize(appScreenSize);
      await windowManager.center();
      await windowManager.show();
      await windowManager.setSkipTaskbar(false);
    });
  }

  await EasyLocalization.ensureInitialized();

  customLogPrinter(
    Object object, {
    String? name,
    StackTrace? stackTrace,
    LevelMessages? level,
  }) {
    (switch (level) {
      LevelMessages.debug => logger.d('[$name] ${object.toString()}'),
      LevelMessages.info => logger.i('[$name] ${object.toString()}'),
      LevelMessages.warning => logger.w('[$name] ${object.toString()}'),
      LevelMessages.error => () {
          logger.e('[$name] ${object.toString()}');
          logger.d(stackTrace);
        }(),
      _ => () {
          // do nothing
        }(),
    });
  }

  EasyLocalization.logger.printer = customLogPrinter;

  await Future<void>.delayed(const Duration(seconds: 2));
  final sharedPrefs = await SharedPreferences.getInstance();

  // mobile app version or desktop in mobile mode
  if (runMobile && _isDesktop() || _isMobile()) {
    FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues(
        enableOnboardingUserFeatures: false,
        enableNetworkSettings: true,
        enableJade: false,
        enableLocalEndpoint: false,
        isFdroid: isFdroid,
      ),
    );

    final plugin = SideswapNotificationsPlugin(
        androidPlatform: FlavorConfig.isFdroid
            ? AndroidPlatformEnum.fdroid
            : AndroidPlatformEnum.android);
    await plugin.firebaseInitializeApp();

    runApp(
      ProviderScope(overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ], child: const AppMain()),
    );
    return;
  }

  // desktop app version
  FlavorConfig(
    flavor: Flavor.production,
    values: FlavorValues(
      enableOnboardingUserFeatures: onboardingUserFeatures,
      enableNetworkSettings: networkSettings,
      enableJade: enableJade,
      enableLocalEndpoint: enableLocalEndpoint,
      isDesktop: _isDesktop(),
    ),
  );

  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPrefs),
  ], child: const DesktopAppMain()));
}
