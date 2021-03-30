import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fixnum/fixnum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideswap/common/widgets/show_peg_info_widget.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/screen_utils.dart';

final swapProvider = ChangeNotifierProvider<SwapChangeNotifierProvider>(
    (ref) => SwapChangeNotifierProvider(ref.read));

enum SwapType {
  atomic,
  pegIn,
  pegOut,
}

enum SwapWallet {
  local,
  extern,
}

class SwapChangeNotifierProvider with ChangeNotifier {
  final Reader read;

  SwapChangeNotifierProvider(this.read);

  static const hidePegInInfo = 'hide_peg_in_info';
  static const hidePegOutInfo = 'hide_peg_out_info';

  bool _showInsufficientFunds = false;
  bool get showInsufficientFunds => _showInsufficientFunds;
  set showInsufficientFunds(bool showInsufficientFunds) {
    if (swapSendWallet == SwapWallet.local) {
      _showInsufficientFunds = showInsufficientFunds;
    } else {
      _showInsufficientFunds = false;
    }
  }

  String _swapSendAsset;
  String get swapSendAsset => _swapSendAsset;
  set swapSendAsset(String swapSendAsset) {
    _swapSendAsset = swapSendAsset;
    notifyListeners();
  }

  String _swapRecvAsset;

  String get swapRecvAsset => _swapRecvAsset;

  set swapRecvAsset(String swapRecvAsset) {
    _swapRecvAsset = swapRecvAsset;
    notifyListeners();
  }

  bool _swapPeg = false;
  bool get swapPeg => _swapPeg;
  set swapPeg(bool swapPeg) {
    _swapPeg = swapPeg;
    notifyListeners();
  }

  SwapWallet _swapSendWallet = SwapWallet.local;
  SwapWallet get swapSendWallet => _swapSendWallet;
  set swapSendWallet(SwapWallet swapSendWallet) {
    _swapSendWallet = swapSendWallet;
    notifyListeners();
  }

  SwapWallet _swapRecvWallet = SwapWallet.local;
  SwapWallet get swapRecvWallet => _swapRecvWallet;
  set swapRecvWallet(SwapWallet swapRecvWallet) {
    _swapRecvWallet = swapRecvWallet;
    notifyListeners();
  }

  int _swapSendAmount;
  int get swapSendAmount => _swapSendAmount;
  set swapSendAmount(int swapSendAmount) {
    _swapSendAmount = swapSendAmount;
    notifyListeners();
  }

  int _swapRecvAmount;
  int get swapRecvAmount => _swapRecvAmount;
  set swapRecvAmount(int swapRecvAmount) {
    _swapRecvAmount = swapRecvAmount;
    notifyListeners();
  }

  int _swapNetworkFee;
  int get swapNetworkFee => _swapNetworkFee;
  set swapNetworkFee(int swapNetworkFee) {
    _swapNetworkFee = swapNetworkFee;
    notifyListeners();
  }

  String _swapRecvAddressExternal;
  String get swapRecvAddressExternal => _swapRecvAddressExternal;
  set swapRecvAddressExternal(String swapRecvAddressExternal) {
    _swapRecvAddressExternal = swapRecvAddressExternal;
    notifyListeners();
  }

  bool _swapActive = false;
  bool get swapActive => _swapActive;
  set swapActive(bool swapActive) {
    _swapActive = swapActive;
  }

  String _swapNetworkError;
  String get swapNetworkError => _swapNetworkError;
  set swapNetworkError(String swapNetworkError) {
    _swapNetworkError = swapNetworkError;
    notifyListeners();
  }

  String _swapPegAddressServer;
  String get swapPegAddressServer => _swapPegAddressServer;
  set swapPegAddressServer(String swapPegAddressServer) {
    _swapPegAddressServer = swapPegAddressServer;
    notifyListeners();
  }

  bool _didAssetReplaced = false;
  bool get didAssetReplaced => _didAssetReplaced;
  set didAssetReplaced(bool didAssetReplaced) {
    _didAssetReplaced = didAssetReplaced;
    notifyListeners();
  }

  // Functions //

  List<String> swapSendAssets() {
    final wallet = read(walletProvider);
    if (swapPeg) {
      return [wallet.bitcoinAssetId(), wallet.liquidAssetId()];
    }
    return wallet.assets.keys
        .where((element) => element != wallet.bitcoinAssetId())
        .toList();
  }

  List<String> swapRecvAssets() {
    final wallet = read(walletProvider);
    if (swapPeg) {
      if (swapSendAsset == wallet.liquidAssetId()) {
        return [wallet.bitcoinAssetId()];
      }
      return [wallet.liquidAssetId()];
    }
    if (swapSendAsset != wallet.liquidAssetId()) {
      return [wallet.liquidAssetId()];
    }
    return wallet.assets.keys
        .where((element) =>
            element != wallet.liquidAssetId() &&
            element != wallet.bitcoinAssetId())
        .toList();
  }

