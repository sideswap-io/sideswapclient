// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_protection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PinProtectionStateNotifier)
final pinProtectionStateProvider = PinProtectionStateNotifierProvider._();

final class PinProtectionStateNotifierProvider
    extends $NotifierProvider<PinProtectionStateNotifier, PinProtectionState> {
  PinProtectionStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinProtectionStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinProtectionStateNotifierHash();

  @$internal
  @override
  PinProtectionStateNotifier create() => PinProtectionStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinProtectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinProtectionState>(value),
    );
  }
}

String _$pinProtectionStateNotifierHash() =>
    r'42824a0ae9414439d969186c6a26d38d1fdcfc72';

abstract class _$PinProtectionStateNotifier
    extends $Notifier<PinProtectionState> {
  PinProtectionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PinProtectionState, PinProtectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinProtectionState, PinProtectionState>,
              PinProtectionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PinCodeProtectionNotifier)
final pinCodeProtectionProvider = PinCodeProtectionNotifierProvider._();

final class PinCodeProtectionNotifierProvider
    extends $NotifierProvider<PinCodeProtectionNotifier, String> {
  PinCodeProtectionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinCodeProtectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinCodeProtectionNotifierHash();

  @$internal
  @override
  PinCodeProtectionNotifier create() => PinCodeProtectionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$pinCodeProtectionNotifierHash() =>
    r'31bb70c237b20e83e17f5824c55be1ebdd7f1d07';

abstract class _$PinCodeProtectionNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PinDecryptedDataNotifier)
final pinDecryptedDataProvider = PinDecryptedDataNotifierProvider._();

final class PinDecryptedDataNotifierProvider
    extends $NotifierProvider<PinDecryptedDataNotifier, PinDecryptedData> {
  PinDecryptedDataNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinDecryptedDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinDecryptedDataNotifierHash();

  @$internal
  @override
  PinDecryptedDataNotifier create() => PinDecryptedDataNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinDecryptedData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinDecryptedData>(value),
    );
  }
}

String _$pinDecryptedDataNotifierHash() =>
    r'daf39daeb56d9da66cdee904134fa0712346c9e7';

abstract class _$PinDecryptedDataNotifier extends $Notifier<PinDecryptedData> {
  PinDecryptedData build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PinDecryptedData, PinDecryptedData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinDecryptedData, PinDecryptedData>,
              PinDecryptedData,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PinUnlockStateNotifier)
final pinUnlockStateProvider = PinUnlockStateNotifierProvider._();

final class PinUnlockStateNotifierProvider
    extends $NotifierProvider<PinUnlockStateNotifier, PinUnlockState> {
  PinUnlockStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinUnlockStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinUnlockStateNotifierHash();

  @$internal
  @override
  PinUnlockStateNotifier create() => PinUnlockStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinUnlockState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinUnlockState>(value),
    );
  }
}

String _$pinUnlockStateNotifierHash() =>
    r'b9e6397457cad7d44229124387df59e59cfd64e6';

abstract class _$PinUnlockStateNotifier extends $Notifier<PinUnlockState> {
  PinUnlockState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PinUnlockState, PinUnlockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinUnlockState, PinUnlockState>,
              PinUnlockState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(pinProtectionHelper)
final pinProtectionHelperProvider = PinProtectionHelperProvider._();

final class PinProtectionHelperProvider
    extends
        $FunctionalProvider<
          PinProtectionHelper,
          PinProtectionHelper,
          PinProtectionHelper
        >
    with $Provider<PinProtectionHelper> {
  PinProtectionHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinProtectionHelperProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinProtectionHelperHash();

  @$internal
  @override
  $ProviderElement<PinProtectionHelper> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PinProtectionHelper create(Ref ref) {
    return pinProtectionHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinProtectionHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinProtectionHelper>(value),
    );
  }
}

String _$pinProtectionHelperHash() =>
    r'2ce9946d7c3d0596d73d0e410b1c8cefc12f4866';
