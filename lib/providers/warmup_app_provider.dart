import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/assets_precache_provider.dart';
import 'package:sideswap/providers/licenses_provider.dart';
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

    await ref.read(clearImageCacheFutureProvider.future);
    await ref.read(licensesLoaderFutureProvider.future);
    await ref.read(assetsPrecacheFutureProvider.future);
    state = const AsyncValue.data(WarmupAppState.initialized());
  }
}