  SwapType swapType() {
    final wallet = read(walletProvider);
    if (swapSendAsset == wallet.bitcoinAssetId() &&
        swapRecvAsset == wallet.liquidAssetId()) {
      return SwapType.pegIn;
    }
    if (swapSendAsset == wallet.liquidAssetId() &&
        swapRecvAsset == wallet.bitcoinAssetId()) {
      return SwapType.pegOut;
    }
    return SwapType.atomic;
  }

  void swapAccept(BuildContext context) async {
    final type = swapType();

    if (type == SwapType.pegIn) {
      final msg = To();
      msg.pegRequest = Empty();
      read(walletProvider).sendMsg(msg);
      return;
    }

    final maxBalance = swapSendWallet == SwapWallet.local
        ? read(walletProvider).balances[swapSendAsset]
        : kMaxCoins;
    if (swapSendAmount == null ||
        swapSendAmount <= 0 ||
        swapSendAmount > maxBalance) {
      read(utilsProvider).showErrorDialog('Please enter correct amount'.tr());
      return;
    }

    if (swapRecvWallet == SwapWallet.extern) {
      final addrType = swapAddrType(swapType());
      if (!read(walletProvider)
          .isAddrValid(swapRecvAddressExternal, addrType)) {
        read(utilsProvider).showErrorDialog('PLEASE_ENTER_CORRECT_ADDRESS'
            .tr(args: ['${addrTypeStr(addrType)}']));
        return;
      }
    }

    if (!swapActive) {
      read(utilsProvider).showErrorDialog('Nothing to accept');
      return;
    }

    if (type == SwapType.pegOut) {
      if (!await read(walletProvider).isAuthenticated()) {
        return;
      }
    }

    swapActive = false;
    final msg = To();
    msg.swapAccept = To_SwapAccept();
    if (swapRecvWallet == SwapWallet.extern) {
      msg.swapAccept.recvAddr = swapRecvAddressExternal;
    }
    read(walletProvider).sendMsg(msg);

    swapReset();
  }

  void setSwapAmount(int amount) {
    swapCancel();

    swapNetworkError = null;
    notifyListeners();

    if (amount == null || amount <= 0) {
      return;
    }

    var balanceAvailable = read(walletProvider).balances[swapSendAsset].toInt();
    if (swapSendWallet == SwapWallet.local && amount > balanceAvailable) {
      return;
    }

    swapActive = true;
    final msg = To();
    msg.swapRequest = To_SwapRequest();
    msg.swapRequest.sendAsset = swapSendAsset;
    msg.swapRequest.recvAsset = swapRecvAsset;
    msg.swapRequest.sendAmount = Int64(amount);
    read(walletProvider).sendMsg(msg);
  }

  void checkSelectedAsset() {
    final wallet = read(walletProvider);
    if (wallet.assets.length < 3) {
      return;
    }
    if (swapSendAsset == null) {
      swapPeg = false;
      swapSendAsset = wallet.liquidAssetId();
      swapRecvAsset = wallet.tetherAssetId();
    }
    final sendAssetsAllowed = swapSendAssets();
    if (!sendAssetsAllowed.contains(swapSendAsset)) {
      swapSendAsset = sendAssetsAllowed.first;
    }
    final recvAssetsAllowed = swapRecvAssets();
    if (!recvAssetsAllowed.contains(swapRecvAsset)) {
      swapRecvAsset = recvAssetsAllowed.first;
    }
    final allowedSendList = allowedSendWallets();
    if (!allowedSendList.contains(swapSendWallet)) {
      swapSendWallet = allowedSendList.first;
    }
    final allowedRecvList = allowedRecvWallets();
    if (!allowedRecvList.contains(swapRecvWallet)) {
      swapRecvWallet = allowedRecvList.first;
    }
  }

  void setSelectedLeftAsset(String asset) {
    swapReset();
    swapSendAsset = asset;
    didAssetReplaced = true;
    checkSelectedAsset();
    notifyListeners();
  }

  void setSelectedRightAsset(String asset) {
    swapReset();
    swapRecvAsset = asset;
    didAssetReplaced = true;
    checkSelectedAsset();
    notifyListeners();
  }

  void swapReset() {
    swapCancel();

    showInsufficientFunds = false;
    swapNetworkError = null;
    swapSendAmount = null;
    swapRecvAmount = null;
    swapNetworkFee = null;
    notifyListeners();
  }

  void swapCancel() {
    swapRecvAmount = null;
    swapNetworkFee = null;
    notifyListeners();

    if (swapActive) {
      swapActive = false;
      final msg = To();
      msg.swapCancel = Empty();
      read(walletProvider).sendMsg(msg);
    }
  }

