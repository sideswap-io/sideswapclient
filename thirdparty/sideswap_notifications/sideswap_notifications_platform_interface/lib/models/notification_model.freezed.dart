// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FCMPayload _$FCMPayloadFromJson(Map<String, dynamic> json) {
  return _FCMPayload.fromJson(json);
}

/// @nodoc
mixin _$FCMPayload {
  FCMPayloadType? get type => throw _privateConstructorUsedError;
  String? get txid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FCMPayloadCopyWith<FCMPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FCMPayloadCopyWith<$Res> {
  factory $FCMPayloadCopyWith(
          FCMPayload value, $Res Function(FCMPayload) then) =
      _$FCMPayloadCopyWithImpl<$Res, FCMPayload>;
  @useResult
  $Res call({FCMPayloadType? type, String? txid});
}

/// @nodoc
class _$FCMPayloadCopyWithImpl<$Res, $Val extends FCMPayload>
    implements $FCMPayloadCopyWith<$Res> {
  _$FCMPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? txid = freezed,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FCMPayloadType?,
      txid: freezed == txid
          ? _value.txid
          : txid // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FCMPayloadImplCopyWith<$Res>
    implements $FCMPayloadCopyWith<$Res> {
  factory _$$FCMPayloadImplCopyWith(
          _$FCMPayloadImpl value, $Res Function(_$FCMPayloadImpl) then) =
      __$$FCMPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FCMPayloadType? type, String? txid});
}

