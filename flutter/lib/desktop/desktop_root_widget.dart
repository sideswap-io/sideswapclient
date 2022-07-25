import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/desktop/pin/d_pin_protection.dart';
import 'package:sideswap/desktop/route_generator.dart';
import 'package:sideswap/listeners/pin_listener.dart';
import 'package:sideswap/models/init_provider.dart';
import 'package:sideswap/models/local_notifications_service.dart';
import 'package:sideswap/models/pin_protection_provider.dart';
import 'package:sideswap/models/select_env_provider.dart';
import 'package:sideswap/models/wallet.dart';

class DesktopRootWidget extends ConsumerStatefulWidget {
  const DesktopRootWidget({super.key});

  @override
  ConsumerState<DesktopRootWidget> createState() => _DesktopRootWidgetState();
}

class _DesktopRootWidgetState extends ConsumerState<DesktopRootWidget> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    ref.read(walletProvider).navigatorKey = _navigatorKey;
    ref.read(pinProtectionProvider).onPinBlockadeCallback = onPinBlockade;
    ref.read(localNotificationsProvider).init();
  }

  Future<bool> onPinBlockade(String? title, bool showBackButton,
      PinKeyboardAcceptType iconType) async {
    final ret = await showDialog<bool>(
      context: ref.read(walletProvider).navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Material(
          child: DPinProtection(
            title: title,
            showBackButton: showBackButton,
            iconType: iconType,
          ),
        );
      },
    );
    ref.read(pinProtectionProvider).deinit();
    return ret ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const PinListener(),
        const RouteContainer(),
        // TODO: WillPopScope is needed here? Check this
        WillPopScope(
          onWillPop: () async {
            // https://github.com/flutter/flutter/issues/66349
            final ret = await _navigatorKey.currentState?.maybePop() ?? false;
            return !ret;
          },
          child: Navigator(
            key: _navigatorKey,
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
            onUnknownRoute: RouteGenerator.errorRoute,
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final initProviderValue = ref.watch(initProvider);
            return initProviderValue.map(data: (_) {
              final env = ref.watch(selectEnvProvider).startupEnv;
              return Visibility(
                visible: env != 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
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
              );
            }, loading: (_) {
              logger.d('loading');
              return Container();
            }, error: (_) {
              logger.e('Env error :${_.error.toString()}');
              return Container();
            });
          },
        ),
      ],
    );
  }
}
