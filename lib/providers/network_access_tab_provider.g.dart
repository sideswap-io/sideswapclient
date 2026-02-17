// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_access_tab_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NetworkAccessTabNotifier)
const networkAccessTabProvider = NetworkAccessTabNotifierProvider._();

final class NetworkAccessTabNotifierProvider
    extends $NotifierProvider<NetworkAccessTabNotifier, NetworkAccessTabState> {
  const NetworkAccessTabNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkAccessTabProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkAccessTabNotifierHash();

  @$internal
  @override
  NetworkAccessTabNotifier create() => NetworkAccessTabNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkAccessTabState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkAccessTabState>(value),
    );
  }
}

String _$networkAccessTabNotifierHash() =>
    r'b9ea4510f6a8489974ef9833324ac591464dbffd';

abstract class _$NetworkAccessTabNotifier
    extends $Notifier<NetworkAccessTabState> {
  NetworkAccessTabState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NetworkAccessTabState, NetworkAccessTabState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkAccessTabState, NetworkAccessTabState>,
              NetworkAccessTabState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(UseProxyNotifier)
const useProxyProvider = UseProxyNotifierProvider._();

final class UseProxyNotifierProvider
    extends $NotifierProvider<UseProxyNotifier, bool> {
  const UseProxyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'useProxyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$useProxyNotifierHash();

  @$internal
  @override
  UseProxyNotifier create() => UseProxyNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$useProxyNotifierHash() => r'5e53759b98a7bdf4efbf5fa95f29e981af896339';

abstract class _$UseProxyNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
