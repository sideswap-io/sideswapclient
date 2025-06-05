// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_releases_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$showNewReleaseFutureHash() =>
    r'9f5f5c328bb3e59e319286f3e5489b6c8464df77';

/// See also [showNewReleaseFuture].
@ProviderFor(showNewReleaseFuture)
final showNewReleaseFutureProvider = AutoDisposeFutureProvider<bool>.internal(
  showNewReleaseFuture,
  name: r'showNewReleaseFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$showNewReleaseFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShowNewReleaseFutureRef = AutoDisposeFutureProviderRef<bool>;
String _$appReleasesStateNotifierHash() =>
    r'82854753122e9d0eaf400aa5b949fcb744fb8eb8';

/// See also [AppReleasesStateNotifier].
@ProviderFor(AppReleasesStateNotifier)
final appReleasesStateNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      AppReleasesStateNotifier,
      AppReleasesModelState
    >.internal(
      AppReleasesStateNotifier.new,
      name: r'appReleasesStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appReleasesStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppReleasesStateNotifier =
    AutoDisposeAsyncNotifier<AppReleasesModelState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
