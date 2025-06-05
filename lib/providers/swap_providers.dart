import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/enums.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/widgets/show_peg_info_widget.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/server_status_providers.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'swap_providers.g.dart';
part 'swap_providers.freezed.dart';

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
    required String assetId,
    required Iterable<String> assetList,
  }) = _SwapAsset;
}

@riverpod
SwapType swapType(Ref ref) {
  final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
  final swapReceiveAsset = ref.watch(swapReceiveAssetProvider);

  if (swapDeliverAsset.assetId == bitcoinAssetId &&
      swapReceiveAsset.assetId == liquidAssetId) {
    return const SwapType.pegIn();
  }
  if (swapDeliverAsset.assetId == liquidAssetId &&
      swapReceiveAsset.assetId == bitcoinAssetId) {
    return const SwapType.pegOut();
  }
  return const SwapType.atomic();
}

@riverpod
String swapTypeString(Ref ref) {
  final swapType = ref.watch(swapTypeProvider);

  return switch (swapType) {
    SwapTypeAtomic() => 'Swap'.tr(),
    SwapTypePegIn() => 'Peg-In'.tr(),
    SwapTypePegOut() => 'Peg-Out'.tr(),
  };
}

@riverpod
AddrType swapAddrType(Ref ref) {
  final swapType = ref.watch(swapTypeProvider);

  return switch (swapType) {
    SwapTypePegOut() => AddrType.bitcoin,
    _ => AddrType.elements,
  };
}

@riverpod
String addrTypeString(Ref ref) {
  final addrType = ref.watch(swapAddrTypeProvider);

  return switch (addrType) {
    AddrType.bitcoin => 'Bitcoin',
    _ => 'Liquid',
  };
}

@Riverpod(keepAlive: true)
class SwapSendAssetIdNotifier extends _$SwapSendAssetIdNotifier {
  @override
  String build() {
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    return liquidAssetId;
  }

  void setState(String assetId) {
    state = assetId;
  }
}

@riverpod
Iterable<String> swapDeliverAssetIdList(Ref ref) {
  final swapPeg = ref.watch(swapPegNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

  if (swapPeg) {
    final swapPegList = <String>[];
    final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);

    swapPegList.add(bitcoinAssetId);
    swapPegList.add(liquidAssetId);
    return swapPegList;
  }

  final assets = ref.watch(assetsStateProvider);

  final assetList = assets.entries
      .where((e) => e.key == liquidAssetId || e.value.instantSwaps)
      .map((e) => e.key)
      .toList();

  return assetList;
}

@riverpod
SwapAsset swapDeliverAsset(Ref ref) {
  final swapSendAssetId = ref.watch(swapSendAssetIdNotifierProvider);
  final assetList = ref.watch(swapDeliverAssetIdListProvider);

  return SwapAsset(assetId: swapSendAssetId, assetList: assetList);
}

@riverpod
Iterable<String> swapReceiveAssetIdList(Ref ref) {
  final swapPeg = ref.watch(swapPegNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final swapSendAssetId = ref.watch(swapSendAssetIdNotifierProvider);

  if (swapPeg) {
    if (swapSendAssetId == liquidAssetId) {
      final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);
      return [bitcoinAssetId];
    }

    return [liquidAssetId];
  }

  if (swapSendAssetId != liquidAssetId) {
    return [liquidAssetId];
  }

  final assets = ref.watch(assetsStateProvider);

  return assets.entries.where((e) => e.value.instantSwaps).map((e) => e.key);
}

