import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'pegs_provider.freezed.dart';
part 'pegs_provider.g.dart';

@freezed
sealed class PegSubscribedValues with _$PegSubscribedValues {
  const factory PegSubscribedValues({
    @Default(0) int pegInMinimumAmount,
    @Default(0) int pegInWalletBalance,
    @Default(0) int pegOutMinimumAmount,
    @Default(0) int pegOutWalletBalance,
  }) = _PegSubscribedValues;
}

abstract class AbstractPegRepository {
  void setActivePage({ActivePage activePage = ActivePage.OTHER});
  String extractValue(int value);
  String pegInMinAmount();
  String pegInWalletBalance();
  String pegOutMinAmount();
  String pegOutWalletBalance();
  void getPegOutAmount();
}

class PegRepository implements AbstractPegRepository {
  final Ref ref;
  final LibClientState libClientState;
  final bool serverConnected;
  final PegSubscribedValues pegSubscribedValues;
  final String liquidAssetId;

  PegRepository({
    required this.ref,
    required this.libClientState,
    required this.serverConnected,
    required this.pegSubscribedValues,
    required this.liquidAssetId,
  });

  @override
  void setActivePage({ActivePage activePage = ActivePage.OTHER}) {
    if (libClientState != LibClientStateInitialized()) {
      return;
    }

    if (!serverConnected) {
      return;
    }

    final msg = To();
    msg.activePage = activePage;
    ref.read(walletProvider).sendMsg(msg);
  }

  @override
  String extractValue(int value) {
    final liquidAssetId = ref.read(liquidAssetIdStateProvider);
    final amountToString = ref.read(amountToStringProvider);
    final assetState = ref.read(assetsStateProvider);

    final asset = assetState[liquidAssetId];
    if (asset == null) {
      return '';
    }

    final amountString = amountToString.amountToString(
      AmountToStringParameters(
        amount: value.toInt(),
        precision: asset.precision,
        useNumberFormatter: true,
      ),
    );

    final amountDecimal = Decimal.tryParse(amountString) ?? Decimal.zero;
    return amountToString.amountToMobileFormatted(
      amount: amountDecimal,
      precision: asset.precision,
    );
  }

  @override
  String pegInMinAmount() {
    return extractValue(pegSubscribedValues.pegInMinimumAmount);
  }

  @override
  String pegInWalletBalance() {
    return extractValue(pegSubscribedValues.pegInWalletBalance);
  }

  @override
  String pegOutMinAmount() {
    return extractValue(pegSubscribedValues.pegOutMinimumAmount);
  }

  @override
  String pegOutWalletBalance() {
    return extractValue(pegSubscribedValues.pegOutWalletBalance);
  }

  @override
  void getPegOutAmount() {
    ref.read(swapHelperProvider).clearNetworkStates();
    final swapType = ref.read(swapTypeProvider);

    if (swapType == const SwapType.pegOut()) {
      final subscribe = ref.read(swapPriceSubscribeNotifierProvider);
      final optionCurrentFeeRate = ref.read(
        bitcoinCurrentFeeRateNotifierProvider,
      );
      final sendAmount = (subscribe == const SwapPriceSubscribeState.send())
          ? ref.read(swapSendSatoshiAmountProvider)
          : null;
      final recvAmount = (subscribe == const SwapPriceSubscribeState.recv())
          ? ref.read(swapRecvSatoshiAmountProvider)
          : null;
      if (((sendAmount ?? 0) > 0 || (recvAmount ?? 0) > 0)) {
        optionCurrentFeeRate.match(() {}, (feeRate) {
          ref
              .read(walletProvider)
              .getPegOutAmount(sendAmount, recvAmount, feeRate.value);
        });
      }
    }
  }
}

@riverpod
AbstractPegRepository pegRepository(Ref ref) {
  final libClientState = ref.watch(libClientStateProvider);
  final serverConnected = ref.watch(serverConnectionNotifierProvider);
  final pegSubscribedValues = ref.watch(pegSubscribedValueNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

  return PegRepository(
    ref: ref,
    libClientState: libClientState,
    serverConnected: serverConnected,
    pegSubscribedValues: pegSubscribedValues,
    liquidAssetId: liquidAssetId,
  );
}

@Riverpod(keepAlive: true)
class AllPegsNotifier extends _$AllPegsNotifier {
  @override
  Map<String, List<TransItem>> build() {
    return {};
  }

  void update({required From_UpdatedPegs pegs}) {
    final allPegs = {...state};
    allPegs[pegs.orderId] = pegs.items;
    state = allPegs;
  }
}

@Riverpod(keepAlive: true)
Map<String, TransItem> allPegsById(Ref ref) {
  final allPegsByIdMap = <String, TransItem>{};
  final allPegs = ref.watch(allPegsNotifierProvider);

  for (var key in allPegs.keys) {
    final peg = allPegs[key]!;

    for (var item in peg) {
      if (item.peg.isPegIn) {
        allPegsByIdMap[item.peg.txidRecv] = item;
        continue;
      }
      allPegsByIdMap[item.peg.txidSend] = item;
    }
  }

  return allPegsByIdMap;
}

@Riverpod(keepAlive: true)
class PegSubscribedValueNotifier extends _$PegSubscribedValueNotifier {
  @override
  PegSubscribedValues build() {
    return PegSubscribedValues();
  }

  void setState(From_SubscribedValue subscribedValue) {
    final current = state;
    if (subscribedValue.hasPegInMinAmount()) {
      state = current.copyWith(
        pegInMinimumAmount: subscribedValue.pegInMinAmount.toInt(),
      );
    }
    if (subscribedValue.hasPegInWalletBalance()) {
      state = current.copyWith(
        pegInWalletBalance: subscribedValue.pegInWalletBalance.toInt(),
      );
    }
    if (subscribedValue.hasPegOutMinAmount()) {
      state = current.copyWith(
        pegOutMinimumAmount: subscribedValue.pegOutMinAmount.toInt(),
      );
    }
    if (subscribedValue.hasPegOutWalletBalance()) {
      state = current.copyWith(
        pegOutWalletBalance: subscribedValue.pegOutWalletBalance.toInt(),
      );
    }
  }
}
