import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/mnemonic_check_row.dart';

class WalletBackupCheck extends ConsumerStatefulWidget {
  const WalletBackupCheck({super.key});

  @override
  WalletBackupCheckState createState() => WalletBackupCheckState();
}

class WalletBackupCheckState extends ConsumerState<WalletBackupCheck> {
  bool _canContinue = false;

  void validate(WidgetRef ref, BuildContext context) {
    final selectedWords = ref.read(walletProvider).backupCheckSelectedWords;

    setState(() {
      _canContinue = selectedWords.length == 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      enableInsideTopPadding: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 38),
              child: SizedBox(
                width: 303,
                height: 29,
                child: Text(
                  'Select the correct word'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Consumer(
                builder: (context, ref, child) {
                  final wordIndices = ref
                      .watch(walletProvider)
                      .backupCheckAllWords
                      .keys
                      .toList();

                  return Column(
                    children: List<Widget>.generate(
                      wordIndices.length,
                      (int index) {
                        final wordIndex = wordIndices[index];
                        final words = ref
                                .read(walletProvider)
                                .backupCheckAllWords[wordIndex] ??
                            [];
                        return Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: MnemonicCheckRow(
                            wordIndex: wordIndex,
                            words: words,
                            onTap: (index) {
                              ref
                                  .read(walletProvider)
                                  .backupNewWalletSelect(wordIndex, index);
                              validate(ref, context);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: CustomBigButton(
                height: 54,
                width: double.maxFinite,
                text: 'CONFIRM'.tr(),
                backgroundColor: SideSwapColors.brightTurquoise,
                onPressed: _canContinue
                    ? () {
                        ref.read(walletProvider).backupNewWalletVerify();
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
