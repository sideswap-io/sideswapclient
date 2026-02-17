// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(marketTypeName)
const marketTypeNameProvider = MarketTypeNameFamily._();

final class MarketTypeNameProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const MarketTypeNameProvider._({
    required MarketTypeNameFamily super.from,
    required MarketType_ super.argument,
  }) : super(
         retry: null,
         name: r'marketTypeNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$marketTypeNameHash();

  @override
  String toString() {
    return r'marketTypeNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as MarketType_;
    return marketTypeName(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MarketTypeNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$marketTypeNameHash() => r'e217a3b36b49ccf77552080f23079cbad61eed5f';

final class MarketTypeNameFamily extends $Family
    with $FunctionalFamilyOverride<String, MarketType_> {
  const MarketTypeNameFamily._()
    : super(
        retry: null,
        name: r'marketTypeNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MarketTypeNameProvider call(MarketType_ type) =>
      MarketTypeNameProvider._(argument: type, from: this);

  @override
  String toString() => r'marketTypeNameProvider';
}

@ProviderFor(assetMarketType)
const assetMarketTypeProvider = AssetMarketTypeFamily._();

final class AssetMarketTypeProvider
    extends $FunctionalProvider<MarketType_, MarketType_, MarketType_>
    with $Provider<MarketType_> {
  const AssetMarketTypeProvider._({
    required AssetMarketTypeFamily super.from,
    required Asset? super.argument,
  }) : super(
         retry: null,
         name: r'assetMarketTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetMarketTypeHash();

  @override
  String toString() {
    return r'assetMarketTypeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MarketType_> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MarketType_ create(Ref ref) {
    final argument = this.argument as Asset?;
    return assetMarketType(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarketType_ value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarketType_>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssetMarketTypeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetMarketTypeHash() => r'1cd997dcaa8c150fb9334d0c1fc00d891e438583';

final class AssetMarketTypeFamily extends $Family
    with $FunctionalFamilyOverride<MarketType_, Asset?> {
  const AssetMarketTypeFamily._()
    : super(
        retry: null,
        name: r'assetMarketTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetMarketTypeProvider call(Asset? asset) =>
      AssetMarketTypeProvider._(argument: asset, from: this);

  @override
  String toString() => r'assetMarketTypeProvider';
}

@ProviderFor(TradeDirStateNotifier)
const tradeDirStateProvider = TradeDirStateNotifierProvider._();

final class TradeDirStateNotifierProvider
    extends $NotifierProvider<TradeDirStateNotifier, TradeDir> {
  const TradeDirStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tradeDirStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tradeDirStateNotifierHash();

  @$internal
  @override
  TradeDirStateNotifier create() => TradeDirStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TradeDir value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TradeDir>(value),
    );
  }
}

String _$tradeDirStateNotifierHash() =>
    r'5a70559c300307c02ed10ff386851d086b4e93bf';

abstract class _$TradeDirStateNotifier extends $Notifier<TradeDir> {
  TradeDir build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TradeDir, TradeDir>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TradeDir, TradeDir>,
              TradeDir,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Market list

@ProviderFor(MarketsNotifier)
const marketsProvider = MarketsNotifierProvider._();

/// Market list
final class MarketsNotifierProvider
    extends $NotifierProvider<MarketsNotifier, List<MarketInfo>> {
  /// Market list
  const MarketsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketsNotifierHash();

  @$internal
  @override
  MarketsNotifier create() => MarketsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MarketInfo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MarketInfo>>(value),
    );
  }
}

String _$marketsNotifierHash() => r'd48f2ec1a9d78e03afde2fea12220abb01935696';

/// Market list

abstract class _$MarketsNotifier extends $Notifier<List<MarketInfo>> {
  List<MarketInfo> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<MarketInfo>, List<MarketInfo>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<MarketInfo>, List<MarketInfo>>,
              List<MarketInfo>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(marketInfoByMarketType)
const marketInfoByMarketTypeProvider = MarketInfoByMarketTypeFamily._();

final class MarketInfoByMarketTypeProvider
    extends
        $FunctionalProvider<
          List<MarketInfo>,
          List<MarketInfo>,
          List<MarketInfo>
        >
    with $Provider<List<MarketInfo>> {
  const MarketInfoByMarketTypeProvider._({
    required MarketInfoByMarketTypeFamily super.from,
    required MarketType_ super.argument,
  }) : super(
         retry: null,
         name: r'marketInfoByMarketTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$marketInfoByMarketTypeHash();

  @override
  String toString() {
    return r'marketInfoByMarketTypeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<MarketInfo>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<MarketInfo> create(Ref ref) {
    final argument = this.argument as MarketType_;
    return marketInfoByMarketType(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MarketInfo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MarketInfo>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MarketInfoByMarketTypeProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$marketInfoByMarketTypeHash() =>
    r'277ea7a3ddb02669e207e584dc0253ec774226d5';

final class MarketInfoByMarketTypeFamily extends $Family
    with $FunctionalFamilyOverride<List<MarketInfo>, MarketType_> {
  const MarketInfoByMarketTypeFamily._()
    : super(
        retry: null,
        name: r'marketInfoByMarketTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MarketInfoByMarketTypeProvider call(MarketType_ marketType) =>
      MarketInfoByMarketTypeProvider._(argument: marketType, from: this);

  @override
  String toString() => r'marketInfoByMarketTypeProvider';
}

@ProviderFor(stableMarkets)
const stableMarketsProvider = StableMarketsProvider._();

final class StableMarketsProvider
    extends
        $FunctionalProvider<
          List<MarketInfo>,
          List<MarketInfo>,
          List<MarketInfo>
        >
    with $Provider<List<MarketInfo>> {
  const StableMarketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stableMarketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stableMarketsHash();

  @$internal
  @override
  $ProviderElement<List<MarketInfo>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<MarketInfo> create(Ref ref) {
    return stableMarkets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MarketInfo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MarketInfo>>(value),
    );
  }
}

String _$stableMarketsHash() => r'f59ea4c91a3cac5c823dbb0c11fb44169092a73a';

@ProviderFor(baseAssetByMarketInfo)
const baseAssetByMarketInfoProvider = BaseAssetByMarketInfoFamily._();

final class BaseAssetByMarketInfoProvider
    extends $FunctionalProvider<Option<Asset>, Option<Asset>, Option<Asset>>
    with $Provider<Option<Asset>> {
  const BaseAssetByMarketInfoProvider._({
    required BaseAssetByMarketInfoFamily super.from,
    required MarketInfo super.argument,
  }) : super(
         retry: null,
         name: r'baseAssetByMarketInfoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$baseAssetByMarketInfoHash();

  @override
  String toString() {
    return r'baseAssetByMarketInfoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Option<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<Asset> create(Ref ref) {
    final argument = this.argument as MarketInfo;
    return baseAssetByMarketInfo(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<Asset>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BaseAssetByMarketInfoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$baseAssetByMarketInfoHash() =>
    r'3320120e9ba1099dfedc24e51cc4a616036455de';

final class BaseAssetByMarketInfoFamily extends $Family
    with $FunctionalFamilyOverride<Option<Asset>, MarketInfo> {
  const BaseAssetByMarketInfoFamily._()
    : super(
        retry: null,
        name: r'baseAssetByMarketInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BaseAssetByMarketInfoProvider call(MarketInfo marketInfo) =>
      BaseAssetByMarketInfoProvider._(argument: marketInfo, from: this);

  @override
  String toString() => r'baseAssetByMarketInfoProvider';
}

@ProviderFor(baseAssetIconByMarketInfo)
const baseAssetIconByMarketInfoProvider = BaseAssetIconByMarketInfoFamily._();

final class BaseAssetIconByMarketInfoProvider
    extends $FunctionalProvider<Widget, Widget, Widget>
    with $Provider<Widget> {
  const BaseAssetIconByMarketInfoProvider._({
    required BaseAssetIconByMarketInfoFamily super.from,
    required MarketInfo super.argument,
  }) : super(
         retry: null,
         name: r'baseAssetIconByMarketInfoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$baseAssetIconByMarketInfoHash();

  @override
  String toString() {
    return r'baseAssetIconByMarketInfoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Widget> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Widget create(Ref ref) {
    final argument = this.argument as MarketInfo;
    return baseAssetIconByMarketInfo(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Widget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Widget>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BaseAssetIconByMarketInfoProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$baseAssetIconByMarketInfoHash() =>
    r'e062bce0c9a0a3c3b09a9f283d212d8d373c5cd8';

final class BaseAssetIconByMarketInfoFamily extends $Family
    with $FunctionalFamilyOverride<Widget, MarketInfo> {
  const BaseAssetIconByMarketInfoFamily._()
    : super(
        retry: null,
        name: r'baseAssetIconByMarketInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BaseAssetIconByMarketInfoProvider call(MarketInfo marketInfo) =>
      BaseAssetIconByMarketInfoProvider._(argument: marketInfo, from: this);

  @override
  String toString() => r'baseAssetIconByMarketInfoProvider';
}

@ProviderFor(quoteAssetByMarketInfo)
const quoteAssetByMarketInfoProvider = QuoteAssetByMarketInfoFamily._();

final class QuoteAssetByMarketInfoProvider
    extends $FunctionalProvider<Option<Asset>, Option<Asset>, Option<Asset>>
    with $Provider<Option<Asset>> {
  const QuoteAssetByMarketInfoProvider._({
    required QuoteAssetByMarketInfoFamily super.from,
    required MarketInfo super.argument,
  }) : super(
         retry: null,
         name: r'quoteAssetByMarketInfoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$quoteAssetByMarketInfoHash();

  @override
  String toString() {
    return r'quoteAssetByMarketInfoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Option<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<Asset> create(Ref ref) {
    final argument = this.argument as MarketInfo;
    return quoteAssetByMarketInfo(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<Asset>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is QuoteAssetByMarketInfoProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$quoteAssetByMarketInfoHash() =>
    r'7e664016dd3eebe2a6fbc65444f60a9ba4568f7f';

final class QuoteAssetByMarketInfoFamily extends $Family
    with $FunctionalFamilyOverride<Option<Asset>, MarketInfo> {
  const QuoteAssetByMarketInfoFamily._()
    : super(
        retry: null,
        name: r'quoteAssetByMarketInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QuoteAssetByMarketInfoProvider call(MarketInfo marketInfo) =>
      QuoteAssetByMarketInfoProvider._(argument: marketInfo, from: this);

  @override
  String toString() => r'quoteAssetByMarketInfoProvider';
}

@ProviderFor(quoteAssetIconByMarketInfo)
const quoteAssetIconByMarketInfoProvider = QuoteAssetIconByMarketInfoFamily._();

final class QuoteAssetIconByMarketInfoProvider
    extends $FunctionalProvider<Widget, Widget, Widget>
    with $Provider<Widget> {
  const QuoteAssetIconByMarketInfoProvider._({
    required QuoteAssetIconByMarketInfoFamily super.from,
    required MarketInfo super.argument,
  }) : super(
         retry: null,
         name: r'quoteAssetIconByMarketInfoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$quoteAssetIconByMarketInfoHash();

  @override
  String toString() {
    return r'quoteAssetIconByMarketInfoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Widget> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Widget create(Ref ref) {
    final argument = this.argument as MarketInfo;
    return quoteAssetIconByMarketInfo(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Widget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Widget>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is QuoteAssetIconByMarketInfoProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$quoteAssetIconByMarketInfoHash() =>
    r'e1372b7216654bde9ef345ca4cc47db9fd59fb7a';

final class QuoteAssetIconByMarketInfoFamily extends $Family
    with $FunctionalFamilyOverride<Widget, MarketInfo> {
  const QuoteAssetIconByMarketInfoFamily._()
    : super(
        retry: null,
        name: r'quoteAssetIconByMarketInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QuoteAssetIconByMarketInfoProvider call(MarketInfo marketInfo) =>
      QuoteAssetIconByMarketInfoProvider._(argument: marketInfo, from: this);

  @override
  String toString() => r'quoteAssetIconByMarketInfoProvider';
}

/// Public orders

@ProviderFor(MarketPublicOrdersNotifier)
const marketPublicOrdersProvider = MarketPublicOrdersNotifierProvider._();

/// Public orders
final class MarketPublicOrdersNotifierProvider
    extends
        $NotifierProvider<
          MarketPublicOrdersNotifier,
          Map<AssetPair, List<PublicOrder>>
        > {
  /// Public orders
  const MarketPublicOrdersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketPublicOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketPublicOrdersNotifierHash();

  @$internal
  @override
  MarketPublicOrdersNotifier create() => MarketPublicOrdersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<AssetPair, List<PublicOrder>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<AssetPair, List<PublicOrder>>>(
        value,
      ),
    );
  }
}

String _$marketPublicOrdersNotifierHash() =>
    r'f4eaa0ca36ff61a37d500fce26b8b922c947e479';

/// Public orders

abstract class _$MarketPublicOrdersNotifier
    extends $Notifier<Map<AssetPair, List<PublicOrder>>> {
  Map<AssetPair, List<PublicOrder>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              Map<AssetPair, List<PublicOrder>>,
              Map<AssetPair, List<PublicOrder>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<AssetPair, List<PublicOrder>>,
                Map<AssetPair, List<PublicOrder>>
              >,
              Map<AssetPair, List<PublicOrder>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(DebouncedMarketPublicOrders)
const debouncedMarketPublicOrdersProvider =
    DebouncedMarketPublicOrdersProvider._();

final class DebouncedMarketPublicOrdersProvider
    extends
        $NotifierProvider<
          DebouncedMarketPublicOrders,
          Map<AssetPair, List<PublicOrder>>
        > {
  const DebouncedMarketPublicOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debouncedMarketPublicOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debouncedMarketPublicOrdersHash();

  @$internal
  @override
  DebouncedMarketPublicOrders create() => DebouncedMarketPublicOrders();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<AssetPair, List<PublicOrder>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<AssetPair, List<PublicOrder>>>(
        value,
      ),
    );
  }
}

String _$debouncedMarketPublicOrdersHash() =>
    r'2fc71ede3573483064668cc49b0041ded4371921';

abstract class _$DebouncedMarketPublicOrders
    extends $Notifier<Map<AssetPair, List<PublicOrder>>> {
  Map<AssetPair, List<PublicOrder>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              Map<AssetPair, List<PublicOrder>>,
              Map<AssetPair, List<PublicOrder>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<AssetPair, List<PublicOrder>>,
                Map<AssetPair, List<PublicOrder>>
              >,
              Map<AssetPair, List<PublicOrder>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Own orders

@ProviderFor(MarketOwnOrdersNotifier)
const marketOwnOrdersProvider = MarketOwnOrdersNotifierProvider._();

/// Own orders
final class MarketOwnOrdersNotifierProvider
    extends $NotifierProvider<MarketOwnOrdersNotifier, List<OwnOrder>> {
  /// Own orders
  const MarketOwnOrdersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketOwnOrdersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketOwnOrdersNotifierHash();

  @$internal
  @override
  MarketOwnOrdersNotifier create() => MarketOwnOrdersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<OwnOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<OwnOrder>>(value),
    );
  }
}

String _$marketOwnOrdersNotifierHash() =>
    r'd08c11d040f8b76d187434986f8cd7569e157ea9';

/// Own orders

abstract class _$MarketOwnOrdersNotifier extends $Notifier<List<OwnOrder>> {
  List<OwnOrder> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<OwnOrder>, List<OwnOrder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<OwnOrder>, List<OwnOrder>>,
              List<OwnOrder>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(marketUiOwnOrders)
const marketUiOwnOrdersProvider = MarketUiOwnOrdersProvider._();

final class MarketUiOwnOrdersProvider
    extends
        $FunctionalProvider<
          List<UiOwnOrder>,
          List<UiOwnOrder>,
          List<UiOwnOrder>
        >
    with $Provider<List<UiOwnOrder>> {
  const MarketUiOwnOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketUiOwnOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketUiOwnOrdersHash();

  @$internal
  @override
  $ProviderElement<List<UiOwnOrder>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<UiOwnOrder> create(Ref ref) {
    return marketUiOwnOrders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<UiOwnOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<UiOwnOrder>>(value),
    );
  }
}

String _$marketUiOwnOrdersHash() => r'b5ef1ffc39b91cb6e6674382d4e166339a216336';

@ProviderFor(marketUiOwnOrderById)
const marketUiOwnOrderByIdProvider = MarketUiOwnOrderByIdFamily._();

final class MarketUiOwnOrderByIdProvider
    extends
        $FunctionalProvider<
          Option<UiOwnOrder>,
          Option<UiOwnOrder>,
          Option<UiOwnOrder>
        >
    with $Provider<Option<UiOwnOrder>> {
  const MarketUiOwnOrderByIdProvider._({
    required MarketUiOwnOrderByIdFamily super.from,
    required OrderId super.argument,
  }) : super(
         retry: null,
         name: r'marketUiOwnOrderByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$marketUiOwnOrderByIdHash();

  @override
  String toString() {
    return r'marketUiOwnOrderByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Option<UiOwnOrder>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<UiOwnOrder> create(Ref ref) {
    final argument = this.argument as OrderId;
    return marketUiOwnOrderById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<UiOwnOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<UiOwnOrder>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MarketUiOwnOrderByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$marketUiOwnOrderByIdHash() =>
    r'933f55a44f331b9c6632607e661486c3663d606a';

final class MarketUiOwnOrderByIdFamily extends $Family
    with $FunctionalFamilyOverride<Option<UiOwnOrder>, OrderId> {
  const MarketUiOwnOrderByIdFamily._()
    : super(
        retry: null,
        name: r'marketUiOwnOrderByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MarketUiOwnOrderByIdProvider call(OrderId orderId) =>
      MarketUiOwnOrderByIdProvider._(argument: orderId, from: this);

  @override
  String toString() => r'marketUiOwnOrderByIdProvider';
}

@ProviderFor(MarketSubscribedAssetPairNotifier)
const marketSubscribedAssetPairProvider =
    MarketSubscribedAssetPairNotifierProvider._();

final class MarketSubscribedAssetPairNotifierProvider
    extends
        $NotifierProvider<
          MarketSubscribedAssetPairNotifier,
          Option<AssetPair>
        > {
  const MarketSubscribedAssetPairNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketSubscribedAssetPairProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$marketSubscribedAssetPairNotifierHash();

  @$internal
  @override
  MarketSubscribedAssetPairNotifier create() =>
      MarketSubscribedAssetPairNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<AssetPair> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<AssetPair>>(value),
    );
  }
}

String _$marketSubscribedAssetPairNotifierHash() =>
    r'3d5d25991cfb32b8e20e18f1f391d279203d1b1e';

abstract class _$MarketSubscribedAssetPairNotifier
    extends $Notifier<Option<AssetPair>> {
  Option<AssetPair> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<AssetPair>, Option<AssetPair>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<AssetPair>, Option<AssetPair>>,
              Option<AssetPair>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(subscribedMarketInfo)
const subscribedMarketInfoProvider = SubscribedMarketInfoProvider._();

final class SubscribedMarketInfoProvider
    extends
        $FunctionalProvider<
          Option<MarketInfo>,
          Option<MarketInfo>,
          Option<MarketInfo>
        >
    with $Provider<Option<MarketInfo>> {
  const SubscribedMarketInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscribedMarketInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscribedMarketInfoHash();

  @$internal
  @override
  $ProviderElement<Option<MarketInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<MarketInfo> create(Ref ref) {
    return subscribedMarketInfo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<MarketInfo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<MarketInfo>>(value),
    );
  }
}

String _$subscribedMarketInfoHash() =>
    r'f5cb44660e00c8d3a3e8384807f5e517965432c9';

@ProviderFor(subscribedMarketProductName)
const subscribedMarketProductNameProvider =
    SubscribedMarketProductNameProvider._();

final class SubscribedMarketProductNameProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const SubscribedMarketProductNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscribedMarketProductNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscribedMarketProductNameHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return subscribedMarketProductName(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$subscribedMarketProductNameHash() =>
    r'9c801467900b87fc082e0ffb8c2532423c8bea5d';

@ProviderFor(marketSubscribedBaseAsset)
const marketSubscribedBaseAssetProvider = MarketSubscribedBaseAssetProvider._();

final class MarketSubscribedBaseAssetProvider
    extends $FunctionalProvider<Option<Asset>, Option<Asset>, Option<Asset>>
    with $Provider<Option<Asset>> {
  const MarketSubscribedBaseAssetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketSubscribedBaseAssetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketSubscribedBaseAssetHash();

  @$internal
  @override
  $ProviderElement<Option<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<Asset> create(Ref ref) {
    return marketSubscribedBaseAsset(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<Asset>>(value),
    );
  }
}

String _$marketSubscribedBaseAssetHash() =>
    r'3c236c8986cec5dc9e5fd6fc70daa0e37ea6a3e3';

@ProviderFor(marketSubscribedQuoteAsset)
const marketSubscribedQuoteAssetProvider =
    MarketSubscribedQuoteAssetProvider._();

final class MarketSubscribedQuoteAssetProvider
    extends $FunctionalProvider<Option<Asset>, Option<Asset>, Option<Asset>>
    with $Provider<Option<Asset>> {
  const MarketSubscribedQuoteAssetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketSubscribedQuoteAssetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketSubscribedQuoteAssetHash();

  @$internal
  @override
  $ProviderElement<Option<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<Asset> create(Ref ref) {
    return marketSubscribedQuoteAsset(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<Asset>>(value),
    );
  }
}

String _$marketSubscribedQuoteAssetHash() =>
    r'990dd2bc7639a938afefe8e5b486b84555edeb80';

/// Index price

@ProviderFor(MarketPriceNotifier)
const marketPriceProvider = MarketPriceNotifierProvider._();

/// Index price
final class MarketPriceNotifierProvider
    extends
        $NotifierProvider<
          MarketPriceNotifier,
          Map<AssetPair, ({double indexPrice, double lastPrice})>
        > {
  /// Index price
  const MarketPriceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketPriceNotifierHash();

  @$internal
  @override
  MarketPriceNotifier create() => MarketPriceNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Map<AssetPair, ({double indexPrice, double lastPrice})> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Map<AssetPair, ({double indexPrice, double lastPrice})>
          >(value),
    );
  }
}

String _$marketPriceNotifierHash() =>
    r'e7e51919d349b9a7b9252cdd3c6120149c38e262';

/// Index price

abstract class _$MarketPriceNotifier
    extends $Notifier<Map<AssetPair, ({double indexPrice, double lastPrice})>> {
  Map<AssetPair, ({double indexPrice, double lastPrice})> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              Map<AssetPair, ({double indexPrice, double lastPrice})>,
              Map<AssetPair, ({double indexPrice, double lastPrice})>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<AssetPair, ({double indexPrice, double lastPrice})>,
                Map<AssetPair, ({double indexPrice, double lastPrice})>
              >,
              Map<AssetPair, ({double indexPrice, double lastPrice})>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(marketSatoshiIndexPrice)
const marketSatoshiIndexPriceProvider = MarketSatoshiIndexPriceProvider._();

final class MarketSatoshiIndexPriceProvider
    extends
        $FunctionalProvider<
          Option<({Option<Asset> quoteAsset, int satoshiIndexPrice})>,
          Option<({Option<Asset> quoteAsset, int satoshiIndexPrice})>,
          Option<({Option<Asset> quoteAsset, int satoshiIndexPrice})>
        >
    with
        $Provider<Option<({Option<Asset> quoteAsset, int satoshiIndexPrice})>> {
  const MarketSatoshiIndexPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketSatoshiIndexPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketSatoshiIndexPriceHash();

  @$internal
  @override
  $ProviderElement<Option<({Option<Asset> quoteAsset, int satoshiIndexPrice})>>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Option<({Option<Asset> quoteAsset, int satoshiIndexPrice})> create(Ref ref) {
    return marketSatoshiIndexPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Option<({Option<Asset> quoteAsset, int satoshiIndexPrice})> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Option<({Option<Asset> quoteAsset, int satoshiIndexPrice})>
          >(value),
    );
  }
}

String _$marketSatoshiIndexPriceHash() =>
    r'bb0cf18d4dd75f35c0777855c4077edccc941e21';

@ProviderFor(marketIndexPrice)
const marketIndexPriceProvider = MarketIndexPriceProvider._();

final class MarketIndexPriceProvider
    extends
        $FunctionalProvider<
          Option<({String indexPrice, Option<Asset> quoteAsset})>,
          Option<({String indexPrice, Option<Asset> quoteAsset})>,
          Option<({String indexPrice, Option<Asset> quoteAsset})>
        >
    with $Provider<Option<({String indexPrice, Option<Asset> quoteAsset})>> {
  const MarketIndexPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketIndexPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketIndexPriceHash();

  @$internal
  @override
  $ProviderElement<Option<({String indexPrice, Option<Asset> quoteAsset})>>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Option<({String indexPrice, Option<Asset> quoteAsset})> create(Ref ref) {
    return marketIndexPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Option<({String indexPrice, Option<Asset> quoteAsset})> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Option<({String indexPrice, Option<Asset> quoteAsset})>
          >(value),
    );
  }
}

String _$marketIndexPriceHash() => r'cbfca696b21a0a59f9f12a1870135f56c821d577';

@ProviderFor(marketDecimalIndexPrice)
const marketDecimalIndexPriceProvider = MarketDecimalIndexPriceProvider._();

final class MarketDecimalIndexPriceProvider
    extends
        $FunctionalProvider<
          Option<({Decimal decimalIndexPrice, Option<Asset> quoteAsset})>,
          Option<({Decimal decimalIndexPrice, Option<Asset> quoteAsset})>,
          Option<({Decimal decimalIndexPrice, Option<Asset> quoteAsset})>
        >
    with
        $Provider<
          Option<({Decimal decimalIndexPrice, Option<Asset> quoteAsset})>
        > {
  const MarketDecimalIndexPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketDecimalIndexPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketDecimalIndexPriceHash();

  @$internal
  @override
  $ProviderElement<
    Option<({Decimal decimalIndexPrice, Option<Asset> quoteAsset})>
  >
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Option<({Decimal decimalIndexPrice, Option<Asset> quoteAsset})> create(
    Ref ref,
  ) {
    return marketDecimalIndexPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Option<({Decimal decimalIndexPrice, Option<Asset> quoteAsset})> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Option<({Decimal decimalIndexPrice, Option<Asset> quoteAsset})>
          >(value),
    );
  }
}

String _$marketDecimalIndexPriceHash() =>
    r'6b865d9b1218384c5719dad9619f08477351ce8a';

@ProviderFor(marketSatoshiLastPrice)
const marketSatoshiLastPriceProvider = MarketSatoshiLastPriceProvider._();

final class MarketSatoshiLastPriceProvider
    extends
        $FunctionalProvider<
          Option<({Option<Asset> quoteAsset, int satoshiLastPrice})>,
          Option<({Option<Asset> quoteAsset, int satoshiLastPrice})>,
          Option<({Option<Asset> quoteAsset, int satoshiLastPrice})>
        >
    with $Provider<Option<({Option<Asset> quoteAsset, int satoshiLastPrice})>> {
  const MarketSatoshiLastPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketSatoshiLastPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketSatoshiLastPriceHash();

  @$internal
  @override
  $ProviderElement<Option<({Option<Asset> quoteAsset, int satoshiLastPrice})>>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Option<({Option<Asset> quoteAsset, int satoshiLastPrice})> create(Ref ref) {
    return marketSatoshiLastPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Option<({Option<Asset> quoteAsset, int satoshiLastPrice})> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Option<({Option<Asset> quoteAsset, int satoshiLastPrice})>
          >(value),
    );
  }
}

String _$marketSatoshiLastPriceHash() =>
    r'23b3a7a539522cc42e2be846a8cd016ca7db4fa4';

@ProviderFor(marketLastPrice)
const marketLastPriceProvider = MarketLastPriceProvider._();

final class MarketLastPriceProvider
    extends
        $FunctionalProvider<
          Option<({String lastPrice, Option<Asset> quoteAsset})>,
          Option<({String lastPrice, Option<Asset> quoteAsset})>,
          Option<({String lastPrice, Option<Asset> quoteAsset})>
        >
    with $Provider<Option<({String lastPrice, Option<Asset> quoteAsset})>> {
  const MarketLastPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketLastPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketLastPriceHash();

  @$internal
  @override
  $ProviderElement<Option<({String lastPrice, Option<Asset> quoteAsset})>>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Option<({String lastPrice, Option<Asset> quoteAsset})> create(Ref ref) {
    return marketLastPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Option<({String lastPrice, Option<Asset> quoteAsset})> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Option<({String lastPrice, Option<Asset> quoteAsset})>
          >(value),
    );
  }
}

String _$marketLastPriceHash() => r'8964a0edb88edde640763529d7d14814214b74cd';

@ProviderFor(marketDecimalLastPrice)
const marketDecimalLastPriceProvider = MarketDecimalLastPriceProvider._();

final class MarketDecimalLastPriceProvider
    extends
        $FunctionalProvider<
          Option<({Decimal decimalLastPrice, Option<Asset> quoteAsset})>,
          Option<({Decimal decimalLastPrice, Option<Asset> quoteAsset})>,
          Option<({Decimal decimalLastPrice, Option<Asset> quoteAsset})>
        >
    with
        $Provider<
          Option<({Decimal decimalLastPrice, Option<Asset> quoteAsset})>
        > {
  const MarketDecimalLastPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketDecimalLastPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketDecimalLastPriceHash();

  @$internal
  @override
  $ProviderElement<
    Option<({Decimal decimalLastPrice, Option<Asset> quoteAsset})>
  >
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Option<({Decimal decimalLastPrice, Option<Asset> quoteAsset})> create(
    Ref ref,
  ) {
    return marketDecimalLastPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Option<({Decimal decimalLastPrice, Option<Asset> quoteAsset})> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<
            Option<({Decimal decimalLastPrice, Option<Asset> quoteAsset})>
          >(value),
    );
  }
}

String _$marketDecimalLastPriceHash() =>
    r'594a080f06343355b96cdbbb21da713b65e0d4d5';

@ProviderFor(MarketSideStateNotifier)
const marketSideStateProvider = MarketSideStateNotifierProvider._();

final class MarketSideStateNotifierProvider
    extends $NotifierProvider<MarketSideStateNotifier, MarketSideState> {
  const MarketSideStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketSideStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketSideStateNotifierHash();

  @$internal
  @override
  MarketSideStateNotifier create() => MarketSideStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarketSideState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarketSideState>(value),
    );
  }
}

String _$marketSideStateNotifierHash() =>
    r'020f92d5c1c5c2d1d74398fa32eba5d0e4b44d75';

abstract class _$MarketSideStateNotifier extends $Notifier<MarketSideState> {
  MarketSideState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MarketSideState, MarketSideState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MarketSideState, MarketSideState>,
              MarketSideState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MarketTypeSwitchStateNotifier)
const marketTypeSwitchStateProvider = MarketTypeSwitchStateNotifierProvider._();

final class MarketTypeSwitchStateNotifierProvider
    extends
        $NotifierProvider<
          MarketTypeSwitchStateNotifier,
          MarketTypeSwitchState
        > {
  const MarketTypeSwitchStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketTypeSwitchStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketTypeSwitchStateNotifierHash();

  @$internal
  @override
  MarketTypeSwitchStateNotifier create() => MarketTypeSwitchStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarketTypeSwitchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarketTypeSwitchState>(value),
    );
  }
}

String _$marketTypeSwitchStateNotifierHash() =>
    r'224ebaec567a018acd7475019073e6ed221f5452';

abstract class _$MarketTypeSwitchStateNotifier
    extends $Notifier<MarketTypeSwitchState> {
  MarketTypeSwitchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MarketTypeSwitchState, MarketTypeSwitchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MarketTypeSwitchState, MarketTypeSwitchState>,
              MarketTypeSwitchState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MarketOrderAmountControllerNotifier)
const marketOrderAmountControllerProvider =
    MarketOrderAmountControllerNotifierProvider._();

final class MarketOrderAmountControllerNotifierProvider
    extends $NotifierProvider<MarketOrderAmountControllerNotifier, String> {
  const MarketOrderAmountControllerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketOrderAmountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$marketOrderAmountControllerNotifierHash();

  @$internal
  @override
  MarketOrderAmountControllerNotifier create() =>
      MarketOrderAmountControllerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$marketOrderAmountControllerNotifierHash() =>
    r'8017517591316645658e20bf23b8faae82138f11';

abstract class _$MarketOrderAmountControllerNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(marketOrderAmount)
const marketOrderAmountProvider = MarketOrderAmountProvider._();

final class MarketOrderAmountProvider
    extends $FunctionalProvider<OrderAmount, OrderAmount, OrderAmount>
    with $Provider<OrderAmount> {
  const MarketOrderAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketOrderAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketOrderAmountHash();

  @$internal
  @override
  $ProviderElement<OrderAmount> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderAmount create(Ref ref) {
    return marketOrderAmount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderAmount value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderAmount>(value),
    );
  }
}

String _$marketOrderAmountHash() => r'2a9ccecd3317decf19396374e5657d551c599c74';

@ProviderFor(marketOrderTradeButtonEnabled)
const marketOrderTradeButtonEnabledProvider =
    MarketOrderTradeButtonEnabledProvider._();

final class MarketOrderTradeButtonEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const MarketOrderTradeButtonEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketOrderTradeButtonEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketOrderTradeButtonEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return marketOrderTradeButtonEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$marketOrderTradeButtonEnabledHash() =>
    r'242fbcfc419bb086606e5d50cd70d5ed8d007e63';

@ProviderFor(MarketQuoteNotifier)
const marketQuoteProvider = MarketQuoteNotifierProvider._();

final class MarketQuoteNotifierProvider
    extends $NotifierProvider<MarketQuoteNotifier, Option<From_Quote>> {
  const MarketQuoteNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketQuoteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketQuoteNotifierHash();

  @$internal
  @override
  MarketQuoteNotifier create() => MarketQuoteNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<From_Quote> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<From_Quote>>(value),
    );
  }
}

String _$marketQuoteNotifierHash() =>
    r'8c609430ec13fc2bd0be8bc6940a9f98f261a81d';

abstract class _$MarketQuoteNotifier extends $Notifier<Option<From_Quote>> {
  Option<From_Quote> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<From_Quote>, Option<From_Quote>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<From_Quote>, Option<From_Quote>>,
              Option<From_Quote>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(marketQuoteError)
const marketQuoteErrorProvider = MarketQuoteErrorProvider._();

final class MarketQuoteErrorProvider
    extends
        $FunctionalProvider<
          Option<QuoteError>,
          Option<QuoteError>,
          Option<QuoteError>
        >
    with $Provider<Option<QuoteError>> {
  const MarketQuoteErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketQuoteErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketQuoteErrorHash();

  @$internal
  @override
  $ProviderElement<Option<QuoteError>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<QuoteError> create(Ref ref) {
    return marketQuoteError(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteError> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteError>>(value),
    );
  }
}

String _$marketQuoteErrorHash() => r'a31e51066f3e993b8e228573880377440dc90ea7';

@ProviderFor(marketQuoteLowBalanceError)
const marketQuoteLowBalanceErrorProvider =
    MarketQuoteLowBalanceErrorProvider._();

final class MarketQuoteLowBalanceErrorProvider
    extends
        $FunctionalProvider<
          Option<QuoteLowBalance>,
          Option<QuoteLowBalance>,
          Option<QuoteLowBalance>
        >
    with $Provider<Option<QuoteLowBalance>> {
  const MarketQuoteLowBalanceErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketQuoteLowBalanceErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketQuoteLowBalanceErrorHash();

  @$internal
  @override
  $ProviderElement<Option<QuoteLowBalance>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<QuoteLowBalance> create(Ref ref) {
    return marketQuoteLowBalanceError(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteLowBalance> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteLowBalance>>(value),
    );
  }
}

String _$marketQuoteLowBalanceErrorHash() =>
    r'900b512d879f993d5832ad89c2656079e00c78d4';

@ProviderFor(marketQuoteSuccess)
const marketQuoteSuccessProvider = MarketQuoteSuccessProvider._();

final class MarketQuoteSuccessProvider
    extends
        $FunctionalProvider<
          Option<QuoteSuccess>,
          Option<QuoteSuccess>,
          Option<QuoteSuccess>
        >
    with $Provider<Option<QuoteSuccess>> {
  const MarketQuoteSuccessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketQuoteSuccessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketQuoteSuccessHash();

  @$internal
  @override
  $ProviderElement<Option<QuoteSuccess>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<QuoteSuccess> create(Ref ref) {
    return marketQuoteSuccess(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteSuccess> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteSuccess>>(value),
    );
  }
}

String _$marketQuoteSuccessHash() =>
    r'4ed0415aaa27000c8e8c5df7a564385c7a88c13b';

@ProviderFor(marketQuoteUnregisteredGaid)
const marketQuoteUnregisteredGaidProvider =
    MarketQuoteUnregisteredGaidProvider._();

final class MarketQuoteUnregisteredGaidProvider
    extends
        $FunctionalProvider<
          Option<QuoteUnregisteredGaid>,
          Option<QuoteUnregisteredGaid>,
          Option<QuoteUnregisteredGaid>
        >
    with $Provider<Option<QuoteUnregisteredGaid>> {
  const MarketQuoteUnregisteredGaidProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketQuoteUnregisteredGaidProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketQuoteUnregisteredGaidHash();

  @$internal
  @override
  $ProviderElement<Option<QuoteUnregisteredGaid>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<QuoteUnregisteredGaid> create(Ref ref) {
    return marketQuoteUnregisteredGaid(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteUnregisteredGaid> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteUnregisteredGaid>>(
        value,
      ),
    );
  }
}

String _$marketQuoteUnregisteredGaidHash() =>
    r'e5b065cad0a9490dc3c3e43df45ab8f4053b9c93';

@ProviderFor(marketAcceptQuote)
const marketAcceptQuoteProvider = MarketAcceptQuoteProvider._();

final class MarketAcceptQuoteProvider
    extends
        $FunctionalProvider<
          Option<From_AcceptQuote>,
          Option<From_AcceptQuote>,
          Option<From_AcceptQuote>
        >
    with $Provider<Option<From_AcceptQuote>> {
  const MarketAcceptQuoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketAcceptQuoteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketAcceptQuoteHash();

  @$internal
  @override
  $ProviderElement<Option<From_AcceptQuote>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<From_AcceptQuote> create(Ref ref) {
    return marketAcceptQuote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<From_AcceptQuote> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<From_AcceptQuote>>(value),
    );
  }
}

String _$marketAcceptQuoteHash() => r'76e795dbb9f0df51ed64db5cd37ded54185681ef';

@ProviderFor(marketAcceptQuoteSuccess)
const marketAcceptQuoteSuccessProvider = MarketAcceptQuoteSuccessProvider._();

final class MarketAcceptQuoteSuccessProvider
    extends $FunctionalProvider<Option<String>, Option<String>, Option<String>>
    with $Provider<Option<String>> {
  const MarketAcceptQuoteSuccessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketAcceptQuoteSuccessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketAcceptQuoteSuccessHash();

  @$internal
  @override
  $ProviderElement<Option<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<String> create(Ref ref) {
    return marketAcceptQuoteSuccess(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<String>>(value),
    );
  }
}

String _$marketAcceptQuoteSuccessHash() =>
    r'b769333f4e8061062194f2acbe05ca2790d34b0d';

@ProviderFor(marketAcceptQuoteError)
const marketAcceptQuoteErrorProvider = MarketAcceptQuoteErrorProvider._();

final class MarketAcceptQuoteErrorProvider
    extends $FunctionalProvider<Option<String>, Option<String>, Option<String>>
    with $Provider<Option<String>> {
  const MarketAcceptQuoteErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketAcceptQuoteErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketAcceptQuoteErrorHash();

  @$internal
  @override
  $ProviderElement<Option<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<String> create(Ref ref) {
    return marketAcceptQuoteError(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<String>>(value),
    );
  }
}

String _$marketAcceptQuoteErrorHash() =>
    r'18dc40ab4c6fd2f681571f6fd796e0744bdd9444';

@ProviderFor(LimitTtlFlagNotifier)
const limitTtlFlagProvider = LimitTtlFlagNotifierProvider._();

final class LimitTtlFlagNotifierProvider
    extends $NotifierProvider<LimitTtlFlagNotifier, LimitTtlFlag> {
  const LimitTtlFlagNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitTtlFlagProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$limitTtlFlagNotifierHash();

  @$internal
  @override
  LimitTtlFlagNotifier create() => LimitTtlFlagNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LimitTtlFlag value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LimitTtlFlag>(value),
    );
  }
}

String _$limitTtlFlagNotifierHash() =>
    r'44f7e5c237f7e7c2cf3f4b8ce04c61e834bd4174';

abstract class _$LimitTtlFlagNotifier extends $Notifier<LimitTtlFlag> {
  LimitTtlFlag build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LimitTtlFlag, LimitTtlFlag>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LimitTtlFlag, LimitTtlFlag>,
              LimitTtlFlag,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(LimitOrderAmountControllerNotifier)
const limitOrderAmountControllerProvider =
    LimitOrderAmountControllerNotifierProvider._();

final class LimitOrderAmountControllerNotifierProvider
    extends $NotifierProvider<LimitOrderAmountControllerNotifier, String> {
  const LimitOrderAmountControllerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitOrderAmountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$limitOrderAmountControllerNotifierHash();

  @$internal
  @override
  LimitOrderAmountControllerNotifier create() =>
      LimitOrderAmountControllerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$limitOrderAmountControllerNotifierHash() =>
    r'f0d6bdb9468edf7fca3a64b5aeabadbb8bafdcc5';

abstract class _$LimitOrderAmountControllerNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(limitOrderAmount)
const limitOrderAmountProvider = LimitOrderAmountProvider._();

final class LimitOrderAmountProvider
    extends $FunctionalProvider<OrderAmount, OrderAmount, OrderAmount>
    with $Provider<OrderAmount> {
  const LimitOrderAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitOrderAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$limitOrderAmountHash();

  @$internal
  @override
  $ProviderElement<OrderAmount> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderAmount create(Ref ref) {
    return limitOrderAmount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderAmount value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderAmount>(value),
    );
  }
}

String _$limitOrderAmountHash() => r'73ee33dd68153df1fc5f8947ed5d5acdfca49f45';

@ProviderFor(LimitOrderPriceControllerNotifier)
const limitOrderPriceControllerProvider =
    LimitOrderPriceControllerNotifierProvider._();

final class LimitOrderPriceControllerNotifierProvider
    extends $NotifierProvider<LimitOrderPriceControllerNotifier, String> {
  const LimitOrderPriceControllerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitOrderPriceControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$limitOrderPriceControllerNotifierHash();

  @$internal
  @override
  LimitOrderPriceControllerNotifier create() =>
      LimitOrderPriceControllerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$limitOrderPriceControllerNotifierHash() =>
    r'a03cd4b2e52fcab70f2ab849860e0f4a50f83522';

abstract class _$LimitOrderPriceControllerNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(limitOrderPrice)
const limitOrderPriceProvider = LimitOrderPriceProvider._();

final class LimitOrderPriceProvider
    extends $FunctionalProvider<OrderAmount, OrderAmount, OrderAmount>
    with $Provider<OrderAmount> {
  const LimitOrderPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitOrderPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$limitOrderPriceHash();

  @$internal
  @override
  $ProviderElement<OrderAmount> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderAmount create(Ref ref) {
    return limitOrderPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderAmount value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderAmount>(value),
    );
  }
}

String _$limitOrderPriceHash() => r'f3ec7265954605d89820b6f50ed5f6e6affcfc26';

@ProviderFor(limitOrderTradeButtonEnabled)
const limitOrderTradeButtonEnabledProvider =
    LimitOrderTradeButtonEnabledProvider._();

final class LimitOrderTradeButtonEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const LimitOrderTradeButtonEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitOrderTradeButtonEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$limitOrderTradeButtonEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return limitOrderTradeButtonEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$limitOrderTradeButtonEnabledHash() =>
    r'073c8543aa8894f54edd0e0d33c459cb038acf26';

@ProviderFor(OrderSubmitNotifier)
const orderSubmitProvider = OrderSubmitNotifierProvider._();

final class OrderSubmitNotifierProvider
    extends $NotifierProvider<OrderSubmitNotifier, Option<From_OrderSubmit>> {
  const OrderSubmitNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderSubmitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderSubmitNotifierHash();

  @$internal
  @override
  OrderSubmitNotifier create() => OrderSubmitNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<From_OrderSubmit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<From_OrderSubmit>>(value),
    );
  }
}

String _$orderSubmitNotifierHash() =>
    r'e029689020453e06ce8769ab983b38f384aed3ea';

abstract class _$OrderSubmitNotifier
    extends $Notifier<Option<From_OrderSubmit>> {
  Option<From_OrderSubmit> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<Option<From_OrderSubmit>, Option<From_OrderSubmit>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<From_OrderSubmit>, Option<From_OrderSubmit>>,
              Option<From_OrderSubmit>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OrderSubmitSuccessNotifier)
const orderSubmitSuccessProvider = OrderSubmitSuccessNotifierProvider._();

final class OrderSubmitSuccessNotifierProvider
    extends $NotifierProvider<OrderSubmitSuccessNotifier, Option<UiOwnOrder>> {
  const OrderSubmitSuccessNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderSubmitSuccessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderSubmitSuccessNotifierHash();

  @$internal
  @override
  OrderSubmitSuccessNotifier create() => OrderSubmitSuccessNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<UiOwnOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<UiOwnOrder>>(value),
    );
  }
}

String _$orderSubmitSuccessNotifierHash() =>
    r'7d14ddece882c140ab3bb7d8b7b8fa6c85404aa6';

abstract class _$OrderSubmitSuccessNotifier
    extends $Notifier<Option<UiOwnOrder>> {
  Option<UiOwnOrder> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<UiOwnOrder>, Option<UiOwnOrder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<UiOwnOrder>, Option<UiOwnOrder>>,
              Option<UiOwnOrder>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OrderSubmitErrorNotifier)
const orderSubmitErrorProvider = OrderSubmitErrorNotifierProvider._();

final class OrderSubmitErrorNotifierProvider
    extends $NotifierProvider<OrderSubmitErrorNotifier, Option<String>> {
  const OrderSubmitErrorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderSubmitErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderSubmitErrorNotifierHash();

  @$internal
  @override
  OrderSubmitErrorNotifier create() => OrderSubmitErrorNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<String>>(value),
    );
  }
}

String _$orderSubmitErrorNotifierHash() =>
    r'd7bc701e94a0f7bb9888fb9d9af28ce0d01e5f85';

abstract class _$OrderSubmitErrorNotifier extends $Notifier<Option<String>> {
  Option<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<String>, Option<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<String>, Option<String>>,
              Option<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OrderSubmitUnregisteredGaidNotifier)
const orderSubmitUnregisteredGaidProvider =
    OrderSubmitUnregisteredGaidNotifierProvider._();

final class OrderSubmitUnregisteredGaidNotifierProvider
    extends
        $NotifierProvider<OrderSubmitUnregisteredGaidNotifier, Option<String>> {
  const OrderSubmitUnregisteredGaidNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderSubmitUnregisteredGaidProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$orderSubmitUnregisteredGaidNotifierHash();

  @$internal
  @override
  OrderSubmitUnregisteredGaidNotifier create() =>
      OrderSubmitUnregisteredGaidNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<String>>(value),
    );
  }
}

String _$orderSubmitUnregisteredGaidNotifierHash() =>
    r'cf392f7ce800a200fb3a03a610ffc673c1de0722';

abstract class _$OrderSubmitUnregisteredGaidNotifier
    extends $Notifier<Option<String>> {
  Option<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<String>, Option<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<String>, Option<String>>,
              Option<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MarketEditOrderErrorNotifier)
const marketEditOrderErrorProvider = MarketEditOrderErrorNotifierProvider._();

final class MarketEditOrderErrorNotifierProvider
    extends $NotifierProvider<MarketEditOrderErrorNotifier, Option<String>> {
  const MarketEditOrderErrorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketEditOrderErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketEditOrderErrorNotifierHash();

  @$internal
  @override
  MarketEditOrderErrorNotifier create() => MarketEditOrderErrorNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<String>>(value),
    );
  }
}

String _$marketEditOrderErrorNotifierHash() =>
    r'e4c2bf12555c514fcf171a71c12cb74830fb1de6';

abstract class _$MarketEditOrderErrorNotifier
    extends $Notifier<Option<String>> {
  Option<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<String>, Option<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<String>, Option<String>>,
              Option<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MarketEditDetailsOrderNotifier)
const marketEditDetailsOrderProvider =
    MarketEditDetailsOrderNotifierProvider._();

final class MarketEditDetailsOrderNotifierProvider
    extends
        $NotifierProvider<MarketEditDetailsOrderNotifier, Option<UiOwnOrder>> {
  const MarketEditDetailsOrderNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketEditDetailsOrderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketEditDetailsOrderNotifierHash();

  @$internal
  @override
  MarketEditDetailsOrderNotifier create() => MarketEditDetailsOrderNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<UiOwnOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<UiOwnOrder>>(value),
    );
  }
}

String _$marketEditDetailsOrderNotifierHash() =>
    r'7e0ef91b7f5faf39d550833c0d858f75221a5643';

abstract class _$MarketEditDetailsOrderNotifier
    extends $Notifier<Option<UiOwnOrder>> {
  Option<UiOwnOrder> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<UiOwnOrder>, Option<UiOwnOrder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<UiOwnOrder>, Option<UiOwnOrder>>,
              Option<UiOwnOrder>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MarketEditOrderAmountControllerNotifier)
const marketEditOrderAmountControllerProvider =
    MarketEditOrderAmountControllerNotifierProvider._();

final class MarketEditOrderAmountControllerNotifierProvider
    extends $NotifierProvider<MarketEditOrderAmountControllerNotifier, String> {
  const MarketEditOrderAmountControllerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketEditOrderAmountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$marketEditOrderAmountControllerNotifierHash();

  @$internal
  @override
  MarketEditOrderAmountControllerNotifier create() =>
      MarketEditOrderAmountControllerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$marketEditOrderAmountControllerNotifierHash() =>
    r'7be8a01f977efdb612b5cb5c74b6563b94868a3d';

abstract class _$MarketEditOrderAmountControllerNotifier
    extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(marketEditOrderAmount)
const marketEditOrderAmountProvider = MarketEditOrderAmountProvider._();

final class MarketEditOrderAmountProvider
    extends
        $FunctionalProvider<
          Option<OrderAmount>,
          Option<OrderAmount>,
          Option<OrderAmount>
        >
    with $Provider<Option<OrderAmount>> {
  const MarketEditOrderAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketEditOrderAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketEditOrderAmountHash();

  @$internal
  @override
  $ProviderElement<Option<OrderAmount>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<OrderAmount> create(Ref ref) {
    return marketEditOrderAmount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<OrderAmount> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<OrderAmount>>(value),
    );
  }
}

String _$marketEditOrderAmountHash() =>
    r'8c16eca0801196524ed8f18a90cfc9e1ae0d2e3a';

@ProviderFor(MarketEditOrderPriceControllerNotifier)
const marketEditOrderPriceControllerProvider =
    MarketEditOrderPriceControllerNotifierProvider._();

final class MarketEditOrderPriceControllerNotifierProvider
    extends $NotifierProvider<MarketEditOrderPriceControllerNotifier, String> {
  const MarketEditOrderPriceControllerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketEditOrderPriceControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$marketEditOrderPriceControllerNotifierHash();

  @$internal
  @override
  MarketEditOrderPriceControllerNotifier create() =>
      MarketEditOrderPriceControllerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$marketEditOrderPriceControllerNotifierHash() =>
    r'5bc9048d52ba2cebc7a070d7f0542bafed419653';

abstract class _$MarketEditOrderPriceControllerNotifier
    extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(marketEditOrderPrice)
const marketEditOrderPriceProvider = MarketEditOrderPriceProvider._();

final class MarketEditOrderPriceProvider
    extends
        $FunctionalProvider<
          Option<OrderAmount>,
          Option<OrderAmount>,
          Option<OrderAmount>
        >
    with $Provider<Option<OrderAmount>> {
  const MarketEditOrderPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketEditOrderPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketEditOrderPriceHash();

  @$internal
  @override
  $ProviderElement<Option<OrderAmount>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<OrderAmount> create(Ref ref) {
    return marketEditOrderPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<OrderAmount> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<OrderAmount>>(value),
    );
  }
}

String _$marketEditOrderPriceHash() =>
    r'409dc49952eca9cb4a18a885dff873c031018574';

@ProviderFor(marketEditOrderAcceptEnabled)
const marketEditOrderAcceptEnabledProvider =
    MarketEditOrderAcceptEnabledProvider._();

final class MarketEditOrderAcceptEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const MarketEditOrderAcceptEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketEditOrderAcceptEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketEditOrderAcceptEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return marketEditOrderAcceptEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$marketEditOrderAcceptEnabledHash() =>
    r'72e8749934d9b0efc4f5266e462ab109cd66ce4c';

@ProviderFor(MarketLimitOrderTypeNotifier)
const marketLimitOrderTypeProvider = MarketLimitOrderTypeNotifierProvider._();

final class MarketLimitOrderTypeNotifierProvider
    extends $NotifierProvider<MarketLimitOrderTypeNotifier, OrderType> {
  const MarketLimitOrderTypeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketLimitOrderTypeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketLimitOrderTypeNotifierHash();

  @$internal
  @override
  MarketLimitOrderTypeNotifier create() => MarketLimitOrderTypeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderType>(value),
    );
  }
}

String _$marketLimitOrderTypeNotifierHash() =>
    r'89ab24438c3387f804836d2d7ab98182899bfa6f';

abstract class _$MarketLimitOrderTypeNotifier extends $Notifier<OrderType> {
  OrderType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OrderType, OrderType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OrderType, OrderType>,
              OrderType,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MarketLimitOfflineSwap)
const marketLimitOfflineSwapProvider = MarketLimitOfflineSwapProvider._();

final class MarketLimitOfflineSwapProvider
    extends $NotifierProvider<MarketLimitOfflineSwap, OfflineSwapType> {
  const MarketLimitOfflineSwapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketLimitOfflineSwapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketLimitOfflineSwapHash();

  @$internal
  @override
  MarketLimitOfflineSwap create() => MarketLimitOfflineSwap();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OfflineSwapType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OfflineSwapType>(value),
    );
  }
}

