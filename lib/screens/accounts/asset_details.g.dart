// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_details.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(heightPercentController)
const heightPercentControllerProvider = HeightPercentControllerProvider._();

final class HeightPercentControllerProvider
    extends
        $FunctionalProvider<
          StreamController<double>,
          StreamController<double>,
          StreamController<double>
        >
    with $Provider<StreamController<double>> {
  const HeightPercentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'heightPercentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$heightPercentControllerHash();

  @$internal
  @override
  $ProviderElement<StreamController<double>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StreamController<double> create(Ref ref) {
    return heightPercentController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreamController<double> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreamController<double>>(value),
    );
  }
}

String _$heightPercentControllerHash() =>
    r'a20cd03b28517e880be9d7dd6b2567f1b66aeb7f';

@ProviderFor(PanelPositionNotifier)
const panelPositionProvider = PanelPositionNotifierProvider._();

final class PanelPositionNotifierProvider
    extends $NotifierProvider<PanelPositionNotifier, double> {
  const PanelPositionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'panelPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$panelPositionNotifierHash();

  @$internal
  @override
  PanelPositionNotifier create() => PanelPositionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$panelPositionNotifierHash() =>
    r'0acbf60193d92e709e54c716bcceea16c77f3a2e';

abstract class _$PanelPositionNotifier extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
