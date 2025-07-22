import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/numerical_range_formatter.dart';
import 'package:sideswap/common/widgets/custom_check_box_row.dart';
import 'package:sideswap/common/widgets/sideswap_text_field.dart';

import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/button/d_settings_radio_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/settings/d_settings_custom_host.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/network_access_tab_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/proxy_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

class DSettingsNetworkAccess extends ConsumerWidget {
  const DSettingsNetworkAccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme = ref
        .watch(desktopAppThemeNotifierProvider)
        .defaultDialogTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      child: DContentDialog(
        title: DContentDialogTitle(
          onClose: () {
            ref.read(walletProvider).goBack();
          },
          content: Text('Network access'.tr()),
        ),
        content: const DSettingsNetworkAccessContent(),
        style: const DContentDialogThemeData().merge(defaultDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 635),
        actions: const [DSettingsNetworkAccessSaveOrBackButton()],
      ),
    );
  }
}

class DSettingsNetworkAccessContent extends ConsumerWidget {
  const DSettingsNetworkAccessContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkAccessTab = ref.watch(networkAccessTabNotifierProvider);

    return Center(
      child: SizedBox(
        width: 344,
        height: 446,
        child: Column(
          children: [
            SwitchButton(
              width: 344,
              height: 36,
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
            switch (networkAccessTab) {
              NetworkAccessTabStateServer() =>
                const DSettingsNetworkAccessServer(),
              _ => const Flexible(child: DSettingsNetworkAccessProxy()),
            },
          ],
        ),
      ),
    );
  }
}

class DSettingsNetworkAccessProxy extends HookConsumerWidget {
  const DSettingsNetworkAccessProxy({super.key});

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

    return SizedBox(
      height: 422,
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
      ),
    );
  }
}

class DSettingsNetworkAccessServer extends ConsumerWidget {
  const DSettingsNetworkAccessServer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkSettingsModel = ref.watch(networkSettingsNotifierProvider);

    return SizedBox(
      width: 344,
      height: 410,
      child: Column(
        children: [
          const SizedBox(height: 10),
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
              await Navigator.of(context).pushAndRemoveUntil(
                RawDialogRoute<Widget>(
                  pageBuilder: (_, _, _) => const DSettingsCustomHost(),
                ),
                (route) => route.isFirst,
              );
            },
            content: Text('Personal Electrum Server'.tr()),
          ),
          const SizedBox(height: 10),
          DSettingsNetworkTestnetServers(),
        ],
      ),
    );
  }
}

class DSettingsNetworkTestnetServers extends HookConsumerWidget {
  const DSettingsNetworkTestnetServers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkSettingsModel = ref.watch(networkSettingsNotifierProvider);

    final isExpanded = useState(switch (networkSettingsModel.env) {
      SIDESWAP_ENV_TESTNET => true,
      _ => false,
    });

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
      initialValue: 0,
    );

    final Animation<double> sizeFactor = useMemoized(() {
      return animationController.drive(CurveTween(curve: Curves.easeIn));
    }, [animationController]);

    useEffect(() {
      if (isExpanded.value) {
        animationController.value = animationController.upperBound;
      }

      return;
    }, const []);

    useEffect(() {
      if (isExpanded.value) {
        animationController.forward();
        return;
      }

      animationController.reverse();
      return;
    }, [isExpanded.value]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCheckBoxRow(
          onChanged: (value) {
            isExpanded.value = value;
          },
          value: isExpanded.value,
          child: Row(
            children: [
              const SizedBox(width: 8),
              Text(
                'Show testnet servers'.tr(),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        SizeTransition(
          sizeFactor: sizeFactor,
          child: ExcludeFocus(
            excluding: !isExpanded.value,
            child: Column(
              children: [
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
                            settingsNetworkType:
                                SettingsNetworkType.blockstream,
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DSettingsNetworkAccessSaveOrBackButton extends ConsumerWidget {
  const DSettingsNetworkAccessSaveOrBackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final needSave = ref.watch(networkSettingsNeedSaveProvider);
    final needRestart = ref.watch(networkSettingsNeedRestartProvider);

    return Center(
      child: switch (needSave) {
        true => DCustomTextBigButton(
          width: 266,
          onPressed: () async {
            if (needRestart) {
              await ref.read(desktopDialogProvider).showNeedRestartDialog();
              return;
            }

            ref.read(networkSettingsNotifierProvider.notifier).applySettings();
            ref.read(walletProvider).sendNetworkSettings();
          },
          child: Text('SAVE'.tr()),
        ),
        false => DCustomTextBigButton(
          width: 266,
          onPressed: () {
            ref.read(walletProvider).goBack();
          },
          child: Text('BACK'.tr()),
        ),
      },
    );
  }
}
