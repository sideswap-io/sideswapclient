// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_market_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TokenMarketNotifier)
final tokenMarketProvider = TokenMarketNotifierProvider._();

final class TokenMarketNotifierProvider
    extends
        $NotifierProvider<TokenMarketNotifier, Map<String, AssetDetailsData>> {
  TokenMarketNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenMarketProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenMarketNotifierHash();

  @$internal
  @override
  TokenMarketNotifier create() => TokenMarketNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, AssetDetailsData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, AssetDetailsData>>(
        value,
      ),
    );
  }
}

String _$tokenMarketNotifierHash() =>
    r'5a9c24990a2a119fae7a1730c6876902fb94c968';

abstract class _$TokenMarketNotifier
    extends $Notifier<Map<String, AssetDetailsData>> {
  Map<String, AssetDetailsData> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<String, AssetDetailsData>,
              Map<String, AssetDetailsData>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, AssetDetailsData>,
                Map<String, AssetDetailsData>
              >,
              Map<String, AssetDetailsData>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
