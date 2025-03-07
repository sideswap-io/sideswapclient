// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'amount_to_string_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AmountToStringParameters {

 int get amount; bool get forceSign; int get precision; bool get trailingZeroes; bool get useNumberFormatter;
/// Create a copy of AmountToStringParameters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AmountToStringParametersCopyWith<AmountToStringParameters> get copyWith => _$AmountToStringParametersCopyWithImpl<AmountToStringParameters>(this as AmountToStringParameters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AmountToStringParameters&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.forceSign, forceSign) || other.forceSign == forceSign)&&(identical(other.precision, precision) || other.precision == precision)&&(identical(other.trailingZeroes, trailingZeroes) || other.trailingZeroes == trailingZeroes)&&(identical(other.useNumberFormatter, useNumberFormatter) || other.useNumberFormatter == useNumberFormatter));
}


@override
int get hashCode => Object.hash(runtimeType,amount,forceSign,precision,trailingZeroes,useNumberFormatter);

@override
String toString() {
  return 'AmountToStringParameters(amount: $amount, forceSign: $forceSign, precision: $precision, trailingZeroes: $trailingZeroes, useNumberFormatter: $useNumberFormatter)';
}


}

/// @nodoc
abstract mixin class $AmountToStringParametersCopyWith<$Res>  {
  factory $AmountToStringParametersCopyWith(AmountToStringParameters value, $Res Function(AmountToStringParameters) _then) = _$AmountToStringParametersCopyWithImpl;
@useResult
$Res call({
 int amount, bool forceSign, int precision, bool trailingZeroes, bool useNumberFormatter
});




}
/// @nodoc
class _$AmountToStringParametersCopyWithImpl<$Res>
    implements $AmountToStringParametersCopyWith<$Res> {
  _$AmountToStringParametersCopyWithImpl(this._self, this._then);

  final AmountToStringParameters _self;
  final $Res Function(AmountToStringParameters) _then;

/// Create a copy of AmountToStringParameters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? forceSign = null,Object? precision = null,Object? trailingZeroes = null,Object? useNumberFormatter = null,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,forceSign: null == forceSign ? _self.forceSign : forceSign // ignore: cast_nullable_to_non_nullable
as bool,precision: null == precision ? _self.precision : precision // ignore: cast_nullable_to_non_nullable
as int,trailingZeroes: null == trailingZeroes ? _self.trailingZeroes : trailingZeroes // ignore: cast_nullable_to_non_nullable
as bool,useNumberFormatter: null == useNumberFormatter ? _self.useNumberFormatter : useNumberFormatter // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _AmountToStringParameters implements AmountToStringParameters {
   _AmountToStringParameters({required this.amount, this.forceSign = false, this.precision = 8, this.trailingZeroes = true, this.useNumberFormatter = false});
  

@override final  int amount;
@override@JsonKey() final  bool forceSign;
@override@JsonKey() final  int precision;
@override@JsonKey() final  bool trailingZeroes;
@override@JsonKey() final  bool useNumberFormatter;

/// Create a copy of AmountToStringParameters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AmountToStringParametersCopyWith<_AmountToStringParameters> get copyWith => __$AmountToStringParametersCopyWithImpl<_AmountToStringParameters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AmountToStringParameters&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.forceSign, forceSign) || other.forceSign == forceSign)&&(identical(other.precision, precision) || other.precision == precision)&&(identical(other.trailingZeroes, trailingZeroes) || other.trailingZeroes == trailingZeroes)&&(identical(other.useNumberFormatter, useNumberFormatter) || other.useNumberFormatter == useNumberFormatter));
}


@override
int get hashCode => Object.hash(runtimeType,amount,forceSign,precision,trailingZeroes,useNumberFormatter);

@override
String toString() {
  return 'AmountToStringParameters(amount: $amount, forceSign: $forceSign, precision: $precision, trailingZeroes: $trailingZeroes, useNumberFormatter: $useNumberFormatter)';
}


}

