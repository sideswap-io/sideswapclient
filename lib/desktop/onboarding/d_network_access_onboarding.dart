import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/numerical_range_formatter.dart';
import 'package:sideswap/common/widgets/sideswap_text_field.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_settings_radio_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/settings/d_settings_custom_host.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/network_access_tab_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/proxy_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

class DNetworkAccessOnboarding extends ConsumerWidget {
  const DNetworkAccessOnboarding({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkAccessTab = ref.watch(networkAccessTabNotifierProvider);
    final defaultDialogTheme = ref
        .watch(desktopAppThemeNotifierProvider)
        .defaultDialogTheme;

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 628, maxHeight: 752),
      style: const DContentDialogThemeData().merge(
        defaultDialogTheme.merge(
          const DContentDialogThemeData(
            titlePadding: EdgeInsets.zero,
            bodyPadding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.all(20),
        child: DContentDialogTitle(
          content: Text('Network access'.tr()),
          onClose: () {
            Navigator.pop(context);
          },
        ),
      ),
      content: SizedBox(
        height: 550,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 84),
          child: Column(
            children: [
              SwitchButton(
                width: 460,
                height: 44,
                backgroundColor: SideSwapColors.chathamsBlue,
                borderColor: SideSwapColors.chathamsBlue,
                inactiveToggleBackground: SideSwapColors.chathamsBlue,
                value: networkAccessTab == const NetworkAccessTabStateProxy(),
                activeText: 'Proxy'.tr(),
                inactiveText: 'Network access server'.tr(),
                onToggle: (value) {
                  ref
                      .read(networkAccessTabNotifierProvider.notifier)
                      .setNetworkAccessTab(
                        value
                            ? const NetworkAccessTabStateProxy()
                            : const NetworkAccessTabStateServer(),
                      );
                },
                activeTextStyle: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.white),
                inactiveTextStyle: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 24),
              switch (networkAccessTab) {
                NetworkAccessTabStateServer() =>
                  const DNetworkAccessOnboardingServer(),
                _ => const DNetworkAccessOnboardingProxy(),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class DNetworkAccessOnboardingServer extends HookConsumerWidget {
  const DNetworkAccessOnboardingServer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkSettingsModel = ref.watch(networkSettingsNotifierProvider);

    return SizedBox(
      height: 482,
      child: Column(
        children: [
          DSettingsRadioButton(
            checked:
                networkSettingsModel.settingsNetworkType ==
                    SettingsNetworkType.blockstream &&
                networkSettingsModel.env == SIDESWAP_ENV_PROD,
            onChanged: (value) {
              ref
                  .read(networkSettingsNotifierProvider.notifier)
                  .setModel(
                    const NetworkSettingsModelApply(
                      settingsNetworkType: SettingsNetworkType.blockstream,
                      env: SIDESWAP_ENV_PROD,
                    ),
                  );
            },
            content: const Text('Blockstream (Mainnet)'),
          ),
          const SizedBox(height: 10),
          DSettingsRadioButton(
            checked:
                networkSettingsModel.settingsNetworkType ==
                    SettingsNetworkType.blockstream &&
                networkSettingsModel.env == SIDESWAP_ENV_TESTNET,
            onChanged: (value) {
              ref
                  .read(networkSettingsNotifierProvider.notifier)
                  .setModel(
                    const NetworkSettingsModelApply(
                      settingsNetworkType: SettingsNetworkType.blockstream,
                      env: SIDESWAP_ENV_TESTNET,
                    ),
                  );
            },
            content: const Text('Blockstream (Testnet)'),
          ),
          const SizedBox(height: 10),
          DSettingsRadioButton(
            checked:
                networkSettingsModel.settingsNetworkType ==
                    SettingsNetworkType.sideswap &&
                networkSettingsModel.env == SIDESWAP_ENV_PROD,
            onChanged: (value) {
              ref
                  .read(networkSettingsNotifierProvider.notifier)
                  .setModel(
                    const NetworkSettingsModelApply(
                      settingsNetworkType: SettingsNetworkType.sideswap,
                      env: SIDESWAP_ENV_PROD,
                    ),
                  );
            },
            content: const Text('SideSwap (Mainnet)'),
          ),
          const SizedBox(height: 10),
          DSettingsRadioButton(
            checked:
                networkSettingsModel.settingsNetworkType ==
                    SettingsNetworkType.sideswap &&
                networkSettingsModel.env == SIDESWAP_ENV_TESTNET,
            onChanged: (value) {
              ref
                  .read(networkSettingsNotifierProvider.notifier)
                  .setModel(
                    const NetworkSettingsModelApply(
                      settingsNetworkType: SettingsNetworkType.sideswap,
                      env: SIDESWAP_ENV_TESTNET,
                    ),
                  );
            },
            content: const Text('SideSwap (Testnet)'),
          ),
          const SizedBox(height: 10),
          DSettingsRadioButton(
            checked:
                networkSettingsModel.settingsNetworkType ==
                SettingsNetworkType.sideswapChina,
            onChanged: (value) {
              ref
                  .read(networkSettingsNotifierProvider.notifier)
                  .setModel(
                    const NetworkSettingsModelApply(
                      settingsNetworkType: SettingsNetworkType.sideswapChina,
                      env: SIDESWAP_ENV_PROD,
                    ),
                  );
            },
            content: const Text('SideSwap China (Mainnet)'),
          ),
          const SizedBox(height: 10),
          DSettingsRadioButton(
            trailingIcon: true,
            checked:
                networkSettingsModel.settingsNetworkType ==
                SettingsNetworkType.personal,
            onChanged: (value) async {
              await Navigator.of(context).push(
                RawDialogRoute<Widget>(
                  pageBuilder: (_, _, _) => const DSettingsCustomHost(),
                ),
              );
            },
            content: Text('Personal Electrum Server'.tr()),
          ),
          const Spacer(),
          DCustomFilledBigButton(
            width: double.infinity,
            onPressed: () async {
              final navigator = Navigator.of(context);
              await ref
                  .read(utilsProvider)
                  .settingsErrorDialog(
                    title: 'Network changes will take effect on restart'.tr(),
                    icon: SettingsDialogIcon.restart,
                    buttonText: 'OK'.tr(),
                    width: 550,
                    onPressed: (context) {
                      Navigator.of(context).pop();
                      ref.read(networkSettingsNotifierProvider.notifier).save();
                    },
                  );
              navigator.pop();
            },
            child: Text('SAVE'.tr()),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class DNetworkAccessOnboardingProxy extends HookConsumerWidget {
  const DNetworkAccessOnboardingProxy({super.key});

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
        ref
            .read(configurationProvider.notifier)
            .setProxySettings(
              ProxySettings(
                host: host.isEmpty ? null : host,
                port: int.tryParse(port),
              ),
            );
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Use proxy'.tr(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SideSwapColors.brightTurquoise,
              ),
            ),
            FlutterSwitch(
              value: useProxy,
              onToggle: (value) {
                ref
                    .read(useProxyNotifierProvider.notifier)
                    .setProxyState(value);
              },
              width: 40,
              height: 22,
              toggleSize: 18,
              padding: 2,
              activeColor: SideSwapColors.brightTurquoise,
              inactiveColor: SideSwapColors.prussianBlue,
              toggleColor: Colors.white,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Host',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: SideSwapColors.brightTurquoise,
          ),
        ),
        const SizedBox(height: 10),
        SideSwapTextField(controller: hostController, hintText: '127.0.0.1'),
        const SizedBox(height: 16),
        Text(
          'Port',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: SideSwapColors.brightTurquoise,
          ),
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
    );
  }
}
