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

String _$accountAssetsUsdBalanceStringHash() =>
    r'8e6280c353693ee45ac900975894a3b4954f8445';

/// See also [accountAssetsUsdBalanceString].
@ProviderFor(accountAssetsUsdBalanceString)
const accountAssetsUsdBalanceStringProvider =
    AccountAssetsUsdBalanceStringFamily();

/// See also [accountAssetsUsdBalanceString].
class AccountAssetsUsdBalanceStringFamily extends Family<String> {
  /// See also [accountAssetsUsdBalanceString].
  const AccountAssetsUsdBalanceStringFamily();

  /// See also [accountAssetsUsdBalanceString].
  AccountAssetsUsdBalanceStringProvider call(
    List<AccountAsset> accountAssets,
  ) {
    return AccountAssetsUsdBalanceStringProvider(
      accountAssets,
    );
  }

  @override
  AccountAssetsUsdBalanceStringProvider getProviderOverride(
    covariant AccountAssetsUsdBalanceStringProvider provider,
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
  String? get name => r'accountAssetsUsdBalanceStringProvider';
}

/// See also [accountAssetsUsdBalanceString].
class AccountAssetsUsdBalanceStringProvider
    extends AutoDisposeProvider<String> {
  /// See also [accountAssetsUsdBalanceString].
  AccountAssetsUsdBalanceStringProvider(
    List<AccountAsset> accountAssets,
  ) : this._internal(
          (ref) => accountAssetsUsdBalanceString(
            ref as AccountAssetsUsdBalanceStringRef,
            accountAssets,
          ),
          from: accountAssetsUsdBalanceStringProvider,
          name: r'accountAssetsUsdBalanceStringProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetsUsdBalanceStringHash,
          dependencies: AccountAssetsUsdBalanceStringFamily._dependencies,
          allTransitiveDependencies:
              AccountAssetsUsdBalanceStringFamily._allTransitiveDependencies,
          accountAssets: accountAssets,
        );

  AccountAssetsUsdBalanceStringProvider._internal(
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
    String Function(AccountAssetsUsdBalanceStringRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetsUsdBalanceStringProvider._internal(
        (ref) => create(ref as AccountAssetsUsdBalanceStringRef),
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
    return _AccountAssetsUsdBalanceStringProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetsUsdBalanceStringProvider &&
        other.accountAssets == accountAssets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAssets.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetsUsdBalanceStringRef on AutoDisposeProviderRef<String> {
  /// The parameter `accountAssets` of this provider.
  List<AccountAsset> get accountAssets;
}

class _AccountAssetsUsdBalanceStringProviderElement
    extends AutoDisposeProviderElement<String>
    with AccountAssetsUsdBalanceStringRef {
  _AccountAssetsUsdBalanceStringProviderElement(super.provider);

  @override
  List<AccountAsset> get accountAssets =>
      (origin as AccountAssetsUsdBalanceStringProvider).accountAssets;
}

String _$accountAssetsUsdBalanceHash() =>
    r'838d95a4851aaacea1aea681e1e4dcaaca66b6ce';

/// See also [accountAssetsUsdBalance].
@ProviderFor(accountAssetsUsdBalance)
const accountAssetsUsdBalanceProvider = AccountAssetsUsdBalanceFamily();

/// See also [accountAssetsUsdBalance].
class AccountAssetsUsdBalanceFamily extends Family<double> {
  /// See also [accountAssetsUsdBalance].
  const AccountAssetsUsdBalanceFamily();

  /// See also [accountAssetsUsdBalance].
  AccountAssetsUsdBalanceProvider call(
    List<AccountAsset> accountAssets,
  ) {
    return AccountAssetsUsdBalanceProvider(
      accountAssets,
    );
  }

  @override
  AccountAssetsUsdBalanceProvider getProviderOverride(
    covariant AccountAssetsUsdBalanceProvider provider,
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
  String? get name => r'accountAssetsUsdBalanceProvider';
}

/// See also [accountAssetsUsdBalance].
class AccountAssetsUsdBalanceProvider extends AutoDisposeProvider<double> {
  /// See also [accountAssetsUsdBalance].
  AccountAssetsUsdBalanceProvider(
    List<AccountAsset> accountAssets,
  ) : this._internal(
          (ref) => accountAssetsUsdBalance(
            ref as AccountAssetsUsdBalanceRef,
            accountAssets,
          ),
          from: accountAssetsUsdBalanceProvider,
          name: r'accountAssetsUsdBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetsUsdBalanceHash,
          dependencies: AccountAssetsUsdBalanceFamily._dependencies,
          allTransitiveDependencies:
              AccountAssetsUsdBalanceFamily._allTransitiveDependencies,
          accountAssets: accountAssets,
        );

  AccountAssetsUsdBalanceProvider._internal(
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
    double Function(AccountAssetsUsdBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetsUsdBalanceProvider._internal(
        (ref) => create(ref as AccountAssetsUsdBalanceRef),
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
  AutoDisposeProviderElement<double> createElement() {
    return _AccountAssetsUsdBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetsUsdBalanceProvider &&
        other.accountAssets == accountAssets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAssets.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetsUsdBalanceRef on AutoDisposeProviderRef<double> {
  /// The parameter `accountAssets` of this provider.
  List<AccountAsset> get accountAssets;
}

class _AccountAssetsUsdBalanceProviderElement
    extends AutoDisposeProviderElement<double> with AccountAssetsUsdBalanceRef {
  _AccountAssetsUsdBalanceProviderElement(super.provider);

  @override
  List<AccountAsset> get accountAssets =>
      (origin as AccountAssetsUsdBalanceProvider).accountAssets;
}

String _$accountAssetsLbtcBalanceHash() =>
    r'56b580f1655959f55167097afc368030ac7cc4a7';

/// See also [accountAssetsLbtcBalance].
@ProviderFor(accountAssetsLbtcBalance)
const accountAssetsLbtcBalanceProvider = AccountAssetsLbtcBalanceFamily();

/// See also [accountAssetsLbtcBalance].
class AccountAssetsLbtcBalanceFamily extends Family<String> {
  /// See also [accountAssetsLbtcBalance].
  const AccountAssetsLbtcBalanceFamily();

  /// See also [accountAssetsLbtcBalance].
  AccountAssetsLbtcBalanceProvider call(
    List<AccountAsset> accountAssets,
  ) {
    return AccountAssetsLbtcBalanceProvider(
      accountAssets,
    );
  }

  @override
  AccountAssetsLbtcBalanceProvider getProviderOverride(
    covariant AccountAssetsLbtcBalanceProvider provider,
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
  String? get name => r'accountAssetsLbtcBalanceProvider';
}

/// See also [accountAssetsLbtcBalance].
class AccountAssetsLbtcBalanceProvider extends AutoDisposeProvider<String> {
  /// See also [accountAssetsLbtcBalance].
  AccountAssetsLbtcBalanceProvider(
    List<AccountAsset> accountAssets,
  ) : this._internal(
          (ref) => accountAssetsLbtcBalance(
            ref as AccountAssetsLbtcBalanceRef,
            accountAssets,
          ),
          from: accountAssetsLbtcBalanceProvider,
          name: r'accountAssetsLbtcBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetsLbtcBalanceHash,
          dependencies: AccountAssetsLbtcBalanceFamily._dependencies,
          allTransitiveDependencies:
              AccountAssetsLbtcBalanceFamily._allTransitiveDependencies,
          accountAssets: accountAssets,
        );

  AccountAssetsLbtcBalanceProvider._internal(
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
    String Function(AccountAssetsLbtcBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetsLbtcBalanceProvider._internal(
        (ref) => create(ref as AccountAssetsLbtcBalanceRef),
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
    return _AccountAssetsLbtcBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetsLbtcBalanceProvider &&
        other.accountAssets == accountAssets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAssets.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetsLbtcBalanceRef on AutoDisposeProviderRef<String> {
  /// The parameter `accountAssets` of this provider.
  List<AccountAsset> get accountAssets;
}

class _AccountAssetsLbtcBalanceProviderElement
    extends AutoDisposeProviderElement<String>
    with AccountAssetsLbtcBalanceRef {
  _AccountAssetsLbtcBalanceProviderElement(super.provider);

  @override
  List<AccountAsset> get accountAssets =>
      (origin as AccountAssetsLbtcBalanceProvider).accountAssets;
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
