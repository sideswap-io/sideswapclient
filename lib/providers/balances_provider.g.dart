// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balances_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$outputsBalanceForAssetHash() =>
    r'40b16de42f2fd39a73d7b7b863b235e383da9133';

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
  OutputsBalanceForAssetProvider call(
    AccountAsset accountAsset,
  ) {
    return OutputsBalanceForAssetProvider(
      accountAsset,
    );
  }

  @override
  OutputsBalanceForAssetProvider getProviderOverride(
    covariant OutputsBalanceForAssetProvider provider,
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
  String? get name => r'outputsBalanceForAssetProvider';
}

/// See also [outputsBalanceForAsset].
class OutputsBalanceForAssetProvider extends AutoDisposeProvider<int> {
  /// See also [outputsBalanceForAsset].
  OutputsBalanceForAssetProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => outputsBalanceForAsset(
            ref as OutputsBalanceForAssetRef,
            accountAsset,
          ),
          from: outputsBalanceForAssetProvider,
          name: r'outputsBalanceForAssetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$outputsBalanceForAssetHash,
          dependencies: OutputsBalanceForAssetFamily._dependencies,
          allTransitiveDependencies:
              OutputsBalanceForAssetFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  OutputsBalanceForAssetProvider._internal(
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
        accountAsset: accountAsset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _OutputsBalanceForAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OutputsBalanceForAssetProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OutputsBalanceForAssetRef on AutoDisposeProviderRef<int> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _OutputsBalanceForAssetProviderElement
    extends AutoDisposeProviderElement<int> with OutputsBalanceForAssetRef {
  _OutputsBalanceForAssetProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as OutputsBalanceForAssetProvider).accountAsset;
}

String _$selectedInputsBalanceForAssetHash() =>
    r'124d2d4e0926b708a13da7ab594b6f2f1c8460e6';

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
  SelectedInputsBalanceForAssetProvider call(
    AccountAsset accountAsset,
  ) {
    return SelectedInputsBalanceForAssetProvider(
      accountAsset,
    );
  }

  @override
  SelectedInputsBalanceForAssetProvider getProviderOverride(
    covariant SelectedInputsBalanceForAssetProvider provider,
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
  String? get name => r'selectedInputsBalanceForAssetProvider';
}

/// Inputs related providers
///
/// Copied from [selectedInputsBalanceForAsset].
class SelectedInputsBalanceForAssetProvider extends AutoDisposeProvider<int> {
  /// Inputs related providers
  ///
  /// Copied from [selectedInputsBalanceForAsset].
  SelectedInputsBalanceForAssetProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => selectedInputsBalanceForAsset(
            ref as SelectedInputsBalanceForAssetRef,
            accountAsset,
          ),
          from: selectedInputsBalanceForAssetProvider,
          name: r'selectedInputsBalanceForAssetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedInputsBalanceForAssetHash,
          dependencies: SelectedInputsBalanceForAssetFamily._dependencies,
          allTransitiveDependencies:
              SelectedInputsBalanceForAssetFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  SelectedInputsBalanceForAssetProvider._internal(
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
        accountAsset: accountAsset,
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
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedInputsBalanceForAssetRef on AutoDisposeProviderRef<int> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _SelectedInputsBalanceForAssetProviderElement
    extends AutoDisposeProviderElement<int>
    with SelectedInputsBalanceForAssetRef {
  _SelectedInputsBalanceForAssetProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as SelectedInputsBalanceForAssetProvider).accountAsset;
}

String _$maxAvailableBalanceWithInputsForAccountAssetHash() =>
    r'c8e2d11d0d09deb227ed23e80d0466e57f08f5ed';

/// See also [maxAvailableBalanceWithInputsForAccountAsset].
@ProviderFor(maxAvailableBalanceWithInputsForAccountAsset)
const maxAvailableBalanceWithInputsForAccountAssetProvider =
    MaxAvailableBalanceWithInputsForAccountAssetFamily();

/// See also [maxAvailableBalanceWithInputsForAccountAsset].
class MaxAvailableBalanceWithInputsForAccountAssetFamily extends Family<int> {
  /// See also [maxAvailableBalanceWithInputsForAccountAsset].
  const MaxAvailableBalanceWithInputsForAccountAssetFamily();

  /// See also [maxAvailableBalanceWithInputsForAccountAsset].
  MaxAvailableBalanceWithInputsForAccountAssetProvider call(
    AccountAsset accountAsset,
  ) {
    return MaxAvailableBalanceWithInputsForAccountAssetProvider(
      accountAsset,
    );
  }

