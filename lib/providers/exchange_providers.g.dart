// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(exchangeSide)
const exchangeSideProvider = ExchangeSideProvider._();

final class ExchangeSideProvider
    extends
        $FunctionalProvider<
          Option<ExchangeSide>,
          Option<ExchangeSide>,
          Option<ExchangeSide>
        >
    with $Provider<Option<ExchangeSide>> {
  const ExchangeSideProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeSideProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeSideHash();

  @$internal
  @override
  $ProviderElement<Option<ExchangeSide>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<ExchangeSide> create(Ref ref) {
    return exchangeSide(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<ExchangeSide> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<ExchangeSide>>(value),
    );
  }
}

String _$exchangeSideHash() => r'aa4b82aadb0eeaf523d94d7010d6945d24bc9ddd';

@ProviderFor(ExchangeCurrentEditAsset)
const exchangeCurrentEditAssetProvider = ExchangeCurrentEditAssetProvider._();

final class ExchangeCurrentEditAssetProvider
    extends $NotifierProvider<ExchangeCurrentEditAsset, Option<Asset>> {
  const ExchangeCurrentEditAssetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeCurrentEditAssetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeCurrentEditAssetHash();

  @$internal
  @override
  ExchangeCurrentEditAsset create() => ExchangeCurrentEditAsset();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<Asset>>(value),
    );
  }
}

String _$exchangeCurrentEditAssetHash() =>
    r'a26b92c2144b9147e4072b1403614610d838e2ee';

abstract class _$ExchangeCurrentEditAsset extends $Notifier<Option<Asset>> {
  Option<Asset> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<Asset>, Option<Asset>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<Asset>, Option<Asset>>,
              Option<Asset>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(exchangeAssetPair)
const exchangeAssetPairProvider = ExchangeAssetPairProvider._();

final class ExchangeAssetPairProvider
    extends
        $FunctionalProvider<
          Option<AssetPair>,
          Option<AssetPair>,
          Option<AssetPair>
        >
    with $Provider<Option<AssetPair>> {
  const ExchangeAssetPairProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeAssetPairProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeAssetPairHash();

  @$internal
  @override
  $ProviderElement<Option<AssetPair>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<AssetPair> create(Ref ref) {
    return exchangeAssetPair(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<AssetPair> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<AssetPair>>(value),
    );
  }
}

String _$exchangeAssetPairHash() => r'4992d1e3e771c9ab6ded705ab8998e14730693b2';

@ProviderFor(exchangeMarketInfo)
const exchangeMarketInfoProvider = ExchangeMarketInfoProvider._();

final class ExchangeMarketInfoProvider
    extends
        $FunctionalProvider<
          Option<MarketInfo>,
          Option<MarketInfo>,
          Option<MarketInfo>
        >
    with $Provider<Option<MarketInfo>> {
  const ExchangeMarketInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeMarketInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeMarketInfoHash();

  @$internal
  @override
  $ProviderElement<Option<MarketInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<MarketInfo> create(Ref ref) {
    return exchangeMarketInfo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<MarketInfo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<MarketInfo>>(value),
    );
  }
}

String _$exchangeMarketInfoHash() =>
    r'660fd641b50b1e1e287c85b65391aef3b4581cce';

@ProviderFor(exchangeTopAssetList)
const exchangeTopAssetListProvider = ExchangeTopAssetListProvider._();

final class ExchangeTopAssetListProvider
    extends $FunctionalProvider<List<Asset>, List<Asset>, List<Asset>>
    with $Provider<List<Asset>> {
  const ExchangeTopAssetListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeTopAssetListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeTopAssetListHash();

  @$internal
  @override
  $ProviderElement<List<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Asset> create(Ref ref) {
    return exchangeTopAssetList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Asset>>(value),
    );
  }
}

String _$exchangeTopAssetListHash() =>
    r'2bc47cd12c3690104b0930202e2ea1925850b22f';

@ProviderFor(ExchangeTopAsset)
const exchangeTopAssetProvider = ExchangeTopAssetProvider._();

final class ExchangeTopAssetProvider
    extends $NotifierProvider<ExchangeTopAsset, Option<Asset>> {
  const ExchangeTopAssetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeTopAssetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeTopAssetHash();

  @$internal
  @override
  ExchangeTopAsset create() => ExchangeTopAsset();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<Asset>>(value),
    );
  }
}

String _$exchangeTopAssetHash() => r'77b24c3966258c37f77eba9cb1b0e1dce64dfe65';

