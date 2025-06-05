// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
