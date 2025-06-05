import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_toggle_switch_button.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_mnemonic_table.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_mnemonic_text_box.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/providers/mnemonic_table_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class PasteMnemonicIntent extends Intent {
  const PasteMnemonicIntent();
}

class PasteMnemonicAction extends Action<PasteMnemonicIntent> {
  PasteMnemonicAction(this.context, this.ref);

  final BuildContext context;
  final WidgetRef ref;

  @override
  void invoke(covariant PasteMnemonicIntent intent) async {
    final pastedData = await Clipboard.getData('text/plain');
    final value = pastedData?.text;
    if (value == null) {
      return;
    }
    final words = value.split(' ');
    if (words.length != 12 && words.length != 24) {
      return;
    }

    final wordItems = Map<int, WordItem>.fromEntries(
      List.generate(
        words.length,
        (index) =>
            MapEntry(index, WordItem(word: words[index], isCorrect: false)),
      ),
    );
    ref.read(mnemonicWordItemsNotifierProvider.notifier).setItems(wordItems);
    await ref
        .read(mnemonicWordItemsNotifierProvider.notifier)
        .validateAllItems();
    final index = ref
        .read(mnemonicWordItemsNotifierProvider.notifier)
        .maxIndex();
    ref.read(currentMnemonicIndexNotifierProvider.notifier).setIndex(index);
    final mnemonicIsValid = ref
        .watch(mnemonicWordItemsNotifierProvider.notifier)
        .mnemonicIsValid();
    if (mnemonicIsValid) {
      ref.read(mnemonicWordItemsNotifierProvider.notifier).importMnemonic();
    }
  }
}

class DWalletImport extends HookConsumerWidget {
  const DWalletImport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode(skipTraversal: true);

    ref.listen(mnemonicWordsCounterNotifierProvider, (_, _) {
      focusNode.requestFocus();
    });
    final mnemonicCounter = ref.watch(mnemonicWordsCounterNotifierProvider);

    useEffect(() {
      focusNode.requestFocus();
      return null;
    }, [focusNode]);

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        if (Platform.isLinux || Platform.isFuchsia) ...{
          LogicalKeySet(
            LogicalKeyboardKey.control,
            LogicalKeyboardKey.shift,
            LogicalKeyboardKey.keyV,
          ): const PasteMnemonicIntent(),
        },
        if (Platform.isWindows) ...{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyV):
              const PasteMnemonicIntent(),
        },
        if (Platform.isMacOS) ...{
          LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyV):
              const PasteMnemonicIntent(),
        },
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          PasteMnemonicIntent: PasteMnemonicAction(context, ref),
        },
        child: SideSwapPopupPage(
          onClose: () {
            ref.read(walletProvider).goBack();
          },
          constraints: const BoxConstraints(maxWidth: 628),
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
              height: mnemonicCounter == 12 ? 350 : 540,
              child: Consumer(
                builder: (context, ref, _) {
                  final currentItem = ref.watch(
                    currentMnemonicIndexNotifierProvider,
                  );
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
                                      .read(
                                        mnemonicWordsCounterNotifierProvider
                                            .notifier,
                                      )
                                      .set12Words();
                                } else {
                                  ref
                                      .read(
                                        mnemonicWordsCounterNotifierProvider
                                            .notifier,
                                      )
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
                          itemsCount: ref
                              .read(mnemonicWordItemsNotifierProvider.notifier)
                              .length(),
                          itemSelected: currentItem,
                          onPressed: (index) async {
                            await ref
                                .read(
                                  mnemonicWordItemsNotifierProvider.notifier,
                                )
                                .validateAllItems();
                            ref
                                .read(
                                  currentMnemonicIndexNotifierProvider.notifier,
                                )
                                .setIndex(index);
                            focusNode.requestFocus();
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DButton(
                            onPressed: () {
                              Actions.maybeInvoke<PasteMnemonicIntent>(
                                context,
                                const PasteMnemonicIntent(),
                              );
                            },
                            child: SizedBox(
                              height: 34,
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/paste.svg',
                                      width: 20,
                                      height: 20,
                                      colorFilter: const ColorFilter.mode(
                                        SideSwapColors.brightTurquoise,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('Paste mnemonic'.tr()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                    ],
                  );
                },
              ),
            ),
          ),
          actions: [
            Center(
              child: Consumer(
                builder: ((context, ref, child) {
                  final mnemonicIsValid = ref
                      .watch(mnemonicWordItemsNotifierProvider.notifier)
                      .mnemonicIsValid();
                  return DCustomFilledBigButton(
                    onPressed: mnemonicIsValid
                        ? () {
                            ref
                                .read(
                                  mnemonicWordItemsNotifierProvider.notifier,
                                )
                                .importMnemonic();
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
            ),
          ],
        ),
      ),
    );
  }
}