String _$marketLimitOfflineSwapHash() =>
    r'588f374bbd96127d847d6817ed61776bb2c1a032';

abstract class _$MarketLimitOfflineSwap extends $Notifier<OfflineSwapType> {
  OfflineSwapType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OfflineSwapType, OfflineSwapType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OfflineSwapType, OfflineSwapType>,
              OfflineSwapType,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(addressToShareByOrder)
const addressToShareByOrderProvider = AddressToShareByOrderFamily._();

final class AddressToShareByOrderProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const AddressToShareByOrderProvider._({
    required AddressToShareByOrderFamily super.from,
    required UiOwnOrder super.argument,
  }) : super(
         retry: null,
         name: r'addressToShareByOrderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addressToShareByOrderHash();

  @override
  String toString() {
    return r'addressToShareByOrderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as UiOwnOrder;
    return addressToShareByOrder(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AddressToShareByOrderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addressToShareByOrderHash() =>
    r'6b46f55b929ecde6444b1cdcbdf14e1498a2bd03';

final class AddressToShareByOrderFamily extends $Family
    with $FunctionalFamilyOverride<String, UiOwnOrder> {
  const AddressToShareByOrderFamily._()
    : super(
        retry: null,
        name: r'addressToShareByOrderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddressToShareByOrderProvider call(UiOwnOrder order) =>
      AddressToShareByOrderProvider._(argument: order, from: this);

  @override
  String toString() => r'addressToShareByOrderProvider';
}

@ProviderFor(MarketHistoryTotal)
const marketHistoryTotalProvider = MarketHistoryTotalProvider._();

final class MarketHistoryTotalProvider
    extends $NotifierProvider<MarketHistoryTotal, int> {
  const MarketHistoryTotalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketHistoryTotalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketHistoryTotalHash();

  @$internal
  @override
  MarketHistoryTotal create() => MarketHistoryTotal();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$marketHistoryTotalHash() =>
    r'394ab8e725c04578eee3dffe861a33f935e9b6d7';

abstract class _$MarketHistoryTotal extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MarketHistoryOrderNotifier)
const marketHistoryOrderProvider = MarketHistoryOrderNotifierProvider._();

final class MarketHistoryOrderNotifierProvider
    extends $NotifierProvider<MarketHistoryOrderNotifier, List<HistoryOrder>> {
  const MarketHistoryOrderNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketHistoryOrderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketHistoryOrderNotifierHash();

  @$internal
  @override
  MarketHistoryOrderNotifier create() => MarketHistoryOrderNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<HistoryOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<HistoryOrder>>(value),
    );
  }
}

String _$marketHistoryOrderNotifierHash() =>
    r'43296a539f0291f16675eb90f44f9e89fd1e13bb';

abstract class _$MarketHistoryOrderNotifier
    extends $Notifier<List<HistoryOrder>> {
  List<HistoryOrder> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<HistoryOrder>, List<HistoryOrder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<HistoryOrder>, List<HistoryOrder>>,
              List<HistoryOrder>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(marketUiHistoryOrders)
const marketUiHistoryOrdersProvider = MarketUiHistoryOrdersProvider._();

final class MarketUiHistoryOrdersProvider
    extends
        $FunctionalProvider<
          List<UiHistoryOrder>,
          List<UiHistoryOrder>,
          List<UiHistoryOrder>
        >
    with $Provider<List<UiHistoryOrder>> {
  const MarketUiHistoryOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketUiHistoryOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketUiHistoryOrdersHash();

  @$internal
  @override
  $ProviderElement<List<UiHistoryOrder>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<UiHistoryOrder> create(Ref ref) {
    return marketUiHistoryOrders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<UiHistoryOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<UiHistoryOrder>>(value),
    );
  }
}

String _$marketUiHistoryOrdersHash() =>
    r'01abc7ba7e016476e6a044efa01b181541570091';

@ProviderFor(orderExpireDescription)
const orderExpireDescriptionProvider = OrderExpireDescriptionFamily._();

final class OrderExpireDescriptionProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const OrderExpireDescriptionProvider._({
    required OrderExpireDescriptionFamily super.from,
    required Option<UiOwnOrder> super.argument,
  }) : super(
         retry: null,
         name: r'orderExpireDescriptionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderExpireDescriptionHash();

  @override
  String toString() {
    return r'orderExpireDescriptionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as Option<UiOwnOrder>;
    return orderExpireDescription(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OrderExpireDescriptionProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderExpireDescriptionHash() =>
    r'48a6139fd494d6210f22931be4e94dfcd5bdb7be';

final class OrderExpireDescriptionFamily extends $Family
    with $FunctionalFamilyOverride<String, Option<UiOwnOrder>> {
  const OrderExpireDescriptionFamily._()
    : super(
        retry: null,
        name: r'orderExpireDescriptionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderExpireDescriptionProvider call(Option<UiOwnOrder> optionOrder) =>
      OrderExpireDescriptionProvider._(argument: optionOrder, from: this);

  @override
  String toString() => r'orderExpireDescriptionProvider';
}

@ProviderFor(IndexPriceButtonAsyncNotifier)
const indexPriceButtonAsyncProvider = IndexPriceButtonAsyncNotifierProvider._();

final class IndexPriceButtonAsyncNotifierProvider
    extends
        $NotifierProvider<IndexPriceButtonAsyncNotifier, AsyncValue<String>> {
  const IndexPriceButtonAsyncNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'indexPriceButtonAsyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$indexPriceButtonAsyncNotifierHash();

  @$internal
  @override
  IndexPriceButtonAsyncNotifier create() => IndexPriceButtonAsyncNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<String>>(value),
    );
  }
}

String _$indexPriceButtonAsyncNotifierHash() =>
    r'ca69eb529640c9271487a2ea56fd059cdafeb536';

abstract class _$IndexPriceButtonAsyncNotifier
    extends $Notifier<AsyncValue<String>> {
  AsyncValue<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String>, AsyncValue<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, AsyncValue<String>>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MarketStartOrderNotifier)
const marketStartOrderProvider = MarketStartOrderNotifierProvider._();

final class MarketStartOrderNotifierProvider
    extends
        $NotifierProvider<MarketStartOrderNotifier, Option<From_StartOrder>> {
  const MarketStartOrderNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketStartOrderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketStartOrderNotifierHash();

  @$internal
  @override
  MarketStartOrderNotifier create() => MarketStartOrderNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<From_StartOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<From_StartOrder>>(value),
    );
  }
}

String _$marketStartOrderNotifierHash() =>
    r'e03b2c7746ca2ddfb44c7733fc6e9c799fc06f73';

abstract class _$MarketStartOrderNotifier
    extends $Notifier<Option<From_StartOrder>> {
  Option<From_StartOrder> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<Option<From_StartOrder>, Option<From_StartOrder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<From_StartOrder>, Option<From_StartOrder>>,
              Option<From_StartOrder>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MarketStartOrderErrorNotifier)
const marketStartOrderErrorProvider = MarketStartOrderErrorNotifierProvider._();

final class MarketStartOrderErrorNotifierProvider
    extends
        $NotifierProvider<
          MarketStartOrderErrorNotifier,
          Option<StartOrderError>
        > {
  const MarketStartOrderErrorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketStartOrderErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketStartOrderErrorNotifierHash();

  @$internal
  @override
  MarketStartOrderErrorNotifier create() => MarketStartOrderErrorNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<StartOrderError> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<StartOrderError>>(value),
    );
  }
}

String _$marketStartOrderErrorNotifierHash() =>
    r'ea1da45c324cea796fe6ff40c978a6ac20a55e9f';

abstract class _$MarketStartOrderErrorNotifier
    extends $Notifier<Option<StartOrderError>> {
  Option<StartOrderError> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<Option<StartOrderError>, Option<StartOrderError>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<StartOrderError>, Option<StartOrderError>>,
              Option<StartOrderError>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(marketStartOrderQuoteSuccess)
const marketStartOrderQuoteSuccessProvider =
    MarketStartOrderQuoteSuccessProvider._();

final class MarketStartOrderQuoteSuccessProvider
    extends
        $FunctionalProvider<
          Option<QuoteSuccess>,
          Option<QuoteSuccess>,
          Option<QuoteSuccess>
        >
    with $Provider<Option<QuoteSuccess>> {
  const MarketStartOrderQuoteSuccessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketStartOrderQuoteSuccessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketStartOrderQuoteSuccessHash();

  @$internal
  @override
  $ProviderElement<Option<QuoteSuccess>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<QuoteSuccess> create(Ref ref) {
    return marketStartOrderQuoteSuccess(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteSuccess> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteSuccess>>(value),
    );
  }
}

String _$marketStartOrderQuoteSuccessHash() =>
    r'c7a9f7d6f06baf5a259d8a5016c84e108c0eb710';

@ProviderFor(marketStartOrderLowBalanceError)
const marketStartOrderLowBalanceErrorProvider =
    MarketStartOrderLowBalanceErrorProvider._();

final class MarketStartOrderLowBalanceErrorProvider
    extends
        $FunctionalProvider<
          Option<QuoteLowBalance>,
          Option<QuoteLowBalance>,
          Option<QuoteLowBalance>
        >
    with $Provider<Option<QuoteLowBalance>> {
  const MarketStartOrderLowBalanceErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketStartOrderLowBalanceErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketStartOrderLowBalanceErrorHash();

  @$internal
  @override
  $ProviderElement<Option<QuoteLowBalance>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<QuoteLowBalance> create(Ref ref) {
    return marketStartOrderLowBalanceError(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteLowBalance> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteLowBalance>>(value),
    );
  }
}

String _$marketStartOrderLowBalanceErrorHash() =>
    r'ea2ca97e48945b7dad24fe3e3d2e14c0126cdd05';

@ProviderFor(marketStartOrderQuoteError)
const marketStartOrderQuoteErrorProvider =
    MarketStartOrderQuoteErrorProvider._();

final class MarketStartOrderQuoteErrorProvider
    extends
        $FunctionalProvider<
          Option<QuoteError>,
          Option<QuoteError>,
          Option<QuoteError>
        >
    with $Provider<Option<QuoteError>> {
  const MarketStartOrderQuoteErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketStartOrderQuoteErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketStartOrderQuoteErrorHash();

  @$internal
  @override
  $ProviderElement<Option<QuoteError>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<QuoteError> create(Ref ref) {
    return marketStartOrderQuoteError(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteError> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteError>>(value),
    );
  }
}

String _$marketStartOrderQuoteErrorHash() =>
    r'50058a66307e097918778796c7b17e9e8e517793';

@ProviderFor(marketStartOrderUnregisteredGaid)
const marketStartOrderUnregisteredGaidProvider =
    MarketStartOrderUnregisteredGaidProvider._();

final class MarketStartOrderUnregisteredGaidProvider
    extends
        $FunctionalProvider<
          Option<QuoteUnregisteredGaid>,
          Option<QuoteUnregisteredGaid>,
          Option<QuoteUnregisteredGaid>
        >
    with $Provider<Option<QuoteUnregisteredGaid>> {
  const MarketStartOrderUnregisteredGaidProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketStartOrderUnregisteredGaidProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketStartOrderUnregisteredGaidHash();

  @$internal
  @override
  $ProviderElement<Option<QuoteUnregisteredGaid>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<QuoteUnregisteredGaid> create(Ref ref) {
    return marketStartOrderUnregisteredGaid(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteUnregisteredGaid> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteUnregisteredGaid>>(
        value,
      ),
    );
  }
}

String _$marketStartOrderUnregisteredGaidHash() =>
    r'230609ddf96ae465abaa46af6474c402d307477e';

@ProviderFor(marketTradeRepository)
const marketTradeRepositoryProvider = MarketTradeRepositoryProvider._();

final class MarketTradeRepositoryProvider
    extends
        $FunctionalProvider<
          AbstractMarketTradeRepository,
          AbstractMarketTradeRepository,
          AbstractMarketTradeRepository
        >
    with $Provider<AbstractMarketTradeRepository> {
  const MarketTradeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketTradeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketTradeRepositoryHash();

  @$internal
  @override
  $ProviderElement<AbstractMarketTradeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AbstractMarketTradeRepository create(Ref ref) {
    return marketTradeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AbstractMarketTradeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AbstractMarketTradeRepository>(
        value,
      ),
    );
  }
}

String _$marketTradeRepositoryHash() =>
    r'dc3cf0dfe476b780fe5537aa2fb5d64f77206813';

@ProviderFor(MarketMinimalAmountsNotfier)
const marketMinimalAmountsNotfierProvider =
    MarketMinimalAmountsNotfierProvider._();

final class MarketMinimalAmountsNotfierProvider
    extends $NotifierProvider<MarketMinimalAmountsNotfier, Map<String, int>> {
  const MarketMinimalAmountsNotfierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketMinimalAmountsNotfierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketMinimalAmountsNotfierHash();

  @$internal
  @override
  MarketMinimalAmountsNotfier create() => MarketMinimalAmountsNotfier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, int>>(value),
    );
  }
}

