// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency_rates_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConversionRate {

 String get name; Decimal get rate;
/// Create a copy of ConversionRate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversionRateCopyWith<ConversionRate> get copyWith => _$ConversionRateCopyWithImpl<ConversionRate>(this as ConversionRate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversionRate&&(identical(other.name, name) || other.name == name)&&(identical(other.rate, rate) || other.rate == rate));
}


@override
int get hashCode => Object.hash(runtimeType,name,rate);

@override
String toString() {
  return 'ConversionRate(name: $name, rate: $rate)';
}


}

/// @nodoc
abstract mixin class $ConversionRateCopyWith<$Res>  {
  factory $ConversionRateCopyWith(ConversionRate value, $Res Function(ConversionRate) _then) = _$ConversionRateCopyWithImpl;
@useResult
$Res call({
 String name, Decimal rate
});




}
/// @nodoc
class _$ConversionRateCopyWithImpl<$Res>
    implements $ConversionRateCopyWith<$Res> {
  _$ConversionRateCopyWithImpl(this._self, this._then);

  final ConversionRate _self;
  final $Res Function(ConversionRate) _then;

/// Create a copy of ConversionRate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? rate = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}

}


/// @nodoc


class _ConversionRate implements ConversionRate {
  const _ConversionRate({required this.name, required this.rate});
  

@override final  String name;
@override final  Decimal rate;

/// Create a copy of ConversionRate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversionRateCopyWith<_ConversionRate> get copyWith => __$ConversionRateCopyWithImpl<_ConversionRate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversionRate&&(identical(other.name, name) || other.name == name)&&(identical(other.rate, rate) || other.rate == rate));
}


@override
int get hashCode => Object.hash(runtimeType,name,rate);

@override
String toString() {
  return 'ConversionRate(name: $name, rate: $rate)';
}


}

/// @nodoc
abstract mixin class _$ConversionRateCopyWith<$Res> implements $ConversionRateCopyWith<$Res> {
  factory _$ConversionRateCopyWith(_ConversionRate value, $Res Function(_ConversionRate) _then) = __$ConversionRateCopyWithImpl;
@override @useResult
$Res call({
 String name, Decimal rate
});




}
/// @nodoc
class __$ConversionRateCopyWithImpl<$Res>
    implements _$ConversionRateCopyWith<$Res> {
  __$ConversionRateCopyWithImpl(this._self, this._then);

  final _ConversionRate _self;
  final $Res Function(_ConversionRate) _then;

/// Create a copy of ConversionRate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? rate = null,}) {
  return _then(_ConversionRate(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}


}

/// @nodoc
mixin _$ConversionRates {

 List<ConversionRate> get usdConversionRates;
/// Create a copy of ConversionRates
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversionRatesCopyWith<ConversionRates> get copyWith => _$ConversionRatesCopyWithImpl<ConversionRates>(this as ConversionRates, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversionRates&&const DeepCollectionEquality().equals(other.usdConversionRates, usdConversionRates));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(usdConversionRates));

@override
String toString() {
  return 'ConversionRates(usdConversionRates: $usdConversionRates)';
}


}

/// @nodoc
abstract mixin class $ConversionRatesCopyWith<$Res>  {
  factory $ConversionRatesCopyWith(ConversionRates value, $Res Function(ConversionRates) _then) = _$ConversionRatesCopyWithImpl;
@useResult
$Res call({
 List<ConversionRate> usdConversionRates
});




}
/// @nodoc
class _$ConversionRatesCopyWithImpl<$Res>
    implements $ConversionRatesCopyWith<$Res> {
  _$ConversionRatesCopyWithImpl(this._self, this._then);

  final ConversionRates _self;
  final $Res Function(ConversionRates) _then;

/// Create a copy of ConversionRates
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? usdConversionRates = null,}) {
  return _then(_self.copyWith(
usdConversionRates: null == usdConversionRates ? _self.usdConversionRates : usdConversionRates // ignore: cast_nullable_to_non_nullable
as List<ConversionRate>,
  ));
}

}


/// @nodoc


class _UsdConversionRates implements ConversionRates {
  const _UsdConversionRates({required final  List<ConversionRate> usdConversionRates}): _usdConversionRates = usdConversionRates;
  

 final  List<ConversionRate> _usdConversionRates;
@override List<ConversionRate> get usdConversionRates {
  if (_usdConversionRates is EqualUnmodifiableListView) return _usdConversionRates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_usdConversionRates);
}


/// Create a copy of ConversionRates
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsdConversionRatesCopyWith<_UsdConversionRates> get copyWith => __$UsdConversionRatesCopyWithImpl<_UsdConversionRates>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsdConversionRates&&const DeepCollectionEquality().equals(other._usdConversionRates, _usdConversionRates));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_usdConversionRates));

@override
String toString() {
  return 'ConversionRates(usdConversionRates: $usdConversionRates)';
}


}

/// @nodoc
abstract mixin class _$UsdConversionRatesCopyWith<$Res> implements $ConversionRatesCopyWith<$Res> {
  factory _$UsdConversionRatesCopyWith(_UsdConversionRates value, $Res Function(_UsdConversionRates) _then) = __$UsdConversionRatesCopyWithImpl;
@override @useResult
$Res call({
 List<ConversionRate> usdConversionRates
});




}
/// @nodoc
class __$UsdConversionRatesCopyWithImpl<$Res>
    implements _$UsdConversionRatesCopyWith<$Res> {
  __$UsdConversionRatesCopyWithImpl(this._self, this._then);

  final _UsdConversionRates _self;
  final $Res Function(_UsdConversionRates) _then;

/// Create a copy of ConversionRates
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? usdConversionRates = null,}) {
  return _then(_UsdConversionRates(
usdConversionRates: null == usdConversionRates ? _self._usdConversionRates : usdConversionRates // ignore: cast_nullable_to_non_nullable
as List<ConversionRate>,
  ));
}


}

// dart format on
