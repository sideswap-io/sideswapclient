// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_select_asset.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentAssetTypesHash() => r'7afbf0ce7825e2655eabbfb7edd72a27682c9cbe';

/// See also [paymentAssetTypes].
@ProviderFor(paymentAssetTypes)
final paymentAssetTypesProvider =
    AutoDisposeProvider<List<PaymentAccountType>>.internal(
  paymentAssetTypes,
  name: r'paymentAssetTypesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentAssetTypesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PaymentAssetTypesRef = AutoDisposeProviderRef<List<PaymentAccountType>>;
String _$paymentIsAssetDisabledHash() =>
    r'e6ecee2082c92a6bc0fc2ca9056622b50ba92f67';

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
  PaymentIsAssetDisabledProvider call(
    AccountAsset accountAsset,
  ) {
    return PaymentIsAssetDisabledProvider(
      accountAsset,
    );
  }

  @override
  PaymentIsAssetDisabledProvider getProviderOverride(
    covariant PaymentIsAssetDisabledProvider provider,
  ) {
    return call(
      provider.accountAsset,
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
  String? get name => r'paymentIsAssetDisabledProvider';
}

/// See also [paymentIsAssetDisabled].
class PaymentIsAssetDisabledProvider extends AutoDisposeProvider<bool> {
  /// See also [paymentIsAssetDisabled].
  PaymentIsAssetDisabledProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => paymentIsAssetDisabled(
            ref as PaymentIsAssetDisabledRef,
            accountAsset,
          ),
          from: paymentIsAssetDisabledProvider,
          name: r'paymentIsAssetDisabledProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paymentIsAssetDisabledHash,
          dependencies: PaymentIsAssetDisabledFamily._dependencies,
          allTransitiveDependencies:
              PaymentIsAssetDisabledFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  PaymentIsAssetDisabledProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountAsset,
  }) : super.internal();

  final AccountAsset accountAsset;

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
        accountAsset: accountAsset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _PaymentIsAssetDisabledProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentIsAssetDisabledProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PaymentIsAssetDisabledRef on AutoDisposeProviderRef<bool> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _PaymentIsAssetDisabledProviderElement
    extends AutoDisposeProviderElement<bool> with PaymentIsAssetDisabledRef {
  _PaymentIsAssetDisabledProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as PaymentIsAssetDisabledProvider).accountAsset;
}

String _$paymentAccountAssetsByTypeHash() =>
    r'8d36ea7f9de087d3b55e789ecacb76aa27966fec';

/// See also [paymentAccountAssetsByType].
@ProviderFor(paymentAccountAssetsByType)
const paymentAccountAssetsByTypeProvider = PaymentAccountAssetsByTypeFamily();

/// See also [paymentAccountAssetsByType].
class PaymentAccountAssetsByTypeFamily extends Family<List<AccountAsset>> {
  /// See also [paymentAccountAssetsByType].
  const PaymentAccountAssetsByTypeFamily();

  /// See also [paymentAccountAssetsByType].
  PaymentAccountAssetsByTypeProvider call(
    PaymentAccountType paymentAccountType,
  ) {
    return PaymentAccountAssetsByTypeProvider(
      paymentAccountType,
    );
  }

  @override
  PaymentAccountAssetsByTypeProvider getProviderOverride(
    covariant PaymentAccountAssetsByTypeProvider provider,
  ) {
    return call(
      provider.paymentAccountType,
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
  String? get name => r'paymentAccountAssetsByTypeProvider';
}

/// See also [paymentAccountAssetsByType].
class PaymentAccountAssetsByTypeProvider
    extends AutoDisposeProvider<List<AccountAsset>> {
  /// See also [paymentAccountAssetsByType].
  PaymentAccountAssetsByTypeProvider(
    PaymentAccountType paymentAccountType,
  ) : this._internal(
          (ref) => paymentAccountAssetsByType(
            ref as PaymentAccountAssetsByTypeRef,
            paymentAccountType,
          ),
          from: paymentAccountAssetsByTypeProvider,
          name: r'paymentAccountAssetsByTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paymentAccountAssetsByTypeHash,
          dependencies: PaymentAccountAssetsByTypeFamily._dependencies,
          allTransitiveDependencies:
              PaymentAccountAssetsByTypeFamily._allTransitiveDependencies,
          paymentAccountType: paymentAccountType,
        );

  PaymentAccountAssetsByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.paymentAccountType,
  }) : super.internal();

  final PaymentAccountType paymentAccountType;

  @override
  Override overrideWith(
    List<AccountAsset> Function(PaymentAccountAssetsByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaymentAccountAssetsByTypeProvider._internal(
        (ref) => create(ref as PaymentAccountAssetsByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        paymentAccountType: paymentAccountType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<AccountAsset>> createElement() {
    return _PaymentAccountAssetsByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentAccountAssetsByTypeProvider &&
        other.paymentAccountType == paymentAccountType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, paymentAccountType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PaymentAccountAssetsByTypeRef
    on AutoDisposeProviderRef<List<AccountAsset>> {
  /// The parameter `paymentAccountType` of this provider.
  PaymentAccountType get paymentAccountType;
}

class _PaymentAccountAssetsByTypeProviderElement
    extends AutoDisposeProviderElement<List<AccountAsset>>
    with PaymentAccountAssetsByTypeRef {
  _PaymentAccountAssetsByTypeProviderElement(super.provider);

  @override
  PaymentAccountType get paymentAccountType =>
      (origin as PaymentAccountAssetsByTypeProvider).paymentAccountType;
}

String _$paymentAvailableAssetsHash() =>
    r'044020bbfb648554dff3d8a998c52b2a1181df74';

/// See also [PaymentAvailableAssets].
@ProviderFor(PaymentAvailableAssets)
final paymentAvailableAssetsProvider = AutoDisposeNotifierProvider<
    PaymentAvailableAssets, List<AccountAsset>>.internal(
  PaymentAvailableAssets.new,
  name: r'paymentAvailableAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentAvailableAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentAvailableAssets = AutoDisposeNotifier<List<AccountAsset>>;
String _$paymentDisabledAssetsHash() =>
    r'd1c4ef325a683a4185c79eee65d82c99b0c3c739';

/// See also [PaymentDisabledAssets].
@ProviderFor(PaymentDisabledAssets)
final paymentDisabledAssetsProvider = AutoDisposeNotifierProvider<
    PaymentDisabledAssets, List<AccountAsset>>.internal(
  PaymentDisabledAssets.new,
  name: r'paymentDisabledAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentDisabledAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentDisabledAssets = AutoDisposeNotifier<List<AccountAsset>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
