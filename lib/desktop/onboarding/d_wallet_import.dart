import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_toggle_switch_button.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_mnemonic_table.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_mnemonic_text_box.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/providers/mnemonic_table_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class DWalletImport extends HookConsumerWidget {
  const DWalletImport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode(skipTraversal: true);

    ref.listen(mnemonicWordsCounterProvider, (_, __) {
      focusNode.requestFocus();
    });
    final mnemonicCounter = ref.watch(mnemonicWordsCounterProvider);

    useEffect(() {
      focusNode.requestFocus();
      return null;
    }, [focusNode]);

    return SideSwapPopupPage(
      onClose: () {
        ref.read(walletProvider).goBack();
      },
      constraints: const BoxConstraints(
        maxWidth: 628,
      ),
      title: Text(
        'Enter your recovery phrase'.tr(),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      content: Center(
        child: SizedBox(
            width: 460,
            height: mnemonicCounter == 12 ? 320 : 510,
            child: Consumer(
              builder: (context, ref, _) {
                final currentItem = ref.watch(currentMnemonicIndexProvider);
                return Column(
                  children: [
                    Container(
                      height: 36,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xFF062D44),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DToggleSwitchButton(
                            checked: mnemonicCounter == 12,
                            checkedName: '12 words'.tr(),
                            uncheckedName: '24 words'.tr(),
                            onChanged: (value) {
                              if (value) {
                                ref
                                    .read(mnemonicWordsCounterProvider.notifier)
                                    .set12Words();
                              } else {
                                ref
                                    .read(mnemonicWordsCounterProvider.notifier)
                                    .set24Words();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: DMnemonicTextBox(
                        focusNode,
                        currentIndex: currentItem,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 19),
                      child: DMnemonicTable(
                        height: mnemonicCounter == 12 ? 180 : 370,
                        itemsCount: ref.read(mnemonicTableProvider).length(),
                        itemSelected: currentItem,
                        onPressed: (index) {
                          ref.read(mnemonicTableProvider).validateAllItems();
                          ref
                              .read(currentMnemonicIndexProvider.notifier)
                              .state = index;
                          focusNode.requestFocus();
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                );
              },
            )),
      ),
      actions: [
        Center(
          child: Consumer(
            builder: ((context, ref, child) {
              final mnemonicIsValid =
                  ref.watch(mnemonicTableProvider).mnemonicIsValid();
              return DCustomFilledBigButton(
                onPressed: mnemonicIsValid
                    ? () {
                        ref.read(mnemonicTableProvider).importMnemonic();
                      }
                    : null,
                width: 460,
                height: 49,
                child: Text(
                  'CONTINUE'.tr(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
