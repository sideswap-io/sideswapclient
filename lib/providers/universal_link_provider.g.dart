// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'universal_link_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UniversalLinkResultStateNotifier)
final universalLinkResultStateProvider =
    UniversalLinkResultStateNotifierProvider._();

final class UniversalLinkResultStateNotifierProvider
    extends
        $NotifierProvider<UniversalLinkResultStateNotifier, LinkResultState> {
  UniversalLinkResultStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'universalLinkResultStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$universalLinkResultStateNotifierHash();

  @$internal
  @override
  UniversalLinkResultStateNotifier create() =>
      UniversalLinkResultStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkResultState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkResultState>(value),
    );
  }
}

String _$universalLinkResultStateNotifierHash() =>
    r'6f16af74c06ecf8838e7a7e4b8011d753cc0b1a5';

abstract class _$UniversalLinkResultStateNotifier
    extends $Notifier<LinkResultState> {
  LinkResultState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LinkResultState, LinkResultState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LinkResultState, LinkResultState>,
              LinkResultState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(universalLink)
final universalLinkProvider = UniversalLinkProvider._();

final class UniversalLinkProvider
    extends $FunctionalProvider<UniversalLink, UniversalLink, UniversalLink>
    with $Provider<UniversalLink> {
  UniversalLinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'universalLinkProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$universalLinkHash();

  @$internal
  @override
  $ProviderElement<UniversalLink> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UniversalLink create(Ref ref) {
    return universalLink(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UniversalLink value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UniversalLink>(value),
    );
  }
}

String _$universalLinkHash() => r'd8444c7b862f78f1924f913b162b48d1f5076c60';
