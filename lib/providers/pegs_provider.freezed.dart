// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

 int get pegInMinimumAmount; int get pegInWalletBalance; bool get pegInWalletBalanceLoaded; int get pegOutMinimumAmount; int get pegOutWalletBalance; double get pegOutNextBlockFeeRate;
/// Create a copy of PegSubscribedValues
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PegSubscribedValuesCopyWith<PegSubscribedValues> get copyWith => _$PegSubscribedValuesCopyWithImpl<PegSubscribedValues>(this as PegSubscribedValues, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegSubscribedValues&&(identical(other.pegInMinimumAmount, pegInMinimumAmount) || other.pegInMinimumAmount == pegInMinimumAmount)&&(identical(other.pegInWalletBalance, pegInWalletBalance) || other.pegInWalletBalance == pegInWalletBalance)&&(identical(other.pegInWalletBalanceLoaded, pegInWalletBalanceLoaded) || other.pegInWalletBalanceLoaded == pegInWalletBalanceLoaded)&&(identical(other.pegOutMinimumAmount, pegOutMinimumAmount) || other.pegOutMinimumAmount == pegOutMinimumAmount)&&(identical(other.pegOutWalletBalance, pegOutWalletBalance) || other.pegOutWalletBalance == pegOutWalletBalance)&&(identical(other.pegOutNextBlockFeeRate, pegOutNextBlockFeeRate) || other.pegOutNextBlockFeeRate == pegOutNextBlockFeeRate));
}


@override
int get hashCode => Object.hash(runtimeType,pegInMinimumAmount,pegInWalletBalance,pegInWalletBalanceLoaded,pegOutMinimumAmount,pegOutWalletBalance,pegOutNextBlockFeeRate);

@override
String toString() {
  return 'PegSubscribedValues(pegInMinimumAmount: $pegInMinimumAmount, pegInWalletBalance: $pegInWalletBalance, pegInWalletBalanceLoaded: $pegInWalletBalanceLoaded, pegOutMinimumAmount: $pegOutMinimumAmount, pegOutWalletBalance: $pegOutWalletBalance, pegOutNextBlockFeeRate: $pegOutNextBlockFeeRate)';
}


}

