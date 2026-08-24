// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_type_buttons.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedMarketTypeButtonNotifier)
final selectedMarketTypeButtonProvider =
    SelectedMarketTypeButtonNotifierProvider._();

final class SelectedMarketTypeButtonNotifierProvider
    extends
        $NotifierProvider<
          SelectedMarketTypeButtonNotifier,
          SelectedMarketTypeButtonEnum
        > {
  SelectedMarketTypeButtonNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedMarketTypeButtonProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedMarketTypeButtonNotifierHash();

  @$internal
  @override
  SelectedMarketTypeButtonNotifier create() =>
      SelectedMarketTypeButtonNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectedMarketTypeButtonEnum value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectedMarketTypeButtonEnum>(value),
    );
  }
}

String _$selectedMarketTypeButtonNotifierHash() =>
    r'5c352d34f0d7c1186060215e3bcd969e8e606f74';

abstract class _$SelectedMarketTypeButtonNotifier
    extends $Notifier<SelectedMarketTypeButtonEnum> {
  SelectedMarketTypeButtonEnum build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<SelectedMarketTypeButtonEnum, SelectedMarketTypeButtonEnum>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                SelectedMarketTypeButtonEnum,
                SelectedMarketTypeButtonEnum
              >,
              SelectedMarketTypeButtonEnum,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
