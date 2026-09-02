import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sideswap/app_main.dart';
import 'package:sideswap/common/utils/build_config.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/common/windows_registry.dart';
import 'package:sideswap/desktop/desktop_app_main.dart';
import 'package:sideswap/desktop/desktop_window_size.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:args/args.dart';
import 'package:sideswap_notifications/sideswap_notifications.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_size/window_size.dart' as window_size;

final class MyObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    if (error is ProviderException) {
      // The provider didn't fail directly, but instead depends on a failed provider.
      // The error was therefore already logged.
      return;
    }

    // Log the error
    logger.e('Provider failed: $error');
    logger.d(stackTrace);
  }
}

bool _isMobile() {
  return Platform.isAndroid || Platform.isIOS;
}

bool _isDesktop() {
  return !isMobile();
}

Future<void> startApp(List<String> args, {bool isFdroid = false}) async {
  WidgetsFlutterBinding.ensureInitialized();

  logger.d('Starting app');

  if (_isDesktop()) {
    await windowManager.ensureInitialized();
    await registerProtocol('liquidconnect');
  }

  // arguments are used only in desktop version!
  final parser = ArgParser();
  parser.addFlag('mobileMode', abbr: 'm');
  parser.addFlag('localEndpoint', abbr: 'E');
  parser.addFlag('networkSettings', abbr: 'n', defaultsTo: true);
  parser.addFlag('enableJade', abbr: 'j', defaultsTo: true);

  final results = parser.parse(args);

  final runMobile = results['mobileMode'] as bool;
  final enableLocalEndpoint = results['localEndpoint'] as bool;
  final networkSettings = results['networkSettings'] as bool;
  final enableJade = results['enableJade'] as bool;

  var appScreenSize = const Size(0, 0);

  if (runMobile && _isDesktop() || _isMobile()) {
    if (_isDesktop()) {
      appScreenSize = const Size(400, 800);

      final windowOptions = WindowOptions(
        size: appScreenSize,
        minimumSize: appScreenSize,
        skipTaskbar: false,
        center: true,
      );

      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
      });
    }
  } else {
    // The screens are laid out for this window. On a screen whose work area
    // (screen minus taskbar) is smaller, the window opens to fit the work
    // area instead of ending up under the taskbar.
    appScreenSize = desktopWindowSize;

    final currentScreen = await window_size.getCurrentScreen();
    if (currentScreen == null) {
      logger.w('Current screen unknown, opening at $desktopWindowSize');
    } else {
      final workArea = logicalWorkArea(
        currentScreen,
        workAreaIsPhysical: Platform.isWindows,
      );
      if (workArea == null) {
        logger.w(
          'Unusable screen report '
          '(frame ${currentScreen.frame}, visible ${currentScreen.visibleFrame}, '
          'scale ${currentScreen.scaleFactor}), opening at $desktopWindowSize',
        );
      }
      appScreenSize = desktopWindowSizeFor(workArea);
      logger.i('Work area $workArea, window $appScreenSize');
    }

    final windowOptions = WindowOptions(
      size: appScreenSize,
      minimumSize: appScreenSize,
      skipTaskbar: false,
      center: true,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
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
      LevelMessages.warning => logger.w(
        '[$name] ${object.toString()} ${StackTrace.current}',
      ),
      LevelMessages.error => () {
        logger.e('[$name] ${object.toString()}');
        logger.d(StackTrace.current);
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
        enableNetworkSettings: true,
        enableJade: true,
        enableLocalEndpoint: false,
        isFdroid: isFdroid,
      ),
    );

    final plugin = SideswapNotificationsPlugin(
      androidPlatform: FlavorConfig.isFdroid
          ? AndroidPlatformEnum.fdroid
          : AndroidPlatformEnum.android,
    );
    await plugin.firebaseInitializeApp();

    runApp(
      ProviderScope(
        observers: [MyObserver()],
        overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
        child: const AppMain(),
      ),
    );
    return;
  }

  // desktop app version
  FlavorConfig(
    flavor: Flavor.production,
    values: FlavorValues(
      enableNetworkSettings: networkSettings,
      enableJade: enableJade,
      enableLocalEndpoint: enableLocalEndpoint,
      isDesktop: _isDesktop(),
    ),
  );

  runApp(
    ProviderScope(
      observers: [MyObserver()],
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: const DesktopAppMain(),
    ),
  );
}
