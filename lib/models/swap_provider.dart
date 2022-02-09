import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/widgets/show_peg_info_widget.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
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

  AccountAsset? _swapSendAsset;
  AccountAsset? get swapSendAsset => _swapSendAsset;

  AccountAsset? _swapRecvAsset;
  AccountAsset? get swapRecvAsset => _swapRecvAsset;

  bool _swapPeg = false;
  bool get swapPeg => _swapPeg;

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

  double? _price;
  double? get price => _price;
  set price(double? value) {
    _price = value;
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

  String _swapRecvAddressExternal = '';
  String get swapRecvAddressExternal => _swapRecvAddressExternal;
  set swapRecvAddressExternal(String swapRecvAddressExternal) {
    _swapRecvAddressExternal = swapRecvAddressExternal;
    notifyListeners();
  }

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

  // Functions //

  List<AccountAsset> swapSendAssets() {
    final wallet = read(walletProvider);
    if (swapPeg) {
      final swapPegList = <AccountAsset>[];

      swapPegList
          .add(AccountAsset(AccountType.regular, wallet.bitcoinAssetId()));
      swapPegList
          .add(AccountAsset(AccountType.regular, wallet.liquidAssetId()));
      swapPegList.add(AccountAsset(AccountType.amp, wallet.liquidAssetId()));

      return swapPegList;
    }
    return wallet.assets.entries
        .where((e) => e.key == wallet.liquidAssetId() || e.value.swapMarket)
        .map((e) => AccountAsset(AccountType.regular, e.key))
        .toList();
  }

  List<AccountAsset> swapRecvAssets() {
    final wallet = read(walletProvider);
    if (swapPeg) {
      if (swapSendAsset?.asset == wallet.liquidAssetId()) {
        return [AccountAsset(AccountType.regular, wallet.bitcoinAssetId())];
      }
      return [AccountAsset(AccountType.regular, wallet.liquidAssetId())];
    }

    if (swapSendAsset?.asset != wallet.liquidAssetId()) {
      return [AccountAsset(AccountType.regular, wallet.liquidAssetId())];
    }

    return wallet.assets.entries
        .where((e) => e.value.swapMarket)
        .map((e) => AccountAsset(AccountType.regular, e.key))
        .toList();
  }

  SwapType swapType() {
    final wallet = read(walletProvider);
    if (swapSendAsset?.asset == wallet.bitcoinAssetId() &&
        swapRecvAsset?.asset == wallet.liquidAssetId()) {
      return SwapType.pegIn;
    }
    if (swapSendAsset?.asset == wallet.liquidAssetId() &&
        swapRecvAsset?.asset == wallet.bitcoinAssetId()) {
      return SwapType.pegOut;
    }
    return SwapType.atomic;
  }

  void checkSelectedAsset() {
    final wallet = read(walletProvider);
    if (wallet.assets.length < 3) {
      return;
    }
    if (swapSendAsset == null) {
      _swapPeg = false;
      _swapSendAsset =
          AccountAsset(AccountType.regular, wallet.liquidAssetId());
      _swapRecvAsset =
          AccountAsset(AccountType.regular, wallet.tetherAssetId());
    }
    final sendAssetsAllowed = swapSendAssets();
    if (!sendAssetsAllowed.contains(swapSendAsset)) {
      _swapSendAsset = sendAssetsAllowed.first;
    }
    final recvAssetsAllowed = swapRecvAssets();
    if (!recvAssetsAllowed.contains(swapRecvAsset)) {
      _swapRecvAsset = recvAssetsAllowed.first;
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

  void setSelectedLeftAsset(AccountAsset asset) {
    swapReset();
    _swapSendAsset = asset;
    checkSelectedAsset();
    notifyListeners();
  }

  void setSelectedRightAsset(AccountAsset asset) {
    swapReset();
    _swapRecvAsset = asset;
    checkSelectedAsset();
    notifyListeners();
  }

  void swapReset() {
    swapNetworkError = '';
    swapSendAmount = 0;
    swapRecvAmount = 0;
    notifyListeners();

    swapState = SwapState.idle;
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
      return;
    }

    swapSendWallet = v;
    checkSelectedAsset();
    notifyListeners();
  }

  void setRecvRadioCb(SwapWallet v) {
    final list = allowedRecvWallets();
    if (!list.contains(v)) {
      return;
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
      _swapPeg = value;
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
      currentIndex: 3,
      navigationItem: WalletMainNavigationItem.swap,
    );
  }

  String? getPriceText() {
    final wallet = read(walletProvider);
    final swapType_ = swapType();

    if (swapType_ == SwapType.atomic) {
      final assetSend = swapSendAsset;
      final assetRecv = swapRecvAsset;
      final priceCopy = _price;
      if (assetSend == null || assetRecv == null || priceCopy == null) {
        return null;
      }
      final sendLiquid = assetSend.asset == wallet.liquidAssetId();
      final asset = sendLiquid ? assetRecv : assetSend;

      final priceString = priceStr(priceCopy, false);
      final assetTicker =
          wallet.getAssetById(asset.asset)?.ticker ?? kUnknownTicker;
      final swapText = '1 $kLiquidBitcoinTicker = $priceString $assetTicker';
      return swapText;
    }

    final serverStatus = wallet.serverStatus;
    if (serverStatus == null) {
      return null;
    }

    final serverPercent = swapType_ == SwapType.pegIn
        ? serverStatus.serverFeePercentPegIn
        : serverStatus.serverFeePercentPegOut;
    final percentConversion = 100 - serverPercent;
    final conversionStr = percentConversion.toStringAsFixed(2);
    final conversionText = 'Conversion rate $conversionStr%';
    return conversionText;
  }
}
