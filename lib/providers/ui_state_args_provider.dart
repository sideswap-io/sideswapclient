import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_state_args_provider.g.dart';

enum WalletMainNavigationItemEnum {
  home,
  accounts,
  assetSelect,
  assetDetails,
  transactions,
  pegs,
  markets,
  swap,
}

class WalletMainArguments {
  final int currentIndex;
  final WalletMainNavigationItemEnum navigationItemEnum;
  final Object? arguments;

  WalletMainArguments({
    required this.currentIndex,
    required this.navigationItemEnum,
    this.arguments,
  });

  WalletMainArguments fromIndex(int value) {
    return switch (value) {
      0 => copyWith(
          currentIndex: value,
          navigationItemEnum: WalletMainNavigationItemEnum.home),
      1 => copyWith(
          currentIndex: value,
          navigationItemEnum: WalletMainNavigationItemEnum.accounts),
      2 => copyWith(
          currentIndex: value,
          navigationItemEnum: WalletMainNavigationItemEnum.markets),
      3 => copyWith(
          currentIndex: value,
          navigationItemEnum: WalletMainNavigationItemEnum.swap),
      4 => copyWith(
          currentIndex: value,
          navigationItemEnum: WalletMainNavigationItemEnum.pegs),
      _ => copyWith(
          currentIndex: value,
          navigationItemEnum: WalletMainNavigationItemEnum.home),
    };
  }

  WalletMainArguments fromIndexDesktop(int value) {
    return switch (value) {
      0 => copyWith(
          currentIndex: value,
          navigationItemEnum: WalletMainNavigationItemEnum.home),
      1 => copyWith(
          currentIndex: value,
          navigationItemEnum: WalletMainNavigationItemEnum.markets),
      2 => copyWith(
          currentIndex: value,
          navigationItemEnum: WalletMainNavigationItemEnum.swap),
      3 => copyWith(
          currentIndex: value,
          navigationItemEnum: WalletMainNavigationItemEnum.transactions),
      4 => copyWith(
          currentIndex: value,
          navigationItemEnum: WalletMainNavigationItemEnum.pegs),
      _ => copyWith(
          currentIndex: value,
          navigationItemEnum: WalletMainNavigationItemEnum.home),
    };
  }

  WalletMainArguments copyWith({
    int? currentIndex,
    WalletMainNavigationItemEnum? navigationItemEnum,
    Object? arguments,
  }) {
    return WalletMainArguments(
      currentIndex: currentIndex ?? this.currentIndex,
      navigationItemEnum: navigationItemEnum ?? this.navigationItemEnum,
      arguments: arguments ?? this.arguments,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletMainArguments &&
        other.currentIndex == currentIndex &&
        other.navigationItemEnum == navigationItemEnum &&
        other.arguments == arguments;
  }

  @override
  int get hashCode =>
      currentIndex.hashCode ^ navigationItemEnum.hashCode ^ arguments.hashCode;

  @override
  String toString() =>
      'WalletMainArguments(currentIndex: $currentIndex, navigationItemEnum: $navigationItemEnum, arguments: $arguments)';
}

@riverpod
class UiStateArgsNotifier extends _$UiStateArgsNotifier {
  @override
  WalletMainArguments build() {
    return WalletMainArguments(
      currentIndex: 0,
      navigationItemEnum: WalletMainNavigationItemEnum.home,
    );
  }

  void setWalletMainArguments(WalletMainArguments value) {
    state = value;
  }

  void clear() {
    state = WalletMainArguments(
      currentIndex: 0,
      navigationItemEnum: WalletMainNavigationItemEnum.home,
    );
  }
}


// final uiStateArgsProvider =
//     ChangeNotifierProvider<UiStateArgsChangeNotifierProvider>((ref) {
//   return UiStateArgsChangeNotifierProvider();
// });

// class UiStateArgsChangeNotifierProvider extends ChangeNotifier {
//   WalletMainArguments _walletMainArguments;
//   WalletMainArguments _lastWalletMainArguments = WalletMainArguments(
//       currentIndex: 0,
//       navigationItem: WalletMainNavigationItem(
//           navigationItemEnum: WalletMainNavigationItemEnum.home));

//   WalletMainArguments get walletMainArguments => _walletMainArguments;
//   set walletMainArguments(WalletMainArguments value) {
//     _lastWalletMainArguments = _walletMainArguments;
//     _walletMainArguments = value;
//     notifyListeners();
//   }

//   void clear() {
//     _walletMainArguments = WalletMainArguments(
//         currentIndex: 0,
//         navigationItem: WalletMainNavigationItem(
//             navigationItemEnum: WalletMainNavigationItemEnum.home));
//     _lastWalletMainArguments = _walletMainArguments;
//   }

//   WalletMainArguments get lastWalletMainArguments => _lastWalletMainArguments;

//   factory UiStateArgsChangeNotifierProvider() {
//     return _uiStateArgs;
//   }

//   UiStateArgsChangeNotifierProvider._internal()
//       : _walletMainArguments = WalletMainArguments(
//             currentIndex: 0,
//             navigationItem: WalletMainNavigationItem(
//                 navigationItemEnum: WalletMainNavigationItemEnum.home));

//   static final UiStateArgsChangeNotifierProvider _uiStateArgs =
//       UiStateArgsChangeNotifierProvider._internal();
// }
