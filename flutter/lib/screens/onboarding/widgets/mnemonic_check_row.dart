import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/wallet.dart';

class MnemonicCheckRow extends ConsumerWidget {
  final int wordIndex;
  final List<String> words;
  final void Function(int) onTap;

  const MnemonicCheckRow({
    super.key,
    required this.wordIndex,
    required this.words,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WORD_HASH'.tr(args: ['${wordIndex + 1}']),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF00C5FF),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SizedBox(
            height: 39,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List<Widget>.generate(
                words.length,
                (int index) {
                  final selectionIndex = ref
                          .read(walletProvider)
                          .backupCheckSelectedWords[wordIndex] ??
                      -1;
                  final isSelected = selectionIndex == index;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        onTap(index);
                      },
                      child: Container(
                        width: 109,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF23729D),
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          color: isSelected ? Colors.white : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            words[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