/// @nodoc
class __$$FCMPayloadImplCopyWithImpl<$Res>
    extends _$FCMPayloadCopyWithImpl<$Res, _$FCMPayloadImpl>
    implements _$$FCMPayloadImplCopyWith<$Res> {
  __$$FCMPayloadImplCopyWithImpl(
      _$FCMPayloadImpl _value, $Res Function(_$FCMPayloadImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? txid = freezed,
  }) {
    return _then(_$FCMPayloadImpl(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FCMPayloadType?,
      txid: freezed == txid
          ? _value.txid
          : txid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FCMPayloadImpl extends _FCMPayload {
  const _$FCMPayloadImpl({this.type, this.txid}) : super._();

  factory _$FCMPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$FCMPayloadImplFromJson(json);

  @override
  final FCMPayloadType? type;
  @override
  final String? txid;

  @override
  String toString() {
    return 'FCMPayload(type: $type, txid: $txid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FCMPayloadImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.txid, txid) || other.txid == txid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, txid);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FCMPayloadImplCopyWith<_$FCMPayloadImpl> get copyWith =>
      __$$FCMPayloadImplCopyWithImpl<_$FCMPayloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FCMPayloadImplToJson(
      this,
    );
  }
}

abstract class _FCMPayload extends FCMPayload {
  const factory _FCMPayload({final FCMPayloadType? type, final String? txid}) =
      _$FCMPayloadImpl;
  const _FCMPayload._() : super._();

  factory _FCMPayload.fromJson(Map<String, dynamic> json) =
      _$FCMPayloadImpl.fromJson;

  @override
  FCMPayloadType? get type;
  @override
  String? get txid;
  @override
  @JsonKey(ignore: true)
  _$$FCMPayloadImplCopyWith<_$FCMPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FCMNotification _$FCMNotificationFromJson(Map<String, dynamic> json) {
  return _FCMNotification.fromJson(json);
}

/// @nodoc
mixin _$FCMNotification {
  String? get title => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FCMNotificationCopyWith<FCMNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FCMNotificationCopyWith<$Res> {
  factory $FCMNotificationCopyWith(
          FCMNotification value, $Res Function(FCMNotification) then) =
      _$FCMNotificationCopyWithImpl<$Res, FCMNotification>;
  @useResult
  $Res call({String? title, String? body});
}

/// @nodoc
class _$FCMNotificationCopyWithImpl<$Res, $Val extends FCMNotification>
    implements $FCMNotificationCopyWith<$Res> {
  _$FCMNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FCMNotificationImplCopyWith<$Res>
    implements $FCMNotificationCopyWith<$Res> {
  factory _$$FCMNotificationImplCopyWith(_$FCMNotificationImpl value,
          $Res Function(_$FCMNotificationImpl) then) =
      __$$FCMNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? title, String? body});
}

/// @nodoc
class __$$FCMNotificationImplCopyWithImpl<$Res>
    extends _$FCMNotificationCopyWithImpl<$Res, _$FCMNotificationImpl>
    implements _$$FCMNotificationImplCopyWith<$Res> {
  __$$FCMNotificationImplCopyWithImpl(
      _$FCMNotificationImpl _value, $Res Function(_$FCMNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(_$FCMNotificationImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FCMNotificationImpl implements _FCMNotification {
  const _$FCMNotificationImpl({this.title, this.body});

  factory _$FCMNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$FCMNotificationImplFromJson(json);

  @override
  final String? title;
  @override
  final String? body;

  @override
  String toString() {
    return 'FCMNotification(title: $title, body: $body)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FCMNotificationImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, body);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FCMNotificationImplCopyWith<_$FCMNotificationImpl> get copyWith =>
      __$$FCMNotificationImplCopyWithImpl<_$FCMNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FCMNotificationImplToJson(
      this,
    );
  }
}

abstract class _FCMNotification implements FCMNotification {
  const factory _FCMNotification({final String? title, final String? body}) =
      _$FCMNotificationImpl;

  factory _FCMNotification.fromJson(Map<String, dynamic> json) =
      _$FCMNotificationImpl.fromJson;

  @override
  String? get title;
  @override
  String? get body;
  @override
  @JsonKey(ignore: true)
  _$$FCMNotificationImplCopyWith<_$FCMNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FCMData _$FCMDataFromJson(Map<String, dynamic> json) {
  return _FCMData.fromJson(json);
}

/// @nodoc
mixin _$FCMData {
  FCMDetails? get details => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FCMDataCopyWith<FCMData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FCMDataCopyWith<$Res> {
  factory $FCMDataCopyWith(FCMData value, $Res Function(FCMData) then) =
      _$FCMDataCopyWithImpl<$Res, FCMData>;
  @useResult
  $Res call({FCMDetails? details});

  $FCMDetailsCopyWith<$Res>? get details;
}

/// @nodoc
class _$FCMDataCopyWithImpl<$Res, $Val extends FCMData>
    implements $FCMDataCopyWith<$Res> {
  _$FCMDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? details = freezed,
  }) {
    return _then(_value.copyWith(
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as FCMDetails?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FCMDetailsCopyWith<$Res>? get details {
    if (_value.details == null) {
      return null;
    }

    return $FCMDetailsCopyWith<$Res>(_value.details!, (value) {
      return _then(_value.copyWith(details: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FCMDataImplCopyWith<$Res> implements $FCMDataCopyWith<$Res> {
  factory _$$FCMDataImplCopyWith(
          _$FCMDataImpl value, $Res Function(_$FCMDataImpl) then) =
      __$$FCMDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FCMDetails? details});

  @override
  $FCMDetailsCopyWith<$Res>? get details;
}

/// @nodoc
class __$$FCMDataImplCopyWithImpl<$Res>
    extends _$FCMDataCopyWithImpl<$Res, _$FCMDataImpl>
    implements _$$FCMDataImplCopyWith<$Res> {
  __$$FCMDataImplCopyWithImpl(
      _$FCMDataImpl _value, $Res Function(_$FCMDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? details = freezed,
  }) {
    return _then(_$FCMDataImpl(
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as FCMDetails?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FCMDataImpl implements _FCMData {
  const _$FCMDataImpl({this.details});

  factory _$FCMDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FCMDataImplFromJson(json);

  @override
  final FCMDetails? details;

  @override
  String toString() {
    return 'FCMData(details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FCMDataImpl &&
            (identical(other.details, details) || other.details == details));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FCMDataImplCopyWith<_$FCMDataImpl> get copyWith =>
      __$$FCMDataImplCopyWithImpl<_$FCMDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FCMDataImplToJson(
      this,
    );
  }
}

abstract class _FCMData implements FCMData {
  const factory _FCMData({final FCMDetails? details}) = _$FCMDataImpl;

  factory _FCMData.fromJson(Map<String, dynamic> json) = _$FCMDataImpl.fromJson;

  @override
  FCMDetails? get details;
  @override
  @JsonKey(ignore: true)
  _$$FCMDataImplCopyWith<_$FCMDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FCMDetails _$FCMDetailsFromJson(Map<String, dynamic> json) {
  return _FCMDetails.fromJson(json);
}

/// @nodoc
mixin _$FCMDetails {
  FCMTx? get tx => throw _privateConstructorUsedError;
  @JsonKey(name: 'peg_payout')
  FCMPeg? get pegPayout => throw _privateConstructorUsedError;
  @JsonKey(name: 'peg_detected')
  FCMPeg? get pegDetected => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_cancelled')
  FCMOrderCancelled? get orderCancelled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FCMDetailsCopyWith<FCMDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FCMDetailsCopyWith<$Res> {
  factory $FCMDetailsCopyWith(
          FCMDetails value, $Res Function(FCMDetails) then) =
      _$FCMDetailsCopyWithImpl<$Res, FCMDetails>;
  @useResult
  $Res call(
      {FCMTx? tx,
      @JsonKey(name: 'peg_payout') FCMPeg? pegPayout,
      @JsonKey(name: 'peg_detected') FCMPeg? pegDetected,
      @JsonKey(name: 'order_cancelled') FCMOrderCancelled? orderCancelled});

  $FCMTxCopyWith<$Res>? get tx;
  $FCMPegCopyWith<$Res>? get pegPayout;
  $FCMPegCopyWith<$Res>? get pegDetected;
  $FCMOrderCancelledCopyWith<$Res>? get orderCancelled;
}

/// @nodoc
class _$FCMDetailsCopyWithImpl<$Res, $Val extends FCMDetails>
    implements $FCMDetailsCopyWith<$Res> {
  _$FCMDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tx = freezed,
    Object? pegPayout = freezed,
    Object? pegDetected = freezed,
    Object? orderCancelled = freezed,
  }) {
    return _then(_value.copyWith(
      tx: freezed == tx
          ? _value.tx
          : tx // ignore: cast_nullable_to_non_nullable
              as FCMTx?,
      pegPayout: freezed == pegPayout
          ? _value.pegPayout
          : pegPayout // ignore: cast_nullable_to_non_nullable
              as FCMPeg?,
      pegDetected: freezed == pegDetected
          ? _value.pegDetected
          : pegDetected // ignore: cast_nullable_to_non_nullable
              as FCMPeg?,
      orderCancelled: freezed == orderCancelled
          ? _value.orderCancelled
          : orderCancelled // ignore: cast_nullable_to_non_nullable
              as FCMOrderCancelled?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FCMTxCopyWith<$Res>? get tx {
    if (_value.tx == null) {
      return null;
    }

    return $FCMTxCopyWith<$Res>(_value.tx!, (value) {
      return _then(_value.copyWith(tx: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FCMPegCopyWith<$Res>? get pegPayout {
    if (_value.pegPayout == null) {
      return null;
    }

    return $FCMPegCopyWith<$Res>(_value.pegPayout!, (value) {
      return _then(_value.copyWith(pegPayout: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FCMPegCopyWith<$Res>? get pegDetected {
    if (_value.pegDetected == null) {
      return null;
    }

    return $FCMPegCopyWith<$Res>(_value.pegDetected!, (value) {
      return _then(_value.copyWith(pegDetected: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FCMOrderCancelledCopyWith<$Res>? get orderCancelled {
    if (_value.orderCancelled == null) {
      return null;
    }

    return $FCMOrderCancelledCopyWith<$Res>(_value.orderCancelled!, (value) {
      return _then(_value.copyWith(orderCancelled: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FCMDetailsImplCopyWith<$Res>
    implements $FCMDetailsCopyWith<$Res> {
  factory _$$FCMDetailsImplCopyWith(
          _$FCMDetailsImpl value, $Res Function(_$FCMDetailsImpl) then) =
      __$$FCMDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {FCMTx? tx,
      @JsonKey(name: 'peg_payout') FCMPeg? pegPayout,
      @JsonKey(name: 'peg_detected') FCMPeg? pegDetected,
      @JsonKey(name: 'order_cancelled') FCMOrderCancelled? orderCancelled});

  @override
  $FCMTxCopyWith<$Res>? get tx;
  @override
  $FCMPegCopyWith<$Res>? get pegPayout;
  @override
  $FCMPegCopyWith<$Res>? get pegDetected;
  @override
  $FCMOrderCancelledCopyWith<$Res>? get orderCancelled;
}

/// @nodoc
class __$$FCMDetailsImplCopyWithImpl<$Res>
    extends _$FCMDetailsCopyWithImpl<$Res, _$FCMDetailsImpl>
    implements _$$FCMDetailsImplCopyWith<$Res> {
  __$$FCMDetailsImplCopyWithImpl(
      _$FCMDetailsImpl _value, $Res Function(_$FCMDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tx = freezed,
    Object? pegPayout = freezed,
    Object? pegDetected = freezed,
    Object? orderCancelled = freezed,
  }) {
    return _then(_$FCMDetailsImpl(
      tx: freezed == tx
          ? _value.tx
          : tx // ignore: cast_nullable_to_non_nullable
              as FCMTx?,
      pegPayout: freezed == pegPayout
          ? _value.pegPayout
          : pegPayout // ignore: cast_nullable_to_non_nullable
              as FCMPeg?,
      pegDetected: freezed == pegDetected
          ? _value.pegDetected
          : pegDetected // ignore: cast_nullable_to_non_nullable
              as FCMPeg?,
      orderCancelled: freezed == orderCancelled
          ? _value.orderCancelled
          : orderCancelled // ignore: cast_nullable_to_non_nullable
              as FCMOrderCancelled?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FCMDetailsImpl implements _FCMDetails {
  const _$FCMDetailsImpl(
      {this.tx,
      @JsonKey(name: 'peg_payout') this.pegPayout,
      @JsonKey(name: 'peg_detected') this.pegDetected,
      @JsonKey(name: 'order_cancelled') this.orderCancelled});

  factory _$FCMDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FCMDetailsImplFromJson(json);

  @override
  final FCMTx? tx;
  @override
  @JsonKey(name: 'peg_payout')
  final FCMPeg? pegPayout;
  @override
  @JsonKey(name: 'peg_detected')
  final FCMPeg? pegDetected;
  @override
  @JsonKey(name: 'order_cancelled')
  final FCMOrderCancelled? orderCancelled;

  @override
  String toString() {
    return 'FCMDetails(tx: $tx, pegPayout: $pegPayout, pegDetected: $pegDetected, orderCancelled: $orderCancelled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FCMDetailsImpl &&
            (identical(other.tx, tx) || other.tx == tx) &&
            (identical(other.pegPayout, pegPayout) ||
                other.pegPayout == pegPayout) &&
            (identical(other.pegDetected, pegDetected) ||
                other.pegDetected == pegDetected) &&
            (identical(other.orderCancelled, orderCancelled) ||
                other.orderCancelled == orderCancelled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tx, pegPayout, pegDetected, orderCancelled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FCMDetailsImplCopyWith<_$FCMDetailsImpl> get copyWith =>
      __$$FCMDetailsImplCopyWithImpl<_$FCMDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FCMDetailsImplToJson(
      this,
    );
  }
}

abstract class _FCMDetails implements FCMDetails {
  const factory _FCMDetails(
      {final FCMTx? tx,
      @JsonKey(name: 'peg_payout') final FCMPeg? pegPayout,
      @JsonKey(name: 'peg_detected') final FCMPeg? pegDetected,
      @JsonKey(name: 'order_cancelled')
      final FCMOrderCancelled? orderCancelled}) = _$FCMDetailsImpl;

  factory _FCMDetails.fromJson(Map<String, dynamic> json) =
      _$FCMDetailsImpl.fromJson;

  @override
  FCMTx? get tx;
  @override
  @JsonKey(name: 'peg_payout')
  FCMPeg? get pegPayout;
  @override
  @JsonKey(name: 'peg_detected')
  FCMPeg? get pegDetected;
  @override
  @JsonKey(name: 'order_cancelled')
  FCMOrderCancelled? get orderCancelled;
  @override
  @JsonKey(ignore: true)
  _$$FCMDetailsImplCopyWith<_$FCMDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FCMTx _$FCMTxFromJson(Map<String, dynamic> json) {
  return _FCMTx.fromJson(json);
}

/// @nodoc
mixin _$FCMTx {
  @JsonKey(name: 'tx_type')
  FCMTxType? get txType => throw _privateConstructorUsedError;
  @JsonKey(name: 'txid')
  String? get txId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FCMTxCopyWith<FCMTx> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FCMTxCopyWith<$Res> {
  factory $FCMTxCopyWith(FCMTx value, $Res Function(FCMTx) then) =
      _$FCMTxCopyWithImpl<$Res, FCMTx>;
  @useResult
  $Res call(
      {@JsonKey(name: 'tx_type') FCMTxType? txType,
      @JsonKey(name: 'txid') String? txId});
}

/// @nodoc
class _$FCMTxCopyWithImpl<$Res, $Val extends FCMTx>
    implements $FCMTxCopyWith<$Res> {
  _$FCMTxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txType = freezed,
    Object? txId = freezed,
  }) {
    return _then(_value.copyWith(
      txType: freezed == txType
          ? _value.txType
          : txType // ignore: cast_nullable_to_non_nullable
              as FCMTxType?,
      txId: freezed == txId
          ? _value.txId
          : txId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FCMTxImplCopyWith<$Res> implements $FCMTxCopyWith<$Res> {
  factory _$$FCMTxImplCopyWith(
          _$FCMTxImpl value, $Res Function(_$FCMTxImpl) then) =
      __$$FCMTxImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'tx_type') FCMTxType? txType,
      @JsonKey(name: 'txid') String? txId});
}

/// @nodoc
class __$$FCMTxImplCopyWithImpl<$Res>
    extends _$FCMTxCopyWithImpl<$Res, _$FCMTxImpl>
    implements _$$FCMTxImplCopyWith<$Res> {
  __$$FCMTxImplCopyWithImpl(
      _$FCMTxImpl _value, $Res Function(_$FCMTxImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txType = freezed,
    Object? txId = freezed,
  }) {
    return _then(_$FCMTxImpl(
      txType: freezed == txType
          ? _value.txType
          : txType // ignore: cast_nullable_to_non_nullable
              as FCMTxType?,
      txId: freezed == txId
          ? _value.txId
          : txId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FCMTxImpl implements _FCMTx {
  const _$FCMTxImpl(
      {@JsonKey(name: 'tx_type') this.txType,
      @JsonKey(name: 'txid') this.txId});

  factory _$FCMTxImpl.fromJson(Map<String, dynamic> json) =>
      _$$FCMTxImplFromJson(json);

  @override
  @JsonKey(name: 'tx_type')
  final FCMTxType? txType;
  @override
  @JsonKey(name: 'txid')
  final String? txId;

  @override
  String toString() {
    return 'FCMTx(txType: $txType, txId: $txId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FCMTxImpl &&
            (identical(other.txType, txType) || other.txType == txType) &&
            (identical(other.txId, txId) || other.txId == txId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, txType, txId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FCMTxImplCopyWith<_$FCMTxImpl> get copyWith =>
      __$$FCMTxImplCopyWithImpl<_$FCMTxImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FCMTxImplToJson(
      this,
    );
  }
}

abstract class _FCMTx implements FCMTx {
  const factory _FCMTx(
      {@JsonKey(name: 'tx_type') final FCMTxType? txType,
      @JsonKey(name: 'txid') final String? txId}) = _$FCMTxImpl;

  factory _FCMTx.fromJson(Map<String, dynamic> json) = _$FCMTxImpl.fromJson;

  @override
  @JsonKey(name: 'tx_type')
  FCMTxType? get txType;
  @override
  @JsonKey(name: 'txid')
  String? get txId;
  @override
  @JsonKey(ignore: true)
  _$$FCMTxImplCopyWith<_$FCMTxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FCMPeg _$FCMPegFromJson(Map<String, dynamic> json) {
  return _FCMPeg.fromJson(json);
}

/// @nodoc
mixin _$FCMPeg {
  @JsonKey(name: 'order_id')
  String? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'peg_in')
  bool? get pegIn => throw _privateConstructorUsedError;
  @JsonKey(name: 'tx_hash')
  String? get txHash => throw _privateConstructorUsedError;
  int? get vout => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  int? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'payout_txid')
  String? get payoutTxId => throw _privateConstructorUsedError;
  int? get payout => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FCMPegCopyWith<FCMPeg> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FCMPegCopyWith<$Res> {
  factory $FCMPegCopyWith(FCMPeg value, $Res Function(FCMPeg) then) =
      _$FCMPegCopyWithImpl<$Res, FCMPeg>;
  @useResult
  $Res call(
      {@JsonKey(name: 'order_id') String? orderId,
      @JsonKey(name: 'peg_in') bool? pegIn,
      @JsonKey(name: 'tx_hash') String? txHash,
      int? vout,
      @JsonKey(name: 'created_at') int? createdAt,
      @JsonKey(name: 'payout_txid') String? payoutTxId,
      int? payout});
}

/// @nodoc
class _$FCMPegCopyWithImpl<$Res, $Val extends FCMPeg>
    implements $FCMPegCopyWith<$Res> {
  _$FCMPegCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = freezed,
    Object? pegIn = freezed,
    Object? txHash = freezed,
    Object? vout = freezed,
    Object? createdAt = freezed,
    Object? payoutTxId = freezed,
    Object? payout = freezed,
  }) {
    return _then(_value.copyWith(
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      pegIn: freezed == pegIn
          ? _value.pegIn
          : pegIn // ignore: cast_nullable_to_non_nullable
              as bool?,
      txHash: freezed == txHash
          ? _value.txHash
          : txHash // ignore: cast_nullable_to_non_nullable
              as String?,
      vout: freezed == vout
          ? _value.vout
          : vout // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
      payoutTxId: freezed == payoutTxId
          ? _value.payoutTxId
          : payoutTxId // ignore: cast_nullable_to_non_nullable
              as String?,
      payout: freezed == payout
          ? _value.payout
          : payout // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FCMPegImplCopyWith<$Res> implements $FCMPegCopyWith<$Res> {
  factory _$$FCMPegImplCopyWith(
          _$FCMPegImpl value, $Res Function(_$FCMPegImpl) then) =
      __$$FCMPegImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'order_id') String? orderId,
      @JsonKey(name: 'peg_in') bool? pegIn,
      @JsonKey(name: 'tx_hash') String? txHash,
      int? vout,
      @JsonKey(name: 'created_at') int? createdAt,
      @JsonKey(name: 'payout_txid') String? payoutTxId,
      int? payout});
}

/// @nodoc
class __$$FCMPegImplCopyWithImpl<$Res>
    extends _$FCMPegCopyWithImpl<$Res, _$FCMPegImpl>
    implements _$$FCMPegImplCopyWith<$Res> {
  __$$FCMPegImplCopyWithImpl(
      _$FCMPegImpl _value, $Res Function(_$FCMPegImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = freezed,
    Object? pegIn = freezed,
    Object? txHash = freezed,
    Object? vout = freezed,
    Object? createdAt = freezed,
    Object? payoutTxId = freezed,
    Object? payout = freezed,
  }) {
    return _then(_$FCMPegImpl(
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      pegIn: freezed == pegIn
          ? _value.pegIn
          : pegIn // ignore: cast_nullable_to_non_nullable
              as bool?,
      txHash: freezed == txHash
          ? _value.txHash
          : txHash // ignore: cast_nullable_to_non_nullable
              as String?,
      vout: freezed == vout
          ? _value.vout
          : vout // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
      payoutTxId: freezed == payoutTxId
          ? _value.payoutTxId
          : payoutTxId // ignore: cast_nullable_to_non_nullable
              as String?,
      payout: freezed == payout
          ? _value.payout
          : payout // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FCMPegImpl implements _FCMPeg {
  const _$FCMPegImpl(
      {@JsonKey(name: 'order_id') this.orderId,
      @JsonKey(name: 'peg_in') this.pegIn,
      @JsonKey(name: 'tx_hash') this.txHash,
      this.vout,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'payout_txid') this.payoutTxId,
      this.payout});

  factory _$FCMPegImpl.fromJson(Map<String, dynamic> json) =>
      _$$FCMPegImplFromJson(json);

  @override
  @JsonKey(name: 'order_id')
  final String? orderId;
  @override
  @JsonKey(name: 'peg_in')
  final bool? pegIn;
  @override
  @JsonKey(name: 'tx_hash')
  final String? txHash;
  @override
  final int? vout;
  @override
  @JsonKey(name: 'created_at')
  final int? createdAt;
  @override
  @JsonKey(name: 'payout_txid')
  final String? payoutTxId;
  @override
  final int? payout;

  @override
  String toString() {
    return 'FCMPeg(orderId: $orderId, pegIn: $pegIn, txHash: $txHash, vout: $vout, createdAt: $createdAt, payoutTxId: $payoutTxId, payout: $payout)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FCMPegImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.pegIn, pegIn) || other.pegIn == pegIn) &&
            (identical(other.txHash, txHash) || other.txHash == txHash) &&
            (identical(other.vout, vout) || other.vout == vout) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.payoutTxId, payoutTxId) ||
                other.payoutTxId == payoutTxId) &&
            (identical(other.payout, payout) || other.payout == payout));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, orderId, pegIn, txHash, vout, createdAt, payoutTxId, payout);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FCMPegImplCopyWith<_$FCMPegImpl> get copyWith =>
      __$$FCMPegImplCopyWithImpl<_$FCMPegImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FCMPegImplToJson(
      this,
    );
  }
}

abstract class _FCMPeg implements FCMPeg {
  const factory _FCMPeg(
      {@JsonKey(name: 'order_id') final String? orderId,
      @JsonKey(name: 'peg_in') final bool? pegIn,
      @JsonKey(name: 'tx_hash') final String? txHash,
      final int? vout,
      @JsonKey(name: 'created_at') final int? createdAt,
      @JsonKey(name: 'payout_txid') final String? payoutTxId,
      final int? payout}) = _$FCMPegImpl;

  factory _FCMPeg.fromJson(Map<String, dynamic> json) = _$FCMPegImpl.fromJson;

  @override
  @JsonKey(name: 'order_id')
  String? get orderId;
  @override
  @JsonKey(name: 'peg_in')
  bool? get pegIn;
  @override
  @JsonKey(name: 'tx_hash')
  String? get txHash;
  @override
  int? get vout;
  @override
  @JsonKey(name: 'created_at')
  int? get createdAt;
  @override
  @JsonKey(name: 'payout_txid')
  String? get payoutTxId;
  @override
  int? get payout;
  @override
  @JsonKey(ignore: true)
  _$$FCMPegImplCopyWith<_$FCMPegImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FCMOrderCancelled _$FCMOrderCancelledFromJson(Map<String, dynamic> json) {
  return _FCMOrderCancelled.fromJson(json);
}

/// @nodoc
mixin _$FCMOrderCancelled {
  @JsonKey(name: 'order_id')
  String? get orderId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FCMOrderCancelledCopyWith<FCMOrderCancelled> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FCMOrderCancelledCopyWith<$Res> {
  factory $FCMOrderCancelledCopyWith(
          FCMOrderCancelled value, $Res Function(FCMOrderCancelled) then) =
      _$FCMOrderCancelledCopyWithImpl<$Res, FCMOrderCancelled>;
  @useResult
  $Res call({@JsonKey(name: 'order_id') String? orderId});
}

/// @nodoc
class _$FCMOrderCancelledCopyWithImpl<$Res, $Val extends FCMOrderCancelled>
    implements $FCMOrderCancelledCopyWith<$Res> {
  _$FCMOrderCancelledCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = freezed,
  }) {
    return _then(_value.copyWith(
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FCMOrderCancelledImplCopyWith<$Res>
    implements $FCMOrderCancelledCopyWith<$Res> {
  factory _$$FCMOrderCancelledImplCopyWith(_$FCMOrderCancelledImpl value,
          $Res Function(_$FCMOrderCancelledImpl) then) =
      __$$FCMOrderCancelledImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'order_id') String? orderId});
}

/// @nodoc
class __$$FCMOrderCancelledImplCopyWithImpl<$Res>
    extends _$FCMOrderCancelledCopyWithImpl<$Res, _$FCMOrderCancelledImpl>
    implements _$$FCMOrderCancelledImplCopyWith<$Res> {
  __$$FCMOrderCancelledImplCopyWithImpl(_$FCMOrderCancelledImpl _value,
      $Res Function(_$FCMOrderCancelledImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = freezed,
  }) {
    return _then(_$FCMOrderCancelledImpl(
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FCMOrderCancelledImpl implements _FCMOrderCancelled {
  const _$FCMOrderCancelledImpl({@JsonKey(name: 'order_id') this.orderId});

  factory _$FCMOrderCancelledImpl.fromJson(Map<String, dynamic> json) =>
      _$$FCMOrderCancelledImplFromJson(json);

  @override
  @JsonKey(name: 'order_id')
  final String? orderId;

  @override
  String toString() {
    return 'FCMOrderCancelled(orderId: $orderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FCMOrderCancelledImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, orderId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FCMOrderCancelledImplCopyWith<_$FCMOrderCancelledImpl> get copyWith =>
      __$$FCMOrderCancelledImplCopyWithImpl<_$FCMOrderCancelledImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FCMOrderCancelledImplToJson(
      this,
    );
  }
}

abstract class _FCMOrderCancelled implements FCMOrderCancelled {
  const factory _FCMOrderCancelled(
          {@JsonKey(name: 'order_id') final String? orderId}) =
      _$FCMOrderCancelledImpl;

  factory _FCMOrderCancelled.fromJson(Map<String, dynamic> json) =
      _$FCMOrderCancelledImpl.fromJson;

  @override
  @JsonKey(name: 'order_id')
  String? get orderId;
  @override
  @JsonKey(ignore: true)
  _$$FCMOrderCancelledImplCopyWith<_$FCMOrderCancelledImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FCMMessage _$FCMMessageFromJson(Map<String, dynamic> json) {
  return _FCMMessage.fromJson(json);
}

/// @nodoc
mixin _$FCMMessage {
  FCMNotification? get notification => throw _privateConstructorUsedError;
  FCMData? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FCMMessageCopyWith<FCMMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FCMMessageCopyWith<$Res> {
  factory $FCMMessageCopyWith(
          FCMMessage value, $Res Function(FCMMessage) then) =
      _$FCMMessageCopyWithImpl<$Res, FCMMessage>;
  @useResult
  $Res call({FCMNotification? notification, FCMData? data});

  $FCMNotificationCopyWith<$Res>? get notification;
  $FCMDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$FCMMessageCopyWithImpl<$Res, $Val extends FCMMessage>
    implements $FCMMessageCopyWith<$Res> {
  _$FCMMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notification = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      notification: freezed == notification
          ? _value.notification
          : notification // ignore: cast_nullable_to_non_nullable
              as FCMNotification?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as FCMData?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FCMNotificationCopyWith<$Res>? get notification {
    if (_value.notification == null) {
      return null;
    }

    return $FCMNotificationCopyWith<$Res>(_value.notification!, (value) {
      return _then(_value.copyWith(notification: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FCMDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $FCMDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FCMMessageImplCopyWith<$Res>
    implements $FCMMessageCopyWith<$Res> {
  factory _$$FCMMessageImplCopyWith(
          _$FCMMessageImpl value, $Res Function(_$FCMMessageImpl) then) =
      __$$FCMMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FCMNotification? notification, FCMData? data});

  @override
  $FCMNotificationCopyWith<$Res>? get notification;
  @override
  $FCMDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$FCMMessageImplCopyWithImpl<$Res>
    extends _$FCMMessageCopyWithImpl<$Res, _$FCMMessageImpl>
    implements _$$FCMMessageImplCopyWith<$Res> {
  __$$FCMMessageImplCopyWithImpl(
      _$FCMMessageImpl _value, $Res Function(_$FCMMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notification = freezed,
    Object? data = freezed,
  }) {
    return _then(_$FCMMessageImpl(
      notification: freezed == notification
          ? _value.notification
          : notification // ignore: cast_nullable_to_non_nullable
              as FCMNotification?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as FCMData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FCMMessageImpl implements _FCMMessage {
  const _$FCMMessageImpl({this.notification, this.data});

  factory _$FCMMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$FCMMessageImplFromJson(json);

  @override
  final FCMNotification? notification;
  @override
  final FCMData? data;

  @override
  String toString() {
    return 'FCMMessage(notification: $notification, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FCMMessageImpl &&
            (identical(other.notification, notification) ||
                other.notification == notification) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, notification, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FCMMessageImplCopyWith<_$FCMMessageImpl> get copyWith =>
      __$$FCMMessageImplCopyWithImpl<_$FCMMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FCMMessageImplToJson(
      this,
    );
  }
}

abstract class _FCMMessage implements FCMMessage {
  const factory _FCMMessage(
      {final FCMNotification? notification,
      final FCMData? data}) = _$FCMMessageImpl;

  factory _FCMMessage.fromJson(Map<String, dynamic> json) =
      _$FCMMessageImpl.fromJson;

  @override
  FCMNotification? get notification;
  @override
  FCMData? get data;
  @override
  @JsonKey(ignore: true)
  _$$FCMMessageImplCopyWith<_$FCMMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FCMRemoteMessage _$FCMRemoteMessageFromJson(Map<String, dynamic> json) {
  return _FCMRemoteMessage.fromJson(json);
}

/// @nodoc
mixin _$FCMRemoteMessage {
  dynamic get details => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FCMRemoteMessageCopyWith<FCMRemoteMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FCMRemoteMessageCopyWith<$Res> {
  factory $FCMRemoteMessageCopyWith(
          FCMRemoteMessage value, $Res Function(FCMRemoteMessage) then) =
      _$FCMRemoteMessageCopyWithImpl<$Res, FCMRemoteMessage>;
  @useResult
  $Res call(
      {dynamic details,
      String? body,
      String? title,
      Map<String, dynamic>? data});
}

/// @nodoc
class _$FCMRemoteMessageCopyWithImpl<$Res, $Val extends FCMRemoteMessage>
    implements $FCMRemoteMessageCopyWith<$Res> {
  _$FCMRemoteMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? details = freezed,
    Object? body = freezed,
    Object? title = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as dynamic,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FCMRemoteMessageImplCopyWith<$Res>
    implements $FCMRemoteMessageCopyWith<$Res> {
  factory _$$FCMRemoteMessageImplCopyWith(_$FCMRemoteMessageImpl value,
          $Res Function(_$FCMRemoteMessageImpl) then) =
      __$$FCMRemoteMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {dynamic details,
      String? body,
      String? title,
      Map<String, dynamic>? data});
}

/// @nodoc
class __$$FCMRemoteMessageImplCopyWithImpl<$Res>
    extends _$FCMRemoteMessageCopyWithImpl<$Res, _$FCMRemoteMessageImpl>
    implements _$$FCMRemoteMessageImplCopyWith<$Res> {
  __$$FCMRemoteMessageImplCopyWithImpl(_$FCMRemoteMessageImpl _value,
      $Res Function(_$FCMRemoteMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? details = freezed,
    Object? body = freezed,
    Object? title = freezed,
    Object? data = freezed,
  }) {
    return _then(_$FCMRemoteMessageImpl(
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as dynamic,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FCMRemoteMessageImpl implements _FCMRemoteMessage {
  const _$FCMRemoteMessageImpl(
      {this.details, this.body, this.title, final Map<String, dynamic>? data})
      : _data = data;

  factory _$FCMRemoteMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$FCMRemoteMessageImplFromJson(json);

  @override
  final dynamic details;
  @override
  final String? body;
  @override
  final String? title;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'FCMRemoteMessage(details: $details, body: $body, title: $title, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FCMRemoteMessageImpl &&
            const DeepCollectionEquality().equals(other.details, details) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(details),
      body,
      title,
      const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FCMRemoteMessageImplCopyWith<_$FCMRemoteMessageImpl> get copyWith =>
      __$$FCMRemoteMessageImplCopyWithImpl<_$FCMRemoteMessageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FCMRemoteMessageImplToJson(
      this,
    );
  }
}

abstract class _FCMRemoteMessage implements FCMRemoteMessage {
  const factory _FCMRemoteMessage(
      {final dynamic details,
      final String? body,
      final String? title,
      final Map<String, dynamic>? data}) = _$FCMRemoteMessageImpl;

  factory _FCMRemoteMessage.fromJson(Map<String, dynamic> json) =
      _$FCMRemoteMessageImpl.fromJson;

  @override
  dynamic get details;
  @override
  String? get body;
  @override
  String? get title;
  @override
  Map<String, dynamic>? get data;
  @override
  @JsonKey(ignore: true)
  _$$FCMRemoteMessageImplCopyWith<_$FCMRemoteMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
