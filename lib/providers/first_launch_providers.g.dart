// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'first_launch_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FirstLaunchStateNotifier)
const firstLaunchStateProvider = FirstLaunchStateNotifierProvider._();

final class FirstLaunchStateNotifierProvider
    extends $NotifierProvider<FirstLaunchStateNotifier, FirstLaunchStateType> {
  const FirstLaunchStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstLaunchStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstLaunchStateNotifierHash();

  @$internal
  @override
  FirstLaunchStateNotifier create() => FirstLaunchStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirstLaunchStateType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirstLaunchStateType>(value),
    );
  }
}

String _$firstLaunchStateNotifierHash() =>
    r'b8a6b148b5595f56c0a5b59e9c7fe2abfc69fe04';

abstract class _$FirstLaunchStateNotifier
    extends $Notifier<FirstLaunchStateType> {
  FirstLaunchStateType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FirstLaunchStateType, FirstLaunchStateType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FirstLaunchStateType, FirstLaunchStateType>,
              FirstLaunchStateType,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
