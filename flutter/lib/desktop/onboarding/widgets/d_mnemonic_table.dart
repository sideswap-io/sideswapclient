import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/models/mnemonic_table_provider.dart';
import 'package:window_manager/window_manager.dart';

class DMnemonicTable extends StatefulWidget {
  const DMnemonicTable({
    super.key,
    this.itemWidth = 150,
    this.itemHeight = 39,
    this.itemSelected = 0,
    this.onPressed,
    this.width = 460,
    this.height = 190,
    this.itemsCount = 12,
    this.enabled = true,
  });

  final int itemsCount;
  final double width;
  final double height;
  final double itemWidth;
  final double itemHeight;
  final int itemSelected;
  final void Function(int)? onPressed;
  final bool enabled;

  @override
  State<DMnemonicTable> createState() => _DMnemonicTableState();
}

class _DMnemonicTableState extends State<DMnemonicTable> with WindowListener {
  bool isFocused = true;

  @override
  void initState() {
    super.initState();
    WindowManager.instance.addListener(this);
  }

  @override
  void dispose() {
    WindowManager.instance.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowEvent(String eventName) {
    if (eventName == 'blur') {
      setState(() {
        isFocused = false;
      });
    }

    if (eventName == 'focus') {
      setState(() {
        isFocused = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GridView.count(
        crossAxisCount: 3,
        addRepaintBoundaries: false,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        childAspectRatio: widget.itemWidth / widget.itemHeight,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: List.generate(widget.itemsCount, (index) {
          return Consumer(
            builder: ((context, ref, child) {
              final wordItem =
                  ref.watch(mnemonicTableProvider.select((p) => p.word(index)));

              return DButton(
                onPressed: widget.enabled
                    ? () {
                        widget.onPressed?.call(index);
                      }
                    : null,
                style: DButtonStyle(
                  padding: ButtonState.all(EdgeInsets.zero),
                  textStyle: ButtonState.all(
                    GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: ButtonState.resolveWith((states) {
                    if (states.isDisabled) {
                      return const Color(0xFF23729D);
                    }

                    return const Color(0xFF1C6086);
                  }),
                  border: ButtonState.resolveWith((states) {
                    if (states.isDisabled) {
                      return const BorderSide(color: Colors.transparent);
                    }

                    return widget.itemSelected == index
                        ? const BorderSide(color: Color(0xFF00C5FF))
                        : const BorderSide(color: Color(0xFF23729D));
                  }),
                  shape: ButtonState.resolveWith((states) {
                    return const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    );
                  }),
                ),
                child: SizedBox(
                  width: widget.itemWidth,
                  height: widget.itemHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF00C5FF),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ImageFiltered(
                          imageFilter: isFocused
                              ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                              : ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Text(
                            wordItem.word,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: wordItem.correct ||
                                      widget.itemSelected == index
                                  ? Colors.white
                                  : const Color(0xFFFF7878),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
