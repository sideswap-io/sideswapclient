// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mobileRoutePage)
const mobileRoutePageProvider = MobileRoutePageProvider._();

final class MobileRoutePageProvider
    extends
        $FunctionalProvider<MobileRoutePage, MobileRoutePage, MobileRoutePage>
    with $Provider<MobileRoutePage> {
  const MobileRoutePageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mobileRoutePageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mobileRoutePageHash();

  @$internal
  @override
  $ProviderElement<MobileRoutePage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MobileRoutePage create(Ref ref) {
    return mobileRoutePage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MobileRoutePage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MobileRoutePage>(value),
    );
  }
}

String _$mobileRoutePageHash() => r'9b178081c2e642b0629218bf1491b2c087ecba28';

@ProviderFor(desktopRoutePage)
const desktopRoutePageProvider = DesktopRoutePageProvider._();

final class DesktopRoutePageProvider
    extends
        $FunctionalProvider<
          DesktopRoutePage,
          DesktopRoutePage,
          DesktopRoutePage
        >
    with $Provider<DesktopRoutePage> {
  const DesktopRoutePageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'desktopRoutePageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$desktopRoutePageHash();

  @$internal
  @override
  $ProviderElement<DesktopRoutePage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DesktopRoutePage create(Ref ref) {
    return desktopRoutePage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DesktopRoutePage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DesktopRoutePage>(value),
    );
  }
}

String _$desktopRoutePageHash() => r'1671fddb96cfb0d180854ed08d2bf93af7bd6b67';
