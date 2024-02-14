// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balances_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$balanceStringHash() => r'b327a6c480185df1d73ea3fd537ce993266821d4';

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

/// See also [balanceString].
@ProviderFor(balanceString)
const balanceStringProvider = BalanceStringFamily();

/// See also [balanceString].
class BalanceStringFamily extends Family<String> {
  /// See also [balanceString].
  const BalanceStringFamily();

  /// See also [balanceString].
  BalanceStringProvider call(
    AccountAsset accountAsset,
  ) {
    return BalanceStringProvider(
      accountAsset,
    );
  }

  @override
  BalanceStringProvider getProviderOverride(
    covariant BalanceStringProvider provider,
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
  String? get name => r'balanceStringProvider';
}

/// See also [balanceString].
class BalanceStringProvider extends AutoDisposeProvider<String> {
  /// See also [balanceString].
  BalanceStringProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => balanceString(
            ref as BalanceStringRef,
            accountAsset,
          ),
          from: balanceStringProvider,
          name: r'balanceStringProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$balanceStringHash,
          dependencies: BalanceStringFamily._dependencies,
          allTransitiveDependencies:
              BalanceStringFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  BalanceStringProvider._internal(
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
    String Function(BalanceStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BalanceStringProvider._internal(
        (ref) => create(ref as BalanceStringRef),
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
    return _BalanceStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BalanceStringProvider && other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BalanceStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _BalanceStringProviderElement extends AutoDisposeProviderElement<String>
    with BalanceStringRef {
  _BalanceStringProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as BalanceStringProvider).accountAsset;
}

String _$amountUsdHash() => r'87a5b3d32fa30db9a3df03ffbfddcef8e5403a2f';

/// See also [amountUsd].
@ProviderFor(amountUsd)
const amountUsdProvider = AmountUsdFamily();

/// See also [amountUsd].
class AmountUsdFamily extends Family<double> {
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
class AmountUsdProvider extends AutoDisposeProvider<double> {
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
    double Function(AmountUsdRef provider) create,
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
  AutoDisposeProviderElement<double> createElement() {
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

mixin AmountUsdRef on AutoDisposeProviderRef<double> {
  /// The parameter `assetId` of this provider.
  String? get assetId;

  /// The parameter `amount` of this provider.
  num get amount;
}

class _AmountUsdProviderElement extends AutoDisposeProviderElement<double>
    with AmountUsdRef {
  _AmountUsdProviderElement(super.provider);

  @override
  String? get assetId => (origin as AmountUsdProvider).assetId;
  @override
  num get amount => (origin as AmountUsdProvider).amount;
}

String _$accountAssetsTotalUsdBalanceStringHash() =>
    r'49e66f624ba9034cd159b8091c0bbb2faa1f1dd2';

/// See also [accountAssetsTotalUsdBalanceString].
@ProviderFor(accountAssetsTotalUsdBalanceString)
const accountAssetsTotalUsdBalanceStringProvider =
    AccountAssetsTotalUsdBalanceStringFamily();

/// See also [accountAssetsTotalUsdBalanceString].
class AccountAssetsTotalUsdBalanceStringFamily extends Family<String> {
  /// See also [accountAssetsTotalUsdBalanceString].
  const AccountAssetsTotalUsdBalanceStringFamily();

  /// See also [accountAssetsTotalUsdBalanceString].
  AccountAssetsTotalUsdBalanceStringProvider call(
    List<AccountAsset> accountAssets,
  ) {
    return AccountAssetsTotalUsdBalanceStringProvider(
      accountAssets,
    );
  }

  @override
  AccountAssetsTotalUsdBalanceStringProvider getProviderOverride(
    covariant AccountAssetsTotalUsdBalanceStringProvider provider,
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
  String? get name => r'accountAssetsTotalUsdBalanceStringProvider';
}

/// See also [accountAssetsTotalUsdBalanceString].
class AccountAssetsTotalUsdBalanceStringProvider
    extends AutoDisposeProvider<String> {
  /// See also [accountAssetsTotalUsdBalanceString].
  AccountAssetsTotalUsdBalanceStringProvider(
    List<AccountAsset> accountAssets,
  ) : this._internal(
          (ref) => accountAssetsTotalUsdBalanceString(
            ref as AccountAssetsTotalUsdBalanceStringRef,
            accountAssets,
          ),
          from: accountAssetsTotalUsdBalanceStringProvider,
          name: r'accountAssetsTotalUsdBalanceStringProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetsTotalUsdBalanceStringHash,
          dependencies: AccountAssetsTotalUsdBalanceStringFamily._dependencies,
          allTransitiveDependencies: AccountAssetsTotalUsdBalanceStringFamily
              ._allTransitiveDependencies,
          accountAssets: accountAssets,
        );

  AccountAssetsTotalUsdBalanceStringProvider._internal(
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
    String Function(AccountAssetsTotalUsdBalanceStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetsTotalUsdBalanceStringProvider._internal(
        (ref) => create(ref as AccountAssetsTotalUsdBalanceStringRef),
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
    return other is AccountAssetsTotalUsdBalanceStringProvider &&
        other.accountAssets == accountAssets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAssets.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetsTotalUsdBalanceStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `accountAssets` of this provider.
  List<AccountAsset> get accountAssets;
}

class _AccountAssetsTotalUsdBalanceStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AccountAssetsTotalUsdBalanceStringRef {
  _AccountAssetsTotalUsdBalanceStringProviderElement(super.provider);

  @override
  List<AccountAsset> get accountAssets =>
      (origin as AccountAssetsTotalUsdBalanceStringProvider).accountAssets;
}

String _$accountAssetsTotalUsdBalanceHash() =>
    r'5cd9879d9f7e2456a9823e2f6c72aa279c0e5b3a';

/// See also [accountAssetsTotalUsdBalance].
@ProviderFor(accountAssetsTotalUsdBalance)
const accountAssetsTotalUsdBalanceProvider =
    AccountAssetsTotalUsdBalanceFamily();

/// See also [accountAssetsTotalUsdBalance].
class AccountAssetsTotalUsdBalanceFamily extends Family<Decimal> {
  /// See also [accountAssetsTotalUsdBalance].
  const AccountAssetsTotalUsdBalanceFamily();

  /// See also [accountAssetsTotalUsdBalance].
  AccountAssetsTotalUsdBalanceProvider call(
    List<AccountAsset> accountAssets,
  ) {
    return AccountAssetsTotalUsdBalanceProvider(
      accountAssets,
    );
  }

  @override
  AccountAssetsTotalUsdBalanceProvider getProviderOverride(
    covariant AccountAssetsTotalUsdBalanceProvider provider,
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
  String? get name => r'accountAssetsTotalUsdBalanceProvider';
}

/// See also [accountAssetsTotalUsdBalance].
class AccountAssetsTotalUsdBalanceProvider
    extends AutoDisposeProvider<Decimal> {
  /// See also [accountAssetsTotalUsdBalance].
  AccountAssetsTotalUsdBalanceProvider(
    List<AccountAsset> accountAssets,
  ) : this._internal(
          (ref) => accountAssetsTotalUsdBalance(
            ref as AccountAssetsTotalUsdBalanceRef,
            accountAssets,
          ),
          from: accountAssetsTotalUsdBalanceProvider,
          name: r'accountAssetsTotalUsdBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetsTotalUsdBalanceHash,
          dependencies: AccountAssetsTotalUsdBalanceFamily._dependencies,
          allTransitiveDependencies:
              AccountAssetsTotalUsdBalanceFamily._allTransitiveDependencies,
          accountAssets: accountAssets,
        );

  AccountAssetsTotalUsdBalanceProvider._internal(
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
    Decimal Function(AccountAssetsTotalUsdBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetsTotalUsdBalanceProvider._internal(
        (ref) => create(ref as AccountAssetsTotalUsdBalanceRef),
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
    return other is AccountAssetsTotalUsdBalanceProvider &&
        other.accountAssets == accountAssets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAssets.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetsTotalUsdBalanceRef on AutoDisposeProviderRef<Decimal> {
  /// The parameter `accountAssets` of this provider.
  List<AccountAsset> get accountAssets;
}

class _AccountAssetsTotalUsdBalanceProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with AccountAssetsTotalUsdBalanceRef {
  _AccountAssetsTotalUsdBalanceProviderElement(super.provider);

  @override
  List<AccountAsset> get accountAssets =>
      (origin as AccountAssetsTotalUsdBalanceProvider).accountAssets;
}

String _$accountAssetsTotalLbtcBalanceHash() =>
    r'0a1bfd91b2236fcae0ee218debb66fb944dae7d2';

/// See also [accountAssetsTotalLbtcBalance].
@ProviderFor(accountAssetsTotalLbtcBalance)
const accountAssetsTotalLbtcBalanceProvider =
    AccountAssetsTotalLbtcBalanceFamily();

/// See also [accountAssetsTotalLbtcBalance].
class AccountAssetsTotalLbtcBalanceFamily extends Family<String> {
  /// See also [accountAssetsTotalLbtcBalance].
  const AccountAssetsTotalLbtcBalanceFamily();

  /// See also [accountAssetsTotalLbtcBalance].
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

/// See also [accountAssetsTotalLbtcBalance].
class AccountAssetsTotalLbtcBalanceProvider
    extends AutoDisposeProvider<String> {
  /// See also [accountAssetsTotalLbtcBalance].
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

String _$accountAssetBalanceInUsdStringHash() =>
    r'342e632f1a5e14a7fd4b5a02d0a1331d8446bc56';

/// See also [accountAssetBalanceInUsdString].
@ProviderFor(accountAssetBalanceInUsdString)
const accountAssetBalanceInUsdStringProvider =
    AccountAssetBalanceInUsdStringFamily();

/// See also [accountAssetBalanceInUsdString].
class AccountAssetBalanceInUsdStringFamily extends Family<String> {
  /// See also [accountAssetBalanceInUsdString].
  const AccountAssetBalanceInUsdStringFamily();

  /// See also [accountAssetBalanceInUsdString].
  AccountAssetBalanceInUsdStringProvider call(
    AccountAsset accountAsset,
  ) {
    return AccountAssetBalanceInUsdStringProvider(
      accountAsset,
    );
  }

  @override
  AccountAssetBalanceInUsdStringProvider getProviderOverride(
    covariant AccountAssetBalanceInUsdStringProvider provider,
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
  String? get name => r'accountAssetBalanceInUsdStringProvider';
}

/// See also [accountAssetBalanceInUsdString].
class AccountAssetBalanceInUsdStringProvider
    extends AutoDisposeProvider<String> {
  /// See also [accountAssetBalanceInUsdString].
  AccountAssetBalanceInUsdStringProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => accountAssetBalanceInUsdString(
            ref as AccountAssetBalanceInUsdStringRef,
            accountAsset,
          ),
          from: accountAssetBalanceInUsdStringProvider,
          name: r'accountAssetBalanceInUsdStringProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetBalanceInUsdStringHash,
          dependencies: AccountAssetBalanceInUsdStringFamily._dependencies,
          allTransitiveDependencies:
              AccountAssetBalanceInUsdStringFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  AccountAssetBalanceInUsdStringProvider._internal(
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
    String Function(AccountAssetBalanceInUsdStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetBalanceInUsdStringProvider._internal(
        (ref) => create(ref as AccountAssetBalanceInUsdStringRef),
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
    return other is AccountAssetBalanceInUsdStringProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetBalanceInUsdStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountAssetBalanceInUsdStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AccountAssetBalanceInUsdStringRef {
  _AccountAssetBalanceInUsdStringProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as AccountAssetBalanceInUsdStringProvider).accountAsset;
}

String _$accountAssetBalanceInUsdHash() =>
    r'2efa7ba36e51a10e1749e03bbd820a5bd36ad3af';

/// See also [accountAssetBalanceInUsd].
@ProviderFor(accountAssetBalanceInUsd)
const accountAssetBalanceInUsdProvider = AccountAssetBalanceInUsdFamily();

/// See also [accountAssetBalanceInUsd].
class AccountAssetBalanceInUsdFamily extends Family<Decimal> {
  /// See also [accountAssetBalanceInUsd].
  const AccountAssetBalanceInUsdFamily();

  /// See also [accountAssetBalanceInUsd].
  AccountAssetBalanceInUsdProvider call(
    AccountAsset accountAsset,
  ) {
    return AccountAssetBalanceInUsdProvider(
      accountAsset,
    );
  }

  @override
  AccountAssetBalanceInUsdProvider getProviderOverride(
    covariant AccountAssetBalanceInUsdProvider provider,
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
  String? get name => r'accountAssetBalanceInUsdProvider';
}

/// See also [accountAssetBalanceInUsd].
class AccountAssetBalanceInUsdProvider extends AutoDisposeProvider<Decimal> {
  /// See also [accountAssetBalanceInUsd].
  AccountAssetBalanceInUsdProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => accountAssetBalanceInUsd(
            ref as AccountAssetBalanceInUsdRef,
            accountAsset,
          ),
          from: accountAssetBalanceInUsdProvider,
          name: r'accountAssetBalanceInUsdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetBalanceInUsdHash,
          dependencies: AccountAssetBalanceInUsdFamily._dependencies,
          allTransitiveDependencies:
              AccountAssetBalanceInUsdFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  AccountAssetBalanceInUsdProvider._internal(
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
    Decimal Function(AccountAssetBalanceInUsdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetBalanceInUsdProvider._internal(
        (ref) => create(ref as AccountAssetBalanceInUsdRef),
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
    return other is AccountAssetBalanceInUsdProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetBalanceInUsdRef on AutoDisposeProviderRef<Decimal> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountAssetBalanceInUsdProviderElement
    extends AutoDisposeProviderElement<Decimal>
    with AccountAssetBalanceInUsdRef {
  _AccountAssetBalanceInUsdProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as AccountAssetBalanceInUsdProvider).accountAsset;
}

String _$accountAssetBalanceStringHash() =>
    r'4b1ed1d93f0361a328c3701c8cb7f4cde24d4284';

/// See also [accountAssetBalanceString].
@ProviderFor(accountAssetBalanceString)
const accountAssetBalanceStringProvider = AccountAssetBalanceStringFamily();

/// See also [accountAssetBalanceString].
class AccountAssetBalanceStringFamily extends Family<String> {
  /// See also [accountAssetBalanceString].
  const AccountAssetBalanceStringFamily();

  /// See also [accountAssetBalanceString].
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

/// See also [accountAssetBalanceString].
class AccountAssetBalanceStringProvider extends AutoDisposeProvider<String> {
  /// See also [accountAssetBalanceString].
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
