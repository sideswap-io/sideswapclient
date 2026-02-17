// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amount_to_string_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(amountToString)
const amountToStringProvider = AmountToStringProvider._();

final class AmountToStringProvider
    extends $FunctionalProvider<AmountToString, AmountToString, AmountToString>
    with $Provider<AmountToString> {
  const AmountToStringProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'amountToStringProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$amountToStringHash();

  @$internal
  @override
  $ProviderElement<AmountToString> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AmountToString create(Ref ref) {
    return amountToString(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AmountToString value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AmountToString>(value),
    );
  }
}

String _$amountToStringHash() => r'088b96feab823cfc3c392a7cc80303d7e4d6fc2b';
