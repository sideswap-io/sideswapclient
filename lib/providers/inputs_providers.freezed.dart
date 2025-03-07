// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inputs_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InputsWalletTypeFlag {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InputsWalletTypeFlag);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InputsWalletTypeFlag()';
}


}

/// @nodoc
class $InputsWalletTypeFlagCopyWith<$Res>  {
$InputsWalletTypeFlagCopyWith(InputsWalletTypeFlag _, $Res Function(InputsWalletTypeFlag) __);
}


/// @nodoc


class InputsWalletTypeFlagRegular implements InputsWalletTypeFlag {
  const InputsWalletTypeFlagRegular();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InputsWalletTypeFlagRegular);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InputsWalletTypeFlag.regular()';
}


}




/// @nodoc


class InputsWalletTypeFlagAmp implements InputsWalletTypeFlag {
  const InputsWalletTypeFlagAmp();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InputsWalletTypeFlagAmp);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InputsWalletTypeFlag.amp()';
}


}




/// @nodoc
mixin _$InputsTxItem {

 String? get tx; int? get satoshi;
/// Create a copy of InputsTxItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InputsTxItemCopyWith<InputsTxItem> get copyWith => _$InputsTxItemCopyWithImpl<InputsTxItem>(this as InputsTxItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InputsTxItem&&(identical(other.tx, tx) || other.tx == tx)&&(identical(other.satoshi, satoshi) || other.satoshi == satoshi));
}


@override
int get hashCode => Object.hash(runtimeType,tx,satoshi);

@override
String toString() {
  return 'InputsTxItem(tx: $tx, satoshi: $satoshi)';
}


}