/// @nodoc
abstract mixin class _$AmountToStringParametersCopyWith<$Res> implements $AmountToStringParametersCopyWith<$Res> {
  factory _$AmountToStringParametersCopyWith(_AmountToStringParameters value, $Res Function(_AmountToStringParameters) _then) = __$AmountToStringParametersCopyWithImpl;
@override @useResult
$Res call({
 int amount, bool forceSign, int precision, bool trailingZeroes, bool useNumberFormatter
});




}
/// @nodoc
class __$AmountToStringParametersCopyWithImpl<$Res>
    implements _$AmountToStringParametersCopyWith<$Res> {
  __$AmountToStringParametersCopyWithImpl(this._self, this._then);

  final _AmountToStringParameters _self;
  final $Res Function(_AmountToStringParameters) _then;

/// Create a copy of AmountToStringParameters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? forceSign = null,Object? precision = null,Object? trailingZeroes = null,Object? useNumberFormatter = null,}) {
  return _then(_AmountToStringParameters(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,forceSign: null == forceSign ? _self.forceSign : forceSign // ignore: cast_nullable_to_non_nullable
as bool,precision: null == precision ? _self.precision : precision // ignore: cast_nullable_to_non_nullable
as int,trailingZeroes: null == trailingZeroes ? _self.trailingZeroes : trailingZeroes // ignore: cast_nullable_to_non_nullable
as bool,useNumberFormatter: null == useNumberFormatter ? _self.useNumberFormatter : useNumberFormatter // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$AmountToStringNamedParameters {

 int get amount; String get ticker; bool get forceSign; int get precision; bool get trailingZeroes; bool get useNumberFormatter;
/// Create a copy of AmountToStringNamedParameters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AmountToStringNamedParametersCopyWith<AmountToStringNamedParameters> get copyWith => _$AmountToStringNamedParametersCopyWithImpl<AmountToStringNamedParameters>(this as AmountToStringNamedParameters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AmountToStringNamedParameters&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.ticker, ticker) || other.ticker == ticker)&&(identical(other.forceSign, forceSign) || other.forceSign == forceSign)&&(identical(other.precision, precision) || other.precision == precision)&&(identical(other.trailingZeroes, trailingZeroes) || other.trailingZeroes == trailingZeroes)&&(identical(other.useNumberFormatter, useNumberFormatter) || other.useNumberFormatter == useNumberFormatter));
}


@override
int get hashCode => Object.hash(runtimeType,amount,ticker,forceSign,precision,trailingZeroes,useNumberFormatter);

@override
String toString() {
  return 'AmountToStringNamedParameters(amount: $amount, ticker: $ticker, forceSign: $forceSign, precision: $precision, trailingZeroes: $trailingZeroes, useNumberFormatter: $useNumberFormatter)';
}


}

/// @nodoc
abstract mixin class $AmountToStringNamedParametersCopyWith<$Res>  {
  factory $AmountToStringNamedParametersCopyWith(AmountToStringNamedParameters value, $Res Function(AmountToStringNamedParameters) _then) = _$AmountToStringNamedParametersCopyWithImpl;
@useResult
$Res call({
 int amount, String ticker, bool forceSign, int precision, bool trailingZeroes, bool useNumberFormatter
});




}
/// @nodoc
class _$AmountToStringNamedParametersCopyWithImpl<$Res>
    implements $AmountToStringNamedParametersCopyWith<$Res> {
  _$AmountToStringNamedParametersCopyWithImpl(this._self, this._then);

  final AmountToStringNamedParameters _self;
  final $Res Function(AmountToStringNamedParameters) _then;

/// Create a copy of AmountToStringNamedParameters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? ticker = null,Object? forceSign = null,Object? precision = null,Object? trailingZeroes = null,Object? useNumberFormatter = null,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,ticker: null == ticker ? _self.ticker : ticker // ignore: cast_nullable_to_non_nullable
as String,forceSign: null == forceSign ? _self.forceSign : forceSign // ignore: cast_nullable_to_non_nullable
as bool,precision: null == precision ? _self.precision : precision // ignore: cast_nullable_to_non_nullable
as int,trailingZeroes: null == trailingZeroes ? _self.trailingZeroes : trailingZeroes // ignore: cast_nullable_to_non_nullable
as bool,useNumberFormatter: null == useNumberFormatter ? _self.useNumberFormatter : useNumberFormatter // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _AmountToStringNamedParameters implements AmountToStringNamedParameters {
   _AmountToStringNamedParameters({required this.amount, required this.ticker, this.forceSign = false, this.precision = 8, this.trailingZeroes = true, this.useNumberFormatter = false});
  

@override final  int amount;
@override final  String ticker;
@override@JsonKey() final  bool forceSign;
@override@JsonKey() final  int precision;
@override@JsonKey() final  bool trailingZeroes;
@override@JsonKey() final  bool useNumberFormatter;

/// Create a copy of AmountToStringNamedParameters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AmountToStringNamedParametersCopyWith<_AmountToStringNamedParameters> get copyWith => __$AmountToStringNamedParametersCopyWithImpl<_AmountToStringNamedParameters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AmountToStringNamedParameters&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.ticker, ticker) || other.ticker == ticker)&&(identical(other.forceSign, forceSign) || other.forceSign == forceSign)&&(identical(other.precision, precision) || other.precision == precision)&&(identical(other.trailingZeroes, trailingZeroes) || other.trailingZeroes == trailingZeroes)&&(identical(other.useNumberFormatter, useNumberFormatter) || other.useNumberFormatter == useNumberFormatter));
}


@override
int get hashCode => Object.hash(runtimeType,amount,ticker,forceSign,precision,trailingZeroes,useNumberFormatter);

@override
String toString() {
  return 'AmountToStringNamedParameters(amount: $amount, ticker: $ticker, forceSign: $forceSign, precision: $precision, trailingZeroes: $trailingZeroes, useNumberFormatter: $useNumberFormatter)';
}


}

