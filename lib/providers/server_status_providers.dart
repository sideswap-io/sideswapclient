import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'server_status_providers.g.dart';

@Riverpod(keepAlive: true)
class PegInMinimumAmount extends _$PegInMinimumAmount {
  @override
  int build() {
    return 0;
  }

  void setState(int value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class PegInServerFeePercent extends _$PegInServerFeePercent {
  @override
  double build() {
    return 0;
  }

  void setState(double value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class PegOutMinimumAmount extends _$PegOutMinimumAmount {
  @override
  int build() {
    return 0;
  }

  void setState(int value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class PegOutServerFeePercent extends _$PegOutServerFeePercent {
  @override
  double build() {
    return 0;
  }

  void setState(double value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class BitcoinFeeRates extends _$BitcoinFeeRates {
  @override
  List<FeeRate> build() {
    return [];
  }

  void setState(List<FeeRate> feeRates) {
    state = [...feeRates];
  }
}
