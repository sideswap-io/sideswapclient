import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/settings/d_settings_network_access.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

class DNetworkAccessOnboarding extends ConsumerWidget {
  const DNetworkAccessOnboarding({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme = ref
        .watch(desktopAppThemeNotifierProvider)
        .defaultDialogTheme;

    return DContentDialog(
      title: DContentDialogTitle(
        onClose: () {
          Navigator.pop(context);
        },
        content: Text('Network access'.tr()),
      ),
      content: const DSettingsNetworkAccessContent(),
      style: const DContentDialogThemeData().merge(defaultDialogTheme),
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 635),
      actions: const [DNetworkAccessOnboardingSaveOrBackButton()],
    );
  }
}

class DNetworkAccessOnboardingSaveOrBackButton extends ConsumerWidget {
  const DNetworkAccessOnboardingSaveOrBackButton({super.key});

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

              final pageStatus = ref.read(pageStatusNotifierProvider);
              if (context.mounted && pageStatus == Status.noWallet) {
                Navigator.of(context).pop();
              }
              return;
            }

            ref.read(networkSettingsNotifierProvider.notifier).applySettings();
            ref.read(walletProvider).sendNetworkSettings();
            Navigator.of(context).pop();
          },
          child: Text('SAVE'.tr()),
        ),
        false => DCustomTextBigButton(
          width: 266,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('BACK'.tr()),
        ),
      },
    );
  }
}
