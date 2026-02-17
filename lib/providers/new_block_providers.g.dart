// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_block_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NewBlockNotifier)
const newBlockProvider = NewBlockNotifierProvider._();

final class NewBlockNotifierProvider
    extends $NotifierProvider<NewBlockNotifier, int> {
  const NewBlockNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newBlockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newBlockNotifierHash();

  @$internal
  @override
  NewBlockNotifier create() => NewBlockNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$newBlockNotifierHash() => r'4802efb8f1a77061883a30db7c5043a31d088949';

abstract class _$NewBlockNotifier extends $Notifier<int> {
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
