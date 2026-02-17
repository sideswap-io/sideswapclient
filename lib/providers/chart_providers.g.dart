// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChartsSubscriptionFlagNotifier)
const chartsSubscriptionFlagProvider =
    ChartsSubscriptionFlagNotifierProvider._();

final class ChartsSubscriptionFlagNotifierProvider
    extends
        $NotifierProvider<
          ChartsSubscriptionFlagNotifier,
          ChartsSubscriptionFlag
        > {
  const ChartsSubscriptionFlagNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chartsSubscriptionFlagProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chartsSubscriptionFlagNotifierHash();

  @$internal
  @override
  ChartsSubscriptionFlagNotifier create() => ChartsSubscriptionFlagNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChartsSubscriptionFlag value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChartsSubscriptionFlag>(value),
    );
  }
}

String _$chartsSubscriptionFlagNotifierHash() =>
    r'0ccb1d482e416133627302206bc90b3e6d9307c0';

abstract class _$ChartsSubscriptionFlagNotifier
    extends $Notifier<ChartsSubscriptionFlag> {
  ChartsSubscriptionFlag build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<ChartsSubscriptionFlag, ChartsSubscriptionFlag>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChartsSubscriptionFlag, ChartsSubscriptionFlag>,
              ChartsSubscriptionFlag,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ChartsNotifier)
const chartsProvider = ChartsNotifierProvider._();

final class ChartsNotifierProvider
    extends $NotifierProvider<ChartsNotifier, Map<AssetPair, List<Candle>>> {
  const ChartsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chartsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chartsNotifierHash();

  @$internal
  @override
  ChartsNotifier create() => ChartsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<AssetPair, List<Candle>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<AssetPair, List<Candle>>>(value),
    );
  }
}

String _$chartsNotifierHash() => r'9ff722d54f5d257121cb41e8f3edad952e8cd21d';

abstract class _$ChartsNotifier
    extends $Notifier<Map<AssetPair, List<Candle>>> {
  Map<AssetPair, List<Candle>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<Map<AssetPair, List<Candle>>, Map<AssetPair, List<Candle>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<AssetPair, List<Candle>>,
                Map<AssetPair, List<Candle>>
              >,
              Map<AssetPair, List<Candle>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(chartsStats)
const chartsStatsProvider = ChartsStatsProvider._();

final class ChartsStatsProvider extends $FunctionalProvider<Stats, Stats, Stats>
    with $Provider<Stats> {
  const ChartsStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chartsStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chartsStatsHash();

  @$internal
  @override
  $ProviderElement<Stats> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Stats create(Ref ref) {
    return chartsStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Stats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Stats>(value),
    );
  }
}

String _$chartsStatsHash() => r'ec6d9f2f7f0ac9e1995fc0d52d6a55b870205d9d';

@ProviderFor(chartStatsRepository)
const chartStatsRepositoryProvider = ChartStatsRepositoryFamily._();

final class ChartStatsRepositoryProvider
    extends
        $FunctionalProvider<
          AbstractChartStatsRepository,
          AbstractChartStatsRepository,
          AbstractChartStatsRepository
        >
    with $Provider<AbstractChartStatsRepository> {
  const ChartStatsRepositoryProvider._({
    required ChartStatsRepositoryFamily super.from,
    required Asset super.argument,
  }) : super(
         retry: null,
         name: r'chartStatsRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chartStatsRepositoryHash();

  @override
  String toString() {
    return r'chartStatsRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AbstractChartStatsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AbstractChartStatsRepository create(Ref ref) {
    final argument = this.argument as Asset;
    return chartStatsRepository(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AbstractChartStatsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AbstractChartStatsRepository>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChartStatsRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chartStatsRepositoryHash() =>
    r'4ae46e2c81eacc410a2c105f8b31e6aacf2d8fe5';

final class ChartStatsRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<AbstractChartStatsRepository, Asset> {
  const ChartStatsRepositoryFamily._()
    : super(
        retry: null,
        name: r'chartStatsRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChartStatsRepositoryProvider call(Asset asset) =>
      ChartStatsRepositoryProvider._(argument: asset, from: this);

  @override
  String toString() => r'chartStatsRepositoryProvider';
}