/// @nodoc
abstract mixin class $InputsTxItemCopyWith<$Res>  {
  factory $InputsTxItemCopyWith(InputsTxItem value, $Res Function(InputsTxItem) _then) = _$InputsTxItemCopyWithImpl;
@useResult
$Res call({
 String? tx, int? satoshi
});




}
/// @nodoc
class _$InputsTxItemCopyWithImpl<$Res>
    implements $InputsTxItemCopyWith<$Res> {
  _$InputsTxItemCopyWithImpl(this._self, this._then);

  final InputsTxItem _self;
  final $Res Function(InputsTxItem) _then;

/// Create a copy of InputsTxItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tx = freezed,Object? satoshi = freezed,}) {
  return _then(_self.copyWith(
tx: freezed == tx ? _self.tx : tx // ignore: cast_nullable_to_non_nullable
as String?,satoshi: freezed == satoshi ? _self.satoshi : satoshi // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc


class _InputsTxItem implements InputsTxItem {
  const _InputsTxItem({this.tx, this.satoshi});
  

@override final  String? tx;
@override final  int? satoshi;

/// Create a copy of InputsTxItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InputsTxItemCopyWith<_InputsTxItem> get copyWith => __$InputsTxItemCopyWithImpl<_InputsTxItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InputsTxItem&&(identical(other.tx, tx) || other.tx == tx)&&(identical(other.satoshi, satoshi) || other.satoshi == satoshi));
}


@override
int get hashCode => Object.hash(runtimeType,tx,satoshi);

@override
String toString() {
  return 'InputsTxItem(tx: $tx, satoshi: $satoshi)';
}


}

/// @nodoc
abstract mixin class _$InputsTxItemCopyWith<$Res> implements $InputsTxItemCopyWith<$Res> {
  factory _$InputsTxItemCopyWith(_InputsTxItem value, $Res Function(_InputsTxItem) _then) = __$InputsTxItemCopyWithImpl;
@override @useResult
$Res call({
 String? tx, int? satoshi
});




}
/// @nodoc
class __$InputsTxItemCopyWithImpl<$Res>
    implements _$InputsTxItemCopyWith<$Res> {
  __$InputsTxItemCopyWithImpl(this._self, this._then);

  final _InputsTxItem _self;
  final $Res Function(_InputsTxItem) _then;

/// Create a copy of InputsTxItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tx = freezed,Object? satoshi = freezed,}) {
  return _then(_InputsTxItem(
tx: freezed == tx ? _self.tx : tx // ignore: cast_nullable_to_non_nullable
as String?,satoshi: freezed == satoshi ? _self.satoshi : satoshi // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$InputsAddressItem {

 String? get address; int? get txAmount; String? get comment; int? get satoshi; List<InputsTxItem>? get inputsTx;
/// Create a copy of InputsAddressItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InputsAddressItemCopyWith<InputsAddressItem> get copyWith => _$InputsAddressItemCopyWithImpl<InputsAddressItem>(this as InputsAddressItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InputsAddressItem&&(identical(other.address, address) || other.address == address)&&(identical(other.txAmount, txAmount) || other.txAmount == txAmount)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.satoshi, satoshi) || other.satoshi == satoshi)&&const DeepCollectionEquality().equals(other.inputsTx, inputsTx));
}


@override
int get hashCode => Object.hash(runtimeType,address,txAmount,comment,satoshi,const DeepCollectionEquality().hash(inputsTx));

@override
String toString() {
  return 'InputsAddressItem(address: $address, txAmount: $txAmount, comment: $comment, satoshi: $satoshi, inputsTx: $inputsTx)';
}


}

/// @nodoc
abstract mixin class $InputsAddressItemCopyWith<$Res>  {
  factory $InputsAddressItemCopyWith(InputsAddressItem value, $Res Function(InputsAddressItem) _then) = _$InputsAddressItemCopyWithImpl;
@useResult
$Res call({
 String? address, int? txAmount, String? comment, int? satoshi, List<InputsTxItem>? inputsTx
});




}
/// @nodoc
class _$InputsAddressItemCopyWithImpl<$Res>
    implements $InputsAddressItemCopyWith<$Res> {
  _$InputsAddressItemCopyWithImpl(this._self, this._then);

  final InputsAddressItem _self;
  final $Res Function(InputsAddressItem) _then;

/// Create a copy of InputsAddressItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = freezed,Object? txAmount = freezed,Object? comment = freezed,Object? satoshi = freezed,Object? inputsTx = freezed,}) {
  return _then(_self.copyWith(
address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,txAmount: freezed == txAmount ? _self.txAmount : txAmount // ignore: cast_nullable_to_non_nullable
as int?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,satoshi: freezed == satoshi ? _self.satoshi : satoshi // ignore: cast_nullable_to_non_nullable
as int?,inputsTx: freezed == inputsTx ? _self.inputsTx : inputsTx // ignore: cast_nullable_to_non_nullable
as List<InputsTxItem>?,
  ));
}

}


/// @nodoc


class _InputsAddressItem implements InputsAddressItem {
  const _InputsAddressItem({this.address, this.txAmount, this.comment, this.satoshi, final  List<InputsTxItem>? inputsTx}): _inputsTx = inputsTx;
  

@override final  String? address;
@override final  int? txAmount;
@override final  String? comment;
@override final  int? satoshi;
 final  List<InputsTxItem>? _inputsTx;
@override List<InputsTxItem>? get inputsTx {
  final value = _inputsTx;
  if (value == null) return null;
  if (_inputsTx is EqualUnmodifiableListView) return _inputsTx;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of InputsAddressItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InputsAddressItemCopyWith<_InputsAddressItem> get copyWith => __$InputsAddressItemCopyWithImpl<_InputsAddressItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InputsAddressItem&&(identical(other.address, address) || other.address == address)&&(identical(other.txAmount, txAmount) || other.txAmount == txAmount)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.satoshi, satoshi) || other.satoshi == satoshi)&&const DeepCollectionEquality().equals(other._inputsTx, _inputsTx));
}


@override
int get hashCode => Object.hash(runtimeType,address,txAmount,comment,satoshi,const DeepCollectionEquality().hash(_inputsTx));

@override
String toString() {
  return 'InputsAddressItem(address: $address, txAmount: $txAmount, comment: $comment, satoshi: $satoshi, inputsTx: $inputsTx)';
}


}

