// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sideswap_notification_listener.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sideswapNotification)
final sideswapNotificationProvider = SideswapNotificationProvider._();

final class SideswapNotificationProvider
    extends
        $FunctionalProvider<
          SideswapNotificationHelper,
          SideswapNotificationHelper,
          SideswapNotificationHelper
        >
    with $Provider<SideswapNotificationHelper> {
  SideswapNotificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sideswapNotificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sideswapNotificationHash();

  @$internal
  @override
  $ProviderElement<SideswapNotificationHelper> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SideswapNotificationHelper create(Ref ref) {
    return sideswapNotification(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SideswapNotificationHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SideswapNotificationHelper>(value),
    );
  }
}

String _$sideswapNotificationHash() =>
    r'36aea813e015a102a326a30ac685b14c6108f957';
