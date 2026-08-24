// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_assets_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bitcoinAssetId)
final bitcoinAssetIdProvider = BitcoinAssetIdProvider._();

final class BitcoinAssetIdProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  BitcoinAssetIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bitcoinAssetIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bitcoinAssetIdHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return bitcoinAssetId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$bitcoinAssetIdHash() => r'ab5ab5393629fbc1cd35fa94391e71a8d0847f81';

@ProviderFor(LiquidAssetIdState)
final liquidAssetIdStateProvider = LiquidAssetIdStateProvider._();

final class LiquidAssetIdStateProvider
    extends $NotifierProvider<LiquidAssetIdState, String> {
  LiquidAssetIdStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liquidAssetIdStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liquidAssetIdStateHash();

  @$internal
  @override
  LiquidAssetIdState create() => LiquidAssetIdState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$liquidAssetIdStateHash() =>
    r'0993e2408473de0a738dd0d0b42e264cac3165df';

abstract class _$LiquidAssetIdState extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(TetherAssetIdState)
final tetherAssetIdStateProvider = TetherAssetIdStateProvider._();

final class TetherAssetIdStateProvider
    extends $NotifierProvider<TetherAssetIdState, String> {
  TetherAssetIdStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tetherAssetIdStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tetherAssetIdStateHash();

  @$internal
  @override
  TetherAssetIdState create() => TetherAssetIdState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$tetherAssetIdStateHash() =>
    r'e4920c1b459cbd9addf44bfebe876536c0457b16';

abstract class _$TetherAssetIdState extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(EurxAssetIdState)
final eurxAssetIdStateProvider = EurxAssetIdStateProvider._();

final class EurxAssetIdStateProvider
    extends $NotifierProvider<EurxAssetIdState, String> {
  EurxAssetIdStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eurxAssetIdStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eurxAssetIdStateHash();

  @$internal
  @override
  EurxAssetIdState create() => EurxAssetIdState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$eurxAssetIdStateHash() => r'cea1a4f1317dc16e9e42c2543172f534892091d6';

abstract class _$EurxAssetIdState extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AmpAssetIdsNotifier)
final ampAssetIdsProvider = AmpAssetIdsNotifierProvider._();

final class AmpAssetIdsNotifierProvider
    extends $NotifierProvider<AmpAssetIdsNotifier, List<String>> {
  AmpAssetIdsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ampAssetIdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ampAssetIdsNotifierHash();

  @$internal
  @override
  AmpAssetIdsNotifier create() => AmpAssetIdsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$ampAssetIdsNotifierHash() =>
    r'973d5b8e615d5b47cc72b9780cb2e5430b323c75';

abstract class _$AmpAssetIdsNotifier extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AssetsState)
final assetsStateProvider = AssetsStateProvider._();

final class AssetsStateProvider
    extends $NotifierProvider<AssetsState, Map<String, Asset>> {
  AssetsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetsStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetsStateHash();

  @$internal
  @override
  AssetsState create() => AssetsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Asset>>(value),
    );
  }
}

String _$assetsStateHash() => r'dc3b5abcf0d3131d19106f41aec18f3f81421f97';

abstract class _$AssetsState extends $Notifier<Map<String, Asset>> {
  Map<String, Asset> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<String, Asset>, Map<String, Asset>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, Asset>, Map<String, Asset>>,
              Map<String, Asset>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(assets)
final assetsProvider = AssetsProvider._();

final class AssetsProvider
    extends
        $FunctionalProvider<Iterable<Asset>, Iterable<Asset>, Iterable<Asset>>
    with $Provider<Iterable<Asset>> {
  AssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetsHash();

  @$internal
  @override
  $ProviderElement<Iterable<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Iterable<Asset> create(Ref ref) {
    return assets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<Asset>>(value),
    );
  }
}

String _$assetsHash() => r'8c124724af564e592ba0632abcef778f8aab2bea';

@ProviderFor(assetFromAssetId)
final assetFromAssetIdProvider = AssetFromAssetIdFamily._();