@riverpod
SwapAsset swapReceiveAsset(Ref ref) {
  final swapPeg = ref.watch(swapPegNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
  final assetList = ref.watch(swapReceiveAssetIdListProvider);

  if (swapPeg || swapDeliverAsset.assetId != liquidAssetId) {
    return SwapAsset(assetId: assetList.first, assetList: assetList);
  }

  final swapRecvAssetId = ref.watch(swapRecvAssetIdNotifierProvider);
  return SwapAsset(assetId: swapRecvAssetId, assetList: assetList);
}

@riverpod
class SwapRecvAssetIdNotifier extends _$SwapRecvAssetIdNotifier {
  @override
  String build() {
    return ref.watch(tetherAssetIdStateProvider);
  }

  void setState(String assetId) {
    state = assetId;
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
SwapWallet swapSendWallet(Ref ref) {
  final swapType = ref.watch(swapTypeProvider);
  return switch (swapType) {
    SwapTypeAtomic() || SwapTypePegOut() => const SwapWallet.local(),
    SwapTypePegIn() => const SwapWallet.extern(),
  };
}

@riverpod
SwapWallet swapRecvWallet(Ref ref) {
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
String swapPriceString(Ref ref) {
  final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
  final swapReceiveAsset = ref.watch(swapReceiveAssetProvider);
  final sendAsset = ref.watch(assetsStateProvider)[swapDeliverAsset.assetId];
  final recvAsset = ref.watch(assetsStateProvider)[swapReceiveAsset.assetId];

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

@riverpod
class BitcoinCurrentFeeRateNotifier extends _$BitcoinCurrentFeeRateNotifier {
  @override
  Option<FeeRate> build() {
    ref.onAddListener(() {
      final feeRates = ref.read(bitcoinFeeRatesProvider);

      Future.microtask(() => _updateFeeRate(feeRates));
    });

    ref.listen(bitcoinFeeRatesProvider, (_, next) {
      if (next.isEmpty) {
        return;
      }

      Future.microtask(() => _updateFeeRate(next));
    });

    return Option.none();
  }

  void _updateFeeRate(List<FeeRate> feeRates) {
    if (feeRates.isEmpty) {
      return;
    }

    state.match(
      () {
        state = Option.of(feeRates.first);
      },
      (feeRate) {
        final index = feeRates.indexWhere((e) => e.blocks == feeRate.blocks);
        if (index == -1) {
          state = Option.of(feeRates.first);
          return;
        }

        state = Option.of(feeRates[index]);
      },
    );
  }

  void setFeeRate(FeeRate feeRate) {
    state = Option.of(feeRate);
  }
}

@riverpod
String bitcoinFeeRateDescription(Ref ref, FeeRate feeRate) {
  final blocks = feeRate.blocks;
  final value = feeRate.value;
  final duration = Duration(minutes: blocks * 10);
  if (duration.inMinutes <= 60) {
    return 'BLOCKS_MINUTES'.plural(
      blocks,
      args: ['$blocks', '${duration.inMinutes}', '$value'],
    );
  } else {
    return 'BLOCKS_HOURS'.plural(
      blocks,
      args: ['$blocks', '${duration.inHours}', '$value'],
    );
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
int swapSendSatoshiAmount(Ref ref) {
  final sendAmount = ref.watch(swapSendTextAmountNotifierProvider);

  if (sendAmount.isEmpty) {
    return 0;
  }

  final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);
  final satoshiAmount = satoshiRepository.satoshiForAmount(
    assetId: swapDeliverAsset.assetId,
    amount: sendAmount,
  );

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
int swapRecvSatoshiAmount(Ref ref) {
  final recvAmount = ref.watch(swapRecvTextAmountNotifierProvider);
  if (recvAmount.isEmpty) {
    return 0;
  }

  final swapReceiveAsset = ref.watch(swapReceiveAssetProvider);
  final satoshiRepository = ref.watch(satoshiRepositoryProvider);
  final satoshiAmount = satoshiRepository.satoshiForAmount(
    assetId: swapReceiveAsset.assetId,
    amount: recvAmount,
  );

  return satoshiAmount;
}

@riverpod
bool showInsufficientFunds(Ref ref) {
  final serverError = ref.watch(swapNetworkErrorNotifierProvider);
  if (serverError.isNotEmpty) {
    return false;
  }

  final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
  final assetBalance =
      ref.watch(assetBalanceProvider)[swapDeliverAsset.assetId] ?? 0;
  final satoshiAmount = ref.watch(swapSendSatoshiAmountProvider);
  return satoshiAmount > 0 && satoshiAmount > assetBalance;
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
SwapRecvAmountPriceStream recvAmountPriceStreamWatcher(Ref ref) {
  final authInProgress = ref.watch(jadeAuthInProgressStateNotifierProvider);
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
      .getPrecisionForAssetId(assetId: swapReceiveAsset.assetId);

  final amountProvider = ref.watch(amountToStringProvider);
  final recvAmountStr = amountProvider.amountToString(
    AmountToStringParameters(amount: recvAmount, precision: recvPrecision),
  );
  final recvValue = replaceCharacterOnPosition(
    input: recvAmount != 0 ? recvAmountStr : '',
  );
  return SwapRecvAmountPriceStream.data(value: recvValue);
}

@riverpod
SwapSendAmountPriceStream sendAmountPriceStreamWatcher(Ref ref) {
  final authInProgress = ref.watch(jadeAuthInProgressStateNotifierProvider);
  final swapState = ref.watch(swapStateNotifierProvider);

  if (swapState != const SwapState.idle() || authInProgress) {
    return const SwapSendAmountPriceStream.empty();
  }

  final subscribeState = ref.watch(swapPriceSubscribeNotifierProvider);

  if (subscribeState != const SwapPriceSubscribeState.recv()) {
    return const SwapSendAmountPriceStream.empty();
  }

  final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);
  final sendAmount = ref.watch(satoshiSendAmountStateNotifierProvider);
  final sendPrecision = ref
      .watch(assetUtilsProvider)
      .getPrecisionForAssetId(assetId: swapDeliverAsset.assetId);
  final amountProvider = ref.watch(amountToStringProvider);
  final sendAmountStr = amountProvider.amountToString(
    AmountToStringParameters(amount: sendAmount, precision: sendPrecision),
  );
  final sendValue = replaceCharacterOnPosition(
    input: sendAmount != 0 ? sendAmountStr : '',
  );

  return SwapSendAmountPriceStream.data(value: sendValue);
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
    return '';
  }

  void setState(String value) {
    state = value;
  }
}

@riverpod
Option<String> swapPriceText(Ref ref) {
  final swapType = ref.watch(swapTypeProvider);

  final pegInServerFeePercent = ref.watch(pegInServerFeePercentProvider);
  final pegOutServerFeePercent = ref.watch(pegOutServerFeePercentProvider);

  final serverPercent = swapType == const SwapType.pegIn()
      ? pegInServerFeePercent
      : pegOutServerFeePercent;

  if (serverPercent == 0) {
    return Option.none();
  }

  final percentConversion = 100 - serverPercent;
  final conversionStr = percentConversion.toStringAsFixed(2);
  final conversionText = 'Conversion rate $conversionStr%';
  return Option.of(conversionText);
}

@riverpod
String? swapAddressError(Ref ref) {
  final swapRecvAddressExternal = ref.watch(
    swapRecvAddressExternalNotifierProvider,
  );
  if (swapRecvAddressExternal.isEmpty) {
    return null;
  }

  final isValidAddress = ref.read(
    isAddrTypeValidProvider(swapRecvAddressExternal, AddrType.bitcoin),
  );
  if (isValidAddress) {
    return null;
  }

  return 'Wrong address'.tr();
}

@riverpod
bool showAddressLabel(Ref ref) {
  final swapRecvAddressExternal = ref.watch(
    swapRecvAddressExternalNotifierProvider,
  );
  if (swapRecvAddressExternal.isEmpty) {
    return false;
  }

  bool isValid = ref.watch(
    isAddrTypeValidProvider(swapRecvAddressExternal, AddrType.bitcoin),
  );

  if (isValid) {
    return true;
  }

  return false;
}

@riverpod
bool swapEnabledState(Ref ref) {
  final swapState = ref.watch(swapStateNotifierProvider);

  if (swapState != const SwapState.idle()) {
    return false;
  }

  final swapType = ref.watch(swapTypeProvider);
  final sendSatoshiAmount = ref.watch(swapSendSatoshiAmountProvider);
  final recvSatoshiAmount = ref.watch(swapRecvSatoshiAmountProvider);
  final insufficientFunds = ref.watch(showInsufficientFundsProvider);
  final addressErrorText = ref.watch(swapAddressErrorProvider);
  final addressRecvExternal = ref.watch(
    swapRecvAddressExternalNotifierProvider,
  );

  return switch (swapType) {
    SwapTypeAtomic() =>
      sendSatoshiAmount > 0 && recvSatoshiAmount > 0 && !insufficientFunds,
    SwapTypePegIn() => true,
    SwapTypePegOut() =>
      sendSatoshiAmount > 0 &&
          !insufficientFunds &&
          addressRecvExternal.isNotEmpty &&
          addressErrorText == null,
  };
}

@riverpod
SwapHelper swapHelper(Ref ref) {
  return SwapHelper(ref);
}

class SwapHelper {
  final Ref ref;

  SwapHelper(this.ref);

  void setSelectedLeftAsset(String assetId) {
    swapReset();
    ref.read(swapSendAssetIdNotifierProvider.notifier).setState(assetId);
  }

  void setSelectedRightAsset(String assetId) {
    swapReset();
    ref.read(swapRecvAssetIdNotifierProvider.notifier).setState(assetId);
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
          final amountStr = ref
              .read(amountToStringProvider)
              .amountToString(
                AmountToStringParameters(
                  amount: value.amounts.recvAmount.toInt(),
                ),
              );
          ref
              .read(swapRecvTextAmountNotifierProvider.notifier)
              .setAmount(amountStr);
        } else {
          final amountStr = ref
              .read(amountToStringProvider)
              .amountToString(
                AmountToStringParameters(
                  amount: value.amounts.sendAmount.toInt(),
                ),
              );
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    final internalHidePegOutInfo = ref
        .read(configurationProvider)
        .hidePegOutInfo;
    if (internalHidePegOutInfo) {
      return;
    }

    final navigatorKey = ref.read(navigatorKeyProvider);

    await showDialog<void>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    ref
        .read(uiStateArgsNotifierProvider.notifier)
        .setWalletMainArguments(
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
        .getPrecisionForAssetId(assetId: swapDeliverAsset.assetId);
    final assetBalance = ref.read(
      assetBalanceProvider,
    )[swapDeliverAsset.assetId];
    final balanceStr = ref
        .read(amountToStringProvider)
        .amountToString(
          AmountToStringParameters(
            amount: assetBalance ?? 0,
            precision: precision,
          ),
        );

    var amount = balanceStr;
    ref.read(swapPriceSubscribeNotifierProvider.notifier).setSend();

    ref.read(swapSendTextAmountNotifierProvider.notifier).setAmount(amount);
  }

  void setDeliverAsset(String assetId) {
    clearAmounts();
    setSelectedLeftAsset(assetId);
  }

  void setReceiveAsset(String assetId) {
    clearAmounts();
    setSelectedRightAsset(assetId);
  }

  void toggleAssets() {
    final swapDeliverAsset = ref.read(swapDeliverAssetProvider);
    final swapReceiveAsset = ref.read(swapReceiveAssetProvider);

    setSelectedLeftAsset(swapReceiveAsset.assetId);
    setSelectedRightAsset(swapDeliverAsset.assetId);
    ref.invalidate(swapRecvAddressExternalNotifierProvider);
    clearAmounts();
  }

  void switchToSwaps() {
    ref.invalidate(swapPegNotifierProvider);
    ref.invalidate(swapSendAssetIdNotifierProvider);
    ref.invalidate(swapRecvAssetIdNotifierProvider);
    ref.invalidate(swapRecvAddressExternalNotifierProvider);
    clearAmounts();
    swapReset();
  }

  void switchToPegs() {
    ref.read(swapPegNotifierProvider.notifier).setState(true);
    final bitcoinAssetId = ref.read(bitcoinAssetIdProvider);
    setSelectedLeftAsset(bitcoinAssetId);
    ref.invalidate(swapRecvAddressExternalNotifierProvider);
    clearAmounts();
    swapReset();
  }

  void swapAccept() async {
    // Remember amounts before calling async functions
    final sendAmount = ref.read(swapSendSatoshiAmountProvider);
    final recvAmount = ref.read(swapRecvSatoshiAmountProvider);

    final swapDeliverAsset = ref.read(swapDeliverAssetProvider);
    final swapType = ref.read(swapTypeProvider);
    final swapSendWallet = ref.read(swapSendWalletProvider);

    final maxBalance = swapSendWallet == const SwapWallet.local()
        ? ref.read(assetBalanceProvider)[swapDeliverAsset.assetId] ?? 0
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
      final swapRecvAddressExternal = ref.read(
        swapRecvAddressExternalNotifierProvider,
      );
      final addrTypeString = ref.read(addrTypeStringProvider);

      if (!ref.read(
        isAddrTypeValidProvider(swapRecvAddressExternal, addrType),
      )) {
        await ref
            .read(utilsProvider)
            .showErrorDialog(
              'PLEASE_ENTER_CORRECT_ADDRESS'.tr(args: [addrTypeString]),
            );
        return;
      }
    }

    ref.read(jadeAuthInProgressStateNotifierProvider.notifier).setState(true);
    final authSucceed = await ref.read(walletProvider).isAuthenticated();
    ref.invalidate(jadeAuthInProgressStateNotifierProvider);
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
      ref.invalidate(jadeAuthInProgressStateNotifierProvider);
      return;
    }

    if (swapType == const SwapType.pegOut()) {
      final optionCurrentFeeRate = ref.read(
        bitcoinCurrentFeeRateNotifierProvider,
      );

      optionCurrentFeeRate.match(() {}, (feeRate) {
        final subscribe = ref.read(swapPriceSubscribeNotifierProvider);
        final swapRecvAddressExternal = ref.read(
          swapRecvAddressExternalNotifierProvider,
        );

        final msg = To();
        msg.pegOutRequest = To_PegOutRequest();
        msg.pegOutRequest.sendAmount = Int64(sendAmount);
        msg.pegOutRequest.recvAmount = Int64(recvAmount);
        msg.pegOutRequest.isSendEntered =
            subscribe == const SwapPriceSubscribeState.send();
        msg.pegOutRequest.recvAddr = swapRecvAddressExternal;
        msg.pegOutRequest.blocks = feeRate.blocks;
        msg.pegOutRequest.feeRate = feeRate.value;
        ref.read(walletProvider).sendMsg(msg);
        ref
            .read(swapStateNotifierProvider.notifier)
            .setState(const SwapState.sent());
      });
    }
  }
}
