// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pegs_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PegSubscribedValues {

 int get pegInMinimumAmount; int get pegInWalletBalance; int get pegOutMinimumAmount; int get pegOutWalletBalance;
/// Create a copy of PegSubscribedValues
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PegSubscribedValuesCopyWith<PegSubscribedValues> get copyWith => _$PegSubscribedValuesCopyWithImpl<PegSubscribedValues>(this as PegSubscribedValues, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegSubscribedValues&&(identical(other.pegInMinimumAmount, pegInMinimumAmount) || other.pegInMinimumAmount == pegInMinimumAmount)&&(identical(other.pegInWalletBalance, pegInWalletBalance) || other.pegInWalletBalance == pegInWalletBalance)&&(identical(other.pegOutMinimumAmount, pegOutMinimumAmount) || other.pegOutMinimumAmount == pegOutMinimumAmount)&&(identical(other.pegOutWalletBalance, pegOutWalletBalance) || other.pegOutWalletBalance == pegOutWalletBalance));
}


@override
int get hashCode => Object.hash(runtimeType,pegInMinimumAmount,pegInWalletBalance,pegOutMinimumAmount,pegOutWalletBalance);

@override
String toString() {
  return 'PegSubscribedValues(pegInMinimumAmount: $pegInMinimumAmount, pegInWalletBalance: $pegInWalletBalance, pegOutMinimumAmount: $pegOutMinimumAmount, pegOutWalletBalance: $pegOutWalletBalance)';
}


}

/// @nodoc
abstract mixin class $PegSubscribedValuesCopyWith<$Res>  {
  factory $PegSubscribedValuesCopyWith(PegSubscribedValues value, $Res Function(PegSubscribedValues) _then) = _$PegSubscribedValuesCopyWithImpl;
@useResult
$Res call({
 int pegInMinimumAmount, int pegInWalletBalance, int pegOutMinimumAmount, int pegOutWalletBalance
});




}
/// @nodoc
class _$PegSubscribedValuesCopyWithImpl<$Res>
    implements $PegSubscribedValuesCopyWith<$Res> {
  _$PegSubscribedValuesCopyWithImpl(this._self, this._then);

  final PegSubscribedValues _self;
  final $Res Function(PegSubscribedValues) _then;

/// Create a copy of PegSubscribedValues
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pegInMinimumAmount = null,Object? pegInWalletBalance = null,Object? pegOutMinimumAmount = null,Object? pegOutWalletBalance = null,}) {
  return _then(_self.copyWith(
pegInMinimumAmount: null == pegInMinimumAmount ? _self.pegInMinimumAmount : pegInMinimumAmount // ignore: cast_nullable_to_non_nullable
as int,pegInWalletBalance: null == pegInWalletBalance ? _self.pegInWalletBalance : pegInWalletBalance // ignore: cast_nullable_to_non_nullable
as int,pegOutMinimumAmount: null == pegOutMinimumAmount ? _self.pegOutMinimumAmount : pegOutMinimumAmount // ignore: cast_nullable_to_non_nullable
as int,pegOutWalletBalance: null == pegOutWalletBalance ? _self.pegOutWalletBalance : pegOutWalletBalance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _PegSubscribedValues implements PegSubscribedValues {
  const _PegSubscribedValues({this.pegInMinimumAmount = 0, this.pegInWalletBalance = 0, this.pegOutMinimumAmount = 0, this.pegOutWalletBalance = 0});
  

@override@JsonKey() final  int pegInMinimumAmount;
@override@JsonKey() final  int pegInWalletBalance;
@override@JsonKey() final  int pegOutMinimumAmount;
@override@JsonKey() final  int pegOutWalletBalance;

/// Create a copy of PegSubscribedValues
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PegSubscribedValuesCopyWith<_PegSubscribedValues> get copyWith => __$PegSubscribedValuesCopyWithImpl<_PegSubscribedValues>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PegSubscribedValues&&(identical(other.pegInMinimumAmount, pegInMinimumAmount) || other.pegInMinimumAmount == pegInMinimumAmount)&&(identical(other.pegInWalletBalance, pegInWalletBalance) || other.pegInWalletBalance == pegInWalletBalance)&&(identical(other.pegOutMinimumAmount, pegOutMinimumAmount) || other.pegOutMinimumAmount == pegOutMinimumAmount)&&(identical(other.pegOutWalletBalance, pegOutWalletBalance) || other.pegOutWalletBalance == pegOutWalletBalance));
}


@override
int get hashCode => Object.hash(runtimeType,pegInMinimumAmount,pegInWalletBalance,pegOutMinimumAmount,pegOutWalletBalance);

@override
String toString() {
  return 'PegSubscribedValues(pegInMinimumAmount: $pegInMinimumAmount, pegInWalletBalance: $pegInWalletBalance, pegOutMinimumAmount: $pegOutMinimumAmount, pegOutWalletBalance: $pegOutWalletBalance)';
}


}

/// @nodoc
abstract mixin class _$PegSubscribedValuesCopyWith<$Res> implements $PegSubscribedValuesCopyWith<$Res> {
  factory _$PegSubscribedValuesCopyWith(_PegSubscribedValues value, $Res Function(_PegSubscribedValues) _then) = __$PegSubscribedValuesCopyWithImpl;
@override @useResult
$Res call({
 int pegInMinimumAmount, int pegInWalletBalance, int pegOutMinimumAmount, int pegOutWalletBalance
});




}
/// @nodoc
class __$PegSubscribedValuesCopyWithImpl<$Res>
    implements _$PegSubscribedValuesCopyWith<$Res> {
  __$PegSubscribedValuesCopyWithImpl(this._self, this._then);

  final _PegSubscribedValues _self;
  final $Res Function(_PegSubscribedValues) _then;

/// Create a copy of PegSubscribedValues
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pegInMinimumAmount = null,Object? pegInWalletBalance = null,Object? pegOutMinimumAmount = null,Object? pegOutWalletBalance = null,}) {
  return _then(_PegSubscribedValues(
pegInMinimumAmount: null == pegInMinimumAmount ? _self.pegInMinimumAmount : pegInMinimumAmount // ignore: cast_nullable_to_non_nullable
as int,pegInWalletBalance: null == pegInWalletBalance ? _self.pegInWalletBalance : pegInWalletBalance // ignore: cast_nullable_to_non_nullable
as int,pegOutMinimumAmount: null == pegOutMinimumAmount ? _self.pegOutMinimumAmount : pegOutMinimumAmount // ignore: cast_nullable_to_non_nullable
as int,pegOutWalletBalance: null == pegOutWalletBalance ? _self.pegOutWalletBalance : pegOutWalletBalance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
