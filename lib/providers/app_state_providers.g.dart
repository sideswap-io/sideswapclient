// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentAppLifecycle)
final currentAppLifecycleProvider = CurrentAppLifecycleProvider._();

final class CurrentAppLifecycleProvider
    extends $NotifierProvider<CurrentAppLifecycle, Option<AppLifecycleState>> {
  CurrentAppLifecycleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAppLifecycleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAppLifecycleHash();

  @$internal
  @override
  CurrentAppLifecycle create() => CurrentAppLifecycle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<AppLifecycleState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<AppLifecycleState>>(value),
    );
  }
}

String _$currentAppLifecycleHash() =>
    r'fd4374fe93a39af33ffb394042ff22e91d45044c';

abstract class _$CurrentAppLifecycle
    extends $Notifier<Option<AppLifecycleState>> {
  Option<AppLifecycleState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<Option<AppLifecycleState>, Option<AppLifecycleState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<AppLifecycleState>, Option<AppLifecycleState>>,
              Option<AppLifecycleState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
