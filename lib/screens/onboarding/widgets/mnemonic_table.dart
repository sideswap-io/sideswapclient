import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';

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
    final itemWidth = 109.w;
    final itemHeight = 39.h;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        width: double.maxFinite,
        height: 15.h * words.length,
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
                      borderRadius: BorderRadius.circular(8.w),
                      color: correctField
                          ? const Color(0xFF23729D)
                          : Colors.transparent,
                      border: Border.all(
                        color: onCheckError(index)
                            ? Colors.red
                            : currentSelectedItem == index
                                ? const Color(0xFF00C5FF)
                                : const Color(0xFF23729D),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 6.w),
                          child: SizedBox(
                            width: 16.w,
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF00C5FF),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 3.w),
                            child: ValueListenableBuilder(
                              valueListenable: words[index],
                              builder: (_, String __, ___) => Text(
                                words[index].value,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.roboto(
                                  fontSize: 13.sp,
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
      ),
    );
  }
}
