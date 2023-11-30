import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/network_access_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/settings/settings_custom_host.dart';
import 'package:sideswap/screens/settings/widgets/settings_network_button.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

class SettingsNetwork extends ConsumerStatefulWidget {
  const SettingsNetwork({super.key});

  @override
  SettingsNetworkState createState() => SettingsNetworkState();
}

class SettingsNetworkState extends ConsumerState<SettingsNetwork> {
  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Network access'.tr(),
      ),
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                  child: Column(
                    children: [
                      const SettingsNetworkServerButton(
                        name: 'BlockStream (Mainnet)',
                        buttonNetwork: SettingsNetworkType.blockstream,
                        buttonEnv: SIDESWAP_ENV_PROD,
                      ),
                      const SettingsNetworkServerButton(
                        name: 'BlockStream (Testnet)',
                        buttonNetwork: SettingsNetworkType.blockstream,
                        buttonEnv: SIDESWAP_ENV_TESTNET,
                      ),
                      const SettingsNetworkServerButton(
                        name: 'SideSwap (Mainnet)',
                        buttonNetwork: SettingsNetworkType.sideswap,
                        buttonEnv: SIDESWAP_ENV_PROD,
                      ),
                      const SettingsNetworkServerButton(
                        name: 'SideSwap (Testnet)',
                        buttonNetwork: SettingsNetworkType.sideswap,
                        buttonEnv: SIDESWAP_ENV_TESTNET,
                      ),
                      Consumer(
                        builder: (context, ref, _) {
                          final networkSettingsModel =
                              ref.watch(networkSettingsProvider);

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SettingsNetworkButton(
                              trailingIconVisible: true,
                              value: networkSettingsModel.settingsNetworkType ==
                                  SettingsNetworkType.personal,
                              onChanged: (value) {
                                Navigator.of(context, rootNavigator: true)
                                    .push<void>(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsCustomHost(),
                                  ),
                                );
                              },
                              title: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Personal Electrum Server'.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      const SizedBox(height: 16),
                      const SettingsNetworkSaveButton(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsNetworkSaveButton extends ConsumerWidget {
  const SettingsNetworkSaveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final needSave = ref.watch(networkSettingsNeedSaveProvider);

    return switch (needSave) {
      true => CustomBigButton(
          onPressed: () {
            ref.read(utilsProvider).settingsErrorDialog(
                  title: 'Network changes will take effect on restart'.tr(),
                  icon: SettingsDialogIcon.restart,
                  buttonText: 'OK'.tr(),
                  onPressed: (context) async {
                    Navigator.of(context).pop();
                    await ref.read(networkSettingsProvider.notifier).save();
                  },
                );
          },
          width: double.maxFinite,
          height: 54,
          text: 'SAVE'.tr(),
          backgroundColor: SideSwapColors.brightTurquoise,
          textColor: Colors.white,
        ),
      false => const SizedBox(),
    };
  }
}

class SettingsNetworkServerButton extends HookConsumerWidget {
  const SettingsNetworkServerButton({
    super.key,
    required this.name,
    required this.buttonNetwork,
    required this.buttonEnv,
  });

  final String name;
  final SettingsNetworkType buttonNetwork;
  final int buttonEnv;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkSettingsModel = ref.watch(networkSettingsProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SettingsNetworkButton(
        value: (networkSettingsModel.settingsNetworkType == buttonNetwork &&
            networkSettingsModel.env == buttonEnv),
        onChanged: (value) {
          ref.read(networkSettingsProvider.notifier).setModel(
              NetworkSettingsModelApply(
                  settingsNetworkType: buttonNetwork, env: buttonEnv));
        },
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
