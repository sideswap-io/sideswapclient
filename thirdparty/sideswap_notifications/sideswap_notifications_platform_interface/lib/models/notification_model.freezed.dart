// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FCMPayload {

 FCMPayloadType? get type; String? get txid;
/// Create a copy of FCMPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FCMPayloadCopyWith<FCMPayload> get copyWith => _$FCMPayloadCopyWithImpl<FCMPayload>(this as FCMPayload, _$identity);

  /// Serializes this FCMPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FCMPayload&&(identical(other.type, type) || other.type == type)&&(identical(other.txid, txid) || other.txid == txid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,txid);

@override
String toString() {
  return 'FCMPayload(type: $type, txid: $txid)';
}


}

/// @nodoc
abstract mixin class $FCMPayloadCopyWith<$Res>  {
  factory $FCMPayloadCopyWith(FCMPayload value, $Res Function(FCMPayload) _then) = _$FCMPayloadCopyWithImpl;
@useResult
$Res call({
 FCMPayloadType? type, String? txid
});




}
/// @nodoc
class _$FCMPayloadCopyWithImpl<$Res>
    implements $FCMPayloadCopyWith<$Res> {
  _$FCMPayloadCopyWithImpl(this._self, this._then);

  final FCMPayload _self;
  final $Res Function(FCMPayload) _then;

/// Create a copy of FCMPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? txid = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FCMPayloadType?,txid: freezed == txid ? _self.txid : txid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FCMPayload extends FCMPayload {
   _FCMPayload({this.type, this.txid}): super._();
  factory _FCMPayload.fromJson(Map<String, dynamic> json) => _$FCMPayloadFromJson(json);

@override final  FCMPayloadType? type;
@override final  String? txid;

/// Create a copy of FCMPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FCMPayloadCopyWith<_FCMPayload> get copyWith => __$FCMPayloadCopyWithImpl<_FCMPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FCMPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FCMPayload&&(identical(other.type, type) || other.type == type)&&(identical(other.txid, txid) || other.txid == txid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,txid);

@override
String toString() {
  return 'FCMPayload(type: $type, txid: $txid)';
}


}

