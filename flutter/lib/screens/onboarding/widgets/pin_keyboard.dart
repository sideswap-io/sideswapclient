import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';

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
  final _buttonStyle = const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    color: SideSwapColors.brightTurquoise,
  );

  @override
  Widget build(BuildContext context) {
    const itemWidth = 96;
    const itemHeight = 57;

    return SizedBox(
      width: 319,
      height: 278,
      child: GridView.count(
        crossAxisCount: 3,
        addRepaintBoundaries: false,
        shrinkWrap: false,
        padding: EdgeInsets.zero,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: itemWidth / itemHeight,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(12, (index) {
          Widget child;
          if (index == 9) {
            child = const Icon(
              Icons.backspace_outlined,
              color: SideSwapColors.brightTurquoise,
              size: 28,
            );
          } else if (index == 10) {
            child = Text(
              '0',
              style: _buttonStyle,
            );
          } else if (index == 11) {
            const textStyle = TextStyle(
              fontSize: 18,
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
            color: SideSwapColors.chathamsBlue,
            // elevation: 1,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                ref.read(pinKeyboardProvider).keyPressed(index);
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: const Color(0xFF23729D),
                  ),
                  color: index == 11
                      ? SideSwapColors.brightTurquoise
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
