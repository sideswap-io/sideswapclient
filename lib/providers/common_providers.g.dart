// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isAddrTypeValidHash() => r'b20a6bb2339b315b4aa5a619eed521f69204a0f4';

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

/// See also [isAddrTypeValid].
@ProviderFor(isAddrTypeValid)
const isAddrTypeValidProvider = IsAddrTypeValidFamily();

/// See also [isAddrTypeValid].
class IsAddrTypeValidFamily extends Family<bool> {
  /// See also [isAddrTypeValid].
  const IsAddrTypeValidFamily();

  /// See also [isAddrTypeValid].
  IsAddrTypeValidProvider call(
    String addr,
    AddrType addrType,
  ) {
    return IsAddrTypeValidProvider(
      addr,
      addrType,
    );
  }

  @override
  IsAddrTypeValidProvider getProviderOverride(
    covariant IsAddrTypeValidProvider provider,
  ) {
    return call(
      provider.addr,
      provider.addrType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isAddrTypeValidProvider';
}

/// See also [isAddrTypeValid].
class IsAddrTypeValidProvider extends AutoDisposeProvider<bool> {
  /// See also [isAddrTypeValid].
  IsAddrTypeValidProvider(
    String addr,
    AddrType addrType,
  ) : this._internal(
          (ref) => isAddrTypeValid(
            ref as IsAddrTypeValidRef,
            addr,
            addrType,
          ),
          from: isAddrTypeValidProvider,
          name: r'isAddrTypeValidProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isAddrTypeValidHash,
          dependencies: IsAddrTypeValidFamily._dependencies,
          allTransitiveDependencies:
              IsAddrTypeValidFamily._allTransitiveDependencies,
          addr: addr,
          addrType: addrType,
        );

  IsAddrTypeValidProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.addr,
    required this.addrType,
  }) : super.internal();

  final String addr;
  final AddrType addrType;

  @override
  Override overrideWith(
    bool Function(IsAddrTypeValidRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsAddrTypeValidProvider._internal(
        (ref) => create(ref as IsAddrTypeValidRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        addr: addr,
        addrType: addrType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsAddrTypeValidProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsAddrTypeValidProvider &&
        other.addr == addr &&
        other.addrType == addrType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, addr.hashCode);
    hash = _SystemHash.combine(hash, addrType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsAddrTypeValidRef on AutoDisposeProviderRef<bool> {
  /// The parameter `addr` of this provider.
  String get addr;

  /// The parameter `addrType` of this provider.
  AddrType get addrType;
}

class _IsAddrTypeValidProviderElement extends AutoDisposeProviderElement<bool>
    with IsAddrTypeValidRef {
  _IsAddrTypeValidProviderElement(super.provider);

  @override
  String get addr => (origin as IsAddrTypeValidProvider).addr;
  @override
  AddrType get addrType => (origin as IsAddrTypeValidProvider).addrType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
