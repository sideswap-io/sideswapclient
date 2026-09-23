import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sideswap/app_main.dart';
import 'package:sideswap/common/utils/build_config.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/common/windows_registry.dart';
import 'package:sideswap/desktop/desktop_app_main.dart';
import 'package:sideswap/desktop/desktop_window_geometry_policy.dart';
import 'package:sideswap/desktop/desktop_window_minimum_listener.dart';
import 'package:sideswap/desktop/desktop_window_size.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/desktop_launch_placement_service.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:args/args.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:sideswap_notifications/sideswap_notifications.dart';
import 'package:window_manager/window_manager.dart';

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
  // The first binding constructed in the process wins, so this runs before
  // windowManager.ensureInitialized() and every other binding-dependent call.
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }

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
  DesktopLaunchWindow launchWindow = (workArea: null, chrome: null);

  // The settings store is built before the window, not two seconds after it.
  // The desktop launch reads the stored geometry through `Configuration`, so
  // the store must exist first. ADR-0016 decisions 1 and 8.
  final sharedPrefs = await SharedPreferences.getInstance();

  // The one container the desktop app runs on. It is built inside the desktop
  // branch below and handed to `UncontrolledProviderScope`, so the launch read
  // and the running app share one `Configuration`. The mobile paths return
  // before it is read. ADR-0016 decision 8.
  late final ProviderContainer desktopContainer;

  if (runMobile && _isDesktop() || _isMobile()) {
    if (_isDesktop()) {
      appScreenSize = const Size(400, 800);

      // Null where the launch keeps `center: true`.
      final placementService = _launchPlacementService();

      final windowOptions = WindowOptions(
        size: appScreenSize,
        minimumSize: appScreenSize,
        skipTaskbar: false,
        center: placementService == null,
      );

      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        if (placementService != null) {
          await _placeLaunchWindow(placementService, appScreenSize);
        }
        await windowManager.show();
      });
    }
  } else {
    // `placementService` is null on a platform without a placement channel;
    // `nativeWorkArea` is null when the channel cannot answer. Either way the
    // launch below falls back to `_launchWorkArea` and `center: true`.
    final placementService = _launchPlacementService();
    final nativeWorkArea = placementService == null
        ? null
        : await _nativeLaunchWorkArea(placementService);

    final workArea = nativeWorkArea ?? await _launchWorkArea();
    // Only Linux answers before the window is shown, and only there is the
    // answer wanted at launch: `gtk_window_resize` targets the size without
    // the client-side header bar, so a request equal to the work area
    // produces a window taller than it. ADR-0014 decision 2.
    final decoration = await _linuxDecoration();

    desktopContainer = ProviderContainer(
      observers: [MyObserver()],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        desktopLaunchWindowProvider.overrideWithValue(launchWindow),
      ],
    );

    // Null means the stored geometry is missing, unreadable, or unusable on
    // this display layout. Every such answer takes the launch below through
    // the same path it takes with nothing stored. ADR-0016 decision 4.
    final placement = await _restorePlacement(desktopContainer);

    // The display the window opens on: the one that accepted the stored
    // bounds, or the one the cursor is on. The size, the minimum and
    // `DesktopLaunchWindow.workArea` all come from that one display.
    final targetWorkArea = placement?.workArea.size ?? workArea;
    launchWindow = (workArea: targetWorkArea, chrome: decoration);

    appScreenSize =
        placement?.bounds.size ??
        desktopWindowSizeFor(workArea, decoration: decoration ?? Size.zero);
    final minimum = desktopMinimumSizeFor(
      chrome: decoration,
      workArea: targetWorkArea,
    );
    if (minimum.capped) {
      logger.w(
        'Work area $targetWorkArea is below the supported floor: the window '
        'minimum is ${minimum.size} rather than $desktopFloorClientSize plus '
        'the chrome',
      );
    }
    logger.i(
      'Work area $targetWorkArea, window $appScreenSize, '
      'minimum ${minimum.size}',
    );

    final windowOptions = WindowOptions(
      size: appScreenSize,
      minimumSize: minimum.size,
      skipTaskbar: false,
      // The restore path places the window itself, and so does the placement
      // channel. Centring as well would undo the position either one gives.
      center: placement == null && nativeWorkArea == null,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      if (placement != null) {
        await windowManager.setBounds(placement.bounds);
        if (placement.maximized) {
          await windowManager.maximize();
        }
      } else if (placementService != null && nativeWorkArea != null) {
        // After `waitUntilReadyToShow` applied the option size, which the
        // plugin multiplies by the *creating* view's device pixel ratio. The
        // native call sets the position and the size together, so the target
        // display's own scale wins. It runs before `show()`, so the user
        // never sees the window jump.
        await _placeLaunchWindow(placementService, appScreenSize);
      }
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

  // The container was built before the window, when the launch decision was
  // not made yet. The two overrides are the same two it was built with, which
  // is what `updateOverrides` allows: the value changes, the shape does not.
  desktopContainer.updateOverrides([
    sharedPreferencesProvider.overrideWithValue(sharedPrefs),
    desktopLaunchWindowProvider.overrideWithValue(launchWindow),
  ]);

  runApp(
    UncontrolledProviderScope(
      container: desktopContainer,
      child: const DesktopAppMain(),
    ),
  );
}

