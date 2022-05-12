import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_settings_radio_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/settings/d_settings_custom_host.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/models/network_access_provider.dart';
import 'package:sideswap/models/network_type_provider.dart';
import 'package:sideswap/models/wallet.dart';

class DSettingsNetworkAccess extends ConsumerWidget {
  const DSettingsNetworkAccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeProvider).settingsDialogTheme;
    final selectedNetwork = ref.watch(networkTypeProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.read(walletProvider).goBack();
        return false;
      },
      child: DContentDialog(
        title: DContentDialogTitle(
          onClose: () {
            ref.read(walletProvider).goBack();
          },
          content: Text('Network access'.tr()),
        ),
        content: Center(
          child: SizedBox(
            width: 344,
            height: 509,
            child: Column(
              children: [
                DSettingsRadioButton(
                  checked: selectedNetwork == SettingsNetworkType.blockstream,
                  onChanged: (value) {
                    ref.read(networkAccessProvider).networkType =
                        SettingsNetworkType.blockstream;
                    ref.read(walletProvider).applyNetworkChange();
                  },
                  content: Text(
                    'Blockstream'.tr(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: DSettingsRadioButton(
                    checked: selectedNetwork == SettingsNetworkType.sideswap,
                    onChanged: (value) {
                      ref.read(networkAccessProvider).networkType =
                          SettingsNetworkType.sideswap;
                      ref.read(walletProvider).applyNetworkChange();
                    },
                    content: Text(
                      'SideSwap'.tr(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: DSettingsRadioButton(
                    trailingIcon: true,
                    checked: selectedNetwork == SettingsNetworkType.custom,
                    onChanged: (value) {
                      ref.read(walletProvider).setRegistered();
                      Navigator.pushAndRemoveUntil(
                          context,
                          RawDialogRoute<Widget>(
                            pageBuilder: (_, __, ___) =>
                                const DSettingsCustomHost(),
                          ),
                          (route) => route.isFirst);
                    },
                    content: Text(
                      'Personal Electrum Server'.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        style: const DContentDialogThemeData().merge(settingsDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
      ),
    );
  }
}