abstract class _$ExchangeTopAsset extends $Notifier<Option<Asset>> {
  Option<Asset> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<Asset>, Option<Asset>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<Asset>, Option<Asset>>,
              Option<Asset>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(exchangeBottomAssetList)
const exchangeBottomAssetListProvider = ExchangeBottomAssetListProvider._();

final class ExchangeBottomAssetListProvider
    extends $FunctionalProvider<List<Asset>, List<Asset>, List<Asset>>
    with $Provider<List<Asset>> {
  const ExchangeBottomAssetListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeBottomAssetListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeBottomAssetListHash();

  @$internal
  @override
  $ProviderElement<List<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Asset> create(Ref ref) {
    return exchangeBottomAssetList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Asset>>(value),
    );
  }
}

String _$exchangeBottomAssetListHash() =>
    r'7073444a6a0776c4734d620ae8328734b325143d';

@ProviderFor(ExchangeBottomAsset)
const exchangeBottomAssetProvider = ExchangeBottomAssetProvider._();

final class ExchangeBottomAssetProvider
    extends $NotifierProvider<ExchangeBottomAsset, Option<Asset>> {
  const ExchangeBottomAssetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeBottomAssetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeBottomAssetHash();

  @$internal
  @override
  ExchangeBottomAsset create() => ExchangeBottomAsset();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<Asset>>(value),
    );
  }
}

String _$exchangeBottomAssetHash() =>
    r'9bd5779fdbc265fa9b99be9077b3c7b76cc589d0';

abstract class _$ExchangeBottomAsset extends $Notifier<Option<Asset>> {
  Option<Asset> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<Asset>, Option<Asset>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<Asset>, Option<Asset>>,
              Option<Asset>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ExchangeTopAmount)
const exchangeTopAmountProvider = ExchangeTopAmountProvider._();

final class ExchangeTopAmountProvider
    extends $NotifierProvider<ExchangeTopAmount, String> {
  const ExchangeTopAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeTopAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeTopAmountHash();

  @$internal
  @override
  ExchangeTopAmount create() => ExchangeTopAmount();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$exchangeTopAmountHash() => r'ebc10cc151a7de0208910b9b131cdeb642499cb8';

abstract class _$ExchangeTopAmount extends $Notifier<String> {
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

@ProviderFor(exchangeTopSatoshiAmount)
const exchangeTopSatoshiAmountProvider = ExchangeTopSatoshiAmountProvider._();

final class ExchangeTopSatoshiAmountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const ExchangeTopSatoshiAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeTopSatoshiAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeTopSatoshiAmountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return exchangeTopSatoshiAmount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$exchangeTopSatoshiAmountHash() =>
    r'13d54e5b892c92c78eb4b44b7d7719c659e39a14';

@ProviderFor(exchangeTopDebounceSatoshiAmount)
const exchangeTopDebounceSatoshiAmountProvider =
    ExchangeTopDebounceSatoshiAmountProvider._();

final class ExchangeTopDebounceSatoshiAmountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  const ExchangeTopDebounceSatoshiAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeTopDebounceSatoshiAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeTopDebounceSatoshiAmountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return exchangeTopDebounceSatoshiAmount(ref);
  }
}

String _$exchangeTopDebounceSatoshiAmountHash() =>
    r'1b9531f37400e3a50bf9a3bd2a31a3ea46bd14ee';

@ProviderFor(ExchangeBottomAmount)
const exchangeBottomAmountProvider = ExchangeBottomAmountProvider._();

final class ExchangeBottomAmountProvider
    extends $NotifierProvider<ExchangeBottomAmount, String> {
  const ExchangeBottomAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeBottomAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeBottomAmountHash();

  @$internal
  @override
  ExchangeBottomAmount create() => ExchangeBottomAmount();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$exchangeBottomAmountHash() =>
    r'ea2996d7a2f93fa3c48e5b5086d41e82e8030fe8';

abstract class _$ExchangeBottomAmount extends $Notifier<String> {
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

@ProviderFor(exchangeBottomSatoshiAmount)
const exchangeBottomSatoshiAmountProvider =
    ExchangeBottomSatoshiAmountProvider._();

final class ExchangeBottomSatoshiAmountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const ExchangeBottomSatoshiAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeBottomSatoshiAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeBottomSatoshiAmountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return exchangeBottomSatoshiAmount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$exchangeBottomSatoshiAmountHash() =>
    r'245e48555169e6cb2940a6e0bcac068800e1bc89';

@ProviderFor(exchangeBottomDebounceSatoshiAmount)
const exchangeBottomDebounceSatoshiAmountProvider =
    ExchangeBottomDebounceSatoshiAmountProvider._();

final class ExchangeBottomDebounceSatoshiAmountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  const ExchangeBottomDebounceSatoshiAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeBottomDebounceSatoshiAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$exchangeBottomDebounceSatoshiAmountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return exchangeBottomDebounceSatoshiAmount(ref);
  }
}

