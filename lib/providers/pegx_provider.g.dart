// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pegx_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PegxLoginStateNotifier)
const pegxLoginStateProvider = PegxLoginStateNotifierProvider._();

final class PegxLoginStateNotifierProvider
    extends $NotifierProvider<PegxLoginStateNotifier, PegxLoginState> {
  const PegxLoginStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pegxLoginStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pegxLoginStateNotifierHash();

  @$internal
  @override
  PegxLoginStateNotifier create() => PegxLoginStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PegxLoginState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PegxLoginState>(value),
    );
  }
}

String _$pegxLoginStateNotifierHash() =>
    r'e3993e0430e20d1e3ebd9a7a433e09093e3edb6d';

abstract class _$PegxLoginStateNotifier extends $Notifier<PegxLoginState> {
  PegxLoginState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PegxLoginState, PegxLoginState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PegxLoginState, PegxLoginState>,
              PegxLoginState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PegxGaidNotifier)
const pegxGaidProvider = PegxGaidNotifierProvider._();

final class PegxGaidNotifierProvider
    extends $NotifierProvider<PegxGaidNotifier, PegxGaidState> {
  const PegxGaidNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pegxGaidProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pegxGaidNotifierHash();

  @$internal
  @override
  PegxGaidNotifier create() => PegxGaidNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PegxGaidState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PegxGaidState>(value),
    );
  }
}

String _$pegxGaidNotifierHash() => r'664deec870ded7b5d5a7079f293bc851fb85008a';

abstract class _$PegxGaidNotifier extends $Notifier<PegxGaidState> {
  PegxGaidState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PegxGaidState, PegxGaidState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PegxGaidState, PegxGaidState>,
              PegxGaidState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PegxRegisterFailedNotifier)
const pegxRegisterFailedProvider = PegxRegisterFailedNotifierProvider._();

final class PegxRegisterFailedNotifierProvider
    extends $NotifierProvider<PegxRegisterFailedNotifier, String> {
  const PegxRegisterFailedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pegxRegisterFailedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pegxRegisterFailedNotifierHash();

  @$internal
  @override
  PegxRegisterFailedNotifier create() => PegxRegisterFailedNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$pegxRegisterFailedNotifierHash() =>
    r'244183a1847376e84eca93daabd7bf0d89f3afd1';

abstract class _$PegxRegisterFailedNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(pegxWebsocketClient)
const pegxWebsocketClientProvider = PegxWebsocketClientProvider._();

final class PegxWebsocketClientProvider
    extends
        $FunctionalProvider<
          PegxWebsocketClient,
          PegxWebsocketClient,
          PegxWebsocketClient
        >
    with $Provider<PegxWebsocketClient> {
  const PegxWebsocketClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pegxWebsocketClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pegxWebsocketClientHash();

  @$internal
  @override
  $ProviderElement<PegxWebsocketClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PegxWebsocketClient create(Ref ref) {
    return pegxWebsocketClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PegxWebsocketClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PegxWebsocketClient>(value),
    );
  }
}

String _$pegxWebsocketClientHash() =>
    r'f99ce970171c9f0091e9117fddd8330d59ad95d6';
