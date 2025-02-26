// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletHash() => r'8a8da98b44c784b81fcd08503b964e1d09247afd';

/// See also [wallet].
@ProviderFor(wallet)
final walletProvider = Provider<SideswapWallet>.internal(
  wallet,
  name: r'walletProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$walletHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WalletRef = ProviderRef<SideswapWallet>;
String _$syncCompleteStateHash() => r'c9615959bf9e9161e12d57df2cf2e3803f9ad082';

/// See also [SyncCompleteState].
@ProviderFor(SyncCompleteState)
final syncCompleteStateProvider =
    NotifierProvider<SyncCompleteState, bool>.internal(
      SyncCompleteState.new,
      name: r'syncCompleteStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$syncCompleteStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SyncCompleteState = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
