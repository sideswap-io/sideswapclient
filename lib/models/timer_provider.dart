import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerProvider = ChangeNotifierProvider<TimerChangeNotifier>((ref) {
  return TimerChangeNotifier();
});

class TimerChangeNotifier with ChangeNotifier {
  void _onTick(Timer timer) {
    notifyListeners();
  }

  TimerChangeNotifier() {
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  late final Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