/// @nodoc
abstract mixin class _$FCMPayloadCopyWith<$Res> implements $FCMPayloadCopyWith<$Res> {
  factory _$FCMPayloadCopyWith(_FCMPayload value, $Res Function(_FCMPayload) _then) = __$FCMPayloadCopyWithImpl;
@override @useResult
$Res call({
 FCMPayloadType? type, String? txid
});




}
/// @nodoc
class __$FCMPayloadCopyWithImpl<$Res>
    implements _$FCMPayloadCopyWith<$Res> {
  __$FCMPayloadCopyWithImpl(this._self, this._then);

  final _FCMPayload _self;
  final $Res Function(_FCMPayload) _then;

/// Create a copy of FCMPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? txid = freezed,}) {
  return _then(_FCMPayload(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FCMPayloadType?,txid: freezed == txid ? _self.txid : txid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FCMNotification {

 String? get title; String? get body;
/// Create a copy of FCMNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FCMNotificationCopyWith<FCMNotification> get copyWith => _$FCMNotificationCopyWithImpl<FCMNotification>(this as FCMNotification, _$identity);

  /// Serializes this FCMNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FCMNotification&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,body);

@override
String toString() {
  return 'FCMNotification(title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class $FCMNotificationCopyWith<$Res>  {
  factory $FCMNotificationCopyWith(FCMNotification value, $Res Function(FCMNotification) _then) = _$FCMNotificationCopyWithImpl;
@useResult
$Res call({
 String? title, String? body
});




}
/// @nodoc
class _$FCMNotificationCopyWithImpl<$Res>
    implements $FCMNotificationCopyWith<$Res> {
  _$FCMNotificationCopyWithImpl(this._self, this._then);

  final FCMNotification _self;
  final $Res Function(FCMNotification) _then;

/// Create a copy of FCMNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? body = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FCMNotification implements FCMNotification {
  const _FCMNotification({this.title, this.body});
  factory _FCMNotification.fromJson(Map<String, dynamic> json) => _$FCMNotificationFromJson(json);

@override final  String? title;
@override final  String? body;

/// Create a copy of FCMNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FCMNotificationCopyWith<_FCMNotification> get copyWith => __$FCMNotificationCopyWithImpl<_FCMNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FCMNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FCMNotification&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,body);

@override
String toString() {
  return 'FCMNotification(title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class _$FCMNotificationCopyWith<$Res> implements $FCMNotificationCopyWith<$Res> {
  factory _$FCMNotificationCopyWith(_FCMNotification value, $Res Function(_FCMNotification) _then) = __$FCMNotificationCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? body
});




}
/// @nodoc
class __$FCMNotificationCopyWithImpl<$Res>
    implements _$FCMNotificationCopyWith<$Res> {
  __$FCMNotificationCopyWithImpl(this._self, this._then);

  final _FCMNotification _self;
  final $Res Function(_FCMNotification) _then;

/// Create a copy of FCMNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? body = freezed,}) {
  return _then(_FCMNotification(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FCMData {

 FCMDetails? get details;
/// Create a copy of FCMData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FCMDataCopyWith<FCMData> get copyWith => _$FCMDataCopyWithImpl<FCMData>(this as FCMData, _$identity);

  /// Serializes this FCMData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FCMData&&(identical(other.details, details) || other.details == details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,details);

@override
String toString() {
  return 'FCMData(details: $details)';
}


}

/// @nodoc
abstract mixin class $FCMDataCopyWith<$Res>  {
  factory $FCMDataCopyWith(FCMData value, $Res Function(FCMData) _then) = _$FCMDataCopyWithImpl;
@useResult
$Res call({
 FCMDetails? details
});


$FCMDetailsCopyWith<$Res>? get details;

}
/// @nodoc
class _$FCMDataCopyWithImpl<$Res>
    implements $FCMDataCopyWith<$Res> {
  _$FCMDataCopyWithImpl(this._self, this._then);

  final FCMData _self;
  final $Res Function(FCMData) _then;

/// Create a copy of FCMData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? details = freezed,}) {
  return _then(_self.copyWith(
details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as FCMDetails?,
  ));
}
/// Create a copy of FCMData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMDetailsCopyWith<$Res>? get details {
    if (_self.details == null) {
    return null;
  }

  return $FCMDetailsCopyWith<$Res>(_self.details!, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _FCMData implements FCMData {
  const _FCMData({this.details});
  factory _FCMData.fromJson(Map<String, dynamic> json) => _$FCMDataFromJson(json);

@override final  FCMDetails? details;

/// Create a copy of FCMData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FCMDataCopyWith<_FCMData> get copyWith => __$FCMDataCopyWithImpl<_FCMData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FCMDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FCMData&&(identical(other.details, details) || other.details == details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,details);

@override
String toString() {
  return 'FCMData(details: $details)';
}


}

/// @nodoc
abstract mixin class _$FCMDataCopyWith<$Res> implements $FCMDataCopyWith<$Res> {
  factory _$FCMDataCopyWith(_FCMData value, $Res Function(_FCMData) _then) = __$FCMDataCopyWithImpl;
@override @useResult
$Res call({
 FCMDetails? details
});


@override $FCMDetailsCopyWith<$Res>? get details;

}
/// @nodoc
class __$FCMDataCopyWithImpl<$Res>
    implements _$FCMDataCopyWith<$Res> {
  __$FCMDataCopyWithImpl(this._self, this._then);

  final _FCMData _self;
  final $Res Function(_FCMData) _then;

/// Create a copy of FCMData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? details = freezed,}) {
  return _then(_FCMData(
details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as FCMDetails?,
  ));
}

/// Create a copy of FCMData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMDetailsCopyWith<$Res>? get details {
    if (_self.details == null) {
    return null;
  }

  return $FCMDetailsCopyWith<$Res>(_self.details!, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}


/// @nodoc
mixin _$FCMDetails {

 FCMTx? get tx;@JsonKey(name: 'peg_payout') FCMPeg? get pegPayout;@JsonKey(name: 'peg_detected') FCMPeg? get pegDetected;@JsonKey(name: 'order_cancelled') FCMOrderCancelled? get orderCancelled;
/// Create a copy of FCMDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FCMDetailsCopyWith<FCMDetails> get copyWith => _$FCMDetailsCopyWithImpl<FCMDetails>(this as FCMDetails, _$identity);

  /// Serializes this FCMDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FCMDetails&&(identical(other.tx, tx) || other.tx == tx)&&(identical(other.pegPayout, pegPayout) || other.pegPayout == pegPayout)&&(identical(other.pegDetected, pegDetected) || other.pegDetected == pegDetected)&&(identical(other.orderCancelled, orderCancelled) || other.orderCancelled == orderCancelled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tx,pegPayout,pegDetected,orderCancelled);

@override
String toString() {
  return 'FCMDetails(tx: $tx, pegPayout: $pegPayout, pegDetected: $pegDetected, orderCancelled: $orderCancelled)';
}


}

/// @nodoc
abstract mixin class $FCMDetailsCopyWith<$Res>  {
  factory $FCMDetailsCopyWith(FCMDetails value, $Res Function(FCMDetails) _then) = _$FCMDetailsCopyWithImpl;
@useResult
$Res call({
 FCMTx? tx,@JsonKey(name: 'peg_payout') FCMPeg? pegPayout,@JsonKey(name: 'peg_detected') FCMPeg? pegDetected,@JsonKey(name: 'order_cancelled') FCMOrderCancelled? orderCancelled
});


$FCMTxCopyWith<$Res>? get tx;$FCMPegCopyWith<$Res>? get pegPayout;$FCMPegCopyWith<$Res>? get pegDetected;$FCMOrderCancelledCopyWith<$Res>? get orderCancelled;

}
/// @nodoc
class _$FCMDetailsCopyWithImpl<$Res>
    implements $FCMDetailsCopyWith<$Res> {
  _$FCMDetailsCopyWithImpl(this._self, this._then);

  final FCMDetails _self;
  final $Res Function(FCMDetails) _then;

/// Create a copy of FCMDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tx = freezed,Object? pegPayout = freezed,Object? pegDetected = freezed,Object? orderCancelled = freezed,}) {
  return _then(_self.copyWith(
tx: freezed == tx ? _self.tx : tx // ignore: cast_nullable_to_non_nullable
as FCMTx?,pegPayout: freezed == pegPayout ? _self.pegPayout : pegPayout // ignore: cast_nullable_to_non_nullable
as FCMPeg?,pegDetected: freezed == pegDetected ? _self.pegDetected : pegDetected // ignore: cast_nullable_to_non_nullable
as FCMPeg?,orderCancelled: freezed == orderCancelled ? _self.orderCancelled : orderCancelled // ignore: cast_nullable_to_non_nullable
as FCMOrderCancelled?,
  ));
}
/// Create a copy of FCMDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMTxCopyWith<$Res>? get tx {
    if (_self.tx == null) {
    return null;
  }

  return $FCMTxCopyWith<$Res>(_self.tx!, (value) {
    return _then(_self.copyWith(tx: value));
  });
}/// Create a copy of FCMDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMPegCopyWith<$Res>? get pegPayout {
    if (_self.pegPayout == null) {
    return null;
  }

  return $FCMPegCopyWith<$Res>(_self.pegPayout!, (value) {
    return _then(_self.copyWith(pegPayout: value));
  });
}/// Create a copy of FCMDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMPegCopyWith<$Res>? get pegDetected {
    if (_self.pegDetected == null) {
    return null;
  }

  return $FCMPegCopyWith<$Res>(_self.pegDetected!, (value) {
    return _then(_self.copyWith(pegDetected: value));
  });
}/// Create a copy of FCMDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMOrderCancelledCopyWith<$Res>? get orderCancelled {
    if (_self.orderCancelled == null) {
    return null;
  }

  return $FCMOrderCancelledCopyWith<$Res>(_self.orderCancelled!, (value) {
    return _then(_self.copyWith(orderCancelled: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _FCMDetails implements FCMDetails {
  const _FCMDetails({this.tx, @JsonKey(name: 'peg_payout') this.pegPayout, @JsonKey(name: 'peg_detected') this.pegDetected, @JsonKey(name: 'order_cancelled') this.orderCancelled});
  factory _FCMDetails.fromJson(Map<String, dynamic> json) => _$FCMDetailsFromJson(json);

@override final  FCMTx? tx;
@override@JsonKey(name: 'peg_payout') final  FCMPeg? pegPayout;
@override@JsonKey(name: 'peg_detected') final  FCMPeg? pegDetected;
@override@JsonKey(name: 'order_cancelled') final  FCMOrderCancelled? orderCancelled;

/// Create a copy of FCMDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FCMDetailsCopyWith<_FCMDetails> get copyWith => __$FCMDetailsCopyWithImpl<_FCMDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FCMDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FCMDetails&&(identical(other.tx, tx) || other.tx == tx)&&(identical(other.pegPayout, pegPayout) || other.pegPayout == pegPayout)&&(identical(other.pegDetected, pegDetected) || other.pegDetected == pegDetected)&&(identical(other.orderCancelled, orderCancelled) || other.orderCancelled == orderCancelled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tx,pegPayout,pegDetected,orderCancelled);

@override
String toString() {
  return 'FCMDetails(tx: $tx, pegPayout: $pegPayout, pegDetected: $pegDetected, orderCancelled: $orderCancelled)';
}


}

/// @nodoc
abstract mixin class _$FCMDetailsCopyWith<$Res> implements $FCMDetailsCopyWith<$Res> {
  factory _$FCMDetailsCopyWith(_FCMDetails value, $Res Function(_FCMDetails) _then) = __$FCMDetailsCopyWithImpl;
@override @useResult
$Res call({
 FCMTx? tx,@JsonKey(name: 'peg_payout') FCMPeg? pegPayout,@JsonKey(name: 'peg_detected') FCMPeg? pegDetected,@JsonKey(name: 'order_cancelled') FCMOrderCancelled? orderCancelled
});


@override $FCMTxCopyWith<$Res>? get tx;@override $FCMPegCopyWith<$Res>? get pegPayout;@override $FCMPegCopyWith<$Res>? get pegDetected;@override $FCMOrderCancelledCopyWith<$Res>? get orderCancelled;

}
/// @nodoc
class __$FCMDetailsCopyWithImpl<$Res>
    implements _$FCMDetailsCopyWith<$Res> {
  __$FCMDetailsCopyWithImpl(this._self, this._then);

  final _FCMDetails _self;
  final $Res Function(_FCMDetails) _then;

/// Create a copy of FCMDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tx = freezed,Object? pegPayout = freezed,Object? pegDetected = freezed,Object? orderCancelled = freezed,}) {
  return _then(_FCMDetails(
tx: freezed == tx ? _self.tx : tx // ignore: cast_nullable_to_non_nullable
as FCMTx?,pegPayout: freezed == pegPayout ? _self.pegPayout : pegPayout // ignore: cast_nullable_to_non_nullable
as FCMPeg?,pegDetected: freezed == pegDetected ? _self.pegDetected : pegDetected // ignore: cast_nullable_to_non_nullable
as FCMPeg?,orderCancelled: freezed == orderCancelled ? _self.orderCancelled : orderCancelled // ignore: cast_nullable_to_non_nullable
as FCMOrderCancelled?,
  ));
}

/// Create a copy of FCMDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMTxCopyWith<$Res>? get tx {
    if (_self.tx == null) {
    return null;
  }

  return $FCMTxCopyWith<$Res>(_self.tx!, (value) {
    return _then(_self.copyWith(tx: value));
  });
}/// Create a copy of FCMDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMPegCopyWith<$Res>? get pegPayout {
    if (_self.pegPayout == null) {
    return null;
  }

  return $FCMPegCopyWith<$Res>(_self.pegPayout!, (value) {
    return _then(_self.copyWith(pegPayout: value));
  });
}/// Create a copy of FCMDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMPegCopyWith<$Res>? get pegDetected {
    if (_self.pegDetected == null) {
    return null;
  }

  return $FCMPegCopyWith<$Res>(_self.pegDetected!, (value) {
    return _then(_self.copyWith(pegDetected: value));
  });
}/// Create a copy of FCMDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMOrderCancelledCopyWith<$Res>? get orderCancelled {
    if (_self.orderCancelled == null) {
    return null;
  }

  return $FCMOrderCancelledCopyWith<$Res>(_self.orderCancelled!, (value) {
    return _then(_self.copyWith(orderCancelled: value));
  });
}
}


/// @nodoc
mixin _$FCMTx {

@JsonKey(name: 'tx_type') FCMTxType? get txType;@JsonKey(name: 'txid') String? get txId;
/// Create a copy of FCMTx
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FCMTxCopyWith<FCMTx> get copyWith => _$FCMTxCopyWithImpl<FCMTx>(this as FCMTx, _$identity);

  /// Serializes this FCMTx to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FCMTx&&(identical(other.txType, txType) || other.txType == txType)&&(identical(other.txId, txId) || other.txId == txId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,txType,txId);

@override
String toString() {
  return 'FCMTx(txType: $txType, txId: $txId)';
}


}

/// @nodoc
abstract mixin class $FCMTxCopyWith<$Res>  {
  factory $FCMTxCopyWith(FCMTx value, $Res Function(FCMTx) _then) = _$FCMTxCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tx_type') FCMTxType? txType,@JsonKey(name: 'txid') String? txId
});




}
/// @nodoc
class _$FCMTxCopyWithImpl<$Res>
    implements $FCMTxCopyWith<$Res> {
  _$FCMTxCopyWithImpl(this._self, this._then);

  final FCMTx _self;
  final $Res Function(FCMTx) _then;

/// Create a copy of FCMTx
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? txType = freezed,Object? txId = freezed,}) {
  return _then(_self.copyWith(
txType: freezed == txType ? _self.txType : txType // ignore: cast_nullable_to_non_nullable
as FCMTxType?,txId: freezed == txId ? _self.txId : txId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FCMTx implements FCMTx {
  const _FCMTx({@JsonKey(name: 'tx_type') this.txType, @JsonKey(name: 'txid') this.txId});
  factory _FCMTx.fromJson(Map<String, dynamic> json) => _$FCMTxFromJson(json);

@override@JsonKey(name: 'tx_type') final  FCMTxType? txType;
@override@JsonKey(name: 'txid') final  String? txId;

/// Create a copy of FCMTx
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FCMTxCopyWith<_FCMTx> get copyWith => __$FCMTxCopyWithImpl<_FCMTx>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FCMTxToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FCMTx&&(identical(other.txType, txType) || other.txType == txType)&&(identical(other.txId, txId) || other.txId == txId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,txType,txId);

@override
String toString() {
  return 'FCMTx(txType: $txType, txId: $txId)';
}


}

/// @nodoc
abstract mixin class _$FCMTxCopyWith<$Res> implements $FCMTxCopyWith<$Res> {
  factory _$FCMTxCopyWith(_FCMTx value, $Res Function(_FCMTx) _then) = __$FCMTxCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tx_type') FCMTxType? txType,@JsonKey(name: 'txid') String? txId
});




}
/// @nodoc
class __$FCMTxCopyWithImpl<$Res>
    implements _$FCMTxCopyWith<$Res> {
  __$FCMTxCopyWithImpl(this._self, this._then);

  final _FCMTx _self;
  final $Res Function(_FCMTx) _then;

/// Create a copy of FCMTx
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? txType = freezed,Object? txId = freezed,}) {
  return _then(_FCMTx(
txType: freezed == txType ? _self.txType : txType // ignore: cast_nullable_to_non_nullable
as FCMTxType?,txId: freezed == txId ? _self.txId : txId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FCMPeg {

@JsonKey(name: 'order_id') String? get orderId;@JsonKey(name: 'peg_in') bool? get pegIn;@JsonKey(name: 'tx_hash') String? get txHash; int? get vout;@JsonKey(name: 'created_at') int? get createdAt;@JsonKey(name: 'payout_txid') String? get payoutTxId; int? get payout;
/// Create a copy of FCMPeg
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FCMPegCopyWith<FCMPeg> get copyWith => _$FCMPegCopyWithImpl<FCMPeg>(this as FCMPeg, _$identity);

  /// Serializes this FCMPeg to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FCMPeg&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.pegIn, pegIn) || other.pegIn == pegIn)&&(identical(other.txHash, txHash) || other.txHash == txHash)&&(identical(other.vout, vout) || other.vout == vout)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.payoutTxId, payoutTxId) || other.payoutTxId == payoutTxId)&&(identical(other.payout, payout) || other.payout == payout));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,pegIn,txHash,vout,createdAt,payoutTxId,payout);

@override
String toString() {
  return 'FCMPeg(orderId: $orderId, pegIn: $pegIn, txHash: $txHash, vout: $vout, createdAt: $createdAt, payoutTxId: $payoutTxId, payout: $payout)';
}


}

/// @nodoc
abstract mixin class $FCMPegCopyWith<$Res>  {
  factory $FCMPegCopyWith(FCMPeg value, $Res Function(FCMPeg) _then) = _$FCMPegCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'order_id') String? orderId,@JsonKey(name: 'peg_in') bool? pegIn,@JsonKey(name: 'tx_hash') String? txHash, int? vout,@JsonKey(name: 'created_at') int? createdAt,@JsonKey(name: 'payout_txid') String? payoutTxId, int? payout
});




}
/// @nodoc
class _$FCMPegCopyWithImpl<$Res>
    implements $FCMPegCopyWith<$Res> {
  _$FCMPegCopyWithImpl(this._self, this._then);

  final FCMPeg _self;
  final $Res Function(FCMPeg) _then;

/// Create a copy of FCMPeg
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = freezed,Object? pegIn = freezed,Object? txHash = freezed,Object? vout = freezed,Object? createdAt = freezed,Object? payoutTxId = freezed,Object? payout = freezed,}) {
  return _then(_self.copyWith(
orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,pegIn: freezed == pegIn ? _self.pegIn : pegIn // ignore: cast_nullable_to_non_nullable
as bool?,txHash: freezed == txHash ? _self.txHash : txHash // ignore: cast_nullable_to_non_nullable
as String?,vout: freezed == vout ? _self.vout : vout // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,payoutTxId: freezed == payoutTxId ? _self.payoutTxId : payoutTxId // ignore: cast_nullable_to_non_nullable
as String?,payout: freezed == payout ? _self.payout : payout // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FCMPeg implements FCMPeg {
  const _FCMPeg({@JsonKey(name: 'order_id') this.orderId, @JsonKey(name: 'peg_in') this.pegIn, @JsonKey(name: 'tx_hash') this.txHash, this.vout, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'payout_txid') this.payoutTxId, this.payout});
  factory _FCMPeg.fromJson(Map<String, dynamic> json) => _$FCMPegFromJson(json);

@override@JsonKey(name: 'order_id') final  String? orderId;
@override@JsonKey(name: 'peg_in') final  bool? pegIn;
@override@JsonKey(name: 'tx_hash') final  String? txHash;
@override final  int? vout;
@override@JsonKey(name: 'created_at') final  int? createdAt;
@override@JsonKey(name: 'payout_txid') final  String? payoutTxId;
@override final  int? payout;

/// Create a copy of FCMPeg
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FCMPegCopyWith<_FCMPeg> get copyWith => __$FCMPegCopyWithImpl<_FCMPeg>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FCMPegToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FCMPeg&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.pegIn, pegIn) || other.pegIn == pegIn)&&(identical(other.txHash, txHash) || other.txHash == txHash)&&(identical(other.vout, vout) || other.vout == vout)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.payoutTxId, payoutTxId) || other.payoutTxId == payoutTxId)&&(identical(other.payout, payout) || other.payout == payout));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,pegIn,txHash,vout,createdAt,payoutTxId,payout);

