// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_descriptors_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the wallet descriptors delivered on login. `null` = **not loaded**.
///
/// Written only from the login-success handler (`_handleLogin` in
/// `wallet.dart`) and invalidated on app-state cleanup. A payload with either
/// descriptor empty actively clears any previously held value back to `null`
/// (ADR-0002, decisions 1 and 6).

@ProviderFor(WalletDescriptorsNotifier)
final walletDescriptorsProvider = WalletDescriptorsNotifierProvider._();

/// Holds the wallet descriptors delivered on login. `null` = **not loaded**.
///
/// Written only from the login-success handler (`_handleLogin` in
/// `wallet.dart`) and invalidated on app-state cleanup. A payload with either
/// descriptor empty actively clears any previously held value back to `null`
/// (ADR-0002, decisions 1 and 6).
final class WalletDescriptorsNotifierProvider
    extends $NotifierProvider<WalletDescriptorsNotifier, WalletDescriptors?> {
  /// Holds the wallet descriptors delivered on login. `null` = **not loaded**.
  ///
  /// Written only from the login-success handler (`_handleLogin` in
  /// `wallet.dart`) and invalidated on app-state cleanup. A payload with either
  /// descriptor empty actively clears any previously held value back to `null`
  /// (ADR-0002, decisions 1 and 6).
  WalletDescriptorsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletDescriptorsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletDescriptorsNotifierHash();

  @$internal
  @override
  WalletDescriptorsNotifier create() => WalletDescriptorsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalletDescriptors? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalletDescriptors?>(value),
    );
  }
}

String _$walletDescriptorsNotifierHash() =>
    r'c9f7c8e71a4fae13c17786addb6139155b729a88';

/// Holds the wallet descriptors delivered on login. `null` = **not loaded**.
///
/// Written only from the login-success handler (`_handleLogin` in
/// `wallet.dart`) and invalidated on app-state cleanup. A payload with either
/// descriptor empty actively clears any previously held value back to `null`
/// (ADR-0002, decisions 1 and 6).

abstract class _$WalletDescriptorsNotifier
    extends $Notifier<WalletDescriptors?> {
  WalletDescriptors? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WalletDescriptors?, WalletDescriptors?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WalletDescriptors?, WalletDescriptors?>,
              WalletDescriptors?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
