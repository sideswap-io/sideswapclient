// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_wallet_backup_skip_prompt_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SkipForNowNotifier)
const skipForNowProvider = SkipForNowNotifierProvider._();

final class SkipForNowNotifierProvider
    extends $NotifierProvider<SkipForNowNotifier, SkipForNowState> {
  const SkipForNowNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'skipForNowProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$skipForNowNotifierHash();

  @$internal
  @override
  SkipForNowNotifier create() => SkipForNowNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SkipForNowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SkipForNowState>(value),
    );
  }
}

String _$skipForNowNotifierHash() =>
    r'89ccb1269818f11d18a905ded81a2d3d8e26780e';

abstract class _$SkipForNowNotifier extends $Notifier<SkipForNowState> {
  SkipForNowState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SkipForNowState, SkipForNowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SkipForNowState, SkipForNowState>,
              SkipForNowState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
