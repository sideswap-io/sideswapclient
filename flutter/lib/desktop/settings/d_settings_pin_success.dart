import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/settings/widgets/d_colored_circular_icon.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/models/wallet.dart';

class DSettingsPinSuccess extends ConsumerWidget {
  const DSettingsPinSuccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeProvider).settingsDialogTheme;

    return DContentDialog(
      title: DContentDialogTitle(
        onClose: () {
          ref.read(walletProvider).settingsViewPage();
        },
        content: Text('Protect your wallet'.tr()),
      ),
      content: SizedBox(
        height: 418,
        child: Center(
          child: Column(children: [
            const DColoredCircularIcon(
              type: DColoredCircularIconType.success,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                'PIN successfully enabled'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
        ),
      ),
      actions: [
        Center(
          child: DCustomFilledBigButton(
            width: 500,
            onPressed: () {
              ref.read(walletProvider).settingsViewPage();
            },
            child: Text(
              'OK'.tr(),
            ),
          ),
        )
      ],
      style: const DContentDialogThemeData().merge(settingsDialogTheme),
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
    );
  }
}
