import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'proxy_provider.freezed.dart';
part 'proxy_provider.g.dart';

@freezed
sealed class ProxySettings with _$ProxySettings {
  factory ProxySettings({String? host, int? port}) = _ProxySettings;
}

@riverpod
class ProxySettingsNotifier extends _$ProxySettingsNotifier {
  @override
  ProxySettings? build() {
    return null;
  }

  void setProxySettings(ProxySettings? proxySettings) {
    state = proxySettings;
  }
}
