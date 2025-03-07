// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FCMPayload _$FCMPayloadFromJson(Map json) => _FCMPayload(
  type: $enumDecodeNullable(_$FCMPayloadTypeEnumMap, json['type']),
  txid: json['txid'] as String?,
);

Map<String, dynamic> _$FCMPayloadToJson(_FCMPayload instance) =>
    <String, dynamic>{
      'type': _$FCMPayloadTypeEnumMap[instance.type],
      'txid': instance.txid,
    };

const _$FCMPayloadTypeEnumMap = {
  FCMPayloadType.send: 'Send',
  FCMPayloadType.recv: 'Recv',
  FCMPayloadType.swap: 'Swap',
  FCMPayloadType.redeposit: 'Redeposit',
  FCMPayloadType.unknown: 'Unknown',
  FCMPayloadType.pegin: 'Peg-in',
  FCMPayloadType.pegout: 'Peg-out',
};

_FCMNotification _$FCMNotificationFromJson(Map json) => _FCMNotification(
  title: json['title'] as String?,
  body: json['body'] as String?,
);

Map<String, dynamic> _$FCMNotificationToJson(_FCMNotification instance) =>
    <String, dynamic>{'title': instance.title, 'body': instance.body};

_FCMData _$FCMDataFromJson(Map json) => _FCMData(
  details:
      json['details'] == null
          ? null
          : FCMDetails.fromJson(
            Map<String, dynamic>.from(json['details'] as Map),
          ),
);

Map<String, dynamic> _$FCMDataToJson(_FCMData instance) => <String, dynamic>{
  'details': instance.details,
};

_FCMDetails _$FCMDetailsFromJson(Map json) => _FCMDetails(
  tx:
      json['tx'] == null
          ? null
          : FCMTx.fromJson(Map<String, dynamic>.from(json['tx'] as Map)),
  pegPayout:
      json['peg_payout'] == null
          ? null
          : FCMPeg.fromJson(
            Map<String, dynamic>.from(json['peg_payout'] as Map),
          ),
  pegDetected:
      json['peg_detected'] == null
          ? null
          : FCMPeg.fromJson(
            Map<String, dynamic>.from(json['peg_detected'] as Map),
          ),
  orderCancelled:
      json['order_cancelled'] == null
          ? null
          : FCMOrderCancelled.fromJson(
            Map<String, dynamic>.from(json['order_cancelled'] as Map),
          ),
);

Map<String, dynamic> _$FCMDetailsToJson(_FCMDetails instance) =>
    <String, dynamic>{
      'tx': instance.tx,
      'peg_payout': instance.pegPayout,
      'peg_detected': instance.pegDetected,
      'order_cancelled': instance.orderCancelled,
    };

_FCMTx _$FCMTxFromJson(Map json) => _FCMTx(
  txType: $enumDecodeNullable(_$FCMTxTypeEnumMap, json['tx_type']),
  txId: json['txid'] as String?,
);

Map<String, dynamic> _$FCMTxToJson(_FCMTx instance) => <String, dynamic>{
  'tx_type': _$FCMTxTypeEnumMap[instance.txType],
  'txid': instance.txId,
};

const _$FCMTxTypeEnumMap = {
  FCMTxType.send: 'Send',
  FCMTxType.recv: 'Recv',
  FCMTxType.swap: 'Swap',
  FCMTxType.redeposit: 'Redeposit',
  FCMTxType.unknown: 'Unknown',
};

_FCMPeg _$FCMPegFromJson(Map json) => _FCMPeg(
  orderId: json['order_id'] as String?,
  pegIn: json['peg_in'] as bool?,
  txHash: json['tx_hash'] as String?,
  vout: (json['vout'] as num?)?.toInt(),
  createdAt: (json['created_at'] as num?)?.toInt(),
  payoutTxId: json['payout_txid'] as String?,
  payout: (json['payout'] as num?)?.toInt(),
);

Map<String, dynamic> _$FCMPegToJson(_FCMPeg instance) => <String, dynamic>{
  'order_id': instance.orderId,
  'peg_in': instance.pegIn,
  'tx_hash': instance.txHash,
  'vout': instance.vout,
  'created_at': instance.createdAt,
  'payout_txid': instance.payoutTxId,
  'payout': instance.payout,
};

_FCMOrderCancelled _$FCMOrderCancelledFromJson(Map json) =>
    _FCMOrderCancelled(orderId: json['order_id'] as String?);

Map<String, dynamic> _$FCMOrderCancelledToJson(_FCMOrderCancelled instance) =>
    <String, dynamic>{'order_id': instance.orderId};

_FCMMessage _$FCMMessageFromJson(Map json) => _FCMMessage(
  notification:
      json['notification'] == null
          ? null
          : FCMNotification.fromJson(
            Map<String, dynamic>.from(json['notification'] as Map),
          ),
  data:
      json['data'] == null
          ? null
          : FCMData.fromJson(Map<String, dynamic>.from(json['data'] as Map)),
);

Map<String, dynamic> _$FCMMessageToJson(_FCMMessage instance) =>
    <String, dynamic>{
      'notification': instance.notification,
      'data': instance.data,
    };

_FCMRemoteMessage _$FCMRemoteMessageFromJson(Map json) => _FCMRemoteMessage(
  details: json['details'],
  body: json['body'] as String?,
  title: json['title'] as String?,
  data: (json['data'] as Map?)?.map((k, e) => MapEntry(k as String, e)),
);

Map<String, dynamic> _$FCMRemoteMessageToJson(_FCMRemoteMessage instance) =>
    <String, dynamic>{
      'details': instance.details,
      'body': instance.body,
      'title': instance.title,
      'data': instance.data,
    };
