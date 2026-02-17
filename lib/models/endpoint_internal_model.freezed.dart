// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'endpoint_internal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EICreateTransaction {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EICreateTransaction);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EICreateTransaction()';
}


}

/// @nodoc
class $EICreateTransactionCopyWith<$Res>  {
$EICreateTransactionCopyWith(EICreateTransaction _, $Res Function(EICreateTransaction) __);
}


/// Adds pattern-matching-related methods to [EICreateTransaction].
extension EICreateTransactionPatterns on EICreateTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EICreateTransactionEmpty value)?  empty,TResult Function( EICreateTransactionData value)?  data,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EICreateTransactionEmpty() when empty != null:
return empty(_that);case EICreateTransactionData() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EICreateTransactionEmpty value)  empty,required TResult Function( EICreateTransactionData value)  data,}){
final _that = this;
switch (_that) {
case EICreateTransactionEmpty():
return empty(_that);case EICreateTransactionData():
return data(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EICreateTransactionEmpty value)?  empty,TResult? Function( EICreateTransactionData value)?  data,}){
final _that = this;
switch (_that) {
case EICreateTransactionEmpty() when empty != null:
return empty(_that);case EICreateTransactionData() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function( String assetId,  String address,  String amount)?  data,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EICreateTransactionEmpty() when empty != null:
return empty();case EICreateTransactionData() when data != null:
return data(_that.assetId,_that.address,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function( String assetId,  String address,  String amount)  data,}) {final _that = this;
switch (_that) {
case EICreateTransactionEmpty():
return empty();case EICreateTransactionData():
return data(_that.assetId,_that.address,_that.amount);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function( String assetId,  String address,  String amount)?  data,}) {final _that = this;
switch (_that) {
case EICreateTransactionEmpty() when empty != null:
return empty();case EICreateTransactionData() when data != null:
return data(_that.assetId,_that.address,_that.amount);case _:
  return null;

}
}

}

/// @nodoc


class EICreateTransactionEmpty implements EICreateTransaction {
   EICreateTransactionEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EICreateTransactionEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EICreateTransaction.empty()';
}


}




/// @nodoc


class EICreateTransactionData implements EICreateTransaction {
   EICreateTransactionData({required this.assetId, required this.address, required this.amount});
  

 final  String assetId;
 final  String address;
 final  String amount;

/// Create a copy of EICreateTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EICreateTransactionDataCopyWith<EICreateTransactionData> get copyWith => _$EICreateTransactionDataCopyWithImpl<EICreateTransactionData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EICreateTransactionData&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.address, address) || other.address == address)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,assetId,address,amount);

@override
String toString() {
  return 'EICreateTransaction.data(assetId: $assetId, address: $address, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $EICreateTransactionDataCopyWith<$Res> implements $EICreateTransactionCopyWith<$Res> {
  factory $EICreateTransactionDataCopyWith(EICreateTransactionData value, $Res Function(EICreateTransactionData) _then) = _$EICreateTransactionDataCopyWithImpl;
@useResult
$Res call({
 String assetId, String address, String amount
});




}
/// @nodoc
class _$EICreateTransactionDataCopyWithImpl<$Res>
    implements $EICreateTransactionDataCopyWith<$Res> {
  _$EICreateTransactionDataCopyWithImpl(this._self, this._then);

  final EICreateTransactionData _self;
  final $Res Function(EICreateTransactionData) _then;

/// Create a copy of EICreateTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? address = null,Object? amount = null,}) {
  return _then(EICreateTransactionData(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
