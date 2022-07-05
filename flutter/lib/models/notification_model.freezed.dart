// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
      _$FCMPayloadCopyWithImpl<$Res>;
  $Res call({FCMPayloadType? type, String? txid});
}

/// @nodoc
class _$FCMPayloadCopyWithImpl<$Res> implements $FCMPayloadCopyWith<$Res> {
  _$FCMPayloadCopyWithImpl(this._value, this._then);

  final FCMPayload _value;
  // ignore: unused_field
  final $Res Function(FCMPayload) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? txid = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FCMPayloadType?,
      txid: txid == freezed
          ? _value.txid
          : txid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_FCMPayloadCopyWith<$Res>
    implements $FCMPayloadCopyWith<$Res> {
  factory _$$_FCMPayloadCopyWith(
          _$_FCMPayload value, $Res Function(_$_FCMPayload) then) =
      __$$_FCMPayloadCopyWithImpl<$Res>;
  @override
  $Res call({FCMPayloadType? type, String? txid});
}

/// @nodoc
class __$$_FCMPayloadCopyWithImpl<$Res> extends _$FCMPayloadCopyWithImpl<$Res>
    implements _$$_FCMPayloadCopyWith<$Res> {
  __$$_FCMPayloadCopyWithImpl(
      _$_FCMPayload _value, $Res Function(_$_FCMPayload) _then)
      : super(_value, (v) => _then(v as _$_FCMPayload));

  @override
  _$_FCMPayload get _value => super._value as _$_FCMPayload;

  @override
  $Res call({
    Object? type = freezed,
    Object? txid = freezed,
  }) {
    return _then(_$_FCMPayload(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FCMPayloadType?,
      txid: txid == freezed
          ? _value.txid
          : txid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FCMPayload extends _FCMPayload {
  const _$_FCMPayload({this.type, this.txid}) : super._();

  factory _$_FCMPayload.fromJson(Map<String, dynamic> json) =>
      _$$_FCMPayloadFromJson(json);

  @override
  final FCMPayloadType? type;
  @override
  final String? txid;

  @override
  String toString() {
    return 'FCMPayload(type: $type, txid: $txid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FCMPayload &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.txid, txid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(txid));

  @JsonKey(ignore: true)
  @override
  _$$_FCMPayloadCopyWith<_$_FCMPayload> get copyWith =>
      __$$_FCMPayloadCopyWithImpl<_$_FCMPayload>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FCMPayloadToJson(this);
  }
}

abstract class _FCMPayload extends FCMPayload {
  const factory _FCMPayload({final FCMPayloadType? type, final String? txid}) =
      _$_FCMPayload;
  const _FCMPayload._() : super._();

  factory _FCMPayload.fromJson(Map<String, dynamic> json) =
      _$_FCMPayload.fromJson;

  @override
  FCMPayloadType? get type => throw _privateConstructorUsedError;
  @override
  String? get txid => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_FCMPayloadCopyWith<_$_FCMPayload> get copyWith =>
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
      _$FCMNotificationCopyWithImpl<$Res>;
  $Res call({String? title, String? body});
}

/// @nodoc
class _$FCMNotificationCopyWithImpl<$Res>
    implements $FCMNotificationCopyWith<$Res> {
  _$FCMNotificationCopyWithImpl(this._value, this._then);

  final FCMNotification _value;
  // ignore: unused_field
  final $Res Function(FCMNotification) _then;

  @override
  $Res call({
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(_value.copyWith(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_FCMNotificationCopyWith<$Res>
    implements $FCMNotificationCopyWith<$Res> {
  factory _$$_FCMNotificationCopyWith(
          _$_FCMNotification value, $Res Function(_$_FCMNotification) then) =
      __$$_FCMNotificationCopyWithImpl<$Res>;
  @override
  $Res call({String? title, String? body});
}

/// @nodoc
class __$$_FCMNotificationCopyWithImpl<$Res>
    extends _$FCMNotificationCopyWithImpl<$Res>
    implements _$$_FCMNotificationCopyWith<$Res> {
  __$$_FCMNotificationCopyWithImpl(
      _$_FCMNotification _value, $Res Function(_$_FCMNotification) _then)
      : super(_value, (v) => _then(v as _$_FCMNotification));

  @override
  _$_FCMNotification get _value => super._value as _$_FCMNotification;

  @override
  $Res call({
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(_$_FCMNotification(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: body == freezed
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FCMNotification implements _FCMNotification {
  const _$_FCMNotification({this.title, this.body});

  factory _$_FCMNotification.fromJson(Map<String, dynamic> json) =>
      _$$_FCMNotificationFromJson(json);

  @override
  final String? title;
  @override
  final String? body;

  @override
  String toString() {
    return 'FCMNotification(title: $title, body: $body)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FCMNotification &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.body, body));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(body));

  @JsonKey(ignore: true)
  @override
  _$$_FCMNotificationCopyWith<_$_FCMNotification> get copyWith =>
      __$$_FCMNotificationCopyWithImpl<_$_FCMNotification>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FCMNotificationToJson(this);
  }
}

abstract class _FCMNotification implements FCMNotification {
  const factory _FCMNotification({final String? title, final String? body}) =
      _$_FCMNotification;

  factory _FCMNotification.fromJson(Map<String, dynamic> json) =
      _$_FCMNotification.fromJson;

  @override
  String? get title => throw _privateConstructorUsedError;
  @override
  String? get body => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_FCMNotificationCopyWith<_$_FCMNotification> get copyWith =>
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
      _$FCMDataCopyWithImpl<$Res>;
  $Res call({FCMDetails? details});

  $FCMDetailsCopyWith<$Res>? get details;
}

/// @nodoc
class _$FCMDataCopyWithImpl<$Res> implements $FCMDataCopyWith<$Res> {
  _$FCMDataCopyWithImpl(this._value, this._then);

  final FCMData _value;
  // ignore: unused_field
  final $Res Function(FCMData) _then;

  @override
  $Res call({
    Object? details = freezed,
  }) {
    return _then(_value.copyWith(
      details: details == freezed
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as FCMDetails?,
    ));
  }

  @override
  $FCMDetailsCopyWith<$Res>? get details {
    if (_value.details == null) {
      return null;
    }

    return $FCMDetailsCopyWith<$Res>(_value.details!, (value) {
      return _then(_value.copyWith(details: value));
    });
  }
}

/// @nodoc
abstract class _$$_FCMDataCopyWith<$Res> implements $FCMDataCopyWith<$Res> {
  factory _$$_FCMDataCopyWith(
          _$_FCMData value, $Res Function(_$_FCMData) then) =
      __$$_FCMDataCopyWithImpl<$Res>;
  @override
  $Res call({FCMDetails? details});

  @override
  $FCMDetailsCopyWith<$Res>? get details;
}

/// @nodoc
class __$$_FCMDataCopyWithImpl<$Res> extends _$FCMDataCopyWithImpl<$Res>
    implements _$$_FCMDataCopyWith<$Res> {
  __$$_FCMDataCopyWithImpl(_$_FCMData _value, $Res Function(_$_FCMData) _then)
      : super(_value, (v) => _then(v as _$_FCMData));

  @override
  _$_FCMData get _value => super._value as _$_FCMData;

  @override
  $Res call({
    Object? details = freezed,
  }) {
    return _then(_$_FCMData(
      details: details == freezed
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as FCMDetails?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FCMData implements _FCMData {
  const _$_FCMData({this.details});

  factory _$_FCMData.fromJson(Map<String, dynamic> json) =>
      _$$_FCMDataFromJson(json);

  @override
  final FCMDetails? details;

  @override
  String toString() {
    return 'FCMData(details: $details)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FCMData &&
            const DeepCollectionEquality().equals(other.details, details));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(details));

  @JsonKey(ignore: true)
  @override
  _$$_FCMDataCopyWith<_$_FCMData> get copyWith =>
      __$$_FCMDataCopyWithImpl<_$_FCMData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FCMDataToJson(this);
  }
}

abstract class _FCMData implements FCMData {
  const factory _FCMData({final FCMDetails? details}) = _$_FCMData;

  factory _FCMData.fromJson(Map<String, dynamic> json) = _$_FCMData.fromJson;

  @override
  FCMDetails? get details => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_FCMDataCopyWith<_$_FCMData> get copyWith =>
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
      _$FCMDetailsCopyWithImpl<$Res>;
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
class _$FCMDetailsCopyWithImpl<$Res> implements $FCMDetailsCopyWith<$Res> {
  _$FCMDetailsCopyWithImpl(this._value, this._then);

  final FCMDetails _value;
  // ignore: unused_field
  final $Res Function(FCMDetails) _then;

  @override
  $Res call({
    Object? tx = freezed,
    Object? pegPayout = freezed,
    Object? pegDetected = freezed,
    Object? orderCancelled = freezed,
  }) {
    return _then(_value.copyWith(
      tx: tx == freezed
          ? _value.tx
          : tx // ignore: cast_nullable_to_non_nullable
              as FCMTx?,
      pegPayout: pegPayout == freezed
          ? _value.pegPayout
          : pegPayout // ignore: cast_nullable_to_non_nullable
              as FCMPeg?,
      pegDetected: pegDetected == freezed
          ? _value.pegDetected
          : pegDetected // ignore: cast_nullable_to_non_nullable
              as FCMPeg?,
      orderCancelled: orderCancelled == freezed
          ? _value.orderCancelled
          : orderCancelled // ignore: cast_nullable_to_non_nullable
              as FCMOrderCancelled?,
    ));
  }

  @override
  $FCMTxCopyWith<$Res>? get tx {
    if (_value.tx == null) {
      return null;
    }

    return $FCMTxCopyWith<$Res>(_value.tx!, (value) {
      return _then(_value.copyWith(tx: value));
    });
  }

  @override
  $FCMPegCopyWith<$Res>? get pegPayout {
    if (_value.pegPayout == null) {
      return null;
    }

    return $FCMPegCopyWith<$Res>(_value.pegPayout!, (value) {
      return _then(_value.copyWith(pegPayout: value));
    });
  }

  @override
  $FCMPegCopyWith<$Res>? get pegDetected {
    if (_value.pegDetected == null) {
      return null;
    }

    return $FCMPegCopyWith<$Res>(_value.pegDetected!, (value) {
      return _then(_value.copyWith(pegDetected: value));
    });
  }

  @override
  $FCMOrderCancelledCopyWith<$Res>? get orderCancelled {
    if (_value.orderCancelled == null) {
      return null;
    }

    return $FCMOrderCancelledCopyWith<$Res>(_value.orderCancelled!, (value) {
      return _then(_value.copyWith(orderCancelled: value));
    });
  }
}

/// @nodoc
abstract class _$$_FCMDetailsCopyWith<$Res>
    implements $FCMDetailsCopyWith<$Res> {
  factory _$$_FCMDetailsCopyWith(
          _$_FCMDetails value, $Res Function(_$_FCMDetails) then) =
      __$$_FCMDetailsCopyWithImpl<$Res>;
  @override
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
class __$$_FCMDetailsCopyWithImpl<$Res> extends _$FCMDetailsCopyWithImpl<$Res>
    implements _$$_FCMDetailsCopyWith<$Res> {
  __$$_FCMDetailsCopyWithImpl(
      _$_FCMDetails _value, $Res Function(_$_FCMDetails) _then)
      : super(_value, (v) => _then(v as _$_FCMDetails));

  @override
  _$_FCMDetails get _value => super._value as _$_FCMDetails;

  @override
  $Res call({
    Object? tx = freezed,
    Object? pegPayout = freezed,
    Object? pegDetected = freezed,
    Object? orderCancelled = freezed,
  }) {
    return _then(_$_FCMDetails(
      tx: tx == freezed
          ? _value.tx
          : tx // ignore: cast_nullable_to_non_nullable
              as FCMTx?,
      pegPayout: pegPayout == freezed
          ? _value.pegPayout
          : pegPayout // ignore: cast_nullable_to_non_nullable
              as FCMPeg?,
      pegDetected: pegDetected == freezed
          ? _value.pegDetected
          : pegDetected // ignore: cast_nullable_to_non_nullable
              as FCMPeg?,
      orderCancelled: orderCancelled == freezed
          ? _value.orderCancelled
          : orderCancelled // ignore: cast_nullable_to_non_nullable
              as FCMOrderCancelled?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FCMDetails implements _FCMDetails {
  const _$_FCMDetails(
      {this.tx,
      @JsonKey(name: 'peg_payout') this.pegPayout,
      @JsonKey(name: 'peg_detected') this.pegDetected,
      @JsonKey(name: 'order_cancelled') this.orderCancelled});

  factory _$_FCMDetails.fromJson(Map<String, dynamic> json) =>
      _$$_FCMDetailsFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FCMDetails &&
            const DeepCollectionEquality().equals(other.tx, tx) &&
            const DeepCollectionEquality().equals(other.pegPayout, pegPayout) &&
            const DeepCollectionEquality()
                .equals(other.pegDetected, pegDetected) &&
            const DeepCollectionEquality()
                .equals(other.orderCancelled, orderCancelled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(tx),
      const DeepCollectionEquality().hash(pegPayout),
      const DeepCollectionEquality().hash(pegDetected),
      const DeepCollectionEquality().hash(orderCancelled));

  @JsonKey(ignore: true)
  @override
  _$$_FCMDetailsCopyWith<_$_FCMDetails> get copyWith =>
      __$$_FCMDetailsCopyWithImpl<_$_FCMDetails>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FCMDetailsToJson(this);
  }
}

abstract class _FCMDetails implements FCMDetails {
  const factory _FCMDetails(
      {final FCMTx? tx,
      @JsonKey(name: 'peg_payout')
          final FCMPeg? pegPayout,
      @JsonKey(name: 'peg_detected')
          final FCMPeg? pegDetected,
      @JsonKey(name: 'order_cancelled')
          final FCMOrderCancelled? orderCancelled}) = _$_FCMDetails;

  factory _FCMDetails.fromJson(Map<String, dynamic> json) =
      _$_FCMDetails.fromJson;

  @override
  FCMTx? get tx => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'peg_payout')
  FCMPeg? get pegPayout => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'peg_detected')
  FCMPeg? get pegDetected => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'order_cancelled')
  FCMOrderCancelled? get orderCancelled => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_FCMDetailsCopyWith<_$_FCMDetails> get copyWith =>
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
      _$FCMTxCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'tx_type') FCMTxType? txType,
      @JsonKey(name: 'txid') String? txId});
}

/// @nodoc
class _$FCMTxCopyWithImpl<$Res> implements $FCMTxCopyWith<$Res> {
  _$FCMTxCopyWithImpl(this._value, this._then);

  final FCMTx _value;
  // ignore: unused_field
  final $Res Function(FCMTx) _then;

  @override
  $Res call({
    Object? txType = freezed,
    Object? txId = freezed,
  }) {
    return _then(_value.copyWith(
      txType: txType == freezed
          ? _value.txType
          : txType // ignore: cast_nullable_to_non_nullable
              as FCMTxType?,
      txId: txId == freezed
          ? _value.txId
          : txId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_FCMTxCopyWith<$Res> implements $FCMTxCopyWith<$Res> {
  factory _$$_FCMTxCopyWith(_$_FCMTx value, $Res Function(_$_FCMTx) then) =
      __$$_FCMTxCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'tx_type') FCMTxType? txType,
      @JsonKey(name: 'txid') String? txId});
}

/// @nodoc
class __$$_FCMTxCopyWithImpl<$Res> extends _$FCMTxCopyWithImpl<$Res>
    implements _$$_FCMTxCopyWith<$Res> {
  __$$_FCMTxCopyWithImpl(_$_FCMTx _value, $Res Function(_$_FCMTx) _then)
      : super(_value, (v) => _then(v as _$_FCMTx));

  @override
  _$_FCMTx get _value => super._value as _$_FCMTx;

  @override
  $Res call({
    Object? txType = freezed,
    Object? txId = freezed,
  }) {
    return _then(_$_FCMTx(
      txType: txType == freezed
          ? _value.txType
          : txType // ignore: cast_nullable_to_non_nullable
              as FCMTxType?,
      txId: txId == freezed
          ? _value.txId
          : txId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FCMTx implements _FCMTx {
  const _$_FCMTx(
      {@JsonKey(name: 'tx_type') this.txType,
      @JsonKey(name: 'txid') this.txId});

  factory _$_FCMTx.fromJson(Map<String, dynamic> json) =>
      _$$_FCMTxFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FCMTx &&
            const DeepCollectionEquality().equals(other.txType, txType) &&
            const DeepCollectionEquality().equals(other.txId, txId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(txType),
      const DeepCollectionEquality().hash(txId));

  @JsonKey(ignore: true)
  @override
  _$$_FCMTxCopyWith<_$_FCMTx> get copyWith =>
      __$$_FCMTxCopyWithImpl<_$_FCMTx>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FCMTxToJson(this);
  }
}

abstract class _FCMTx implements FCMTx {
  const factory _FCMTx(
      {@JsonKey(name: 'tx_type') final FCMTxType? txType,
      @JsonKey(name: 'txid') final String? txId}) = _$_FCMTx;

  factory _FCMTx.fromJson(Map<String, dynamic> json) = _$_FCMTx.fromJson;

  @override
  @JsonKey(name: 'tx_type')
  FCMTxType? get txType => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'txid')
  String? get txId => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_FCMTxCopyWith<_$_FCMTx> get copyWith =>
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
      _$FCMPegCopyWithImpl<$Res>;
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
class _$FCMPegCopyWithImpl<$Res> implements $FCMPegCopyWith<$Res> {
  _$FCMPegCopyWithImpl(this._value, this._then);

  final FCMPeg _value;
  // ignore: unused_field
  final $Res Function(FCMPeg) _then;

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
      orderId: orderId == freezed
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      pegIn: pegIn == freezed
          ? _value.pegIn
          : pegIn // ignore: cast_nullable_to_non_nullable
              as bool?,
      txHash: txHash == freezed
          ? _value.txHash
          : txHash // ignore: cast_nullable_to_non_nullable
              as String?,
      vout: vout == freezed
          ? _value.vout
          : vout // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
      payoutTxId: payoutTxId == freezed
          ? _value.payoutTxId
          : payoutTxId // ignore: cast_nullable_to_non_nullable
              as String?,
      payout: payout == freezed
          ? _value.payout
          : payout // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$$_FCMPegCopyWith<$Res> implements $FCMPegCopyWith<$Res> {
  factory _$$_FCMPegCopyWith(_$_FCMPeg value, $Res Function(_$_FCMPeg) then) =
      __$$_FCMPegCopyWithImpl<$Res>;
  @override
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
class __$$_FCMPegCopyWithImpl<$Res> extends _$FCMPegCopyWithImpl<$Res>
    implements _$$_FCMPegCopyWith<$Res> {
  __$$_FCMPegCopyWithImpl(_$_FCMPeg _value, $Res Function(_$_FCMPeg) _then)
      : super(_value, (v) => _then(v as _$_FCMPeg));

  @override
  _$_FCMPeg get _value => super._value as _$_FCMPeg;

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
    return _then(_$_FCMPeg(
      orderId: orderId == freezed
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      pegIn: pegIn == freezed
          ? _value.pegIn
          : pegIn // ignore: cast_nullable_to_non_nullable
              as bool?,
      txHash: txHash == freezed
          ? _value.txHash
          : txHash // ignore: cast_nullable_to_non_nullable
              as String?,
      vout: vout == freezed
          ? _value.vout
          : vout // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: createdAt == freezed
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as int?,
      payoutTxId: payoutTxId == freezed
          ? _value.payoutTxId
          : payoutTxId // ignore: cast_nullable_to_non_nullable
              as String?,
      payout: payout == freezed
          ? _value.payout
          : payout // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FCMPeg implements _FCMPeg {
  const _$_FCMPeg(
      {@JsonKey(name: 'order_id') this.orderId,
      @JsonKey(name: 'peg_in') this.pegIn,
      @JsonKey(name: 'tx_hash') this.txHash,
      this.vout,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'payout_txid') this.payoutTxId,
      this.payout});

  factory _$_FCMPeg.fromJson(Map<String, dynamic> json) =>
      _$$_FCMPegFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FCMPeg &&
            const DeepCollectionEquality().equals(other.orderId, orderId) &&
            const DeepCollectionEquality().equals(other.pegIn, pegIn) &&
            const DeepCollectionEquality().equals(other.txHash, txHash) &&
            const DeepCollectionEquality().equals(other.vout, vout) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.payoutTxId, payoutTxId) &&
            const DeepCollectionEquality().equals(other.payout, payout));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(orderId),
      const DeepCollectionEquality().hash(pegIn),
      const DeepCollectionEquality().hash(txHash),
      const DeepCollectionEquality().hash(vout),
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(payoutTxId),
      const DeepCollectionEquality().hash(payout));

  @JsonKey(ignore: true)
  @override
  _$$_FCMPegCopyWith<_$_FCMPeg> get copyWith =>
      __$$_FCMPegCopyWithImpl<_$_FCMPeg>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FCMPegToJson(this);
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
      final int? payout}) = _$_FCMPeg;

  factory _FCMPeg.fromJson(Map<String, dynamic> json) = _$_FCMPeg.fromJson;

  @override
  @JsonKey(name: 'order_id')
  String? get orderId => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'peg_in')
  bool? get pegIn => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'tx_hash')
  String? get txHash => throw _privateConstructorUsedError;
  @override
  int? get vout => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'created_at')
  int? get createdAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: 'payout_txid')
  String? get payoutTxId => throw _privateConstructorUsedError;
  @override
  int? get payout => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_FCMPegCopyWith<_$_FCMPeg> get copyWith =>
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
      _$FCMOrderCancelledCopyWithImpl<$Res>;
  $Res call({@JsonKey(name: 'order_id') String? orderId});
}

/// @nodoc
class _$FCMOrderCancelledCopyWithImpl<$Res>
    implements $FCMOrderCancelledCopyWith<$Res> {
  _$FCMOrderCancelledCopyWithImpl(this._value, this._then);

  final FCMOrderCancelled _value;
  // ignore: unused_field
  final $Res Function(FCMOrderCancelled) _then;

  @override
  $Res call({
    Object? orderId = freezed,
  }) {
    return _then(_value.copyWith(
      orderId: orderId == freezed
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_FCMOrderCancelledCopyWith<$Res>
    implements $FCMOrderCancelledCopyWith<$Res> {
  factory _$$_FCMOrderCancelledCopyWith(_$_FCMOrderCancelled value,
          $Res Function(_$_FCMOrderCancelled) then) =
      __$$_FCMOrderCancelledCopyWithImpl<$Res>;
  @override
  $Res call({@JsonKey(name: 'order_id') String? orderId});
}

/// @nodoc
class __$$_FCMOrderCancelledCopyWithImpl<$Res>
    extends _$FCMOrderCancelledCopyWithImpl<$Res>
    implements _$$_FCMOrderCancelledCopyWith<$Res> {
  __$$_FCMOrderCancelledCopyWithImpl(
      _$_FCMOrderCancelled _value, $Res Function(_$_FCMOrderCancelled) _then)
      : super(_value, (v) => _then(v as _$_FCMOrderCancelled));

  @override
  _$_FCMOrderCancelled get _value => super._value as _$_FCMOrderCancelled;

  @override
  $Res call({
    Object? orderId = freezed,
  }) {
    return _then(_$_FCMOrderCancelled(
      orderId: orderId == freezed
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FCMOrderCancelled implements _FCMOrderCancelled {
  const _$_FCMOrderCancelled({@JsonKey(name: 'order_id') this.orderId});

  factory _$_FCMOrderCancelled.fromJson(Map<String, dynamic> json) =>
      _$$_FCMOrderCancelledFromJson(json);

  @override
  @JsonKey(name: 'order_id')
  final String? orderId;

  @override
  String toString() {
    return 'FCMOrderCancelled(orderId: $orderId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FCMOrderCancelled &&
            const DeepCollectionEquality().equals(other.orderId, orderId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(orderId));

  @JsonKey(ignore: true)
  @override
  _$$_FCMOrderCancelledCopyWith<_$_FCMOrderCancelled> get copyWith =>
      __$$_FCMOrderCancelledCopyWithImpl<_$_FCMOrderCancelled>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FCMOrderCancelledToJson(this);
  }
}

abstract class _FCMOrderCancelled implements FCMOrderCancelled {
  const factory _FCMOrderCancelled(
          {@JsonKey(name: 'order_id') final String? orderId}) =
      _$_FCMOrderCancelled;

  factory _FCMOrderCancelled.fromJson(Map<String, dynamic> json) =
      _$_FCMOrderCancelled.fromJson;

  @override
  @JsonKey(name: 'order_id')
  String? get orderId => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_FCMOrderCancelledCopyWith<_$_FCMOrderCancelled> get copyWith =>
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
      _$FCMMessageCopyWithImpl<$Res>;
  $Res call({FCMNotification? notification, FCMData? data});

  $FCMNotificationCopyWith<$Res>? get notification;
  $FCMDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$FCMMessageCopyWithImpl<$Res> implements $FCMMessageCopyWith<$Res> {
  _$FCMMessageCopyWithImpl(this._value, this._then);

  final FCMMessage _value;
  // ignore: unused_field
  final $Res Function(FCMMessage) _then;

  @override
  $Res call({
    Object? notification = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      notification: notification == freezed
          ? _value.notification
          : notification // ignore: cast_nullable_to_non_nullable
              as FCMNotification?,
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as FCMData?,
    ));
  }

  @override
  $FCMNotificationCopyWith<$Res>? get notification {
    if (_value.notification == null) {
      return null;
    }

    return $FCMNotificationCopyWith<$Res>(_value.notification!, (value) {
      return _then(_value.copyWith(notification: value));
    });
  }

  @override
  $FCMDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $FCMDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc
abstract class _$$_FCMMessageCopyWith<$Res>
    implements $FCMMessageCopyWith<$Res> {
  factory _$$_FCMMessageCopyWith(
          _$_FCMMessage value, $Res Function(_$_FCMMessage) then) =
      __$$_FCMMessageCopyWithImpl<$Res>;
  @override
  $Res call({FCMNotification? notification, FCMData? data});

  @override
  $FCMNotificationCopyWith<$Res>? get notification;
  @override
  $FCMDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$_FCMMessageCopyWithImpl<$Res> extends _$FCMMessageCopyWithImpl<$Res>
    implements _$$_FCMMessageCopyWith<$Res> {
  __$$_FCMMessageCopyWithImpl(
      _$_FCMMessage _value, $Res Function(_$_FCMMessage) _then)
      : super(_value, (v) => _then(v as _$_FCMMessage));

  @override
  _$_FCMMessage get _value => super._value as _$_FCMMessage;

  @override
  $Res call({
    Object? notification = freezed,
    Object? data = freezed,
  }) {
    return _then(_$_FCMMessage(
      notification: notification == freezed
          ? _value.notification
          : notification // ignore: cast_nullable_to_non_nullable
              as FCMNotification?,
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as FCMData?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FCMMessage implements _FCMMessage {
  const _$_FCMMessage({this.notification, this.data});

  factory _$_FCMMessage.fromJson(Map<String, dynamic> json) =>
      _$$_FCMMessageFromJson(json);

  @override
  final FCMNotification? notification;
  @override
  final FCMData? data;

  @override
  String toString() {
    return 'FCMMessage(notification: $notification, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FCMMessage &&
            const DeepCollectionEquality()
                .equals(other.notification, notification) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(notification),
      const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  _$$_FCMMessageCopyWith<_$_FCMMessage> get copyWith =>
      __$$_FCMMessageCopyWithImpl<_$_FCMMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FCMMessageToJson(this);
  }
}

abstract class _FCMMessage implements FCMMessage {
  const factory _FCMMessage(
      {final FCMNotification? notification,
      final FCMData? data}) = _$_FCMMessage;

  factory _FCMMessage.fromJson(Map<String, dynamic> json) =
      _$_FCMMessage.fromJson;

  @override
  FCMNotification? get notification => throw _privateConstructorUsedError;
  @override
  FCMData? get data => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_FCMMessageCopyWith<_$_FCMMessage> get copyWith =>
      throw _privateConstructorUsedError;
}
