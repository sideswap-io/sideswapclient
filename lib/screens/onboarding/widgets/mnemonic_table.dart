import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class MnemonicTable extends StatelessWidget {
  const MnemonicTable({
    super.key,
    required this.onCheckField,
    this.onTapIndex,
    required this.onCheckError,
    required this.currentSelectedItem,
    required this.words,
  });

  final bool Function(int index) onCheckField;
  final void Function(int index)? onTapIndex;
  final bool Function(int index) onCheckError;
  final int currentSelectedItem;
  final List<ValueNotifier<String>> words;

  @override
  Widget build(BuildContext context) {
    const itemWidth = 109.0;
    const itemHeight = 39.0;

    return SizedBox(
      width: 343.0,
      height: 15.0 * words.length,
      child: GridView.count(
        crossAxisCount: 3,
        addRepaintBoundaries: false,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        childAspectRatio: itemWidth / itemHeight - 0.16,
        children: List.generate(
          words.length,
          (index) {
            final correctField = onCheckField(index);
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
                      color: onCheckError(index)
                          ? Colors.red
                          : currentSelectedItem == index
                              ? SideSwapColors.brightTurquoise
                              : const Color(0xFF23729D),
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
                          child: ValueListenableBuilder(
                            valueListenable: words[index],
                            builder: (_, String __, ___) => Text(
                              words[index].value,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
