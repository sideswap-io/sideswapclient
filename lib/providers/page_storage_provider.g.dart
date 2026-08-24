// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PageStorageKeyData)
final pageStorageKeyDataProvider = PageStorageKeyDataProvider._();

final class PageStorageKeyDataProvider
    extends $NotifierProvider<PageStorageKeyData, String> {
  PageStorageKeyDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pageStorageKeyDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pageStorageKeyDataHash();

  @$internal
  @override
  PageStorageKeyData create() => PageStorageKeyData();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$pageStorageKeyDataHash() =>
    r'c76d10c2b5eaba09c73cf66acbd1a520df9bf148';

abstract class _$PageStorageKeyData extends $Notifier<String> {
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
