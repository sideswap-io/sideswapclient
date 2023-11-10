import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sideswap/providers/qrcode_provider.dart';

part 'qrcode_models.freezed.dart';

@freezed
class QrCodeResultModel with _$QrCodeResultModel {
  const factory QrCodeResultModel.empty() = QrCodeResultModelEmpty;
  const factory QrCodeResultModel.data({
    QrCodeResult? result,
  }) = QrCodeResultModelData;
}
