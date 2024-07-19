import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'payjoin_providers.freezed.dart';
part 'payjoin_providers.g.dart';

@freezed
sealed class PayjoinState with _$PayjoinState {
  const factory PayjoinState.empty() = PayjoinStateEmpty;
  const factory PayjoinState.createPayjoin(CreatePayjoin createPayjoin) =
      PayjoinStateCreatePayjoin;
  const factory PayjoinState.waitingCreatedPayjoin() =
      PayjoinStateWaitingCreatedPayjoin;
  const factory PayjoinState.createdPayjoin(CreatedPayjoin createdPayjoin) =
      PayjoinStateCreatedPayjoin;
  const factory PayjoinState.waitingSendPayjoin() =
      PayjoinStateWaitingSendPayjoin;
  const factory PayjoinState.error([String? errorMsg]) = PayjoinStateError;
}

@riverpod
class PayjoinStateNotifier extends _$PayjoinStateNotifier {
  @override
  PayjoinState build() {
    return const PayjoinStateEmpty();
  }

  void setPayjoinState(PayjoinState payjoinState) {
    state = payjoinState;
  }
}