@override
String toString() {
  return 'FCMPeg(orderId: $orderId, pegIn: $pegIn, txHash: $txHash, vout: $vout, createdAt: $createdAt, payoutTxId: $payoutTxId, payout: $payout)';
}


}

/// @nodoc
abstract mixin class _$FCMPegCopyWith<$Res> implements $FCMPegCopyWith<$Res> {
  factory _$FCMPegCopyWith(_FCMPeg value, $Res Function(_FCMPeg) _then) = __$FCMPegCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'order_id') String? orderId,@JsonKey(name: 'peg_in') bool? pegIn,@JsonKey(name: 'tx_hash') String? txHash, int? vout,@JsonKey(name: 'created_at') int? createdAt,@JsonKey(name: 'payout_txid') String? payoutTxId, int? payout
});




}
/// @nodoc
class __$FCMPegCopyWithImpl<$Res>
    implements _$FCMPegCopyWith<$Res> {
  __$FCMPegCopyWithImpl(this._self, this._then);

  final _FCMPeg _self;
  final $Res Function(_FCMPeg) _then;

/// Create a copy of FCMPeg
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = freezed,Object? pegIn = freezed,Object? txHash = freezed,Object? vout = freezed,Object? createdAt = freezed,Object? payoutTxId = freezed,Object? payout = freezed,}) {
  return _then(_FCMPeg(
orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,pegIn: freezed == pegIn ? _self.pegIn : pegIn // ignore: cast_nullable_to_non_nullable
as bool?,txHash: freezed == txHash ? _self.txHash : txHash // ignore: cast_nullable_to_non_nullable
as String?,vout: freezed == vout ? _self.vout : vout // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,payoutTxId: freezed == payoutTxId ? _self.payoutTxId : payoutTxId // ignore: cast_nullable_to_non_nullable
as String?,payout: freezed == payout ? _self.payout : payout // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$FCMOrderCancelled {

@JsonKey(name: 'order_id') String? get orderId;
/// Create a copy of FCMOrderCancelled
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FCMOrderCancelledCopyWith<FCMOrderCancelled> get copyWith => _$FCMOrderCancelledCopyWithImpl<FCMOrderCancelled>(this as FCMOrderCancelled, _$identity);

  /// Serializes this FCMOrderCancelled to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FCMOrderCancelled&&(identical(other.orderId, orderId) || other.orderId == orderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId);

@override
String toString() {
  return 'FCMOrderCancelled(orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class $FCMOrderCancelledCopyWith<$Res>  {
  factory $FCMOrderCancelledCopyWith(FCMOrderCancelled value, $Res Function(FCMOrderCancelled) _then) = _$FCMOrderCancelledCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'order_id') String? orderId
});




}
/// @nodoc
class _$FCMOrderCancelledCopyWithImpl<$Res>
    implements $FCMOrderCancelledCopyWith<$Res> {
  _$FCMOrderCancelledCopyWithImpl(this._self, this._then);

  final FCMOrderCancelled _self;
  final $Res Function(FCMOrderCancelled) _then;

/// Create a copy of FCMOrderCancelled
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = freezed,}) {
  return _then(_self.copyWith(
orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FCMOrderCancelled implements FCMOrderCancelled {
  const _FCMOrderCancelled({@JsonKey(name: 'order_id') this.orderId});
  factory _FCMOrderCancelled.fromJson(Map<String, dynamic> json) => _$FCMOrderCancelledFromJson(json);

@override@JsonKey(name: 'order_id') final  String? orderId;

/// Create a copy of FCMOrderCancelled
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FCMOrderCancelledCopyWith<_FCMOrderCancelled> get copyWith => __$FCMOrderCancelledCopyWithImpl<_FCMOrderCancelled>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FCMOrderCancelledToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FCMOrderCancelled&&(identical(other.orderId, orderId) || other.orderId == orderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId);

@override
String toString() {
  return 'FCMOrderCancelled(orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class _$FCMOrderCancelledCopyWith<$Res> implements $FCMOrderCancelledCopyWith<$Res> {
  factory _$FCMOrderCancelledCopyWith(_FCMOrderCancelled value, $Res Function(_FCMOrderCancelled) _then) = __$FCMOrderCancelledCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'order_id') String? orderId
});




}
/// @nodoc
class __$FCMOrderCancelledCopyWithImpl<$Res>
    implements _$FCMOrderCancelledCopyWith<$Res> {
  __$FCMOrderCancelledCopyWithImpl(this._self, this._then);

  final _FCMOrderCancelled _self;
  final $Res Function(_FCMOrderCancelled) _then;

/// Create a copy of FCMOrderCancelled
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = freezed,}) {
  return _then(_FCMOrderCancelled(
orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FCMMessage {

 FCMNotification? get notification; FCMData? get data;
/// Create a copy of FCMMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FCMMessageCopyWith<FCMMessage> get copyWith => _$FCMMessageCopyWithImpl<FCMMessage>(this as FCMMessage, _$identity);

  /// Serializes this FCMMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FCMMessage&&(identical(other.notification, notification) || other.notification == notification)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notification,data);

@override
String toString() {
  return 'FCMMessage(notification: $notification, data: $data)';
}


}

/// @nodoc
abstract mixin class $FCMMessageCopyWith<$Res>  {
  factory $FCMMessageCopyWith(FCMMessage value, $Res Function(FCMMessage) _then) = _$FCMMessageCopyWithImpl;
@useResult
$Res call({
 FCMNotification? notification, FCMData? data
});


$FCMNotificationCopyWith<$Res>? get notification;$FCMDataCopyWith<$Res>? get data;

}
/// @nodoc
class _$FCMMessageCopyWithImpl<$Res>
    implements $FCMMessageCopyWith<$Res> {
  _$FCMMessageCopyWithImpl(this._self, this._then);

  final FCMMessage _self;
  final $Res Function(FCMMessage) _then;

/// Create a copy of FCMMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notification = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
notification: freezed == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as FCMNotification?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as FCMData?,
  ));
}
/// Create a copy of FCMMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMNotificationCopyWith<$Res>? get notification {
    if (_self.notification == null) {
    return null;
  }

  return $FCMNotificationCopyWith<$Res>(_self.notification!, (value) {
    return _then(_self.copyWith(notification: value));
  });
}/// Create a copy of FCMMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $FCMDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _FCMMessage implements FCMMessage {
  const _FCMMessage({this.notification, this.data});
  factory _FCMMessage.fromJson(Map<String, dynamic> json) => _$FCMMessageFromJson(json);