/// @nodoc
abstract mixin class $PegSubscribedValuesCopyWith<$Res>  {
  factory $PegSubscribedValuesCopyWith(PegSubscribedValues value, $Res Function(PegSubscribedValues) _then) = _$PegSubscribedValuesCopyWithImpl;
@useResult
$Res call({
 int pegInMinimumAmount, int pegInWalletBalance, bool pegInWalletBalanceLoaded, int pegOutMinimumAmount, int pegOutWalletBalance, double pegOutNextBlockFeeRate
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
@pragma('vm:prefer-inline') @override $Res call({Object? pegInMinimumAmount = null,Object? pegInWalletBalance = null,Object? pegInWalletBalanceLoaded = null,Object? pegOutMinimumAmount = null,Object? pegOutWalletBalance = null,Object? pegOutNextBlockFeeRate = null,}) {
  return _then(_self.copyWith(
pegInMinimumAmount: null == pegInMinimumAmount ? _self.pegInMinimumAmount : pegInMinimumAmount // ignore: cast_nullable_to_non_nullable
as int,pegInWalletBalance: null == pegInWalletBalance ? _self.pegInWalletBalance : pegInWalletBalance // ignore: cast_nullable_to_non_nullable
as int,pegInWalletBalanceLoaded: null == pegInWalletBalanceLoaded ? _self.pegInWalletBalanceLoaded : pegInWalletBalanceLoaded // ignore: cast_nullable_to_non_nullable
as bool,pegOutMinimumAmount: null == pegOutMinimumAmount ? _self.pegOutMinimumAmount : pegOutMinimumAmount // ignore: cast_nullable_to_non_nullable
as int,pegOutWalletBalance: null == pegOutWalletBalance ? _self.pegOutWalletBalance : pegOutWalletBalance // ignore: cast_nullable_to_non_nullable
as int,pegOutNextBlockFeeRate: null == pegOutNextBlockFeeRate ? _self.pegOutNextBlockFeeRate : pegOutNextBlockFeeRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PegSubscribedValues].
extension PegSubscribedValuesPatterns on PegSubscribedValues {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PegSubscribedValues value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PegSubscribedValues() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PegSubscribedValues value)  $default,){
final _that = this;
switch (_that) {
case _PegSubscribedValues():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PegSubscribedValues value)?  $default,){
final _that = this;
switch (_that) {
case _PegSubscribedValues() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pegInMinimumAmount,  int pegInWalletBalance,  bool pegInWalletBalanceLoaded,  int pegOutMinimumAmount,  int pegOutWalletBalance,  double pegOutNextBlockFeeRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PegSubscribedValues() when $default != null:
return $default(_that.pegInMinimumAmount,_that.pegInWalletBalance,_that.pegInWalletBalanceLoaded,_that.pegOutMinimumAmount,_that.pegOutWalletBalance,_that.pegOutNextBlockFeeRate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pegInMinimumAmount,  int pegInWalletBalance,  bool pegInWalletBalanceLoaded,  int pegOutMinimumAmount,  int pegOutWalletBalance,  double pegOutNextBlockFeeRate)  $default,) {final _that = this;
switch (_that) {
case _PegSubscribedValues():
return $default(_that.pegInMinimumAmount,_that.pegInWalletBalance,_that.pegInWalletBalanceLoaded,_that.pegOutMinimumAmount,_that.pegOutWalletBalance,_that.pegOutNextBlockFeeRate);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pegInMinimumAmount,  int pegInWalletBalance,  bool pegInWalletBalanceLoaded,  int pegOutMinimumAmount,  int pegOutWalletBalance,  double pegOutNextBlockFeeRate)?  $default,) {final _that = this;
switch (_that) {
case _PegSubscribedValues() when $default != null:
return $default(_that.pegInMinimumAmount,_that.pegInWalletBalance,_that.pegInWalletBalanceLoaded,_that.pegOutMinimumAmount,_that.pegOutWalletBalance,_that.pegOutNextBlockFeeRate);case _:
  return null;

}
}

}

/// @nodoc


class _PegSubscribedValues implements PegSubscribedValues {
  const _PegSubscribedValues({this.pegInMinimumAmount = 0, this.pegInWalletBalance = 0, this.pegInWalletBalanceLoaded = false, this.pegOutMinimumAmount = 0, this.pegOutWalletBalance = 0, this.pegOutNextBlockFeeRate = 0});
  

@override@JsonKey() final  int pegInMinimumAmount;
@override@JsonKey() final  int pegInWalletBalance;
@override@JsonKey() final  bool pegInWalletBalanceLoaded;
@override@JsonKey() final  int pegOutMinimumAmount;
@override@JsonKey() final  int pegOutWalletBalance;
@override@JsonKey() final  double pegOutNextBlockFeeRate;

/// Create a copy of PegSubscribedValues
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PegSubscribedValuesCopyWith<_PegSubscribedValues> get copyWith => __$PegSubscribedValuesCopyWithImpl<_PegSubscribedValues>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PegSubscribedValues&&(identical(other.pegInMinimumAmount, pegInMinimumAmount) || other.pegInMinimumAmount == pegInMinimumAmount)&&(identical(other.pegInWalletBalance, pegInWalletBalance) || other.pegInWalletBalance == pegInWalletBalance)&&(identical(other.pegInWalletBalanceLoaded, pegInWalletBalanceLoaded) || other.pegInWalletBalanceLoaded == pegInWalletBalanceLoaded)&&(identical(other.pegOutMinimumAmount, pegOutMinimumAmount) || other.pegOutMinimumAmount == pegOutMinimumAmount)&&(identical(other.pegOutWalletBalance, pegOutWalletBalance) || other.pegOutWalletBalance == pegOutWalletBalance)&&(identical(other.pegOutNextBlockFeeRate, pegOutNextBlockFeeRate) || other.pegOutNextBlockFeeRate == pegOutNextBlockFeeRate));
}


@override
int get hashCode => Object.hash(runtimeType,pegInMinimumAmount,pegInWalletBalance,pegInWalletBalanceLoaded,pegOutMinimumAmount,pegOutWalletBalance,pegOutNextBlockFeeRate);

@override
String toString() {
  return 'PegSubscribedValues(pegInMinimumAmount: $pegInMinimumAmount, pegInWalletBalance: $pegInWalletBalance, pegInWalletBalanceLoaded: $pegInWalletBalanceLoaded, pegOutMinimumAmount: $pegOutMinimumAmount, pegOutWalletBalance: $pegOutWalletBalance, pegOutNextBlockFeeRate: $pegOutNextBlockFeeRate)';
}


}

/// @nodoc
abstract mixin class _$PegSubscribedValuesCopyWith<$Res> implements $PegSubscribedValuesCopyWith<$Res> {
  factory _$PegSubscribedValuesCopyWith(_PegSubscribedValues value, $Res Function(_PegSubscribedValues) _then) = __$PegSubscribedValuesCopyWithImpl;
@override @useResult
$Res call({
 int pegInMinimumAmount, int pegInWalletBalance, bool pegInWalletBalanceLoaded, int pegOutMinimumAmount, int pegOutWalletBalance, double pegOutNextBlockFeeRate
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
@override @pragma('vm:prefer-inline') $Res call({Object? pegInMinimumAmount = null,Object? pegInWalletBalance = null,Object? pegInWalletBalanceLoaded = null,Object? pegOutMinimumAmount = null,Object? pegOutWalletBalance = null,Object? pegOutNextBlockFeeRate = null,}) {
  return _then(_PegSubscribedValues(
pegInMinimumAmount: null == pegInMinimumAmount ? _self.pegInMinimumAmount : pegInMinimumAmount // ignore: cast_nullable_to_non_nullable
as int,pegInWalletBalance: null == pegInWalletBalance ? _self.pegInWalletBalance : pegInWalletBalance // ignore: cast_nullable_to_non_nullable
as int,pegInWalletBalanceLoaded: null == pegInWalletBalanceLoaded ? _self.pegInWalletBalanceLoaded : pegInWalletBalanceLoaded // ignore: cast_nullable_to_non_nullable
as bool,pegOutMinimumAmount: null == pegOutMinimumAmount ? _self.pegOutMinimumAmount : pegOutMinimumAmount // ignore: cast_nullable_to_non_nullable
as int,pegOutWalletBalance: null == pegOutWalletBalance ? _self.pegOutWalletBalance : pegOutWalletBalance // ignore: cast_nullable_to_non_nullable
as int,pegOutNextBlockFeeRate: null == pegOutNextBlockFeeRate ? _self.pegOutNextBlockFeeRate : pegOutNextBlockFeeRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$PegOrderFeeData {

 Decimal get feeRate; int get bitcoinNetworkFee;
/// Create a copy of PegOrderFeeData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PegOrderFeeDataCopyWith<PegOrderFeeData> get copyWith => _$PegOrderFeeDataCopyWithImpl<PegOrderFeeData>(this as PegOrderFeeData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegOrderFeeData&&(identical(other.feeRate, feeRate) || other.feeRate == feeRate)&&(identical(other.bitcoinNetworkFee, bitcoinNetworkFee) || other.bitcoinNetworkFee == bitcoinNetworkFee));
}


@override
int get hashCode => Object.hash(runtimeType,feeRate,bitcoinNetworkFee);

@override
String toString() {
  return 'PegOrderFeeData(feeRate: $feeRate, bitcoinNetworkFee: $bitcoinNetworkFee)';
}


}

/// @nodoc
abstract mixin class $PegOrderFeeDataCopyWith<$Res>  {
  factory $PegOrderFeeDataCopyWith(PegOrderFeeData value, $Res Function(PegOrderFeeData) _then) = _$PegOrderFeeDataCopyWithImpl;
@useResult
$Res call({
 Decimal feeRate, int bitcoinNetworkFee
});




}
/// @nodoc
class _$PegOrderFeeDataCopyWithImpl<$Res>
    implements $PegOrderFeeDataCopyWith<$Res> {
  _$PegOrderFeeDataCopyWithImpl(this._self, this._then);

  final PegOrderFeeData _self;
  final $Res Function(PegOrderFeeData) _then;

/// Create a copy of PegOrderFeeData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? feeRate = null,Object? bitcoinNetworkFee = null,}) {
  return _then(_self.copyWith(
feeRate: null == feeRate ? _self.feeRate : feeRate // ignore: cast_nullable_to_non_nullable
as Decimal,bitcoinNetworkFee: null == bitcoinNetworkFee ? _self.bitcoinNetworkFee : bitcoinNetworkFee // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PegOrderFeeData].
extension PegOrderFeeDataPatterns on PegOrderFeeData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PegOrderFeeData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PegOrderFeeData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PegOrderFeeData value)  $default,){
final _that = this;
switch (_that) {
case _PegOrderFeeData():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PegOrderFeeData value)?  $default,){
final _that = this;
switch (_that) {
case _PegOrderFeeData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Decimal feeRate,  int bitcoinNetworkFee)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PegOrderFeeData() when $default != null:
return $default(_that.feeRate,_that.bitcoinNetworkFee);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Decimal feeRate,  int bitcoinNetworkFee)  $default,) {final _that = this;
switch (_that) {
case _PegOrderFeeData():
return $default(_that.feeRate,_that.bitcoinNetworkFee);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Decimal feeRate,  int bitcoinNetworkFee)?  $default,) {final _that = this;
switch (_that) {
case _PegOrderFeeData() when $default != null:
return $default(_that.feeRate,_that.bitcoinNetworkFee);case _:
  return null;

}
}

}

/// @nodoc


class _PegOrderFeeData implements PegOrderFeeData {
  const _PegOrderFeeData({required this.feeRate, required this.bitcoinNetworkFee});
  

@override final  Decimal feeRate;
@override final  int bitcoinNetworkFee;

/// Create a copy of PegOrderFeeData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PegOrderFeeDataCopyWith<_PegOrderFeeData> get copyWith => __$PegOrderFeeDataCopyWithImpl<_PegOrderFeeData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PegOrderFeeData&&(identical(other.feeRate, feeRate) || other.feeRate == feeRate)&&(identical(other.bitcoinNetworkFee, bitcoinNetworkFee) || other.bitcoinNetworkFee == bitcoinNetworkFee));
}


@override
int get hashCode => Object.hash(runtimeType,feeRate,bitcoinNetworkFee);

@override
String toString() {
  return 'PegOrderFeeData(feeRate: $feeRate, bitcoinNetworkFee: $bitcoinNetworkFee)';
}


}

/// @nodoc
abstract mixin class _$PegOrderFeeDataCopyWith<$Res> implements $PegOrderFeeDataCopyWith<$Res> {
  factory _$PegOrderFeeDataCopyWith(_PegOrderFeeData value, $Res Function(_PegOrderFeeData) _then) = __$PegOrderFeeDataCopyWithImpl;
@override @useResult
$Res call({
 Decimal feeRate, int bitcoinNetworkFee
});




}
/// @nodoc
class __$PegOrderFeeDataCopyWithImpl<$Res>
    implements _$PegOrderFeeDataCopyWith<$Res> {
  __$PegOrderFeeDataCopyWithImpl(this._self, this._then);

  final _PegOrderFeeData _self;
  final $Res Function(_PegOrderFeeData) _then;

/// Create a copy of PegOrderFeeData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? feeRate = null,Object? bitcoinNetworkFee = null,}) {
  return _then(_PegOrderFeeData(
feeRate: null == feeRate ? _self.feeRate : feeRate // ignore: cast_nullable_to_non_nullable
as Decimal,bitcoinNetworkFee: null == bitcoinNetworkFee ? _self.bitcoinNetworkFee : bitcoinNetworkFee // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PegOutEditFeeRateResult {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegOutEditFeeRateResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegOutEditFeeRateResult()';
}


}

/// @nodoc
class $PegOutEditFeeRateResultCopyWith<$Res>  {
$PegOutEditFeeRateResultCopyWith(PegOutEditFeeRateResult _, $Res Function(PegOutEditFeeRateResult) __);
}


/// Adds pattern-matching-related methods to [PegOutEditFeeRateResult].
extension PegOutEditFeeRateResultPatterns on PegOutEditFeeRateResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _PegOutEditFeeRateResultSuccess value)?  success,TResult Function( _PegOutEditFeeRateResultFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PegOutEditFeeRateResultSuccess() when success != null:
return success(_that);case _PegOutEditFeeRateResultFailure() when failure != null:
return failure(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _PegOutEditFeeRateResultSuccess value)  success,required TResult Function( _PegOutEditFeeRateResultFailure value)  failure,}){
final _that = this;
switch (_that) {
case _PegOutEditFeeRateResultSuccess():
return success(_that);case _PegOutEditFeeRateResultFailure():
return failure(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _PegOutEditFeeRateResultSuccess value)?  success,TResult? Function( _PegOutEditFeeRateResultFailure value)?  failure,}){
final _that = this;
switch (_that) {
case _PegOutEditFeeRateResultSuccess() when success != null:
return success(_that);case _PegOutEditFeeRateResultFailure() when failure != null:
return failure(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  success,TResult Function( String error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PegOutEditFeeRateResultSuccess() when success != null:
return success();case _PegOutEditFeeRateResultFailure() when failure != null:
return failure(_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  success,required TResult Function( String error)  failure,}) {final _that = this;
switch (_that) {
case _PegOutEditFeeRateResultSuccess():
return success();case _PegOutEditFeeRateResultFailure():
return failure(_that.error);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  success,TResult? Function( String error)?  failure,}) {final _that = this;
switch (_that) {
case _PegOutEditFeeRateResultSuccess() when success != null:
return success();case _PegOutEditFeeRateResultFailure() when failure != null:
return failure(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PegOutEditFeeRateResultSuccess implements PegOutEditFeeRateResult {
  const _PegOutEditFeeRateResultSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PegOutEditFeeRateResultSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegOutEditFeeRateResult.success()';
}


}




/// @nodoc


class _PegOutEditFeeRateResultFailure implements PegOutEditFeeRateResult {
  const _PegOutEditFeeRateResultFailure(this.error);
  

 final  String error;

/// Create a copy of PegOutEditFeeRateResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PegOutEditFeeRateResultFailureCopyWith<_PegOutEditFeeRateResultFailure> get copyWith => __$PegOutEditFeeRateResultFailureCopyWithImpl<_PegOutEditFeeRateResultFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PegOutEditFeeRateResultFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'PegOutEditFeeRateResult.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class _$PegOutEditFeeRateResultFailureCopyWith<$Res> implements $PegOutEditFeeRateResultCopyWith<$Res> {
  factory _$PegOutEditFeeRateResultFailureCopyWith(_PegOutEditFeeRateResultFailure value, $Res Function(_PegOutEditFeeRateResultFailure) _then) = __$PegOutEditFeeRateResultFailureCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$PegOutEditFeeRateResultFailureCopyWithImpl<$Res>
    implements _$PegOutEditFeeRateResultFailureCopyWith<$Res> {
  __$PegOutEditFeeRateResultFailureCopyWithImpl(this._self, this._then);

  final _PegOutEditFeeRateResultFailure _self;
  final $Res Function(_PegOutEditFeeRateResultFailure) _then;

/// Create a copy of PegOutEditFeeRateResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_PegOutEditFeeRateResultFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
