import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/wallet.dart';

final selectEnvProvider =
    ChangeNotifierProvider.autoDispose<SelectEnvProvider>((ref) {
  return SelectEnvProvider(ref);
});

class SelectEnvProvider extends ChangeNotifier {
  final Ref ref;

  SelectEnvProvider(this.ref) {
    _startupEnv = ref.read(walletProvider).env();
    _currentEnv = _startupEnv;
  }

  int _startupEnv = 0;
  int tapCounter = 0;
  int _currentEnv = 0;
  bool _showSelectEnvDialog = false;

  bool get showSelectEnvDialog => _showSelectEnvDialog;
  set showSelectEnvDialog(bool value) {
    _currentEnv = ref.read(walletProvider).env();
    _showSelectEnvDialog = value;
    notifyListeners();
  }

  int get currentEnv => _currentEnv;
  Future<void> setCurrentEnv(int value) async {
    _currentEnv = value;
    notifyListeners();
  }

  int get startupEnv => _startupEnv;

  void handleTap() {
    tapCounter += 1;
    if (tapCounter >= 7) {
      tapCounter = 0;
      showSelectEnvDialog = true;
    }
  }

  Future<void> saveEnv({bool restart = true}) async {
    await ref.read(walletProvider).setEnv(_currentEnv, restart: restart);
  }
}
