import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_mnemonic_table.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/models/mnemonic_table_provider.dart';
import 'package:sideswap/models/wallet.dart';

class DSettingsViewBackup extends HookConsumerWidget {
  const DSettingsViewBackup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeProvider).settingsDialogTheme;

    useEffect(() {
      Future.microtask(() {
        final words = ref.read(walletProvider).getMnemonicWords();
        final wordItems = Map<int, WordItem>.fromEntries(List.generate(
            words.length,
            (index) => MapEntry(index, WordItem(words[index], true))));
        ref.read(mnemonicWordItemsProvider.notifier).state = wordItems;
      });
      return;
    });

    final wordCount = ref.read(mnemonicWordItemsProvider.notifier).state.length;
    return WillPopScope(
      onWillPop: () async {
        ref.read(walletProvider).goBack();
        return false;
      },
      child: DContentDialog(
        title: DContentDialogTitle(
          content: Text('Recovery phrase'.tr()),
          onClose: () {
            ref.read(walletProvider).goBack();
          },
        ),
        content: Center(
          child: SizedBox(
            height: 430,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text(
                      'Your $wordCount word recovery phrase is your wallets backup. Write it down and store it somewhere safe, preferably offline.'
                          .tr()),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: DMnemonicTable(
                      enabled: false,
                      itemsCount: wordCount,
                      height: 365,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          Center(
            child: DCustomTextBigButton(
              onPressed: () {
                ref.read(walletProvider).goBack();
              },
              child: Text(
                'BACK'.tr(),
              ),
            ),
          ),
        ],
        style: const DContentDialogThemeData().merge(settingsDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580),
      ),
    );
  }
}
