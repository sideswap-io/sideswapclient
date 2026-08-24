// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bip32_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(parseBIP21)
final parseBIP21Provider = ParseBIP21Family._();

final class ParseBIP21Provider
    extends
        $FunctionalProvider<
          Either<Exception, BIP21Result>,
          Either<Exception, BIP21Result>,
          Either<Exception, BIP21Result>
        >
    with $Provider<Either<Exception, BIP21Result>> {
  ParseBIP21Provider._({
    required ParseBIP21Family super.from,
    required (String, BIP21AddressTypeEnum) super.argument,
  }) : super(
         retry: null,
         name: r'parseBIP21Provider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$parseBIP21Hash();

  @override
  String toString() {
    return r'parseBIP21Provider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<Either<Exception, BIP21Result>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Either<Exception, BIP21Result> create(Ref ref) {
    final argument = this.argument as (String, BIP21AddressTypeEnum);
    return parseBIP21(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Either<Exception, BIP21Result> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Either<Exception, BIP21Result>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ParseBIP21Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$parseBIP21Hash() => r'8eb5447fe2b232d31e6a8f846a0c03a755d3c764';

final class ParseBIP21Family extends $Family
    with
        $FunctionalFamilyOverride<
          Either<Exception, BIP21Result>,
          (String, BIP21AddressTypeEnum)
        > {
  ParseBIP21Family._()
    : super(
        retry: null,
        name: r'parseBIP21Provider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ParseBIP21Provider call(String address, BIP21AddressTypeEnum addressType) =>
      ParseBIP21Provider._(argument: (address, addressType), from: this);

  @override
  String toString() => r'parseBIP21Provider';
}
