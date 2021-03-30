import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

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

@freezed
abstract class FCMPayload implements _$FCMPayload {
  const FCMPayload._();
  const factory FCMPayload({
    @required FCMPayloadType type,
    @required String txid,
  }) = _FCMPayload;

  factory FCMPayload.fromJson(Map<String, Object> json) =>
      _$FCMPayloadFromJson(json);

  String toJsonString() {
    final json = toJson();
    return jsonEncode(json);
  }
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
abstract class FCMNotification with _$FCMNotification {
  const factory FCMNotification({
    @nullable String title,
    @nullable String body,
  }) = _FCMNotification;

  factory FCMNotification.fromJson(Map<String, Object> json) =>
      _$FCMNotificationFromJson(json);
}

@freezed
abstract class FCMData with _$FCMData {
  const factory FCMData({
    @nullable FCMDetails details,
  }) = _FCMData;

  factory FCMData.fromJson(Map<String, Object> json) =>
      FCMData.createFromJson(json);

  factory FCMData.createFromJson(Map<String, Object> json) {
    if (json['details'] is String) {
      json['details'] =
          jsonDecode(json['details'] as String) as Map<String, Object>;
    }

    return _$FCMDataFromJson(json);
  }
}

@freezed
abstract class FCMDetails with _$FCMDetails {
  const factory FCMDetails({
    @nullable FCMTx tx,
    @nullable @JsonKey(name: 'peg_payout') FCMPeg pegPayout,
    @nullable @JsonKey(name: 'peg_detected') FCMPeg pegDetected,
  }) = _FCMDetails;

  factory FCMDetails.fromJson(Map<String, Object> json) =>
      _$FCMDetailsFromJson(json);
}

@freezed
abstract class FCMTx with _$FCMTx {
  const factory FCMTx({
    @nullable @JsonKey(name: 'tx_type') FCMTxType txType,
    @nullable @JsonKey(name: 'txid') String txId,
  }) = _FCMTx;

  factory FCMTx.fromJson(Map<String, Object> json) => _$FCMTxFromJson(json);
}

@freezed
abstract class FCMPeg with _$FCMPeg {
  const factory FCMPeg({
    @nullable @JsonKey(name: 'order_id') String orderId,
    @nullable @JsonKey(name: 'peg_in') bool pegIn,
    @nullable @JsonKey(name: 'tx_hash') String txHash,
    @nullable int vout,
    @nullable @JsonKey(name: 'created_at') int createdAt,
    @nullable @JsonKey(name: 'payout_txid') String payoutTxId,
    @nullable int payout,
  }) = _FCMPeg;

  factory FCMPeg.fromJson(Map<String, Object> json) => _$FCMPegFromJson(json);
}

@freezed
abstract class FCMMessage with _$FCMMessage {
  const factory FCMMessage({
    @nullable FCMNotification notification,
    @nullable FCMData data,
  }) = _FCMMessage;

  factory FCMMessage.fromJson(Map<String, Object> json) =>
      _$FCMMessageFromJson(json);
}

// ================ IOS ================

@freezed
abstract class FCMIOSAps with _$FCMIOSAps {
  const factory FCMIOSAps({
    @nullable FCMNotification alert,
    @nullable String category,
  }) = _FCMIOSAps;

  factory FCMIOSAps.fromJson(Map<String, Object> json) =>
      _$FCMIOSApsFromJson(json);
}

@freezed
abstract class FCMIOSMessage with _$FCMIOSMessage {
  const factory FCMIOSMessage({
    @nullable FCMIOSAps aps,
    @nullable @JsonKey(name: 'google.c.sender.id') String googleCSenderId,
    @nullable FCMDetails details,
  }) = _FCMIOSMessage;

  factory FCMIOSMessage.fromJson(Map<String, Object> json) =>
      FCMIOSMessage.createFromJson(json);

  factory FCMIOSMessage.createFromJson(Map<String, Object> json) {
    if (json['details'] != null && json['details'] is String) {
      final details = (json['details'] as String)
          .replaceAll(r'\', '')
          .replaceAll(r"'", '"');
      json['details'] = jsonDecode(details) as Map<String, Object>;
    }

    return _$FCMIOSMessageFromJson(json);
  }
}
