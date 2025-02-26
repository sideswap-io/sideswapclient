import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'pin_keyboard_provider.g.dart';

enum PinKeyEnum {
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

@riverpod
PinKeyboardHelper pinKeyboardHelper(Ref ref) {
  return PinKeyboardHelper(ref: ref);
}

class PinKeyboardHelper {
  final Ref ref;

  PinKeyboardHelper({required this.ref});

  final PublishSubject<PinKeyEnum> pinKeySubject = PublishSubject();
  late final Stream<PinKeyEnum> pinKeyStream = pinKeySubject;

  PinKeyEnum indexToKey(int index) {
    if (index < 0 || index > PinKeyEnum.values.length) {
      return PinKeyEnum.backspace;
    }

    return PinKeyEnum.values[index];
  }

  void keyPressed(int index) {
    final key = indexToKey(index);

    pinKeySubject.add(key);
  }

  void onDesktopKeyChanged(String oldValue, String newValue) {
    if (oldValue == newValue) {
      return;
    }

    final oldPinKeys =
        oldValue.runes.map((e) => String.fromCharCode(e)).toList();
    for (var _ in oldPinKeys) {
      // backspace
      keyPressed(9);
    }

    final newPinKeys = newValue.runes.map((e) => String.fromCharCode(e));
    for (final char in newPinKeys) {
      final index = int.tryParse(char) ?? -1;
      if (index == 0) {
        // zero
        keyPressed(10);
      } else {
        keyPressed(index - 1);
      }
    }
  }
}
