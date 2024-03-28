import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:secure_application/secure_application.dart';
import 'package:sideswap/common/theme.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/home/listeners/conversion_rates_listener.dart';
import 'package:sideswap/desktop/home/listeners/portfolio_prices_listener.dart';
import 'package:sideswap/listeners/pin_listener.dart';
import 'package:sideswap/listeners/sideswap_notification_listener.dart';
import 'package:sideswap/listeners/ui_states_listener.dart';
import 'package:sideswap/listeners/warmup_app_listener.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/local_notifications_service.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/route_providers.dart';
import 'package:sideswap/providers/universal_link_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/background/preload_background_painter.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pin/pin_protection.dart';

class AppMain extends StatelessWidget {
  const AppMain({
    super.key,
  });

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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!FlavorConfig.isFdroid) {
      ref.read(localNotificationsProvider).init();
    }
    ref.read(universalLinkProvider).handleIncomingLinks();
    ref.read(universalLinkProvider).handleInitialUri();
  }

  @override
  dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    ref.read(walletProvider).handleAppStateChange(state);
  }

  @override
  Widget build(BuildContext context) {
    final mobileThemeData = ref.watch(mobileAppThemeNotifierProvider);

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
      ),
      builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Builder(builder: (context) {
            return widget!;
          }),
        );
      },
      home: Builder(builder: (context) {
        return SecureApplication(
          nativeRemoveDelay: 100,
          onNeedUnlock: (secureApplicationController) async {
            secureApplicationController?.unlock();
            return SecureApplicationAuthenticationStatus.NONE;
          },
          child: const RootWidget(),
        );
      }),
    );
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
  MyPopupPageRoute({
    required MyPopupPage<T> page,
  }) : super(settings: page);

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
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));

      Future<bool> onPinBlockade(String? title, bool backButton,
          PinKeyboardAcceptType iconType) async {
        final ret = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return PinProtection(
              title: title,
              iconType: iconType,
            );
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
    final serverLoginState = ref.watch(serverLoginNotifierProvider);

    useEffect(() {
      (switch (serverLoginState) {
        ServerLoginStateError(message: String msg) =>
          Future.microtask(() async {
            await ref.read(utilsProvider).showErrorDialog(msg);
            ref.read(walletProvider).cleanupConnectionStates();
            ref.read(warmupAppProvider.notifier).reinitialize();
          }),
        _ => () {}(),
      });

      return;
    }, [serverLoginState]);

    return Stack(
      children: [
        const ConversionRatesListener(),
        const PortfolioPricesListener(),
        const PinListener(),
        const UiStatesListener(),
        const SideswapNotificationListener(),
        const WarmupAppListener(),
        PopScope(
          canPop: false,
          child: Consumer(
            builder: (context, ref, child) {
              final mobileRoutePage = ref.watch(mobileRoutePageProvider);

              return Navigator(
                key: navigatorKey,
                pages: mobileRoutePage.pages(),
                onPopPage: (route, dynamic result) {
                  logger.d('on pop page');
                  if (!route.didPop(result)) {
                    return false;
                  }
                  return true;
                },
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
