// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warmup_app_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WarmupApp)
final warmupAppProvider = WarmupAppProvider._();

final class WarmupAppProvider
    extends $AsyncNotifierProvider<WarmupApp, WarmupAppState> {
  WarmupAppProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'warmupAppProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$warmupAppHash();

  @$internal
  @override
  WarmupApp create() => WarmupApp();
}

String _$warmupAppHash() => r'3c3f150a50af4a950409102d17d5bf22805879e7';

abstract class _$WarmupApp extends $AsyncNotifier<WarmupAppState> {
  FutureOr<WarmupAppState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WarmupAppState>, WarmupAppState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WarmupAppState>, WarmupAppState>,
              AsyncValue<WarmupAppState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(navigatorKey)
final navigatorKeyProvider = NavigatorKeyProvider._();

final class NavigatorKeyProvider
    extends
        $FunctionalProvider<
          GlobalKey<NavigatorState>,
          GlobalKey<NavigatorState>,
          GlobalKey<NavigatorState>
        >
    with $Provider<GlobalKey<NavigatorState>> {
  NavigatorKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navigatorKeyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navigatorKeyHash();

  @$internal
  @override
  $ProviderElement<GlobalKey<NavigatorState>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GlobalKey<NavigatorState> create(Ref ref) {
    return navigatorKey(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalKey<NavigatorState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalKey<NavigatorState>>(value),
    );
  }
}

String _$navigatorKeyHash() => r'e98ea9b83a531ebfa207927a585fc0549744a9c1';
