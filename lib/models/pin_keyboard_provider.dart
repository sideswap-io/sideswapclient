import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/subjects.dart';

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
}