@override final  FCMNotification? notification;
@override final  FCMData? data;

/// Create a copy of FCMMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FCMMessageCopyWith<_FCMMessage> get copyWith => __$FCMMessageCopyWithImpl<_FCMMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FCMMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FCMMessage&&(identical(other.notification, notification) || other.notification == notification)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notification,data);

@override
String toString() {
  return 'FCMMessage(notification: $notification, data: $data)';
}


}

/// @nodoc
abstract mixin class _$FCMMessageCopyWith<$Res> implements $FCMMessageCopyWith<$Res> {
  factory _$FCMMessageCopyWith(_FCMMessage value, $Res Function(_FCMMessage) _then) = __$FCMMessageCopyWithImpl;
@override @useResult
$Res call({
 FCMNotification? notification, FCMData? data
});


@override $FCMNotificationCopyWith<$Res>? get notification;@override $FCMDataCopyWith<$Res>? get data;

}
/// @nodoc
class __$FCMMessageCopyWithImpl<$Res>
    implements _$FCMMessageCopyWith<$Res> {
  __$FCMMessageCopyWithImpl(this._self, this._then);

  final _FCMMessage _self;
  final $Res Function(_FCMMessage) _then;

/// Create a copy of FCMMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notification = freezed,Object? data = freezed,}) {
  return _then(_FCMMessage(
notification: freezed == notification ? _self.notification : notification // ignore: cast_nullable_to_non_nullable
as FCMNotification?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as FCMData?,
  ));
}

