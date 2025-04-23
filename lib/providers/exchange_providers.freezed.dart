// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exchange_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExchangeSide {

 AccountAsset get accountAsset;
/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeSideCopyWith<ExchangeSide> get copyWith => _$ExchangeSideCopyWithImpl<ExchangeSide>(this as ExchangeSide, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeSide&&(identical(other.accountAsset, accountAsset) || other.accountAsset == accountAsset));
}


@override
int get hashCode => Object.hash(runtimeType,accountAsset);

@override
String toString() {
  return 'ExchangeSide(accountAsset: $accountAsset)';
}


}

/// @nodoc
abstract mixin class $ExchangeSideCopyWith<$Res>  {
  factory $ExchangeSideCopyWith(ExchangeSide value, $Res Function(ExchangeSide) _then) = _$ExchangeSideCopyWithImpl;
@useResult
$Res call({
 AccountAsset accountAsset
});




}
/// @nodoc
class _$ExchangeSideCopyWithImpl<$Res>
    implements $ExchangeSideCopyWith<$Res> {
  _$ExchangeSideCopyWithImpl(this._self, this._then);

  final ExchangeSide _self;
  final $Res Function(ExchangeSide) _then;

/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountAsset = null,}) {
  return _then(_self.copyWith(
accountAsset: null == accountAsset ? _self.accountAsset : accountAsset // ignore: cast_nullable_to_non_nullable
as AccountAsset,
  ));
}

}


/// @nodoc


class ExchangeSideSell implements ExchangeSide {
  const ExchangeSideSell(this.accountAsset);
  

@override final  AccountAsset accountAsset;

/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeSideSellCopyWith<ExchangeSideSell> get copyWith => _$ExchangeSideSellCopyWithImpl<ExchangeSideSell>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeSideSell&&(identical(other.accountAsset, accountAsset) || other.accountAsset == accountAsset));
}


@override
int get hashCode => Object.hash(runtimeType,accountAsset);

@override
String toString() {
  return 'ExchangeSide.sell(accountAsset: $accountAsset)';
}


}

/// @nodoc
abstract mixin class $ExchangeSideSellCopyWith<$Res> implements $ExchangeSideCopyWith<$Res> {
  factory $ExchangeSideSellCopyWith(ExchangeSideSell value, $Res Function(ExchangeSideSell) _then) = _$ExchangeSideSellCopyWithImpl;
@override @useResult
$Res call({
 AccountAsset accountAsset
});




}
/// @nodoc
class _$ExchangeSideSellCopyWithImpl<$Res>
    implements $ExchangeSideSellCopyWith<$Res> {
  _$ExchangeSideSellCopyWithImpl(this._self, this._then);

  final ExchangeSideSell _self;
  final $Res Function(ExchangeSideSell) _then;

/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountAsset = null,}) {
  return _then(ExchangeSideSell(
null == accountAsset ? _self.accountAsset : accountAsset // ignore: cast_nullable_to_non_nullable
as AccountAsset,
  ));
}


}

/// @nodoc


class ExchangeSideBuy implements ExchangeSide {
  const ExchangeSideBuy(this.accountAsset);
  

@override final  AccountAsset accountAsset;

/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeSideBuyCopyWith<ExchangeSideBuy> get copyWith => _$ExchangeSideBuyCopyWithImpl<ExchangeSideBuy>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeSideBuy&&(identical(other.accountAsset, accountAsset) || other.accountAsset == accountAsset));
}


@override
int get hashCode => Object.hash(runtimeType,accountAsset);

@override
String toString() {
  return 'ExchangeSide.buy(accountAsset: $accountAsset)';
}


}

/// @nodoc
abstract mixin class $ExchangeSideBuyCopyWith<$Res> implements $ExchangeSideCopyWith<$Res> {
  factory $ExchangeSideBuyCopyWith(ExchangeSideBuy value, $Res Function(ExchangeSideBuy) _then) = _$ExchangeSideBuyCopyWithImpl;
@override @useResult
$Res call({
 AccountAsset accountAsset
});




}
/// @nodoc
class _$ExchangeSideBuyCopyWithImpl<$Res>
    implements $ExchangeSideBuyCopyWith<$Res> {
  _$ExchangeSideBuyCopyWithImpl(this._self, this._then);

  final ExchangeSideBuy _self;
  final $Res Function(ExchangeSideBuy) _then;

/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountAsset = null,}) {
  return _then(ExchangeSideBuy(
null == accountAsset ? _self.accountAsset : accountAsset // ignore: cast_nullable_to_non_nullable
as AccountAsset,
  ));
}


}

