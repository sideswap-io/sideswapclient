// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_state_args_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UiStateArgsNotifier)
const uiStateArgsProvider = UiStateArgsNotifierProvider._();

final class UiStateArgsNotifierProvider
    extends $NotifierProvider<UiStateArgsNotifier, WalletMainArguments> {
  const UiStateArgsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uiStateArgsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uiStateArgsNotifierHash();

  @$internal
  @override
  UiStateArgsNotifier create() => UiStateArgsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalletMainArguments value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalletMainArguments>(value),
    );
  }
}

String _$uiStateArgsNotifierHash() =>
    r'942aa310a047c6262afa94d25942b0b1ed575c6b';

abstract class _$UiStateArgsNotifier extends $Notifier<WalletMainArguments> {
  WalletMainArguments build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WalletMainArguments, WalletMainArguments>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WalletMainArguments, WalletMainArguments>,
              WalletMainArguments,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
