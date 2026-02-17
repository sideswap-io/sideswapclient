// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_precache_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(assetsPrecacheFuture)
const assetsPrecacheFutureProvider = AssetsPrecacheFutureProvider._();

final class AssetsPrecacheFutureProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const AssetsPrecacheFutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetsPrecacheFutureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetsPrecacheFutureHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return assetsPrecacheFuture(ref);
  }
}

String _$assetsPrecacheFutureHash() =>
    r'dbe2204928a8124bad88a61434955bf566028f9f';
