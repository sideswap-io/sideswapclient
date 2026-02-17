// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inputs_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InputsWalletFlagNotifier)
const inputsWalletFlagProvider = InputsWalletFlagNotifierProvider._();

final class InputsWalletFlagNotifierProvider
    extends $NotifierProvider<InputsWalletFlagNotifier, InputsWalletFlagType> {
  const InputsWalletFlagNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inputsWalletFlagProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inputsWalletFlagNotifierHash();

  @$internal
  @override
  InputsWalletFlagNotifier create() => InputsWalletFlagNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InputsWalletFlagType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InputsWalletFlagType>(value),
    );
  }
}

String _$inputsWalletFlagNotifierHash() =>
    r'0712605ae9625f625a30aa973f0084918f480a57';

abstract class _$InputsWalletFlagNotifier
    extends $Notifier<InputsWalletFlagType> {
  InputsWalletFlagType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<InputsWalletFlagType, InputsWalletFlagType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InputsWalletFlagType, InputsWalletFlagType>,
              InputsWalletFlagType,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(InputsNotifier)
const inputsProvider = InputsNotifierProvider._();

final class InputsNotifierProvider
    extends $NotifierProvider<InputsNotifier, List<InputsItem>> {
  const InputsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inputsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inputsNotifierHash();

  @$internal
  @override
  InputsNotifier create() => InputsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<InputsItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<InputsItem>>(value),
    );
  }
}

String _$inputsNotifierHash() => r'cccd6a3a1466c5b766c0a19e18c73cd37f6e9927';

abstract class _$InputsNotifier extends $Notifier<List<InputsItem>> {
  List<InputsItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<InputsItem>, List<InputsItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<InputsItem>, List<InputsItem>>,
              List<InputsItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SelectedInputsNotifier)
const selectedInputsProvider = SelectedInputsNotifierProvider._();

final class SelectedInputsNotifierProvider
    extends $NotifierProvider<SelectedInputsNotifier, List<InputsTxItem>> {
  const SelectedInputsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedInputsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedInputsNotifierHash();

  @$internal
  @override
  SelectedInputsNotifier create() => SelectedInputsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<InputsTxItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<InputsTxItem>>(value),
    );
  }
}

String _$selectedInputsNotifierHash() =>
    r'b8c62ef23047af4fe773fc30839b0f87e6cb4f9b';

abstract class _$SelectedInputsNotifier extends $Notifier<List<InputsTxItem>> {
  List<InputsTxItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<InputsTxItem>, List<InputsTxItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<InputsTxItem>, List<InputsTxItem>>,
              List<InputsTxItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
