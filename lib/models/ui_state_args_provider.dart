import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum WalletMainNavigationItem {
  home,
  homeAssetReceive,
  accounts,
  assetSelect,
  assetDetails,
  assetReceive,
  transactions,
  requests,
  swap,
}

class WalletMainArguments {
  int _currentIndex;
  WalletMainNavigationItem _navigationItem;

  int get currentIndex => _currentIndex;
  set currentIndex(int value) => _currentIndex = value;

  WalletMainNavigationItem get navigationItem => _navigationItem;
  set navigationItem(WalletMainNavigationItem value) => _navigationItem = value;

  WalletMainArguments({
    int currentIndex,
    WalletMainNavigationItem navigationItem,
  })  : _currentIndex = currentIndex,
        _navigationItem = navigationItem;

  WalletMainArguments fromIndex(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return copyWith(
            currentIndex: currentIndex,
            navigationItem: WalletMainNavigationItem.home);
      case 1:
        return copyWith(
            currentIndex: currentIndex,
            navigationItem: WalletMainNavigationItem.accounts);
      // TODO: uncomment when request will be ready
      // case 2:
      //   return copyWith(
      //       currentIndex: currentIndex,
      //       navigationItem: WalletMainNavigationItem.requests);
      case 2:
        return copyWith(
            currentIndex: currentIndex,
            navigationItem: WalletMainNavigationItem.swap);
    }

    return copyWith(
        currentIndex: currentIndex,
        navigationItem: WalletMainNavigationItem.home);
  }

  WalletMainArguments copyWith({
    int currentIndex,
    WalletMainNavigationItem navigationItem,
  }) {
    return WalletMainArguments(
      currentIndex: currentIndex ?? this.currentIndex,
      navigationItem: navigationItem ?? this.navigationItem,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is WalletMainArguments &&
        o._currentIndex == _currentIndex &&
        o._navigationItem == _navigationItem;
  }

  @override
  int get hashCode => _currentIndex.hashCode ^ _navigationItem.hashCode;

  @override
  String toString() =>
      'WalletMainArguments(_currentIndex: $_currentIndex, _navigationItem: $_navigationItem)';
}

final uiStateArgsProvider =
    ChangeNotifierProvider<UiStateArgsChangeNotifierProvider>((ref) {
  return UiStateArgsChangeNotifierProvider();
});

class UiStateArgsChangeNotifierProvider extends ChangeNotifier {
  WalletMainArguments _walletMainArguments;
  WalletMainArguments _lastWalletMainArguments;

  WalletMainArguments get walletMainArguments => _walletMainArguments;
  set walletMainArguments(WalletMainArguments walletMainArguments) {
    _lastWalletMainArguments = _walletMainArguments;
    _walletMainArguments = walletMainArguments;
    notifyListeners();
  }

  WalletMainArguments get lastWalletMainArguments =>
      _lastWalletMainArguments ??
      WalletMainArguments(
          currentIndex: 0, navigationItem: WalletMainNavigationItem.home);

  factory UiStateArgsChangeNotifierProvider() {
    return _uiStateArgs;
  }

  UiStateArgsChangeNotifierProvider._internal() {
    walletMainArguments = WalletMainArguments(
      currentIndex: 0,
      navigationItem: WalletMainNavigationItem.home,
    );
  }

  static final UiStateArgsChangeNotifierProvider _uiStateArgs =
      UiStateArgsChangeNotifierProvider._internal();
}
