import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/button/d_settings_radio_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/settings/d_settings_custom_host.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

class DSettingsNetworkAccess extends ConsumerWidget {
  const DSettingsNetworkAccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeNotifierProvider).settingsDialogTheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
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
        style: const DContentDialogThemeData().merge(settingsDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
      ),
    );
  }
}

class DSettingsNetworkAccessContent extends ConsumerWidget {
  const DSettingsNetworkAccessContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkSettingsModel = ref.watch(networkSettingsNotifierProvider);

    return Center(
      child: SizedBox(
        width: 344,
        height: 509,
        child: Column(
          children: [
            DSettingsRadioButton(
              checked: networkSettingsModel.settingsNetworkType ==
                      SettingsNetworkType.blockstream &&
                  networkSettingsModel.env == SIDESWAP_ENV_PROD,
              onChanged: (value) {
                ref.read(networkSettingsNotifierProvider.notifier).setModel(
                      const NetworkSettingsModelApply(
                        settingsNetworkType: SettingsNetworkType.blockstream,
                        env: SIDESWAP_ENV_PROD,
                      ),
                    );
              },
              content: const Text(
                'Blockstream (Mainnet)',
              ),
            ),
            const SizedBox(height: 10),
            DSettingsRadioButton(
              checked: networkSettingsModel.settingsNetworkType ==
                      SettingsNetworkType.blockstream &&
                  networkSettingsModel.env == SIDESWAP_ENV_TESTNET,
              onChanged: (value) {
                ref.read(networkSettingsNotifierProvider.notifier).setModel(
                      const NetworkSettingsModelApply(
                        settingsNetworkType: SettingsNetworkType.blockstream,
                        env: SIDESWAP_ENV_TESTNET,
                      ),
                    );
              },
              content: const Text(
                'Blockstream (Testnet)',
              ),
            ),
            const SizedBox(height: 10),
            DSettingsRadioButton(
              checked: networkSettingsModel.settingsNetworkType ==
                      SettingsNetworkType.sideswap &&
                  networkSettingsModel.env == SIDESWAP_ENV_PROD,
              onChanged: (value) {
                ref.read(networkSettingsNotifierProvider.notifier).setModel(
                      const NetworkSettingsModelApply(
                        settingsNetworkType: SettingsNetworkType.sideswap,
                        env: SIDESWAP_ENV_PROD,
                      ),
                    );
              },
              content: const Text(
                'SideSwap (Mainnet)',
              ),
            ),
            const SizedBox(height: 10),
            DSettingsRadioButton(
              checked: networkSettingsModel.settingsNetworkType ==
                      SettingsNetworkType.sideswap &&
                  networkSettingsModel.env == SIDESWAP_ENV_TESTNET,
              onChanged: (value) {
                ref.read(networkSettingsNotifierProvider.notifier).setModel(
                      const NetworkSettingsModelApply(
                        settingsNetworkType: SettingsNetworkType.sideswap,
                        env: SIDESWAP_ENV_TESTNET,
                      ),
                    );
              },
              content: const Text(
                'SideSwap (Testnet)',
              ),
            ),
            const SizedBox(height: 10),
            DSettingsRadioButton(
              checked: networkSettingsModel.settingsNetworkType ==
                  SettingsNetworkType.sideswapChina,
              onChanged: (value) {
                ref.read(networkSettingsNotifierProvider.notifier).setModel(
                      const NetworkSettingsModelApply(
                        settingsNetworkType: SettingsNetworkType.sideswapChina,
                        env: SIDESWAP_ENV_PROD,
                      ),
                    );
              },
              content: const Text(
                'SideSwap China (Mainnet)',
              ),
            ),
            const SizedBox(height: 10),
            DSettingsRadioButton(
              trailingIcon: true,
              checked: networkSettingsModel.settingsNetworkType ==
                  SettingsNetworkType.personal,
              onChanged: (value) {
                ref.read(walletProvider).setRegistered();
                Navigator.pushAndRemoveUntil(
                    context,
                    RawDialogRoute<Widget>(
                      pageBuilder: (_, __, ___) => const DSettingsCustomHost(),
                    ),
                    (route) => route.isFirst);
              },
              content: Text(
                'Personal Electrum Server'.tr(),
              ),
            ),
            const Spacer(),
            const SizedBox(height: 16),
            const DSettingsNetworkAccessSaveButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class DSettingsNetworkAccessSaveButton extends ConsumerWidget {
  const DSettingsNetworkAccessSaveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final needSave = ref.watch(networkSettingsNeedSaveProvider);

    return switch (needSave) {
      true => Center(
          child: DCustomTextBigButton(
            width: 266,
            onPressed: () {
              ref.read(desktopDialogProvider).showNeedRestartDialog();
            },
            child: Text(
              'SAVE'.tr(),
            ),
          ),
        ),
      false => const SizedBox(),
    };
  }
}
