// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_tx_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NewTxNotifier)
const newTxProvider = NewTxNotifierProvider._();

final class NewTxNotifierProvider
    extends $NotifierProvider<NewTxNotifier, int> {
  const NewTxNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newTxProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newTxNotifierHash();

  @$internal
  @override
  NewTxNotifier create() => NewTxNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$newTxNotifierHash() => r'70c5e30fe932dbb48a40ee33a9d2ec1e551a9b7d';

abstract class _$NewTxNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
