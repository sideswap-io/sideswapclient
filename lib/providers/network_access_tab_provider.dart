import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';

part 'network_access_tab_provider.freezed.dart';
part 'network_access_tab_provider.g.dart';

@freezed
class NetworkAccessTabState with _$NetworkAccessTabState {
  const factory NetworkAccessTabState.server() = NetworkAccessTabStateServer;
  const factory NetworkAccessTabState.proxy() = NetworkAccessTabStateProxy;
}

@riverpod
class NetworkAccessTabNotifier extends _$NetworkAccessTabNotifier {
  @override
  NetworkAccessTabState build() {
    return const NetworkAccessTabState.server();
  }

  void setNetworkAccessTab(NetworkAccessTabState value) {
    state = value;
  }
}

@riverpod
class UseProxyNotifier extends _$UseProxyNotifier {
  @override
  bool build() {
    return ref.watch(configurationProvider).useProxy;
  }

  void setProxyState(bool useProxy) {
    ref.read(configurationProvider.notifier).setUseProxy(useProxy);
  }
}
