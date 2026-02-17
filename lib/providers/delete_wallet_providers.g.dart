// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_wallet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LaunchPageDeleteWalletNotifier)
const launchPageDeleteWalletProvider =
    LaunchPageDeleteWalletNotifierProvider._();

final class LaunchPageDeleteWalletNotifierProvider
    extends
        $NotifierProvider<
          LaunchPageDeleteWalletNotifier,
          LaunchPageDeleteWalletState
        > {
  const LaunchPageDeleteWalletNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'launchPageDeleteWalletProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$launchPageDeleteWalletNotifierHash();

  @$internal
  @override
  LaunchPageDeleteWalletNotifier create() => LaunchPageDeleteWalletNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LaunchPageDeleteWalletState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LaunchPageDeleteWalletState>(value),
    );
  }
}

String _$launchPageDeleteWalletNotifierHash() =>
    r'4c32963207aa063d8b8bf7428c331dad7849ee9d';

abstract class _$LaunchPageDeleteWalletNotifier
    extends $Notifier<LaunchPageDeleteWalletState> {
  LaunchPageDeleteWalletState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<LaunchPageDeleteWalletState, LaunchPageDeleteWalletState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                LaunchPageDeleteWalletState,
                LaunchPageDeleteWalletState
              >,
              LaunchPageDeleteWalletState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