/// @nodoc
abstract mixin class _$InputsAddressItemCopyWith<$Res> implements $InputsAddressItemCopyWith<$Res> {
  factory _$InputsAddressItemCopyWith(_InputsAddressItem value, $Res Function(_InputsAddressItem) _then) = __$InputsAddressItemCopyWithImpl;
@override @useResult
$Res call({
 String? address, int? txAmount, String? comment, int? satoshi, List<InputsTxItem>? inputsTx
});




}
/// @nodoc
class __$InputsAddressItemCopyWithImpl<$Res>
    implements _$InputsAddressItemCopyWith<$Res> {
  __$InputsAddressItemCopyWithImpl(this._self, this._then);

  final _InputsAddressItem _self;
  final $Res Function(_InputsAddressItem) _then;

/// Create a copy of InputsAddressItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = freezed,Object? txAmount = freezed,Object? comment = freezed,Object? satoshi = freezed,Object? inputsTx = freezed,}) {
  return _then(_InputsAddressItem(
address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,txAmount: freezed == txAmount ? _self.txAmount : txAmount // ignore: cast_nullable_to_non_nullable
as int?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,satoshi: freezed == satoshi ? _self.satoshi : satoshi // ignore: cast_nullable_to_non_nullable
as int?,inputsTx: freezed == inputsTx ? _self._inputsTx : inputsTx // ignore: cast_nullable_to_non_nullable
as List<InputsTxItem>?,
  ));
}


}

/// @nodoc
mixin _$InputsItem {

 List<InputsAddressItem>? get inputs;
/// Create a copy of InputsItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InputsItemCopyWith<InputsItem> get copyWith => _$InputsItemCopyWithImpl<InputsItem>(this as InputsItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InputsItem&&const DeepCollectionEquality().equals(other.inputs, inputs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(inputs));

@override
String toString() {
  return 'InputsItem(inputs: $inputs)';
}


}

/// @nodoc
abstract mixin class $InputsItemCopyWith<$Res>  {
  factory $InputsItemCopyWith(InputsItem value, $Res Function(InputsItem) _then) = _$InputsItemCopyWithImpl;
@useResult
$Res call({
 List<InputsAddressItem>? inputs
});




}
/// @nodoc
class _$InputsItemCopyWithImpl<$Res>
    implements $InputsItemCopyWith<$Res> {
  _$InputsItemCopyWithImpl(this._self, this._then);

  final InputsItem _self;
  final $Res Function(InputsItem) _then;

/// Create a copy of InputsItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inputs = freezed,}) {
  return _then(_self.copyWith(
inputs: freezed == inputs ? _self.inputs : inputs // ignore: cast_nullable_to_non_nullable
as List<InputsAddressItem>?,
  ));
}

}


/// @nodoc


class _InputsItem implements InputsItem {
  const _InputsItem({final  List<InputsAddressItem>? inputs}): _inputs = inputs;
  

 final  List<InputsAddressItem>? _inputs;
@override List<InputsAddressItem>? get inputs {
  final value = _inputs;
  if (value == null) return null;
  if (_inputs is EqualUnmodifiableListView) return _inputs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of InputsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InputsItemCopyWith<_InputsItem> get copyWith => __$InputsItemCopyWithImpl<_InputsItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InputsItem&&const DeepCollectionEquality().equals(other._inputs, _inputs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_inputs));

@override
String toString() {
  return 'InputsItem(inputs: $inputs)';
}


}

/// @nodoc
abstract mixin class _$InputsItemCopyWith<$Res> implements $InputsItemCopyWith<$Res> {
  factory _$InputsItemCopyWith(_InputsItem value, $Res Function(_InputsItem) _then) = __$InputsItemCopyWithImpl;
@override @useResult
$Res call({
 List<InputsAddressItem>? inputs
});




}
/// @nodoc
class __$InputsItemCopyWithImpl<$Res>
    implements _$InputsItemCopyWith<$Res> {
  __$InputsItemCopyWithImpl(this._self, this._then);

  final _InputsItem _self;
  final $Res Function(_InputsItem) _then;

/// Create a copy of InputsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputs = freezed,}) {
  return _then(_InputsItem(
inputs: freezed == inputs ? _self._inputs : inputs // ignore: cast_nullable_to_non_nullable
as List<InputsAddressItem>?,
  ));
}


}

// dart format on
