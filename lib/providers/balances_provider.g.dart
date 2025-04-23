// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balances_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$balanceUniqueAccountTypesHash() =>
    r'2317a468288b9ff3170fa25613eadc0206317323';

/// See also [balanceUniqueAccountTypes].
@ProviderFor(balanceUniqueAccountTypes)
final balanceUniqueAccountTypesProvider =
    AutoDisposeProvider<List<AccountType>>.internal(
      balanceUniqueAccountTypes,
      name: r'balanceUniqueAccountTypesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$balanceUniqueAccountTypesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BalanceUniqueAccountTypesRef =
    AutoDisposeProviderRef<List<AccountType>>;
String _$outputsBalanceForAssetHash() =>
    r'dab3956f01c619538b25b5f5a374fdd4ffd89ea4';

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
  OutputsBalanceForAssetProvider call(AccountAsset accountAsset) {
    return OutputsBalanceForAssetProvider(accountAsset);
  }

  @override
  OutputsBalanceForAssetProvider getProviderOverride(
    covariant OutputsBalanceForAssetProvider provider,
  ) {
    return call(provider.accountAsset);
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
  OutputsBalanceForAssetProvider(AccountAsset accountAsset)
    : this._internal(
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OutputsBalanceForAssetRef on AutoDisposeProviderRef<int> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _OutputsBalanceForAssetProviderElement
    extends AutoDisposeProviderElement<int>
    with OutputsBalanceForAssetRef {
  _OutputsBalanceForAssetProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as OutputsBalanceForAssetProvider).accountAsset;
}

String _$selectedInputsBalanceForAssetHash() =>
    r'945158eba82d4e779856db35789c6a2c52070bf3';

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
  SelectedInputsBalanceForAssetProvider call(AccountAsset accountAsset) {
    return SelectedInputsBalanceForAssetProvider(accountAsset);
  }

  @override
  SelectedInputsBalanceForAssetProvider getProviderOverride(
    covariant SelectedInputsBalanceForAssetProvider provider,
  ) {
    return call(provider.accountAsset);
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
  SelectedInputsBalanceForAssetProvider(AccountAsset accountAsset)
    : this._internal(
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'1b7f4e2c413a3b58bd42bc6e7b2d004b74be84f1';

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
    return MaxAvailableBalanceWithInputsForAccountAssetProvider(accountAsset);
  }

  @override
  MaxAvailableBalanceWithInputsForAccountAssetProvider getProviderOverride(
    covariant MaxAvailableBalanceWithInputsForAccountAssetProvider provider,
  ) {
    return call(provider.accountAsset);
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'f6d7ad5599145973b520ee2ef13dce2e07b823a4';

/// See also [balanceWithInputsForAccountAsset].
@ProviderFor(balanceWithInputsForAccountAsset)
const balanceWithInputsForAccountAssetProvider =
    BalanceWithInputsForAccountAssetFamily();

/// See also [balanceWithInputsForAccountAsset].
class BalanceWithInputsForAccountAssetFamily extends Family<int> {
  /// See also [balanceWithInputsForAccountAsset].
  const BalanceWithInputsForAccountAssetFamily();

  /// See also [balanceWithInputsForAccountAsset].
  BalanceWithInputsForAccountAssetProvider call(AccountAsset accountAsset) {
    return BalanceWithInputsForAccountAssetProvider(accountAsset);
  }

  @override
  BalanceWithInputsForAccountAssetProvider getProviderOverride(
    covariant BalanceWithInputsForAccountAssetProvider provider,
  ) {
    return call(provider.accountAsset);
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
  BalanceWithInputsForAccountAssetProvider(AccountAsset accountAsset)
    : this._internal(
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'0c88e688c3e18edd862702c5c8aaee9eb85c21e0';

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
    return BalanceStringWithInputsForAccountAssetProvider(accountAsset);
  }

  @override
  BalanceStringWithInputsForAccountAssetProvider getProviderOverride(
    covariant BalanceStringWithInputsForAccountAssetProvider provider,
  ) {
    return call(provider.accountAsset);
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
  BalanceStringWithInputsForAccountAssetProvider(AccountAsset accountAsset)
    : this._internal(
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'444fa19c578e94f34ed631a54c9493c7db574c28';

/// See also [balanceStringWithInputs].
@ProviderFor(balanceStringWithInputs)
final balanceStringWithInputsProvider = AutoDisposeProvider<String>.internal(
  balanceStringWithInputs,
  name: r'balanceStringWithInputsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$balanceStringWithInputsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BalanceStringWithInputsRef = AutoDisposeProviderRef<String>;
String _$accountAssetBalanceWithInputsInDefaultCurrencyHash() =>
    r'fbfb44e1a4470345aafd51f2f263f4f99529ca59';

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
    return AccountAssetBalanceWithInputsInDefaultCurrencyProvider(accountAsset);
  }

  @override
  AccountAssetBalanceWithInputsInDefaultCurrencyProvider getProviderOverride(
    covariant AccountAssetBalanceWithInputsInDefaultCurrencyProvider provider,
  ) {
    return call(provider.accountAsset);
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
        dependencies:
            AccountAssetBalanceWithInputsInDefaultCurrencyFamily._dependencies,
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
            (ref) => create(
              ref as AccountAssetBalanceWithInputsInDefaultCurrencyRef,
            ),
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountAssetBalanceWithInputsInDefaultCurrencyRef
    on AutoDisposeProviderRef<Decimal> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountAssetBalanceWithInputsInDefaultCurrencyProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with AccountAssetBalanceWithInputsInDefaultCurrencyRef {
  _AccountAssetBalanceWithInputsInDefaultCurrencyProviderElement(
    super.provider,
  );

  @override
  AccountAsset get accountAsset =>
      (origin as AccountAssetBalanceWithInputsInDefaultCurrencyProvider)
          .accountAsset;
}

String _$accountAssetBalanceWithInputsInDefaultCurrencyStringHash() =>
    r'331723fd15b0a0987ea8a8843ff4e5806dce838a';

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
    return call(provider.accountAsset);
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
      AccountAssetBalanceWithInputsInDefaultCurrencyStringRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override:
          AccountAssetBalanceWithInputsInDefaultCurrencyStringProvider._internal(
            (ref) => create(
              ref as AccountAssetBalanceWithInputsInDefaultCurrencyStringRef,
            ),
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
      this,
    );
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountAssetBalanceWithInputsInDefaultCurrencyStringRef
    on AutoDisposeProviderRef<String> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountAssetBalanceWithInputsInDefaultCurrencyStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AccountAssetBalanceWithInputsInDefaultCurrencyStringRef {
  _AccountAssetBalanceWithInputsInDefaultCurrencyStringProviderElement(
    super.provider,
  );

  @override
  AccountAsset get accountAsset =>
      (origin as AccountAssetBalanceWithInputsInDefaultCurrencyStringProvider)
          .accountAsset;
}

String _$totalMaxAvailableBalanceForAssetHash() =>
    r'7ce7f14878122884d13c6e436e419a84f02ac5fd';

/// Balance providers without inputs
///
/// Copied from [totalMaxAvailableBalanceForAsset].
@ProviderFor(totalMaxAvailableBalanceForAsset)
const totalMaxAvailableBalanceForAssetProvider =
    TotalMaxAvailableBalanceForAssetFamily();

/// Balance providers without inputs
///
/// Copied from [totalMaxAvailableBalanceForAsset].
class TotalMaxAvailableBalanceForAssetFamily extends Family<int> {
  /// Balance providers without inputs
  ///
  /// Copied from [totalMaxAvailableBalanceForAsset].
  const TotalMaxAvailableBalanceForAssetFamily();

  /// Balance providers without inputs
  ///
  /// Copied from [totalMaxAvailableBalanceForAsset].
  TotalMaxAvailableBalanceForAssetProvider call(String? assetId) {
    return TotalMaxAvailableBalanceForAssetProvider(assetId);
  }

  @override
  TotalMaxAvailableBalanceForAssetProvider getProviderOverride(
    covariant TotalMaxAvailableBalanceForAssetProvider provider,
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
  String? get name => r'totalMaxAvailableBalanceForAssetProvider';
}

/// Balance providers without inputs
///
/// Copied from [totalMaxAvailableBalanceForAsset].
class TotalMaxAvailableBalanceForAssetProvider
    extends AutoDisposeProvider<int> {
  /// Balance providers without inputs
  ///
  /// Copied from [totalMaxAvailableBalanceForAsset].
  TotalMaxAvailableBalanceForAssetProvider(String? assetId)
    : this._internal(
        (ref) => totalMaxAvailableBalanceForAsset(
          ref as TotalMaxAvailableBalanceForAssetRef,
          assetId,
        ),
        from: totalMaxAvailableBalanceForAssetProvider,
        name: r'totalMaxAvailableBalanceForAssetProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$totalMaxAvailableBalanceForAssetHash,
        dependencies: TotalMaxAvailableBalanceForAssetFamily._dependencies,
        allTransitiveDependencies:
            TotalMaxAvailableBalanceForAssetFamily._allTransitiveDependencies,
        assetId: assetId,
      );

  TotalMaxAvailableBalanceForAssetProvider._internal(
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
    int Function(TotalMaxAvailableBalanceForAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TotalMaxAvailableBalanceForAssetProvider._internal(
        (ref) => create(ref as TotalMaxAvailableBalanceForAssetRef),
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
    return _TotalMaxAvailableBalanceForAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalMaxAvailableBalanceForAssetProvider &&
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
mixin TotalMaxAvailableBalanceForAssetRef on AutoDisposeProviderRef<int> {
  /// The parameter `assetId` of this provider.
  String? get assetId;
}

class _TotalMaxAvailableBalanceForAssetProviderElement
    extends AutoDisposeProviderElement<int>
    with TotalMaxAvailableBalanceForAssetRef {
  _TotalMaxAvailableBalanceForAssetProviderElement(super.provider);

  @override
  String? get assetId =>
      (origin as TotalMaxAvailableBalanceForAssetProvider).assetId;
}

String _$maxAvailableBalanceForAccountAssetHash() =>
    r'e56090abdc65b60f517bcaf6d23ca5badb3dc83f';

/// See also [maxAvailableBalanceForAccountAsset].
@ProviderFor(maxAvailableBalanceForAccountAsset)
const maxAvailableBalanceForAccountAssetProvider =
    MaxAvailableBalanceForAccountAssetFamily();

/// See also [maxAvailableBalanceForAccountAsset].
class MaxAvailableBalanceForAccountAssetFamily extends Family<int> {
  /// See also [maxAvailableBalanceForAccountAsset].
  const MaxAvailableBalanceForAccountAssetFamily();

  /// See also [maxAvailableBalanceForAccountAsset].
  MaxAvailableBalanceForAccountAssetProvider call(AccountAsset accountAsset) {
    return MaxAvailableBalanceForAccountAssetProvider(accountAsset);
  }

  @override
  MaxAvailableBalanceForAccountAssetProvider getProviderOverride(
    covariant MaxAvailableBalanceForAccountAssetProvider provider,
  ) {
    return call(provider.accountAsset);
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

/// See also [maxAvailableBalanceForAccountAsset].
class MaxAvailableBalanceForAccountAssetProvider
    extends AutoDisposeProvider<int> {
  /// See also [maxAvailableBalanceForAccountAsset].
  MaxAvailableBalanceForAccountAssetProvider(AccountAsset accountAsset)
    : this._internal(
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
        allTransitiveDependencies:
            MaxAvailableBalanceForAccountAssetFamily._allTransitiveDependencies,
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
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
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
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
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$defaultCurrencyConversionWithTickerHash,
        dependencies: DefaultCurrencyConversionWithTickerFamily._dependencies,
        allTransitiveDependencies:
            DefaultCurrencyConversionWithTickerFamily
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
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$defaultCurrencyConversionFromStringHash,
        dependencies: DefaultCurrencyConversionFromStringFamily._dependencies,
        allTransitiveDependencies:
            DefaultCurrencyConversionFromStringFamily
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

String _$accountAssetsTotalLbtcBalanceHash() =>
    r'cd9b41b9d82dc7e7157226cffd4c2029151cc489';

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
  AccountAssetsTotalLbtcBalanceProvider call(List<AccountAsset> accountAssets) {
    return AccountAssetsTotalLbtcBalanceProvider(accountAssets);
  }

  @override
  AccountAssetsTotalLbtcBalanceProvider getProviderOverride(
    covariant AccountAssetsTotalLbtcBalanceProvider provider,
  ) {
    return call(provider.accountAssets);
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
  AccountAssetsTotalLbtcBalanceProvider(List<AccountAsset> accountAssets)
    : this._internal(
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'00d3641b6c1cad465f9fd784a5fcd9cbd834e190';

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
    return _AccountAssetsTotalUsdBalanceStringProvider(accountAssets);
  }

  @override
  _AccountAssetsTotalUsdBalanceStringProvider getProviderOverride(
    covariant _AccountAssetsTotalUsdBalanceStringProvider provider,
  ) {
    return call(provider.accountAssets);
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
  _AccountAssetsTotalUsdBalanceStringProvider(List<AccountAsset> accountAssets)
    : this._internal(
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
        allTransitiveDependencies:
            _AccountAssetsTotalUsdBalanceStringFamily
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'd5570c942da0eaa4671c69df81a870a50b5bb278';

/// See also [_accountAssetsTotalUsdBalance].
@ProviderFor(_accountAssetsTotalUsdBalance)
const _accountAssetsTotalUsdBalanceProvider =
    _AccountAssetsTotalUsdBalanceFamily();

/// See also [_accountAssetsTotalUsdBalance].
class _AccountAssetsTotalUsdBalanceFamily extends Family<Decimal> {
  /// See also [_accountAssetsTotalUsdBalance].
  const _AccountAssetsTotalUsdBalanceFamily();

  /// See also [_accountAssetsTotalUsdBalance].
  _AccountAssetsTotalUsdBalanceProvider call(List<AccountAsset> accountAssets) {
    return _AccountAssetsTotalUsdBalanceProvider(accountAssets);
  }

  @override
  _AccountAssetsTotalUsdBalanceProvider getProviderOverride(
    covariant _AccountAssetsTotalUsdBalanceProvider provider,
  ) {
    return call(provider.accountAssets);
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
  _AccountAssetsTotalUsdBalanceProvider(List<AccountAsset> accountAssets)
    : this._internal(
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'ed7f93bb9be6ea609f73487699521f8be39af6e4';

/// See also [_accountAssetBalanceInUsd].
@ProviderFor(_accountAssetBalanceInUsd)
const _accountAssetBalanceInUsdProvider = _AccountAssetBalanceInUsdFamily();

/// See also [_accountAssetBalanceInUsd].
class _AccountAssetBalanceInUsdFamily extends Family<Decimal> {
  /// See also [_accountAssetBalanceInUsd].
  const _AccountAssetBalanceInUsdFamily();

  /// See also [_accountAssetBalanceInUsd].
  _AccountAssetBalanceInUsdProvider call(AccountAsset accountAsset) {
    return _AccountAssetBalanceInUsdProvider(accountAsset);
  }

  @override
  _AccountAssetBalanceInUsdProvider getProviderOverride(
    covariant _AccountAssetBalanceInUsdProvider provider,
  ) {
    return call(provider.accountAsset);
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
  _AccountAssetBalanceInUsdProvider(AccountAsset accountAsset)
    : this._internal(
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'484be1350c799130cba281bd839cf0965514815a';

/// See also [_accountAssetBalanceInUsdString].
@ProviderFor(_accountAssetBalanceInUsdString)
const _accountAssetBalanceInUsdStringProvider =
    _AccountAssetBalanceInUsdStringFamily();

/// See also [_accountAssetBalanceInUsdString].
class _AccountAssetBalanceInUsdStringFamily extends Family<String> {
  /// See also [_accountAssetBalanceInUsdString].
  const _AccountAssetBalanceInUsdStringFamily();

  /// See also [_accountAssetBalanceInUsdString].
  _AccountAssetBalanceInUsdStringProvider call(AccountAsset accountAsset) {
    return _AccountAssetBalanceInUsdStringProvider(accountAsset);
  }

  @override
  _AccountAssetBalanceInUsdStringProvider getProviderOverride(
    covariant _AccountAssetBalanceInUsdStringProvider provider,
  ) {
    return call(provider.accountAsset);
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
  _AccountAssetBalanceInUsdStringProvider(AccountAsset accountAsset)
    : this._internal(
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'bd4cbef90f7ce495d300c3f8fdc954e0bfae0a57';

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
    return call(provider.accountAssets);
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
        dependencies:
            AccountAssetsTotalDefaultCurrencyBalanceStringFamily._dependencies,
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
            (ref) => create(
              ref as AccountAssetsTotalDefaultCurrencyBalanceStringRef,
            ),
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountAssetsTotalDefaultCurrencyBalanceStringRef
    on AutoDisposeProviderRef<String> {
  /// The parameter `accountAssets` of this provider.
  List<AccountAsset> get accountAssets;
}

class _AccountAssetsTotalDefaultCurrencyBalanceStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AccountAssetsTotalDefaultCurrencyBalanceStringRef {
  _AccountAssetsTotalDefaultCurrencyBalanceStringProviderElement(
    super.provider,
  );

  @override
  List<AccountAsset> get accountAssets =>
      (origin as AccountAssetsTotalDefaultCurrencyBalanceStringProvider)
          .accountAssets;
}

String _$accountAssetsTotalDefaultCurrencyBalanceHash() =>
    r'33f66fbbc89474535b4f132399b25ae6aabf25b2';

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
    return AccountAssetsTotalDefaultCurrencyBalanceProvider(accountAssets);
  }

  @override
  AccountAssetsTotalDefaultCurrencyBalanceProvider getProviderOverride(
    covariant AccountAssetsTotalDefaultCurrencyBalanceProvider provider,
  ) {
    return call(provider.accountAssets);
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'242928ec2f959389c7676bb22824e55cec9c7454';

/// See also [accountAssetBalanceInDefaultCurrency].
@ProviderFor(accountAssetBalanceInDefaultCurrency)
const accountAssetBalanceInDefaultCurrencyProvider =
    AccountAssetBalanceInDefaultCurrencyFamily();

/// See also [accountAssetBalanceInDefaultCurrency].
class AccountAssetBalanceInDefaultCurrencyFamily extends Family<Decimal> {
  /// See also [accountAssetBalanceInDefaultCurrency].
  const AccountAssetBalanceInDefaultCurrencyFamily();

  /// See also [accountAssetBalanceInDefaultCurrency].
  AccountAssetBalanceInDefaultCurrencyProvider call(AccountAsset accountAsset) {
    return AccountAssetBalanceInDefaultCurrencyProvider(accountAsset);
  }

  @override
  AccountAssetBalanceInDefaultCurrencyProvider getProviderOverride(
    covariant AccountAssetBalanceInDefaultCurrencyProvider provider,
  ) {
    return call(provider.accountAsset);
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
  AccountAssetBalanceInDefaultCurrencyProvider(AccountAsset accountAsset)
    : this._internal(
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
        dependencies: AccountAssetBalanceInDefaultCurrencyFamily._dependencies,
        allTransitiveDependencies:
            AccountAssetBalanceInDefaultCurrencyFamily
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'2ec82442e62bc85b3df3af3a6aa9568ec958a549';

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
    return AccountAssetBalanceInDefaultCurrencyStringProvider(accountAsset);
  }

  @override
  AccountAssetBalanceInDefaultCurrencyStringProvider getProviderOverride(
    covariant AccountAssetBalanceInDefaultCurrencyStringProvider provider,
  ) {
    return call(provider.accountAsset);
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
  AccountAssetBalanceInDefaultCurrencyStringProvider(AccountAsset accountAsset)
    : this._internal(
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'0795ce0ab43464b2e1ad302a3414d293f4ffe59c';

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
  AccountAssetBalanceStringProvider call(AccountAsset accountAsset) {
    return AccountAssetBalanceStringProvider(accountAsset);
  }

  @override
  AccountAssetBalanceStringProvider getProviderOverride(
    covariant AccountAssetBalanceStringProvider provider,
  ) {
    return call(provider.accountAsset);
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
  AccountAssetBalanceStringProvider(AccountAsset accountAsset)
    : this._internal(
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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

String _$totalMaxAvailableBalanceForAssetAsStringHash() =>
    r'013b010f7f9191b0eec2512097b03b4b4f4eb675';

/// See also [totalMaxAvailableBalanceForAssetAsString].
@ProviderFor(totalMaxAvailableBalanceForAssetAsString)
const totalMaxAvailableBalanceForAssetAsStringProvider =
    TotalMaxAvailableBalanceForAssetAsStringFamily();

/// See also [totalMaxAvailableBalanceForAssetAsString].
class TotalMaxAvailableBalanceForAssetAsStringFamily extends Family<String> {
  /// See also [totalMaxAvailableBalanceForAssetAsString].
  const TotalMaxAvailableBalanceForAssetAsStringFamily();

  /// See also [totalMaxAvailableBalanceForAssetAsString].
  TotalMaxAvailableBalanceForAssetAsStringProvider call(String? assetId) {
    return TotalMaxAvailableBalanceForAssetAsStringProvider(assetId);
  }

  @override
  TotalMaxAvailableBalanceForAssetAsStringProvider getProviderOverride(
    covariant TotalMaxAvailableBalanceForAssetAsStringProvider provider,
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
  String? get name => r'totalMaxAvailableBalanceForAssetAsStringProvider';
}

/// See also [totalMaxAvailableBalanceForAssetAsString].
class TotalMaxAvailableBalanceForAssetAsStringProvider
    extends AutoDisposeProvider<String> {
  /// See also [totalMaxAvailableBalanceForAssetAsString].
  TotalMaxAvailableBalanceForAssetAsStringProvider(String? assetId)
    : this._internal(
        (ref) => totalMaxAvailableBalanceForAssetAsString(
          ref as TotalMaxAvailableBalanceForAssetAsStringRef,
          assetId,
        ),
        from: totalMaxAvailableBalanceForAssetAsStringProvider,
        name: r'totalMaxAvailableBalanceForAssetAsStringProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$totalMaxAvailableBalanceForAssetAsStringHash,
        dependencies:
            TotalMaxAvailableBalanceForAssetAsStringFamily._dependencies,
        allTransitiveDependencies:
            TotalMaxAvailableBalanceForAssetAsStringFamily
                ._allTransitiveDependencies,
        assetId: assetId,
      );

  TotalMaxAvailableBalanceForAssetAsStringProvider._internal(
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
    String Function(TotalMaxAvailableBalanceForAssetAsStringRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TotalMaxAvailableBalanceForAssetAsStringProvider._internal(
        (ref) => create(ref as TotalMaxAvailableBalanceForAssetAsStringRef),
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
    return _TotalMaxAvailableBalanceForAssetAsStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalMaxAvailableBalanceForAssetAsStringProvider &&
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
mixin TotalMaxAvailableBalanceForAssetAsStringRef
    on AutoDisposeProviderRef<String> {
  /// The parameter `assetId` of this provider.
  String? get assetId;
}

class _TotalMaxAvailableBalanceForAssetAsStringProviderElement
    extends AutoDisposeProviderElement<String>
    with TotalMaxAvailableBalanceForAssetAsStringRef {
  _TotalMaxAvailableBalanceForAssetAsStringProviderElement(super.provider);

  @override
  String? get assetId =>
      (origin as TotalMaxAvailableBalanceForAssetAsStringProvider).assetId;
}

String _$defaultCurrencyTickerHash() =>
    r'adf1cae370426e5c364eaa0dfd834166041ac867';

/// See also [defaultCurrencyTicker].
@ProviderFor(defaultCurrencyTicker)
final defaultCurrencyTickerProvider = AutoDisposeProvider<String>.internal(
  defaultCurrencyTicker,
  name: r'defaultCurrencyTickerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$defaultCurrencyTickerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DefaultCurrencyTickerRef = AutoDisposeProviderRef<String>;
String _$balancesNotifierHash() => r'cacedc41b0ad8a5ec7822c318f388b72d228005b';

/// See also [BalancesNotifier].
@ProviderFor(BalancesNotifier)
final balancesNotifierProvider =
    NotifierProvider<BalancesNotifier, Map<AccountAsset, int>>.internal(
      BalancesNotifier.new,
      name: r'balancesNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$balancesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BalancesNotifier = Notifier<Map<AccountAsset, int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
