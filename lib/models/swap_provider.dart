import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/widgets/show_peg_info_widget.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

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

enum SwapState {
  idle,
  sent,
}

class SwapChangeNotifierProvider with ChangeNotifier {
  final Reader read;

  SwapChangeNotifierProvider(this.read);

  static const hidePegInInfo = 'hide_peg_in_info';
  static const hidePegOutInfo = 'hide_peg_out_info_new';

  SwapState _swapState = SwapState.idle;
  SwapState get swapState => _swapState;
  set swapState(SwapState value) {
    _swapState = value;
    notifyListeners();
  }

  bool _showInsufficientFunds = false;
  bool get showInsufficientFunds => _showInsufficientFunds;
  set showInsufficientFunds(bool showInsufficientFunds) {
    if (swapSendWallet == SwapWallet.local) {
      _showInsufficientFunds = showInsufficientFunds;
    } else {
      _showInsufficientFunds = false;
    }
  }

  String? _swapSendAsset;
  String? get swapSendAsset => _swapSendAsset;
  set swapSendAsset(String? swapSendAsset) {
    _swapSendAsset = swapSendAsset;
    notifyListeners();
  }

  String? _swapRecvAsset;
  String? get swapRecvAsset => _swapRecvAsset;

  set swapRecvAsset(String? swapRecvAsset) {
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

  int _swapSendAmount = 0;
  int get swapSendAmount => _swapSendAmount;
  set swapSendAmount(int swapSendAmount) {
    _swapSendAmount = swapSendAmount;
    notifyListeners();
  }

  int _swapRecvAmount = 0;
  int get swapRecvAmount => _swapRecvAmount;
  set swapRecvAmount(int swapRecvAmount) {
    _swapRecvAmount = swapRecvAmount;
    notifyListeners();
  }

  int _swapNetworkFee = 0;
  int get swapNetworkFee => _swapNetworkFee;
  set swapNetworkFee(int swapNetworkFee) {
    _swapNetworkFee = swapNetworkFee;
    notifyListeners();
  }

  String _swapRecvAddressExternal = '';
  String get swapRecvAddressExternal => _swapRecvAddressExternal;
  set swapRecvAddressExternal(String swapRecvAddressExternal) {
    _swapRecvAddressExternal = swapRecvAddressExternal;
    notifyListeners();
  }

  bool swapActive = false;

  String _swapNetworkError = '';
  String get swapNetworkError => _swapNetworkError;
  set swapNetworkError(String swapNetworkError) {
    _swapNetworkError = swapNetworkError;
    if (swapNetworkError.isNotEmpty) {
      swapState = SwapState.idle;
    }
    notifyListeners();
  }

  String? _swapPegAddressServer;
  String? get swapPegAddressServer => _swapPegAddressServer;
  set swapPegAddressServer(String? swapPegAddressServer) {
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
      final swapPegList = <String>[];

      if (wallet.bitcoinAssetId() != null) {
        swapPegList.add(wallet.bitcoinAssetId()!);
      }

      if (wallet.liquidAssetId() != null) {
        swapPegList.add(wallet.liquidAssetId()!);
      }

      return swapPegList;
    }
    return wallet.assets.keys
        .where((element) => element != wallet.bitcoinAssetId())
        .toList();
  }