final class AssetFromAssetIdProvider
    extends $FunctionalProvider<Option<Asset>, Option<Asset>, Option<Asset>>
    with $Provider<Option<Asset>> {
  AssetFromAssetIdProvider._({
    required AssetFromAssetIdFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'assetFromAssetIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$assetFromAssetIdHash();

  @override
  String toString() {
    return r'assetFromAssetIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Option<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<Asset> create(Ref ref) {
    final argument = this.argument as String?;
    return assetFromAssetId(ref, argument);
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
    return other is AssetFromAssetIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$assetFromAssetIdHash() => r'b72841dbd1056e3de308d8a84b47822c12263170';

final class AssetFromAssetIdFamily extends $Family
    with $FunctionalFamilyOverride<Option<Asset>, String?> {
  AssetFromAssetIdFamily._()
    : super(
        retry: null,
        name: r'assetFromAssetIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AssetFromAssetIdProvider call(String? assetId) =>
      AssetFromAssetIdProvider._(argument: assetId, from: this);

  @override
  String toString() => r'assetFromAssetIdProvider';
}

@ProviderFor(assetUtils)
final assetUtilsProvider = AssetUtilsProvider._();

final class AssetUtilsProvider
    extends $FunctionalProvider<AssetUtils, AssetUtils, AssetUtils>
    with $Provider<AssetUtils> {
  AssetUtilsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetUtilsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetUtilsHash();

  @$internal
  @override
  $ProviderElement<AssetUtils> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AssetUtils create(Ref ref) {
    return assetUtils(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetUtils value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetUtils>(value),
    );
  }
}

String _$assetUtilsHash() => r'3ab23b14fed091938634c0c8d49080f197bcc2d5';

@ProviderFor(imageCacheConfig)
final imageCacheConfigProvider = ImageCacheConfigProvider._();

final class ImageCacheConfigProvider
    extends $FunctionalProvider<Config, Config, Config>
    with $Provider<Config> {
  ImageCacheConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageCacheConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageCacheConfigHash();

  @$internal
  @override
  $ProviderElement<Config> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Config create(Ref ref) {
    return imageCacheConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Config value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Config>(value),
    );
  }
}

String _$imageCacheConfigHash() => r'f224e4fd21d4dcd5c23a47c75c0d78ef0446a953';

@ProviderFor(cacheManager)
final cacheManagerProvider = CacheManagerProvider._();

final class CacheManagerProvider
    extends $FunctionalProvider<CacheManager, CacheManager, CacheManager>
    with $Provider<CacheManager> {
  CacheManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheManagerHash();

  @$internal
  @override
  $ProviderElement<CacheManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CacheManager create(Ref ref) {
    return cacheManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CacheManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CacheManager>(value),
    );
  }
}

String _$cacheManagerHash() => r'7d465b2a6fadeec896a8d3cfca918a582ea038b4';

@ProviderFor(cachedImageManager)
final cachedImageManagerProvider = CachedImageManagerProvider._();

final class CachedImageManagerProvider
    extends
        $FunctionalProvider<
          CachedImageBase64Manager,
          CachedImageBase64Manager,
          CachedImageBase64Manager
        >
    with $Provider<CachedImageBase64Manager> {
  CachedImageManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cachedImageManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cachedImageManagerHash();

  @$internal
  @override
  $ProviderElement<CachedImageBase64Manager> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CachedImageBase64Manager create(Ref ref) {
    return cachedImageManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CachedImageBase64Manager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CachedImageBase64Manager>(value),
    );
  }
}

String _$cachedImageManagerHash() =>
    r'0eb7658243703a883423f52915e0ec0fc998af9e';

@ProviderFor(clearImageCacheFuture)
final clearImageCacheFutureProvider = ClearImageCacheFutureProvider._();

final class ClearImageCacheFutureProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  ClearImageCacheFutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clearImageCacheFutureProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clearImageCacheFutureHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return clearImageCacheFuture(ref);
  }
}

String _$clearImageCacheFutureHash() =>
    r'ec01d17910dbfa5b87607209ccf50243b9873f85';

@ProviderFor(builtinAssets)
final builtinAssetsProvider = BuiltinAssetsProvider._();

final class BuiltinAssetsProvider
    extends
        $FunctionalProvider<
          Map<String, Asset>,
          Map<String, Asset>,
          Map<String, Asset>
        >
    with $Provider<Map<String, Asset>> {
  BuiltinAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'builtinAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$builtinAssetsHash();

  @$internal
  @override
  $ProviderElement<Map<String, Asset>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, Asset> create(Ref ref) {
    return builtinAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Asset>>(value),
    );
  }
}

