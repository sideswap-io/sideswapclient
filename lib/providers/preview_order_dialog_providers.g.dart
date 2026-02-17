// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_order_dialog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PreviewOrderDialogModifiersNotifier)
const previewOrderDialogModifiersProvider =
    PreviewOrderDialogModifiersNotifierProvider._();

final class PreviewOrderDialogModifiersNotifierProvider
    extends
        $NotifierProvider<
          PreviewOrderDialogModifiersNotifier,
          PreviewOrderDialogModifiers
        > {
  const PreviewOrderDialogModifiersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'previewOrderDialogModifiersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$previewOrderDialogModifiersNotifierHash();

  @$internal
  @override
  PreviewOrderDialogModifiersNotifier create() =>
      PreviewOrderDialogModifiersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PreviewOrderDialogModifiers value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreviewOrderDialogModifiers>(value),
    );
  }
}

String _$previewOrderDialogModifiersNotifierHash() =>
    r'e3f0c953eae04f04d70a08609055f75822975826';

abstract class _$PreviewOrderDialogModifiersNotifier
    extends $Notifier<PreviewOrderDialogModifiers> {
  PreviewOrderDialogModifiers build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<PreviewOrderDialogModifiers, PreviewOrderDialogModifiers>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                PreviewOrderDialogModifiers,
                PreviewOrderDialogModifiers
              >,
              PreviewOrderDialogModifiers,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(previewOrderDialogAcceptState)
const previewOrderDialogAcceptStateProvider =
    PreviewOrderDialogAcceptStateProvider._();

final class PreviewOrderDialogAcceptStateProvider
    extends
        $FunctionalProvider<
          PreviewOrderDialogAcceptState,
          PreviewOrderDialogAcceptState,
          PreviewOrderDialogAcceptState
        >
    with $Provider<PreviewOrderDialogAcceptState> {
  const PreviewOrderDialogAcceptStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'previewOrderDialogAcceptStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$previewOrderDialogAcceptStateHash();

  @$internal
  @override
  $ProviderElement<PreviewOrderDialogAcceptState> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PreviewOrderDialogAcceptState create(Ref ref) {
    return previewOrderDialogAcceptState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PreviewOrderDialogAcceptState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PreviewOrderDialogAcceptState>(
        value,
      ),
    );
  }
}

String _$previewOrderDialogAcceptStateHash() =>
    r'a619d8c222aef5dd0c7a8e1651dbf92d574619da';
