import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'proxy_provider.freezed.dart';
part 'proxy_provider.g.dart';

@freezed
sealed class ProxySettings with _$ProxySettings {
  factory ProxySettings({String? host, int? port}) = _ProxySettings;
}

abstract class AbstractProxySettingsRepository {
  To_ProxySettings getProxySettings();
}

class ProxySettingsRepository extends AbstractProxySettingsRepository {
  final ProxySettings proxySettings;
  final bool useProxy;

  ProxySettingsRepository(this.proxySettings, {this.useProxy = false});

  @override
  To_ProxySettings getProxySettings() {
    final proxy = To_ProxySettings();
    final host = proxySettings.host;
    final port = proxySettings.port;

    if (useProxy &&
        host != null &&
        host.isNotEmpty &&
        port != null &&
        port > 0 &&
        port < 65535) {
      proxy.proxy = To_ProxySettings_Proxy(host: host, port: port);
    }

    return proxy;
  }
}

@riverpod
class ProxySettingsRepositoryNotifier
    extends _$ProxySettingsRepositoryNotifier {
  @override
  AbstractProxySettingsRepository build() {
    final proxySettings =
        ref.watch(configurationProvider.select((e) => e.proxySettings)) ??
        ProxySettings();
    final useProxy = ref.watch(configurationProvider.select((e) => e.useProxy));

    return ProxySettingsRepository(proxySettings, useProxy: useProxy);
  }

  void setState(AbstractProxySettingsRepository proxySettingsRepository) {
    state = proxySettingsRepository;
  }
}