/// @nodoc
mixin _$ExchangeCustomError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeCustomError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExchangeCustomError()';
}


}

/// @nodoc
class $ExchangeCustomErrorCopyWith<$Res>  {
$ExchangeCustomErrorCopyWith(ExchangeCustomError _, $Res Function(ExchangeCustomError) __);
}


/// @nodoc


class ExchangeCustomErrorEmpty implements ExchangeCustomError {
  const ExchangeCustomErrorEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeCustomErrorEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExchangeCustomError.empty()';
}


}




/// @nodoc


class ExchangeCustomErrorBalanceExceeded implements ExchangeCustomError {
  const ExchangeCustomErrorBalanceExceeded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeCustomErrorBalanceExceeded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExchangeCustomError.balanceExceeded()';
}


}




/// @nodoc


class ExchangeCustomErrorDeliverExceeded implements ExchangeCustomError {
  const ExchangeCustomErrorDeliverExceeded({this.maxDeliverAmount});
  

 final  String? maxDeliverAmount;

/// Create a copy of ExchangeCustomError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeCustomErrorDeliverExceededCopyWith<ExchangeCustomErrorDeliverExceeded> get copyWith => _$ExchangeCustomErrorDeliverExceededCopyWithImpl<ExchangeCustomErrorDeliverExceeded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeCustomErrorDeliverExceeded&&(identical(other.maxDeliverAmount, maxDeliverAmount) || other.maxDeliverAmount == maxDeliverAmount));
}


@override
int get hashCode => Object.hash(runtimeType,maxDeliverAmount);

@override
String toString() {
  return 'ExchangeCustomError.deliverExceeded(maxDeliverAmount: $maxDeliverAmount)';
}


}

/// @nodoc
abstract mixin class $ExchangeCustomErrorDeliverExceededCopyWith<$Res> implements $ExchangeCustomErrorCopyWith<$Res> {
  factory $ExchangeCustomErrorDeliverExceededCopyWith(ExchangeCustomErrorDeliverExceeded value, $Res Function(ExchangeCustomErrorDeliverExceeded) _then) = _$ExchangeCustomErrorDeliverExceededCopyWithImpl;
@useResult
$Res call({
 String? maxDeliverAmount
});




}
/// @nodoc
class _$ExchangeCustomErrorDeliverExceededCopyWithImpl<$Res>
    implements $ExchangeCustomErrorDeliverExceededCopyWith<$Res> {
  _$ExchangeCustomErrorDeliverExceededCopyWithImpl(this._self, this._then);

  final ExchangeCustomErrorDeliverExceeded _self;
  final $Res Function(ExchangeCustomErrorDeliverExceeded) _then;

/// Create a copy of ExchangeCustomError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? maxDeliverAmount = freezed,}) {
  return _then(ExchangeCustomErrorDeliverExceeded(
maxDeliverAmount: freezed == maxDeliverAmount ? _self.maxDeliverAmount : maxDeliverAmount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ExchangeAcceptQuoteState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeAcceptQuoteState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExchangeAcceptQuoteState()';
}


}

/// @nodoc
class $ExchangeAcceptQuoteStateCopyWith<$Res>  {
$ExchangeAcceptQuoteStateCopyWith(ExchangeAcceptQuoteState _, $Res Function(ExchangeAcceptQuoteState) __);
}


/// @nodoc


class ExchangeAcceptQuoteStateEmpty implements ExchangeAcceptQuoteState {
  const ExchangeAcceptQuoteStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeAcceptQuoteStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExchangeAcceptQuoteState.empty()';
}


}




/// @nodoc


class ExchangeAcceptQuoteStateInProgress implements ExchangeAcceptQuoteState {
  const ExchangeAcceptQuoteStateInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeAcceptQuoteStateInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExchangeAcceptQuoteState.inProgress()';
}


}




// dart format on
