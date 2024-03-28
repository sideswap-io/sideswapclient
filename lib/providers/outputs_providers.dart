import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/main/providers/d_send_popup_providers.dart';

part 'outputs_providers.freezed.dart';
part 'outputs_providers.g.dart';

class DoubleToDecimalConverter implements JsonConverter<Decimal?, double?> {
  const DoubleToDecimalConverter();

  @override
  Decimal? fromJson(double? value) {
    return value == null ? null : Decimal.tryParse('$value');
  }

  @override
  double? toJson(Decimal? object) {
    return object == null ? null : double.tryParse(object.toString());
  }
}

@Freezed(copyWith: true, equal: true)
class OutputsData with _$OutputsData {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory OutputsData({
    String? type,
    String? version,
    int? timestamp,
    List<OutputsReceiver>? receivers,
  }) = _OutputsData;

  factory OutputsData.fromJson(Map<String, dynamic> json) =>
      _$OutputsDataFromJson(json);
}

@Freezed(fromJson: true, equal: true)
class OutputsReceiver with _$OutputsReceiver {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory OutputsReceiver({
    String? address,
    @JsonKey(name: 'asset_id') String? assetId,
    @DoubleToDecimalConverter() Decimal? amount,
    String? comment,
  }) = _OutputsReceiver;

  factory OutputsReceiver.fromJson(Map<String, dynamic> json) =>
      _$OutputsReceiverFromJson(json);
}

@Riverpod(keepAlive: true)
class OutputsReaderNotifier extends _$OutputsReaderNotifier {
  @override
  Either<OutputsError, OutputsData> build() {
    return const Left(OutputsErrorOutputsDataIsEmpty());
  }

  Future<bool> decodeJsonString(String jsonString) async {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;

      return switch (json) {
        {'type': String type} when type != 'sideswap_app' => () {
            state =
                Left(OutputsErrorWrongTypeOfFile('Wrong type of file'.tr()));
            return false;
          }(),
        {'version': String version} when version != '1' => () {
            state = Left(
                OutputsErrorWrongVersionOfFile('Wrong version of file'.tr()));
            return false;
          }(),
        {'type': 'sideswap_app', 'version': '1'} => () {
            try {
              final outputsData = OutputsData.fromJson(json);
              state = Right(outputsData);
              return true;
            } catch (e) {
              logger.e(e);
              state = Left(
                  OutputsErrorFileStructureError('File structure error'.tr()));
            }
            return false;
          }(),
        _ => () {
            state =
                Left(OutputsErrorWrongTypeOfFile('Wrong type of file'.tr()));
            return false;
          }(),
      };
    } catch (e) {
      logger.e(e);
      state =
          Left(OutputsErrorJsonFileSyntaxError('Json file syntax error'.tr()));
    }

    return false;
  }

  Future<bool> setXFile(XFile? xFile) async {
    if (xFile == null) {
      return false;
    }

    try {
      final fileString = await xFile.readAsString();
      return decodeJsonString(fileString);
    } catch (e) {
      logger.e(e);
      state =
          Left(OutputsErrorOperationCancelled('Operation cancelled: $e'.tr()));
    }

    return false;
  }

  void insertOutput({
    required String assetId,
    required String address,
    required Decimal amount,
  }) {
    if (assetId.isEmpty || address.isEmpty || amount == Decimal.zero) {
      logger.w(
          'Inserting invalid output receiver arguments. AssetId: $assetId, address: $address, amount $amount');
      return;
    }

    final currentOutputs = switch (state) {
      Left<OutputsError, OutputsData>() => OutputsData(
          type: 'sideswap_app',
          version: '1',
          timestamp: DateTime.now().millisecondsSinceEpoch,
          receivers: [],
        ),
      Right<OutputsError, OutputsData>(value: final r) => r,
    };

    final newOutputs = currentOutputs.copyWith(receivers: [
      ...currentOutputs.receivers ?? [],
      ...[OutputsReceiver(address: address, assetId: assetId, amount: amount)]
    ]);

    state = Right(newOutputs);
  }

  void removeOutput(int index) {
    final currentOutputs = switch (state) {
      Left(value: final _) => null,
      Right(value: final r) => r,
    };

    if (currentOutputs == null || currentOutputs.receivers == null) {
      return;
    }

    final newReceiverList = [...currentOutputs.receivers ?? []];
    newReceiverList.removeAt(index);

    if (newReceiverList.isEmpty) {
      state = const Left(OutputsErrorOutputsDataIsEmpty());
      return;
    }

    state = Right(currentOutputs.copyWith(receivers: [...newReceiverList]));
  }
}

