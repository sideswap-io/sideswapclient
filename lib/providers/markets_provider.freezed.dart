// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'markets_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarketSideState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketSideState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketSideState()';
}


}

/// @nodoc
class $MarketSideStateCopyWith<$Res>  {
$MarketSideStateCopyWith(MarketSideState _, $Res Function(MarketSideState) __);
}


/// @nodoc


class MarketSideStateBase implements MarketSideState {
  const MarketSideStateBase();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketSideStateBase);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketSideState.base()';
}


}




/// @nodoc


class MarketSideStateQuote implements MarketSideState {
  const MarketSideStateQuote();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketSideStateQuote);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketSideState.quote()';
}


}




/// @nodoc
mixin _$MarketTypeSwitchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketTypeSwitchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketTypeSwitchState()';
}


}

/// @nodoc
class $MarketTypeSwitchStateCopyWith<$Res>  {
$MarketTypeSwitchStateCopyWith(MarketTypeSwitchState _, $Res Function(MarketTypeSwitchState) __);
}


/// @nodoc


class MarketTypeSwitchStateMarket implements MarketTypeSwitchState {
  const MarketTypeSwitchStateMarket();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketTypeSwitchStateMarket);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketTypeSwitchState.market()';
}


}




/// @nodoc


class MarketTypeSwitchStateLimit implements MarketTypeSwitchState {
  const MarketTypeSwitchStateLimit();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketTypeSwitchStateLimit);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketTypeSwitchState.limit()';
}


}




/// @nodoc
mixin _$QuoteError {

 String get error; int get orderId;
/// Create a copy of QuoteError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteErrorCopyWith<QuoteError> get copyWith => _$QuoteErrorCopyWithImpl<QuoteError>(this as QuoteError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteError&&(identical(other.error, error) || other.error == error)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}


@override
int get hashCode => Object.hash(runtimeType,error,orderId);

@override
String toString() {
  return 'QuoteError(error: $error, orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class $QuoteErrorCopyWith<$Res>  {
  factory $QuoteErrorCopyWith(QuoteError value, $Res Function(QuoteError) _then) = _$QuoteErrorCopyWithImpl;
@useResult
$Res call({
 String error, int orderId
});




}
/// @nodoc
class _$QuoteErrorCopyWithImpl<$Res>
    implements $QuoteErrorCopyWith<$Res> {
  _$QuoteErrorCopyWithImpl(this._self, this._then);

  final QuoteError _self;
  final $Res Function(QuoteError) _then;

/// Create a copy of QuoteError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? error = null,Object? orderId = null,}) {
  return _then(_self.copyWith(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _QuoteError implements QuoteError {
  const _QuoteError({this.error = '', this.orderId = 0});
  

@override@JsonKey() final  String error;
@override@JsonKey() final  int orderId;

/// Create a copy of QuoteError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteErrorCopyWith<_QuoteError> get copyWith => __$QuoteErrorCopyWithImpl<_QuoteError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuoteError&&(identical(other.error, error) || other.error == error)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}


@override
int get hashCode => Object.hash(runtimeType,error,orderId);

@override
String toString() {
  return 'QuoteError(error: $error, orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class _$QuoteErrorCopyWith<$Res> implements $QuoteErrorCopyWith<$Res> {
  factory _$QuoteErrorCopyWith(_QuoteError value, $Res Function(_QuoteError) _then) = __$QuoteErrorCopyWithImpl;
@override @useResult
$Res call({
 String error, int orderId
});




}
/// @nodoc
class __$QuoteErrorCopyWithImpl<$Res>
    implements _$QuoteErrorCopyWith<$Res> {
  __$QuoteErrorCopyWithImpl(this._self, this._then);

  final _QuoteError _self;
  final $Res Function(_QuoteError) _then;

/// Create a copy of QuoteError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? error = null,Object? orderId = null,}) {
  return _then(_QuoteError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$LimitTtlFlag {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlag);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag()';
}


}

/// @nodoc
class $LimitTtlFlagCopyWith<$Res>  {
$LimitTtlFlagCopyWith(LimitTtlFlag _, $Res Function(LimitTtlFlag) __);
}


/// @nodoc


class LimitTtlFlagOneHour extends LimitTtlFlag {
  const LimitTtlFlagOneHour(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagOneHour);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.oneHour()';
}


}




/// @nodoc


class LimitTtlFlagSixHours extends LimitTtlFlag {
  const LimitTtlFlagSixHours(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagSixHours);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.sixHours()';
}


}




/// @nodoc


class LimitTtlFlagTwelveHours extends LimitTtlFlag {
  const LimitTtlFlagTwelveHours(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagTwelveHours);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.twelveHours()';
}


}




/// @nodoc


class LimitTtlFlagTwentyFourHours extends LimitTtlFlag {
  const LimitTtlFlagTwentyFourHours(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagTwentyFourHours);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.twentyFourHours()';
}


}




/// @nodoc


class LimitTtlFlagThreeDays extends LimitTtlFlag {
  const LimitTtlFlagThreeDays(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagThreeDays);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.threeDays()';
}


}




