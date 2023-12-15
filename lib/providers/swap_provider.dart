import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideswap/common/enums.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/widgets/show_peg_info_widget.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

final swapProvider = ChangeNotifierProvider<SwapChangeNotifierProvider>(
    (ref) => SwapChangeNotifierProvider(ref));

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
  final Ref ref;

  SwapChangeNotifierProvider(this.ref);

  static const hidePegInInfo = 'hide_peg_in_info';
  static const hidePegOutInfo = 'hide_peg_out_info_new';

  AccountAsset? _swapSendAsset;
  AccountAsset? get swapSendAsset => _swapSendAsset;
  set swapSendAsset(AccountAsset? value) {
    _swapSendAsset = value;
    notifyListeners();
  }

  AccountAsset? _swapRecvAsset;
  AccountAsset? get swapRecvAsset => _swapRecvAsset;
  set swapRecvAsset(AccountAsset? value) {
    _swapRecvAsset = value;
    notifyListeners();
  }

  bool _swapPeg = false;
  bool get swapPeg => _swapPeg;
  set swapPeg(bool value) {
    _swapPeg = value;
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

  String _swapRecvAddressExternal = '';
  String get swapRecvAddressExternal => _swapRecvAddressExternal;
  set swapRecvAddressExternal(String swapRecvAddressExternal) {
    _swapRecvAddressExternal = swapRecvAddressExternal;
    validateAddress(_swapRecvAddressExternal);
    notifyListeners();
  }

  String? _swapPegAddressServer;
  String? get swapPegAddressServer => _swapPegAddressServer;
  set swapPegAddressServer(String? swapPegAddressServer) {
    _swapPegAddressServer = swapPegAddressServer;
    notifyListeners();
  }

  // Functions //
  void validateAddress(String text) {
    if (text.isEmpty) {
      ref.read(swapAddressErrorStateProvider.notifier).state = null;
      ref.read(showAddressLabelStateProvider.notifier).state = false;
      return;
    }

    if (ref.read(isAddrTypeValidProvider(text, AddrType.bitcoin))) {
      ref.read(swapAddressErrorStateProvider.notifier).state = null;
      ref.read(showAddressLabelStateProvider.notifier).state = true;
    } else {
      ref.read(swapAddressErrorStateProvider.notifier).state =
          'Wrong address'.tr();
      ref.read(showAddressLabelStateProvider.notifier).state = false;
    }
  }

  List<AccountAsset> swapSendAssets() {
    if (swapPeg) {
      final swapPegList = <AccountAsset>[];

      swapPegList
          .add(AccountAsset(AccountType.reg, ref.read(bitcoinAssetIdProvider)));
      swapPegList.add(
          AccountAsset(AccountType.reg, ref.read(liquidAssetIdStateProvider)));
      swapPegList.add(
          AccountAsset(AccountType.amp, ref.read(liquidAssetIdStateProvider)));

      return swapPegList;
    }
    final assets = ref.read(assetsStateProvider);
    return assets.entries
        .where((e) =>
            e.key == ref.read(liquidAssetIdStateProvider) ||
            e.value.instantSwaps)
        .map((e) => AccountAsset(AccountType.reg, e.key))
        .toList();
  }

  List<AccountAsset> swapRecvAssets() {
    if (swapPeg) {
      if (swapSendAsset?.assetId == ref.read(liquidAssetIdStateProvider)) {
        return [
          AccountAsset(AccountType.reg, ref.read(bitcoinAssetIdProvider))
        ];
      }
      return [
        AccountAsset(AccountType.reg, ref.read(liquidAssetIdStateProvider))
      ];
    }

    if (swapSendAsset?.assetId != ref.read(liquidAssetIdStateProvider)) {
      return [
        AccountAsset(AccountType.reg, ref.read(liquidAssetIdStateProvider))
      ];
    }

    final assets = ref.read(assetsStateProvider);
    return assets.entries
        .where((e) => e.value.instantSwaps)
        .map((e) => AccountAsset(AccountType.reg, e.key))
        .toList();
  }

  void checkSelectedAsset() {
    final assets = ref.read(assetsStateProvider);
    if (assets.length < 3) {
      return;
    }
    if (swapSendAsset == null) {
      _swapPeg = false;
      _swapSendAsset =
          AccountAsset(AccountType.reg, ref.read(liquidAssetIdStateProvider));
      _swapRecvAsset =
          AccountAsset(AccountType.reg, ref.read(tetherAssetIdStateProvider));
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

  void clearNetworkStates() {
    Future.microtask(() {
      ref.read(swapNetworkErrorStateProvider.notifier).state = '';
      ref
          .read(satoshiSendAmountStateNotifierProvider.notifier)
          .setSatoshiAmount(0);
      ref
          .read(satoshiRecvAmountStateNotifierProvider.notifier)
          .setSatoshiAmount(0);
    });
  }

  void swapReset() {
    Future.microtask(() {
      clearNetworkStates();
      ref.read(swapStateProvider.notifier).state = SwapState.idle;
    });
  }

  void clearAmounts() {
    Future.microtask(() {
      clearNetworkStates();
      ref.read(swapSendAmountChangeNotifierProvider).setAmount('');
      ref.read(swapRecvAmountChangeNotifierProvider).setAmount('');
      ref.read(swapPriceSubscribeStateNotifierProvider.notifier).setEmpty();
      ref
          .read(priceStreamSubscribeChangeNotifierProvider)
          .subscribeToPriceStream();
    });
  }

  String swapPriceStr() {
    final sendAsset = ref.read(assetsStateProvider)[swapSendAsset?.assetId];
    final recvAsset = ref.read(assetsStateProvider)[swapRecvAsset?.assetId];

    Asset? nonBtcAsset;
    int btcAmount;
    int nonBtcAmount;
    if (sendAsset?.ticker == kLiquidBitcoinTicker) {
      nonBtcAsset = recvAsset;
      nonBtcAmount = ref.read(satoshiRecvAmountStateNotifierProvider);
      btcAmount = ref.read(satoshiSendAmountStateNotifierProvider);
    } else {
      nonBtcAsset = sendAsset;
      nonBtcAmount = ref.read(satoshiSendAmountStateNotifierProvider);
      btcAmount = ref.read(satoshiRecvAmountStateNotifierProvider);
    }
    var priceStr = '-';
    if (btcAmount != 0) {
      final price = nonBtcAmount.toDouble() / btcAmount.toDouble();
      priceStr = price.toStringAsFixed(nonBtcAsset?.precision.toInt() ?? 0);
    }
    return '1 $kLiquidBitcoinTicker = $priceStr ${nonBtcAsset?.ticker ?? ''}';
  }

  SwapType swapType() {
    final bitcoinAssetId = ref.read(bitcoinAssetIdProvider);
    final liquidAssetId = ref.read(liquidAssetIdStateProvider);
    if (swapSendAsset?.assetId == bitcoinAssetId &&
        swapRecvAsset?.assetId == liquidAssetId) {
      return SwapType.pegIn;
    }
    if (swapSendAsset?.assetId == liquidAssetId &&
        swapRecvAsset?.assetId == bitcoinAssetId) {
      return SwapType.pegOut;
    }
    return SwapType.atomic;
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
    ref.read(pageStatusStateProvider.notifier).setStatus(Status.registered);
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

  void onPegOutAmountReceived(From_PegOutAmount value) {
    switch (value.whichResult()) {
      case From_PegOutAmount_Result.errorMsg:
        ref.read(swapNetworkErrorStateProvider.notifier).state = value.errorMsg;
        break;
      case From_PegOutAmount_Result.amounts:
        if (value.amounts.isSendEntered) {
          final amountStr = ref.read(amountToStringProvider).amountToString(
              AmountToStringParameters(
                  amount: value.amounts.recvAmount.toInt()));
          ref.read(swapRecvAmountChangeNotifierProvider).setAmount(amountStr);
        } else {
          final amountStr = ref.read(amountToStringProvider).amountToString(
              AmountToStringParameters(
                  amount: value.amounts.sendAmount.toInt()));
          ref.read(swapSendAmountChangeNotifierProvider).setAmount(amountStr);
        }
        break;
      case From_PegOutAmount_Result.notSet:
        throw Exception('unexpected message');
    }
  }

  void showPegInInformation() async {
    final navigatorKey = ref.read(navigatorKeyProvider);
    final prefs = await SharedPreferences.getInstance();
    final internalHidePegInInfo = prefs.getBool(hidePegInInfo) ?? false;
    if (internalHidePegInInfo) {
      return;
    }

    await showDialog<void>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ShowPegInfoWidget(
            text:
                'Larger peg-in transactions may need 102 confirmations before your L-BTC are released.'
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
    final internalHidePegOutInfo = prefs.getBool(hidePegOutInfo) ?? false;
    if (internalHidePegOutInfo) {
      return;
    }

    final navigatorKey = ref.read(navigatorKeyProvider);

    await showDialog<void>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
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
    ref.read(pageStatusStateProvider.notifier).setStatus(Status.registered);

    final walletMainArguments = ref.read(uiStateArgsNotifierProvider);
    ref.read(uiStateArgsNotifierProvider.notifier).setWalletMainArguments(
          walletMainArguments.copyWith(
            currentIndex: 3,
            navigationItemEnum: WalletMainNavigationItemEnum.swap,
          ),
        );
  }

  void onMaxSendPressed() {
    final swapSendAccount = swapSendAsset;
    final precision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: swapSendAsset?.assetId);
    final balance = ref.read(balancesNotifierProvider)[swapSendAccount];
    final balanceStr = ref.read(amountToStringProvider).amountToString(
        AmountToStringParameters(amount: balance ?? 0, precision: precision));

    var amount = balanceStr;
    ref.read(swapPriceSubscribeStateNotifierProvider.notifier).setSend();

    ref.read(swapSendAmountChangeNotifierProvider).setAmount(amount);
    ref
        .read(priceStreamSubscribeChangeNotifierProvider)
        .subscribeToPriceStream();
  }

  void setDeliverAsset(AccountAsset accountAsset) {
    clearAmounts();
    setSelectedLeftAsset(accountAsset);
    ref
        .read(priceStreamSubscribeChangeNotifierProvider)
        .subscribeToPriceStream();
  }

  void setReceiveAsset(AccountAsset accountAsset) {
    clearAmounts();
    setSelectedRightAsset(accountAsset);
    ref
        .read(priceStreamSubscribeChangeNotifierProvider)
        .subscribeToPriceStream();
  }

  void toggleAssets() {
    setSelectedLeftAsset(swapRecvAsset!);
    setSelectedRightAsset(swapSendAsset!);
    swapRecvAddressExternal = '';
    clearAmounts();
    ref
        .read(priceStreamSubscribeChangeNotifierProvider)
        .subscribeToPriceStream();
  }

  void switchToSwaps() {
    setSwapPeg(false);
    swapRecvAddressExternal = '';
    clearAmounts();
    swapReset();
    ref
        .read(priceStreamSubscribeChangeNotifierProvider)
        .subscribeToPriceStream();
  }

  void switchToPegs() {
    setSwapPeg(true);
    setSelectedLeftAsset(
        AccountAsset(AccountType.reg, ref.read(bitcoinAssetIdProvider)));
    setSelectedRightAsset(
        AccountAsset(AccountType.reg, ref.read(liquidAssetIdStateProvider)));
    swapRecvAddressExternal = '';
    clearAmounts();
    swapReset();
    ref
        .read(priceStreamSubscribeChangeNotifierProvider)
        .subscribeToPriceStream();
  }

  void swapAccept() async {
    final wallet = ref.read(walletProvider);
    // Remember amounts before calling async functions
    final sendAmount =
        ref.read(swapSendAmountChangeNotifierProvider).satoshiAmount;
    final recvAmount =
        ref.read(swapRecvAmountChangeNotifierProvider).satoshiAmount;
    final price = ref.read(swapPriceStateNotifierProvider);
    final type = swapType();

    final maxBalance = swapSendWallet == SwapWallet.local
        ? ref.read(balancesNotifierProvider)[swapSendAsset] ?? 0
        : kMaxCoins;
    if (type != SwapType.pegIn) {
      if (sendAmount <= 0 || sendAmount > maxBalance) {
        await ref
            .read(utilsProvider)
            .showErrorDialog('Please enter correct amount'.tr());
        return;
      }
    }

    if (type == SwapType.pegOut) {
      final addrType = swapAddrType(type);
      if (!ref
          .read(isAddrTypeValidProvider(swapRecvAddressExternal, addrType))) {
        await ref.read(utilsProvider).showErrorDialog(
            'PLEASE_ENTER_CORRECT_ADDRESS'.tr(args: [(addrTypeStr(addrType))]));
        return;
      }
    }

    ref.read(authInProgressStateProvider.notifier).state = true;
    final authSucceed = await wallet.isAuthenticated();
    ref.read(authInProgressStateProvider.notifier).state = false;
    if (!authSucceed) {
      return;
    }

    if (type == SwapType.pegIn) {
      final msg = To();
      msg.pegInRequest = To_PegInRequest();
      wallet.sendMsg(msg);
      ref.read(swapStateProvider.notifier).state = SwapState.sent;
      ref.read(authInProgressStateProvider.notifier).state = false;
      return;
    }

    if (type == SwapType.pegOut) {
      final feeRate = ref.read(bitcoinCurrentFeeRateStateNotifierProvider)
          as SwapCurrentFeeRateData;
      final subscribe = ref.read(swapPriceSubscribeStateNotifierProvider);

      final msg = To();
      msg.pegOutRequest = To_PegOutRequest();
      msg.pegOutRequest.sendAmount = Int64(sendAmount);
      msg.pegOutRequest.recvAmount = Int64(recvAmount);
      msg.pegOutRequest.isSendEntered =
          subscribe == const SwapPriceSubscribeState.send();
      msg.pegOutRequest.recvAddr = swapRecvAddressExternal;
      msg.pegOutRequest.blocks = feeRate.feeRate.blocks;
      msg.pegOutRequest.feeRate = feeRate.feeRate.value;
      msg.pegOutRequest.account = getAccount(swapSendAsset!.account);
      wallet.sendMsg(msg);
      ref.read(swapStateProvider.notifier).state = SwapState.sent;
    }

    if (type == SwapType.atomic) {
      final msg = To();
      msg.swapRequest = To_SwapRequest();
      final sendBitcoins =
          swapSendAsset?.assetId == ref.read(liquidAssetIdStateProvider);
      final asset = sendBitcoins ? swapRecvAsset : swapSendAsset;
      msg.swapRequest.sendBitcoins = sendBitcoins;
      msg.swapRequest.asset = asset?.assetId ?? '';
      msg.swapRequest.sendAmount = Int64(sendAmount);
      msg.swapRequest.recvAmount = Int64(recvAmount);
      msg.swapRequest.price = price ?? 0.0;
      wallet.sendMsg(msg);
      ref.read(swapStateProvider.notifier).state = SwapState.sent;
    }
  }
}

final swapPriceSubscribeStateNotifierProvider =
    StateNotifierProvider.autoDispose<SwapPriceSubscribeStateNotifierProvider,
        SwapPriceSubscribeState>((ref) {
  return SwapPriceSubscribeStateNotifierProvider(ref);
});

class SwapPriceSubscribeStateNotifierProvider
    extends StateNotifier<SwapPriceSubscribeState> {
  final Ref ref;

  SwapPriceSubscribeStateNotifierProvider(this.ref)
      : super(const SwapPriceSubscribeState.empty());

  void setEmpty() => state = const SwapPriceSubscribeState.empty();
  void setSend() => state = const SwapPriceSubscribeState.send();
  void setRecv() => state = const SwapPriceSubscribeState.recv();
}

final bitcoinCurrentFeeRateStateNotifierProvider =
    StateNotifierProvider.autoDispose<
        BitcoinCurrentFeeRateStateNotifierProvider, SwapCurrentFeeRate>(
  (ref) {
    final provider = BitcoinCurrentFeeRateStateNotifierProvider(
        ref, const SwapCurrentFeeRate.empty());
    ref.listen<BitcoinFeeRatesProvider>(bitcoinFeeRatesProvider,
        (previous, next) {
      provider.updateFeeRate(next.feeRates);
    });
    return provider;
  },
);

class BitcoinCurrentFeeRateStateNotifierProvider
    extends StateNotifier<SwapCurrentFeeRate> {
  final Ref ref;

  BitcoinCurrentFeeRateStateNotifierProvider(
      this.ref, SwapCurrentFeeRate feeRate)
      : super(feeRate) {
    final feeRates = ref.read(walletProvider).serverStatus?.bitcoinFeeRates;
    if (feeRates != null && feeRates.isNotEmpty) {
      state = SwapCurrentFeeRate.data(feeRate: feeRates.first);
    }
  }

  void updateFeeRate(List<FeeRate> feeRates) {
    if (feeRates.isEmpty) {
      return;
    }
    state.when(empty: () {
      state = SwapCurrentFeeRate.data(feeRate: feeRates.first);
    }, data: (feeRate) {
      final updatedFeeRate =
          feeRates.firstWhere((e) => e.blocks == feeRate.blocks);
      state = SwapCurrentFeeRate.data(feeRate: updatedFeeRate);
    });
  }

  void setFeeRate(FeeRate feeRate) {
    state = SwapCurrentFeeRate.data(feeRate: feeRate);
    ref
        .read(priceStreamSubscribeChangeNotifierProvider)
        .subscribeToPriceStream();
  }

  void setEmpty() {
    state = const SwapCurrentFeeRate.empty();
  }
}

final bitcoinFeeRatesProvider =
    Provider.autoDispose<BitcoinFeeRatesProvider>((ref) {
  final swapType = ref.read(swapProvider).swapType();
  final swapRecvWallet =
      ref.watch(swapProvider.select((p) => p.swapRecvWallet));
  final serverStatus = ref.watch(walletProvider.select((p) => p.serverStatus));

  final feeRates = (swapType == SwapType.pegOut &&
          swapRecvWallet == SwapWallet.extern &&
          serverStatus != null)
      ? serverStatus.bitcoinFeeRates
      : <FeeRate>[];

  return BitcoinFeeRatesProvider(ref, feeRates);
});

class BitcoinFeeRatesProvider {
  final Ref ref;
  final List<FeeRate> feeRates;

  BitcoinFeeRatesProvider(this.ref, this.feeRates);

  String feeRateDescription(FeeRate feeRate) {
    final blocks = feeRate.blocks;
    final value = feeRate.value;
    final duration = Duration(minutes: blocks * 10);
    if (duration.inMinutes <= 60) {
      return 'BLOCKS_MINUTES'
          .plural(blocks, args: ['$blocks', '${duration.inMinutes}', '$value']);
    } else {
      return 'BLOCKS_HOURS'
          .plural(blocks, args: ['$blocks', '${duration.inHours}', '$value']);
    }
  }
}

final swapSendAmountChangeNotifierProvider =
    ChangeNotifierProvider.autoDispose<SwapSendAmountProvider>((ref) {
  return SwapSendAmountProvider(ref);
});

class SwapSendAmountProvider extends ChangeNotifier {
  final Ref ref;
  String amount = '';
  int satoshiAmount = 0;

  SwapSendAmountProvider(this.ref);

  void setAmount(String value) {
    amount = value;

    if (amount.isEmpty) {
      satoshiAmount = 0;
    } else {
      final sendAsset = ref.read(swapProvider).swapSendAsset;
      satoshiAmount = ref
          .read(walletProvider)
          .getSatoshiForAmount(sendAsset?.assetId ?? '', amount);
    }

    notifyListeners();
  }
}

final swapRecvAmountChangeNotifierProvider =
    ChangeNotifierProvider.autoDispose<SwapRecvAmountProvider>((ref) {
  return SwapRecvAmountProvider(ref);
});

class SwapRecvAmountProvider extends ChangeNotifier {
  final Ref ref;
  String amount = '';
  int satoshiAmount = 0;

  SwapRecvAmountProvider(this.ref);

  void setAmount(String value) {
    amount = value;

    if (amount.isEmpty) {
      satoshiAmount = 0;
    } else {
      final recvAsset = ref.read(swapProvider).swapRecvAsset;
      satoshiAmount = ref
          .read(walletProvider)
          .getSatoshiForAmount(recvAsset?.assetId ?? '', amount);
    }

    notifyListeners();
  }
}

final showInsufficientFundsProvider = Provider.autoDispose<bool>((ref) {
  final serverError = ref.watch(swapNetworkErrorStateProvider);
  if (serverError.isNotEmpty) {
    return false;
  }

  final swapSendAsset = ref.watch(swapProvider.select((p) => p.swapSendAsset));
  final balance = ref.watch(balancesNotifierProvider)[swapSendAsset] ?? 0;
  final satoshiAmount = ref.watch(
      swapSendAmountChangeNotifierProvider.select((p) => p.satoshiAmount));
  return satoshiAmount > 0 && satoshiAmount > balance;
});

final priceStreamSubscribeChangeNotifierProvider =
    ChangeNotifierProvider.autoDispose<PriceStreamSubscribeProvider>((ref) {
  final provider = PriceStreamSubscribeProvider(ref);
  final subscription = ref
      .read(walletProvider)
      .updatePriceStream
      .listen(provider.onUpdatePriceStreamChanged);

  ref.onDispose(() {
    subscription.cancel();
  });

  return provider;
});

class PriceStreamSubscribeProvider extends ChangeNotifier {
  final Ref ref;
  From_UpdatePriceStream msg = From_UpdatePriceStream();

  PriceStreamSubscribeProvider(this.ref);

  void onUpdatePriceStreamChanged(From_UpdatePriceStream value) {
    msg = value;

    if (msg.hasRecvAmount()) {
      ref
          .read(satoshiRecvAmountStateNotifierProvider.notifier)
          .setSatoshiAmount(msg.recvAmount.toInt());
    }

    if (msg.hasSendAmount()) {
      ref
          .read(satoshiSendAmountStateNotifierProvider.notifier)
          .setSatoshiAmount(msg.sendAmount.toInt());
    }
    notifyListeners();
  }

  Future<void> subscribeToPriceStream() async {
    Future.microtask(() async {
      ref.read(swapProvider).swapReset();
    });
    final type = ref.read(swapProvider).swapType();

    ref.read(walletProvider).unsubscribeFromPriceStream();

    if (type == SwapType.atomic) {
      final swapSendAsset = ref.read(swapProvider).swapSendAsset;
      final swapRecvAsset = ref.read(swapProvider).swapRecvAsset;
      final subscribe = ref.read(swapPriceSubscribeStateNotifierProvider);
      final sendAmount = (subscribe == const SwapPriceSubscribeState.send())
          ? ref.read(swapSendAmountChangeNotifierProvider).satoshiAmount
          : null;
      final recvAmount = (subscribe == const SwapPriceSubscribeState.recv())
          ? ref.read(swapRecvAmountChangeNotifierProvider).satoshiAmount
          : null;
      final sendBitcoins =
          swapSendAsset?.assetId == ref.read(liquidAssetIdStateProvider);
      final asset = sendBitcoins ? swapRecvAsset : swapSendAsset;
      ref.read(walletProvider).subscribeToPriceStream(
            asset?.assetId ?? '',
            sendBitcoins,
            sendAmount,
            recvAmount,
          );
    } else if (type == SwapType.pegOut) {
      final subscribe = ref.read(swapPriceSubscribeStateNotifierProvider);
      final swapSendAsset = ref.read(swapProvider).swapSendAsset;
      final feeRate = ref.read(bitcoinCurrentFeeRateStateNotifierProvider);
      final sendAmount = (subscribe == const SwapPriceSubscribeState.send())
          ? ref.read(swapSendAmountChangeNotifierProvider).satoshiAmount
          : null;
      final recvAmount = (subscribe == const SwapPriceSubscribeState.recv())
          ? ref.read(swapRecvAmountChangeNotifierProvider).satoshiAmount
          : null;
      if (((sendAmount ?? 0) > 0 || (recvAmount ?? 0) > 0) &&
          feeRate is SwapCurrentFeeRateData) {
        ref.read(walletProvider).getPegOutAmount(sendAmount, recvAmount,
            feeRate.feeRate.value, swapSendAsset!.account);
      }
    }
  }
}

final satoshiRecvAmountStateNotifierProvider =
    StateNotifierProvider.autoDispose<SatoshiRecvAmountProvider, int>((ref) {
  return SatoshiRecvAmountProvider(ref);
});

class SatoshiRecvAmountProvider extends StateNotifier<int> {
  final Ref ref;

  SatoshiRecvAmountProvider(this.ref) : super(0);

  void setSatoshiAmount(int value) {
    state = value;
  }
}

final satoshiSendAmountStateNotifierProvider =
    StateNotifierProvider.autoDispose<SatoshiSendAmountProvider, int>((ref) {
  return SatoshiSendAmountProvider(ref);
});

class SatoshiSendAmountProvider extends StateNotifier<int> {
  final Ref ref;

  SatoshiSendAmountProvider(this.ref) : super(0);

  void setSatoshiAmount(int value) {
    state = value;
  }
}

final recvAmountPriceStreamWatcherProvider =
    Provider.autoDispose<SwapRecvAmountPriceStream>((ref) {
  final authInProgress = ref.watch(authInProgressStateProvider);
  final swapState = ref.watch(swapStateProvider);

  if (swapState != SwapState.idle || authInProgress) {
    return const SwapRecvAmountPriceStream.empty();
  }

  final subscribeState = ref.watch(swapPriceSubscribeStateNotifierProvider);

  if (subscribeState != const SwapPriceSubscribeState.send()) {
    return const SwapRecvAmountPriceStream.empty();
  }

  final recvAsset = ref.watch(swapProvider.select((p) => p.swapRecvAsset));
  final recvAmount = ref.watch(satoshiRecvAmountStateNotifierProvider);
  final recvPrecision = ref
      .read(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: recvAsset?.assetId);

  final amountProvider = ref.watch(amountToStringProvider);
  final recvAmountStr = amountProvider.amountToString(
      AmountToStringParameters(amount: recvAmount, precision: recvPrecision));
  final recvValue = replaceCharacterOnPosition(
    input: recvAmount != 0 ? recvAmountStr : '',
  );
  return SwapRecvAmountPriceStream.data(value: recvValue);
});

final sendAmountPriceStreamWatcherProvider =
    Provider.autoDispose<SwapSendAmountPriceStream>((ref) {
  final authInProgress = ref.watch(authInProgressStateProvider);
  final swapState = ref.watch(swapStateProvider);

  if (swapState != SwapState.idle || authInProgress) {
    return const SwapSendAmountPriceStream.empty();
  }

  final subscribeState = ref.watch(swapPriceSubscribeStateNotifierProvider);

  if (subscribeState != const SwapPriceSubscribeState.recv()) {
    return const SwapSendAmountPriceStream.empty();
  }

  final msg = ref
      .watch(priceStreamSubscribeChangeNotifierProvider.select((p) => p.msg));
  if (!msg.hasSendAmount()) {
    return const SwapSendAmountPriceStream.empty();
  }

  final sendAsset = ref.watch(swapProvider.select((p) => p.swapSendAsset));
  final sendAmount = ref.watch(satoshiSendAmountStateNotifierProvider);
  final sendPrecision = ref
      .read(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: sendAsset?.assetId);
  final amountProvider = ref.watch(amountToStringProvider);
  final sendAmountStr = amountProvider.amountToString(
      AmountToStringParameters(amount: sendAmount, precision: sendPrecision));
  final sendValue = replaceCharacterOnPosition(
    input: sendAmount != 0 ? sendAmountStr : '',
  );

  return SwapSendAmountPriceStream.data(value: sendValue);
});

final authInProgressStateProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final swapStateProvider =
    StateProvider.autoDispose<SwapState>((ref) => SwapState.idle);

final swapNetworkErrorStateProvider = StateProvider.autoDispose<String>((ref) {
  final msg = ref
      .watch(priceStreamSubscribeChangeNotifierProvider.select((p) => p.msg));
  if (msg.hasErrorMsg()) {
    return msg.errorMsg;
  }
  return '';
});

final swapPriceStateNotifierProvider =
    StateNotifierProvider.autoDispose<SwapPriceProvider, double?>((ref) {
  return SwapPriceProvider(ref, null);
});

class SwapPriceProvider extends StateNotifier<double?> {
  final Ref ref;

  SwapPriceProvider(this.ref, double? price) : super(price);

  void setPrice(double? value) {
    state = value;
  }

  String? getPriceText() {
    final swapType = ref.read(swapProvider).swapType();

    if (swapType == SwapType.atomic) {
      final assetSend = ref.read(swapProvider).swapSendAsset;
      final assetRecv = ref.read(swapProvider).swapRecvAsset;
      final price = state;
      if (assetSend == null || assetRecv == null || price == null) {
        return null;
      }
      final sendLiquid =
          assetSend.assetId == ref.read(liquidAssetIdStateProvider);
      final asset = sendLiquid ? assetRecv : assetSend;

      final priceString = priceStr(price, false);
      var assetTicker =
          ref.read(assetUtilsProvider).tickerForAssetId(asset.assetId);
      assetTicker = assetTicker.isEmpty ? kUnknownTicker : assetTicker;
      final swapText = '1 $kLiquidBitcoinTicker = $priceString $assetTicker';
      return swapText;
    }

    final serverStatus = ref.read(walletProvider).serverStatus;
    if (serverStatus == null) {
      return null;
    }

    final serverPercent = swapType == SwapType.pegIn
        ? serverStatus.serverFeePercentPegIn
        : serverStatus.serverFeePercentPegOut;
    final percentConversion = 100 - serverPercent;
    final conversionStr = percentConversion.toStringAsFixed(2);
    final conversionText = 'Conversion rate $conversionStr%';
    return conversionText;
  }
}

final swapAddressErrorStateProvider =
    StateProvider.autoDispose<String?>((ref) => null);

final showAddressLabelStateProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final swapEnabledStateProvider = StateProvider.autoDispose<bool>((ref) {
  final swapType = ref.watch(swapProvider).swapType();
  final sendSatoshiAmount =
      ref.watch(swapSendAmountChangeNotifierProvider).satoshiAmount;
  final recvSatoshiAmount =
      ref.watch(swapRecvAmountChangeNotifierProvider).satoshiAmount;
  final insufficientFunds = ref.watch(showInsufficientFundsProvider);
  final addressErrorText = ref.watch(swapAddressErrorStateProvider);
  final addressRecvExternal = ref.watch(swapProvider).swapRecvAddressExternal;
  final swapState = ref.watch(swapStateProvider);

  bool enabled;
  switch (swapType) {
    case SwapType.atomic:
      enabled =
          sendSatoshiAmount > 0 && recvSatoshiAmount > 0 && !insufficientFunds;
      break;
    case SwapType.pegIn:
      enabled = true;
      break;
    case SwapType.pegOut:
      enabled = sendSatoshiAmount > 0 &&
          !insufficientFunds &&
          addressRecvExternal.isNotEmpty &&
          addressErrorText == null;
      break;
  }

  enabled = enabled && swapState == SwapState.idle;
  return enabled;
});
