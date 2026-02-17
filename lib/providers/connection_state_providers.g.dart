// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ServerConnectionNotifier)
const serverConnectionProvider = ServerConnectionNotifierProvider._();

final class ServerConnectionNotifierProvider
    extends $NotifierProvider<ServerConnectionNotifier, bool> {
  const ServerConnectionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverConnectionNotifierHash();

  @$internal
  @override
  ServerConnectionNotifier create() => ServerConnectionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$serverConnectionNotifierHash() =>
    r'8906d799f7a94be534d8826d5136606744105529';

abstract class _$ServerConnectionNotifier extends $Notifier<bool> {
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

@ProviderFor(ServerLoginNotifier)
const serverLoginProvider = ServerLoginNotifierProvider._();

final class ServerLoginNotifierProvider
    extends $NotifierProvider<ServerLoginNotifier, ServerLoginState> {
  const ServerLoginNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverLoginProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverLoginNotifierHash();

  @$internal
  @override
  ServerLoginNotifier create() => ServerLoginNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerLoginState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerLoginState>(value),
    );
  }
}

String _$serverLoginNotifierHash() =>
    r'378f9bc8e4e463729a3789980bcfdaea255c85fd';

abstract class _$ServerLoginNotifier extends $Notifier<ServerLoginState> {
  ServerLoginState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ServerLoginState, ServerLoginState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ServerLoginState, ServerLoginState>,
              ServerLoginState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
