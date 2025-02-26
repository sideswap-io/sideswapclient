import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_mnemonic_table.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_new_wallet_backup_logo_background.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/providers/mnemonic_table_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class DNewWalletBackup extends ConsumerStatefulWidget {
  const DNewWalletBackup({super.key});

  @override
  ConsumerState<DNewWalletBackup> createState() => DWalletBackupState();
}

class DWalletBackupState extends ConsumerState<DNewWalletBackup> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final words = ref.read(walletProvider).getMnemonicWords();
      final wordItems = Map<int, WordItem>.fromEntries(
        List.generate(
          words.length,
          (index) =>
              MapEntry(index, WordItem(word: words[index], isCorrect: true)),
        ),
      );
      ref.read(mnemonicWordItemsNotifierProvider.notifier).setItems(wordItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapPopupPage(
      onClose: () {
        ref.read(walletProvider).newWalletBackupPrompt();
      },
      backgroundContent: const DNewWalletBackupLogoBackground(),
      constraints: const BoxConstraints(maxWidth: 628),
      content: Center(
        child: SizedBox(
          width: 484,
          child: Column(
            children: [
              Text(
                'Save your 12 word recovery phrase'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Please ensure you write down and save your 12 word recovery phrase. Without your recovery phrase, there is no way to restore access to your wallet and all balances will be irretrievably lost without recourse.'
                      .tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: DMnemonicTable(enabled: false),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: DCustomFilledBigButton(
            width: 460,
            height: 49,
            onPressed: () {
              ref.read(walletProvider).backupNewWalletCheck();
            },
            child: Text('CONFIRM YOUR WORDS'.tr()),
          ),
        ),
      ],
    );
  }
}
