// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_assets_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bitcoinAssetIdHash() => r'0f4665a0b907b7ed2af7d6f5385e086071981873';

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

typedef BitcoinAssetIdRef = ProviderRef<String>;
String _$assetUtilsHash() => r'06e684a8420c7d12ef7da59b0dd95277aefd84c1';

/// See also [assetUtils].
@ProviderFor(assetUtils)
final assetUtilsProvider = AutoDisposeProvider<AssetUtils>.internal(
  assetUtils,
  name: r'assetUtilsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$assetUtilsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AssetUtilsRef = AutoDisposeProviderRef<AssetUtils>;
String _$cachedImageManagerHash() =>
    r'0c98bb88fd963ab145033445a67e8c9542986492';

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

typedef CachedImageManagerRef = ProviderRef<CachedImageBase64Manager>;
String _$clearImageCacheFutureHash() =>
    r'5f1854054609f505f58f97f3db2c9a636d72e8e6';

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

typedef ClearImageCacheFutureRef = FutureProviderRef<bool>;
String _$assetImageHash() => r'0fa26ea63b9ed192a6b81dd018ab1605d5f63c39';

/// See also [assetImage].
@ProviderFor(assetImage)
final assetImageProvider = AutoDisposeProvider<AssetImage>.internal(
  assetImage,
  name: r'assetImageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$assetImageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AssetImageRef = AutoDisposeProviderRef<AssetImage>;
String _$builtinAssetsHash() => r'8fde451fff74bc2f3064435f93c52eb4aaec7af1';

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

typedef BuiltinAssetsRef = AutoDisposeProviderRef<Map<String, Asset>>;
String _$imageBytesResizedFutureHash() =>
    r'8e0fac4f5ac48f9d75eff18f7b1234479a290849';

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
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
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
String _$ampAssetsNotifierHash() => r'b57fe93761c6c6a232e44b0ac80398a7c9718604';

/// See also [AmpAssetsNotifier].
@ProviderFor(AmpAssetsNotifier)
final ampAssetsNotifierProvider =
    AutoDisposeNotifierProvider<AmpAssetsNotifier, List<String>>.internal(
  AmpAssetsNotifier.new,
  name: r'ampAssetsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ampAssetsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AmpAssetsNotifier = AutoDisposeNotifier<List<String>>;
String _$assetsStateHash() => r'48729271cca082e7ff42dae31652319333075665';

/// See also [AssetsState].
@ProviderFor(AssetsState)
final assetsStateProvider =
    NotifierProvider<AssetsState, Map<String, Asset>>.internal(
  AssetsState.new,
  name: r'assetsStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$assetsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AssetsState = Notifier<Map<String, Asset>>;
String _$selectedWalletAccountAssetNotifierHash() =>
    r'80c8b7c138ac843d68ee8c40ca5e32cfe29278a0';

/// See also [SelectedWalletAccountAssetNotifier].
@ProviderFor(SelectedWalletAccountAssetNotifier)
final selectedWalletAccountAssetNotifierProvider = NotifierProvider<
    SelectedWalletAccountAssetNotifier, AccountAsset?>.internal(
  SelectedWalletAccountAssetNotifier.new,
  name: r'selectedWalletAccountAssetNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedWalletAccountAssetNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedWalletAccountAssetNotifier = Notifier<AccountAsset?>;
String _$walletAssetPricesNotifierHash() =>
    r'9be676bb1301c4fa4c977588b85caa7e1c699551';

/// See also [WalletAssetPricesNotifier].
@ProviderFor(WalletAssetPricesNotifier)
final walletAssetPricesNotifierProvider = NotifierProvider<
    WalletAssetPricesNotifier, Map<String, From_PriceUpdate>>.internal(
  WalletAssetPricesNotifier.new,
  name: r'walletAssetPricesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$walletAssetPricesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WalletAssetPricesNotifier = Notifier<Map<String, From_PriceUpdate>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
