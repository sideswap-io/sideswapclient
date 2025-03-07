import 'package:freezed_annotation/freezed_annotation.dart';

part 'swap_models.freezed.dart';

@freezed
class SwapPriceSubscribeState with _$SwapPriceSubscribeState {
  const factory SwapPriceSubscribeState.empty() = SwapPriceSubscribeStateEmpty;
  const factory SwapPriceSubscribeState.send() = SwapPriceSubscribeStateSend;
  const factory SwapPriceSubscribeState.recv() = SwapPriceSubscribeStateRecv;
}

@freezed
class SwapRecvAmountPriceStream with _$SwapRecvAmountPriceStream {
  const factory SwapRecvAmountPriceStream.empty() =
      SwapRecvAmountPriceStreamEmpty;
  const factory SwapRecvAmountPriceStream.data({required String value}) =
      SwapRecvAmountPriceStreamData;
}

@freezed
class SwapSendAmountPriceStream with _$SwapSendAmountPriceStream {
  const factory SwapSendAmountPriceStream.empty() =
      SwapSendAmountPriceStreamEmpty;
  const factory SwapSendAmountPriceStream.data({required String value}) =
      SwapSendAmountPriceStreamData;
}
