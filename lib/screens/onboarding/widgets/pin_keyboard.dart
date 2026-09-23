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
    this.enabled = true,
  });

  final PinKeyboardAcceptType acceptType;

  /// Every key shows the same state as the fields. Each key renders its own
  /// disabled appearance; the grid is not dimmed as one block. ADR-0013
  /// decision 10.
  final bool enabled;

  @override
  PinKeyboardState createState() => PinKeyboardState();
}

class PinKeyboardState extends ConsumerState<PinKeyboard> {
  /// The one way a disabled key is drawn: the enabled colour at half opacity.
  Color _dim(Color color) =>
      widget.enabled ? color : color.withValues(alpha: 0.5);

  TextStyle get _buttonStyle => TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    color: _dim(SideSwapColors.brightTurquoise),
  );

  @override
  Widget build(BuildContext context) {
    const itemWidth = 96;
    const itemHeight = 57;

    final enabled = widget.enabled;
    final borderColor = _dim(const Color(0xFF23729D));
    final keyColor = _dim(SideSwapColors.brightTurquoise);

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
            child = Icon(Icons.backspace_outlined, color: keyColor, size: 28);
          } else if (index == 10) {
            child = Text('0', style: _buttonStyle);
          } else if (index == 11) {
            const textStyle = TextStyle(fontSize: 18);
            switch (widget.acceptType) {
              case PinKeyboardAcceptType.icon:
                child = Icon(
                  Icons.keyboard_return,
                  color: _dim(Colors.white),
                  size: 24,
                );
                break;
              case PinKeyboardAcceptType.enable:
                child = Text('ENABLE'.tr(), style: textStyle);
                break;
              case PinKeyboardAcceptType.disable:
                child = Text('DISABLE'.tr(), style: textStyle);
                break;
              case PinKeyboardAcceptType.unlock:
                child = Text('UNLOCK'.tr(), style: textStyle);
                break;
              case PinKeyboardAcceptType.save:
                child = Text('SAVE'.tr(), style: textStyle);
                break;
            }

            // The word labels take their colour from the ambient text style,
            // which this key does not own, so it dims its own label by opacity
            // rather than by naming a colour. The icon arm names its colour and
            // is dimmed already.
            if (!enabled && widget.acceptType != PinKeyboardAcceptType.icon) {
              child = Opacity(opacity: 0.5, child: child);
            }
          } else {
            child = Text('${index + 1}', style: _buttonStyle);
          }

          return Material(
            color: SideSwapColors.chathamsBlue,
            // elevation: 1,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: InkWell(
              onTap: enabled
                  ? () {
                      HapticFeedback.mediumImpact();
                      ref.read(pinKeyboardHelperProvider).keyPressed(index);
                    }
                  : null,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: borderColor),
                  color: index == 11 ? keyColor : Colors.transparent,
                ),
                child: Center(child: child),
              ),
            ),
          );
        }),
      ),
    );
  }
}