/// Create a copy of FCMMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMNotificationCopyWith<$Res>? get notification {
    if (_self.notification == null) {
    return null;
  }

  return $FCMNotificationCopyWith<$Res>(_self.notification!, (value) {
    return _then(_self.copyWith(notification: value));
  });
}/// Create a copy of FCMMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FCMDataCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $FCMDataCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$FCMRemoteMessage {

 dynamic get details; String? get body; String? get title; Map<String, dynamic>? get data;
/// Create a copy of FCMRemoteMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FCMRemoteMessageCopyWith<FCMRemoteMessage> get copyWith => _$FCMRemoteMessageCopyWithImpl<FCMRemoteMessage>(this as FCMRemoteMessage, _$identity);

  /// Serializes this FCMRemoteMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FCMRemoteMessage&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.body, body) || other.body == body)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(details),body,title,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'FCMRemoteMessage(details: $details, body: $body, title: $title, data: $data)';
}


}

/// @nodoc
abstract mixin class $FCMRemoteMessageCopyWith<$Res>  {
  factory $FCMRemoteMessageCopyWith(FCMRemoteMessage value, $Res Function(FCMRemoteMessage) _then) = _$FCMRemoteMessageCopyWithImpl;
@useResult
$Res call({
 dynamic details, String? body, String? title, Map<String, dynamic>? data
});




}
/// @nodoc
class _$FCMRemoteMessageCopyWithImpl<$Res>
    implements $FCMRemoteMessageCopyWith<$Res> {
  _$FCMRemoteMessageCopyWithImpl(this._self, this._then);

  final FCMRemoteMessage _self;
  final $Res Function(FCMRemoteMessage) _then;

/// Create a copy of FCMRemoteMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? details = freezed,Object? body = freezed,Object? title = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as dynamic,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _FCMRemoteMessage implements FCMRemoteMessage {
  const _FCMRemoteMessage({this.details, this.body, this.title, final  Map<String, dynamic>? data}): _data = data;
  factory _FCMRemoteMessage.fromJson(Map<String, dynamic> json) => _$FCMRemoteMessageFromJson(json);

@override final  dynamic details;
@override final  String? body;
@override final  String? title;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of FCMRemoteMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FCMRemoteMessageCopyWith<_FCMRemoteMessage> get copyWith => __$FCMRemoteMessageCopyWithImpl<_FCMRemoteMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FCMRemoteMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FCMRemoteMessage&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.body, body) || other.body == body)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(details),body,title,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'FCMRemoteMessage(details: $details, body: $body, title: $title, data: $data)';
}


}

/// @nodoc
abstract mixin class _$FCMRemoteMessageCopyWith<$Res> implements $FCMRemoteMessageCopyWith<$Res> {
  factory _$FCMRemoteMessageCopyWith(_FCMRemoteMessage value, $Res Function(_FCMRemoteMessage) _then) = __$FCMRemoteMessageCopyWithImpl;
@override @useResult
$Res call({
 dynamic details, String? body, String? title, Map<String, dynamic>? data
});




}
/// @nodoc
class __$FCMRemoteMessageCopyWithImpl<$Res>
    implements _$FCMRemoteMessageCopyWith<$Res> {
  __$FCMRemoteMessageCopyWithImpl(this._self, this._then);

  final _FCMRemoteMessage _self;
  final $Res Function(_FCMRemoteMessage) _then;

/// Create a copy of FCMRemoteMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? details = freezed,Object? body = freezed,Object? title = freezed,Object? data = freezed,}) {
  return _then(_FCMRemoteMessage(
details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as dynamic,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
