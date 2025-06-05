// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_select_asset.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentIsAssetDisabledHash() =>
    r'a54ec2e37766189b78c6b39cb6bc01f652806716';

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

/// See also [paymentIsAssetDisabled].
@ProviderFor(paymentIsAssetDisabled)
const paymentIsAssetDisabledProvider = PaymentIsAssetDisabledFamily();

/// See also [paymentIsAssetDisabled].
class PaymentIsAssetDisabledFamily extends Family<bool> {
  /// See also [paymentIsAssetDisabled].
  const PaymentIsAssetDisabledFamily();

  /// See also [paymentIsAssetDisabled].
  PaymentIsAssetDisabledProvider call(String assetId) {
    return PaymentIsAssetDisabledProvider(assetId);
  }

  @override
  PaymentIsAssetDisabledProvider getProviderOverride(
    covariant PaymentIsAssetDisabledProvider provider,
  ) {
    return call(provider.assetId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'paymentIsAssetDisabledProvider';
}

/// See also [paymentIsAssetDisabled].
class PaymentIsAssetDisabledProvider extends AutoDisposeProvider<bool> {
  /// See also [paymentIsAssetDisabled].
  PaymentIsAssetDisabledProvider(String assetId)
    : this._internal(
        (ref) =>
            paymentIsAssetDisabled(ref as PaymentIsAssetDisabledRef, assetId),
        from: paymentIsAssetDisabledProvider,
        name: r'paymentIsAssetDisabledProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$paymentIsAssetDisabledHash,
        dependencies: PaymentIsAssetDisabledFamily._dependencies,
        allTransitiveDependencies:
            PaymentIsAssetDisabledFamily._allTransitiveDependencies,
        assetId: assetId,
      );

  PaymentIsAssetDisabledProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
  }) : super.internal();

  final String assetId;

  @override
  Override overrideWith(
    bool Function(PaymentIsAssetDisabledRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaymentIsAssetDisabledProvider._internal(
        (ref) => create(ref as PaymentIsAssetDisabledRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetId: assetId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _PaymentIsAssetDisabledProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentIsAssetDisabledProvider && other.assetId == assetId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PaymentIsAssetDisabledRef on AutoDisposeProviderRef<bool> {
  /// The parameter `assetId` of this provider.
  String get assetId;
}

class _PaymentIsAssetDisabledProviderElement
    extends AutoDisposeProviderElement<bool>
    with PaymentIsAssetDisabledRef {
  _PaymentIsAssetDisabledProviderElement(super.provider);

  @override
  String get assetId => (origin as PaymentIsAssetDisabledProvider).assetId;
}

String _$paymentAvailableAssetsWithInputsFilteredHash() =>
    r'c9fa54b1d3db046adf103a1985dcc291768cc4f8';

/// See also [paymentAvailableAssetsWithInputsFiltered].
@ProviderFor(paymentAvailableAssetsWithInputsFiltered)
final paymentAvailableAssetsWithInputsFilteredProvider =
    AutoDisposeProvider<Iterable<String>>.internal(
      paymentAvailableAssetsWithInputsFiltered,
      name: r'paymentAvailableAssetsWithInputsFilteredProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentAvailableAssetsWithInputsFilteredHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaymentAvailableAssetsWithInputsFilteredRef =
    AutoDisposeProviderRef<Iterable<String>>;
String _$paymentAvailableAssetsHash() =>
    r'd9d253df7ef5df89b3da94edb3df7903dfd22bc2';

/// See also [PaymentAvailableAssets].
@ProviderFor(PaymentAvailableAssets)
final paymentAvailableAssetsProvider =
    AutoDisposeNotifierProvider<
      PaymentAvailableAssets,
      Iterable<String>
    >.internal(
      PaymentAvailableAssets.new,
      name: r'paymentAvailableAssetsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentAvailableAssetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PaymentAvailableAssets = AutoDisposeNotifier<Iterable<String>>;
String _$paymentDisabledAssetsHash() =>
    r'd5388d815547aad761bec274afe933a027297b53';

/// See also [PaymentDisabledAssets].
@ProviderFor(PaymentDisabledAssets)
final paymentDisabledAssetsProvider =
    AutoDisposeNotifierProvider<
      PaymentDisabledAssets,
      Iterable<String>
    >.internal(
      PaymentDisabledAssets.new,
      name: r'paymentDisabledAssetsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentDisabledAssetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PaymentDisabledAssets = AutoDisposeNotifier<Iterable<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
