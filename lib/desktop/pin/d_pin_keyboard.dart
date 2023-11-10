import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/providers/pin_keyboard_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';

final pinKeyboardIndexProvider =
    ChangeNotifierProvider.autoDispose<PinKeyboardIndexProvider>(
        (ref) => PinKeyboardIndexProvider(ref));

class PinKeyboardIndexProvider extends ChangeNotifier {
  final Ref ref;

  PinKeyboardIndexProvider(this.ref);

  int _pinIndex = 0;
  int get pinIndex => _pinIndex;
  set pinIndex(int value) {
    _pinIndex = value;
    notifyListeners();
  }
}

class DPinKeyboard extends HookConsumerWidget {
  const DPinKeyboard({
    super.key,
    this.width,
    this.height,
    this.acceptType = PinKeyboardAcceptType.icon,
  });

  final PinKeyboardAcceptType acceptType;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var itemWidth = 106.0;
    var itemHeight = 44.0;

    if (width != null) {
      itemWidth = width! * 30.8139;
    }

    if (height != null) {
      itemHeight = height! * 21.3592;
    }

    final defaultButtonStyle = ref
        .read(desktopAppThemeProvider)
        .buttonThemeData
        .defaultButtonStyle
        ?.merge(
          DButtonStyle(
            border: ButtonState.resolveWith(
              (states) {
                return const BorderSide(color: Color(0xFF5F9EC4), width: 1);
              },
            ),
            textStyle: ButtonState.all(
              const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: SideSwapColors.brightTurquoise,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );

    final defaultEnterButtonStyle = ref
        .read(desktopAppThemeProvider)
        .buttonThemeData
        .filledButtonStyle
        ?.merge(
          DButtonStyle(
            textStyle: ButtonState.all(
              const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );

    return SizedBox(
      width: 344,
      height: 208,
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 13,
        childAspectRatio: itemWidth / itemHeight,
        children: List.generate(12, (index) {
          DButtonStyle? buttonStyle = defaultButtonStyle;
          Widget child = Container();
          switch (index) {
            case 9:
              child = const Icon(
                Icons.backspace_outlined,
                color: SideSwapColors.brightTurquoise,
                size: 24,
              );
              break;
            case 10:
              child = const Text('0');
              break;
            case 11:
              buttonStyle = defaultEnterButtonStyle;
              const textStyle = TextStyle(
                fontSize: 14,
              );

              switch (acceptType) {
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

              break;
            default:
              child = Text('${index + 1}');
          }

          return DAnimatedPinButton(
            itemWidth: itemWidth,
            itemHeight: itemHeight,
            buttonStyle: buttonStyle,
            index: index,
            child: child,
          );
        }),
      ),
    );
  }
}

class DAnimatedPinButton extends HookConsumerWidget {
  const DAnimatedPinButton({
    super.key,
    required this.itemWidth,
    required this.itemHeight,
    required this.buttonStyle,
    required this.child,
    required this.index,
  });

  final double itemWidth;
  final double itemHeight;
  final DButtonStyle? buttonStyle;
  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 160));

    final beginColor =
        buttonStyle?.backgroundColor?.resolve({ButtonStates.pressing});

    final color = ColorTween(begin: beginColor, end: Colors.transparent)
        .animate(controller);

    controller.forward();

    ref.listen(pinKeyboardIndexProvider, (_, next) {
      final pinIndex = ref.watch(pinKeyboardIndexProvider).pinIndex;
      int simulateIndex = pinIndex == 0 ? 10 : pinIndex - 1;
      if (index == simulateIndex) {
        controller.reset();
        controller.forward();
      }
    });

    return DCustomTextBigButton(
      width: itemWidth,
      height: itemHeight,
      padding: EdgeInsets.zero,
      onPressed: () {
        ref.read(pinKeyboardProvider).keyPressed(index);
        ref.watch(pinKeyboardIndexProvider).pinIndex = index + 1;
      },
      style: buttonStyle,
      child: AnimatedBuilder(
        animation: color,
        builder: (_, __) {
          return Container(
            decoration: ShapeDecoration(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              color: color.value,
            ),
            child: Center(child: child),
          );
        },
      ),
    );
  }
}