/// @nodoc


class LimitTtlFlagOneWeek extends LimitTtlFlag {
  const LimitTtlFlagOneWeek(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagOneWeek);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.oneWeek()';
}


}




/// @nodoc


class LimitTtlFlagOneMonth extends LimitTtlFlag {
  const LimitTtlFlagOneMonth(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagOneMonth);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.oneMonth()';
}


}




/// @nodoc


class LimitTtlFlagUnlimited extends LimitTtlFlag {
  const LimitTtlFlagUnlimited(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LimitTtlFlagUnlimited);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LimitTtlFlag.unlimited()';
}


}




/// @nodoc
mixin _$OrderType {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderType);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderType()';
}


}

/// @nodoc
class $OrderTypeCopyWith<$Res>  {
$OrderTypeCopyWith(OrderType _, $Res Function(OrderType) __);
}


/// @nodoc


class OrderTypePublic implements OrderType {
  const OrderTypePublic();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTypePublic);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderType.public()';
}


}




/// @nodoc


class OrderTypePrivate implements OrderType {
  const OrderTypePrivate();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTypePrivate);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderType.private()';
}


}




/// @nodoc
mixin _$OfflineSwapType {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflineSwapType);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OfflineSwapType()';
}


}

/// @nodoc
class $OfflineSwapTypeCopyWith<$Res>  {
$OfflineSwapTypeCopyWith(OfflineSwapType _, $Res Function(OfflineSwapType) __);
}


/// @nodoc


class OfflineSwapTypeEmpty implements OfflineSwapType {
  const OfflineSwapTypeEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflineSwapTypeEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OfflineSwapType.empty()';
}


}




/// @nodoc


class OfflineSwapTypeTwoStep implements OfflineSwapType {
  const OfflineSwapTypeTwoStep();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflineSwapTypeTwoStep);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OfflineSwapType.twoStep()';
}


}




/// @nodoc
mixin _$StartOrderError {

 String get error; int get orderId;
/// Create a copy of StartOrderError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartOrderErrorCopyWith<StartOrderError> get copyWith => _$StartOrderErrorCopyWithImpl<StartOrderError>(this as StartOrderError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartOrderError&&(identical(other.error, error) || other.error == error)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}


@override
int get hashCode => Object.hash(runtimeType,error,orderId);

@override
String toString() {
  return 'StartOrderError(error: $error, orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class $StartOrderErrorCopyWith<$Res>  {
  factory $StartOrderErrorCopyWith(StartOrderError value, $Res Function(StartOrderError) _then) = _$StartOrderErrorCopyWithImpl;
@useResult
$Res call({
 String error, int orderId
});




}
/// @nodoc
class _$StartOrderErrorCopyWithImpl<$Res>
    implements $StartOrderErrorCopyWith<$Res> {
  _$StartOrderErrorCopyWithImpl(this._self, this._then);

  final StartOrderError _self;
  final $Res Function(StartOrderError) _then;

/// Create a copy of StartOrderError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? error = null,Object? orderId = null,}) {
  return _then(_self.copyWith(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _StartOrderError implements StartOrderError {
  const _StartOrderError({this.error = '', this.orderId = 0});
  

@override@JsonKey() final  String error;
@override@JsonKey() final  int orderId;

/// Create a copy of StartOrderError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartOrderErrorCopyWith<_StartOrderError> get copyWith => __$StartOrderErrorCopyWithImpl<_StartOrderError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartOrderError&&(identical(other.error, error) || other.error == error)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}


@override
int get hashCode => Object.hash(runtimeType,error,orderId);

@override
String toString() {
  return 'StartOrderError(error: $error, orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class _$StartOrderErrorCopyWith<$Res> implements $StartOrderErrorCopyWith<$Res> {
  factory _$StartOrderErrorCopyWith(_StartOrderError value, $Res Function(_StartOrderError) _then) = __$StartOrderErrorCopyWithImpl;
@override @useResult
$Res call({
 String error, int orderId
});




}
/// @nodoc
class __$StartOrderErrorCopyWithImpl<$Res>
    implements _$StartOrderErrorCopyWith<$Res> {
  __$StartOrderErrorCopyWithImpl(this._self, this._then);

  final _StartOrderError _self;
  final $Res Function(_StartOrderError) _then;

/// Create a copy of StartOrderError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? error = null,Object? orderId = null,}) {
  return _then(_StartOrderError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
