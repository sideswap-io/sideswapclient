import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/theme.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/lang_selector.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/select_env_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/settings/settings_network.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

class FirstLaunchPage extends HookConsumerWidget {
  const FirstLaunchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(selectEnvDialogProvider, (_, next) async {
      if (next) {
        ref.read(selectEnvDialogProvider.notifier).setSelectEnvDialog(false);
        ref
            .read(pageStatusNotifierProvider.notifier)
            .setStatus(Status.selectEnv);
      }
    });

    final locale = ref.watch(localesNotifierProvider);

    useEffect(() {
      if (locale == 'zh') {
        Future.microtask(() {
          ref
              .read(networkSettingsNotifierProvider.notifier)
              .setModel(
                const NetworkSettingsModelApply(
                  settingsNetworkType: SettingsNetworkType.sideswapChina,
                  env: SIDESWAP_ENV_PROD,
                ),
              );
          ref.read(networkSettingsNotifierProvider.notifier).save();
        });
      }

      return;
    }, [locale]);

    useEffect(() {
      Future.microtask(() => ref.invalidate(firstLaunchStateNotifierProvider));

      return;
    }, const []);

    final serverLoginState = ref.watch(serverLoginNotifierProvider);

    return SideSwapScaffold(
      key: ValueKey(locale),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap:
                                ref.read(selectEnvTapProvider.notifier).setTap,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.0),
                                  child: Directionality(
                                    textDirection: ui.TextDirection.ltr,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        LangSelector(),
                                        Spacer(),
                                        FirstLaunchNetworkSettingsButton(),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 132,
                                  height: 130,
                                  child: SvgPicture.asset('assets/logo.svg'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Text(
                                    'Welcome in SideSwap'.tr(),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    'SideSwap is the easiest way to send, receive and swap on the Liquid network.'
                                        .tr(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                ...switch (serverLoginState) {
                                  ServerLoginStateError() => [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 48),
                                      child: Text(
                                        'Connection issues detected. Check your network connection and restart the app.'
                                            .tr(),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          color: SideSwapColors.bitterSweet,
                                        ),
                                      ),
                                    ),
                                  ],
                                  _ => [const SizedBox()],
                                },
                              ],
                            ),
                          ),
                          Expanded(child: Container()),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: CustomBigButton(
                              width: double.infinity,
                              height: 54,
                              enabled:
                                  serverLoginState is! ServerLoginStateError,
                              text: 'CREATE NEW WALLET'.tr(),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              onPressed: () async {
                                ref
                                    .read(
                                      firstLaunchStateNotifierProvider.notifier,
                                    )
                                    .setFirstLaunchState(
                                      const FirstLaunchStateCreateWallet(),
                                    );

                                await ref
                                    .read(walletProvider)
                                    .setReviewLicenseCreateWallet();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: CustomBigButton(
                              width: double.infinity,
                              height: 54,
                              enabled:
                                  serverLoginState is! ServerLoginStateError,
                              text: 'IMPORT WALLET'.tr(),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: Colors.transparent,
                              side: const BorderSide(
                                color: SideSwapColors.brightTurquoise,
                                width: 1,
                              ),
                              onPressed: () {
                                ref
                                    .read(
                                      firstLaunchStateNotifierProvider.notifier,
                                    )
                                    .setFirstLaunchState(
                                      const FirstLaunchStateImportWallet(),
                                    );
                                ref
                                    .read(walletProvider)
                                    .setReviewLicenseImportWallet();
                              },
                            ),
                          ),
                          if (FlavorConfig.enableJade) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 23),
                              child: CustomBigButton(
                                width: double.infinity,
                                height: 54,
                                enabled:
                                    serverLoginState is! ServerLoginStateError,
                                backgroundColor: Colors.transparent,
                                side: const BorderSide(
                                  color: SideSwapColors.brightTurquoise,
                                  width: 1,
                                ),
                                onPressed: () async {
                                  ref
                                      .read(pageStatusNotifierProvider.notifier)
                                      .setStatus(
                                        Status.jadeBluetoothPermission,
                                      );
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          SvgPicture.asset(
                                            'assets/jade.svg',
                                            width: 24,
                                            height: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'JADE',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FirstLaunchNetworkSettingsButton extends ConsumerWidget {
  const FirstLaunchNetworkSettingsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle =
        ref
            .watch(mobileAppThemeNotifierProvider)
            .firstLaunchNetworkSettingsButtonTheme
            .style;

    return SizedBox(
      height: 39,
      child: TextButton(
        style: buttonStyle,
        onPressed: () async {
          await showDialog<void>(
            useRootNavigator: true,
            barrierDismissible: false,
            context: context,
            builder: (_) => const SettingsNetwork(),
          );
        },
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset('assets/network.svg'),
            ),
            const SizedBox(width: 10),
            Text('Network'.tr()),
          ],
        ),
      ),
    );
  }
}