/// @nodoc
abstract mixin class _$AmountToStringNamedParametersCopyWith<$Res> implements $AmountToStringNamedParametersCopyWith<$Res> {
  factory _$AmountToStringNamedParametersCopyWith(_AmountToStringNamedParameters value, $Res Function(_AmountToStringNamedParameters) _then) = __$AmountToStringNamedParametersCopyWithImpl;
@override @useResult
$Res call({
 int amount, String ticker, bool forceSign, int precision, bool trailingZeroes, bool useNumberFormatter
});




}
/// @nodoc
class __$AmountToStringNamedParametersCopyWithImpl<$Res>
    implements _$AmountToStringNamedParametersCopyWith<$Res> {
  __$AmountToStringNamedParametersCopyWithImpl(this._self, this._then);

  final _AmountToStringNamedParameters _self;
  final $Res Function(_AmountToStringNamedParameters) _then;

/// Create a copy of AmountToStringNamedParameters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? ticker = null,Object? forceSign = null,Object? precision = null,Object? trailingZeroes = null,Object? useNumberFormatter = null,}) {
  return _then(_AmountToStringNamedParameters(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,ticker: null == ticker ? _self.ticker : ticker // ignore: cast_nullable_to_non_nullable
as String,forceSign: null == forceSign ? _self.forceSign : forceSign // ignore: cast_nullable_to_non_nullable
as bool,precision: null == precision ? _self.precision : precision // ignore: cast_nullable_to_non_nullable
as int,trailingZeroes: null == trailingZeroes ? _self.trailingZeroes : trailingZeroes // ignore: cast_nullable_to_non_nullable
as bool,useNumberFormatter: null == useNumberFormatter ? _self.useNumberFormatter : useNumberFormatter // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
