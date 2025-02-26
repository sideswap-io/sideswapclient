import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/assets_precache_provider.dart';
import 'package:sideswap/providers/licenses_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'warmup_app_provider.g.dart';
part 'warmup_app_provider.freezed.dart';

@freezed
class WarmupAppState with _$WarmupAppState {
  const factory WarmupAppState.uninitialized() = WarmupAppStateUninitialized;
  const factory WarmupAppState.initialized() = WarmupAppStateInitialized;
}

@Riverpod(keepAlive: true)
class WarmupApp extends _$WarmupApp {
  @override
  FutureOr<WarmupAppState> build() {
    return const WarmupAppState.uninitialized();
  }

  Future<void> initializeApp() async {
    if (state.value == const WarmupAppState.initialized()) {
      return;
    }

    try {
      final (v1, v2, v3) =
          await (
            ref.read(clearImageCacheFutureProvider.future),
            ref.read(licensesLoaderFutureProvider.future),
            ref.read(assetsPrecacheFutureProvider.future),
          ).wait;

      if (!v1 || !v2 || !v3) {
        Error.throwWithStackTrace('WarmupApp failed', StackTrace.current);
      }
    } on ParallelWaitError<(bool, bool, bool), (Object, Object, Object)> catch (
      e,
      st
    ) {
      Error.throwWithStackTrace(e.errors.$1, st);
    }

    ref.read(networkSettingsNotifierProvider.notifier).applySettings();

    state = const AsyncValue.data(WarmupAppState.initialized());
  }

  void reinitialize() {
    state = const AsyncValue.data(WarmupAppState.uninitialized());
  }
}

@Riverpod(keepAlive: true)
GlobalKey<NavigatorState> navigatorKey(Ref ref) {
  return GlobalKey<NavigatorState>();
}
