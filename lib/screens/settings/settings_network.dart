import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/numerical_range_formatter.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/common/widgets/sideswap_text_field.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/network_access_tab_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/proxy_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';
import 'package:sideswap/screens/settings/settings_custom_host.dart';
import 'package:sideswap/screens/settings/widgets/settings_checkbox_button.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

class SettingsNetwork extends ConsumerWidget {
  const SettingsNetwork({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkAccessTab = ref.watch(networkAccessTabNotifierProvider);

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
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      SwitchButton(
                        width: constraints.maxWidth - 32,
                        height: 54,
                        backgroundColor: SideSwapColors.chathamsBlue,
                        borderColor: SideSwapColors.chathamsBlue,
                        inactiveToggleBackground: SideSwapColors.chathamsBlue,
                        value: networkAccessTab ==
                            const NetworkAccessTabStateProxy(),
                        activeText: 'Proxy'.tr(),
                        inactiveText: 'Network access server'.tr(),
                        onToggle: (value) {
                          ref
                              .read(networkAccessTabNotifierProvider.notifier)
                              .setNetworkAccessTab(value
                                  ? const NetworkAccessTabStateProxy()
                                  : const NetworkAccessTabStateServer());
                        },
                        activeTextStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 14, color: Colors.white),
                        inactiveTextStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 14, color: Colors.white),
                      ),
                      switch (networkAccessTab) {
                        NetworkAccessTabStateServer() =>
                          const SettingsNetworkAccessServer(),
                        _ =>
                          const Flexible(child: SettingsNetworkAccessProxy()),
                      },
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

class SettingsNetworkAccessProxy extends HookConsumerWidget {
  const SettingsNetworkAccessProxy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostController = useTextEditingController();
    final portController = useTextEditingController();

    final useProxy = ref.watch(useProxyNotifierProvider);

    final validateCallback = useCallback(() {
      final host = hostController.text;
      final port = portController.text;

      if (host.isEmpty && port.isEmpty) {
        ref.read(configurationProvider.notifier).setProxySettings(null);
      } else {
        ref.read(configurationProvider.notifier).setProxySettings(ProxySettings(
            host: host.isEmpty ? null : host, port: int.tryParse(port)));
      }
    }, const []);

    useEffect(() {
      hostController.text =
          ref.read(configurationProvider).proxySettings?.host ?? '';
      portController.text =
          '${ref.read(configurationProvider).proxySettings?.port ?? ''}';

      hostController.addListener(() {
        validateCallback();
      });
      portController.addListener(() {
        validateCallback();
      });

      return;
    }, [hostController, portController]);

    return SizedBox(
      height: 620,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Use proxy'.tr(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.brightTurquoise),
              ),
              FlutterSwitch(
                value: useProxy,
                onToggle: (value) {
                  ref
                      .read(useProxyNotifierProvider.notifier)
                      .setProxyState(value);
                },
                width: 51,
                height: 31,
                toggleSize: 27,
                padding: 2,
                activeColor: SideSwapColors.brightTurquoise,
                inactiveColor: SideSwapColors.prussianBlue,
                toggleColor: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Host',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: SideSwapColors.brightTurquoise),
          ),
          const SizedBox(height: 10),
          SideSwapTextField(
            controller: hostController,
            hintText: '127.0.0.1',
          ),
          const SizedBox(height: 18),
          Text(
            'Port',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: SideSwapColors.brightTurquoise),
          ),
          const SizedBox(height: 10),
          SideSwapTextField(
            controller: portController,
            hintText: 'Range 1-65535'.tr(),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
              NumericalRangeFormatter(min: 1, max: 65535),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsNetworkAccessServer extends StatelessWidget {
  const SettingsNetworkAccessServer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 620,
      child: Column(
        children: [
          const SizedBox(height: 20),
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
          const SettingsNetworkServerButton(
            name: 'SideSwap China (Mainnet)',
            buttonNetwork: SettingsNetworkType.sideswapChina,
            buttonEnv: SIDESWAP_ENV_PROD,
          ),
          Consumer(
            builder: (context, ref, _) {
              final networkSettingsModel =
                  ref.watch(networkSettingsNotifierProvider);

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SettingsCheckboxButton(
                  trailingIconVisible: true,
                  checked: networkSettingsModel.settingsNetworkType ==
                      SettingsNetworkType.personal,
                  onChanged: (value) {
                    Navigator.of(context, rootNavigator: true).push<void>(
                      MaterialPageRoute(
                        builder: (context) => const SettingsCustomHost(),
                      ),
                    );
                  },
                  content: Padding(
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
                  onPressed: (context) {
                    Navigator.of(context).pop();
                    ref.read(networkSettingsNotifierProvider.notifier).save();
                    ref
                        .read(pageStatusNotifierProvider.notifier)
                        .setStatus(Status.registered);
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
    final networkSettingsModel = ref.watch(networkSettingsNotifierProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SettingsCheckboxButton(
        checked: (networkSettingsModel.settingsNetworkType == buttonNetwork &&
            networkSettingsModel.env == buttonEnv),
        onChanged: (value) {
          ref.read(networkSettingsNotifierProvider.notifier).setModel(
              NetworkSettingsModelApply(
                  settingsNetworkType: buttonNetwork, env: buttonEnv));
        },
        content: Padding(
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
