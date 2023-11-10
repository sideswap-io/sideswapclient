import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/connection_models.dart';

final serverConnectionStateProvider = AutoDisposeStateProvider<bool>((ref) {
  ref.keepAlive();
  return false;
});

final walletLoadedStateProvider = AutoDisposeStateProvider<bool>((ref) {
  ref.keepAlive();
  return false;
});

final serverLoginStateProvider =
    AutoDisposeStateProvider<ServerLoginState>((ref) {
  ref.keepAlive();
  return const ServerLoginStateLogout();
});