String _$exchangeBottomDebounceSatoshiAmountHash() =>
    r'27b06b30bf9a5bce424ea31ffd6c30d2d1ad1dd0';

/// Exchange quotes

@ProviderFor(ExchangeQuoteNotifier)
const exchangeQuoteProvider = ExchangeQuoteNotifierProvider._();

/// Exchange quotes
final class ExchangeQuoteNotifierProvider
    extends $NotifierProvider<ExchangeQuoteNotifier, Option<From_Quote>> {
  /// Exchange quotes
  const ExchangeQuoteNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeQuoteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeQuoteNotifierHash();

  @$internal
  @override
  ExchangeQuoteNotifier create() => ExchangeQuoteNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<From_Quote> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<From_Quote>>(value),
    );
  }
}

String _$exchangeQuoteNotifierHash() =>
    r'cc08c7a3a5f7a187efc7e8587d03fab0ab81403f';

/// Exchange quotes

abstract class _$ExchangeQuoteNotifier extends $Notifier<Option<From_Quote>> {
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

@ProviderFor(exchangeSwapButtonText)
const exchangeSwapButtonTextProvider = ExchangeSwapButtonTextProvider._();

final class ExchangeSwapButtonTextProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const ExchangeSwapButtonTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeSwapButtonTextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeSwapButtonTextHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return exchangeSwapButtonText(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$exchangeSwapButtonTextHash() =>
    r'08565ef0e723679ce66922958b4fa5d2f1996217';

@ProviderFor(exchangeQuoteError)
const exchangeQuoteErrorProvider = ExchangeQuoteErrorProvider._();

final class ExchangeQuoteErrorProvider
    extends
        $FunctionalProvider<
          Option<QuoteError>,
          Option<QuoteError>,
          Option<QuoteError>
        >
    with $Provider<Option<QuoteError>> {
  const ExchangeQuoteErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeQuoteErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeQuoteErrorHash();

  @$internal
  @override
  $ProviderElement<Option<QuoteError>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<QuoteError> create(Ref ref) {
    return exchangeQuoteError(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteError> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteError>>(value),
    );
  }
}

String _$exchangeQuoteErrorHash() =>
    r'a592a254996238b1cc8db72df58f7943c677a7aa';

@ProviderFor(instantSwapTopDropdownError)
const instantSwapTopDropdownErrorProvider =
    InstantSwapTopDropdownErrorProvider._();

final class InstantSwapTopDropdownErrorProvider
    extends $FunctionalProvider<Option<String>, Option<String>, Option<String>>
    with $Provider<Option<String>> {
  const InstantSwapTopDropdownErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instantSwapTopDropdownErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instantSwapTopDropdownErrorHash();

  @$internal
  @override
  $ProviderElement<Option<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<String> create(Ref ref) {
    return instantSwapTopDropdownError(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<String>>(value),
    );
  }
}

String _$instantSwapTopDropdownErrorHash() =>
    r'e27144b3cbf56d9160d6dbb03a748ed1e866d8dd';

@ProviderFor(ExchangeIndexPrice)
const exchangeIndexPriceProvider = ExchangeIndexPriceProvider._();

final class ExchangeIndexPriceProvider
    extends $NotifierProvider<ExchangeIndexPrice, Option<QuoteIndexPrice>> {
  const ExchangeIndexPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeIndexPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeIndexPriceHash();

  @$internal
  @override
  ExchangeIndexPrice create() => ExchangeIndexPrice();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteIndexPrice> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteIndexPrice>>(value),
    );
  }
}

String _$exchangeIndexPriceHash() =>
    r'02ccc14c935776c47e76c2ce63fd987d4b9d67ab';

