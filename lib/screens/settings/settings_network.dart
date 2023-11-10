import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/network_access_provider.dart';
import 'package:sideswap/providers/network_type_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/settings/settings_custom_host.dart';
import 'package:sideswap/screens/settings/widgets/settings_network_button.dart';

class SettingsNetwork extends ConsumerStatefulWidget {
  const SettingsNetwork({super.key});

  @override
  SettingsNetworkState createState() => SettingsNetworkState();
}

class SettingsNetworkState extends ConsumerState<SettingsNetwork> {
  void showRestartDialog() {
    ref.read(utilsProvider).settingsErrorDialog(
          title: 'Network changes will take effect on restart'.tr(),
          buttonText: 'RESTART APP'.tr(),
          onPressed: (context) {},
          secondButtonText: 'CANCEL'.tr(),
          onSecondPressed: (context) {
            Navigator.of(context).pop();
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Network access'.tr(),
      ),
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
                  child: Consumer(
                    builder: (context, ref, _) {
                      final selectedNetwork = ref.watch(networkTypeProvider);
                      return Column(
                        children: [
                          SettingsNetworkServerButton(
                            name: 'BlockStream (Mainnet)',
                            selectedNetwork: selectedNetwork,
                            buttonNetwork: SettingsNetworkType.blockstream,
                          ),
                          SettingsNetworkServerButton(
                            name: 'SideSwap (Mainnet)',
                            selectedNetwork: selectedNetwork,
                            buttonNetwork: SettingsNetworkType.sideswap,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: SettingsNetworkButton(
                              trailingIconVisible: true,
                              value: selectedNetwork ==
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
                          ),
                        ],
                      );
                    },
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

class SettingsNetworkServerButton extends HookConsumerWidget {
  const SettingsNetworkServerButton(
      {super.key,
      required this.name,
      required this.selectedNetwork,
      required this.buttonNetwork});

  final String name;
  final SettingsNetworkType selectedNetwork;
  final SettingsNetworkType buttonNetwork;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SettingsNetworkButton(
        value: selectedNetwork == buttonNetwork,
        onChanged: (value) {
          ref.read(networkAccessProvider).networkType = buttonNetwork;
          ref.read(walletProvider).applyNetworkChange();
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
