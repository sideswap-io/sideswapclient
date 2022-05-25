import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/pin_keyboard_provider.dart';
import 'package:sideswap/models/pin_protection_provider.dart';

class PinKeyboard extends ConsumerStatefulWidget {
  const PinKeyboard({
    super.key,
    this.acceptType = PinKeyboardAcceptType.icon,
  });

  final PinKeyboardAcceptType acceptType;

  @override
  PinKeyboardState createState() => PinKeyboardState();
}

class PinKeyboardState extends ConsumerState<PinKeyboard> {
  final _buttonStyle = GoogleFonts.roboto(
    fontSize: 26.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF00C5FF),
  );

  @override
  Widget build(BuildContext context) {
    final itemWidth = 96.w;
    final itemHeight = 57.h;

    return SizedBox(
      width: 319.w,
      height: 278.h,
      child: GridView.count(
        crossAxisCount: 3,
        addRepaintBoundaries: false,
        shrinkWrap: false,
        padding: EdgeInsets.zero,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: itemWidth / itemHeight,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(12, (index) {
          Widget child;
          if (index == 9) {
            child = Icon(
              Icons.backspace_outlined,
              color: const Color(0xFF00C5FF),
              size: 28.w,
            );
          } else if (index == 10) {
            child = Text(
              '0',
              style: _buttonStyle,
            );
          } else if (index == 11) {
            final textStyle = GoogleFonts.roboto(
              fontSize: 18.sp,
            );
            switch (widget.acceptType) {
              case PinKeyboardAcceptType.icon:
                child = const Icon(
                  Icons.keyboard_return,
                  color: Colors.white,
                  size: 24,
                );
                break;
              case PinKeyboardAcceptType.enable:
                child = Text(
                  'ENABLE'.tr(),
                  style: textStyle,
                );
                break;
              case PinKeyboardAcceptType.disable:
                child = Text(
                  'DISABLE'.tr(),
                  style: textStyle,
                );
                break;
              case PinKeyboardAcceptType.unlock:
                child = Text(
                  'UNLOCK'.tr(),
                  style: textStyle,
                );
                break;
              case PinKeyboardAcceptType.save:
                child = Text(
                  'SAVE'.tr(),
                  style: textStyle,
                );
                break;
            }
          } else {
            child = Text(
              '${index + 1}',
              style: _buttonStyle,
            );
          }

          return Material(
            color: const Color(0xFF135579),
            // elevation: 1,
            borderRadius: BorderRadius.all(Radius.circular(8.w)),
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                ref.read(pinKeyboardProvider).keyPressed(index);
              },
              borderRadius: BorderRadius.all(Radius.circular(8.w)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.w)),
                  border: Border.all(
                    color: const Color(0xFF23729D),
                  ),
                  color: index == 11
                      ? const Color(0xFF00C5FF)
                      : Colors.transparent,
                ),
                child: Center(
                  child: child,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
