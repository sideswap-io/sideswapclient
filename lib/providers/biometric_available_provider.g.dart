// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_available_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isBiometricEnabled)
final isBiometricEnabledProvider = IsBiometricEnabledProvider._();

final class IsBiometricEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  IsBiometricEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isBiometricEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isBiometricEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isBiometricEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isBiometricEnabledHash() =>
    r'bbcfc7e74f2fa3b3d2176bfd961284f698f3e899';

@ProviderFor(isBiometricAvailable)
final isBiometricAvailableProvider = IsBiometricAvailableProvider._();

final class IsBiometricAvailableProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsBiometricAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isBiometricAvailableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isBiometricAvailableHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isBiometricAvailable(ref);
  }
}

String _$isBiometricAvailableHash() =>
    r'91ba42175574e67b306813c475e0a435844cc8b4';