@riverpod
class OutputsCreator extends _$OutputsCreator {
  @override
  Either<OutputsError, OutputsData> build() {
    ref.keepAlive();
    final selectedAccountAsset =
        ref.watch(sendPopupSelectedAccountAssetNotifierProvider);
    final sendPopupAmount = ref.watch(sendPopupAmountNotifierProvider);
    final address = ref.watch(sendPopupAddressNotifierProvider);
    final outputsData = ref.watch(outputsReaderNotifierProvider);
    final amount = Decimal.tryParse(sendPopupAmount);
    final assetId = selectedAccountAsset.assetId;

    return switch (outputsData) {
      Left(value: final _)
          when amount == null ||
              assetId == null ||
              assetId.isEmpty ||
              address.isEmpty =>
        () {
          return const Left<OutputsError, OutputsData>(
              OutputsErrorRequiredDataIsEmpty());
        }(),
      Left(value: final _) => () {
          return Right<OutputsError, OutputsData>(OutputsData(
              type: 'sideswap_app',
              version: '1',
              timestamp: DateTime.now().millisecondsSinceEpoch,
              receivers: [
                OutputsReceiver(
                    address: address, assetId: assetId, amount: amount)
              ]));
        }(),
      Right(value: final value) => () {
          final receivers = [
            ...value.receivers ?? <OutputsReceiver>[],
          ];

          final outputs = OutputsData(
            type: 'sideswap_app',
            version: '1',
            timestamp: DateTime.now().millisecondsSinceEpoch,
            receivers: receivers,
          );
          return Right<OutputsError, OutputsData>(outputs);
        }(),
    };
  }

  Future<bool> saveToFile({String? suggestedName}) async {
    final currentOutputs = switch (state) {
      Left<OutputsError, OutputsData>() => null,
      Right<OutputsError, OutputsData>(value: final r) => r,
    };

    if (currentOutputs == null) {
      return false;
    }

    final fileName = switch (suggestedName) {
      final suggestedName? => '$suggestedName.json',
      _ => 'SideSwap_${currentOutputs.timestamp.toString()}_unsigned.json',
    };

    final directory = await getApplicationDocumentsDirectory();
    final result = await getSaveLocation(
        suggestedName: fileName, initialDirectory: directory.path);
    if (result == null) {
      // Operation was canceled by the user.
      return false;
    }

    final outputData = jsonEncode(currentOutputs.toJson());

    final Uint8List fileData = Uint8List.fromList(outputData.codeUnits);
    const String mimeType = 'text/plain';
    final XFile textFile =
        XFile.fromData(fileData, mimeType: mimeType, name: fileName);
    await textFile.saveTo(result.path);
    return true;
  }
}

@freezed
sealed class OutputsError with _$OutputsError {
  const factory OutputsError.wrongTypeOfFile([String? message]) =
      OutputsErrorWrongTypeOfFile;
  const factory OutputsError.wrongVersionOfFile([String? message]) =
      OutputsErrorWrongVersionOfFile;
  const factory OutputsError.jsonFileSyntaxError([String? message]) =
      OutputsErrorJsonFileSyntaxError;
  const factory OutputsError.fileStructureError([String? message]) =
      OutputsErrorFileStructureError;
  const factory OutputsError.operationCancelled([String? message]) =
      OutputsErrorOperationCancelled;
  const factory OutputsError.requiredDataIsEmpty([String? message]) =
      OutputsErrorRequiredDataIsEmpty;
  const factory OutputsError.outputsDataIsEmpty([String? message]) =
      OutputsErrorOutputsDataIsEmpty;
}
