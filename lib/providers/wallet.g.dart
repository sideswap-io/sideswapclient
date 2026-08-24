// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncCompleteState)
final syncCompleteStateProvider = SyncCompleteStateProvider._();

final class SyncCompleteStateProvider
    extends $NotifierProvider<SyncCompleteState, bool> {
  SyncCompleteStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncCompleteStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncCompleteStateHash();

  @$internal
  @override
  SyncCompleteState create() => SyncCompleteState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$syncCompleteStateHash() => r'c9615959bf9e9161e12d57df2cf2e3803f9ad082';

abstract class _$SyncCompleteState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(wallet)
final walletProvider = WalletProvider._();

final class WalletProvider
    extends $FunctionalProvider<SideswapWallet, SideswapWallet, SideswapWallet>
    with $Provider<SideswapWallet> {
  WalletProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletHash();

  @$internal
  @override
  $ProviderElement<SideswapWallet> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SideswapWallet create(Ref ref) {
    return wallet(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SideswapWallet value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SideswapWallet>(value),
    );
  }
}

String _$walletHash() => r'8a8da98b44c784b81fcd08503b964e1d09247afd';
