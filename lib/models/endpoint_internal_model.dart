import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sideswap/models/account_asset.dart';

part 'endpoint_internal_model.freezed.dart';

@freezed
class EICreateTransaction with _$EICreateTransaction {
  factory EICreateTransaction.empty() = EICreateTransactionEmpty;
  factory EICreateTransaction.data({
    required AccountAsset accountAsset,
    required String address,
    required String amount,
  }) = EICreateTransactionData;
}
