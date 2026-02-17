// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_releases_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppReleasesStateNotifier)
const appReleasesStateProvider = AppReleasesStateNotifierProvider._();

final class AppReleasesStateNotifierProvider
    extends
        $AsyncNotifierProvider<
          AppReleasesStateNotifier,
          AppReleasesModelState
        > {
  const AppReleasesStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appReleasesStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appReleasesStateNotifierHash();

  @$internal
  @override
  AppReleasesStateNotifier create() => AppReleasesStateNotifier();
}

String _$appReleasesStateNotifierHash() =>
    r'82854753122e9d0eaf400aa5b949fcb744fb8eb8';

abstract class _$AppReleasesStateNotifier
    extends $AsyncNotifier<AppReleasesModelState> {
  FutureOr<AppReleasesModelState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<AppReleasesModelState>, AppReleasesModelState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<AppReleasesModelState>,
                AppReleasesModelState
              >,
              AsyncValue<AppReleasesModelState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(showNewReleaseFuture)
const showNewReleaseFutureProvider = ShowNewReleaseFutureProvider._();

final class ShowNewReleaseFutureProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const ShowNewReleaseFutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showNewReleaseFutureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showNewReleaseFutureHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return showNewReleaseFuture(ref);
  }
}

String _$showNewReleaseFutureHash() =>
    r'd36ecaf4161943bf8d3752e0546d90d087ec85b4';
