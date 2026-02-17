// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DefaultAccountsState)
const defaultAccountsStateProvider = DefaultAccountsStateProvider._();

final class DefaultAccountsStateProvider
    extends $NotifierProvider<DefaultAccountsState, Set<AccountAsset>> {
  const DefaultAccountsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultAccountsStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultAccountsStateHash();

  @$internal
  @override
  DefaultAccountsState create() => DefaultAccountsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<AccountAsset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<AccountAsset>>(value),
    );
  }
}

String _$defaultAccountsStateHash() =>
    r'0a26ce887126dd07a2a2525def2d0665757d8c95';

abstract class _$DefaultAccountsState extends $Notifier<Set<AccountAsset>> {
  Set<AccountAsset> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<AccountAsset>, Set<AccountAsset>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<AccountAsset>, Set<AccountAsset>>,
              Set<AccountAsset>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(predefinedAccountAssets)
const predefinedAccountAssetsProvider = PredefinedAccountAssetsProvider._();

final class PredefinedAccountAssetsProvider
    extends
        $FunctionalProvider<
          List<AccountAsset>,
          List<AccountAsset>,
          List<AccountAsset>
        >
    with $Provider<List<AccountAsset>> {
  const PredefinedAccountAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'predefinedAccountAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$predefinedAccountAssetsHash();

  @$internal
  @override
  $ProviderElement<List<AccountAsset>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<AccountAsset> create(Ref ref) {
    return predefinedAccountAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AccountAsset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AccountAsset>>(value),
    );
  }
}

String _$predefinedAccountAssetsHash() =>
    r'7052a7e0b4cd517e5d97be91c20d62fc4e8fd175';

@ProviderFor(predefinedAssets)
const predefinedAssetsProvider = PredefinedAssetsProvider._();

final class PredefinedAssetsProvider
    extends
        $FunctionalProvider<Iterable<Asset>, Iterable<Asset>, Iterable<Asset>>
    with $Provider<Iterable<Asset>> {
  const PredefinedAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'predefinedAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$predefinedAssetsHash();

  @$internal
  @override
  $ProviderElement<Iterable<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Iterable<Asset> create(Ref ref) {
    return predefinedAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<Asset>>(value),
    );
  }
}

String _$predefinedAssetsHash() => r'f1609f95d2335219b2d96671e17ded0f3f48bfcb';

/// Needed by ui which want to display limited list of assets - ex. home page wallet
///

@ProviderFor(allAlwaysShowAccountAssets)
const allAlwaysShowAccountAssetsProvider =
    AllAlwaysShowAccountAssetsProvider._();

/// Needed by ui which want to display limited list of assets - ex. home page wallet
///

final class AllAlwaysShowAccountAssetsProvider
    extends
        $FunctionalProvider<
          List<AccountAsset>,
          List<AccountAsset>,
          List<AccountAsset>
        >
    with $Provider<List<AccountAsset>> {
  /// Needed by ui which want to display limited list of assets - ex. home page wallet
  ///
  const AllAlwaysShowAccountAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allAlwaysShowAccountAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allAlwaysShowAccountAssetsHash();

  @$internal
  @override
  $ProviderElement<List<AccountAsset>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<AccountAsset> create(Ref ref) {
    return allAlwaysShowAccountAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AccountAsset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AccountAsset>>(value),
    );
  }
}

String _$allAlwaysShowAccountAssetsHash() =>
    r'dd8174c09e4645b2e96a191269cdc76bde94451a';

@ProviderFor(allAlwaysShowAssets)
const allAlwaysShowAssetsProvider = AllAlwaysShowAssetsProvider._();

final class AllAlwaysShowAssetsProvider
    extends
        $FunctionalProvider<Iterable<Asset>, Iterable<Asset>, Iterable<Asset>>
    with $Provider<Iterable<Asset>> {
  const AllAlwaysShowAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allAlwaysShowAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allAlwaysShowAssetsHash();

  @$internal
  @override
  $ProviderElement<Iterable<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Iterable<Asset> create(Ref ref) {
    return allAlwaysShowAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<Asset>>(value),
    );
  }
}

String _$allAlwaysShowAssetsHash() =>
    r'5903d2990b81b2b9372404ae1781992962918097';

@ProviderFor(allVisibleAccountAssets)
const allVisibleAccountAssetsProvider = AllVisibleAccountAssetsProvider._();

