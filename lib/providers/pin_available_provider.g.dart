// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_available_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pinAvailable)
const pinAvailableProvider = PinAvailableProvider._();

final class PinAvailableProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const PinAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinAvailableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinAvailableHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return pinAvailable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$pinAvailableHash() => r'02ef428a6810afed4af4e2ed5aa509faae1d0439';

@ProviderFor(isPinAvailable)
const isPinAvailableProvider = IsPinAvailableProvider._();

final class IsPinAvailableProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const IsPinAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isPinAvailableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isPinAvailableHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isPinAvailable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isPinAvailableHash() => r'84d45154432d3c1bde6234b04113f2924773946f';
