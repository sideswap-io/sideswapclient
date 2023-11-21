// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allAccountAssetsHash() => r'7dd189c33f5037e5d1b4d230ff3680dc0db24e32';

/// See also [allAccountAssets].
@ProviderFor(allAccountAssets)
final allAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  allAccountAssets,
  name: r'allAccountAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allAccountAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$allVisibleAccountAssetsHash() =>
    r'064bfee021e7a57ce754508ebb91a12333986fa3';

/// See also [allVisibleAccountAssets].
@ProviderFor(allVisibleAccountAssets)
final allVisibleAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  allVisibleAccountAssets,
  name: r'allVisibleAccountAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allVisibleAccountAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllVisibleAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$regularAccountAssetsHash() =>
    r'5f55247493042eeef0c091e3fe5b0893e1346a53';

/// See also [regularAccountAssets].
@ProviderFor(regularAccountAssets)
final regularAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  regularAccountAssets,
  name: r'regularAccountAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$regularAccountAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RegularAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$ampAccountAssetsHash() => r'c44660f694f98b0b99780822421919b2e6f7b830';

/// See also [ampAccountAssets].
@ProviderFor(ampAccountAssets)
final ampAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  ampAccountAssets,
  name: r'ampAccountAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ampAccountAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AmpAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$defaultAccountsStateHash() =>
    r'0a26ce887126dd07a2a2525def2d0665757d8c95';

/// See also [DefaultAccountsState].
@ProviderFor(DefaultAccountsState)
final defaultAccountsStateProvider =
    NotifierProvider<DefaultAccountsState, Set<AccountAsset>>.internal(
  DefaultAccountsState.new,
  name: r'defaultAccountsStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$defaultAccountsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DefaultAccountsState = Notifier<Set<AccountAsset>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