  @override
  MaxAvailableBalanceWithInputsForAccountAssetProvider getProviderOverride(
    covariant MaxAvailableBalanceWithInputsForAccountAssetProvider provider,
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
  String? get name => r'maxAvailableBalanceWithInputsForAccountAssetProvider';
}

/// See also [maxAvailableBalanceWithInputsForAccountAsset].
class MaxAvailableBalanceWithInputsForAccountAssetProvider
    extends AutoDisposeProvider<int> {
  /// See also [maxAvailableBalanceWithInputsForAccountAsset].
  MaxAvailableBalanceWithInputsForAccountAssetProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => maxAvailableBalanceWithInputsForAccountAsset(
            ref as MaxAvailableBalanceWithInputsForAccountAssetRef,
            accountAsset,
          ),
          from: maxAvailableBalanceWithInputsForAccountAssetProvider,
          name: r'maxAvailableBalanceWithInputsForAccountAssetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$maxAvailableBalanceWithInputsForAccountAssetHash,
          dependencies:
              MaxAvailableBalanceWithInputsForAccountAssetFamily._dependencies,
          allTransitiveDependencies:
              MaxAvailableBalanceWithInputsForAccountAssetFamily
                  ._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  MaxAvailableBalanceWithInputsForAccountAssetProvider._internal(
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
    int Function(MaxAvailableBalanceWithInputsForAccountAssetRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MaxAvailableBalanceWithInputsForAccountAssetProvider._internal(
        (ref) => create(ref as MaxAvailableBalanceWithInputsForAccountAssetRef),
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
  AutoDisposeProviderElement<int> createElement() {
    return _MaxAvailableBalanceWithInputsForAccountAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MaxAvailableBalanceWithInputsForAccountAssetProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MaxAvailableBalanceWithInputsForAccountAssetRef
    on AutoDisposeProviderRef<int> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _MaxAvailableBalanceWithInputsForAccountAssetProviderElement
    extends AutoDisposeProviderElement<int>
    with MaxAvailableBalanceWithInputsForAccountAssetRef {
  _MaxAvailableBalanceWithInputsForAccountAssetProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as MaxAvailableBalanceWithInputsForAccountAssetProvider)
          .accountAsset;
}

String _$balanceWithInputsForAccountAssetHash() =>
    r'43299d0c2439efb043d7582d65b60b2a60ede2c9';

/// See also [balanceWithInputsForAccountAsset].
@ProviderFor(balanceWithInputsForAccountAsset)
const balanceWithInputsForAccountAssetProvider =
    BalanceWithInputsForAccountAssetFamily();

/// See also [balanceWithInputsForAccountAsset].
class BalanceWithInputsForAccountAssetFamily extends Family<int> {
  /// See also [balanceWithInputsForAccountAsset].
  const BalanceWithInputsForAccountAssetFamily();

  /// See also [balanceWithInputsForAccountAsset].
  BalanceWithInputsForAccountAssetProvider call(
    AccountAsset accountAsset,
  ) {
    return BalanceWithInputsForAccountAssetProvider(
      accountAsset,
    );
  }

  @override
  BalanceWithInputsForAccountAssetProvider getProviderOverride(
    covariant BalanceWithInputsForAccountAssetProvider provider,
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
  String? get name => r'balanceWithInputsForAccountAssetProvider';
}

/// See also [balanceWithInputsForAccountAsset].
class BalanceWithInputsForAccountAssetProvider
    extends AutoDisposeProvider<int> {
  /// See also [balanceWithInputsForAccountAsset].
  BalanceWithInputsForAccountAssetProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => balanceWithInputsForAccountAsset(
            ref as BalanceWithInputsForAccountAssetRef,
            accountAsset,
          ),
          from: balanceWithInputsForAccountAssetProvider,
          name: r'balanceWithInputsForAccountAssetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$balanceWithInputsForAccountAssetHash,
          dependencies: BalanceWithInputsForAccountAssetFamily._dependencies,
          allTransitiveDependencies:
              BalanceWithInputsForAccountAssetFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  BalanceWithInputsForAccountAssetProvider._internal(
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
    int Function(BalanceWithInputsForAccountAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BalanceWithInputsForAccountAssetProvider._internal(
        (ref) => create(ref as BalanceWithInputsForAccountAssetRef),
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
  AutoDisposeProviderElement<int> createElement() {
    return _BalanceWithInputsForAccountAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BalanceWithInputsForAccountAssetProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BalanceWithInputsForAccountAssetRef on AutoDisposeProviderRef<int> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _BalanceWithInputsForAccountAssetProviderElement
    extends AutoDisposeProviderElement<int>
    with BalanceWithInputsForAccountAssetRef {
  _BalanceWithInputsForAccountAssetProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as BalanceWithInputsForAccountAssetProvider).accountAsset;
}

String _$balanceStringWithInputsForAccountAssetHash() =>
    r'aac10c2874035a7b334d9dd7779bd25f0c2bda2a';

/// See also [balanceStringWithInputsForAccountAsset].
@ProviderFor(balanceStringWithInputsForAccountAsset)
const balanceStringWithInputsForAccountAssetProvider =
    BalanceStringWithInputsForAccountAssetFamily();

/// See also [balanceStringWithInputsForAccountAsset].
class BalanceStringWithInputsForAccountAssetFamily extends Family<String> {
  /// See also [balanceStringWithInputsForAccountAsset].
  const BalanceStringWithInputsForAccountAssetFamily();

  /// See also [balanceStringWithInputsForAccountAsset].
  BalanceStringWithInputsForAccountAssetProvider call(
    AccountAsset accountAsset,
  ) {
    return BalanceStringWithInputsForAccountAssetProvider(
      accountAsset,
    );
  }

  @override
  BalanceStringWithInputsForAccountAssetProvider getProviderOverride(
    covariant BalanceStringWithInputsForAccountAssetProvider provider,
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
  String? get name => r'balanceStringWithInputsForAccountAssetProvider';
}

/// See also [balanceStringWithInputsForAccountAsset].
class BalanceStringWithInputsForAccountAssetProvider
    extends AutoDisposeProvider<String> {
  /// See also [balanceStringWithInputsForAccountAsset].
  BalanceStringWithInputsForAccountAssetProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => balanceStringWithInputsForAccountAsset(
            ref as BalanceStringWithInputsForAccountAssetRef,
            accountAsset,
          ),
          from: balanceStringWithInputsForAccountAssetProvider,
          name: r'balanceStringWithInputsForAccountAssetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$balanceStringWithInputsForAccountAssetHash,
          dependencies:
              BalanceStringWithInputsForAccountAssetFamily._dependencies,
          allTransitiveDependencies:
              BalanceStringWithInputsForAccountAssetFamily
                  ._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  BalanceStringWithInputsForAccountAssetProvider._internal(
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
    String Function(BalanceStringWithInputsForAccountAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BalanceStringWithInputsForAccountAssetProvider._internal(
        (ref) => create(ref as BalanceStringWithInputsForAccountAssetRef),
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
  AutoDisposeProviderElement<String> createElement() {
    return _BalanceStringWithInputsForAccountAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BalanceStringWithInputsForAccountAssetProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BalanceStringWithInputsForAccountAssetRef
    on AutoDisposeProviderRef<String> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _BalanceStringWithInputsForAccountAssetProviderElement
    extends AutoDisposeProviderElement<String>
    with BalanceStringWithInputsForAccountAssetRef {
  _BalanceStringWithInputsForAccountAssetProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as BalanceStringWithInputsForAccountAssetProvider).accountAsset;
}

String _$balanceStringWithInputsHash() =>
    r'63c26b7d47b154781f7edff85652cb44cd8e8a85';

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

typedef BalanceStringWithInputsRef = AutoDisposeProviderRef<String>;
String _$accountAssetBalanceWithInputsInDefaultCurrencyHash() =>
    r'97434ae4da31034664e9113206ab75385aa71525';

/// See also [accountAssetBalanceWithInputsInDefaultCurrency].
@ProviderFor(accountAssetBalanceWithInputsInDefaultCurrency)
const accountAssetBalanceWithInputsInDefaultCurrencyProvider =
    AccountAssetBalanceWithInputsInDefaultCurrencyFamily();

/// See also [accountAssetBalanceWithInputsInDefaultCurrency].
class AccountAssetBalanceWithInputsInDefaultCurrencyFamily
    extends Family<Decimal> {
  /// See also [accountAssetBalanceWithInputsInDefaultCurrency].
  const AccountAssetBalanceWithInputsInDefaultCurrencyFamily();

  /// See also [accountAssetBalanceWithInputsInDefaultCurrency].
  AccountAssetBalanceWithInputsInDefaultCurrencyProvider call(
    AccountAsset accountAsset,
  ) {
    return AccountAssetBalanceWithInputsInDefaultCurrencyProvider(
      accountAsset,
    );
  }

  @override
  AccountAssetBalanceWithInputsInDefaultCurrencyProvider getProviderOverride(
    covariant AccountAssetBalanceWithInputsInDefaultCurrencyProvider provider,
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
  String? get name => r'accountAssetBalanceWithInputsInDefaultCurrencyProvider';
}

/// See also [accountAssetBalanceWithInputsInDefaultCurrency].
class AccountAssetBalanceWithInputsInDefaultCurrencyProvider
    extends AutoDisposeProvider<Decimal> {
  /// See also [accountAssetBalanceWithInputsInDefaultCurrency].
  AccountAssetBalanceWithInputsInDefaultCurrencyProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => accountAssetBalanceWithInputsInDefaultCurrency(
            ref as AccountAssetBalanceWithInputsInDefaultCurrencyRef,
            accountAsset,
          ),
          from: accountAssetBalanceWithInputsInDefaultCurrencyProvider,
          name: r'accountAssetBalanceWithInputsInDefaultCurrencyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetBalanceWithInputsInDefaultCurrencyHash,
          dependencies: AccountAssetBalanceWithInputsInDefaultCurrencyFamily
              ._dependencies,
          allTransitiveDependencies:
              AccountAssetBalanceWithInputsInDefaultCurrencyFamily
                  ._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  AccountAssetBalanceWithInputsInDefaultCurrencyProvider._internal(
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
    Decimal Function(AccountAssetBalanceWithInputsInDefaultCurrencyRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override:
          AccountAssetBalanceWithInputsInDefaultCurrencyProvider._internal(
        (ref) =>
            create(ref as AccountAssetBalanceWithInputsInDefaultCurrencyRef),
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
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AccountAssetBalanceWithInputsInDefaultCurrencyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetBalanceWithInputsInDefaultCurrencyProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetBalanceWithInputsInDefaultCurrencyRef
    on AutoDisposeProviderRef<Decimal> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountAssetBalanceWithInputsInDefaultCurrencyProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with AccountAssetBalanceWithInputsInDefaultCurrencyRef {
  _AccountAssetBalanceWithInputsInDefaultCurrencyProviderElement(
      super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as AccountAssetBalanceWithInputsInDefaultCurrencyProvider)
          .accountAsset;
}

String _$accountAssetBalanceWithInputsInDefaultCurrencyStringHash() =>
    r'269ef300ba2dbfbb1cfa51e17286554ddac89b80';

/// See also [accountAssetBalanceWithInputsInDefaultCurrencyString].
@ProviderFor(accountAssetBalanceWithInputsInDefaultCurrencyString)
const accountAssetBalanceWithInputsInDefaultCurrencyStringProvider =
    AccountAssetBalanceWithInputsInDefaultCurrencyStringFamily();

/// See also [accountAssetBalanceWithInputsInDefaultCurrencyString].
class AccountAssetBalanceWithInputsInDefaultCurrencyStringFamily
    extends Family<String> {
  /// See also [accountAssetBalanceWithInputsInDefaultCurrencyString].
  const AccountAssetBalanceWithInputsInDefaultCurrencyStringFamily();

  /// See also [accountAssetBalanceWithInputsInDefaultCurrencyString].
  AccountAssetBalanceWithInputsInDefaultCurrencyStringProvider call(
    AccountAsset accountAsset,
  ) {
    return AccountAssetBalanceWithInputsInDefaultCurrencyStringProvider(
      accountAsset,
    );
  }

  @override
  AccountAssetBalanceWithInputsInDefaultCurrencyStringProvider
      getProviderOverride(
    covariant AccountAssetBalanceWithInputsInDefaultCurrencyStringProvider
        provider,
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
  String? get name =>
      r'accountAssetBalanceWithInputsInDefaultCurrencyStringProvider';
}

/// See also [accountAssetBalanceWithInputsInDefaultCurrencyString].
class AccountAssetBalanceWithInputsInDefaultCurrencyStringProvider
    extends AutoDisposeProvider<String> {
  /// See also [accountAssetBalanceWithInputsInDefaultCurrencyString].
  AccountAssetBalanceWithInputsInDefaultCurrencyStringProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => accountAssetBalanceWithInputsInDefaultCurrencyString(
            ref as AccountAssetBalanceWithInputsInDefaultCurrencyStringRef,
            accountAsset,
          ),
          from: accountAssetBalanceWithInputsInDefaultCurrencyStringProvider,
          name: r'accountAssetBalanceWithInputsInDefaultCurrencyStringProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetBalanceWithInputsInDefaultCurrencyStringHash,
          dependencies:
              AccountAssetBalanceWithInputsInDefaultCurrencyStringFamily
                  ._dependencies,
          allTransitiveDependencies:
              AccountAssetBalanceWithInputsInDefaultCurrencyStringFamily
                  ._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  AccountAssetBalanceWithInputsInDefaultCurrencyStringProvider._internal(
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
    String Function(
            AccountAssetBalanceWithInputsInDefaultCurrencyStringRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetBalanceWithInputsInDefaultCurrencyStringProvider
          ._internal(
        (ref) => create(
            ref as AccountAssetBalanceWithInputsInDefaultCurrencyStringRef),
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
  AutoDisposeProviderElement<String> createElement() {
    return _AccountAssetBalanceWithInputsInDefaultCurrencyStringProviderElement(
        this);
  }

  @override
  bool operator ==(Object other) {
    return other
            is AccountAssetBalanceWithInputsInDefaultCurrencyStringProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetBalanceWithInputsInDefaultCurrencyStringRef
    on AutoDisposeProviderRef<String> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountAssetBalanceWithInputsInDefaultCurrencyStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AccountAssetBalanceWithInputsInDefaultCurrencyStringRef {
  _AccountAssetBalanceWithInputsInDefaultCurrencyStringProviderElement(
      super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as AccountAssetBalanceWithInputsInDefaultCurrencyStringProvider)
          .accountAsset;
}

String _$maxAvailableBalanceForAccountAssetHash() =>
    r'6ca57c97330240935afd254dff7f449595edeb62';

/// Balance providers without inputs
///
/// Copied from [maxAvailableBalanceForAccountAsset].
@ProviderFor(maxAvailableBalanceForAccountAsset)
const maxAvailableBalanceForAccountAssetProvider =
    MaxAvailableBalanceForAccountAssetFamily();

/// Balance providers without inputs
///
/// Copied from [maxAvailableBalanceForAccountAsset].
class MaxAvailableBalanceForAccountAssetFamily extends Family<int> {
  /// Balance providers without inputs
  ///
  /// Copied from [maxAvailableBalanceForAccountAsset].
  const MaxAvailableBalanceForAccountAssetFamily();

  /// Balance providers without inputs
  ///
  /// Copied from [maxAvailableBalanceForAccountAsset].
  MaxAvailableBalanceForAccountAssetProvider call(
    AccountAsset accountAsset,
  ) {
    return MaxAvailableBalanceForAccountAssetProvider(
      accountAsset,
    );
  }

  @override
  MaxAvailableBalanceForAccountAssetProvider getProviderOverride(
    covariant MaxAvailableBalanceForAccountAssetProvider provider,
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
  String? get name => r'maxAvailableBalanceForAccountAssetProvider';
}

/// Balance providers without inputs
///
/// Copied from [maxAvailableBalanceForAccountAsset].
class MaxAvailableBalanceForAccountAssetProvider
    extends AutoDisposeProvider<int> {
  /// Balance providers without inputs
  ///
  /// Copied from [maxAvailableBalanceForAccountAsset].
  MaxAvailableBalanceForAccountAssetProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => maxAvailableBalanceForAccountAsset(
            ref as MaxAvailableBalanceForAccountAssetRef,
            accountAsset,
          ),
          from: maxAvailableBalanceForAccountAssetProvider,
          name: r'maxAvailableBalanceForAccountAssetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$maxAvailableBalanceForAccountAssetHash,
          dependencies: MaxAvailableBalanceForAccountAssetFamily._dependencies,
          allTransitiveDependencies: MaxAvailableBalanceForAccountAssetFamily
              ._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  MaxAvailableBalanceForAccountAssetProvider._internal(
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
    int Function(MaxAvailableBalanceForAccountAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MaxAvailableBalanceForAccountAssetProvider._internal(
        (ref) => create(ref as MaxAvailableBalanceForAccountAssetRef),
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
  AutoDisposeProviderElement<int> createElement() {
    return _MaxAvailableBalanceForAccountAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MaxAvailableBalanceForAccountAssetProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MaxAvailableBalanceForAccountAssetRef on AutoDisposeProviderRef<int> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _MaxAvailableBalanceForAccountAssetProviderElement
    extends AutoDisposeProviderElement<int>
    with MaxAvailableBalanceForAccountAssetRef {
  _MaxAvailableBalanceForAccountAssetProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as MaxAvailableBalanceForAccountAssetProvider).accountAsset;
}

String _$amountUsdInDefaultCurrencyHash() =>
    r'3b48fd8f54871a087cf6a4f182d444ee41a4e0b8';

/// See also [amountUsdInDefaultCurrency].
@ProviderFor(amountUsdInDefaultCurrency)
const amountUsdInDefaultCurrencyProvider = AmountUsdInDefaultCurrencyFamily();

/// See also [amountUsdInDefaultCurrency].
class AmountUsdInDefaultCurrencyFamily extends Family<Decimal> {
  /// See also [amountUsdInDefaultCurrency].
  const AmountUsdInDefaultCurrencyFamily();

  /// See also [amountUsdInDefaultCurrency].
  AmountUsdInDefaultCurrencyProvider call(
    String? assetId,
    num amount,
  ) {
    return AmountUsdInDefaultCurrencyProvider(
      assetId,
      amount,
    );
  }

  @override
  AmountUsdInDefaultCurrencyProvider getProviderOverride(
    covariant AmountUsdInDefaultCurrencyProvider provider,
  ) {
    return call(
      provider.assetId,
      provider.amount,
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
  String? get name => r'amountUsdInDefaultCurrencyProvider';
}

/// See also [amountUsdInDefaultCurrency].
class AmountUsdInDefaultCurrencyProvider extends AutoDisposeProvider<Decimal> {
  /// See also [amountUsdInDefaultCurrency].
  AmountUsdInDefaultCurrencyProvider(
    String? assetId,
    num amount,
  ) : this._internal(
          (ref) => amountUsdInDefaultCurrency(
            ref as AmountUsdInDefaultCurrencyRef,
            assetId,
            amount,
          ),
          from: amountUsdInDefaultCurrencyProvider,
          name: r'amountUsdInDefaultCurrencyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
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

String _$amountUsdHash() => r'80d67666d0b0efbf54cdd6ccbd4af6a8c454fe0d';

/// See also [amountUsd].
@ProviderFor(amountUsd)
const amountUsdProvider = AmountUsdFamily();

/// See also [amountUsd].
class AmountUsdFamily extends Family<Decimal> {
  /// See also [amountUsd].
  const AmountUsdFamily();

  /// See also [amountUsd].
  AmountUsdProvider call(
    String? assetId,
    num amount,
  ) {
    return AmountUsdProvider(
      assetId,
      amount,
    );
  }

  @override
  AmountUsdProvider getProviderOverride(
    covariant AmountUsdProvider provider,
  ) {
    return call(
      provider.assetId,
      provider.amount,
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
  String? get name => r'amountUsdProvider';
}

/// See also [amountUsd].
class AmountUsdProvider extends AutoDisposeProvider<Decimal> {
  /// See also [amountUsd].
  AmountUsdProvider(
    String? assetId,
    num amount,
  ) : this._internal(
          (ref) => amountUsd(
            ref as AmountUsdRef,
            assetId,
            amount,
          ),
          from: amountUsdProvider,
          name: r'amountUsdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
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
  Override overrideWith(
    Decimal Function(AmountUsdRef provider) create,
  ) {
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

String _$accountAssetsTotalLbtcBalanceHash() =>
    r'be33e21e8e7bf55c64d9f786043c64b9d36aea37';

/// Total LBTC ============
///
/// Copied from [accountAssetsTotalLbtcBalance].
@ProviderFor(accountAssetsTotalLbtcBalance)
const accountAssetsTotalLbtcBalanceProvider =
    AccountAssetsTotalLbtcBalanceFamily();

/// Total LBTC ============
///
/// Copied from [accountAssetsTotalLbtcBalance].
class AccountAssetsTotalLbtcBalanceFamily extends Family<String> {
  /// Total LBTC ============
  ///
  /// Copied from [accountAssetsTotalLbtcBalance].
  const AccountAssetsTotalLbtcBalanceFamily();

  /// Total LBTC ============
  ///
  /// Copied from [accountAssetsTotalLbtcBalance].
  AccountAssetsTotalLbtcBalanceProvider call(
    List<AccountAsset> accountAssets,
  ) {
    return AccountAssetsTotalLbtcBalanceProvider(
      accountAssets,
    );
  }

  @override
  AccountAssetsTotalLbtcBalanceProvider getProviderOverride(
    covariant AccountAssetsTotalLbtcBalanceProvider provider,
  ) {
    return call(
      provider.accountAssets,
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
  String? get name => r'accountAssetsTotalLbtcBalanceProvider';
}

/// Total LBTC ============
///
/// Copied from [accountAssetsTotalLbtcBalance].
class AccountAssetsTotalLbtcBalanceProvider
    extends AutoDisposeProvider<String> {
  /// Total LBTC ============
  ///
  /// Copied from [accountAssetsTotalLbtcBalance].
  AccountAssetsTotalLbtcBalanceProvider(
    List<AccountAsset> accountAssets,
  ) : this._internal(
          (ref) => accountAssetsTotalLbtcBalance(
            ref as AccountAssetsTotalLbtcBalanceRef,
            accountAssets,
          ),
          from: accountAssetsTotalLbtcBalanceProvider,
          name: r'accountAssetsTotalLbtcBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetsTotalLbtcBalanceHash,
          dependencies: AccountAssetsTotalLbtcBalanceFamily._dependencies,
          allTransitiveDependencies:
              AccountAssetsTotalLbtcBalanceFamily._allTransitiveDependencies,
          accountAssets: accountAssets,
        );

  AccountAssetsTotalLbtcBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountAssets,
  }) : super.internal();

  final List<AccountAsset> accountAssets;

  @override
  Override overrideWith(
    String Function(AccountAssetsTotalLbtcBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetsTotalLbtcBalanceProvider._internal(
        (ref) => create(ref as AccountAssetsTotalLbtcBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountAssets: accountAssets,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _AccountAssetsTotalLbtcBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetsTotalLbtcBalanceProvider &&
        other.accountAssets == accountAssets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAssets.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetsTotalLbtcBalanceRef on AutoDisposeProviderRef<String> {
  /// The parameter `accountAssets` of this provider.
  List<AccountAsset> get accountAssets;
}

class _AccountAssetsTotalLbtcBalanceProviderElement
    extends AutoDisposeProviderElement<String>
    with AccountAssetsTotalLbtcBalanceRef {
  _AccountAssetsTotalLbtcBalanceProviderElement(super.provider);

  @override
  List<AccountAsset> get accountAssets =>
      (origin as AccountAssetsTotalLbtcBalanceProvider).accountAssets;
}

String _$accountAssetsTotalUsdBalanceStringHash() =>
    r'c19503f3b3e40f0bae1b3386fa0b52d6d376722f';

/// USD currency converters ============
///
/// Copied from [_accountAssetsTotalUsdBalanceString].
@ProviderFor(_accountAssetsTotalUsdBalanceString)
const _accountAssetsTotalUsdBalanceStringProvider =
    _AccountAssetsTotalUsdBalanceStringFamily();

/// USD currency converters ============
///
/// Copied from [_accountAssetsTotalUsdBalanceString].
class _AccountAssetsTotalUsdBalanceStringFamily extends Family<String> {
  /// USD currency converters ============
  ///
  /// Copied from [_accountAssetsTotalUsdBalanceString].
  const _AccountAssetsTotalUsdBalanceStringFamily();

  /// USD currency converters ============
  ///
  /// Copied from [_accountAssetsTotalUsdBalanceString].
  _AccountAssetsTotalUsdBalanceStringProvider call(
    List<AccountAsset> accountAssets,
  ) {
    return _AccountAssetsTotalUsdBalanceStringProvider(
      accountAssets,
    );
  }

  @override
  _AccountAssetsTotalUsdBalanceStringProvider getProviderOverride(
    covariant _AccountAssetsTotalUsdBalanceStringProvider provider,
  ) {
    return call(
      provider.accountAssets,
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
  String? get name => r'_accountAssetsTotalUsdBalanceStringProvider';
}

/// USD currency converters ============
///
/// Copied from [_accountAssetsTotalUsdBalanceString].
class _AccountAssetsTotalUsdBalanceStringProvider
    extends AutoDisposeProvider<String> {
  /// USD currency converters ============
  ///
  /// Copied from [_accountAssetsTotalUsdBalanceString].
  _AccountAssetsTotalUsdBalanceStringProvider(
    List<AccountAsset> accountAssets,
  ) : this._internal(
          (ref) => _accountAssetsTotalUsdBalanceString(
            ref as _AccountAssetsTotalUsdBalanceStringRef,
            accountAssets,
          ),
          from: _accountAssetsTotalUsdBalanceStringProvider,
          name: r'_accountAssetsTotalUsdBalanceStringProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetsTotalUsdBalanceStringHash,
          dependencies: _AccountAssetsTotalUsdBalanceStringFamily._dependencies,
          allTransitiveDependencies: _AccountAssetsTotalUsdBalanceStringFamily
              ._allTransitiveDependencies,
          accountAssets: accountAssets,
        );

  _AccountAssetsTotalUsdBalanceStringProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountAssets,
  }) : super.internal();

  final List<AccountAsset> accountAssets;

  @override
  Override overrideWith(
    String Function(_AccountAssetsTotalUsdBalanceStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _AccountAssetsTotalUsdBalanceStringProvider._internal(
        (ref) => create(ref as _AccountAssetsTotalUsdBalanceStringRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountAssets: accountAssets,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _AccountAssetsTotalUsdBalanceStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _AccountAssetsTotalUsdBalanceStringProvider &&
        other.accountAssets == accountAssets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAssets.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _AccountAssetsTotalUsdBalanceStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `accountAssets` of this provider.
  List<AccountAsset> get accountAssets;
}

class _AccountAssetsTotalUsdBalanceStringProviderElement
    extends AutoDisposeProviderElement<String>
    with _AccountAssetsTotalUsdBalanceStringRef {
  _AccountAssetsTotalUsdBalanceStringProviderElement(super.provider);

  @override
  List<AccountAsset> get accountAssets =>
      (origin as _AccountAssetsTotalUsdBalanceStringProvider).accountAssets;
}

String _$accountAssetsTotalUsdBalanceHash() =>
    r'f0bcbe8eb59ef68b7f11a50c116aade5a7acb1d0';

/// See also [_accountAssetsTotalUsdBalance].
@ProviderFor(_accountAssetsTotalUsdBalance)
const _accountAssetsTotalUsdBalanceProvider =
    _AccountAssetsTotalUsdBalanceFamily();

/// See also [_accountAssetsTotalUsdBalance].
class _AccountAssetsTotalUsdBalanceFamily extends Family<Decimal> {
  /// See also [_accountAssetsTotalUsdBalance].
  const _AccountAssetsTotalUsdBalanceFamily();

  /// See also [_accountAssetsTotalUsdBalance].
  _AccountAssetsTotalUsdBalanceProvider call(
    List<AccountAsset> accountAssets,
  ) {
    return _AccountAssetsTotalUsdBalanceProvider(
      accountAssets,
    );
  }

  @override
  _AccountAssetsTotalUsdBalanceProvider getProviderOverride(
    covariant _AccountAssetsTotalUsdBalanceProvider provider,
  ) {
    return call(
      provider.accountAssets,
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
  String? get name => r'_accountAssetsTotalUsdBalanceProvider';
}

/// See also [_accountAssetsTotalUsdBalance].
class _AccountAssetsTotalUsdBalanceProvider
    extends AutoDisposeProvider<Decimal> {
  /// See also [_accountAssetsTotalUsdBalance].
  _AccountAssetsTotalUsdBalanceProvider(
    List<AccountAsset> accountAssets,
  ) : this._internal(
          (ref) => _accountAssetsTotalUsdBalance(
            ref as _AccountAssetsTotalUsdBalanceRef,
            accountAssets,
          ),
          from: _accountAssetsTotalUsdBalanceProvider,
          name: r'_accountAssetsTotalUsdBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetsTotalUsdBalanceHash,
          dependencies: _AccountAssetsTotalUsdBalanceFamily._dependencies,
          allTransitiveDependencies:
              _AccountAssetsTotalUsdBalanceFamily._allTransitiveDependencies,
          accountAssets: accountAssets,
        );

  _AccountAssetsTotalUsdBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountAssets,
  }) : super.internal();

  final List<AccountAsset> accountAssets;

  @override
  Override overrideWith(
    Decimal Function(_AccountAssetsTotalUsdBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _AccountAssetsTotalUsdBalanceProvider._internal(
        (ref) => create(ref as _AccountAssetsTotalUsdBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountAssets: accountAssets,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AccountAssetsTotalUsdBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _AccountAssetsTotalUsdBalanceProvider &&
        other.accountAssets == accountAssets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAssets.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _AccountAssetsTotalUsdBalanceRef on AutoDisposeProviderRef<Decimal> {
  /// The parameter `accountAssets` of this provider.
  List<AccountAsset> get accountAssets;
}

class _AccountAssetsTotalUsdBalanceProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with _AccountAssetsTotalUsdBalanceRef {
  _AccountAssetsTotalUsdBalanceProviderElement(super.provider);

  @override
  List<AccountAsset> get accountAssets =>
      (origin as _AccountAssetsTotalUsdBalanceProvider).accountAssets;
}

String _$accountAssetBalanceInUsdHash() =>
    r'79573e75e8f3222df1dece17978c2b001480eb1b';

/// See also [_accountAssetBalanceInUsd].
@ProviderFor(_accountAssetBalanceInUsd)
const _accountAssetBalanceInUsdProvider = _AccountAssetBalanceInUsdFamily();

/// See also [_accountAssetBalanceInUsd].
class _AccountAssetBalanceInUsdFamily extends Family<Decimal> {
  /// See also [_accountAssetBalanceInUsd].
  const _AccountAssetBalanceInUsdFamily();

  /// See also [_accountAssetBalanceInUsd].
  _AccountAssetBalanceInUsdProvider call(
    AccountAsset accountAsset,
  ) {
    return _AccountAssetBalanceInUsdProvider(
      accountAsset,
    );
  }

  @override
  _AccountAssetBalanceInUsdProvider getProviderOverride(
    covariant _AccountAssetBalanceInUsdProvider provider,
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
  String? get name => r'_accountAssetBalanceInUsdProvider';
}

/// See also [_accountAssetBalanceInUsd].
class _AccountAssetBalanceInUsdProvider extends AutoDisposeProvider<Decimal> {
  /// See also [_accountAssetBalanceInUsd].
  _AccountAssetBalanceInUsdProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => _accountAssetBalanceInUsd(
            ref as _AccountAssetBalanceInUsdRef,
            accountAsset,
          ),
          from: _accountAssetBalanceInUsdProvider,
          name: r'_accountAssetBalanceInUsdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetBalanceInUsdHash,
          dependencies: _AccountAssetBalanceInUsdFamily._dependencies,
          allTransitiveDependencies:
              _AccountAssetBalanceInUsdFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  _AccountAssetBalanceInUsdProvider._internal(
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
    Decimal Function(_AccountAssetBalanceInUsdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _AccountAssetBalanceInUsdProvider._internal(
        (ref) => create(ref as _AccountAssetBalanceInUsdRef),
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
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AccountAssetBalanceInUsdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _AccountAssetBalanceInUsdProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _AccountAssetBalanceInUsdRef on AutoDisposeProviderRef<Decimal> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountAssetBalanceInUsdProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with _AccountAssetBalanceInUsdRef {
  _AccountAssetBalanceInUsdProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as _AccountAssetBalanceInUsdProvider).accountAsset;
}

String _$accountAssetBalanceInUsdStringHash() =>
    r'0807cc69d0cf00435f15a5a9bdc15580df86817a';

/// See also [_accountAssetBalanceInUsdString].
@ProviderFor(_accountAssetBalanceInUsdString)
const _accountAssetBalanceInUsdStringProvider =
    _AccountAssetBalanceInUsdStringFamily();

/// See also [_accountAssetBalanceInUsdString].
class _AccountAssetBalanceInUsdStringFamily extends Family<String> {
  /// See also [_accountAssetBalanceInUsdString].
  const _AccountAssetBalanceInUsdStringFamily();

  /// See also [_accountAssetBalanceInUsdString].
  _AccountAssetBalanceInUsdStringProvider call(
    AccountAsset accountAsset,
  ) {
    return _AccountAssetBalanceInUsdStringProvider(
      accountAsset,
    );
  }

  @override
  _AccountAssetBalanceInUsdStringProvider getProviderOverride(
    covariant _AccountAssetBalanceInUsdStringProvider provider,
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
  String? get name => r'_accountAssetBalanceInUsdStringProvider';
}

/// See also [_accountAssetBalanceInUsdString].
class _AccountAssetBalanceInUsdStringProvider
    extends AutoDisposeProvider<String> {
  /// See also [_accountAssetBalanceInUsdString].
  _AccountAssetBalanceInUsdStringProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => _accountAssetBalanceInUsdString(
            ref as _AccountAssetBalanceInUsdStringRef,
            accountAsset,
          ),
          from: _accountAssetBalanceInUsdStringProvider,
          name: r'_accountAssetBalanceInUsdStringProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetBalanceInUsdStringHash,
          dependencies: _AccountAssetBalanceInUsdStringFamily._dependencies,
          allTransitiveDependencies:
              _AccountAssetBalanceInUsdStringFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  _AccountAssetBalanceInUsdStringProvider._internal(
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
    String Function(_AccountAssetBalanceInUsdStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _AccountAssetBalanceInUsdStringProvider._internal(
        (ref) => create(ref as _AccountAssetBalanceInUsdStringRef),
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
  AutoDisposeProviderElement<String> createElement() {
    return _AccountAssetBalanceInUsdStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _AccountAssetBalanceInUsdStringProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _AccountAssetBalanceInUsdStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountAssetBalanceInUsdStringProviderElement
    extends AutoDisposeProviderElement<String>
    with _AccountAssetBalanceInUsdStringRef {
  _AccountAssetBalanceInUsdStringProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as _AccountAssetBalanceInUsdStringProvider).accountAsset;
}

String _$accountAssetsTotalDefaultCurrencyBalanceStringHash() =>
    r'febf9fc602bda2a7e7d8daf2514f19a3b18b9a41';

/// Default currency converters ============
///
/// Copied from [accountAssetsTotalDefaultCurrencyBalanceString].
@ProviderFor(accountAssetsTotalDefaultCurrencyBalanceString)
const accountAssetsTotalDefaultCurrencyBalanceStringProvider =
    AccountAssetsTotalDefaultCurrencyBalanceStringFamily();

/// Default currency converters ============
///
/// Copied from [accountAssetsTotalDefaultCurrencyBalanceString].
class AccountAssetsTotalDefaultCurrencyBalanceStringFamily
    extends Family<String> {
  /// Default currency converters ============
  ///
  /// Copied from [accountAssetsTotalDefaultCurrencyBalanceString].
  const AccountAssetsTotalDefaultCurrencyBalanceStringFamily();

  /// Default currency converters ============
  ///
  /// Copied from [accountAssetsTotalDefaultCurrencyBalanceString].
  AccountAssetsTotalDefaultCurrencyBalanceStringProvider call(
    List<AccountAsset> accountAssets,
  ) {
    return AccountAssetsTotalDefaultCurrencyBalanceStringProvider(
      accountAssets,
    );
  }

  @override
  AccountAssetsTotalDefaultCurrencyBalanceStringProvider getProviderOverride(
    covariant AccountAssetsTotalDefaultCurrencyBalanceStringProvider provider,
  ) {
    return call(
      provider.accountAssets,
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
  String? get name => r'accountAssetsTotalDefaultCurrencyBalanceStringProvider';
}

/// Default currency converters ============
///
/// Copied from [accountAssetsTotalDefaultCurrencyBalanceString].
class AccountAssetsTotalDefaultCurrencyBalanceStringProvider
    extends AutoDisposeProvider<String> {
  /// Default currency converters ============
  ///
  /// Copied from [accountAssetsTotalDefaultCurrencyBalanceString].
  AccountAssetsTotalDefaultCurrencyBalanceStringProvider(
    List<AccountAsset> accountAssets,
  ) : this._internal(
          (ref) => accountAssetsTotalDefaultCurrencyBalanceString(
            ref as AccountAssetsTotalDefaultCurrencyBalanceStringRef,
            accountAssets,
          ),
          from: accountAssetsTotalDefaultCurrencyBalanceStringProvider,
          name: r'accountAssetsTotalDefaultCurrencyBalanceStringProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetsTotalDefaultCurrencyBalanceStringHash,
          dependencies: AccountAssetsTotalDefaultCurrencyBalanceStringFamily
              ._dependencies,
          allTransitiveDependencies:
              AccountAssetsTotalDefaultCurrencyBalanceStringFamily
                  ._allTransitiveDependencies,
          accountAssets: accountAssets,
        );

  AccountAssetsTotalDefaultCurrencyBalanceStringProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountAssets,
  }) : super.internal();

  final List<AccountAsset> accountAssets;

  @override
  Override overrideWith(
    String Function(AccountAssetsTotalDefaultCurrencyBalanceStringRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override:
          AccountAssetsTotalDefaultCurrencyBalanceStringProvider._internal(
        (ref) =>
            create(ref as AccountAssetsTotalDefaultCurrencyBalanceStringRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountAssets: accountAssets,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _AccountAssetsTotalDefaultCurrencyBalanceStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetsTotalDefaultCurrencyBalanceStringProvider &&
        other.accountAssets == accountAssets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAssets.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetsTotalDefaultCurrencyBalanceStringRef
    on AutoDisposeProviderRef<String> {
  /// The parameter `accountAssets` of this provider.
  List<AccountAsset> get accountAssets;
}

class _AccountAssetsTotalDefaultCurrencyBalanceStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AccountAssetsTotalDefaultCurrencyBalanceStringRef {
  _AccountAssetsTotalDefaultCurrencyBalanceStringProviderElement(
      super.provider);

  @override
  List<AccountAsset> get accountAssets =>
      (origin as AccountAssetsTotalDefaultCurrencyBalanceStringProvider)
          .accountAssets;
}

String _$accountAssetsTotalDefaultCurrencyBalanceHash() =>
    r'b286a3b8810dd9d56d849df6e222b9fb2bac8532';

/// See also [accountAssetsTotalDefaultCurrencyBalance].
@ProviderFor(accountAssetsTotalDefaultCurrencyBalance)
const accountAssetsTotalDefaultCurrencyBalanceProvider =
    AccountAssetsTotalDefaultCurrencyBalanceFamily();

/// See also [accountAssetsTotalDefaultCurrencyBalance].
class AccountAssetsTotalDefaultCurrencyBalanceFamily extends Family<Decimal> {
  /// See also [accountAssetsTotalDefaultCurrencyBalance].
  const AccountAssetsTotalDefaultCurrencyBalanceFamily();

  /// See also [accountAssetsTotalDefaultCurrencyBalance].
  AccountAssetsTotalDefaultCurrencyBalanceProvider call(
    List<AccountAsset> accountAssets,
  ) {
    return AccountAssetsTotalDefaultCurrencyBalanceProvider(
      accountAssets,
    );
  }

  @override
  AccountAssetsTotalDefaultCurrencyBalanceProvider getProviderOverride(
    covariant AccountAssetsTotalDefaultCurrencyBalanceProvider provider,
  ) {
    return call(
      provider.accountAssets,
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
  String? get name => r'accountAssetsTotalDefaultCurrencyBalanceProvider';
}

/// See also [accountAssetsTotalDefaultCurrencyBalance].
class AccountAssetsTotalDefaultCurrencyBalanceProvider
    extends AutoDisposeProvider<Decimal> {
  /// See also [accountAssetsTotalDefaultCurrencyBalance].
  AccountAssetsTotalDefaultCurrencyBalanceProvider(
    List<AccountAsset> accountAssets,
  ) : this._internal(
          (ref) => accountAssetsTotalDefaultCurrencyBalance(
            ref as AccountAssetsTotalDefaultCurrencyBalanceRef,
            accountAssets,
          ),
          from: accountAssetsTotalDefaultCurrencyBalanceProvider,
          name: r'accountAssetsTotalDefaultCurrencyBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetsTotalDefaultCurrencyBalanceHash,
          dependencies:
              AccountAssetsTotalDefaultCurrencyBalanceFamily._dependencies,
          allTransitiveDependencies:
              AccountAssetsTotalDefaultCurrencyBalanceFamily
                  ._allTransitiveDependencies,
          accountAssets: accountAssets,
        );

  AccountAssetsTotalDefaultCurrencyBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountAssets,
  }) : super.internal();

  final List<AccountAsset> accountAssets;

  @override
  Override overrideWith(
    Decimal Function(AccountAssetsTotalDefaultCurrencyBalanceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetsTotalDefaultCurrencyBalanceProvider._internal(
        (ref) => create(ref as AccountAssetsTotalDefaultCurrencyBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountAssets: accountAssets,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AccountAssetsTotalDefaultCurrencyBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetsTotalDefaultCurrencyBalanceProvider &&
        other.accountAssets == accountAssets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAssets.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetsTotalDefaultCurrencyBalanceRef
    on AutoDisposeProviderRef<Decimal> {
  /// The parameter `accountAssets` of this provider.
  List<AccountAsset> get accountAssets;
}

class _AccountAssetsTotalDefaultCurrencyBalanceProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with AccountAssetsTotalDefaultCurrencyBalanceRef {
  _AccountAssetsTotalDefaultCurrencyBalanceProviderElement(super.provider);

  @override
  List<AccountAsset> get accountAssets =>
      (origin as AccountAssetsTotalDefaultCurrencyBalanceProvider)
          .accountAssets;
}

String _$accountAssetBalanceInDefaultCurrencyHash() =>
    r'9eaa7be8b1dcac1852b1f555022b62605e94514a';

/// See also [accountAssetBalanceInDefaultCurrency].
@ProviderFor(accountAssetBalanceInDefaultCurrency)
const accountAssetBalanceInDefaultCurrencyProvider =
    AccountAssetBalanceInDefaultCurrencyFamily();

/// See also [accountAssetBalanceInDefaultCurrency].
class AccountAssetBalanceInDefaultCurrencyFamily extends Family<Decimal> {
  /// See also [accountAssetBalanceInDefaultCurrency].
  const AccountAssetBalanceInDefaultCurrencyFamily();

  /// See also [accountAssetBalanceInDefaultCurrency].
  AccountAssetBalanceInDefaultCurrencyProvider call(
    AccountAsset accountAsset,
  ) {
    return AccountAssetBalanceInDefaultCurrencyProvider(
      accountAsset,
    );
  }

  @override
  AccountAssetBalanceInDefaultCurrencyProvider getProviderOverride(
    covariant AccountAssetBalanceInDefaultCurrencyProvider provider,
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
  String? get name => r'accountAssetBalanceInDefaultCurrencyProvider';
}

/// See also [accountAssetBalanceInDefaultCurrency].
class AccountAssetBalanceInDefaultCurrencyProvider
    extends AutoDisposeProvider<Decimal> {
  /// See also [accountAssetBalanceInDefaultCurrency].
  AccountAssetBalanceInDefaultCurrencyProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => accountAssetBalanceInDefaultCurrency(
            ref as AccountAssetBalanceInDefaultCurrencyRef,
            accountAsset,
          ),
          from: accountAssetBalanceInDefaultCurrencyProvider,
          name: r'accountAssetBalanceInDefaultCurrencyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetBalanceInDefaultCurrencyHash,
          dependencies:
              AccountAssetBalanceInDefaultCurrencyFamily._dependencies,
          allTransitiveDependencies: AccountAssetBalanceInDefaultCurrencyFamily
              ._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  AccountAssetBalanceInDefaultCurrencyProvider._internal(
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
    Decimal Function(AccountAssetBalanceInDefaultCurrencyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetBalanceInDefaultCurrencyProvider._internal(
        (ref) => create(ref as AccountAssetBalanceInDefaultCurrencyRef),
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
  AutoDisposeProviderElement<Decimal> createElement() {
    return _AccountAssetBalanceInDefaultCurrencyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetBalanceInDefaultCurrencyProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetBalanceInDefaultCurrencyRef
    on AutoDisposeProviderRef<Decimal> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountAssetBalanceInDefaultCurrencyProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with AccountAssetBalanceInDefaultCurrencyRef {
  _AccountAssetBalanceInDefaultCurrencyProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as AccountAssetBalanceInDefaultCurrencyProvider).accountAsset;
}

String _$accountAssetBalanceInDefaultCurrencyStringHash() =>
    r'0c9a26fed0a1804effa11bdb1792e45e71b086b6';

/// See also [accountAssetBalanceInDefaultCurrencyString].
@ProviderFor(accountAssetBalanceInDefaultCurrencyString)
const accountAssetBalanceInDefaultCurrencyStringProvider =
    AccountAssetBalanceInDefaultCurrencyStringFamily();

/// See also [accountAssetBalanceInDefaultCurrencyString].
class AccountAssetBalanceInDefaultCurrencyStringFamily extends Family<String> {
  /// See also [accountAssetBalanceInDefaultCurrencyString].
  const AccountAssetBalanceInDefaultCurrencyStringFamily();

  /// See also [accountAssetBalanceInDefaultCurrencyString].
  AccountAssetBalanceInDefaultCurrencyStringProvider call(
    AccountAsset accountAsset,
  ) {
    return AccountAssetBalanceInDefaultCurrencyStringProvider(
      accountAsset,
    );
  }

  @override
  AccountAssetBalanceInDefaultCurrencyStringProvider getProviderOverride(
    covariant AccountAssetBalanceInDefaultCurrencyStringProvider provider,
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
  String? get name => r'accountAssetBalanceInDefaultCurrencyStringProvider';
}

/// See also [accountAssetBalanceInDefaultCurrencyString].
class AccountAssetBalanceInDefaultCurrencyStringProvider
    extends AutoDisposeProvider<String> {
  /// See also [accountAssetBalanceInDefaultCurrencyString].
  AccountAssetBalanceInDefaultCurrencyStringProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => accountAssetBalanceInDefaultCurrencyString(
            ref as AccountAssetBalanceInDefaultCurrencyStringRef,
            accountAsset,
          ),
          from: accountAssetBalanceInDefaultCurrencyStringProvider,
          name: r'accountAssetBalanceInDefaultCurrencyStringProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetBalanceInDefaultCurrencyStringHash,
          dependencies:
              AccountAssetBalanceInDefaultCurrencyStringFamily._dependencies,
          allTransitiveDependencies:
              AccountAssetBalanceInDefaultCurrencyStringFamily
                  ._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  AccountAssetBalanceInDefaultCurrencyStringProvider._internal(
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
    String Function(AccountAssetBalanceInDefaultCurrencyStringRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetBalanceInDefaultCurrencyStringProvider._internal(
        (ref) => create(ref as AccountAssetBalanceInDefaultCurrencyStringRef),
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
  AutoDisposeProviderElement<String> createElement() {
    return _AccountAssetBalanceInDefaultCurrencyStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetBalanceInDefaultCurrencyStringProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetBalanceInDefaultCurrencyStringRef
    on AutoDisposeProviderRef<String> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountAssetBalanceInDefaultCurrencyStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AccountAssetBalanceInDefaultCurrencyStringRef {
  _AccountAssetBalanceInDefaultCurrencyStringProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as AccountAssetBalanceInDefaultCurrencyStringProvider)
          .accountAsset;
}

String _$accountAssetBalanceStringHash() =>
    r'4b1ed1d93f0361a328c3701c8cb7f4cde24d4284';

/// Asset balance ============
///
/// Copied from [accountAssetBalanceString].
@ProviderFor(accountAssetBalanceString)
const accountAssetBalanceStringProvider = AccountAssetBalanceStringFamily();

/// Asset balance ============
///
/// Copied from [accountAssetBalanceString].
class AccountAssetBalanceStringFamily extends Family<String> {
  /// Asset balance ============
  ///
  /// Copied from [accountAssetBalanceString].
  const AccountAssetBalanceStringFamily();

  /// Asset balance ============
  ///
  /// Copied from [accountAssetBalanceString].
  AccountAssetBalanceStringProvider call(
    AccountAsset accountAsset,
  ) {
    return AccountAssetBalanceStringProvider(
      accountAsset,
    );
  }

  @override
  AccountAssetBalanceStringProvider getProviderOverride(
    covariant AccountAssetBalanceStringProvider provider,
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
  String? get name => r'accountAssetBalanceStringProvider';
}

/// Asset balance ============
///
/// Copied from [accountAssetBalanceString].
class AccountAssetBalanceStringProvider extends AutoDisposeProvider<String> {
  /// Asset balance ============
  ///
  /// Copied from [accountAssetBalanceString].
  AccountAssetBalanceStringProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => accountAssetBalanceString(
            ref as AccountAssetBalanceStringRef,
            accountAsset,
          ),
          from: accountAssetBalanceStringProvider,
          name: r'accountAssetBalanceStringProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetBalanceStringHash,
          dependencies: AccountAssetBalanceStringFamily._dependencies,
          allTransitiveDependencies:
              AccountAssetBalanceStringFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  AccountAssetBalanceStringProvider._internal(
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
    String Function(AccountAssetBalanceStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetBalanceStringProvider._internal(
        (ref) => create(ref as AccountAssetBalanceStringRef),
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
  AutoDisposeProviderElement<String> createElement() {
    return _AccountAssetBalanceStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetBalanceStringProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetBalanceStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountAssetBalanceStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AccountAssetBalanceStringRef {
  _AccountAssetBalanceStringProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as AccountAssetBalanceStringProvider).accountAsset;
}

String _$defaultCurrencyTickerHash() =>
    r'd2c75bd58a5ed26500f43de6b021872ef45053cd';

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

typedef DefaultCurrencyTickerRef = AutoDisposeProviderRef<String>;
String _$balancesNotifierHash() => r'd7827099d37568583c6dd45f66b61c5d44c1fcf1';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
