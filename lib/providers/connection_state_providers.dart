import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/connection_models.dart';

part 'connection_state_providers.g.dart';

@Riverpod(keepAlive: true)
class ServerConnectionNotifier extends _$ServerConnectionNotifier {
  @override
  bool build() {
    return false;
  }

  void setServerConnectionState(bool serverConnectionState) {
    state = serverConnectionState;
  }
}

@Riverpod(keepAlive: true)
class ServerLoginNotifier extends _$ServerLoginNotifier {
  @override
  ServerLoginState build() {
    return const ServerLoginStateLogin();
  }

  void setServerLoginState(ServerLoginState serverLoginState) {
    state = serverLoginState;
  }
}