abstract class _$ExchangeIndexPrice extends $Notifier<Option<QuoteIndexPrice>> {
  Option<QuoteIndexPrice> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<Option<QuoteIndexPrice>, Option<QuoteIndexPrice>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<QuoteIndexPrice>, Option<QuoteIndexPrice>>,
              Option<QuoteIndexPrice>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(exchangeLowBalanceError)
const exchangeLowBalanceErrorProvider = ExchangeLowBalanceErrorProvider._();

final class ExchangeLowBalanceErrorProvider
    extends
        $FunctionalProvider<
          Option<QuoteLowBalance>,
          Option<QuoteLowBalance>,
          Option<QuoteLowBalance>
        >
    with $Provider<Option<QuoteLowBalance>> {
  const ExchangeLowBalanceErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeLowBalanceErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeLowBalanceErrorHash();

  @$internal
  @override
  $ProviderElement<Option<QuoteLowBalance>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<QuoteLowBalance> create(Ref ref) {
    return exchangeLowBalanceError(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteLowBalance> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteLowBalance>>(value),
    );
  }
}

String _$exchangeLowBalanceErrorHash() =>
    r'1358062c2208d6a2cab986f512ee9b8279f6ee95';

@ProviderFor(exchangeQuoteSuccess)
const exchangeQuoteSuccessProvider = ExchangeQuoteSuccessProvider._();

final class ExchangeQuoteSuccessProvider
    extends
        $FunctionalProvider<
          Option<QuoteSuccess>,
          Option<QuoteSuccess>,
          Option<QuoteSuccess>
        >
    with $Provider<Option<QuoteSuccess>> {
  const ExchangeQuoteSuccessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeQuoteSuccessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeQuoteSuccessHash();

  @$internal
  @override
  $ProviderElement<Option<QuoteSuccess>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<QuoteSuccess> create(Ref ref) {
    return exchangeQuoteSuccess(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteSuccess> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteSuccess>>(value),
    );
  }
}

String _$exchangeQuoteSuccessHash() =>
    r'4d31b84cc1ed72b34265708b225aa3f821001ff1';

@ProviderFor(exchangeSwapButtonEnabled)
const exchangeSwapButtonEnabledProvider = ExchangeSwapButtonEnabledProvider._();

final class ExchangeSwapButtonEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const ExchangeSwapButtonEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeSwapButtonEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeSwapButtonEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return exchangeSwapButtonEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$exchangeSwapButtonEnabledHash() =>
    r'014042985d16b3e1050569b8e1065d30dff56360';

@ProviderFor(ExchangeAccepQuoteStateNotifier)
const exchangeAccepQuoteStateProvider =
    ExchangeAccepQuoteStateNotifierProvider._();

final class ExchangeAccepQuoteStateNotifierProvider
    extends
        $NotifierProvider<
          ExchangeAccepQuoteStateNotifier,
          ExchangeAcceptQuoteState
        > {
  const ExchangeAccepQuoteStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeAccepQuoteStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeAccepQuoteStateNotifierHash();

  @$internal
  @override
  ExchangeAccepQuoteStateNotifier create() => ExchangeAccepQuoteStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExchangeAcceptQuoteState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExchangeAcceptQuoteState>(value),
    );
  }
}

String _$exchangeAccepQuoteStateNotifierHash() =>
    r'c2de54ad043efd4e788ce50b6119db18f5949a78';

abstract class _$ExchangeAccepQuoteStateNotifier
    extends $Notifier<ExchangeAcceptQuoteState> {
  ExchangeAcceptQuoteState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<ExchangeAcceptQuoteState, ExchangeAcceptQuoteState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExchangeAcceptQuoteState, ExchangeAcceptQuoteState>,
              ExchangeAcceptQuoteState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(exchangeAcceptQuote)
const exchangeAcceptQuoteProvider = ExchangeAcceptQuoteProvider._();

final class ExchangeAcceptQuoteProvider
    extends
        $FunctionalProvider<
          Option<From_AcceptQuote>,
          Option<From_AcceptQuote>,
          Option<From_AcceptQuote>
        >
    with $Provider<Option<From_AcceptQuote>> {
  const ExchangeAcceptQuoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeAcceptQuoteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeAcceptQuoteHash();

  @$internal
  @override
  $ProviderElement<Option<From_AcceptQuote>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<From_AcceptQuote> create(Ref ref) {
    return exchangeAcceptQuote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<From_AcceptQuote> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<From_AcceptQuote>>(value),
    );
  }
}

String _$exchangeAcceptQuoteHash() =>
    r'2d9de1c021b9906a28993e4906b3d23ec369de84';

