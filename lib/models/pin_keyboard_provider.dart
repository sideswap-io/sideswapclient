import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/subjects.dart';
import 'package:sideswap/desktop/pin/d_pin_keyboard.dart';

enum PinKey {
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  backspace,
  zero,
  enter,
}

final pinKeyboardProvider =
    Provider<PinKeyboardProvider>((ref) => PinKeyboardProvider(ref));

class PinKeyboardProvider {
  final Ref ref;

  PinKeyboardProvider(this.ref);

  PublishSubject<PinKey> keyPressedSubject = PublishSubject<PinKey>();

  PinKey indexToKey(int index) {
    if (index < 0 || index > PinKey.values.length) {
      return PinKey.backspace;
    }

    return PinKey.values[index];
  }

  void keyPressed(int index) {
    final key = indexToKey(index);

    keyPressedSubject.add(key);
  }

  void onDesktopKeyChanged(String oldValue, String newValue) {
    if (oldValue == newValue) {
      return;
    }

    if (oldValue.length > newValue.length) {
      ref.read(pinKeyboardIndexProvider).pinIndex = 10;
      keyPressed(9);
      return;
    }

    final lastCharacter =
        newValue.substring((newValue.length - 1).clamp(0, newValue.length));
    final index = int.tryParse(lastCharacter) ?? -1;
    if (index == 0) {
      ref.read(pinKeyboardIndexProvider).pinIndex = 11;
      keyPressed(10);
    } else {
      ref.read(pinKeyboardIndexProvider).pinIndex = index;
      keyPressed(index - 1);
    }
  }
}
