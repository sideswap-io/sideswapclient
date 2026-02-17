// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_ffi.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LibClientId)
const libClientIdProvider = LibClientIdProvider._();

final class LibClientIdProvider extends $NotifierProvider<LibClientId, int> {
  const LibClientIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libClientIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libClientIdHash();

  @$internal
  @override
  LibClientId create() => LibClientId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$libClientIdHash() => r'848a6c2450dd03273452115f644e9b17a604fda8';

abstract class _$LibClientId extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(libClientState)
const libClientStateProvider = LibClientStateProvider._();

final class LibClientStateProvider
    extends $FunctionalProvider<LibClientState, LibClientState, LibClientState>
    with $Provider<LibClientState> {
  const LibClientStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libClientStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libClientStateHash();

  @$internal
  @override
  $ProviderElement<LibClientState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LibClientState create(Ref ref) {
    return libClientState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibClientState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibClientState>(value),
    );
  }
}

String _$libClientStateHash() => r'68046036a8364c09d0529d00d60bca1f86d089b4';
