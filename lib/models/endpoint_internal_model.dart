import 'package:freezed_annotation/freezed_annotation.dart';

part 'endpoint_internal_model.freezed.dart';

@freezed
class EICreateTransaction with _$EICreateTransaction {
  factory EICreateTransaction.empty() = EICreateTransactionEmpty;
  factory EICreateTransaction.data({
    required String assetId,
    required String address,
    required String amount,
  }) = EICreateTransactionData;
}
