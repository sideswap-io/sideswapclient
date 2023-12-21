import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'portfolio_prices_providers.g.dart';

@riverpod
class RequestPortfolioPrices extends _$RequestPortfolioPrices {
  @override
  void build() {
    requestPortfolioPrices();
    final timer = Timer.periodic(const Duration(seconds: 10), (_) {
      requestPortfolioPrices();
    });

    ref.onDispose(() {
      timer.cancel();
    });
  }

  void requestPortfolioPrices() {
    final msg = To();
    msg.portfolioPrices = Empty();
    ref.read(walletProvider).sendMsg(msg);
  }
}

@riverpod
class PortfolioPricesNotifier extends _$PortfolioPricesNotifier {
  @override
  Map<String, double> build() {
    return {};
  }

  void setPortfolioPrices(Map<String, double> value) {
    state = value;
  }
}
