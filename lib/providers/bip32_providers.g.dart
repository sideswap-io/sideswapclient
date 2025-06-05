// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bip32_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$parseBIP21Hash() => r'8eb5447fe2b232d31e6a8f846a0c03a755d3c764';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [parseBIP21].
@ProviderFor(parseBIP21)
const parseBIP21Provider = ParseBIP21Family();

/// See also [parseBIP21].
class ParseBIP21Family extends Family<Either<Exception, BIP21Result>> {
  /// See also [parseBIP21].
  const ParseBIP21Family();

  /// See also [parseBIP21].
  ParseBIP21Provider call(String address, BIP21AddressTypeEnum addressType) {
    return ParseBIP21Provider(address, addressType);
  }

  @override
  ParseBIP21Provider getProviderOverride(
    covariant ParseBIP21Provider provider,
  ) {
    return call(provider.address, provider.addressType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'parseBIP21Provider';
}

/// See also [parseBIP21].
class ParseBIP21Provider
    extends AutoDisposeProvider<Either<Exception, BIP21Result>> {
  /// See also [parseBIP21].
  ParseBIP21Provider(String address, BIP21AddressTypeEnum addressType)
    : this._internal(
        (ref) => parseBIP21(ref as ParseBIP21Ref, address, addressType),
        from: parseBIP21Provider,
        name: r'parseBIP21Provider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$parseBIP21Hash,
        dependencies: ParseBIP21Family._dependencies,
        allTransitiveDependencies: ParseBIP21Family._allTransitiveDependencies,
        address: address,
        addressType: addressType,
      );

  ParseBIP21Provider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.address,
    required this.addressType,
  }) : super.internal();

  final String address;
  final BIP21AddressTypeEnum addressType;

  @override
  Override overrideWith(
    Either<Exception, BIP21Result> Function(ParseBIP21Ref provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ParseBIP21Provider._internal(
        (ref) => create(ref as ParseBIP21Ref),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        address: address,
        addressType: addressType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Either<Exception, BIP21Result>> createElement() {
    return _ParseBIP21ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ParseBIP21Provider &&
        other.address == address &&
        other.addressType == addressType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);
    hash = _SystemHash.combine(hash, addressType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ParseBIP21Ref on AutoDisposeProviderRef<Either<Exception, BIP21Result>> {
  /// The parameter `address` of this provider.
  String get address;

  /// The parameter `addressType` of this provider.
  BIP21AddressTypeEnum get addressType;
}

class _ParseBIP21ProviderElement
    extends AutoDisposeProviderElement<Either<Exception, BIP21Result>>
    with ParseBIP21Ref {
  _ParseBIP21ProviderElement(super.provider);

  @override
  String get address => (origin as ParseBIP21Provider).address;
  @override
  BIP21AddressTypeEnum get addressType =>
      (origin as ParseBIP21Provider).addressType;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
