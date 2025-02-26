// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chartsStatsHash() => r'7e934ec4cd22eb603d78fea80e9c2a8c146304a2';

/// See also [chartsStats].
@ProviderFor(chartsStats)
final chartsStatsProvider = AutoDisposeProvider<Stats>.internal(
  chartsStats,
  name: r'chartsStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chartsStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChartsStatsRef = AutoDisposeProviderRef<Stats>;
String _$chartStatsRepositoryHash() =>
    r'991325c36769452e4afacc11f0891bb64f96391a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [chartStatsRepository].
@ProviderFor(chartStatsRepository)
const chartStatsRepositoryProvider = ChartStatsRepositoryFamily();

/// See also [chartStatsRepository].
class ChartStatsRepositoryFamily extends Family<AbstractChartStatsRepository> {
  /// See also [chartStatsRepository].
  const ChartStatsRepositoryFamily();

  /// See also [chartStatsRepository].
  ChartStatsRepositoryProvider call(Asset asset) {
    return ChartStatsRepositoryProvider(asset);
  }

  @override
  ChartStatsRepositoryProvider getProviderOverride(
    covariant ChartStatsRepositoryProvider provider,
  ) {
    return call(provider.asset);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chartStatsRepositoryProvider';
}

/// See also [chartStatsRepository].
class ChartStatsRepositoryProvider
    extends AutoDisposeProvider<AbstractChartStatsRepository> {
  /// See also [chartStatsRepository].
  ChartStatsRepositoryProvider(Asset asset)
    : this._internal(
        (ref) => chartStatsRepository(ref as ChartStatsRepositoryRef, asset),
        from: chartStatsRepositoryProvider,
        name: r'chartStatsRepositoryProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$chartStatsRepositoryHash,
        dependencies: ChartStatsRepositoryFamily._dependencies,
        allTransitiveDependencies:
            ChartStatsRepositoryFamily._allTransitiveDependencies,
        asset: asset,
      );

  ChartStatsRepositoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.asset,
  }) : super.internal();

  final Asset asset;

  @override
  Override overrideWith(
    AbstractChartStatsRepository Function(ChartStatsRepositoryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChartStatsRepositoryProvider._internal(
        (ref) => create(ref as ChartStatsRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        asset: asset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<AbstractChartStatsRepository> createElement() {
    return _ChartStatsRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChartStatsRepositoryProvider && other.asset == asset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, asset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChartStatsRepositoryRef
    on AutoDisposeProviderRef<AbstractChartStatsRepository> {
  /// The parameter `asset` of this provider.
  Asset get asset;
}

class _ChartStatsRepositoryProviderElement
    extends AutoDisposeProviderElement<AbstractChartStatsRepository>
    with ChartStatsRepositoryRef {
  _ChartStatsRepositoryProviderElement(super.provider);

  @override
  Asset get asset => (origin as ChartStatsRepositoryProvider).asset;
}

String _$chartsSubscriptionFlagNotifierHash() =>
    r'0ccb1d482e416133627302206bc90b3e6d9307c0';

/// See also [ChartsSubscriptionFlagNotifier].
@ProviderFor(ChartsSubscriptionFlagNotifier)
final chartsSubscriptionFlagNotifierProvider = AutoDisposeNotifierProvider<
  ChartsSubscriptionFlagNotifier,
  ChartsSubscriptionFlag
>.internal(
  ChartsSubscriptionFlagNotifier.new,
  name: r'chartsSubscriptionFlagNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chartsSubscriptionFlagNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChartsSubscriptionFlagNotifier =
    AutoDisposeNotifier<ChartsSubscriptionFlag>;
String _$chartsNotifierHash() => r'6f8201489a8b2b54f4f249f46575dbe4de1ba0c7';

/// See also [ChartsNotifier].
@ProviderFor(ChartsNotifier)
final chartsNotifierProvider = AutoDisposeNotifierProvider<
  ChartsNotifier,
  Map<AssetPair, List<Candle>>
>.internal(
  ChartsNotifier.new,
  name: r'chartsNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chartsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChartsNotifier = AutoDisposeNotifier<Map<AssetPair, List<Candle>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