String _$builtinAssetsHash() => r'747435613ca20555dcac7dde1b8cb10fe604d7c2';

@ProviderFor(imageBytesResizedFuture)
final imageBytesResizedFutureProvider = ImageBytesResizedFutureFamily._();

final class ImageBytesResizedFutureProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List?>,
          Uint8List?,
          FutureOr<Uint8List?>
        >
    with $FutureModifier<Uint8List?>, $FutureProvider<Uint8List?> {
  ImageBytesResizedFutureProvider._({
    required ImageBytesResizedFutureFamily super.from,
    required ({
      String uniqueKey,
      String? assetSvg,
      String? base64,
      double width,
      double height,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'imageBytesResizedFutureProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$imageBytesResizedFutureHash();

  @override
  String toString() {
    return r'imageBytesResizedFutureProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List?> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String uniqueKey,
              String? assetSvg,
              String? base64,
              double width,
              double height,
            });
    return imageBytesResizedFuture(
      ref,
      uniqueKey: argument.uniqueKey,
      assetSvg: argument.assetSvg,
      base64: argument.base64,
      width: argument.width,
      height: argument.height,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ImageBytesResizedFutureProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$imageBytesResizedFutureHash() =>
    r'd9569c8a2a20bbc9174da5ea71dd74afc3710b39';

final class ImageBytesResizedFutureFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Uint8List?>,
          ({
            String uniqueKey,
            String? assetSvg,
            String? base64,
            double width,
            double height,
          })
        > {
  ImageBytesResizedFutureFamily._()
    : super(
        retry: null,
        name: r'imageBytesResizedFutureProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ImageBytesResizedFutureProvider call({
    required String uniqueKey,
    String? assetSvg,
    String? base64,
    required double width,
    required double height,
  }) => ImageBytesResizedFutureProvider._(
    argument: (
      uniqueKey: uniqueKey,
      assetSvg: assetSvg,
      base64: base64,
      width: width,
      height: height,
    ),
    from: this,
  );

  @override
  String toString() => r'imageBytesResizedFutureProvider';
}

@ProviderFor(SelectedWalletAccountAssetNotifier)
@Deprecated('Only for mobile app version, should not be used now')
final selectedWalletAccountAssetProvider =
    SelectedWalletAccountAssetNotifierProvider._();

@Deprecated('Only for mobile app version, should not be used now')
final class SelectedWalletAccountAssetNotifierProvider
    extends
        $NotifierProvider<SelectedWalletAccountAssetNotifier, AccountAsset?> {
  SelectedWalletAccountAssetNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedWalletAccountAssetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$selectedWalletAccountAssetNotifierHash();

  @$internal
  @override
  SelectedWalletAccountAssetNotifier create() =>
      SelectedWalletAccountAssetNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountAsset? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountAsset?>(value),
    );
  }
}

String _$selectedWalletAccountAssetNotifierHash() =>
    r'6d81f34fcfcaea2b9e20491bad87b4103fd20be5';

@Deprecated('Only for mobile app version, should not be used now')
abstract class _$SelectedWalletAccountAssetNotifier
    extends $Notifier<AccountAsset?> {
  AccountAsset? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AccountAsset?, AccountAsset?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AccountAsset?, AccountAsset?>,
              AccountAsset?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedWalletAssetNotifier)
final selectedWalletAssetProvider = SelectedWalletAssetNotifierProvider._();

final class SelectedWalletAssetNotifierProvider
    extends $NotifierProvider<SelectedWalletAssetNotifier, Option<Asset>> {
  SelectedWalletAssetNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedWalletAssetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedWalletAssetNotifierHash();

  @$internal
  @override
  SelectedWalletAssetNotifier create() => SelectedWalletAssetNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<Asset>>(value),
    );
  }
}

String _$selectedWalletAssetNotifierHash() =>
    r'796ffbd765bee1df2140404339b11345f8139ffd';

abstract class _$SelectedWalletAssetNotifier extends $Notifier<Option<Asset>> {
  Option<Asset> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Option<Asset>, Option<Asset>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<Asset>, Option<Asset>>,
              Option<Asset>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
