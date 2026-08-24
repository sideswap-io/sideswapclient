import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/mnemonic_table_provider.dart';

class MnemonicTable extends HookConsumerWidget {
  const MnemonicTable({
    super.key,
    required this.onCheckField,
    this.onTapIndex,
    required this.onCheckError,
    required this.currentIndex,
  });

  final bool Function(int index) onCheckField;
  final void Function(int index)? onTapIndex;
  final bool Function(int index) onCheckError;
  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const itemWidth = 109.0;
    const itemHeight = 39.0;

    final itemsCount = ref.watch(mnemonicWordsCounterProvider);

    return GridView.count(
      crossAxisCount: 3,
      addRepaintBoundaries: false,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      childAspectRatio: itemWidth / itemHeight - 0.16,
      children: List.generate(itemsCount, (index) {
        final correctField = onCheckField(index);
        return Consumer(
          builder: (context, ref, child) {
            final wordItem = ref
                .watch(mnemonicWordItemsProvider.notifier)
                .word(index);

            return Center(
              child: GestureDetector(
                onTap: () {
                  if (onTapIndex != null) {
                    onTapIndex!(index);
                  }
                },
                child: Container(
                  width: itemWidth,
                  height: itemHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: correctField
                        ? const Color(0xFF23729D)
                        : Colors.transparent,
                    border: Border.all(
                      color: !correctField && wordItem.word.isNotEmpty
                          ? SideSwapColors.bitterSweet
                          : currentIndex == index
                          ? SideSwapColors.brightTurquoise
                          : Color(0xFF23729D),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: SizedBox(
                          width: 17,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Consumer(
                            builder: (context, ref, child) {
                              final wordItem = ref
                                  .watch(mnemonicWordItemsProvider.notifier)
                                  .word(index);
                              return Text(
                                wordItem.word,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color:
                                      wordItem.isCorrect ||
                                          currentIndex == index
                                      ? Colors.white
                                      : SideSwapColors.bitterSweet,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
