import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/settings/widgets/d_colored_circular_icon.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/models/wallet.dart';

class DSettingsDeleteWallet extends ConsumerWidget {
  const DSettingsDeleteWallet({super.key});

  void goBack(WidgetRef ref) {
    ref.read(walletProvider).setRegistered();
    ref.read(walletProvider).settingsViewPage();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeProvider).settingsDialogTheme;

    return WillPopScope(
      onWillPop: () async {
        goBack(ref);
        return false;
      },
      child: DContentDialog(
        title: DContentDialogTitle(
          content: Text('Delete wallet'.tr()),
          onClose: () {
            goBack(ref);
          },
        ),
        content: Center(
          child: SizedBox(
            height: 418,
            child: Column(children: [
              const DColoredCircularIcon(),
              Padding(
                padding: const EdgeInsets.only(top: 33),
                child: Text(
                  'Are you sure to delete wallet?'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                child: Text(
                  'Please make sure you have backed up your wallet before proceeding.'
                      .tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ]),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DCustomTextBigButton(
                width: 245,
                height: 44,
                onPressed: () {
                  goBack(ref);
                },
                child: Text(
                  'NO'.tr(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DCustomFilledBigButton(
                  width: 245,
                  height: 44,
                  onPressed: () async {
                    if (await ref.read(walletProvider).isAuthenticated()) {
                      await ref
                          .read(walletProvider)
                          .settingsDeletePromptConfirm();
                    }
                  },
                  child: Text(
                    'YES'.tr(),
                  ),
                ),
              ),
            ],
          ),
        ],
        style: const DContentDialogThemeData().merge(settingsDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
      ),
    );
  }
}