final class AllVisibleAccountAssetsProvider
    extends
        $FunctionalProvider<
          List<AccountAsset>,
          List<AccountAsset>,
          List<AccountAsset>
        >
    with $Provider<List<AccountAsset>> {
  const AllVisibleAccountAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allVisibleAccountAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allVisibleAccountAssetsHash();

  @$internal
  @override
  $ProviderElement<List<AccountAsset>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<AccountAsset> create(Ref ref) {
    return allVisibleAccountAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AccountAsset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AccountAsset>>(value),
    );
  }
}

String _$allVisibleAccountAssetsHash() =>
    r'9dd4e2577f0fdb41e7782685770916831d094e70';

@ProviderFor(regularVisibleAccountAssets)
const regularVisibleAccountAssetsProvider =
    RegularVisibleAccountAssetsProvider._();

final class RegularVisibleAccountAssetsProvider
    extends
        $FunctionalProvider<
          List<AccountAsset>,
          List<AccountAsset>,
          List<AccountAsset>
        >
    with $Provider<List<AccountAsset>> {
  const RegularVisibleAccountAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'regularVisibleAccountAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$regularVisibleAccountAssetsHash();

  @$internal
  @override
  $ProviderElement<List<AccountAsset>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<AccountAsset> create(Ref ref) {
    return regularVisibleAccountAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AccountAsset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AccountAsset>>(value),
    );
  }
}

String _$regularVisibleAccountAssetsHash() =>
    r'89a34fda5d6e7d5557246980d4e0afd8c1b931c5';

@ProviderFor(ampVisibleAccountAssets)
const ampVisibleAccountAssetsProvider = AmpVisibleAccountAssetsProvider._();

final class AmpVisibleAccountAssetsProvider
    extends
        $FunctionalProvider<
          List<AccountAsset>,
          List<AccountAsset>,
          List<AccountAsset>
        >
    with $Provider<List<AccountAsset>> {
  const AmpVisibleAccountAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ampVisibleAccountAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ampVisibleAccountAssetsHash();

  @$internal
  @override
  $ProviderElement<List<AccountAsset>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<AccountAsset> create(Ref ref) {
    return ampVisibleAccountAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AccountAsset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AccountAsset>>(value),
    );
  }
}

String _$ampVisibleAccountAssetsHash() =>
    r'5b3811013db0325ab216fdbec125cf7e6ce995b6';

/// Needed by ui parts which want to search assetid over all assets - ex. market
///

@ProviderFor(allAccountAssets)
const allAccountAssetsProvider = AllAccountAssetsProvider._();

/// Needed by ui parts which want to search assetid over all assets - ex. market
///

final class AllAccountAssetsProvider
    extends
        $FunctionalProvider<
          List<AccountAsset>,
          List<AccountAsset>,
          List<AccountAsset>
        >
    with $Provider<List<AccountAsset>> {
  /// Needed by ui parts which want to search assetid over all assets - ex. market
  ///
  const AllAccountAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allAccountAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allAccountAssetsHash();

  @$internal
  @override
  $ProviderElement<List<AccountAsset>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<AccountAsset> create(Ref ref) {
    return allAccountAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AccountAsset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AccountAsset>>(value),
    );
  }
}

String _$allAccountAssetsHash() => r'9e8cac327c050654d1ea7f4c20f73f2da7f4b014';

@ProviderFor(regularAccountAssets)
const regularAccountAssetsProvider = RegularAccountAssetsProvider._();

final class RegularAccountAssetsProvider
    extends
        $FunctionalProvider<
          List<AccountAsset>,
          List<AccountAsset>,
          List<AccountAsset>
        >
    with $Provider<List<AccountAsset>> {
  const RegularAccountAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'regularAccountAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$regularAccountAssetsHash();

  @$internal
  @override
  $ProviderElement<List<AccountAsset>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<AccountAsset> create(Ref ref) {
    return regularAccountAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AccountAsset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AccountAsset>>(value),
    );
  }
}

String _$regularAccountAssetsHash() =>
    r'7d2e3c2430b79e1a3d911ce2997e55e138a81acf';

@ProviderFor(ampAccountAssets)
const ampAccountAssetsProvider = AmpAccountAssetsProvider._();