String _$marketMinimalAmountsNotfierHash() =>
    r'f5c08326d9de968c56c855822b3d5d4196ff3dbf';

abstract class _$MarketMinimalAmountsNotfier
    extends $Notifier<Map<String, int>> {
  Map<String, int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<String, int>, Map<String, int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, int>, Map<String, int>>,
              Map<String, int>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(limitFeeAsset)
const limitFeeAssetProvider = LimitFeeAssetProvider._();

final class LimitFeeAssetProvider
    extends $FunctionalProvider<Option<Asset>, Option<Asset>, Option<Asset>>
    with $Provider<Option<Asset>> {
  const LimitFeeAssetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitFeeAssetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$limitFeeAssetHash();

  @$internal
  @override
  $ProviderElement<Option<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<Asset> create(Ref ref) {
    return limitFeeAsset(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<Asset>>(value),
    );
  }
}

String _$limitFeeAssetHash() => r'1a882be15d4d90369c2cc7e6bbf4817b026a4dc5';

@ProviderFor(limitMinimumFeeAmount)
const limitMinimumFeeAmountProvider = LimitMinimumFeeAmountProvider._();

final class LimitMinimumFeeAmountProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const LimitMinimumFeeAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitMinimumFeeAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$limitMinimumFeeAmountHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return limitMinimumFeeAmount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$limitMinimumFeeAmountHash() =>
    r'b2e3574a7ef52cb36f9bc6eeb41b166e75152f2d';

@ProviderFor(limitInsufficientAmount)
const limitInsufficientAmountProvider = LimitInsufficientAmountProvider._();

final class LimitInsufficientAmountProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const LimitInsufficientAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitInsufficientAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$limitInsufficientAmountHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return limitInsufficientAmount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$limitInsufficientAmountHash() =>
    r'e170c0a04513a3fd2ebc840dcc1c68a96063c8b8';

@ProviderFor(limitInsufficientPrice)
const limitInsufficientPriceProvider = LimitInsufficientPriceProvider._();

final class LimitInsufficientPriceProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const LimitInsufficientPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitInsufficientPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$limitInsufficientPriceHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return limitInsufficientPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$limitInsufficientPriceHash() =>
    r'1d37576878ae5af25a154f3921c110570b8f6297';

@ProviderFor(marketOrderButtonText)
const marketOrderButtonTextProvider = MarketOrderButtonTextProvider._();

final class MarketOrderButtonTextProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const MarketOrderButtonTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketOrderButtonTextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketOrderButtonTextHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return marketOrderButtonText(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$marketOrderButtonTextHash() =>
    r'6952e77b5990cabf446aeac7a34944ccff33c621';

/// Aggregated volume

@ProviderFor(marketLimitOrderAggregateVolume)
const marketLimitOrderAggregateVolumeProvider =
    MarketLimitOrderAggregateVolumeProvider._();

/// Aggregated volume

final class MarketLimitOrderAggregateVolumeProvider
    extends
        $FunctionalProvider<
          MarketOrderAggregateVolumeProvider,
          MarketOrderAggregateVolumeProvider,
          MarketOrderAggregateVolumeProvider
        >
    with $Provider<MarketOrderAggregateVolumeProvider> {
  /// Aggregated volume
  const MarketLimitOrderAggregateVolumeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketLimitOrderAggregateVolumeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketLimitOrderAggregateVolumeHash();

  @$internal
  @override
  $ProviderElement<MarketOrderAggregateVolumeProvider> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MarketOrderAggregateVolumeProvider create(Ref ref) {
    return marketLimitOrderAggregateVolume(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarketOrderAggregateVolumeProvider value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarketOrderAggregateVolumeProvider>(
        value,
      ),
    );
  }
}

String _$marketLimitOrderAggregateVolumeHash() =>
    r'53e474a4ff006a6de8c4d044ff5b21b2711569a0';

@ProviderFor(marketLimitOrderAggregatedVolumeWithTicker)
const marketLimitOrderAggregatedVolumeWithTickerProvider =
    MarketLimitOrderAggregatedVolumeWithTickerProvider._();

final class MarketLimitOrderAggregatedVolumeWithTickerProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const MarketLimitOrderAggregatedVolumeWithTickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketLimitOrderAggregatedVolumeWithTickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$marketLimitOrderAggregatedVolumeWithTickerHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return marketLimitOrderAggregatedVolumeWithTicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$marketLimitOrderAggregatedVolumeWithTickerHash() =>
    r'b5d0e314dc4a2c2098e5644d11fb7ee4b9d18a90';

@ProviderFor(marketLimitOrderAggregateVolumeTooHigh)
const marketLimitOrderAggregateVolumeTooHighProvider =
    MarketLimitOrderAggregateVolumeTooHighProvider._();

final class MarketLimitOrderAggregateVolumeTooHighProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const MarketLimitOrderAggregateVolumeTooHighProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketLimitOrderAggregateVolumeTooHighProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$marketLimitOrderAggregateVolumeTooHighHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return marketLimitOrderAggregateVolumeTooHigh(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$marketLimitOrderAggregateVolumeTooHighHash() =>
    r'389528403214c27b75e20b5b0296711f43e8dce0';

@ProviderFor(marketLimitPriceBalance)
const marketLimitPriceBalanceProvider = MarketLimitPriceBalanceProvider._();

final class MarketLimitPriceBalanceProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const MarketLimitPriceBalanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketLimitPriceBalanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketLimitPriceBalanceHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return marketLimitPriceBalance(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$marketLimitPriceBalanceHash() =>
    r'498a8fd229eff17dd1cbf012b2eb3c565f317f37';

@ProviderFor(marketLimitAmountBalance)
const marketLimitAmountBalanceProvider = MarketLimitAmountBalanceProvider._();

final class MarketLimitAmountBalanceProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const MarketLimitAmountBalanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketLimitAmountBalanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketLimitAmountBalanceHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return marketLimitAmountBalance(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$marketLimitAmountBalanceHash() =>
    r'3e43a7dcae0778fdf0dd00fc5359c8497c8e6389';
