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

 Asset get asset;
/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeSideCopyWith<ExchangeSide> get copyWith => _$ExchangeSideCopyWithImpl<ExchangeSide>(this as ExchangeSide, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeSide&&(identical(other.asset, asset) || other.asset == asset));
}


@override
int get hashCode => Object.hash(runtimeType,asset);

@override
String toString() {
  return 'ExchangeSide(asset: $asset)';
}


}

/// @nodoc
abstract mixin class $ExchangeSideCopyWith<$Res>  {
  factory $ExchangeSideCopyWith(ExchangeSide value, $Res Function(ExchangeSide) _then) = _$ExchangeSideCopyWithImpl;
@useResult
$Res call({
 Asset asset
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
@pragma('vm:prefer-inline') @override $Res call({Object? asset = null,}) {
  return _then(_self.copyWith(
asset: null == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as Asset,
  ));
}

}


/// @nodoc


class ExchangeSideSell implements ExchangeSide {
  const ExchangeSideSell(this.asset);
  

@override final  Asset asset;

/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeSideSellCopyWith<ExchangeSideSell> get copyWith => _$ExchangeSideSellCopyWithImpl<ExchangeSideSell>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeSideSell&&(identical(other.asset, asset) || other.asset == asset));
}


@override
int get hashCode => Object.hash(runtimeType,asset);

@override
String toString() {
  return 'ExchangeSide.sell(asset: $asset)';
}


}

/// @nodoc
abstract mixin class $ExchangeSideSellCopyWith<$Res> implements $ExchangeSideCopyWith<$Res> {
  factory $ExchangeSideSellCopyWith(ExchangeSideSell value, $Res Function(ExchangeSideSell) _then) = _$ExchangeSideSellCopyWithImpl;
@override @useResult
$Res call({
 Asset asset
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
@override @pragma('vm:prefer-inline') $Res call({Object? asset = null,}) {
  return _then(ExchangeSideSell(
null == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as Asset,
  ));
}


}

/// @nodoc


class ExchangeSideBuy implements ExchangeSide {
  const ExchangeSideBuy(this.asset);
  

@override final  Asset asset;

/// Create a copy of ExchangeSide
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeSideBuyCopyWith<ExchangeSideBuy> get copyWith => _$ExchangeSideBuyCopyWithImpl<ExchangeSideBuy>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeSideBuy&&(identical(other.asset, asset) || other.asset == asset));
}


@override
int get hashCode => Object.hash(runtimeType,asset);

@override
String toString() {
  return 'ExchangeSide.buy(asset: $asset)';
}


}

/// @nodoc
abstract mixin class $ExchangeSideBuyCopyWith<$Res> implements $ExchangeSideCopyWith<$Res> {
  factory $ExchangeSideBuyCopyWith(ExchangeSideBuy value, $Res Function(ExchangeSideBuy) _then) = _$ExchangeSideBuyCopyWithImpl;
@override @useResult
$Res call({
 Asset asset
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
@override @pragma('vm:prefer-inline') $Res call({Object? asset = null,}) {
  return _then(ExchangeSideBuy(
null == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as Asset,
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
