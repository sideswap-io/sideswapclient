// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FCMPayloadImpl _$$FCMPayloadImplFromJson(Map json) => _$FCMPayloadImpl(
      type: $enumDecodeNullable(_$FCMPayloadTypeEnumMap, json['type']),
      txid: json['txid'] as String?,
    );

Map<String, dynamic> _$$FCMPayloadImplToJson(_$FCMPayloadImpl instance) =>
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

_$FCMNotificationImpl _$$FCMNotificationImplFromJson(Map json) =>
    _$FCMNotificationImpl(
      title: json['title'] as String?,
      body: json['body'] as String?,
    );

Map<String, dynamic> _$$FCMNotificationImplToJson(
        _$FCMNotificationImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
    };

_$FCMDataImpl _$$FCMDataImplFromJson(Map json) => _$FCMDataImpl(
      details: json['details'] == null
          ? null
          : FCMDetails.fromJson(
              Map<String, dynamic>.from(json['details'] as Map)),
    );

Map<String, dynamic> _$$FCMDataImplToJson(_$FCMDataImpl instance) =>
    <String, dynamic>{
      'details': instance.details,
    };

_$FCMDetailsImpl _$$FCMDetailsImplFromJson(Map json) => _$FCMDetailsImpl(
      tx: json['tx'] == null
          ? null
          : FCMTx.fromJson(Map<String, dynamic>.from(json['tx'] as Map)),
      pegPayout: json['peg_payout'] == null
          ? null
          : FCMPeg.fromJson(
              Map<String, dynamic>.from(json['peg_payout'] as Map)),
      pegDetected: json['peg_detected'] == null
          ? null
          : FCMPeg.fromJson(
              Map<String, dynamic>.from(json['peg_detected'] as Map)),
      orderCancelled: json['order_cancelled'] == null
          ? null
          : FCMOrderCancelled.fromJson(
              Map<String, dynamic>.from(json['order_cancelled'] as Map)),
    );

Map<String, dynamic> _$$FCMDetailsImplToJson(_$FCMDetailsImpl instance) =>
    <String, dynamic>{
      'tx': instance.tx,
      'peg_payout': instance.pegPayout,
      'peg_detected': instance.pegDetected,
      'order_cancelled': instance.orderCancelled,
    };

_$FCMTxImpl _$$FCMTxImplFromJson(Map json) => _$FCMTxImpl(
      txType: $enumDecodeNullable(_$FCMTxTypeEnumMap, json['tx_type']),
      txId: json['txid'] as String?,
    );

Map<String, dynamic> _$$FCMTxImplToJson(_$FCMTxImpl instance) =>
    <String, dynamic>{
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

_$FCMPegImpl _$$FCMPegImplFromJson(Map json) => _$FCMPegImpl(
      orderId: json['order_id'] as String?,
      pegIn: json['peg_in'] as bool?,
      txHash: json['tx_hash'] as String?,
      vout: json['vout'] as int?,
      createdAt: json['created_at'] as int?,
      payoutTxId: json['payout_txid'] as String?,
      payout: json['payout'] as int?,
    );

Map<String, dynamic> _$$FCMPegImplToJson(_$FCMPegImpl instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'peg_in': instance.pegIn,
      'tx_hash': instance.txHash,
      'vout': instance.vout,
      'created_at': instance.createdAt,
      'payout_txid': instance.payoutTxId,
      'payout': instance.payout,
    };

_$FCMOrderCancelledImpl _$$FCMOrderCancelledImplFromJson(Map json) =>
    _$FCMOrderCancelledImpl(
      orderId: json['order_id'] as String?,
    );

Map<String, dynamic> _$$FCMOrderCancelledImplToJson(
        _$FCMOrderCancelledImpl instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
    };

_$FCMMessageImpl _$$FCMMessageImplFromJson(Map json) => _$FCMMessageImpl(
      notification: json['notification'] == null
          ? null
          : FCMNotification.fromJson(
              Map<String, dynamic>.from(json['notification'] as Map)),
      data: json['data'] == null
          ? null
          : FCMData.fromJson(Map<String, dynamic>.from(json['data'] as Map)),
    );

Map<String, dynamic> _$$FCMMessageImplToJson(_$FCMMessageImpl instance) =>
    <String, dynamic>{
      'notification': instance.notification,
      'data': instance.data,
    };
