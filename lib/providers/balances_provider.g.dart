// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balances_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$assetBalanceHash() => r'089ae9d40352354b2c199984b1b22a841bb77730';

/// See also [assetBalance].
@ProviderFor(assetBalance)
final assetBalanceProvider = AutoDisposeProvider<Map<String, int>>.internal(
  assetBalance,
  name: r'assetBalanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$assetBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssetBalanceRef = AutoDisposeProviderRef<Map<String, int>>;
String _$outputsBalanceForAssetHash() =>
    r'1c61a5a92c676282fc232d153cdfe7b103376d34';

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

/// See also [outputsBalanceForAsset].
@ProviderFor(outputsBalanceForAsset)
const outputsBalanceForAssetProvider = OutputsBalanceForAssetFamily();

/// See also [outputsBalanceForAsset].
class OutputsBalanceForAssetFamily extends Family<int> {
  /// See also [outputsBalanceForAsset].
  const OutputsBalanceForAssetFamily();

  /// See also [outputsBalanceForAsset].
  OutputsBalanceForAssetProvider call(String assetId) {
    return OutputsBalanceForAssetProvider(assetId);
  }

  @override
  OutputsBalanceForAssetProvider getProviderOverride(
    covariant OutputsBalanceForAssetProvider provider,
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
  String? get name => r'outputsBalanceForAssetProvider';
}

/// See also [outputsBalanceForAsset].
class OutputsBalanceForAssetProvider extends AutoDisposeProvider<int> {
  /// See also [outputsBalanceForAsset].
  OutputsBalanceForAssetProvider(String assetId)
    : this._internal(
        (ref) =>
            outputsBalanceForAsset(ref as OutputsBalanceForAssetRef, assetId),
        from: outputsBalanceForAssetProvider,
        name: r'outputsBalanceForAssetProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$outputsBalanceForAssetHash,
        dependencies: OutputsBalanceForAssetFamily._dependencies,
        allTransitiveDependencies:
            OutputsBalanceForAssetFamily._allTransitiveDependencies,
        assetId: assetId,
      );

  OutputsBalanceForAssetProvider._internal(
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
    int Function(OutputsBalanceForAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OutputsBalanceForAssetProvider._internal(
        (ref) => create(ref as OutputsBalanceForAssetRef),
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
  AutoDisposeProviderElement<int> createElement() {
    return _OutputsBalanceForAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OutputsBalanceForAssetProvider && other.assetId == assetId;
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
mixin OutputsBalanceForAssetRef on AutoDisposeProviderRef<int> {
  /// The parameter `assetId` of this provider.
  String get assetId;
}

class _OutputsBalanceForAssetProviderElement
    extends AutoDisposeProviderElement<int>
    with OutputsBalanceForAssetRef {
  _OutputsBalanceForAssetProviderElement(super.provider);

  @override
  String get assetId => (origin as OutputsBalanceForAssetProvider).assetId;
}

String _$selectedInputsBalanceForAssetHash() =>
    r'55e10582efde34d0a3a4166f58912bd0b26231ed';

/// Inputs related providers
///
/// Copied from [selectedInputsBalanceForAsset].
@ProviderFor(selectedInputsBalanceForAsset)
const selectedInputsBalanceForAssetProvider =
    SelectedInputsBalanceForAssetFamily();

/// Inputs related providers
///
/// Copied from [selectedInputsBalanceForAsset].
class SelectedInputsBalanceForAssetFamily extends Family<int> {
  /// Inputs related providers
  ///
  /// Copied from [selectedInputsBalanceForAsset].
  const SelectedInputsBalanceForAssetFamily();

  /// Inputs related providers
  ///
  /// Copied from [selectedInputsBalanceForAsset].
  SelectedInputsBalanceForAssetProvider call(String assetId) {
    return SelectedInputsBalanceForAssetProvider(assetId);
  }

  @override
  SelectedInputsBalanceForAssetProvider getProviderOverride(
    covariant SelectedInputsBalanceForAssetProvider provider,
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
  String? get name => r'selectedInputsBalanceForAssetProvider';
}

/// Inputs related providers
///
/// Copied from [selectedInputsBalanceForAsset].
class SelectedInputsBalanceForAssetProvider extends AutoDisposeProvider<int> {
  /// Inputs related providers
  ///
  /// Copied from [selectedInputsBalanceForAsset].
  SelectedInputsBalanceForAssetProvider(String assetId)
    : this._internal(
        (ref) => selectedInputsBalanceForAsset(
          ref as SelectedInputsBalanceForAssetRef,
          assetId,
        ),
        from: selectedInputsBalanceForAssetProvider,
        name: r'selectedInputsBalanceForAssetProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$selectedInputsBalanceForAssetHash,
        dependencies: SelectedInputsBalanceForAssetFamily._dependencies,
        allTransitiveDependencies:
            SelectedInputsBalanceForAssetFamily._allTransitiveDependencies,
        assetId: assetId,
      );

  SelectedInputsBalanceForAssetProvider._internal(
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
    int Function(SelectedInputsBalanceForAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedInputsBalanceForAssetProvider._internal(
        (ref) => create(ref as SelectedInputsBalanceForAssetRef),
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
  AutoDisposeProviderElement<int> createElement() {
    return _SelectedInputsBalanceForAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedInputsBalanceForAssetProvider &&
        other.assetId == assetId;
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
mixin SelectedInputsBalanceForAssetRef on AutoDisposeProviderRef<int> {
  /// The parameter `assetId` of this provider.
  String get assetId;
}

class _SelectedInputsBalanceForAssetProviderElement
    extends AutoDisposeProviderElement<int>
    with SelectedInputsBalanceForAssetRef {
  _SelectedInputsBalanceForAssetProviderElement(super.provider);

  @override
  String get assetId =>
      (origin as SelectedInputsBalanceForAssetProvider).assetId;
}

String _$maxAvailableBalanceWithInputsForAssetHash() =>
    r'2c4366e31f865bfb944e4e0789e5aedeeac616b3';

/// See also [maxAvailableBalanceWithInputsForAsset].
@ProviderFor(maxAvailableBalanceWithInputsForAsset)
const maxAvailableBalanceWithInputsForAssetProvider =
    MaxAvailableBalanceWithInputsForAssetFamily();

/// See also [maxAvailableBalanceWithInputsForAsset].
class MaxAvailableBalanceWithInputsForAssetFamily extends Family<int> {
  /// See also [maxAvailableBalanceWithInputsForAsset].
  const MaxAvailableBalanceWithInputsForAssetFamily();

  /// See also [maxAvailableBalanceWithInputsForAsset].
  MaxAvailableBalanceWithInputsForAssetProvider call(String assetId) {
    return MaxAvailableBalanceWithInputsForAssetProvider(assetId);
  }

  @override
  MaxAvailableBalanceWithInputsForAssetProvider getProviderOverride(
    covariant MaxAvailableBalanceWithInputsForAssetProvider provider,
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
  String? get name => r'maxAvailableBalanceWithInputsForAssetProvider';
}

/// See also [maxAvailableBalanceWithInputsForAsset].
class MaxAvailableBalanceWithInputsForAssetProvider
    extends AutoDisposeProvider<int> {
  /// See also [maxAvailableBalanceWithInputsForAsset].
  MaxAvailableBalanceWithInputsForAssetProvider(String assetId)
    : this._internal(
        (ref) => maxAvailableBalanceWithInputsForAsset(
          ref as MaxAvailableBalanceWithInputsForAssetRef,
          assetId,
        ),
        from: maxAvailableBalanceWithInputsForAssetProvider,
        name: r'maxAvailableBalanceWithInputsForAssetProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$maxAvailableBalanceWithInputsForAssetHash,
        dependencies: MaxAvailableBalanceWithInputsForAssetFamily._dependencies,
        allTransitiveDependencies: MaxAvailableBalanceWithInputsForAssetFamily
            ._allTransitiveDependencies,
        assetId: assetId,
      );

  MaxAvailableBalanceWithInputsForAssetProvider._internal(
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
    int Function(MaxAvailableBalanceWithInputsForAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MaxAvailableBalanceWithInputsForAssetProvider._internal(
        (ref) => create(ref as MaxAvailableBalanceWithInputsForAssetRef),
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
  AutoDisposeProviderElement<int> createElement() {
    return _MaxAvailableBalanceWithInputsForAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MaxAvailableBalanceWithInputsForAssetProvider &&
        other.assetId == assetId;
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
mixin MaxAvailableBalanceWithInputsForAssetRef on AutoDisposeProviderRef<int> {
  /// The parameter `assetId` of this provider.
  String get assetId;
}

class _MaxAvailableBalanceWithInputsForAssetProviderElement
    extends AutoDisposeProviderElement<int>
    with MaxAvailableBalanceWithInputsForAssetRef {
  _MaxAvailableBalanceWithInputsForAssetProviderElement(super.provider);

  @override
  String get assetId =>
      (origin as MaxAvailableBalanceWithInputsForAssetProvider).assetId;
}

String _$balanceWithInputsForAssetHash() =>
    r'52852c0bbf84423f8c9fac318381f843d0476433';

/// See also [balanceWithInputsForAsset].
@ProviderFor(balanceWithInputsForAsset)
const balanceWithInputsForAssetProvider = BalanceWithInputsForAssetFamily();

/// See also [balanceWithInputsForAsset].
class BalanceWithInputsForAssetFamily extends Family<int> {
  /// See also [balanceWithInputsForAsset].
  const BalanceWithInputsForAssetFamily();

  /// See also [balanceWithInputsForAsset].
  BalanceWithInputsForAssetProvider call(String assetId) {
    return BalanceWithInputsForAssetProvider(assetId);
  }

  @override
  BalanceWithInputsForAssetProvider getProviderOverride(
    covariant BalanceWithInputsForAssetProvider provider,
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
  String? get name => r'balanceWithInputsForAssetProvider';
}

/// See also [balanceWithInputsForAsset].
class BalanceWithInputsForAssetProvider extends AutoDisposeProvider<int> {
  /// See also [balanceWithInputsForAsset].
  BalanceWithInputsForAssetProvider(String assetId)
    : this._internal(
        (ref) => balanceWithInputsForAsset(
          ref as BalanceWithInputsForAssetRef,
          assetId,
        ),
        from: balanceWithInputsForAssetProvider,
        name: r'balanceWithInputsForAssetProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$balanceWithInputsForAssetHash,
        dependencies: BalanceWithInputsForAssetFamily._dependencies,
        allTransitiveDependencies:
            BalanceWithInputsForAssetFamily._allTransitiveDependencies,
        assetId: assetId,
      );

  BalanceWithInputsForAssetProvider._internal(
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
    int Function(BalanceWithInputsForAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BalanceWithInputsForAssetProvider._internal(
        (ref) => create(ref as BalanceWithInputsForAssetRef),
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
  AutoDisposeProviderElement<int> createElement() {
    return _BalanceWithInputsForAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BalanceWithInputsForAssetProvider &&
        other.assetId == assetId;
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
mixin BalanceWithInputsForAssetRef on AutoDisposeProviderRef<int> {
  /// The parameter `assetId` of this provider.
  String get assetId;
}

class _BalanceWithInputsForAssetProviderElement
    extends AutoDisposeProviderElement<int>
    with BalanceWithInputsForAssetRef {
  _BalanceWithInputsForAssetProviderElement(super.provider);

  @override
  String get assetId => (origin as BalanceWithInputsForAssetProvider).assetId;
}

String _$balanceStringWithInputsForAssetHash() =>
    r'a70aa70fc1b458398d9046ee93f3db0a51eb4a44';

/// See also [balanceStringWithInputsForAsset].
@ProviderFor(balanceStringWithInputsForAsset)
const balanceStringWithInputsForAssetProvider =
    BalanceStringWithInputsForAssetFamily();

/// See also [balanceStringWithInputsForAsset].
class BalanceStringWithInputsForAssetFamily extends Family<String> {
  /// See also [balanceStringWithInputsForAsset].
  const BalanceStringWithInputsForAssetFamily();

  /// See also [balanceStringWithInputsForAsset].
  BalanceStringWithInputsForAssetProvider call(String assetId) {
    return BalanceStringWithInputsForAssetProvider(assetId);
  }

  @override
  BalanceStringWithInputsForAssetProvider getProviderOverride(
    covariant BalanceStringWithInputsForAssetProvider provider,
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
  String? get name => r'balanceStringWithInputsForAssetProvider';
}

/// See also [balanceStringWithInputsForAsset].
class BalanceStringWithInputsForAssetProvider
    extends AutoDisposeProvider<String> {
  /// See also [balanceStringWithInputsForAsset].
  BalanceStringWithInputsForAssetProvider(String assetId)
    : this._internal(
        (ref) => balanceStringWithInputsForAsset(
          ref as BalanceStringWithInputsForAssetRef,
          assetId,
        ),
        from: balanceStringWithInputsForAssetProvider,
        name: r'balanceStringWithInputsForAssetProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$balanceStringWithInputsForAssetHash,
        dependencies: BalanceStringWithInputsForAssetFamily._dependencies,
        allTransitiveDependencies:
            BalanceStringWithInputsForAssetFamily._allTransitiveDependencies,
        assetId: assetId,
      );

  BalanceStringWithInputsForAssetProvider._internal(
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
    String Function(BalanceStringWithInputsForAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BalanceStringWithInputsForAssetProvider._internal(
        (ref) => create(ref as BalanceStringWithInputsForAssetRef),
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
  AutoDisposeProviderElement<String> createElement() {
    return _BalanceStringWithInputsForAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BalanceStringWithInputsForAssetProvider &&
        other.assetId == assetId;
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
mixin BalanceStringWithInputsForAssetRef on AutoDisposeProviderRef<String> {
  /// The parameter `assetId` of this provider.
  String get assetId;
}

class _BalanceStringWithInputsForAssetProviderElement
    extends AutoDisposeProviderElement<String>
    with BalanceStringWithInputsForAssetRef {
  _BalanceStringWithInputsForAssetProviderElement(super.provider);

  @override
  String get assetId =>
      (origin as BalanceStringWithInputsForAssetProvider).assetId;
}

String _$balanceStringWithInputsHash() =>
    r'c6c78eb546bb37ae0adc3e9a11a462d32c35c09a';

/// See also [balanceStringWithInputs].
@ProviderFor(balanceStringWithInputs)
final balanceStringWithInputsProvider = AutoDisposeProvider<String>.internal(
  balanceStringWithInputs,
  name: r'balanceStringWithInputsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$balanceStringWithInputsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BalanceStringWithInputsRef = AutoDisposeProviderRef<String>;
String _$assetBalanceWithInputsInDefaultCurrencyHash() =>
    r'09815675cc64e1a1726942ef42b00316113140d8';

/// See also [assetBalanceWithInputsInDefaultCurrency].
@ProviderFor(assetBalanceWithInputsInDefaultCurrency)
const assetBalanceWithInputsInDefaultCurrencyProvider =
    AssetBalanceWithInputsInDefaultCurrencyFamily();

/// See also [assetBalanceWithInputsInDefaultCurrency].
class AssetBalanceWithInputsInDefaultCurrencyFamily extends Family<Decimal> {
  /// See also [assetBalanceWithInputsInDefaultCurrency].
  const AssetBalanceWithInputsInDefaultCurrencyFamily();

  /// See also [assetBalanceWithInputsInDefaultCurrency].
  AssetBalanceWithInputsInDefaultCurrencyProvider call(String assetId) {
    return AssetBalanceWithInputsInDefaultCurrencyProvider(assetId);
  }

  @override
  AssetBalanceWithInputsInDefaultCurrencyProvider getProviderOverride(
    covariant AssetBalanceWithInputsInDefaultCurrencyProvider provider,
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
  String? get name => r'assetBalanceWithInputsInDefaultCurrencyProvider';
}

/// See also [assetBalanceWithInputsInDefaultCurrency].
class AssetBalanceWithInputsInDefaultCurrencyProvider
    extends AutoDisposeProvider<Decimal> {
  /// See also [assetBalanceWithInputsInDefaultCurrency].
  AssetBalanceWithInputsInDefaultCurrencyProvider(String assetId)
    : this._internal(
        (ref) => assetBalanceWithInputsInDefaultCurrency(
          ref as AssetBalanceWithInputsInDefaultCurrencyRef,
          assetId,
        ),
        from: assetBalanceWithInputsInDefaultCurrencyProvider,
        name: r'assetBalanceWithInputsInDefaultCurrencyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetBalanceWithInputsInDefaultCurrencyHash,
        dependencies:
            AssetBalanceWithInputsInDefaultCurrencyFamily._dependencies,
        allTransitiveDependencies: AssetBalanceWithInputsInDefaultCurrencyFamily
            ._allTransitiveDependencies,
        assetId: assetId,
      );

  AssetBalanceWithInputsInDefaultCurrencyProvider._internal(
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
    Decimal Function(AssetBalanceWithInputsInDefaultCurrencyRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetBalanceWithInputsInDefaultCurrencyProvider._internal(
        (ref) => create(ref as AssetBalanceWithInputsInDefaultCurrencyRef),
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
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AssetBalanceWithInputsInDefaultCurrencyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceWithInputsInDefaultCurrencyProvider &&
        other.assetId == assetId;
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
mixin AssetBalanceWithInputsInDefaultCurrencyRef
    on AutoDisposeProviderRef<Decimal> {
  /// The parameter `assetId` of this provider.
  String get assetId;
}

class _AssetBalanceWithInputsInDefaultCurrencyProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with AssetBalanceWithInputsInDefaultCurrencyRef {
  _AssetBalanceWithInputsInDefaultCurrencyProviderElement(super.provider);

  @override
  String get assetId =>
      (origin as AssetBalanceWithInputsInDefaultCurrencyProvider).assetId;
}

String _$assetBalanceWithInputsInDefaultCurrencyStringHash() =>
    r'694a49cd1bf9770aef7e95c0be1f47060fc46ed1';

/// See also [assetBalanceWithInputsInDefaultCurrencyString].
@ProviderFor(assetBalanceWithInputsInDefaultCurrencyString)
const assetBalanceWithInputsInDefaultCurrencyStringProvider =
    AssetBalanceWithInputsInDefaultCurrencyStringFamily();

/// See also [assetBalanceWithInputsInDefaultCurrencyString].
class AssetBalanceWithInputsInDefaultCurrencyStringFamily
    extends Family<String> {
  /// See also [assetBalanceWithInputsInDefaultCurrencyString].
  const AssetBalanceWithInputsInDefaultCurrencyStringFamily();

  /// See also [assetBalanceWithInputsInDefaultCurrencyString].
  AssetBalanceWithInputsInDefaultCurrencyStringProvider call(String assetId) {
    return AssetBalanceWithInputsInDefaultCurrencyStringProvider(assetId);
  }

  @override
  AssetBalanceWithInputsInDefaultCurrencyStringProvider getProviderOverride(
    covariant AssetBalanceWithInputsInDefaultCurrencyStringProvider provider,
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
  String? get name => r'assetBalanceWithInputsInDefaultCurrencyStringProvider';
}

/// See also [assetBalanceWithInputsInDefaultCurrencyString].
class AssetBalanceWithInputsInDefaultCurrencyStringProvider
    extends AutoDisposeProvider<String> {
  /// See also [assetBalanceWithInputsInDefaultCurrencyString].
  AssetBalanceWithInputsInDefaultCurrencyStringProvider(String assetId)
    : this._internal(
        (ref) => assetBalanceWithInputsInDefaultCurrencyString(
          ref as AssetBalanceWithInputsInDefaultCurrencyStringRef,
          assetId,
        ),
        from: assetBalanceWithInputsInDefaultCurrencyStringProvider,
        name: r'assetBalanceWithInputsInDefaultCurrencyStringProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetBalanceWithInputsInDefaultCurrencyStringHash,
        dependencies:
            AssetBalanceWithInputsInDefaultCurrencyStringFamily._dependencies,
        allTransitiveDependencies:
            AssetBalanceWithInputsInDefaultCurrencyStringFamily
                ._allTransitiveDependencies,
        assetId: assetId,
      );

  AssetBalanceWithInputsInDefaultCurrencyStringProvider._internal(
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
    String Function(AssetBalanceWithInputsInDefaultCurrencyStringRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetBalanceWithInputsInDefaultCurrencyStringProvider._internal(
        (ref) =>
            create(ref as AssetBalanceWithInputsInDefaultCurrencyStringRef),
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
  AutoDisposeProviderElement<String> createElement() {
    return _AssetBalanceWithInputsInDefaultCurrencyStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceWithInputsInDefaultCurrencyStringProvider &&
        other.assetId == assetId;
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
mixin AssetBalanceWithInputsInDefaultCurrencyStringRef
    on AutoDisposeProviderRef<String> {
  /// The parameter `assetId` of this provider.
  String get assetId;
}

class _AssetBalanceWithInputsInDefaultCurrencyStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AssetBalanceWithInputsInDefaultCurrencyStringRef {
  _AssetBalanceWithInputsInDefaultCurrencyStringProviderElement(super.provider);

  @override
  String get assetId =>
      (origin as AssetBalanceWithInputsInDefaultCurrencyStringProvider).assetId;
}

String _$availableBalanceForAssetIdHash() =>
    r'549bf9ece9f30ab63ac70d93508b66f1a0909904';

/// Balance providers without inputs
///
/// Copied from [availableBalanceForAssetId].
@ProviderFor(availableBalanceForAssetId)
const availableBalanceForAssetIdProvider = AvailableBalanceForAssetIdFamily();

/// Balance providers without inputs
///
/// Copied from [availableBalanceForAssetId].
class AvailableBalanceForAssetIdFamily extends Family<int> {
  /// Balance providers without inputs
  ///
  /// Copied from [availableBalanceForAssetId].
  const AvailableBalanceForAssetIdFamily();

  /// Balance providers without inputs
  ///
  /// Copied from [availableBalanceForAssetId].
  AvailableBalanceForAssetIdProvider call(String assetId) {
    return AvailableBalanceForAssetIdProvider(assetId);
  }

  @override
  AvailableBalanceForAssetIdProvider getProviderOverride(
    covariant AvailableBalanceForAssetIdProvider provider,
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
  String? get name => r'availableBalanceForAssetIdProvider';
}

/// Balance providers without inputs
///
/// Copied from [availableBalanceForAssetId].
class AvailableBalanceForAssetIdProvider extends AutoDisposeProvider<int> {
  /// Balance providers without inputs
  ///
  /// Copied from [availableBalanceForAssetId].
  AvailableBalanceForAssetIdProvider(String assetId)
    : this._internal(
        (ref) => availableBalanceForAssetId(
          ref as AvailableBalanceForAssetIdRef,
          assetId,
        ),
        from: availableBalanceForAssetIdProvider,
        name: r'availableBalanceForAssetIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$availableBalanceForAssetIdHash,
        dependencies: AvailableBalanceForAssetIdFamily._dependencies,
        allTransitiveDependencies:
            AvailableBalanceForAssetIdFamily._allTransitiveDependencies,
        assetId: assetId,
      );

  AvailableBalanceForAssetIdProvider._internal(
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
    int Function(AvailableBalanceForAssetIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableBalanceForAssetIdProvider._internal(
        (ref) => create(ref as AvailableBalanceForAssetIdRef),
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
  AutoDisposeProviderElement<int> createElement() {
    return _AvailableBalanceForAssetIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableBalanceForAssetIdProvider &&
        other.assetId == assetId;
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
mixin AvailableBalanceForAssetIdRef on AutoDisposeProviderRef<int> {
  /// The parameter `assetId` of this provider.
  String get assetId;
}

class _AvailableBalanceForAssetIdProviderElement
    extends AutoDisposeProviderElement<int>
    with AvailableBalanceForAssetIdRef {
  _AvailableBalanceForAssetIdProviderElement(super.provider);

  @override
  String get assetId => (origin as AvailableBalanceForAssetIdProvider).assetId;
}

String _$amountUsdInDefaultCurrencyHash() =>
    r'b8085e473b91fb484a717183baced9801f1b3b81';

/// See also [amountUsdInDefaultCurrency].
@ProviderFor(amountUsdInDefaultCurrency)
const amountUsdInDefaultCurrencyProvider = AmountUsdInDefaultCurrencyFamily();

/// See also [amountUsdInDefaultCurrency].
class AmountUsdInDefaultCurrencyFamily extends Family<Decimal> {
  /// See also [amountUsdInDefaultCurrency].
  const AmountUsdInDefaultCurrencyFamily();

  /// See also [amountUsdInDefaultCurrency].
  AmountUsdInDefaultCurrencyProvider call(String? assetId, num amount) {
    return AmountUsdInDefaultCurrencyProvider(assetId, amount);
  }

  @override
  AmountUsdInDefaultCurrencyProvider getProviderOverride(
    covariant AmountUsdInDefaultCurrencyProvider provider,
  ) {
    return call(provider.assetId, provider.amount);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'amountUsdInDefaultCurrencyProvider';
}

/// See also [amountUsdInDefaultCurrency].
class AmountUsdInDefaultCurrencyProvider extends AutoDisposeProvider<Decimal> {
  /// See also [amountUsdInDefaultCurrency].
  AmountUsdInDefaultCurrencyProvider(String? assetId, num amount)
    : this._internal(
        (ref) => amountUsdInDefaultCurrency(
          ref as AmountUsdInDefaultCurrencyRef,
          assetId,
          amount,
        ),
        from: amountUsdInDefaultCurrencyProvider,
        name: r'amountUsdInDefaultCurrencyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$amountUsdInDefaultCurrencyHash,
        dependencies: AmountUsdInDefaultCurrencyFamily._dependencies,
        allTransitiveDependencies:
            AmountUsdInDefaultCurrencyFamily._allTransitiveDependencies,
        assetId: assetId,
        amount: amount,
      );

  AmountUsdInDefaultCurrencyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
    required this.amount,
  }) : super.internal();

  final String? assetId;
  final num amount;

  @override
  Override overrideWith(
    Decimal Function(AmountUsdInDefaultCurrencyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AmountUsdInDefaultCurrencyProvider._internal(
        (ref) => create(ref as AmountUsdInDefaultCurrencyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetId: assetId,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AmountUsdInDefaultCurrencyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AmountUsdInDefaultCurrencyProvider &&
        other.assetId == assetId &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AmountUsdInDefaultCurrencyRef on AutoDisposeProviderRef<Decimal> {
  /// The parameter `assetId` of this provider.
  String? get assetId;

  /// The parameter `amount` of this provider.
  num get amount;
}

class _AmountUsdInDefaultCurrencyProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with AmountUsdInDefaultCurrencyRef {
  _AmountUsdInDefaultCurrencyProviderElement(super.provider);

  @override
  String? get assetId => (origin as AmountUsdInDefaultCurrencyProvider).assetId;
  @override
  num get amount => (origin as AmountUsdInDefaultCurrencyProvider).amount;
}

String _$amountUsdHash() => r'2f5f742dc80fd059509795b599573b592f8297d7';

/// See also [amountUsd].
@ProviderFor(amountUsd)
const amountUsdProvider = AmountUsdFamily();

/// See also [amountUsd].
class AmountUsdFamily extends Family<Decimal> {
  /// See also [amountUsd].
  const AmountUsdFamily();

  /// See also [amountUsd].
  AmountUsdProvider call(String? assetId, num amount) {
    return AmountUsdProvider(assetId, amount);
  }

  @override
  AmountUsdProvider getProviderOverride(covariant AmountUsdProvider provider) {
    return call(provider.assetId, provider.amount);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'amountUsdProvider';
}

/// See also [amountUsd].
class AmountUsdProvider extends AutoDisposeProvider<Decimal> {
  /// See also [amountUsd].
  AmountUsdProvider(String? assetId, num amount)
    : this._internal(
        (ref) => amountUsd(ref as AmountUsdRef, assetId, amount),
        from: amountUsdProvider,
        name: r'amountUsdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$amountUsdHash,
        dependencies: AmountUsdFamily._dependencies,
        allTransitiveDependencies: AmountUsdFamily._allTransitiveDependencies,
        assetId: assetId,
        amount: amount,
      );

  AmountUsdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
    required this.amount,
  }) : super.internal();

  final String? assetId;
  final num amount;

  @override
  Override overrideWith(Decimal Function(AmountUsdRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: AmountUsdProvider._internal(
        (ref) => create(ref as AmountUsdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetId: assetId,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AmountUsdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AmountUsdProvider &&
        other.assetId == assetId &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AmountUsdRef on AutoDisposeProviderRef<Decimal> {
  /// The parameter `assetId` of this provider.
  String? get assetId;

  /// The parameter `amount` of this provider.
  num get amount;
}

class _AmountUsdProviderElement extends AutoDisposeProviderElement<Decimal>
    with AmountUsdRef {
  _AmountUsdProviderElement(super.provider);

  @override
  String? get assetId => (origin as AmountUsdProvider).assetId;
  @override
  num get amount => (origin as AmountUsdProvider).amount;
}

String _$isAmountUsdAvailableHash() =>
    r'e1083a6c6202a70780343a4fe5d111f3ceaeca54';

/// See also [isAmountUsdAvailable].
@ProviderFor(isAmountUsdAvailable)
const isAmountUsdAvailableProvider = IsAmountUsdAvailableFamily();

/// See also [isAmountUsdAvailable].
class IsAmountUsdAvailableFamily extends Family<bool> {
  /// See also [isAmountUsdAvailable].
  const IsAmountUsdAvailableFamily();

  /// See also [isAmountUsdAvailable].
  IsAmountUsdAvailableProvider call(String? assetId) {
    return IsAmountUsdAvailableProvider(assetId);
  }

  @override
  IsAmountUsdAvailableProvider getProviderOverride(
    covariant IsAmountUsdAvailableProvider provider,
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
  String? get name => r'isAmountUsdAvailableProvider';
}

/// See also [isAmountUsdAvailable].
class IsAmountUsdAvailableProvider extends AutoDisposeProvider<bool> {
  /// See also [isAmountUsdAvailable].
  IsAmountUsdAvailableProvider(String? assetId)
    : this._internal(
        (ref) => isAmountUsdAvailable(ref as IsAmountUsdAvailableRef, assetId),
        from: isAmountUsdAvailableProvider,
        name: r'isAmountUsdAvailableProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$isAmountUsdAvailableHash,
        dependencies: IsAmountUsdAvailableFamily._dependencies,
        allTransitiveDependencies:
            IsAmountUsdAvailableFamily._allTransitiveDependencies,
        assetId: assetId,
      );

  IsAmountUsdAvailableProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
  }) : super.internal();

  final String? assetId;

  @override
  Override overrideWith(
    bool Function(IsAmountUsdAvailableRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsAmountUsdAvailableProvider._internal(
        (ref) => create(ref as IsAmountUsdAvailableRef),
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
    return _IsAmountUsdAvailableProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsAmountUsdAvailableProvider && other.assetId == assetId;
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
mixin IsAmountUsdAvailableRef on AutoDisposeProviderRef<bool> {
  /// The parameter `assetId` of this provider.
  String? get assetId;
}

class _IsAmountUsdAvailableProviderElement
    extends AutoDisposeProviderElement<bool>
    with IsAmountUsdAvailableRef {
  _IsAmountUsdAvailableProviderElement(super.provider);

  @override
  String? get assetId => (origin as IsAmountUsdAvailableProvider).assetId;
}

String _$defaultCurrencyConversionHash() =>
    r'f326e73283c18198419da837b2bfb457fa342cdc';

/// See also [defaultCurrencyConversion].
@ProviderFor(defaultCurrencyConversion)
const defaultCurrencyConversionProvider = DefaultCurrencyConversionFamily();

/// See also [defaultCurrencyConversion].
class DefaultCurrencyConversionFamily extends Family<String> {
  /// See also [defaultCurrencyConversion].
  const DefaultCurrencyConversionFamily();

  /// See also [defaultCurrencyConversion].
  DefaultCurrencyConversionProvider call(String? assetId, num amount) {
    return DefaultCurrencyConversionProvider(assetId, amount);
  }

  @override
  DefaultCurrencyConversionProvider getProviderOverride(
    covariant DefaultCurrencyConversionProvider provider,
  ) {
    return call(provider.assetId, provider.amount);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'defaultCurrencyConversionProvider';
}

/// See also [defaultCurrencyConversion].
class DefaultCurrencyConversionProvider extends AutoDisposeProvider<String> {
  /// See also [defaultCurrencyConversion].
  DefaultCurrencyConversionProvider(String? assetId, num amount)
    : this._internal(
        (ref) => defaultCurrencyConversion(
          ref as DefaultCurrencyConversionRef,
          assetId,
          amount,
        ),
        from: defaultCurrencyConversionProvider,
        name: r'defaultCurrencyConversionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$defaultCurrencyConversionHash,
        dependencies: DefaultCurrencyConversionFamily._dependencies,
        allTransitiveDependencies:
            DefaultCurrencyConversionFamily._allTransitiveDependencies,
        assetId: assetId,
        amount: amount,
      );

  DefaultCurrencyConversionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
    required this.amount,
  }) : super.internal();

  final String? assetId;
  final num amount;

  @override
  Override overrideWith(
    String Function(DefaultCurrencyConversionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DefaultCurrencyConversionProvider._internal(
        (ref) => create(ref as DefaultCurrencyConversionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetId: assetId,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _DefaultCurrencyConversionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefaultCurrencyConversionProvider &&
        other.assetId == assetId &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DefaultCurrencyConversionRef on AutoDisposeProviderRef<String> {
  /// The parameter `assetId` of this provider.
  String? get assetId;

  /// The parameter `amount` of this provider.
  num get amount;
}

class _DefaultCurrencyConversionProviderElement
    extends AutoDisposeProviderElement<String>
    with DefaultCurrencyConversionRef {
  _DefaultCurrencyConversionProviderElement(super.provider);

  @override
  String? get assetId => (origin as DefaultCurrencyConversionProvider).assetId;
  @override
  num get amount => (origin as DefaultCurrencyConversionProvider).amount;
}

String _$defaultCurrencyConversionWithTickerHash() =>
    r'd2d453077c021fee579cb7dc35e6dca567d5f128';

/// See also [defaultCurrencyConversionWithTicker].
@ProviderFor(defaultCurrencyConversionWithTicker)
const defaultCurrencyConversionWithTickerProvider =
    DefaultCurrencyConversionWithTickerFamily();

/// See also [defaultCurrencyConversionWithTicker].
class DefaultCurrencyConversionWithTickerFamily extends Family<String> {
  /// See also [defaultCurrencyConversionWithTicker].
  const DefaultCurrencyConversionWithTickerFamily();

  /// See also [defaultCurrencyConversionWithTicker].
  DefaultCurrencyConversionWithTickerProvider call(
    String? assetId,
    num amount,
  ) {
    return DefaultCurrencyConversionWithTickerProvider(assetId, amount);
  }

  @override
  DefaultCurrencyConversionWithTickerProvider getProviderOverride(
    covariant DefaultCurrencyConversionWithTickerProvider provider,
  ) {
    return call(provider.assetId, provider.amount);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'defaultCurrencyConversionWithTickerProvider';
}

/// See also [defaultCurrencyConversionWithTicker].
class DefaultCurrencyConversionWithTickerProvider
    extends AutoDisposeProvider<String> {
  /// See also [defaultCurrencyConversionWithTicker].
  DefaultCurrencyConversionWithTickerProvider(String? assetId, num amount)
    : this._internal(
        (ref) => defaultCurrencyConversionWithTicker(
          ref as DefaultCurrencyConversionWithTickerRef,
          assetId,
          amount,
        ),
        from: defaultCurrencyConversionWithTickerProvider,
        name: r'defaultCurrencyConversionWithTickerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$defaultCurrencyConversionWithTickerHash,
        dependencies: DefaultCurrencyConversionWithTickerFamily._dependencies,
        allTransitiveDependencies: DefaultCurrencyConversionWithTickerFamily
            ._allTransitiveDependencies,
        assetId: assetId,
        amount: amount,
      );

  DefaultCurrencyConversionWithTickerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
    required this.amount,
  }) : super.internal();

  final String? assetId;
  final num amount;

  @override
  Override overrideWith(
    String Function(DefaultCurrencyConversionWithTickerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DefaultCurrencyConversionWithTickerProvider._internal(
        (ref) => create(ref as DefaultCurrencyConversionWithTickerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetId: assetId,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _DefaultCurrencyConversionWithTickerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefaultCurrencyConversionWithTickerProvider &&
        other.assetId == assetId &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DefaultCurrencyConversionWithTickerRef on AutoDisposeProviderRef<String> {
  /// The parameter `assetId` of this provider.
  String? get assetId;

  /// The parameter `amount` of this provider.
  num get amount;
}

class _DefaultCurrencyConversionWithTickerProviderElement
    extends AutoDisposeProviderElement<String>
    with DefaultCurrencyConversionWithTickerRef {
  _DefaultCurrencyConversionWithTickerProviderElement(super.provider);

  @override
  String? get assetId =>
      (origin as DefaultCurrencyConversionWithTickerProvider).assetId;
  @override
  num get amount =>
      (origin as DefaultCurrencyConversionWithTickerProvider).amount;
}

String _$defaultCurrencyConversionFromStringHash() =>
    r'a934e1fc12818e61e309492cd0d49dddc001d539';

/// See also [defaultCurrencyConversionFromString].
@ProviderFor(defaultCurrencyConversionFromString)
const defaultCurrencyConversionFromStringProvider =
    DefaultCurrencyConversionFromStringFamily();

/// See also [defaultCurrencyConversionFromString].
class DefaultCurrencyConversionFromStringFamily extends Family<String> {
  /// See also [defaultCurrencyConversionFromString].
  const DefaultCurrencyConversionFromStringFamily();

  /// See also [defaultCurrencyConversionFromString].
  DefaultCurrencyConversionFromStringProvider call(
    String? assetId,
    String amount,
  ) {
    return DefaultCurrencyConversionFromStringProvider(assetId, amount);
  }

  @override
  DefaultCurrencyConversionFromStringProvider getProviderOverride(
    covariant DefaultCurrencyConversionFromStringProvider provider,
  ) {
    return call(provider.assetId, provider.amount);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'defaultCurrencyConversionFromStringProvider';
}

/// See also [defaultCurrencyConversionFromString].
class DefaultCurrencyConversionFromStringProvider
    extends AutoDisposeProvider<String> {
  /// See also [defaultCurrencyConversionFromString].
  DefaultCurrencyConversionFromStringProvider(String? assetId, String amount)
    : this._internal(
        (ref) => defaultCurrencyConversionFromString(
          ref as DefaultCurrencyConversionFromStringRef,
          assetId,
          amount,
        ),
        from: defaultCurrencyConversionFromStringProvider,
        name: r'defaultCurrencyConversionFromStringProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$defaultCurrencyConversionFromStringHash,
        dependencies: DefaultCurrencyConversionFromStringFamily._dependencies,
        allTransitiveDependencies: DefaultCurrencyConversionFromStringFamily
            ._allTransitiveDependencies,
        assetId: assetId,
        amount: amount,
      );

  DefaultCurrencyConversionFromStringProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
    required this.amount,
  }) : super.internal();

  final String? assetId;
  final String amount;

  @override
  Override overrideWith(
    String Function(DefaultCurrencyConversionFromStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DefaultCurrencyConversionFromStringProvider._internal(
        (ref) => create(ref as DefaultCurrencyConversionFromStringRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetId: assetId,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _DefaultCurrencyConversionFromStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DefaultCurrencyConversionFromStringProvider &&
        other.assetId == assetId &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DefaultCurrencyConversionFromStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `assetId` of this provider.
  String? get assetId;

  /// The parameter `amount` of this provider.
  String get amount;
}

class _DefaultCurrencyConversionFromStringProviderElement
    extends AutoDisposeProviderElement<String>
    with DefaultCurrencyConversionFromStringRef {
  _DefaultCurrencyConversionFromStringProviderElement(super.provider);

  @override
  String? get assetId =>
      (origin as DefaultCurrencyConversionFromStringProvider).assetId;
  @override
  String get amount =>
      (origin as DefaultCurrencyConversionFromStringProvider).amount;
}

String _$assetsTotalLbtcBalanceHash() =>
    r'16487b0a459f6e32e6bb10f1b305e28907d71021';

/// Total LBTC ============
///
/// Copied from [assetsTotalLbtcBalance].
@ProviderFor(assetsTotalLbtcBalance)
const assetsTotalLbtcBalanceProvider = AssetsTotalLbtcBalanceFamily();

/// Total LBTC ============
///
/// Copied from [assetsTotalLbtcBalance].
class AssetsTotalLbtcBalanceFamily extends Family<String> {
  /// Total LBTC ============
  ///
  /// Copied from [assetsTotalLbtcBalance].
  const AssetsTotalLbtcBalanceFamily();

  /// Total LBTC ============
  ///
  /// Copied from [assetsTotalLbtcBalance].
  AssetsTotalLbtcBalanceProvider call(Iterable<Asset> assets) {
    return AssetsTotalLbtcBalanceProvider(assets);
  }

  @override
  AssetsTotalLbtcBalanceProvider getProviderOverride(
    covariant AssetsTotalLbtcBalanceProvider provider,
  ) {
    return call(provider.assets);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetsTotalLbtcBalanceProvider';
}

/// Total LBTC ============
///
/// Copied from [assetsTotalLbtcBalance].
class AssetsTotalLbtcBalanceProvider extends AutoDisposeProvider<String> {
  /// Total LBTC ============
  ///
  /// Copied from [assetsTotalLbtcBalance].
  AssetsTotalLbtcBalanceProvider(Iterable<Asset> assets)
    : this._internal(
        (ref) =>
            assetsTotalLbtcBalance(ref as AssetsTotalLbtcBalanceRef, assets),
        from: assetsTotalLbtcBalanceProvider,
        name: r'assetsTotalLbtcBalanceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetsTotalLbtcBalanceHash,
        dependencies: AssetsTotalLbtcBalanceFamily._dependencies,
        allTransitiveDependencies:
            AssetsTotalLbtcBalanceFamily._allTransitiveDependencies,
        assets: assets,
      );

  AssetsTotalLbtcBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assets,
  }) : super.internal();

  final Iterable<Asset> assets;

  @override
  Override overrideWith(
    String Function(AssetsTotalLbtcBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetsTotalLbtcBalanceProvider._internal(
        (ref) => create(ref as AssetsTotalLbtcBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assets: assets,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _AssetsTotalLbtcBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetsTotalLbtcBalanceProvider && other.assets == assets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assets.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetsTotalLbtcBalanceRef on AutoDisposeProviderRef<String> {
  /// The parameter `assets` of this provider.
  Iterable<Asset> get assets;
}

class _AssetsTotalLbtcBalanceProviderElement
    extends AutoDisposeProviderElement<String>
    with AssetsTotalLbtcBalanceRef {
  _AssetsTotalLbtcBalanceProviderElement(super.provider);

  @override
  Iterable<Asset> get assets =>
      (origin as AssetsTotalLbtcBalanceProvider).assets;
}

String _$assetsTotalUsdBalanceStringHash() =>
    r'068b4d330301da9e7b9d8f1991800dc46ba08f16';

/// USD currency converters ============
///
/// Copied from [_assetsTotalUsdBalanceString].
@ProviderFor(_assetsTotalUsdBalanceString)
const _assetsTotalUsdBalanceStringProvider =
    _AssetsTotalUsdBalanceStringFamily();

/// USD currency converters ============
///
/// Copied from [_assetsTotalUsdBalanceString].
class _AssetsTotalUsdBalanceStringFamily extends Family<String> {
  /// USD currency converters ============
  ///
  /// Copied from [_assetsTotalUsdBalanceString].
  const _AssetsTotalUsdBalanceStringFamily();

  /// USD currency converters ============
  ///
  /// Copied from [_assetsTotalUsdBalanceString].
  _AssetsTotalUsdBalanceStringProvider call(Iterable<Asset> assets) {
    return _AssetsTotalUsdBalanceStringProvider(assets);
  }

  @override
  _AssetsTotalUsdBalanceStringProvider getProviderOverride(
    covariant _AssetsTotalUsdBalanceStringProvider provider,
  ) {
    return call(provider.assets);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_assetsTotalUsdBalanceStringProvider';
}

/// USD currency converters ============
///
/// Copied from [_assetsTotalUsdBalanceString].
class _AssetsTotalUsdBalanceStringProvider extends AutoDisposeProvider<String> {
  /// USD currency converters ============
  ///
  /// Copied from [_assetsTotalUsdBalanceString].
  _AssetsTotalUsdBalanceStringProvider(Iterable<Asset> assets)
    : this._internal(
        (ref) => _assetsTotalUsdBalanceString(
          ref as _AssetsTotalUsdBalanceStringRef,
          assets,
        ),
        from: _assetsTotalUsdBalanceStringProvider,
        name: r'_assetsTotalUsdBalanceStringProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetsTotalUsdBalanceStringHash,
        dependencies: _AssetsTotalUsdBalanceStringFamily._dependencies,
        allTransitiveDependencies:
            _AssetsTotalUsdBalanceStringFamily._allTransitiveDependencies,
        assets: assets,
      );

  _AssetsTotalUsdBalanceStringProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assets,
  }) : super.internal();

  final Iterable<Asset> assets;

  @override
  Override overrideWith(
    String Function(_AssetsTotalUsdBalanceStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _AssetsTotalUsdBalanceStringProvider._internal(
        (ref) => create(ref as _AssetsTotalUsdBalanceStringRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assets: assets,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _AssetsTotalUsdBalanceStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _AssetsTotalUsdBalanceStringProvider &&
        other.assets == assets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assets.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _AssetsTotalUsdBalanceStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `assets` of this provider.
  Iterable<Asset> get assets;
}

class _AssetsTotalUsdBalanceStringProviderElement
    extends AutoDisposeProviderElement<String>
    with _AssetsTotalUsdBalanceStringRef {
  _AssetsTotalUsdBalanceStringProviderElement(super.provider);

  @override
  Iterable<Asset> get assets =>
      (origin as _AssetsTotalUsdBalanceStringProvider).assets;
}

String _$assetsTotalUsdBalanceHash() =>
    r'5917299bf7d2437a39861d495878b1dc712957bb';

/// See also [_assetsTotalUsdBalance].
@ProviderFor(_assetsTotalUsdBalance)
const _assetsTotalUsdBalanceProvider = _AssetsTotalUsdBalanceFamily();

/// See also [_assetsTotalUsdBalance].
class _AssetsTotalUsdBalanceFamily extends Family<Decimal> {
  /// See also [_assetsTotalUsdBalance].
  const _AssetsTotalUsdBalanceFamily();

  /// See also [_assetsTotalUsdBalance].
  _AssetsTotalUsdBalanceProvider call(Iterable<Asset> assets) {
    return _AssetsTotalUsdBalanceProvider(assets);
  }

  @override
  _AssetsTotalUsdBalanceProvider getProviderOverride(
    covariant _AssetsTotalUsdBalanceProvider provider,
  ) {
    return call(provider.assets);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_assetsTotalUsdBalanceProvider';
}

/// See also [_assetsTotalUsdBalance].
class _AssetsTotalUsdBalanceProvider extends AutoDisposeProvider<Decimal> {
  /// See also [_assetsTotalUsdBalance].
  _AssetsTotalUsdBalanceProvider(Iterable<Asset> assets)
    : this._internal(
        (ref) =>
            _assetsTotalUsdBalance(ref as _AssetsTotalUsdBalanceRef, assets),
        from: _assetsTotalUsdBalanceProvider,
        name: r'_assetsTotalUsdBalanceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetsTotalUsdBalanceHash,
        dependencies: _AssetsTotalUsdBalanceFamily._dependencies,
        allTransitiveDependencies:
            _AssetsTotalUsdBalanceFamily._allTransitiveDependencies,
        assets: assets,
      );

  _AssetsTotalUsdBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assets,
  }) : super.internal();

  final Iterable<Asset> assets;

  @override
  Override overrideWith(
    Decimal Function(_AssetsTotalUsdBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _AssetsTotalUsdBalanceProvider._internal(
        (ref) => create(ref as _AssetsTotalUsdBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assets: assets,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AssetsTotalUsdBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _AssetsTotalUsdBalanceProvider && other.assets == assets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assets.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _AssetsTotalUsdBalanceRef on AutoDisposeProviderRef<Decimal> {
  /// The parameter `assets` of this provider.
  Iterable<Asset> get assets;
}

class _AssetsTotalUsdBalanceProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with _AssetsTotalUsdBalanceRef {
  _AssetsTotalUsdBalanceProviderElement(super.provider);

  @override
  Iterable<Asset> get assets =>
      (origin as _AssetsTotalUsdBalanceProvider).assets;
}

String _$assetBalanceInUsdHash() => r'91b0ef21bb616aebbab8eb82961e7228395648c1';

/// See also [_assetBalanceInUsd].
@ProviderFor(_assetBalanceInUsd)
const _assetBalanceInUsdProvider = _AssetBalanceInUsdFamily();

/// See also [_assetBalanceInUsd].
class _AssetBalanceInUsdFamily extends Family<Decimal> {
  /// See also [_assetBalanceInUsd].
  const _AssetBalanceInUsdFamily();

  /// See also [_assetBalanceInUsd].
  _AssetBalanceInUsdProvider call(Asset asset) {
    return _AssetBalanceInUsdProvider(asset);
  }

  @override
  _AssetBalanceInUsdProvider getProviderOverride(
    covariant _AssetBalanceInUsdProvider provider,
  ) {
    return call(provider.asset);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_assetBalanceInUsdProvider';
}

/// See also [_assetBalanceInUsd].
class _AssetBalanceInUsdProvider extends AutoDisposeProvider<Decimal> {
  /// See also [_assetBalanceInUsd].
  _AssetBalanceInUsdProvider(Asset asset)
    : this._internal(
        (ref) => _assetBalanceInUsd(ref as _AssetBalanceInUsdRef, asset),
        from: _assetBalanceInUsdProvider,
        name: r'_assetBalanceInUsdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetBalanceInUsdHash,
        dependencies: _AssetBalanceInUsdFamily._dependencies,
        allTransitiveDependencies:
            _AssetBalanceInUsdFamily._allTransitiveDependencies,
        asset: asset,
      );

  _AssetBalanceInUsdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.asset,
  }) : super.internal();

  final Asset asset;

  @override
  Override overrideWith(
    Decimal Function(_AssetBalanceInUsdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _AssetBalanceInUsdProvider._internal(
        (ref) => create(ref as _AssetBalanceInUsdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        asset: asset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AssetBalanceInUsdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _AssetBalanceInUsdProvider && other.asset == asset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, asset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _AssetBalanceInUsdRef on AutoDisposeProviderRef<Decimal> {
  /// The parameter `asset` of this provider.
  Asset get asset;
}

class _AssetBalanceInUsdProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with _AssetBalanceInUsdRef {
  _AssetBalanceInUsdProviderElement(super.provider);

  @override
  Asset get asset => (origin as _AssetBalanceInUsdProvider).asset;
}

String _$assetBalanceInUsdStringHash() =>
    r'4917857463ca2aff9d1ad3f693daeccf4aa61e29';

/// See also [_assetBalanceInUsdString].
@ProviderFor(_assetBalanceInUsdString)
const _assetBalanceInUsdStringProvider = _AssetBalanceInUsdStringFamily();

/// See also [_assetBalanceInUsdString].
class _AssetBalanceInUsdStringFamily extends Family<String> {
  /// See also [_assetBalanceInUsdString].
  const _AssetBalanceInUsdStringFamily();

  /// See also [_assetBalanceInUsdString].
  _AssetBalanceInUsdStringProvider call(Asset asset) {
    return _AssetBalanceInUsdStringProvider(asset);
  }

  @override
  _AssetBalanceInUsdStringProvider getProviderOverride(
    covariant _AssetBalanceInUsdStringProvider provider,
  ) {
    return call(provider.asset);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_assetBalanceInUsdStringProvider';
}

/// See also [_assetBalanceInUsdString].
class _AssetBalanceInUsdStringProvider extends AutoDisposeProvider<String> {
  /// See also [_assetBalanceInUsdString].
  _AssetBalanceInUsdStringProvider(Asset asset)
    : this._internal(
        (ref) =>
            _assetBalanceInUsdString(ref as _AssetBalanceInUsdStringRef, asset),
        from: _assetBalanceInUsdStringProvider,
        name: r'_assetBalanceInUsdStringProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetBalanceInUsdStringHash,
        dependencies: _AssetBalanceInUsdStringFamily._dependencies,
        allTransitiveDependencies:
            _AssetBalanceInUsdStringFamily._allTransitiveDependencies,
        asset: asset,
      );

  _AssetBalanceInUsdStringProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.asset,
  }) : super.internal();

  final Asset asset;

  @override
  Override overrideWith(
    String Function(_AssetBalanceInUsdStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _AssetBalanceInUsdStringProvider._internal(
        (ref) => create(ref as _AssetBalanceInUsdStringRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        asset: asset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _AssetBalanceInUsdStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _AssetBalanceInUsdStringProvider && other.asset == asset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, asset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _AssetBalanceInUsdStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `asset` of this provider.
  Asset get asset;
}

class _AssetBalanceInUsdStringProviderElement
    extends AutoDisposeProviderElement<String>
    with _AssetBalanceInUsdStringRef {
  _AssetBalanceInUsdStringProviderElement(super.provider);

  @override
  Asset get asset => (origin as _AssetBalanceInUsdStringProvider).asset;
}

String _$assetsTotalDefaultCurrencyBalanceStringHash() =>
    r'29324c093e8671a56041e2018d44e2854f6ae83f';

/// Default currency converters ============
///
/// Copied from [assetsTotalDefaultCurrencyBalanceString].
@ProviderFor(assetsTotalDefaultCurrencyBalanceString)
const assetsTotalDefaultCurrencyBalanceStringProvider =
    AssetsTotalDefaultCurrencyBalanceStringFamily();

/// Default currency converters ============
///
/// Copied from [assetsTotalDefaultCurrencyBalanceString].
class AssetsTotalDefaultCurrencyBalanceStringFamily extends Family<String> {
  /// Default currency converters ============
  ///
  /// Copied from [assetsTotalDefaultCurrencyBalanceString].
  const AssetsTotalDefaultCurrencyBalanceStringFamily();

  /// Default currency converters ============
  ///
  /// Copied from [assetsTotalDefaultCurrencyBalanceString].
  AssetsTotalDefaultCurrencyBalanceStringProvider call(Iterable<Asset> assets) {
    return AssetsTotalDefaultCurrencyBalanceStringProvider(assets);
  }

  @override
  AssetsTotalDefaultCurrencyBalanceStringProvider getProviderOverride(
    covariant AssetsTotalDefaultCurrencyBalanceStringProvider provider,
  ) {
    return call(provider.assets);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetsTotalDefaultCurrencyBalanceStringProvider';
}

/// Default currency converters ============
///
/// Copied from [assetsTotalDefaultCurrencyBalanceString].
class AssetsTotalDefaultCurrencyBalanceStringProvider
    extends AutoDisposeProvider<String> {
  /// Default currency converters ============
  ///
  /// Copied from [assetsTotalDefaultCurrencyBalanceString].
  AssetsTotalDefaultCurrencyBalanceStringProvider(Iterable<Asset> assets)
    : this._internal(
        (ref) => assetsTotalDefaultCurrencyBalanceString(
          ref as AssetsTotalDefaultCurrencyBalanceStringRef,
          assets,
        ),
        from: assetsTotalDefaultCurrencyBalanceStringProvider,
        name: r'assetsTotalDefaultCurrencyBalanceStringProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetsTotalDefaultCurrencyBalanceStringHash,
        dependencies:
            AssetsTotalDefaultCurrencyBalanceStringFamily._dependencies,
        allTransitiveDependencies: AssetsTotalDefaultCurrencyBalanceStringFamily
            ._allTransitiveDependencies,
        assets: assets,
      );

  AssetsTotalDefaultCurrencyBalanceStringProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assets,
  }) : super.internal();

  final Iterable<Asset> assets;

  @override
  Override overrideWith(
    String Function(AssetsTotalDefaultCurrencyBalanceStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetsTotalDefaultCurrencyBalanceStringProvider._internal(
        (ref) => create(ref as AssetsTotalDefaultCurrencyBalanceStringRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assets: assets,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _AssetsTotalDefaultCurrencyBalanceStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetsTotalDefaultCurrencyBalanceStringProvider &&
        other.assets == assets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assets.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetsTotalDefaultCurrencyBalanceStringRef
    on AutoDisposeProviderRef<String> {
  /// The parameter `assets` of this provider.
  Iterable<Asset> get assets;
}

class _AssetsTotalDefaultCurrencyBalanceStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AssetsTotalDefaultCurrencyBalanceStringRef {
  _AssetsTotalDefaultCurrencyBalanceStringProviderElement(super.provider);

  @override
  Iterable<Asset> get assets =>
      (origin as AssetsTotalDefaultCurrencyBalanceStringProvider).assets;
}

String _$assetsTotalDefaultCurrencyBalanceHash() =>
    r'f457c6ab7d96ae62263bd46a3df6785c093d259b';

/// See also [assetsTotalDefaultCurrencyBalance].
@ProviderFor(assetsTotalDefaultCurrencyBalance)
const assetsTotalDefaultCurrencyBalanceProvider =
    AssetsTotalDefaultCurrencyBalanceFamily();

/// See also [assetsTotalDefaultCurrencyBalance].
class AssetsTotalDefaultCurrencyBalanceFamily extends Family<Decimal> {
  /// See also [assetsTotalDefaultCurrencyBalance].
  const AssetsTotalDefaultCurrencyBalanceFamily();

  /// See also [assetsTotalDefaultCurrencyBalance].
  AssetsTotalDefaultCurrencyBalanceProvider call(Iterable<Asset> assets) {
    return AssetsTotalDefaultCurrencyBalanceProvider(assets);
  }

  @override
  AssetsTotalDefaultCurrencyBalanceProvider getProviderOverride(
    covariant AssetsTotalDefaultCurrencyBalanceProvider provider,
  ) {
    return call(provider.assets);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetsTotalDefaultCurrencyBalanceProvider';
}

/// See also [assetsTotalDefaultCurrencyBalance].
class AssetsTotalDefaultCurrencyBalanceProvider
    extends AutoDisposeProvider<Decimal> {
  /// See also [assetsTotalDefaultCurrencyBalance].
  AssetsTotalDefaultCurrencyBalanceProvider(Iterable<Asset> assets)
    : this._internal(
        (ref) => assetsTotalDefaultCurrencyBalance(
          ref as AssetsTotalDefaultCurrencyBalanceRef,
          assets,
        ),
        from: assetsTotalDefaultCurrencyBalanceProvider,
        name: r'assetsTotalDefaultCurrencyBalanceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetsTotalDefaultCurrencyBalanceHash,
        dependencies: AssetsTotalDefaultCurrencyBalanceFamily._dependencies,
        allTransitiveDependencies:
            AssetsTotalDefaultCurrencyBalanceFamily._allTransitiveDependencies,
        assets: assets,
      );

  AssetsTotalDefaultCurrencyBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assets,
  }) : super.internal();

  final Iterable<Asset> assets;

  @override
  Override overrideWith(
    Decimal Function(AssetsTotalDefaultCurrencyBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetsTotalDefaultCurrencyBalanceProvider._internal(
        (ref) => create(ref as AssetsTotalDefaultCurrencyBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assets: assets,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AssetsTotalDefaultCurrencyBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetsTotalDefaultCurrencyBalanceProvider &&
        other.assets == assets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assets.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetsTotalDefaultCurrencyBalanceRef on AutoDisposeProviderRef<Decimal> {
  /// The parameter `assets` of this provider.
  Iterable<Asset> get assets;
}

class _AssetsTotalDefaultCurrencyBalanceProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with AssetsTotalDefaultCurrencyBalanceRef {
  _AssetsTotalDefaultCurrencyBalanceProviderElement(super.provider);

  @override
  Iterable<Asset> get assets =>
      (origin as AssetsTotalDefaultCurrencyBalanceProvider).assets;
}

String _$assetBalanceInDefaultCurrencyHash() =>
    r'9cf3bad57732a85a70ba41a706da245b9995bade';

/// See also [assetBalanceInDefaultCurrency].
@ProviderFor(assetBalanceInDefaultCurrency)
const assetBalanceInDefaultCurrencyProvider =
    AssetBalanceInDefaultCurrencyFamily();

/// See also [assetBalanceInDefaultCurrency].
class AssetBalanceInDefaultCurrencyFamily extends Family<Decimal> {
  /// See also [assetBalanceInDefaultCurrency].
  const AssetBalanceInDefaultCurrencyFamily();

  /// See also [assetBalanceInDefaultCurrency].
  AssetBalanceInDefaultCurrencyProvider call(Asset asset) {
    return AssetBalanceInDefaultCurrencyProvider(asset);
  }

  @override
  AssetBalanceInDefaultCurrencyProvider getProviderOverride(
    covariant AssetBalanceInDefaultCurrencyProvider provider,
  ) {
    return call(provider.asset);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetBalanceInDefaultCurrencyProvider';
}

/// See also [assetBalanceInDefaultCurrency].
class AssetBalanceInDefaultCurrencyProvider
    extends AutoDisposeProvider<Decimal> {
  /// See also [assetBalanceInDefaultCurrency].
  AssetBalanceInDefaultCurrencyProvider(Asset asset)
    : this._internal(
        (ref) => assetBalanceInDefaultCurrency(
          ref as AssetBalanceInDefaultCurrencyRef,
          asset,
        ),
        from: assetBalanceInDefaultCurrencyProvider,
        name: r'assetBalanceInDefaultCurrencyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetBalanceInDefaultCurrencyHash,
        dependencies: AssetBalanceInDefaultCurrencyFamily._dependencies,
        allTransitiveDependencies:
            AssetBalanceInDefaultCurrencyFamily._allTransitiveDependencies,
        asset: asset,
      );

  AssetBalanceInDefaultCurrencyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.asset,
  }) : super.internal();

  final Asset asset;

  @override
  Override overrideWith(
    Decimal Function(AssetBalanceInDefaultCurrencyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetBalanceInDefaultCurrencyProvider._internal(
        (ref) => create(ref as AssetBalanceInDefaultCurrencyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        asset: asset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AssetBalanceInDefaultCurrencyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceInDefaultCurrencyProvider &&
        other.asset == asset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, asset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetBalanceInDefaultCurrencyRef on AutoDisposeProviderRef<Decimal> {
  /// The parameter `asset` of this provider.
  Asset get asset;
}

class _AssetBalanceInDefaultCurrencyProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with AssetBalanceInDefaultCurrencyRef {
  _AssetBalanceInDefaultCurrencyProviderElement(super.provider);

  @override
  Asset get asset => (origin as AssetBalanceInDefaultCurrencyProvider).asset;
}

String _$assetBalanceInDefaultCurrencyStringHash() =>
    r'74bd4ccf9655efd315bef50a019d70eb6f6e6287';

/// See also [assetBalanceInDefaultCurrencyString].
@ProviderFor(assetBalanceInDefaultCurrencyString)
const assetBalanceInDefaultCurrencyStringProvider =
    AssetBalanceInDefaultCurrencyStringFamily();

/// See also [assetBalanceInDefaultCurrencyString].
class AssetBalanceInDefaultCurrencyStringFamily extends Family<String> {
  /// See also [assetBalanceInDefaultCurrencyString].
  const AssetBalanceInDefaultCurrencyStringFamily();

  /// See also [assetBalanceInDefaultCurrencyString].
  AssetBalanceInDefaultCurrencyStringProvider call(Asset asset) {
    return AssetBalanceInDefaultCurrencyStringProvider(asset);
  }

  @override
  AssetBalanceInDefaultCurrencyStringProvider getProviderOverride(
    covariant AssetBalanceInDefaultCurrencyStringProvider provider,
  ) {
    return call(provider.asset);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetBalanceInDefaultCurrencyStringProvider';
}

/// See also [assetBalanceInDefaultCurrencyString].
class AssetBalanceInDefaultCurrencyStringProvider
    extends AutoDisposeProvider<String> {
  /// See also [assetBalanceInDefaultCurrencyString].
  AssetBalanceInDefaultCurrencyStringProvider(Asset asset)
    : this._internal(
        (ref) => assetBalanceInDefaultCurrencyString(
          ref as AssetBalanceInDefaultCurrencyStringRef,
          asset,
        ),
        from: assetBalanceInDefaultCurrencyStringProvider,
        name: r'assetBalanceInDefaultCurrencyStringProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetBalanceInDefaultCurrencyStringHash,
        dependencies: AssetBalanceInDefaultCurrencyStringFamily._dependencies,
        allTransitiveDependencies: AssetBalanceInDefaultCurrencyStringFamily
            ._allTransitiveDependencies,
        asset: asset,
      );

  AssetBalanceInDefaultCurrencyStringProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.asset,
  }) : super.internal();

  final Asset asset;

  @override
  Override overrideWith(
    String Function(AssetBalanceInDefaultCurrencyStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetBalanceInDefaultCurrencyStringProvider._internal(
        (ref) => create(ref as AssetBalanceInDefaultCurrencyStringRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        asset: asset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _AssetBalanceInDefaultCurrencyStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceInDefaultCurrencyStringProvider &&
        other.asset == asset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, asset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetBalanceInDefaultCurrencyStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `asset` of this provider.
  Asset get asset;
}

class _AssetBalanceInDefaultCurrencyStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AssetBalanceInDefaultCurrencyStringRef {
  _AssetBalanceInDefaultCurrencyStringProviderElement(super.provider);

  @override
  Asset get asset =>
      (origin as AssetBalanceInDefaultCurrencyStringProvider).asset;
}

String _$assetBalanceStringHash() =>
    r'e380490b0208128e3e34a2f56612b784ca04ef69';

/// Asset balance ============
///
/// Copied from [assetBalanceString].
@ProviderFor(assetBalanceString)
const assetBalanceStringProvider = AssetBalanceStringFamily();

/// Asset balance ============
///
/// Copied from [assetBalanceString].
class AssetBalanceStringFamily extends Family<String> {
  /// Asset balance ============
  ///
  /// Copied from [assetBalanceString].
  const AssetBalanceStringFamily();

  /// Asset balance ============
  ///
  /// Copied from [assetBalanceString].
  AssetBalanceStringProvider call(Asset asset) {
    return AssetBalanceStringProvider(asset);
  }

  @override
  AssetBalanceStringProvider getProviderOverride(
    covariant AssetBalanceStringProvider provider,
  ) {
    return call(provider.asset);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetBalanceStringProvider';
}

/// Asset balance ============
///
/// Copied from [assetBalanceString].
class AssetBalanceStringProvider extends AutoDisposeProvider<String> {
  /// Asset balance ============
  ///
  /// Copied from [assetBalanceString].
  AssetBalanceStringProvider(Asset asset)
    : this._internal(
        (ref) => assetBalanceString(ref as AssetBalanceStringRef, asset),
        from: assetBalanceStringProvider,
        name: r'assetBalanceStringProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetBalanceStringHash,
        dependencies: AssetBalanceStringFamily._dependencies,
        allTransitiveDependencies:
            AssetBalanceStringFamily._allTransitiveDependencies,
        asset: asset,
      );

  AssetBalanceStringProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.asset,
  }) : super.internal();

  final Asset asset;

  @override
  Override overrideWith(
    String Function(AssetBalanceStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetBalanceStringProvider._internal(
        (ref) => create(ref as AssetBalanceStringRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        asset: asset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _AssetBalanceStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceStringProvider && other.asset == asset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, asset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetBalanceStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `asset` of this provider.
  Asset get asset;
}

class _AssetBalanceStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AssetBalanceStringRef {
  _AssetBalanceStringProviderElement(super.provider);

  @override
  Asset get asset => (origin as AssetBalanceStringProvider).asset;
}

String _$assetBalanceDecimalHash() =>
    r'bfa57a470604bab66c4a58d53681bdde0f147a69';

/// See also [assetBalanceDecimal].
@ProviderFor(assetBalanceDecimal)
const assetBalanceDecimalProvider = AssetBalanceDecimalFamily();

/// See also [assetBalanceDecimal].
class AssetBalanceDecimalFamily extends Family<Decimal> {
  /// See also [assetBalanceDecimal].
  const AssetBalanceDecimalFamily();

  /// See also [assetBalanceDecimal].
  AssetBalanceDecimalProvider call(Asset asset) {
    return AssetBalanceDecimalProvider(asset);
  }

  @override
  AssetBalanceDecimalProvider getProviderOverride(
    covariant AssetBalanceDecimalProvider provider,
  ) {
    return call(provider.asset);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetBalanceDecimalProvider';
}

/// See also [assetBalanceDecimal].
class AssetBalanceDecimalProvider extends AutoDisposeProvider<Decimal> {
  /// See also [assetBalanceDecimal].
  AssetBalanceDecimalProvider(Asset asset)
    : this._internal(
        (ref) => assetBalanceDecimal(ref as AssetBalanceDecimalRef, asset),
        from: assetBalanceDecimalProvider,
        name: r'assetBalanceDecimalProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetBalanceDecimalHash,
        dependencies: AssetBalanceDecimalFamily._dependencies,
        allTransitiveDependencies:
            AssetBalanceDecimalFamily._allTransitiveDependencies,
        asset: asset,
      );

  AssetBalanceDecimalProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.asset,
  }) : super.internal();

  final Asset asset;

  @override
  Override overrideWith(
    Decimal Function(AssetBalanceDecimalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetBalanceDecimalProvider._internal(
        (ref) => create(ref as AssetBalanceDecimalRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        asset: asset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AssetBalanceDecimalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceDecimalProvider && other.asset == asset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, asset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetBalanceDecimalRef on AutoDisposeProviderRef<Decimal> {
  /// The parameter `asset` of this provider.
  Asset get asset;
}

class _AssetBalanceDecimalProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with AssetBalanceDecimalRef {
  _AssetBalanceDecimalProviderElement(super.provider);

  @override
  Asset get asset => (origin as AssetBalanceDecimalProvider).asset;
}

String _$assetBalanceDoubleHash() =>
    r'c692732f9d94f63ac2955155c2b153abfafaeb48';

/// See also [assetBalanceDouble].
@ProviderFor(assetBalanceDouble)
const assetBalanceDoubleProvider = AssetBalanceDoubleFamily();

/// See also [assetBalanceDouble].
class AssetBalanceDoubleFamily extends Family<double> {
  /// See also [assetBalanceDouble].
  const AssetBalanceDoubleFamily();

  /// See also [assetBalanceDouble].
  AssetBalanceDoubleProvider call(Asset asset) {
    return AssetBalanceDoubleProvider(asset);
  }

  @override
  AssetBalanceDoubleProvider getProviderOverride(
    covariant AssetBalanceDoubleProvider provider,
  ) {
    return call(provider.asset);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetBalanceDoubleProvider';
}

/// See also [assetBalanceDouble].
class AssetBalanceDoubleProvider extends AutoDisposeProvider<double> {
  /// See also [assetBalanceDouble].
  AssetBalanceDoubleProvider(Asset asset)
    : this._internal(
        (ref) => assetBalanceDouble(ref as AssetBalanceDoubleRef, asset),
        from: assetBalanceDoubleProvider,
        name: r'assetBalanceDoubleProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetBalanceDoubleHash,
        dependencies: AssetBalanceDoubleFamily._dependencies,
        allTransitiveDependencies:
            AssetBalanceDoubleFamily._allTransitiveDependencies,
        asset: asset,
      );

  AssetBalanceDoubleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.asset,
  }) : super.internal();

  final Asset asset;

  @override
  Override overrideWith(
    double Function(AssetBalanceDoubleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetBalanceDoubleProvider._internal(
        (ref) => create(ref as AssetBalanceDoubleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        asset: asset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _AssetBalanceDoubleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetBalanceDoubleProvider && other.asset == asset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, asset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetBalanceDoubleRef on AutoDisposeProviderRef<double> {
  /// The parameter `asset` of this provider.
  Asset get asset;
}

class _AssetBalanceDoubleProviderElement
    extends AutoDisposeProviderElement<double>
    with AssetBalanceDoubleRef {
  _AssetBalanceDoubleProviderElement(super.provider);

  @override
  Asset get asset => (origin as AssetBalanceDoubleProvider).asset;
}

String _$availableBalanceForAssetIdAsStringHash() =>
    r'a4fd4f97c08b789e86ec107bf004dbf38029e358';

/// See also [availableBalanceForAssetIdAsString].
@ProviderFor(availableBalanceForAssetIdAsString)
const availableBalanceForAssetIdAsStringProvider =
    AvailableBalanceForAssetIdAsStringFamily();

/// See also [availableBalanceForAssetIdAsString].
class AvailableBalanceForAssetIdAsStringFamily extends Family<String> {
  /// See also [availableBalanceForAssetIdAsString].
  const AvailableBalanceForAssetIdAsStringFamily();

  /// See also [availableBalanceForAssetIdAsString].
  AvailableBalanceForAssetIdAsStringProvider call(String? assetId) {
    return AvailableBalanceForAssetIdAsStringProvider(assetId);
  }

  @override
  AvailableBalanceForAssetIdAsStringProvider getProviderOverride(
    covariant AvailableBalanceForAssetIdAsStringProvider provider,
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
  String? get name => r'availableBalanceForAssetIdAsStringProvider';
}

/// See also [availableBalanceForAssetIdAsString].
class AvailableBalanceForAssetIdAsStringProvider
    extends AutoDisposeProvider<String> {
  /// See also [availableBalanceForAssetIdAsString].
  AvailableBalanceForAssetIdAsStringProvider(String? assetId)
    : this._internal(
        (ref) => availableBalanceForAssetIdAsString(
          ref as AvailableBalanceForAssetIdAsStringRef,
          assetId,
        ),
        from: availableBalanceForAssetIdAsStringProvider,
        name: r'availableBalanceForAssetIdAsStringProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$availableBalanceForAssetIdAsStringHash,
        dependencies: AvailableBalanceForAssetIdAsStringFamily._dependencies,
        allTransitiveDependencies:
            AvailableBalanceForAssetIdAsStringFamily._allTransitiveDependencies,
        assetId: assetId,
      );

  AvailableBalanceForAssetIdAsStringProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
  }) : super.internal();

  final String? assetId;

  @override
  Override overrideWith(
    String Function(AvailableBalanceForAssetIdAsStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableBalanceForAssetIdAsStringProvider._internal(
        (ref) => create(ref as AvailableBalanceForAssetIdAsStringRef),
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
  AutoDisposeProviderElement<String> createElement() {
    return _AvailableBalanceForAssetIdAsStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableBalanceForAssetIdAsStringProvider &&
        other.assetId == assetId;
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
mixin AvailableBalanceForAssetIdAsStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `assetId` of this provider.
  String? get assetId;
}

class _AvailableBalanceForAssetIdAsStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AvailableBalanceForAssetIdAsStringRef {
  _AvailableBalanceForAssetIdAsStringProviderElement(super.provider);

  @override
  String? get assetId =>
      (origin as AvailableBalanceForAssetIdAsStringProvider).assetId;
}

String _$defaultCurrencyTickerHash() =>
    r'adf1cae370426e5c364eaa0dfd834166041ac867';

/// See also [defaultCurrencyTicker].
@ProviderFor(defaultCurrencyTicker)
final defaultCurrencyTickerProvider = AutoDisposeProvider<String>.internal(
  defaultCurrencyTicker,
  name: r'defaultCurrencyTickerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$defaultCurrencyTickerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DefaultCurrencyTickerRef = AutoDisposeProviderRef<String>;
String _$balancesNotifierHash() => r'ed70ac2f9f3052422ba6a16cdd70b1e4c4cbd373';

/// See also [BalancesNotifier].
@ProviderFor(BalancesNotifier)
final balancesNotifierProvider =
    NotifierProvider<BalancesNotifier, Map<AccountAsset, int>>.internal(
      BalancesNotifier.new,
      name: r'balancesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$balancesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BalancesNotifier = Notifier<Map<AccountAsset, int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
