// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_asset_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SendAssetIdNotifier)
const sendAssetIdProvider = SendAssetIdNotifierProvider._();

final class SendAssetIdNotifierProvider
    extends $NotifierProvider<SendAssetIdNotifier, String> {
  const SendAssetIdNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendAssetIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendAssetIdNotifierHash();

  @$internal
  @override
  SendAssetIdNotifier create() => SendAssetIdNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$sendAssetIdNotifierHash() =>
    r'9e013542189cdc74b89f28720f8e01fbd5f69dba';

abstract class _$SendAssetIdNotifier extends $Notifier<String> {
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
