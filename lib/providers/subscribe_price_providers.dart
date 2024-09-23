import 'package:fixnum/fixnum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'subscribe_price_providers.g.dart';

@Riverpod(keepAlive: true)
class SubscribePriceStreamNotifier extends _$SubscribePriceStreamNotifier {
  String? _subscribedAsset;
  bool? _subscribedSendBitcoins;
  int? _subscribedSendAmount;
  int? _subscribedRecvAmount;

  @override
  Stream<From_UpdatePriceStream> build() async* {
    yield From_UpdatePriceStream();
  }

  void onUpdatePriceStreamChanged(From_UpdatePriceStream msg) {
    // Ignore old updates
    final subscribedSendAmountCopy = _subscribedSendAmount;
    final subscribedRecvAmountCopy = _subscribedRecvAmount;
    if (msg.assetId != _subscribedAsset ||
        msg.sendBitcoins != _subscribedSendBitcoins) {
      return;
    }

    // Ignore old updates
    final expectedPriceMsg = _subscribedSendAmount == null &&
        _subscribedRecvAmount == null &&
        !msg.hasSendAmount() &&
        !msg.hasRecvAmount();
    final expectedSendAmountMsg = subscribedSendAmountCopy != null &&
        subscribedSendAmountCopy.toInt() == msg.sendAmount.toInt();
    final expectedRecvAmountMsg = subscribedRecvAmountCopy != null &&
        subscribedRecvAmountCopy.toInt() == msg.recvAmount.toInt();

    if (expectedPriceMsg || expectedSendAmountMsg || expectedRecvAmountMsg) {
      state = AsyncValue.data(msg);

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
    }
  }

  void _subscribeToPriceStream(
    String asset,
    bool sendBitcoins,
    int? sendAmount,
    int? recvAmount,
  ) {
    assert(asset.isNotEmpty);
    _resetSubscribedData();

    _subscribedAsset = asset;
    _subscribedSendBitcoins = sendBitcoins;
    _subscribedSendAmount = sendAmount;
    _subscribedRecvAmount = recvAmount;

    final msg = To();
    msg.subscribePriceStream = To_SubscribePriceStream();
    msg.subscribePriceStream.assetId = asset;
    msg.subscribePriceStream.sendBitcoins = sendBitcoins;
    if (sendAmount != null && sendAmount != 0) {
      msg.subscribePriceStream.sendAmount = Int64(sendAmount);
    }
    if (recvAmount != null && recvAmount != 0) {
      msg.subscribePriceStream.recvAmount = Int64(recvAmount);
    }

    ref.read(walletProvider).sendMsg(msg);
  }

  void _resetSubscribedData() {
    _subscribedAsset = null;
    _subscribedSendBitcoins = null;
    _subscribedSendAmount = null;
    _subscribedRecvAmount = null;
  }

  void unsubscribeFromPriceStream() {
    if (_subscribedAsset != null) {
      final msg = To();
      msg.unsubscribePriceStream = Empty();
      ref.read(walletProvider).sendMsg(msg);

      _resetSubscribedData();
    }
  }

  void subscribeToPriceStream() async {
    ref.read(swapHelperProvider).swapReset();
    final swapType = ref.read(swapTypeProvider);

    unsubscribeFromPriceStream();

    if (swapType == const SwapType.atomic()) {
      final swapDeliverAsset = ref.read(swapDeliverAssetProvider);
      final swapReceiveAsset = ref.read(swapReceiveAssetProvider);
      final subscribe = ref.read(swapPriceSubscribeNotifierProvider);
      final sendAmount = (subscribe == const SwapPriceSubscribeState.send())
          ? ref.read(swapSendSatoshiAmountProvider)
          : null;
      final recvAmount = (subscribe == const SwapPriceSubscribeState.recv())
          ? ref.read(swapRecvSatoshiAmountProvider)
          : null;
      final sendBitcoins = swapDeliverAsset.asset.assetId ==
          ref.read(liquidAssetIdStateProvider);
      final asset = sendBitcoins ? swapReceiveAsset : swapDeliverAsset;
      _subscribeToPriceStream(
        asset.asset.assetId ?? '',
        sendBitcoins,
        sendAmount,
        recvAmount,
      );
    } else if (swapType == const SwapType.pegOut()) {
      final subscribe = ref.read(swapPriceSubscribeNotifierProvider);
      final swapDeliverAsset = ref.read(swapDeliverAssetProvider);
      final feeRate = ref.read(bitcoinCurrentFeeRateStateNotifierProvider);
      final sendAmount = (subscribe == const SwapPriceSubscribeState.send())
          ? ref.read(swapSendSatoshiAmountProvider)
          : null;
      final recvAmount = (subscribe == const SwapPriceSubscribeState.recv())
          ? ref.read(swapRecvSatoshiAmountProvider)
          : null;
      if (((sendAmount ?? 0) > 0 || (recvAmount ?? 0) > 0) &&
          feeRate is SwapCurrentFeeRateData) {
        ref.read(walletProvider).getPegOutAmount(sendAmount, recvAmount,
            feeRate.feeRate.value, swapDeliverAsset.asset.account);
      }
    }
  }
}
