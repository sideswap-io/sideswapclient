import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/enums.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/widgets/show_peg_info_widget.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/subscribe_price_providers.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'swap_provider.g.dart';
part 'swap_provider.freezed.dart';

@freezed
sealed class SwapType with _$SwapType {
  const factory SwapType.atomic() = SwapTypeAtomic;
  const factory SwapType.pegIn() = SwapTypePegIn;
  const factory SwapType.pegOut() = SwapTypePegOut;
}

@freezed
sealed class SwapWallet with _$SwapWallet {
  const factory SwapWallet.local() = SwapWalletLocal;
  const factory SwapWallet.extern() = SwapWalletExtern;
}

@freezed
sealed class SwapState with _$SwapState {
  const factory SwapState.idle() = SwapStateIdle;
  const factory SwapState.sent() = SwapStateSent;
}

@freezed
sealed class SwapAsset with _$SwapAsset {
  const factory SwapAsset({
    required AccountAsset asset,
    required List<AccountAsset> assetList,
  }) = _SwapAsset;
}

@riverpod
SwapType swapType(SwapTypeRef ref) {
  final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
  final swapReceiveAsset = ref.watch(swapReceiveAssetProvider);

  if (swapDeliverAsset.asset.assetId == bitcoinAssetId &&
      swapReceiveAsset.asset.assetId == liquidAssetId) {
    return const SwapType.pegIn();
  }
  if (swapDeliverAsset.asset.assetId == liquidAssetId &&
      swapReceiveAsset.asset.assetId == bitcoinAssetId) {
    return const SwapType.pegOut();
  }
  return const SwapType.atomic();
}

@riverpod
String swapTypeString(SwapTypeStringRef ref) {
  final swapType = ref.watch(swapTypeProvider);

  return switch (swapType) {
    SwapTypeAtomic() => 'Swap'.tr(),
    SwapTypePegIn() => 'Peg-In'.tr(),
    SwapTypePegOut() => 'Peg-Out'.tr(),
  };
}

@riverpod
AddrType swapAddrType(SwapAddrTypeRef ref) {
  final swapType = ref.watch(swapTypeProvider);

  return switch (swapType) {
    SwapTypePegOut() => AddrType.bitcoin,
    _ => AddrType.elements,
  };
}

@riverpod
String addrTypeString(AddrTypeStringRef ref) {
  final addrType = ref.watch(swapAddrTypeProvider);

  return switch (addrType) {
    AddrType.bitcoin => 'Bitcoin',
    _ => 'Liquid',
  };
}

@Riverpod(keepAlive: true)
class SwapSendAssetNotifier extends _$SwapSendAssetNotifier {
  @override
  AccountAsset build() {
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    return AccountAsset(AccountType.reg, liquidAssetId);
  }

  void setState(AccountAsset value) {
    state = value;
  }
}

@riverpod
List<AccountAsset> swapDeliverAccountAssetList(
    SwapDeliverAccountAssetListRef ref) {
  final swapPeg = ref.watch(swapPegNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

  if (swapPeg) {
    final swapPegList = <AccountAsset>[];
    final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);

    swapPegList.add(AccountAsset(AccountType.reg, bitcoinAssetId));
    swapPegList.add(AccountAsset(AccountType.reg, liquidAssetId));
    swapPegList.add(AccountAsset(AccountType.amp, liquidAssetId));
    return swapPegList;
  }

  final assets = ref.watch(assetsStateProvider);

  final assetList = assets.entries
      .where((e) => e.key == liquidAssetId || e.value.instantSwaps)
      .map((e) => AccountAsset(AccountType.reg, e.key))
      .toList();

  return assetList;
}

@riverpod
SwapAsset swapDeliverAsset(SwapDeliverAssetRef ref) {
  final swapSendAsset = ref.watch(swapSendAssetNotifierProvider);
  final assetList = ref.watch(swapDeliverAccountAssetListProvider);

  return SwapAsset(
    asset: swapSendAsset,
    assetList: assetList,
  );
}

