// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MobileAppThemeNotifier)
final mobileAppThemeProvider = MobileAppThemeNotifierProvider._();

final class MobileAppThemeNotifierProvider
    extends $NotifierProvider<MobileAppThemeNotifier, MobileThemeData> {
  MobileAppThemeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mobileAppThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mobileAppThemeNotifierHash();

  @$internal
  @override
  MobileAppThemeNotifier create() => MobileAppThemeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MobileThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MobileThemeData>(value),
    );
  }
}

String _$mobileAppThemeNotifierHash() =>
    r'df834772f44e98ae05c1782ff4dbfd54ca1fc7be';

abstract class _$MobileAppThemeNotifier extends $Notifier<MobileThemeData> {
  MobileThemeData build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MobileThemeData, MobileThemeData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MobileThemeData, MobileThemeData>,
              MobileThemeData,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
