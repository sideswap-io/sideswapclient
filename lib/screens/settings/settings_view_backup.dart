import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/mnemonic_table.dart';

class SettingsViewBackup extends HookConsumerWidget {
  const SettingsViewBackup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() async {
        await ScreenProtector.protectDataLeakageOn();
      });
      return () {
        Future.microtask(() async {
          await ScreenProtector.protectDataLeakageOff();
        });
      };
    });

    return SideSwapScaffold(
      appBar: CustomAppBar(title: 'Recovery phrase'.tr()),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, _) {
            final mnemonicWords = ref.watch(walletProvider).getMnemonicWords();
            final words = List<ValueNotifier<String>>.generate(
              mnemonicWords.length,
              (index) => ValueNotifier(''),
            );
            var index = 0;
            for (var word in mnemonicWords) {
              words[index].value = word;
              index++;
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Your ${words.length} word recovery phrase is your wallets backup. Write it down and store it somewhere safe, preferably offline.'
                          .tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                MnemonicTable(
                  onCheckError: (index) {
                    return false;
                  },
                  currentSelectedItem: -1,
                  onCheckField: (index) {
                    return true;
                  },
                  words: words,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