@riverpod
List<AccountAsset> swapReceiveAccountAssetList(
    SwapReceiveAccountAssetListRef ref) {
  final swapPeg = ref.watch(swapPegNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final swapSendAsset = ref.watch(swapSendAssetNotifierProvider);

  if (swapPeg) {
    if (swapSendAsset.assetId == liquidAssetId) {
      final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);
      final assetList = [AccountAsset(AccountType.reg, bitcoinAssetId)];
      return assetList;
    }

    final assetList = [AccountAsset(AccountType.reg, liquidAssetId)];
    return assetList;
  }

  if (swapSendAsset.assetId != liquidAssetId) {
    final assetList = [AccountAsset(AccountType.reg, liquidAssetId)];
    return assetList;
  }

  final assets = ref.watch(assetsStateProvider);

  final assetList = assets.entries
      .where((e) => e.value.instantSwaps)
      .map((e) => AccountAsset(AccountType.reg, e.key))
      .toList();

  return assetList;
}

@riverpod
SwapAsset swapReceiveAsset(SwapReceiveAssetRef ref) {
  final swapPeg = ref.watch(swapPegNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
  final assetList = ref.watch(swapReceiveAccountAssetListProvider);

  if (swapPeg || swapDeliverAsset.asset.assetId != liquidAssetId) {
    return SwapAsset(asset: assetList.first, assetList: assetList);
  }

  final swapRecvAsset = ref.watch(swapRecvAssetNotifierProvider);
  return SwapAsset(asset: swapRecvAsset, assetList: assetList);
}

@riverpod
class SwapRecvAssetNotifier extends _$SwapRecvAssetNotifier {
  @override
  AccountAsset build() {
    final tetherAssetId = ref.watch(tetherAssetIdStateProvider);
    return AccountAsset(AccountType.reg, tetherAssetId);
  }

  void setState(AccountAsset value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class SwapPegNotifier extends _$SwapPegNotifier {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}

@riverpod
SwapWallet swapSendWallet(SwapSendWalletRef ref) {
  final swapType = ref.watch(swapTypeProvider);
  return switch (swapType) {
    SwapTypeAtomic() || SwapTypePegOut() => const SwapWallet.local(),
    SwapTypePegIn() => const SwapWallet.extern(),
  };
}

@riverpod
SwapWallet swapRecvWallet(SwapRecvWalletRef ref) {
  final swapType = ref.watch(swapTypeProvider);
  return switch (swapType) {
    SwapTypeAtomic() || SwapTypePegIn() => const SwapWallet.local(),
    SwapTypePegOut() => const SwapWallet.extern(),
  };
}

@riverpod
class SwapRecvAddressExternalNotifier
    extends _$SwapRecvAddressExternalNotifier {
  @override
  String build() {
    return '';
  }

  void setState(String value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class SwapPegAddressServerNotifier extends _$SwapPegAddressServerNotifier {
  @override
  String? build() {
    return null;
  }

  void setState(String? value) {
    state = value;
  }
}

@riverpod
String swapPriceString(SwapPriceStringRef ref) {
  final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
  final swapReceiveAsset = ref.watch(swapReceiveAssetProvider);
  final sendAsset =
      ref.watch(assetsStateProvider)[swapDeliverAsset.asset.assetId];
  final recvAsset =
      ref.watch(assetsStateProvider)[swapReceiveAsset.asset.assetId];

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

@riverpod
class SwapPriceSubscribeNotifier extends _$SwapPriceSubscribeNotifier {
  @override
  SwapPriceSubscribeState build() {
    return const SwapPriceSubscribeStateEmpty();
  }

  void setEmpty() => state = const SwapPriceSubscribeStateEmpty();
  void setSend() => state = const SwapPriceSubscribeStateSend();
  void setRecv() => state = const SwapPriceSubscribeStateRecv();
}

// TODO (malcolmpl): move this to riverpod_generator
final bitcoinCurrentFeeRateStateNotifierProvider =
    StateNotifierProvider.autoDispose<
        BitcoinCurrentFeeRateStateNotifierProvider, SwapCurrentFeeRate>(
  (ref) {
    final provider = BitcoinCurrentFeeRateStateNotifierProvider(
        ref, const SwapCurrentFeeRate.empty());
    ref.listen(bitcoinFeeRatesProvider, (previous, next) {
      provider.updateFeeRate(next);
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
        .read(subscribePriceStreamNotifierProvider.notifier)
        .subscribeToPriceStream();
  }

  void setEmpty() {
    state = const SwapCurrentFeeRate.empty();
  }
}

@riverpod
List<FeeRate> bitcoinFeeRates(BitcoinFeeRatesRef ref) {
  final swapType = ref.watch(swapTypeProvider);
  final swapRecvWallet = ref.watch(swapRecvWalletProvider);
  final serverStatus = ref.watch(walletProvider.select((p) => p.serverStatus));

  final feeRates = (swapType == const SwapType.pegOut() &&
          swapRecvWallet == const SwapWallet.extern() &&
          serverStatus != null)
      ? serverStatus.bitcoinFeeRates
      : <FeeRate>[];

  return feeRates;
}

@riverpod
String bitcoinFeeRateDescription(
    BitcoinFeeRateDescriptionRef ref, FeeRate feeRate) {
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

@riverpod
class SwapSendTextAmountNotifier extends _$SwapSendTextAmountNotifier {
  @override
  String build() {
    return '';
  }

  void setAmount(String value) {
    state = value;
  }
}

@riverpod
int swapSendSatoshiAmount(SwapSendSatoshiAmountRef ref) {
  final sendAmount = ref.watch(swapSendTextAmountNotifierProvider);

  if (sendAmount.isEmpty) {
    return 0;
  }

  final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
  final satoshiAmount = ref.watch(satoshiForAmountProvider(
      assetId: swapDeliverAsset.asset.assetId ?? '', amount: sendAmount));

  return satoshiAmount;
}

@riverpod
class SwapRecvTextAmountNotifier extends _$SwapRecvTextAmountNotifier {
  @override
  String build() {
    return '';
  }

  void setAmount(String value) {
    state = value;
  }
}

@riverpod
int swapRecvSatoshiAmount(SwapRecvSatoshiAmountRef ref) {
  final recvAmount = ref.watch(swapRecvTextAmountNotifierProvider);
  if (recvAmount.isEmpty) {
    return 0;
  }

  final swapReceiveAsset = ref.watch(swapReceiveAssetProvider);
  final satoshiAmount = ref.watch(satoshiForAmountProvider(
      assetId: swapReceiveAsset.asset.assetId ?? '', amount: recvAmount));

  return satoshiAmount;
}

@riverpod
bool showInsufficientFunds(ShowInsufficientFundsRef ref) {
  final serverError = ref.watch(swapNetworkErrorNotifierProvider);
  if (serverError.isNotEmpty) {
    return false;
  }

  final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
  final balance =
      ref.watch(balancesNotifierProvider)[swapDeliverAsset.asset] ?? 0;
  final satoshiAmount = ref.watch(swapSendSatoshiAmountProvider);
  return satoshiAmount > 0 && satoshiAmount > balance;
}

@riverpod
class SatoshiRecvAmountStateNotifier extends _$SatoshiRecvAmountStateNotifier {
  @override
  int build() {
    return 0;
  }

  void setSatoshiAmount(int value) {
    state = value;
  }
}

@riverpod
class SatoshiSendAmountStateNotifier extends _$SatoshiSendAmountStateNotifier {
  @override
  int build() {
    return 0;
  }

  void setSatoshiAmount(int value) {
    state = value;
  }
}

@riverpod
SwapRecvAmountPriceStream recvAmountPriceStreamWatcher(
    RecvAmountPriceStreamWatcherRef ref) {
  final authInProgress = ref.watch(authInProgressStateNotifierProvider);
  final swapState = ref.watch(swapStateNotifierProvider);

  if (swapState != const SwapState.idle() || authInProgress) {
    return const SwapRecvAmountPriceStream.empty();
  }

  final subscribeState = ref.watch(swapPriceSubscribeNotifierProvider);

  if (subscribeState != const SwapPriceSubscribeState.send()) {
    return const SwapRecvAmountPriceStream.empty();
  }

  final swapReceiveAsset = ref.watch(swapReceiveAssetProvider);
  final recvAmount = ref.watch(satoshiRecvAmountStateNotifierProvider);
  final recvPrecision = ref
      .read(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: swapReceiveAsset.asset.assetId);

  final amountProvider = ref.watch(amountToStringProvider);
  final recvAmountStr = amountProvider.amountToString(
      AmountToStringParameters(amount: recvAmount, precision: recvPrecision));
  final recvValue = replaceCharacterOnPosition(
    input: recvAmount != 0 ? recvAmountStr : '',
  );
  return SwapRecvAmountPriceStream.data(value: recvValue);
}

@riverpod
SwapSendAmountPriceStream sendAmountPriceStreamWatcher(
    SendAmountPriceStreamWatcherRef ref) {
  final authInProgress = ref.watch(authInProgressStateNotifierProvider);
  final swapState = ref.watch(swapStateNotifierProvider);

  if (swapState != const SwapState.idle() || authInProgress) {
    return const SwapSendAmountPriceStream.empty();
  }

  final subscribeState = ref.watch(swapPriceSubscribeNotifierProvider);

  if (subscribeState != const SwapPriceSubscribeState.recv()) {
    return const SwapSendAmountPriceStream.empty();
  }

  final asyncPriceStream = ref.watch(subscribePriceStreamNotifierProvider);

  return switch (asyncPriceStream) {
    AsyncValue(hasValue: true, value: From_UpdatePriceStream priceStream)
        when !priceStream.hasSendAmount() =>
      () {
        return const SwapSendAmountPriceStream.empty();
      },
    _ => () {
        final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
        final sendAmount = ref.watch(satoshiSendAmountStateNotifierProvider);
        final sendPrecision = ref
            .watch(assetUtilsProvider)
            .getPrecisionForAssetId(assetId: swapDeliverAsset.asset.assetId);
        final amountProvider = ref.watch(amountToStringProvider);
        final sendAmountStr = amountProvider.amountToString(
            AmountToStringParameters(
                amount: sendAmount, precision: sendPrecision));
        final sendValue = replaceCharacterOnPosition(
          input: sendAmount != 0 ? sendAmountStr : '',
        );

        return SwapSendAmountPriceStream.data(value: sendValue);
      },
  }();
}

@riverpod
class AuthInProgressStateNotifier extends _$AuthInProgressStateNotifier {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}

@riverpod
class SwapStateNotifier extends _$SwapStateNotifier {
  @override
  SwapState build() {
    return const SwapState.idle();
  }

  void setState(SwapState value) {
    state = value;
  }
}

@riverpod
class SwapNetworkErrorNotifier extends _$SwapNetworkErrorNotifier {
  @override
  String build() {
    final asyncPriceStream = ref.watch(subscribePriceStreamNotifierProvider);

    return switch (asyncPriceStream) {
      AsyncValue(hasValue: true, value: From_UpdatePriceStream priceStream)
          when priceStream.hasErrorMsg() =>
        priceStream.errorMsg,
      _ => '',
    };
  }

  void setState(String value) {
    state = value;
  }
}

@riverpod
class SwapPriceStateNotifier extends _$SwapPriceStateNotifier {
  @override
  double? build() {
    return null;
  }

  void setPrice(double? value) {
    state = value;
  }
}

@riverpod
String? swapPriceText(SwapPriceTextRef ref) {
  final swapPrice = ref.watch(swapPriceStateNotifierProvider);
  if (swapPrice == null) {
    return null;
  }

  final swapType = ref.watch(swapTypeProvider);

  if (swapType == const SwapType.atomic()) {
    final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
    final swapReceiveAsset = ref.watch(swapReceiveAssetProvider);

    final sendLiquid =
        swapDeliverAsset.asset.assetId == ref.watch(liquidAssetIdStateProvider);
    final asset = sendLiquid ? swapReceiveAsset : swapDeliverAsset;

    final priceString = priceStr(swapPrice, false);
    var assetTicker =
        ref.watch(assetUtilsProvider).tickerForAssetId(asset.asset.assetId);
    assetTicker = assetTicker.isEmpty ? kUnknownTicker : assetTicker;
    final swapText = '1 $kLiquidBitcoinTicker = $priceString $assetTicker';
    return swapText;
  }

  final serverStatus = ref.watch(walletProvider).serverStatus;
  if (serverStatus == null) {
    return null;
  }

  final serverPercent = swapType == const SwapType.pegIn()
      ? serverStatus.serverFeePercentPegIn
      : serverStatus.serverFeePercentPegOut;
  final percentConversion = 100 - serverPercent;
  final conversionStr = percentConversion.toStringAsFixed(2);
  final conversionText = 'Conversion rate $conversionStr%';
  return conversionText;
}

@riverpod
String? swapAddressError(SwapAddressErrorRef ref) {
  final swapRecvAddressExternal =
      ref.watch(swapRecvAddressExternalNotifierProvider);
  if (swapRecvAddressExternal.isEmpty) {
    return null;
  }

  final isValidAddress = ref
      .read(isAddrTypeValidProvider(swapRecvAddressExternal, AddrType.bitcoin));
  if (isValidAddress) {
    return null;
  }

  return 'Wrong address'.tr();
}

@riverpod
bool showAddressLabel(ShowAddressLabelRef ref) {
  final swapRecvAddressExternal =
      ref.watch(swapRecvAddressExternalNotifierProvider);
  if (swapRecvAddressExternal.isEmpty) {
    return false;
  }

  bool isValid = ref.watch(
      isAddrTypeValidProvider(swapRecvAddressExternal, AddrType.bitcoin));

  if (isValid) {
    return true;
  }

  return false;
}

@riverpod
bool swapEnabledState(SwapEnabledStateRef ref) {
  final swapState = ref.watch(swapStateNotifierProvider);

  if (swapState != const SwapState.idle()) {
    return false;
  }

  final swapType = ref.watch(swapTypeProvider);
  final sendSatoshiAmount = ref.watch(swapSendSatoshiAmountProvider);
  final recvSatoshiAmount = ref.watch(swapRecvSatoshiAmountProvider);
  final insufficientFunds = ref.watch(showInsufficientFundsProvider);
  final addressErrorText = ref.watch(swapAddressErrorProvider);
  final addressRecvExternal =
      ref.watch(swapRecvAddressExternalNotifierProvider);

  return switch (swapType) {
    SwapTypeAtomic() =>
      sendSatoshiAmount > 0 && recvSatoshiAmount > 0 && !insufficientFunds,
    SwapTypePegIn() => true,
    SwapTypePegOut() => sendSatoshiAmount > 0 &&
        !insufficientFunds &&
        addressRecvExternal.isNotEmpty &&
        addressErrorText == null,
  };
}

@riverpod
SwapHelper swapHelper(SwapHelperRef ref) {
  return SwapHelper(ref);
}

class SwapHelper {
  final Ref ref;

  SwapHelper(this.ref);

  void setSelectedLeftAsset(AccountAsset asset) {
    swapReset();
    ref.read(swapSendAssetNotifierProvider.notifier).setState(asset);
  }

  void setSelectedRightAsset(AccountAsset asset) {
    swapReset();
    ref.read(swapRecvAssetNotifierProvider.notifier).setState(asset);
  }

  void clearNetworkStates() {
    Future.microtask(() {
      ref.invalidate(swapNetworkErrorNotifierProvider);
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
      ref.invalidate(swapStateNotifierProvider);
    });
  }

  void clearAmounts() {
    Future.microtask(() {
      clearNetworkStates();
      ref.invalidate(swapSendTextAmountNotifierProvider);
      ref.invalidate(swapRecvTextAmountNotifierProvider);
      ref.invalidate(swapPriceSubscribeNotifierProvider);
      ref
          .read(subscribePriceStreamNotifierProvider.notifier)
          .subscribeToPriceStream();
    });
  }

  void pegStop() {
    swapReset();
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.registered);
  }

  void onPegOutAmountReceived(From_PegOutAmount value) {
    switch (value.whichResult()) {
      case From_PegOutAmount_Result.errorMsg:
        ref
            .read(swapNetworkErrorNotifierProvider.notifier)
            .setState(value.errorMsg);
        break;
      case From_PegOutAmount_Result.amounts:
        if (value.amounts.isSendEntered) {
          final amountStr = ref.read(amountToStringProvider).amountToString(
              AmountToStringParameters(
                  amount: value.amounts.recvAmount.toInt()));
          ref
              .read(swapRecvTextAmountNotifierProvider.notifier)
              .setAmount(amountStr);
        } else {
          final amountStr = ref.read(amountToStringProvider).amountToString(
              AmountToStringParameters(
                  amount: value.amounts.sendAmount.toInt()));
          ref
              .read(swapSendTextAmountNotifierProvider.notifier)
              .setAmount(amountStr);
        }
        break;
      case From_PegOutAmount_Result.notSet:
        throw Exception('unexpected message');
    }
  }

  void showPegInInformation() async {
    final navigatorKey = ref.read(navigatorKeyProvider);
    final internalHidePegInInfo = ref.read(configurationProvider).hidePegInInfo;
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
              ref.read(configurationProvider.notifier).setHidePegInInfo(value);
            },
          ),
        );
      },
    );
  }

  void showPegOutInformation() async {
    final internalHidePegOutInfo =
        ref.read(configurationProvider).hidePegOutInfo;
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
            onChanged: (value) {
              ref.read(configurationProvider.notifier).setHidePegOutInfo(value);
            },
          ),
        );
      },
    );
  }

  void selectSwap() {
    ref.read(pageStatusNotifierProvider.notifier).setStatus(Status.registered);

    final walletMainArguments = ref.read(uiStateArgsNotifierProvider);
    ref.read(uiStateArgsNotifierProvider.notifier).setWalletMainArguments(
          walletMainArguments.copyWith(
            currentIndex: 3,
            navigationItemEnum: WalletMainNavigationItemEnum.swap,
          ),
        );
  }

  void onMaxSendPressed() {
    final swapDeliverAsset = ref.read(swapDeliverAssetProvider);
    final precision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: swapDeliverAsset.asset.assetId);
    final balance = ref.read(balancesNotifierProvider)[swapDeliverAsset.asset];
    final balanceStr = ref.read(amountToStringProvider).amountToString(
        AmountToStringParameters(amount: balance ?? 0, precision: precision));

    var amount = balanceStr;
    ref.read(swapPriceSubscribeNotifierProvider.notifier).setSend();

    ref.read(swapSendTextAmountNotifierProvider.notifier).setAmount(amount);
    ref
        .read(subscribePriceStreamNotifierProvider.notifier)
        .subscribeToPriceStream();
  }

  void setDeliverAsset(AccountAsset accountAsset) {
    clearAmounts();
    setSelectedLeftAsset(accountAsset);
    ref
        .read(subscribePriceStreamNotifierProvider.notifier)
        .subscribeToPriceStream();
  }

  void setReceiveAsset(AccountAsset accountAsset) {
    clearAmounts();
    setSelectedRightAsset(accountAsset);
    ref
        .read(subscribePriceStreamNotifierProvider.notifier)
        .subscribeToPriceStream();
  }

  void toggleAssets() {
    final swapDeliverAsset = ref.read(swapDeliverAssetProvider);
    final swapReceiveAsset = ref.read(swapReceiveAssetProvider);

    setSelectedLeftAsset(swapReceiveAsset.asset);
    setSelectedRightAsset(swapDeliverAsset.asset);
    ref.invalidate(swapRecvAddressExternalNotifierProvider);
    clearAmounts();
    ref
        .read(subscribePriceStreamNotifierProvider.notifier)
        .subscribeToPriceStream();
  }

  void switchToSwaps() {
    ref.invalidate(swapPegNotifierProvider);
    ref.invalidate(swapSendAssetNotifierProvider);
    ref.invalidate(swapRecvAssetNotifierProvider);
    ref.invalidate(swapRecvAddressExternalNotifierProvider);
    clearAmounts();
    swapReset();
    ref
        .read(subscribePriceStreamNotifierProvider.notifier)
        .subscribeToPriceStream();
  }

  void switchToPegs() {
    ref.read(swapPegNotifierProvider.notifier).setState(true);
    setSelectedLeftAsset(
        AccountAsset(AccountType.reg, ref.read(bitcoinAssetIdProvider)));
    ref.invalidate(swapRecvAddressExternalNotifierProvider);
    clearAmounts();
    swapReset();
    ref
        .read(subscribePriceStreamNotifierProvider.notifier)
        .subscribeToPriceStream();
  }

  void swapAccept() async {
    // Remember amounts before calling async functions
    final sendAmount = ref.read(swapSendSatoshiAmountProvider);
    final recvAmount = ref.read(swapRecvSatoshiAmountProvider);

    final swapDeliverAsset = ref.read(swapDeliverAssetProvider);
    final price = ref.read(swapPriceStateNotifierProvider);
    final swapType = ref.read(swapTypeProvider);
    final swapSendWallet = ref.read(swapSendWalletProvider);

    final maxBalance = swapSendWallet == const SwapWallet.local()
        ? ref.read(balancesNotifierProvider)[swapDeliverAsset.asset] ?? 0
        : kMaxCoins;
    if (swapType != const SwapType.pegIn()) {
      if (sendAmount <= 0 || sendAmount > maxBalance) {
        await ref
            .read(utilsProvider)
            .showErrorDialog('Please enter correct amount'.tr());
        return;
      }
    }

    if (swapType == const SwapType.pegOut()) {
      final addrType = ref.read(swapAddrTypeProvider);
      final swapRecvAddressExternal =
          ref.read(swapRecvAddressExternalNotifierProvider);
      final addrTypeString = ref.read(addrTypeStringProvider);

      if (!ref
          .read(isAddrTypeValidProvider(swapRecvAddressExternal, addrType))) {
        await ref.read(utilsProvider).showErrorDialog(
            'PLEASE_ENTER_CORRECT_ADDRESS'.tr(args: [addrTypeString]));
        return;
      }
    }

    ref.read(authInProgressStateNotifierProvider.notifier).setState(true);
    final authSucceed = await ref.read(walletProvider).isAuthenticated();
    ref.invalidate(authInProgressStateNotifierProvider);
    if (!authSucceed) {
      return;
    }

    if (swapType == const SwapType.pegIn()) {
      final msg = To();
      msg.pegInRequest = To_PegInRequest();
      ref.read(walletProvider).sendMsg(msg);
      ref
          .read(swapStateNotifierProvider.notifier)
          .setState(const SwapState.sent());
      ref.invalidate(authInProgressStateNotifierProvider);
      return;
    }

    if (swapType == const SwapType.pegOut()) {
      final feeRate = ref.read(bitcoinCurrentFeeRateStateNotifierProvider)
          as SwapCurrentFeeRateData;
      final subscribe = ref.read(swapPriceSubscribeNotifierProvider);
      final swapRecvAddressExternal =
          ref.read(swapRecvAddressExternalNotifierProvider);

      final msg = To();
      msg.pegOutRequest = To_PegOutRequest();
      msg.pegOutRequest.sendAmount = Int64(sendAmount);
      msg.pegOutRequest.recvAmount = Int64(recvAmount);
      msg.pegOutRequest.isSendEntered =
          subscribe == const SwapPriceSubscribeState.send();
      msg.pegOutRequest.recvAddr = swapRecvAddressExternal;
      msg.pegOutRequest.blocks = feeRate.feeRate.blocks;
      msg.pegOutRequest.feeRate = feeRate.feeRate.value;
      msg.pegOutRequest.account = getAccount(swapDeliverAsset.asset.account);
      ref.read(walletProvider).sendMsg(msg);
      ref
          .read(swapStateNotifierProvider.notifier)
          .setState(const SwapState.sent());
    }

    if (swapType == const SwapType.atomic()) {
      final msg = To();
      msg.swapRequest = To_SwapRequest();
      final sendBitcoins = swapDeliverAsset.asset.assetId ==
          ref.read(liquidAssetIdStateProvider);
      final swapRecvAsset = ref.read(swapReceiveAssetProvider);

      final asset = sendBitcoins ? swapRecvAsset : swapDeliverAsset;
      msg.swapRequest.sendBitcoins = sendBitcoins;
      msg.swapRequest.asset = asset.asset.assetId ?? '';
      msg.swapRequest.sendAmount = Int64(sendAmount);
      msg.swapRequest.recvAmount = Int64(recvAmount);
      msg.swapRequest.price = price ?? 0.0;
      ref.read(walletProvider).sendMsg(msg);
      ref
          .read(swapStateNotifierProvider.notifier)
          .setState(const SwapState.sent());
    }
  }
}
