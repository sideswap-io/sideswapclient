// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_page_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PageStatusNotifier)
final pageStatusProvider = PageStatusNotifierProvider._();

final class PageStatusNotifierProvider
    extends $NotifierProvider<PageStatusNotifier, Status> {
  PageStatusNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pageStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pageStatusNotifierHash();

  @$internal
  @override
  PageStatusNotifier create() => PageStatusNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Status value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Status>(value),
    );
  }
}

String _$pageStatusNotifierHash() =>
    r'885a08b17fbc985f57930cdf48e5b76b33b1c978';

abstract class _$PageStatusNotifier extends $Notifier<Status> {
  Status build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Status, Status>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Status, Status>,
              Status,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
