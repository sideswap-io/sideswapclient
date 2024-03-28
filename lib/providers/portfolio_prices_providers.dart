import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'portfolio_prices_providers.g.dart';

@Riverpod(keepAlive: true)
class RequestPortfolioPrices extends _$RequestPortfolioPrices {
  @override
  void build() {
    final libClientState = ref.watch(libClientStateProvider);

    if (libClientState == const LibClientStateEmpty()) {
      return;
    }

    final timer = Timer.periodic(const Duration(seconds: 10), (_) {
      ref.invalidateSelf();
    });

    ref.onDispose(() {
      timer.cancel();
    });

    requestPortfolioPrices();
  }

  void requestPortfolioPrices() {
    final msg = To();
    msg.portfolioPrices = Empty();
    try {
      ref.read(walletProvider).sendMsg(msg);
    } catch (e) {
      logger.e(e);
    }
  }
}

@Riverpod(keepAlive: true)
class PortfolioPricesNotifier extends _$PortfolioPricesNotifier {
  @override
  Map<String, double> build() {
    return {};
  }

  void setPortfolioPrices(Map<String, double> value) {
    state = value;
  }
}