@ProviderFor(exchangeAcceptQuoteSuccess)
const exchangeAcceptQuoteSuccessProvider =
    ExchangeAcceptQuoteSuccessProvider._();

final class ExchangeAcceptQuoteSuccessProvider
    extends $FunctionalProvider<Option<String>, Option<String>, Option<String>>
    with $Provider<Option<String>> {
  const ExchangeAcceptQuoteSuccessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeAcceptQuoteSuccessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeAcceptQuoteSuccessHash();

  @$internal
  @override
  $ProviderElement<Option<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<String> create(Ref ref) {
    return exchangeAcceptQuoteSuccess(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<String>>(value),
    );
  }
}

String _$exchangeAcceptQuoteSuccessHash() =>
    r'f11bc2d8a43e9eb914d357dacd0005d0f4fff056';

@ProviderFor(exchangeAcceptQuoteError)
const exchangeAcceptQuoteErrorProvider = ExchangeAcceptQuoteErrorProvider._();

final class ExchangeAcceptQuoteErrorProvider
    extends $FunctionalProvider<Option<String>, Option<String>, Option<String>>
    with $Provider<Option<String>> {
  const ExchangeAcceptQuoteErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeAcceptQuoteErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeAcceptQuoteErrorHash();

  @$internal
  @override
  $ProviderElement<Option<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<String> create(Ref ref) {
    return exchangeAcceptQuoteError(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<String>>(value),
    );
  }
}

String _$exchangeAcceptQuoteErrorHash() =>
    r'cafa891c5446866609ecc2cd2b3f0fc1f86717b8';

@ProviderFor(InstantSwapStateNotifier)
const instantSwapStateProvider = InstantSwapStateNotifierProvider._();

final class InstantSwapStateNotifierProvider
    extends $NotifierProvider<InstantSwapStateNotifier, InstantSwapState> {
  const InstantSwapStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instantSwapStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instantSwapStateNotifierHash();

  @$internal
  @override
  InstantSwapStateNotifier create() => InstantSwapStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InstantSwapState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InstantSwapState>(value),
    );
  }
}

String _$instantSwapStateNotifierHash() =>
    r'c526c298648b046a08c7c549ea4121129ad70468';

abstract class _$InstantSwapStateNotifier extends $Notifier<InstantSwapState> {
  InstantSwapState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<InstantSwapState, InstantSwapState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InstantSwapState, InstantSwapState>,
              InstantSwapState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(InstantSwapQuoteSuccessNotifier)
const instantSwapQuoteSuccessProvider =
    InstantSwapQuoteSuccessNotifierProvider._();

final class InstantSwapQuoteSuccessNotifierProvider
    extends
        $NotifierProvider<
          InstantSwapQuoteSuccessNotifier,
          Option<QuoteSuccess>
        > {
  const InstantSwapQuoteSuccessNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instantSwapQuoteSuccessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instantSwapQuoteSuccessNotifierHash();

  @$internal
  @override
  InstantSwapQuoteSuccessNotifier create() => InstantSwapQuoteSuccessNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteSuccess> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteSuccess>>(value),
    );
  }
}

String _$instantSwapQuoteSuccessNotifierHash() =>
    r'6cbe51e4c761ea6fb873f7582122d73c83175cdf';

abstract class _$InstantSwapQuoteSuccessNotifier
    extends $Notifier<Option<QuoteSuccess>> {
  Option<QuoteSuccess> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<QuoteSuccess>, Option<QuoteSuccess>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<QuoteSuccess>, Option<QuoteSuccess>>,
              Option<QuoteSuccess>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(instantSwapDisabledAmount)
const instantSwapDisabledAmountProvider = InstantSwapDisabledAmountProvider._();

final class InstantSwapDisabledAmountProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const InstantSwapDisabledAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instantSwapDisabledAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instantSwapDisabledAmountHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return instantSwapDisabledAmount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$instantSwapDisabledAmountHash() =>
    r'3efac6cd116f2783ec4bd02f9e735bb80dd5befa';

@ProviderFor(instantSwapDisabledDropdown)
const instantSwapDisabledDropdownProvider =
    InstantSwapDisabledDropdownProvider._();

final class InstantSwapDisabledDropdownProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const InstantSwapDisabledDropdownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instantSwapDisabledDropdownProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instantSwapDisabledDropdownHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return instantSwapDisabledDropdown(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$instantSwapDisabledDropdownHash() =>
    r'9c094bd32e86115a7e87f04a5a06ffa2da2251c4';
