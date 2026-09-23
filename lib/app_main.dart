import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/theme.dart';
import 'package:sideswap/desktop/home/listeners/conversion_rates_listener.dart';
import 'package:sideswap/desktop/home/listeners/portfolio_prices_listener.dart';
import 'package:sideswap/listeners/app_lifecycle_wallet_listener.dart';
import 'package:sideswap/listeners/jade_status_listener.dart';
import 'package:sideswap/listeners/pin_listener.dart';
import 'package:sideswap/listeners/proxy_settings_listener.dart';
import 'package:sideswap/listeners/send_asset_listener.dart';
import 'package:sideswap/listeners/server_login_error_listener.dart';
import 'package:sideswap/listeners/sideswap_notification_listener.dart';
import 'package:sideswap/listeners/swaption_notification_listener.dart';
import 'package:sideswap/listeners/ui_states_listener.dart';
import 'package:sideswap/listeners/universal_link_listener.dart';
import 'package:sideswap/listeners/warmup_app_listener.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/local_notifications_service.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/route_providers.dart';
import 'package:sideswap/providers/universal_link_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/background/preload_background_painter.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pin/pin_protection.dart';

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PreloadBackgroundPainter(),
      child: EasyLocalization(
        useOnlyLangCode: true,
        supportedLocales: supportedLocales(),
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      if (!FlavorConfig.isFdroid) {
        ref.read(localNotificationsProvider).init();
      }
      ref.read(universalLinkProvider).handleIncomingLinks();
      ref.read(universalLinkProvider).handleInitialUri();
      return null;
    }, const []);

    final locale = context.locale.languageCode;
    useEffect(() {
      var cancelled = false;
      Future.microtask(() {
        if (!cancelled) {
          ref.read(localesProvider.notifier).setSelectedLang(locale);
        }
      });
      return () => cancelled = true;
    }, [locale]);

    final mobileThemeData = ref.watch(mobileAppThemeProvider);

    return MaterialApp(
      title: 'SideSwap',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: mobileThemeData.mode,
      darkTheme: ThemeData(
        brightness: mobileThemeData.brightness,
        textTheme: mobileThemeData.textTheme,
        colorScheme: mobileThemeData.darkScheme,
        scaffoldBackgroundColor: mobileThemeData.scaffoldBackgroundColor,
        textSelectionTheme: mobileThemeData.textSelectionTheme,
        scrollbarTheme: mobileThemeData.scrollbarTheme,
        textButtonTheme: mobileThemeData.textButtonTheme,
        extensions: mobileThemeData.themeExtensions,
      ),
      builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: widget!,
        );
      },
      home: RootWidget(),
    );
  }
}

/// Hands a system back gesture down to the nested navigator.
///
/// The root [PopScope] sits on the root route, and the navigator below owns
/// its own routes, so a screen inside that navigator never sees the gesture.
/// Forward it only while the stack below cannot pop: then [NavigatorState
/// .maybePop] reaches that screen's handler without removing a page the
/// pages list still holds.
void handleRootPopInvoked(bool didPop, GlobalKey<NavigatorState> navigatorKey) {
  if (didPop) {
    return;
  }

  final navigator = navigatorKey.currentState;
  if (navigator != null && !navigator.canPop()) {
    navigator.maybePop();
  }
}

class MyPopupPage<T> extends Page<T> {
  const MyPopupPage({required this.child});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return MyPopupPageRoute<T>(page: this);
  }
}

class MyPopupPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  MyPopupPageRoute({required MyPopupPage<T> page}) : super(settings: page);

  MyPopupPage<T> get _page => settings as MyPopupPage<T>;

  @override
  Widget buildContent(BuildContext context) {
    return _page.child;
  }

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  bool get fullscreenDialog => false;
}

class RootWidget extends HookConsumerWidget {
  const RootWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );

      Future<bool> onPinBlockade(
        String? title,
        bool backButton,
        PinKeyboardAcceptType iconType,
      ) async {
        // Before the dialog is built, never from inside its build.
        ref.read(pinProtectionHelperProvider).init();
        final ret = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return PinProtection(title: title, iconType: iconType);
          },
        );
        ref.read(pinProtectionHelperProvider).deinit();
        return ret ?? false;
      }

      ref.read(pinProtectionHelperProvider).onPinBlockadeCallback =
          onPinBlockade;

      return;
    }, const []);

    final navigatorKey = ref.watch(navigatorKeyProvider);

    return Stack(
      children: [
        const ServerLoginErrorListener(),
        const AppLifecycleWalletListener(),
        const ProxySettingsListener(),
        const SendAssetIdListener(),
        const ConversionRatesListener(),
        const PortfolioPricesListener(),
        const PinListener(),
        const UiStatesListener(),
        const SideswapNotificationListener(),
        const SwaptionNotificationListener(),
        const JadeStatusListener(),
        const WarmupAppListener(),
        const UniversalLinkListener(),
        PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) =>
              handleRootPopInvoked(didPop, navigatorKey),
          child: Consumer(
            builder: (context, ref, child) {
              final mobileRoutePage = ref.watch(mobileRoutePageProvider);

              return Navigator(
                key: navigatorKey,
                onDidRemovePage: (page) {},
                pages: mobileRoutePage.pages(),
              );
            },
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final env = ref.watch(envProvider);
            return switch (env) {
              0 => const SizedBox(),
              _ => Align(
                alignment: Alignment.topCenter,
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),
                    child: Text(
                      envName(env),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            };
          },
        ),
      ],
    );
  }
}