/// The placement the stored geometry asks for, or null to launch the way the
/// app launches with nothing stored.
///
/// The geometry is read through `Configuration`, never through the store:
/// nothing outside `Configuration` touches `SharedPreferences`.
/// ADR-0016 decision 1.
///
/// A display that reports no scale factor fails the uniform-scale guard. An
/// unknown scale is not a scale known to match, and a wrong one places the
/// window where the user cannot see it. ADR-0016 decision 3.
Future<DesktopWindowPlacement?> _restorePlacement(
  ProviderContainer container,
) async {
  final stored = container.read(configurationProvider).desktopWindowGeometry;
  if (stored == null) {
    return null;
  }

  final List<DesktopDisplayGeometry> displays;
  try {
    displays = (await screenRetriever.getAllDisplays())
        .map(_displayGeometryOf)
        .toList();
  } catch (e) {
    logger.w('Cannot read the display layout: $e');
    return null;
  }

  final placement = desktopRestorePlacement(
    storedBounds: Rect.fromLTWH(
      stored.left,
      stored.top,
      stored.width,
      stored.height,
    ),
    storedMaximized: stored.maximized,
    displays: displays,
  );

  if (placement == null) {
    logger.i(
      'The stored window geometry $stored is not restored on the displays '
      '$displays: the whole window must lie inside one work area, and every '
      'display must report the same scale factor. Centring the window instead',
    );
  }
  return placement;
}

/// A `screen_retriever` display reduced to what the restore decision reads.
///
/// A display that reports no work area collapses to `Rect.zero`, which the
/// decision skips. A display that reports no scale factor collapses to NaN,
/// which never equals the reference scale.
DesktopDisplayGeometry _displayGeometryOf(Display display) {
  final position = display.visiblePosition;
  final visibleSize = display.visibleSize;
  return (
    workArea: position == null || visibleSize == null
        ? Rect.zero
        : Rect.fromLTWH(
            position.dx,
            position.dy,
            visibleSize.width,
            visibleSize.height,
          ),
    scaleFactor: display.scaleFactor?.toDouble() ?? double.nan,
  );
}

/// The native placement seam on the two desktops that have one, or null
/// where the launch keeps `center: true`.
///
/// Linux is not one of them: `setBounds` reaches `gtk_window_move`, which a
/// window manager may ignore, so placement there is out of scope
/// (ADR-0014 section 14).
DesktopLaunchPlacementService? _launchPlacementService() =>
    Platform.isWindows || Platform.isMacOS
    ? MethodChannelDesktopLaunchPlacementService()
    : null;

/// The work area of the display under the cursor, as the native channel
/// reports it, or null when there is no usable answer.
///
/// Null is a complete answer, not an error: the caller then reads the display
/// layout through `screen_retriever` and centres the window the way the app
/// centred it before the channel existed. ADR-0014 decision 3, as amended
/// by #261.
Future<Size?> _nativeLaunchWorkArea(
  DesktopLaunchPlacementService service,
) async {
  try {
    final workArea = await service.readLaunchWorkArea();
    if (workArea == null) {
      logger.w(
        'The placement channel reported no usable work area; sizing and '
        'centring the window through the display layout instead',
      );
    }
    return workArea;
  } catch (e) {
    logger.w('Cannot read the work area under the cursor: $e');
    return null;
  }
}

/// Places the window of logical size [size] through the native channel, or
/// centres it the way the app centred it before the channel existed.
///
/// The window is never left unplaced: a channel that throws, or that answers
/// that it did not place the window, falls back to `center()`, which is the
/// plugin's own placement — the one ADR-0014 decision 3 describes.
Future<void> _placeLaunchWindow(
  DesktopLaunchPlacementService service,
  Size size,
) async {
  try {
    if (await service.placeLaunchWindow(size)) {
      return;
    }
    logger.w(
      'The placement channel did not place the window; centring it instead',
    );
  } catch (e) {
    logger.w('Cannot place the window under the cursor: $e');
  }
  await windowManager.center();
}

/// The work area of the display `center: true` will place the window on.
///
/// The display is chosen exactly the way `calcWindowPosition` chooses it — the
/// one under the mouse cursor, falling back to the primary — so the display
/// this sizes for and the display the window lands on are the same one.
/// ADR-0014 decision 3.
///
/// Returns null when the platform reports nothing usable. The caller then
/// opens at the floor rather than at the design size, which is the whole
/// point of decision 4: a window smaller than it needs to be is one the user
/// can enlarge.
Future<Size?> _launchWorkArea() async {
  try {
    final primary = _reportOf(await screenRetriever.getPrimaryDisplay());
    final displays = (await screenRetriever.getAllDisplays())
        .map(_reportOf)
        .toList();
    final cursor = await screenRetriever.getCursorScreenPoint();
    final display = desktopDisplayFor(
      displays: displays,
      primary: primary,
      point: cursor,
    );
    return desktopWorkAreaOf(display);
  } catch (e) {
    logger.w('Cannot read the display layout: $e');
    return null;
  }
}

DisplayReport _reportOf(Display display) => (
  visiblePosition: display.visiblePosition,
  size: display.size,
  visibleSize: display.visibleSize,
);

/// The client-side decoration GTK draws outside the size `setSize` takes, or
/// null on every other platform, where the chrome is measured after the first
/// frame instead. ADR-0014 decision 5.
///
/// The toolkit's answer is sanitized rather than trusted: it is read before
/// the window is shown, and a widget GTK has not allocated yet does not
/// report its final height. An implausible answer collapses to zero, which is
/// the correct allowance on a desktop that decorates server-side anyway.
Future<Size?> _linuxDecoration() async {
  if (!Platform.isLinux) {
    return null;
  }

  try {
    final height = await windowManager.getTitleBarHeight();
    final decoration = Size(0, height.toDouble());
    if (!isPlausibleChrome(decoration)) {
      logger.w('Implausible title bar height $height, allowing none');
      return Size.zero;
    }
    return decoration;
  } catch (e) {
    logger.w('Cannot read the title bar height: $e');
    return Size.zero;
  }
}
