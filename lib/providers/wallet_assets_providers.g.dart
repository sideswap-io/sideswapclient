// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_assets_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bitcoinAssetIdHash() => r'ab5ab5393629fbc1cd35fa94391e71a8d0847f81';

/// See also [bitcoinAssetId].
@ProviderFor(bitcoinAssetId)
final bitcoinAssetIdProvider = Provider<String>.internal(
  bitcoinAssetId,
  name: r'bitcoinAssetIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bitcoinAssetIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BitcoinAssetIdRef = ProviderRef<String>;
String _$assetsHash() => r'8c124724af564e592ba0632abcef778f8aab2bea';

/// See also [assets].
@ProviderFor(assets)
final assetsProvider = AutoDisposeProvider<Iterable<Asset>>.internal(
  assets,
  name: r'assetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$assetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssetsRef = AutoDisposeProviderRef<Iterable<Asset>>;
String _$assetFromAssetIdHash() => r'b72841dbd1056e3de308d8a84b47822c12263170';

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

/// See also [assetFromAssetId].
@ProviderFor(assetFromAssetId)
const assetFromAssetIdProvider = AssetFromAssetIdFamily();

/// See also [assetFromAssetId].
class AssetFromAssetIdFamily extends Family<Option<Asset>> {
  /// See also [assetFromAssetId].
  const AssetFromAssetIdFamily();

  /// See also [assetFromAssetId].
  AssetFromAssetIdProvider call(String? assetId) {
    return AssetFromAssetIdProvider(assetId);
  }

  @override
  AssetFromAssetIdProvider getProviderOverride(
    covariant AssetFromAssetIdProvider provider,
  ) {
    return call(provider.assetId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'assetFromAssetIdProvider';
}

/// See also [assetFromAssetId].
class AssetFromAssetIdProvider extends AutoDisposeProvider<Option<Asset>> {
  /// See also [assetFromAssetId].
  AssetFromAssetIdProvider(String? assetId)
    : this._internal(
        (ref) => assetFromAssetId(ref as AssetFromAssetIdRef, assetId),
        from: assetFromAssetIdProvider,
        name: r'assetFromAssetIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$assetFromAssetIdHash,
        dependencies: AssetFromAssetIdFamily._dependencies,
        allTransitiveDependencies:
            AssetFromAssetIdFamily._allTransitiveDependencies,
        assetId: assetId,
      );

  AssetFromAssetIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
  }) : super.internal();

  final String? assetId;

  @override
  Override overrideWith(
    Option<Asset> Function(AssetFromAssetIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetFromAssetIdProvider._internal(
        (ref) => create(ref as AssetFromAssetIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetId: assetId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Option<Asset>> createElement() {
    return _AssetFromAssetIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetFromAssetIdProvider && other.assetId == assetId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssetFromAssetIdRef on AutoDisposeProviderRef<Option<Asset>> {
  /// The parameter `assetId` of this provider.
  String? get assetId;
}

class _AssetFromAssetIdProviderElement
    extends AutoDisposeProviderElement<Option<Asset>>
    with AssetFromAssetIdRef {
  _AssetFromAssetIdProviderElement(super.provider);

  @override
  String? get assetId => (origin as AssetFromAssetIdProvider).assetId;
}

String _$assetUtilsHash() => r'3ab23b14fed091938634c0c8d49080f197bcc2d5';

/// See also [assetUtils].
@ProviderFor(assetUtils)
final assetUtilsProvider = AutoDisposeProvider<AssetUtils>.internal(
  assetUtils,
  name: r'assetUtilsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$assetUtilsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssetUtilsRef = AutoDisposeProviderRef<AssetUtils>;
String _$cacheManagerHash() => r'e1b08ebd0a33e4e5a44d8fda304e3a88d3f25da7';

/// See also [cacheManager].
@ProviderFor(cacheManager)
final cacheManagerProvider = Provider<CacheManager>.internal(
  cacheManager,
  name: r'cacheManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cacheManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CacheManagerRef = ProviderRef<CacheManager>;
String _$cachedImageManagerHash() =>
    r'0eb7658243703a883423f52915e0ec0fc998af9e';

/// See also [cachedImageManager].
@ProviderFor(cachedImageManager)
final cachedImageManagerProvider = Provider<CachedImageBase64Manager>.internal(
  cachedImageManager,
  name: r'cachedImageManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cachedImageManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CachedImageManagerRef = ProviderRef<CachedImageBase64Manager>;
String _$clearImageCacheFutureHash() =>
    r'ec01d17910dbfa5b87607209ccf50243b9873f85';

/// See also [clearImageCacheFuture].
@ProviderFor(clearImageCacheFuture)
final clearImageCacheFutureProvider = FutureProvider<bool>.internal(
  clearImageCacheFuture,
  name: r'clearImageCacheFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clearImageCacheFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClearImageCacheFutureRef = FutureProviderRef<bool>;
String _$builtinAssetsHash() => r'747435613ca20555dcac7dde1b8cb10fe604d7c2';

/// See also [builtinAssets].
@ProviderFor(builtinAssets)
final builtinAssetsProvider = AutoDisposeProvider<Map<String, Asset>>.internal(
  builtinAssets,
  name: r'builtinAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$builtinAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BuiltinAssetsRef = AutoDisposeProviderRef<Map<String, Asset>>;
String _$imageBytesResizedFutureHash() =>
    r'd9569c8a2a20bbc9174da5ea71dd74afc3710b39';

/// See also [imageBytesResizedFuture].
@ProviderFor(imageBytesResizedFuture)
const imageBytesResizedFutureProvider = ImageBytesResizedFutureFamily();

/// See also [imageBytesResizedFuture].
class ImageBytesResizedFutureFamily extends Family<AsyncValue<Uint8List?>> {
  /// See also [imageBytesResizedFuture].
  const ImageBytesResizedFutureFamily();

  /// See also [imageBytesResizedFuture].
  ImageBytesResizedFutureProvider call({
    required String uniqueKey,
    String? assetSvg,
    String? base64,
    required double width,
    required double height,
  }) {
    return ImageBytesResizedFutureProvider(
      uniqueKey: uniqueKey,
      assetSvg: assetSvg,
      base64: base64,
      width: width,
      height: height,
    );
  }

  @override
  ImageBytesResizedFutureProvider getProviderOverride(
    covariant ImageBytesResizedFutureProvider provider,
  ) {
    return call(
      uniqueKey: provider.uniqueKey,
      assetSvg: provider.assetSvg,
      base64: provider.base64,
      width: provider.width,
      height: provider.height,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'imageBytesResizedFutureProvider';
}

/// See also [imageBytesResizedFuture].
class ImageBytesResizedFutureProvider
    extends AutoDisposeFutureProvider<Uint8List?> {
  /// See also [imageBytesResizedFuture].
  ImageBytesResizedFutureProvider({
    required String uniqueKey,
    String? assetSvg,
    String? base64,
    required double width,
    required double height,
  }) : this._internal(
         (ref) => imageBytesResizedFuture(
           ref as ImageBytesResizedFutureRef,
           uniqueKey: uniqueKey,
           assetSvg: assetSvg,
           base64: base64,
           width: width,
           height: height,
         ),
         from: imageBytesResizedFutureProvider,
         name: r'imageBytesResizedFutureProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$imageBytesResizedFutureHash,
         dependencies: ImageBytesResizedFutureFamily._dependencies,
         allTransitiveDependencies:
             ImageBytesResizedFutureFamily._allTransitiveDependencies,
         uniqueKey: uniqueKey,
         assetSvg: assetSvg,
         base64: base64,
         width: width,
         height: height,
       );

  ImageBytesResizedFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uniqueKey,
    required this.assetSvg,
    required this.base64,
    required this.width,
    required this.height,
  }) : super.internal();

  final String uniqueKey;
  final String? assetSvg;
  final String? base64;
  final double width;
  final double height;

  @override
  Override overrideWith(
    FutureOr<Uint8List?> Function(ImageBytesResizedFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ImageBytesResizedFutureProvider._internal(
        (ref) => create(ref as ImageBytesResizedFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uniqueKey: uniqueKey,
        assetSvg: assetSvg,
        base64: base64,
        width: width,
        height: height,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Uint8List?> createElement() {
    return _ImageBytesResizedFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ImageBytesResizedFutureProvider &&
        other.uniqueKey == uniqueKey &&
        other.assetSvg == assetSvg &&
        other.base64 == base64 &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uniqueKey.hashCode);
    hash = _SystemHash.combine(hash, assetSvg.hashCode);
    hash = _SystemHash.combine(hash, base64.hashCode);
    hash = _SystemHash.combine(hash, width.hashCode);
    hash = _SystemHash.combine(hash, height.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ImageBytesResizedFutureRef on AutoDisposeFutureProviderRef<Uint8List?> {
  /// The parameter `uniqueKey` of this provider.
  String get uniqueKey;

  /// The parameter `assetSvg` of this provider.
  String? get assetSvg;

  /// The parameter `base64` of this provider.
  String? get base64;

  /// The parameter `width` of this provider.
  double get width;

  /// The parameter `height` of this provider.
  double get height;
}

class _ImageBytesResizedFutureProviderElement
    extends AutoDisposeFutureProviderElement<Uint8List?>
    with ImageBytesResizedFutureRef {
  _ImageBytesResizedFutureProviderElement(super.provider);

  @override
  String get uniqueKey => (origin as ImageBytesResizedFutureProvider).uniqueKey;
  @override
  String? get assetSvg => (origin as ImageBytesResizedFutureProvider).assetSvg;
  @override
  String? get base64 => (origin as ImageBytesResizedFutureProvider).base64;
  @override
  double get width => (origin as ImageBytesResizedFutureProvider).width;
  @override
  double get height => (origin as ImageBytesResizedFutureProvider).height;
}

String _$liquidAssetIdStateHash() =>
    r'0993e2408473de0a738dd0d0b42e264cac3165df';

/// See also [LiquidAssetIdState].
@ProviderFor(LiquidAssetIdState)
final liquidAssetIdStateProvider =
    NotifierProvider<LiquidAssetIdState, String>.internal(
      LiquidAssetIdState.new,
      name: r'liquidAssetIdStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$liquidAssetIdStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LiquidAssetIdState = Notifier<String>;
String _$tetherAssetIdStateHash() =>
    r'e4920c1b459cbd9addf44bfebe876536c0457b16';

/// See also [TetherAssetIdState].
@ProviderFor(TetherAssetIdState)
final tetherAssetIdStateProvider =
    NotifierProvider<TetherAssetIdState, String>.internal(
      TetherAssetIdState.new,
      name: r'tetherAssetIdStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$tetherAssetIdStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TetherAssetIdState = Notifier<String>;
String _$eurxAssetIdStateHash() => r'cea1a4f1317dc16e9e42c2543172f534892091d6';

/// See also [EurxAssetIdState].
@ProviderFor(EurxAssetIdState)
final eurxAssetIdStateProvider =
    NotifierProvider<EurxAssetIdState, String>.internal(
      EurxAssetIdState.new,
      name: r'eurxAssetIdStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$eurxAssetIdStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EurxAssetIdState = Notifier<String>;
String _$ampAssetIdsNotifierHash() =>
    r'973d5b8e615d5b47cc72b9780cb2e5430b323c75';

/// See also [AmpAssetIdsNotifier].
@ProviderFor(AmpAssetIdsNotifier)
final ampAssetIdsNotifierProvider =
    NotifierProvider<AmpAssetIdsNotifier, List<String>>.internal(
      AmpAssetIdsNotifier.new,
      name: r'ampAssetIdsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ampAssetIdsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AmpAssetIdsNotifier = Notifier<List<String>>;
String _$assetsStateHash() => r'dc3b5abcf0d3131d19106f41aec18f3f81421f97';

/// See also [AssetsState].
@ProviderFor(AssetsState)
final assetsStateProvider =
    NotifierProvider<AssetsState, Map<String, Asset>>.internal(
      AssetsState.new,
      name: r'assetsStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$assetsStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AssetsState = Notifier<Map<String, Asset>>;
String _$selectedWalletAccountAssetNotifierHash() =>
    r'6d81f34fcfcaea2b9e20491bad87b4103fd20be5';

/// See also [SelectedWalletAccountAssetNotifier].
@ProviderFor(SelectedWalletAccountAssetNotifier)
final selectedWalletAccountAssetNotifierProvider =
    NotifierProvider<
      SelectedWalletAccountAssetNotifier,
      AccountAsset?
    >.internal(
      SelectedWalletAccountAssetNotifier.new,
      name: r'selectedWalletAccountAssetNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedWalletAccountAssetNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedWalletAccountAssetNotifier = Notifier<AccountAsset?>;
String _$selectedWalletAssetNotifierHash() =>
    r'796ffbd765bee1df2140404339b11345f8139ffd';

/// See also [SelectedWalletAssetNotifier].
@ProviderFor(SelectedWalletAssetNotifier)
final selectedWalletAssetNotifierProvider =
    NotifierProvider<SelectedWalletAssetNotifier, Option<Asset>>.internal(
      SelectedWalletAssetNotifier.new,
      name: r'selectedWalletAssetNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedWalletAssetNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedWalletAssetNotifier = Notifier<Option<Asset>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
