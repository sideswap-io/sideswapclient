import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_state_providers.g.dart';

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final void Function(AppLifecycleState) onChanged;
  _AppLifecycleObserver(this.onChanged);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onChanged(state);
  }
}

@Riverpod(keepAlive: true)
class CurrentAppLifecycle extends _$CurrentAppLifecycle {
  _AppLifecycleObserver? _observer;

  @override
  Option<AppLifecycleState> build() {
    _observer = _AppLifecycleObserver((state) {
      this.state = Option.of(state);
    });
    WidgetsBinding.instance.addObserver(_observer!);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(_observer!);
    });
    return const Option.none();
  }
}
