import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/button/d_radio_button.dart';
import 'package:sideswap/desktop/common/d_focus.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_new_wallet_backup_logo_background.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';

import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/models/wallet.dart';

class DNewWalletBackupCheck extends ConsumerWidget {
  const DNewWalletBackupCheck({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopupPage(
      onClose: () {
        ref.read(walletProvider).newWalletBackupPrompt();
      },
      backgroundContent: const DNewWalletBackupLogoBackground(),
      constraints: const BoxConstraints(
        maxWidth: 628,
        maxHeight: 529,
      ),
      content: Center(
        child: SizedBox(
          width: 484,
          height: 378,
          child: Column(
            children: [
              Text(
                'Select the correct word'.tr(),
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
                  'Confirm your backup by proving you have the keys available offline'
                      .tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: GridView.count(
                  crossAxisCount: 1,
                  addRepaintBoundaries: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  childAspectRatio: 456 / 55,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: List.generate(4, (index) {
                    return Consumer(
                      builder: (context, ref, _) {
                        final backupCheckAllWords = ref.watch(walletProvider
                            .select((p) => p.backupCheckAllWords));
                        final wordIndices = backupCheckAllWords.keys.toList();
                        final words =
                            backupCheckAllWords[wordIndices[index]] ?? [];

                        return DWordLine(
                          wordIndex: wordIndices[index],
                          words: words,
                          onLineChanged: (wordIndex, index) {
                            ref
                                .read(walletProvider)
                                .backupNewWalletSelect(wordIndex, index);
                            // validate(ref, context);
                          },
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: Consumer(
            builder: ((context, ref, child) {
              final canContinue = ref
                      .watch(walletProvider)
                      .backupCheckSelectedWords
                      .keys
                      .length ==
                  4;
              return DCustomFilledBigButton(
                width: 460,
                height: 49,
                onPressed: canContinue
                    ? () {
                        ref.read(walletProvider).backupNewWalletVerify();
                      }
                    : null,
                child: Text('CONFIRM'.tr()),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class DWordLine extends ConsumerWidget {
  const DWordLine({
    super.key,
    required this.wordIndex,
    this.onLineChanged,
    required this.words,
  });

  final int wordIndex;
  final void Function(int wordIndex, int index)? onLineChanged;
  final List<String> words;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 456,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF165071),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 105,
            height: 39,
            child: Center(
              child: Text(
                'Word #${wordIndex + 1}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF00C5FF),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          ...List.generate(3, (index) {
            return Consumer(
              builder: (context, ref, _) {
                final selectedIndex = ref
                        .watch(walletProvider)
                        .backupCheckSelectedWords[wordIndex] ??
                    -1;
                final checked = selectedIndex == index;
                return DWordRadioButton(
                  checked: checked,
                  word: words[index],
                  onChanged: (value) {
                    onLineChanged?.call(wordIndex, index);
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class DWordRadioButton extends ConsumerWidget {
  const DWordRadioButton({
    super.key,
    this.semanticLabel,
    this.checked = false,
    this.focusNode,
    this.autofocus = false,
    this.onChanged,
    this.style,
    this.word = '',
  });

  final String? semanticLabel;
  final bool checked;
  final FocusNode? focusNode;
  final bool autofocus;
  final ValueChanged<bool>? onChanged;
  final DRadioButtonThemeData? style;
  final String? word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = DRadioButtonThemeData(
      uncheckedDecoration: ButtonState.all(
        BoxDecoration(
          color: const Color(0xFF165071),
          border: Border.all(
            color: const Color(0xFF23729D),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      checkedDecoration: ButtonState.all(
        BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ).merge(this.style);

    final fastAnimationDuration =
        ref.watch(desktopAppThemeProvider).fastAnimationDuration;
    final animationCurve = ref.watch(desktopAppThemeProvider).animationCurve;

    return DHoverButton(
      onPressed: onChanged == null ? null : () => onChanged!(!checked),
      builder: (context, state) {
        final BoxDecoration decoration = (checked
                ? style.checkedDecoration?.resolve(state)
                : style.uncheckedDecoration?.resolve(state)) ??
            const BoxDecoration(shape: BoxShape.rectangle);
        return Semantics(
          label: semanticLabel,
          selected: checked,
          child: DFocusBorder(
            focused: state.isFocused,
            child: AnimatedContainer(
              duration: fastAnimationDuration,
              curve: animationCurve,
              decoration: decoration,
              child: SizedBox(
                width: 109,
                height: 39,
                child: Center(
                  child: Text(
                    "${word?[0]}${word?.substring(1).toLowerCase()}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: checked ? const Color(0xFF002241) : Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