  List<String> swapRecvAssets() {
    final wallet = read(walletProvider);
    if (swapPeg) {
      if (swapSendAsset == wallet.liquidAssetId() &&
          wallet.bitcoinAssetId() != null) {
        return [wallet.bitcoinAssetId()!];
      } else if (wallet.liquidAssetId() != null) {
        return [wallet.liquidAssetId()!];
      }
    }

    if (swapSendAsset != wallet.liquidAssetId() &&
        wallet.liquidAssetId() != null) {
      return [wallet.liquidAssetId()!];
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

  void swapAccept(BuildContext context, int recvAmount) async {
    final type = swapType();

    if (type == SwapType.pegIn) {
      final msg = To();
      msg.pegRequest = Empty();
      read(walletProvider).sendMsg(msg);
      swapState = SwapState.sent;
      return;
    }

    final maxBalance = swapSendWallet == SwapWallet.local
        ? read(balancesProvider).balances[swapSendAsset] ?? 0
        : kMaxCoins;
    if (swapSendAmount <= 0 || swapSendAmount > maxBalance) {
      await read(utilsProvider)
          .showErrorDialog('Please enter correct amount'.tr());
      swapState = SwapState.idle;
      return;
    }

    if (swapRecvWallet == SwapWallet.extern) {
      final addrType = swapAddrType(swapType());
      if (!read(walletProvider)
          .isAddrValid(swapRecvAddressExternal, addrType)) {
        await read(utilsProvider).showErrorDialog('PLEASE_ENTER_CORRECT_ADDRESS'
            .tr(args: ['${addrTypeStr(addrType)}']));
        swapState = SwapState.idle;
        return;
      }
    }

    if (!swapActive) {
      await read(utilsProvider).showErrorDialog('Nothing to accept');
      swapState = SwapState.idle;
      return;
    }

    swapActive = false;
    final msg = To();
    msg.swapAccept = To_SwapAccept();
    if (swapRecvWallet == SwapWallet.extern) {
      msg.swapAccept.recvAddr = swapRecvAddressExternal;
    }
    msg.swapAccept.recvAmount = Int64(recvAmount);
    read(walletProvider).sendMsg(msg);
    swapState = SwapState.sent;
  }

  void setSwapAmount(int amount, int blocks) {
    swapCancel();

    swapNetworkError = '';
    notifyListeners();

    if (amount <= 0) {
      return;
    }

    var balanceAvailable =
        read(balancesProvider).balances[swapSendAsset]?.toInt() ?? 0;
    if (swapSendWallet == SwapWallet.local && amount > balanceAvailable) {
      return;
    }

    if (swapSendAsset == null || swapRecvAsset == null) {
      logger.w('Expected non null asset: $swapSendAsset and $swapRecvAsset');
    }

    swapActive = true;
    final msg = To();
    msg.swapRequest = To_SwapRequest();
    msg.swapRequest.sendAsset = swapSendAsset!;
    msg.swapRequest.recvAsset = swapRecvAsset!;
    msg.swapRequest.sendAmount = Int64(amount);
    msg.swapRequest.blocks = blocks;
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
    swapNetworkError = '';
    swapSendAmount = 0;
    swapRecvAmount = 0;
    swapNetworkFee = 0;
    notifyListeners();

    swapState = SwapState.idle;
  }

  void swapCancel() {
    swapRecvAmount = 0;
    swapNetworkFee = 0;
    notifyListeners();

    if (swapActive) {
      swapActive = false;
      final msg = To();
      msg.swapCancel = Empty();
      read(walletProvider).sendMsg(msg);
      swapState = SwapState.idle;
    }
  }

  String swapPriceStr() {
    final sendAsset = read(walletProvider).assets[swapSendAsset];
    final recvAsset = read(walletProvider).assets[swapRecvAsset];

    Asset? nonBtcAsset;
    int btcAmount;
    int nonBtcAmount;
    if (sendAsset?.ticker == kLiquidBitcoinTicker) {
      nonBtcAsset = recvAsset;
      nonBtcAmount = swapRecvAmount;
      btcAmount = swapSendAmount;
    } else {
      nonBtcAsset = sendAsset;
      nonBtcAmount = swapSendAmount;
      btcAmount = swapRecvAmount;
    }
    var priceStr = '-';
    if (btcAmount != 0) {
      final price = nonBtcAmount.toDouble() / btcAmount.toDouble();
      priceStr = price.toStringAsFixed(nonBtcAsset?.precision.toInt() ?? 0);
    }
    return '1 $kLiquidBitcoinTicker = $priceStr ${nonBtcAsset?.ticker ?? ''}';
  }

  String swapConversionRateStr() {
    final rate = 100 * (swapRecvAmount / swapSendAmount);
    final rateStr = rate.toStringAsFixed(1);
    return '$rateStr%';
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
  }

  void showPegInInformation() async {
    final prefs = await SharedPreferences.getInstance();
    final _hidePegInInfo = prefs.getBool(hidePegInInfo) ?? false;
    if (_hidePegInInfo) {
      return;
    }

    final context = read(walletProvider).navigatorKey.currentContext;
    if (context == null) {
      logger.w('Context cannot be null');
      return;
    }

    await showDialog<void>(
      context: context,
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

    final context = read(walletProvider).navigatorKey.currentContext;
    if (context == null) {
      logger.w('Context cannot be null');
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: ShowPegInfoWidget(
            text: 'PEGOUT_WARNING'.tr(),
            onChanged: (value) async {
              await prefs.setBool(hidePegOutInfo, value);
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
