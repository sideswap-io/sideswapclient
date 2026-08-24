// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProxySettingsRepositoryNotifier)
final proxySettingsRepositoryProvider =
    ProxySettingsRepositoryNotifierProvider._();

final class ProxySettingsRepositoryNotifierProvider
    extends
        $NotifierProvider<
          ProxySettingsRepositoryNotifier,
          AbstractProxySettingsRepository
        > {
  ProxySettingsRepositoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'proxySettingsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$proxySettingsRepositoryNotifierHash();

  @$internal
  @override
  ProxySettingsRepositoryNotifier create() => ProxySettingsRepositoryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AbstractProxySettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AbstractProxySettingsRepository>(
        value,
      ),
    );
  }
}

String _$proxySettingsRepositoryNotifierHash() =>
    r'e19f98f7971b9f4b700cf0638f5f232cfb0c50da';

abstract class _$ProxySettingsRepositoryNotifier
    extends $Notifier<AbstractProxySettingsRepository> {
  AbstractProxySettingsRepository build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AbstractProxySettingsRepository,
              AbstractProxySettingsRepository
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AbstractProxySettingsRepository,
                AbstractProxySettingsRepository
              >,
              AbstractProxySettingsRepository,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