  String swapPriceStr() {
    final sendAsset = read(walletProvider).assets[swapSendAsset];
    final recvAsset = read(walletProvider).assets[swapRecvAsset];

    Asset nonBtcAsset;
    int btcAmount;
    int nonBtcAmount;
    if (sendAsset.ticker == kLiquidBitcoinTicker) {
      nonBtcAsset = recvAsset;
      nonBtcAmount = swapRecvAmount;
      btcAmount = swapSendAmount;
    } else {
      nonBtcAsset = sendAsset;
      nonBtcAmount = swapSendAmount;
      btcAmount = swapRecvAmount;
    }
    var priceStr = '-';
    if (btcAmount != null && nonBtcAmount != null && btcAmount != 0) {
      final price = nonBtcAmount.toDouble() / btcAmount.toDouble();
      priceStr = price.toStringAsFixed(nonBtcAsset.precision.toInt());
    }
    return '1 ${kLiquidBitcoinTicker} = $priceStr ${nonBtcAsset.ticker}';
  }

  String swapConversionRateStr() {
    final rate = 100 * (swapRecvAmount ?? 0) / (swapSendAmount ?? 0);
    final rateStr = rate.toStringAsFixed(1);
    return '${rateStr}%';
  }

  List<SwapWallet> allowedSendWallets() {
    switch (swapType()) {
      case SwapType.atomic:
        return [SwapWallet.local];
      case SwapType.pegIn:
        return [SwapWallet.extern];
      case SwapType.pegOut:
        return [SwapWallet.local];
    }
    throw Exception('unexpected state');
  }

  List<SwapWallet> allowedRecvWallets() {
    switch (swapType()) {
      case SwapType.atomic:
        return [SwapWallet.local];
      case SwapType.pegIn:
        return [SwapWallet.local];
      case SwapType.pegOut:
        return [SwapWallet.extern];
    }
    throw Exception('unexpected state');
  }

  void setSendRadioCb(SwapWallet v) {
    final list = allowedSendWallets();
    if (!list.contains(v)) {
      return null;
    }

    swapSendWallet = v;
    checkSelectedAsset();
    notifyListeners();
  }

  void setRecvRadioCb(SwapWallet v) {
    final list = allowedRecvWallets();
    if (!list.contains(v)) {
      return null;
    }
    swapRecvWallet = v;
    checkSelectedAsset();
    notifyListeners();
  }

  void pegStop() {
    swapReset();
    read(walletProvider).status = Status.registered;
    notifyListeners();
  }

  void setSwapPeg(bool value) {
    if (swapPeg != value) {
      swapPeg = value;
      checkSelectedAsset();
      notifyListeners();
    }
  }

  AddrType swapAddrType(SwapType swapType) {
    if (swapType == SwapType.pegOut) {
      return AddrType.bitcoin;
    }
    return AddrType.elements;
  }

  String addrTypeStr(AddrType addrType) {
    switch (addrType) {
      case AddrType.bitcoin:
        return 'Bitcoin';
      case AddrType.elements:
        return 'Liquid';
    }
    throw Exception('unexpected value');
  }

  String swapTypeStr(SwapType swapType) {
    switch (swapType) {
      case SwapType.atomic:
        return 'Swap'.tr();
      case SwapType.pegIn:
        return 'Peg-In'.tr();
      case SwapType.pegOut:
        return 'Peg-Out'.tr();
    }
    throw Exception('unexpected value');
  }

  void showPegInInformation() async {
    final prefs = await SharedPreferences.getInstance();
    final _hidePegInInfo = prefs.getBool(hidePegInInfo) ?? false;
    if (_hidePegInInfo) {
      return;
    }

    await showDialog<void>(
      context: read(walletProvider).navigatorKey.currentContext,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: ShowPegInfoWidget(
            text:
                'Larger peg-In transactions may need 102 confirmations before your L-BTC are released.'
                    .tr(),
            onChanged: (value) {
              prefs.setBool(hidePegInInfo, value);
            },
          ),
        );
      },
    );
  }

  void showPegOutInformation() async {
    final prefs = await SharedPreferences.getInstance();
    final _hidePegOutInfo = prefs.getBool(hidePegOutInfo) ?? false;
    if (_hidePegOutInfo) {
      return;
    }

    await showDialog<void>(
      context: read(walletProvider).navigatorKey.currentContext,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: ShowPegInfoWidget(
            text:
                'Peg-Outs will be supported once our Peg-out Authorization Key is activated by the Liquid Federation.'
                    .tr(),
            onChanged: (value) {
              prefs.setBool(hidePegOutInfo, value);
            },
          ),
        );
      },
    );
  }

  void selectSwap() {
    read(walletProvider).status = Status.registered;

    final uiStateArgs = read(uiStateArgsProvider);
    uiStateArgs.walletMainArguments = uiStateArgs.walletMainArguments.copyWith(
      currentIndex: 2,
      navigationItem: WalletMainNavigationItem.swap,
    );
  }
}
