import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum FCMPayloadType {
  @JsonValue('Send')
  send,
  @JsonValue('Recv')
  recv,
  @JsonValue('Swap')
  swap,
  @JsonValue('Redeposit')
  redeposit,
  @JsonValue('Unknown')
  unknown,
  @JsonValue('Peg-in')
  pegin,
  @JsonValue('Peg-out')
  pegout,
}

enum FCMTxType {
  @JsonValue('Send')
  send,
  @JsonValue('Recv')
  recv,
  @JsonValue('Swap')
  swap,
  @JsonValue('Redeposit')
  redeposit,
  @JsonValue('Unknown')
  unknown,
}

@freezed
class FCMPayload with _$FCMPayload {
  // ignore: unused_element
  const FCMPayload._();
  const factory FCMPayload({
    FCMPayloadType? type,
    String? txid,
  }) = _FCMPayload;

  factory FCMPayload.fromJson(Map<String, dynamic> json) =>
      _$FCMPayloadFromJson(json);

  String toJsonString() {
    final json = toJson();
    return jsonEncode(json);
  }
}

@freezed
class FCMNotification with _$FCMNotification {
  const factory FCMNotification({
    String? title,
    String? body,
  }) = _FCMNotification;

  factory FCMNotification.fromJson(Map<String, dynamic> json) =>
      _$FCMNotificationFromJson(json);
}

@freezed
class FCMData with _$FCMData {
  const factory FCMData({
    FCMDetails? details,
  }) = _FCMData;

  factory FCMData.fromJson(Map<String, dynamic> json) =>
      FCMData.createFromJson(json);

  factory FCMData.createFromJson(Map<String, dynamic> json) {
    if (json['details'] is String) {
      final details = (json['details'] as String)
          .replaceAll(r'\', '')
          .replaceAll(r"'", '"');
      json['details'] = jsonDecode(details) as Map<String, dynamic>;
    }

    return _$FCMDataFromJson(json);
  }
}

@freezed
class FCMDetails with _$FCMDetails {
  const factory FCMDetails({
    FCMTx? tx,
    @JsonKey(name: 'peg_payout') FCMPeg? pegPayout,
    @JsonKey(name: 'peg_detected') FCMPeg? pegDetected,
    @JsonKey(name: 'order_cancelled') FCMOrderCancelled? orderCancelled,
  }) = _FCMDetails;

  factory FCMDetails.fromJson(Map<String, dynamic> json) =>
      _$FCMDetailsFromJson(json);
}

@freezed
class FCMTx with _$FCMTx {
  const factory FCMTx({
    @JsonKey(name: 'tx_type') FCMTxType? txType,
    @JsonKey(name: 'txid') String? txId,
  }) = _FCMTx;

  factory FCMTx.fromJson(Map<String, dynamic> json) => _$FCMTxFromJson(json);
}

@freezed
class FCMPeg with _$FCMPeg {
  const factory FCMPeg({
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'peg_in') bool? pegIn,
    @JsonKey(name: 'tx_hash') String? txHash,
    int? vout,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'payout_txid') String? payoutTxId,
    int? payout,
  }) = _FCMPeg;

  factory FCMPeg.fromJson(Map<String, dynamic> json) => _$FCMPegFromJson(json);
}

@freezed
class FCMOrderCancelled with _$FCMOrderCancelled {
  const factory FCMOrderCancelled({
    @JsonKey(name: 'order_id') String? orderId,
  }) = _FCMOrderCancelled;

  factory FCMOrderCancelled.fromJson(Map<String, dynamic> json) =>
      _$FCMOrderCancelledFromJson(json);
}

@freezed
class FCMMessage with _$FCMMessage {
  const factory FCMMessage({
    FCMNotification? notification,
    FCMData? data,
  }) = _FCMMessage;

  factory FCMMessage.fromJson(Map<String, dynamic> json) =>
      _$FCMMessageFromJson(json);
}

@freezed
sealed class FCMRemoteMessage with _$FCMRemoteMessage {
  const factory FCMRemoteMessage({
    dynamic details,
    String? body,
    String? title,
    Map<String, dynamic>? data,
  }) = _FCMRemoteMessage;

  factory FCMRemoteMessage.fromJson(Map<String, dynamic> json) =>
      _$FCMRemoteMessageFromJson(json);
}
