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

/// The scroll store of the desktop shell, scoped to the visit.
///
/// A visit is one continuous stay on one desktop navigation item; see the
/// `Visit` term in `CONTEXT.md`. The bucket is therefore new for every value of
/// `navigationItemEnum`, and the same one for everything that happens inside a
/// visit: a dialog pushed over the page, a spinner inside it, and the rebuild
/// of the shell that the return from Settings performs.
///
/// Two properties carry that rule and neither is optional. `keepAlive` makes
/// the bucket outlive the shell widget, which the return from Settings
/// destroys. The `select` makes the bucket die with the visit alone, and not
/// with any other change of `WalletMainArguments` such as `currentIndex`.

@ProviderFor(pageStorageBucket)
final pageStorageBucketProvider = PageStorageBucketProvider._();

/// The scroll store of the desktop shell, scoped to the visit.
///
/// A visit is one continuous stay on one desktop navigation item; see the
/// `Visit` term in `CONTEXT.md`. The bucket is therefore new for every value of
/// `navigationItemEnum`, and the same one for everything that happens inside a
/// visit: a dialog pushed over the page, a spinner inside it, and the rebuild
/// of the shell that the return from Settings performs.
///
/// Two properties carry that rule and neither is optional. `keepAlive` makes
/// the bucket outlive the shell widget, which the return from Settings
/// destroys. The `select` makes the bucket die with the visit alone, and not
/// with any other change of `WalletMainArguments` such as `currentIndex`.

final class PageStorageBucketProvider
    extends
        $FunctionalProvider<
          PageStorageBucket,
          PageStorageBucket,
          PageStorageBucket
        >
    with $Provider<PageStorageBucket> {
  /// The scroll store of the desktop shell, scoped to the visit.
  ///
  /// A visit is one continuous stay on one desktop navigation item; see the
  /// `Visit` term in `CONTEXT.md`. The bucket is therefore new for every value of
  /// `navigationItemEnum`, and the same one for everything that happens inside a
  /// visit: a dialog pushed over the page, a spinner inside it, and the rebuild
  /// of the shell that the return from Settings performs.
  ///
  /// Two properties carry that rule and neither is optional. `keepAlive` makes
  /// the bucket outlive the shell widget, which the return from Settings
  /// destroys. The `select` makes the bucket die with the visit alone, and not
  /// with any other change of `WalletMainArguments` such as `currentIndex`.
  PageStorageBucketProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pageStorageBucketProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pageStorageBucketHash();

  @$internal
  @override
  $ProviderElement<PageStorageBucket> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PageStorageBucket create(Ref ref) {
    return pageStorageBucket(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PageStorageBucket value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PageStorageBucket>(value),
    );
  }
}

String _$pageStorageBucketHash() => r'e8031d63c9a13efbb5d17695d37dac51f4c4db00';
