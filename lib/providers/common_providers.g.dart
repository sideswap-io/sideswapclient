// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isAddrTypeValid)
final isAddrTypeValidProvider = IsAddrTypeValidFamily._();

final class IsAddrTypeValidProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  IsAddrTypeValidProvider._({
    required IsAddrTypeValidFamily super.from,
    required (String, AddrType) super.argument,
  }) : super(
         retry: null,
         name: r'isAddrTypeValidProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isAddrTypeValidHash();

  @override
  String toString() {
    return r'isAddrTypeValidProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as (String, AddrType);
    return isAddrTypeValid(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsAddrTypeValidProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isAddrTypeValidHash() => r'406cf7c3edbc038973a5cba2cb12b2cd9fc49335';

final class IsAddrTypeValidFamily extends $Family
    with $FunctionalFamilyOverride<bool, (String, AddrType)> {
  IsAddrTypeValidFamily._()
    : super(
        retry: null,
        name: r'isAddrTypeValidProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsAddrTypeValidProvider call(String addr, AddrType addrType) =>
      IsAddrTypeValidProvider._(argument: (addr, addrType), from: this);

  @override
  String toString() => r'isAddrTypeValidProvider';
}
