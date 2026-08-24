import 'package:freezed_annotation/freezed_annotation.dart';

part 'swap_models.freezed.dart';

@freezed
class SwapPriceSubscribeState with _$SwapPriceSubscribeState {
  const factory SwapPriceSubscribeState.empty() = SwapPriceSubscribeStateEmpty;
  const factory SwapPriceSubscribeState.send() = SwapPriceSubscribeStateSend;
  const factory SwapPriceSubscribeState.recv() = SwapPriceSubscribeStateRecv;
}