final class AmpAccountAssetsProvider
    extends
        $FunctionalProvider<
          List<AccountAsset>,
          List<AccountAsset>,
          List<AccountAsset>
        >
    with $Provider<List<AccountAsset>> {
  const AmpAccountAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ampAccountAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ampAccountAssetsHash();

  @$internal
  @override
  $ProviderElement<List<AccountAsset>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<AccountAsset> create(Ref ref) {
    return ampAccountAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AccountAsset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AccountAsset>>(value),
    );
  }
}

String _$ampAccountAssetsHash() => r'c94a5ac43a8b4d7e91c394a65bb6099d18eea286';

@ProviderFor(marketTypeForAccountAsset)
const marketTypeForAccountAssetProvider = MarketTypeForAccountAssetFamily._();

final class MarketTypeForAccountAssetProvider
    extends $FunctionalProvider<MarketType_, MarketType_, MarketType_>
    with $Provider<MarketType_> {
  const MarketTypeForAccountAssetProvider._({
    required MarketTypeForAccountAssetFamily super.from,
    required AccountAsset? super.argument,
  }) : super(
         retry: null,
         name: r'marketTypeForAccountAssetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$marketTypeForAccountAssetHash();

  @override
  String toString() {
    return r'marketTypeForAccountAssetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MarketType_> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MarketType_ create(Ref ref) {
    final argument = this.argument as AccountAsset?;
    return marketTypeForAccountAsset(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarketType_ value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarketType_>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MarketTypeForAccountAssetProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$marketTypeForAccountAssetHash() =>
    r'cbecb3f453d7ba82de1cd75ace20092e85430b16';

final class MarketTypeForAccountAssetFamily extends $Family
    with $FunctionalFamilyOverride<MarketType_, AccountAsset?> {
  const MarketTypeForAccountAssetFamily._()
    : super(
        retry: null,
        name: r'marketTypeForAccountAssetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MarketTypeForAccountAssetProvider call(AccountAsset? accountAsset) =>
      MarketTypeForAccountAssetProvider._(argument: accountAsset, from: this);

  @override
  String toString() => r'marketTypeForAccountAssetProvider';
}

@ProviderFor(accountAssetFromAsset)
const accountAssetFromAssetProvider = AccountAssetFromAssetFamily._();

final class AccountAssetFromAssetProvider
    extends $FunctionalProvider<AccountAsset, AccountAsset, AccountAsset>
    with $Provider<AccountAsset> {
  const AccountAssetFromAssetProvider._({
    required AccountAssetFromAssetFamily super.from,
    required Asset? super.argument,
  }) : super(
         retry: null,
         name: r'accountAssetFromAssetProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$accountAssetFromAssetHash();

  @override
  String toString() {
    return r'accountAssetFromAssetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AccountAsset> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccountAsset create(Ref ref) {
    final argument = this.argument as Asset?;
    return accountAssetFromAsset(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountAsset value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountAsset>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetFromAssetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$accountAssetFromAssetHash() =>
    r'0f9b4949cd07437c4d1ca07b13c827065c307ed7';

final class AccountAssetFromAssetFamily extends $Family
    with $FunctionalFamilyOverride<AccountAsset, Asset?> {
  const AccountAssetFromAssetFamily._()
    : super(
        retry: null,
        name: r'accountAssetFromAssetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AccountAssetFromAssetProvider call(Asset? asset) =>
      AccountAssetFromAssetProvider._(argument: asset, from: this);

  @override
  String toString() => r'accountAssetFromAssetProvider';
}

/// Show assets which are:
/// 1. predefined
/// 2. have balance
/// 3. have flag always show

@ProviderFor(allVisibleAssets)
const allVisibleAssetsProvider = AllVisibleAssetsProvider._();

/// Show assets which are:
/// 1. predefined
/// 2. have balance
/// 3. have flag always show

final class AllVisibleAssetsProvider
    extends
        $FunctionalProvider<Iterable<Asset>, Iterable<Asset>, Iterable<Asset>>
    with $Provider<Iterable<Asset>> {
  /// Show assets which are:
  /// 1. predefined
  /// 2. have balance
  /// 3. have flag always show
  const AllVisibleAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allVisibleAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allVisibleAssetsHash();

  @$internal
  @override
  $ProviderElement<Iterable<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Iterable<Asset> create(Ref ref) {
    return allVisibleAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<Asset>>(value),
    );
  }
}

String _$allVisibleAssetsHash() => r'f784fdd88dc18c251acce20aefb9c0d00df3bdf5';
