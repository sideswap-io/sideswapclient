// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mobileAvailableAssetsHash() =>
    r'a721cd4a258088d5d9cdd6b0cf92c97035e051af';

/// See also [mobileAvailableAssets].
@ProviderFor(mobileAvailableAssets)
final mobileAvailableAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  mobileAvailableAssets,
  name: r'mobileAvailableAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mobileAvailableAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MobileAvailableAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$accountItemDollarConversionHash() =>
    r'48cac2ddabb71207d55fdc88dcb48452694a7ba8';

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

/// See also [accountItemDollarConversion].
@ProviderFor(accountItemDollarConversion)
const accountItemDollarConversionProvider = AccountItemDollarConversionFamily();

/// See also [accountItemDollarConversion].
class AccountItemDollarConversionFamily
    extends Family<({double amountUsd, String dollarConversion})> {
  /// See also [accountItemDollarConversion].
  const AccountItemDollarConversionFamily();

  /// See also [accountItemDollarConversion].
  AccountItemDollarConversionProvider call(
    AccountAsset accountAsset,
  ) {
    return AccountItemDollarConversionProvider(
      accountAsset,
    );
  }

  @override
  AccountItemDollarConversionProvider getProviderOverride(
    covariant AccountItemDollarConversionProvider provider,
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
  String? get name => r'accountItemDollarConversionProvider';
}

/// See also [accountItemDollarConversion].
class AccountItemDollarConversionProvider
    extends AutoDisposeProvider<({double amountUsd, String dollarConversion})> {
  /// See also [accountItemDollarConversion].
  AccountItemDollarConversionProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => accountItemDollarConversion(
            ref as AccountItemDollarConversionRef,
            accountAsset,
          ),
          from: accountItemDollarConversionProvider,
          name: r'accountItemDollarConversionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountItemDollarConversionHash,
          dependencies: AccountItemDollarConversionFamily._dependencies,
          allTransitiveDependencies:
              AccountItemDollarConversionFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  AccountItemDollarConversionProvider._internal(
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
    ({double amountUsd, String dollarConversion}) Function(
            AccountItemDollarConversionRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountItemDollarConversionProvider._internal(
        (ref) => create(ref as AccountItemDollarConversionRef),
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
  AutoDisposeProviderElement<({double amountUsd, String dollarConversion})>
      createElement() {
    return _AccountItemDollarConversionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountItemDollarConversionProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountItemDollarConversionRef
    on AutoDisposeProviderRef<({double amountUsd, String dollarConversion})> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountItemDollarConversionProviderElement
    extends AutoDisposeProviderElement<
        ({double amountUsd, String dollarConversion})>
    with AccountItemDollarConversionRef {
  _AccountItemDollarConversionProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as AccountItemDollarConversionProvider).accountAsset;
}

String _$accountItemAmountHash() => r'656b057bbff942d8b1c71f826770ada59edf700c';

/// See also [accountItemAmount].
@ProviderFor(accountItemAmount)
const accountItemAmountProvider = AccountItemAmountFamily();

/// See also [accountItemAmount].
class AccountItemAmountFamily extends Family<String?> {
  /// See also [accountItemAmount].
  const AccountItemAmountFamily();

  /// See also [accountItemAmount].
  AccountItemAmountProvider call(
    AccountAsset accountAsset,
  ) {
    return AccountItemAmountProvider(
      accountAsset,
    );
  }

  @override
  AccountItemAmountProvider getProviderOverride(
    covariant AccountItemAmountProvider provider,
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
  String? get name => r'accountItemAmountProvider';
}

/// See also [accountItemAmount].
class AccountItemAmountProvider extends AutoDisposeProvider<String?> {
  /// See also [accountItemAmount].
  AccountItemAmountProvider(
    AccountAsset accountAsset,
  ) : this._internal(
          (ref) => accountItemAmount(
            ref as AccountItemAmountRef,
            accountAsset,
          ),
          from: accountItemAmountProvider,
          name: r'accountItemAmountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountItemAmountHash,
          dependencies: AccountItemAmountFamily._dependencies,
          allTransitiveDependencies:
              AccountItemAmountFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  AccountItemAmountProvider._internal(
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
    String? Function(AccountItemAmountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountItemAmountProvider._internal(
        (ref) => create(ref as AccountItemAmountRef),
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
  AutoDisposeProviderElement<String?> createElement() {
    return _AccountItemAmountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountItemAmountProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountItemAmountRef on AutoDisposeProviderRef<String?> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset get accountAsset;
}

class _AccountItemAmountProviderElement
    extends AutoDisposeProviderElement<String?> with AccountItemAmountRef {
  _AccountItemAmountProviderElement(super.provider);

  @override
  AccountAsset get accountAsset =>
      (origin as AccountItemAmountProvider).accountAsset;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
