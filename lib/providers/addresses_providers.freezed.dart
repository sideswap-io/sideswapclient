// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'addresses_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UtxosItem {

 String? get txid; int? get vout; String? get assetId; int? get amount; bool? get isInternal; bool? get isConfidential; Account? get account;
/// Create a copy of UtxosItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UtxosItemCopyWith<UtxosItem> get copyWith => _$UtxosItemCopyWithImpl<UtxosItem>(this as UtxosItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UtxosItem&&(identical(other.txid, txid) || other.txid == txid)&&(identical(other.vout, vout) || other.vout == vout)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.isInternal, isInternal) || other.isInternal == isInternal)&&(identical(other.isConfidential, isConfidential) || other.isConfidential == isConfidential)&&(identical(other.account, account) || other.account == account));
}


@override
int get hashCode => Object.hash(runtimeType,txid,vout,assetId,amount,isInternal,isConfidential,account);

@override
String toString() {
  return 'UtxosItem(txid: $txid, vout: $vout, assetId: $assetId, amount: $amount, isInternal: $isInternal, isConfidential: $isConfidential, account: $account)';
}


}

/// @nodoc
abstract mixin class $UtxosItemCopyWith<$Res>  {
  factory $UtxosItemCopyWith(UtxosItem value, $Res Function(UtxosItem) _then) = _$UtxosItemCopyWithImpl;
@useResult
$Res call({
 String? txid, int? vout, String? assetId, int? amount, bool? isInternal, bool? isConfidential, Account? account
});




}
/// @nodoc
class _$UtxosItemCopyWithImpl<$Res>
    implements $UtxosItemCopyWith<$Res> {
  _$UtxosItemCopyWithImpl(this._self, this._then);

  final UtxosItem _self;
  final $Res Function(UtxosItem) _then;

/// Create a copy of UtxosItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? txid = freezed,Object? vout = freezed,Object? assetId = freezed,Object? amount = freezed,Object? isInternal = freezed,Object? isConfidential = freezed,Object? account = freezed,}) {
  return _then(_self.copyWith(
txid: freezed == txid ? _self.txid : txid // ignore: cast_nullable_to_non_nullable
as String?,vout: freezed == vout ? _self.vout : vout // ignore: cast_nullable_to_non_nullable
as int?,assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,isInternal: freezed == isInternal ? _self.isInternal : isInternal // ignore: cast_nullable_to_non_nullable
as bool?,isConfidential: freezed == isConfidential ? _self.isConfidential : isConfidential // ignore: cast_nullable_to_non_nullable
as bool?,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account?,
  ));
}

}


/// Adds pattern-matching-related methods to [UtxosItem].
extension UtxosItemPatterns on UtxosItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UtxosItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UtxosItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UtxosItem value)  $default,){
final _that = this;
switch (_that) {
case _UtxosItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UtxosItem value)?  $default,){
final _that = this;
switch (_that) {
case _UtxosItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? txid,  int? vout,  String? assetId,  int? amount,  bool? isInternal,  bool? isConfidential,  Account? account)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UtxosItem() when $default != null:
return $default(_that.txid,_that.vout,_that.assetId,_that.amount,_that.isInternal,_that.isConfidential,_that.account);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? txid,  int? vout,  String? assetId,  int? amount,  bool? isInternal,  bool? isConfidential,  Account? account)  $default,) {final _that = this;
switch (_that) {
case _UtxosItem():
return $default(_that.txid,_that.vout,_that.assetId,_that.amount,_that.isInternal,_that.isConfidential,_that.account);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? txid,  int? vout,  String? assetId,  int? amount,  bool? isInternal,  bool? isConfidential,  Account? account)?  $default,) {final _that = this;
switch (_that) {
case _UtxosItem() when $default != null:
return $default(_that.txid,_that.vout,_that.assetId,_that.amount,_that.isInternal,_that.isConfidential,_that.account);case _:
  return null;

}
}

}

/// @nodoc


class _UtxosItem implements UtxosItem {
  const _UtxosItem({this.txid, this.vout, this.assetId, this.amount, this.isInternal, this.isConfidential, this.account});
  

@override final  String? txid;
@override final  int? vout;
@override final  String? assetId;
@override final  int? amount;
@override final  bool? isInternal;
@override final  bool? isConfidential;
@override final  Account? account;

/// Create a copy of UtxosItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UtxosItemCopyWith<_UtxosItem> get copyWith => __$UtxosItemCopyWithImpl<_UtxosItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UtxosItem&&(identical(other.txid, txid) || other.txid == txid)&&(identical(other.vout, vout) || other.vout == vout)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.isInternal, isInternal) || other.isInternal == isInternal)&&(identical(other.isConfidential, isConfidential) || other.isConfidential == isConfidential)&&(identical(other.account, account) || other.account == account));
}


@override
int get hashCode => Object.hash(runtimeType,txid,vout,assetId,amount,isInternal,isConfidential,account);

@override
String toString() {
  return 'UtxosItem(txid: $txid, vout: $vout, assetId: $assetId, amount: $amount, isInternal: $isInternal, isConfidential: $isConfidential, account: $account)';
}


}

/// @nodoc
abstract mixin class _$UtxosItemCopyWith<$Res> implements $UtxosItemCopyWith<$Res> {
  factory _$UtxosItemCopyWith(_UtxosItem value, $Res Function(_UtxosItem) _then) = __$UtxosItemCopyWithImpl;
@override @useResult
$Res call({
 String? txid, int? vout, String? assetId, int? amount, bool? isInternal, bool? isConfidential, Account? account
});




}
/// @nodoc
class __$UtxosItemCopyWithImpl<$Res>
    implements _$UtxosItemCopyWith<$Res> {
  __$UtxosItemCopyWithImpl(this._self, this._then);

  final _UtxosItem _self;
  final $Res Function(_UtxosItem) _then;

/// Create a copy of UtxosItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? txid = freezed,Object? vout = freezed,Object? assetId = freezed,Object? amount = freezed,Object? isInternal = freezed,Object? isConfidential = freezed,Object? account = freezed,}) {
  return _then(_UtxosItem(
txid: freezed == txid ? _self.txid : txid // ignore: cast_nullable_to_non_nullable
as String?,vout: freezed == vout ? _self.vout : vout // ignore: cast_nullable_to_non_nullable
as int?,assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int?,isInternal: freezed == isInternal ? _self.isInternal : isInternal // ignore: cast_nullable_to_non_nullable
as bool?,isConfidential: freezed == isConfidential ? _self.isConfidential : isConfidential // ignore: cast_nullable_to_non_nullable
as bool?,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account?,
  ));
}


}

/// @nodoc
mixin _$AddressesItem {

 Account? get account; String? get address; String? get unconfidentialAddress; int? get index; bool? get isInternal; List<UtxosItem>? get utxos;
/// Create a copy of AddressesItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressesItemCopyWith<AddressesItem> get copyWith => _$AddressesItemCopyWithImpl<AddressesItem>(this as AddressesItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesItem&&(identical(other.account, account) || other.account == account)&&(identical(other.address, address) || other.address == address)&&(identical(other.unconfidentialAddress, unconfidentialAddress) || other.unconfidentialAddress == unconfidentialAddress)&&(identical(other.index, index) || other.index == index)&&(identical(other.isInternal, isInternal) || other.isInternal == isInternal)&&const DeepCollectionEquality().equals(other.utxos, utxos));
}


@override
int get hashCode => Object.hash(runtimeType,account,address,unconfidentialAddress,index,isInternal,const DeepCollectionEquality().hash(utxos));

@override
String toString() {
  return 'AddressesItem(account: $account, address: $address, unconfidentialAddress: $unconfidentialAddress, index: $index, isInternal: $isInternal, utxos: $utxos)';
}


}

/// @nodoc
abstract mixin class $AddressesItemCopyWith<$Res>  {
  factory $AddressesItemCopyWith(AddressesItem value, $Res Function(AddressesItem) _then) = _$AddressesItemCopyWithImpl;
@useResult
$Res call({
 Account? account, String? address, String? unconfidentialAddress, int? index, bool? isInternal, List<UtxosItem>? utxos
});




}
/// @nodoc
class _$AddressesItemCopyWithImpl<$Res>
    implements $AddressesItemCopyWith<$Res> {
  _$AddressesItemCopyWithImpl(this._self, this._then);

  final AddressesItem _self;
  final $Res Function(AddressesItem) _then;

/// Create a copy of AddressesItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? account = freezed,Object? address = freezed,Object? unconfidentialAddress = freezed,Object? index = freezed,Object? isInternal = freezed,Object? utxos = freezed,}) {
  return _then(_self.copyWith(
account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,unconfidentialAddress: freezed == unconfidentialAddress ? _self.unconfidentialAddress : unconfidentialAddress // ignore: cast_nullable_to_non_nullable
as String?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,isInternal: freezed == isInternal ? _self.isInternal : isInternal // ignore: cast_nullable_to_non_nullable
as bool?,utxos: freezed == utxos ? _self.utxos : utxos // ignore: cast_nullable_to_non_nullable
as List<UtxosItem>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddressesItem].
extension AddressesItemPatterns on AddressesItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressesItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressesItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressesItem value)  $default,){
final _that = this;
switch (_that) {
case _AddressesItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressesItem value)?  $default,){
final _that = this;
switch (_that) {
case _AddressesItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Account? account,  String? address,  String? unconfidentialAddress,  int? index,  bool? isInternal,  List<UtxosItem>? utxos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressesItem() when $default != null:
return $default(_that.account,_that.address,_that.unconfidentialAddress,_that.index,_that.isInternal,_that.utxos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Account? account,  String? address,  String? unconfidentialAddress,  int? index,  bool? isInternal,  List<UtxosItem>? utxos)  $default,) {final _that = this;
switch (_that) {
case _AddressesItem():
return $default(_that.account,_that.address,_that.unconfidentialAddress,_that.index,_that.isInternal,_that.utxos);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Account? account,  String? address,  String? unconfidentialAddress,  int? index,  bool? isInternal,  List<UtxosItem>? utxos)?  $default,) {final _that = this;
switch (_that) {
case _AddressesItem() when $default != null:
return $default(_that.account,_that.address,_that.unconfidentialAddress,_that.index,_that.isInternal,_that.utxos);case _:
  return null;

}
}

}

/// @nodoc


class _AddressesItem implements AddressesItem {
  const _AddressesItem({this.account, this.address, this.unconfidentialAddress, this.index, this.isInternal, final  List<UtxosItem>? utxos}): _utxos = utxos;
  

@override final  Account? account;
@override final  String? address;
@override final  String? unconfidentialAddress;
@override final  int? index;
@override final  bool? isInternal;
 final  List<UtxosItem>? _utxos;
@override List<UtxosItem>? get utxos {
  final value = _utxos;
  if (value == null) return null;
  if (_utxos is EqualUnmodifiableListView) return _utxos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AddressesItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressesItemCopyWith<_AddressesItem> get copyWith => __$AddressesItemCopyWithImpl<_AddressesItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressesItem&&(identical(other.account, account) || other.account == account)&&(identical(other.address, address) || other.address == address)&&(identical(other.unconfidentialAddress, unconfidentialAddress) || other.unconfidentialAddress == unconfidentialAddress)&&(identical(other.index, index) || other.index == index)&&(identical(other.isInternal, isInternal) || other.isInternal == isInternal)&&const DeepCollectionEquality().equals(other._utxos, _utxos));
}


@override
int get hashCode => Object.hash(runtimeType,account,address,unconfidentialAddress,index,isInternal,const DeepCollectionEquality().hash(_utxos));

@override
String toString() {
  return 'AddressesItem(account: $account, address: $address, unconfidentialAddress: $unconfidentialAddress, index: $index, isInternal: $isInternal, utxos: $utxos)';
}


}

/// @nodoc
abstract mixin class _$AddressesItemCopyWith<$Res> implements $AddressesItemCopyWith<$Res> {
  factory _$AddressesItemCopyWith(_AddressesItem value, $Res Function(_AddressesItem) _then) = __$AddressesItemCopyWithImpl;
@override @useResult
$Res call({
 Account? account, String? address, String? unconfidentialAddress, int? index, bool? isInternal, List<UtxosItem>? utxos
});




}
/// @nodoc
class __$AddressesItemCopyWithImpl<$Res>
    implements _$AddressesItemCopyWith<$Res> {
  __$AddressesItemCopyWithImpl(this._self, this._then);

  final _AddressesItem _self;
  final $Res Function(_AddressesItem) _then;

/// Create a copy of AddressesItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? account = freezed,Object? address = freezed,Object? unconfidentialAddress = freezed,Object? index = freezed,Object? isInternal = freezed,Object? utxos = freezed,}) {
  return _then(_AddressesItem(
account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,unconfidentialAddress: freezed == unconfidentialAddress ? _self.unconfidentialAddress : unconfidentialAddress // ignore: cast_nullable_to_non_nullable
as String?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,isInternal: freezed == isInternal ? _self.isInternal : isInternal // ignore: cast_nullable_to_non_nullable
as bool?,utxos: freezed == utxos ? _self._utxos : utxos // ignore: cast_nullable_to_non_nullable
as List<UtxosItem>?,
  ));
}


}

/// @nodoc
mixin _$AddressesModel {

 List<AddressesItem>? get addresses;
/// Create a copy of AddressesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressesModelCopyWith<AddressesModel> get copyWith => _$AddressesModelCopyWithImpl<AddressesModel>(this as AddressesModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesModel&&const DeepCollectionEquality().equals(other.addresses, addresses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(addresses));

@override
String toString() {
  return 'AddressesModel(addresses: $addresses)';
}


}

/// @nodoc
abstract mixin class $AddressesModelCopyWith<$Res>  {
  factory $AddressesModelCopyWith(AddressesModel value, $Res Function(AddressesModel) _then) = _$AddressesModelCopyWithImpl;
@useResult
$Res call({
 List<AddressesItem>? addresses
});




}
/// @nodoc
class _$AddressesModelCopyWithImpl<$Res>
    implements $AddressesModelCopyWith<$Res> {
  _$AddressesModelCopyWithImpl(this._self, this._then);

  final AddressesModel _self;
  final $Res Function(AddressesModel) _then;

/// Create a copy of AddressesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? addresses = freezed,}) {
  return _then(_self.copyWith(
addresses: freezed == addresses ? _self.addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<AddressesItem>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddressesModel].
extension AddressesModelPatterns on AddressesModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressesModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressesModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressesModel value)  $default,){
final _that = this;
switch (_that) {
case _AddressesModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressesModel value)?  $default,){
final _that = this;
switch (_that) {
case _AddressesModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AddressesItem>? addresses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressesModel() when $default != null:
return $default(_that.addresses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AddressesItem>? addresses)  $default,) {final _that = this;
switch (_that) {
case _AddressesModel():
return $default(_that.addresses);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AddressesItem>? addresses)?  $default,) {final _that = this;
switch (_that) {
case _AddressesModel() when $default != null:
return $default(_that.addresses);case _:
  return null;

}
}

}

/// @nodoc


class _AddressesModel implements AddressesModel {
  const _AddressesModel({final  List<AddressesItem>? addresses}): _addresses = addresses;
  

 final  List<AddressesItem>? _addresses;
@override List<AddressesItem>? get addresses {
  final value = _addresses;
  if (value == null) return null;
  if (_addresses is EqualUnmodifiableListView) return _addresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AddressesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressesModelCopyWith<_AddressesModel> get copyWith => __$AddressesModelCopyWithImpl<_AddressesModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressesModel&&const DeepCollectionEquality().equals(other._addresses, _addresses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_addresses));

@override
String toString() {
  return 'AddressesModel(addresses: $addresses)';
}


}

/// @nodoc
abstract mixin class _$AddressesModelCopyWith<$Res> implements $AddressesModelCopyWith<$Res> {
  factory _$AddressesModelCopyWith(_AddressesModel value, $Res Function(_AddressesModel) _then) = __$AddressesModelCopyWithImpl;
@override @useResult
$Res call({
 List<AddressesItem>? addresses
});




}
/// @nodoc
class __$AddressesModelCopyWithImpl<$Res>
    implements _$AddressesModelCopyWith<$Res> {
  __$AddressesModelCopyWithImpl(this._self, this._then);

  final _AddressesModel _self;
  final $Res Function(_AddressesModel) _then;

/// Create a copy of AddressesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? addresses = freezed,}) {
  return _then(_AddressesModel(
addresses: freezed == addresses ? _self._addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<AddressesItem>?,
  ));
}


}

/// @nodoc
mixin _$LoadAddressesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAddressesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoadAddressesState()';
}


}

/// @nodoc
class $LoadAddressesStateCopyWith<$Res>  {
$LoadAddressesStateCopyWith(LoadAddressesState _, $Res Function(LoadAddressesState) __);
}


/// Adds pattern-matching-related methods to [LoadAddressesState].
extension LoadAddressesStatePatterns on LoadAddressesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadAddressesStateEmpty value)?  empty,TResult Function( LoadAddressesStateLoading value)?  loading,TResult Function( LoadAddressesStateData value)?  data,TResult Function( LoadAddressesStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadAddressesStateEmpty() when empty != null:
return empty(_that);case LoadAddressesStateLoading() when loading != null:
return loading(_that);case LoadAddressesStateData() when data != null:
return data(_that);case LoadAddressesStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadAddressesStateEmpty value)  empty,required TResult Function( LoadAddressesStateLoading value)  loading,required TResult Function( LoadAddressesStateData value)  data,required TResult Function( LoadAddressesStateError value)  error,}){
final _that = this;
switch (_that) {
case LoadAddressesStateEmpty():
return empty(_that);case LoadAddressesStateLoading():
return loading(_that);case LoadAddressesStateData():
return data(_that);case LoadAddressesStateError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadAddressesStateEmpty value)?  empty,TResult? Function( LoadAddressesStateLoading value)?  loading,TResult? Function( LoadAddressesStateData value)?  data,TResult? Function( LoadAddressesStateError value)?  error,}){
final _that = this;
switch (_that) {
case LoadAddressesStateEmpty() when empty != null:
return empty(_that);case LoadAddressesStateLoading() when loading != null:
return loading(_that);case LoadAddressesStateData() when data != null:
return data(_that);case LoadAddressesStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  loading,TResult Function( From_LoadAddresses loadAddresses)?  data,TResult Function( String errorMsg)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadAddressesStateEmpty() when empty != null:
return empty();case LoadAddressesStateLoading() when loading != null:
return loading();case LoadAddressesStateData() when data != null:
return data(_that.loadAddresses);case LoadAddressesStateError() when error != null:
return error(_that.errorMsg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  loading,required TResult Function( From_LoadAddresses loadAddresses)  data,required TResult Function( String errorMsg)  error,}) {final _that = this;
switch (_that) {
case LoadAddressesStateEmpty():
return empty();case LoadAddressesStateLoading():
return loading();case LoadAddressesStateData():
return data(_that.loadAddresses);case LoadAddressesStateError():
return error(_that.errorMsg);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  loading,TResult? Function( From_LoadAddresses loadAddresses)?  data,TResult? Function( String errorMsg)?  error,}) {final _that = this;
switch (_that) {
case LoadAddressesStateEmpty() when empty != null:
return empty();case LoadAddressesStateLoading() when loading != null:
return loading();case LoadAddressesStateData() when data != null:
return data(_that.loadAddresses);case LoadAddressesStateError() when error != null:
return error(_that.errorMsg);case _:
  return null;

}
}

}

/// @nodoc


class LoadAddressesStateEmpty implements LoadAddressesState {
  const LoadAddressesStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAddressesStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoadAddressesState.empty()';
}


}




/// @nodoc


class LoadAddressesStateLoading implements LoadAddressesState {
  const LoadAddressesStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAddressesStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoadAddressesState.loading()';
}


}




/// @nodoc


class LoadAddressesStateData implements LoadAddressesState {
  const LoadAddressesStateData(this.loadAddresses);
  

 final  From_LoadAddresses loadAddresses;

/// Create a copy of LoadAddressesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadAddressesStateDataCopyWith<LoadAddressesStateData> get copyWith => _$LoadAddressesStateDataCopyWithImpl<LoadAddressesStateData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAddressesStateData&&(identical(other.loadAddresses, loadAddresses) || other.loadAddresses == loadAddresses));
}


@override
int get hashCode => Object.hash(runtimeType,loadAddresses);

@override
String toString() {
  return 'LoadAddressesState.data(loadAddresses: $loadAddresses)';
}


}

/// @nodoc
abstract mixin class $LoadAddressesStateDataCopyWith<$Res> implements $LoadAddressesStateCopyWith<$Res> {
  factory $LoadAddressesStateDataCopyWith(LoadAddressesStateData value, $Res Function(LoadAddressesStateData) _then) = _$LoadAddressesStateDataCopyWithImpl;
@useResult
$Res call({
 From_LoadAddresses loadAddresses
});




}
/// @nodoc
class _$LoadAddressesStateDataCopyWithImpl<$Res>
    implements $LoadAddressesStateDataCopyWith<$Res> {
  _$LoadAddressesStateDataCopyWithImpl(this._self, this._then);

  final LoadAddressesStateData _self;
  final $Res Function(LoadAddressesStateData) _then;

/// Create a copy of LoadAddressesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? loadAddresses = null,}) {
  return _then(LoadAddressesStateData(
null == loadAddresses ? _self.loadAddresses : loadAddresses // ignore: cast_nullable_to_non_nullable
as From_LoadAddresses,
  ));
}


}

/// @nodoc


class LoadAddressesStateError implements LoadAddressesState {
  const LoadAddressesStateError(this.errorMsg);
  

 final  String errorMsg;

/// Create a copy of LoadAddressesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadAddressesStateErrorCopyWith<LoadAddressesStateError> get copyWith => _$LoadAddressesStateErrorCopyWithImpl<LoadAddressesStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAddressesStateError&&(identical(other.errorMsg, errorMsg) || other.errorMsg == errorMsg));
}


@override
int get hashCode => Object.hash(runtimeType,errorMsg);

@override
String toString() {
  return 'LoadAddressesState.error(errorMsg: $errorMsg)';
}


}

/// @nodoc
abstract mixin class $LoadAddressesStateErrorCopyWith<$Res> implements $LoadAddressesStateCopyWith<$Res> {
  factory $LoadAddressesStateErrorCopyWith(LoadAddressesStateError value, $Res Function(LoadAddressesStateError) _then) = _$LoadAddressesStateErrorCopyWithImpl;
@useResult
$Res call({
 String errorMsg
});




}
/// @nodoc
class _$LoadAddressesStateErrorCopyWithImpl<$Res>
    implements $LoadAddressesStateErrorCopyWith<$Res> {
  _$LoadAddressesStateErrorCopyWithImpl(this._self, this._then);

  final LoadAddressesStateError _self;
  final $Res Function(LoadAddressesStateError) _then;

/// Create a copy of LoadAddressesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMsg = null,}) {
  return _then(LoadAddressesStateError(
null == errorMsg ? _self.errorMsg : errorMsg // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$LoadUtxosState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadUtxosState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoadUtxosState()';
}


}

/// @nodoc
class $LoadUtxosStateCopyWith<$Res>  {
$LoadUtxosStateCopyWith(LoadUtxosState _, $Res Function(LoadUtxosState) __);
}


/// Adds pattern-matching-related methods to [LoadUtxosState].
extension LoadUtxosStatePatterns on LoadUtxosState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadUtxosStateEmpty value)?  empty,TResult Function( LoadUtxosStateLoading value)?  loading,TResult Function( LoadUtxosStateData value)?  data,TResult Function( LoadUtxosStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadUtxosStateEmpty() when empty != null:
return empty(_that);case LoadUtxosStateLoading() when loading != null:
return loading(_that);case LoadUtxosStateData() when data != null:
return data(_that);case LoadUtxosStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadUtxosStateEmpty value)  empty,required TResult Function( LoadUtxosStateLoading value)  loading,required TResult Function( LoadUtxosStateData value)  data,required TResult Function( LoadUtxosStateError value)  error,}){
final _that = this;
switch (_that) {
case LoadUtxosStateEmpty():
return empty(_that);case LoadUtxosStateLoading():
return loading(_that);case LoadUtxosStateData():
return data(_that);case LoadUtxosStateError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadUtxosStateEmpty value)?  empty,TResult? Function( LoadUtxosStateLoading value)?  loading,TResult? Function( LoadUtxosStateData value)?  data,TResult? Function( LoadUtxosStateError value)?  error,}){
final _that = this;
switch (_that) {
case LoadUtxosStateEmpty() when empty != null:
return empty(_that);case LoadUtxosStateLoading() when loading != null:
return loading(_that);case LoadUtxosStateData() when data != null:
return data(_that);case LoadUtxosStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  loading,TResult Function( From_LoadUtxos loadUtxos)?  data,TResult Function( String errorMsg)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadUtxosStateEmpty() when empty != null:
return empty();case LoadUtxosStateLoading() when loading != null:
return loading();case LoadUtxosStateData() when data != null:
return data(_that.loadUtxos);case LoadUtxosStateError() when error != null:
return error(_that.errorMsg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  loading,required TResult Function( From_LoadUtxos loadUtxos)  data,required TResult Function( String errorMsg)  error,}) {final _that = this;
switch (_that) {
case LoadUtxosStateEmpty():
return empty();case LoadUtxosStateLoading():
return loading();case LoadUtxosStateData():
return data(_that.loadUtxos);case LoadUtxosStateError():
return error(_that.errorMsg);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  loading,TResult? Function( From_LoadUtxos loadUtxos)?  data,TResult? Function( String errorMsg)?  error,}) {final _that = this;
switch (_that) {
case LoadUtxosStateEmpty() when empty != null:
return empty();case LoadUtxosStateLoading() when loading != null:
return loading();case LoadUtxosStateData() when data != null:
return data(_that.loadUtxos);case LoadUtxosStateError() when error != null:
return error(_that.errorMsg);case _:
  return null;

}
}

}

/// @nodoc


class LoadUtxosStateEmpty implements LoadUtxosState {
  const LoadUtxosStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadUtxosStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoadUtxosState.empty()';
}


}




/// @nodoc


class LoadUtxosStateLoading implements LoadUtxosState {
  const LoadUtxosStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadUtxosStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoadUtxosState.loading()';
}


}




/// @nodoc


class LoadUtxosStateData implements LoadUtxosState {
  const LoadUtxosStateData(this.loadUtxos);
  

 final  From_LoadUtxos loadUtxos;

/// Create a copy of LoadUtxosState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadUtxosStateDataCopyWith<LoadUtxosStateData> get copyWith => _$LoadUtxosStateDataCopyWithImpl<LoadUtxosStateData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadUtxosStateData&&(identical(other.loadUtxos, loadUtxos) || other.loadUtxos == loadUtxos));
}


@override
int get hashCode => Object.hash(runtimeType,loadUtxos);

@override
String toString() {
  return 'LoadUtxosState.data(loadUtxos: $loadUtxos)';
}


}

/// @nodoc
abstract mixin class $LoadUtxosStateDataCopyWith<$Res> implements $LoadUtxosStateCopyWith<$Res> {
  factory $LoadUtxosStateDataCopyWith(LoadUtxosStateData value, $Res Function(LoadUtxosStateData) _then) = _$LoadUtxosStateDataCopyWithImpl;
@useResult
$Res call({
 From_LoadUtxos loadUtxos
});




}
/// @nodoc
class _$LoadUtxosStateDataCopyWithImpl<$Res>
    implements $LoadUtxosStateDataCopyWith<$Res> {
  _$LoadUtxosStateDataCopyWithImpl(this._self, this._then);

  final LoadUtxosStateData _self;
  final $Res Function(LoadUtxosStateData) _then;

/// Create a copy of LoadUtxosState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? loadUtxos = null,}) {
  return _then(LoadUtxosStateData(
null == loadUtxos ? _self.loadUtxos : loadUtxos // ignore: cast_nullable_to_non_nullable
as From_LoadUtxos,
  ));
}


}

/// @nodoc


class LoadUtxosStateError implements LoadUtxosState {
  const LoadUtxosStateError(this.errorMsg);
  

 final  String errorMsg;

/// Create a copy of LoadUtxosState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadUtxosStateErrorCopyWith<LoadUtxosStateError> get copyWith => _$LoadUtxosStateErrorCopyWithImpl<LoadUtxosStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadUtxosStateError&&(identical(other.errorMsg, errorMsg) || other.errorMsg == errorMsg));
}


@override
int get hashCode => Object.hash(runtimeType,errorMsg);

@override
String toString() {
  return 'LoadUtxosState.error(errorMsg: $errorMsg)';
}


}

/// @nodoc
abstract mixin class $LoadUtxosStateErrorCopyWith<$Res> implements $LoadUtxosStateCopyWith<$Res> {
  factory $LoadUtxosStateErrorCopyWith(LoadUtxosStateError value, $Res Function(LoadUtxosStateError) _then) = _$LoadUtxosStateErrorCopyWithImpl;
@useResult
$Res call({
 String errorMsg
});




}
/// @nodoc
class _$LoadUtxosStateErrorCopyWithImpl<$Res>
    implements $LoadUtxosStateErrorCopyWith<$Res> {
  _$LoadUtxosStateErrorCopyWithImpl(this._self, this._then);

  final LoadUtxosStateError _self;
  final $Res Function(LoadUtxosStateError) _then;

/// Create a copy of LoadUtxosState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMsg = null,}) {
  return _then(LoadUtxosStateError(
null == errorMsg ? _self.errorMsg : errorMsg // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AddressDetailsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressDetailsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressDetailsState()';
}


}

/// @nodoc
class $AddressDetailsStateCopyWith<$Res>  {
$AddressDetailsStateCopyWith(AddressDetailsState _, $Res Function(AddressDetailsState) __);
}


/// Adds pattern-matching-related methods to [AddressDetailsState].
extension AddressDetailsStatePatterns on AddressDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddressDetailsStateEmpty value)?  empty,TResult Function( AddressDetailsStateData value)?  data,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddressDetailsStateEmpty() when empty != null:
return empty(_that);case AddressDetailsStateData() when data != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddressDetailsStateEmpty value)  empty,required TResult Function( AddressDetailsStateData value)  data,}){
final _that = this;
switch (_that) {
case AddressDetailsStateEmpty():
return empty(_that);case AddressDetailsStateData():
return data(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddressDetailsStateEmpty value)?  empty,TResult? Function( AddressDetailsStateData value)?  data,}){
final _that = this;
switch (_that) {
case AddressDetailsStateEmpty() when empty != null:
return empty(_that);case AddressDetailsStateData() when data != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function( AddressesItem addressesItem)?  data,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddressDetailsStateEmpty() when empty != null:
return empty();case AddressDetailsStateData() when data != null:
return data(_that.addressesItem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function( AddressesItem addressesItem)  data,}) {final _that = this;
switch (_that) {
case AddressDetailsStateEmpty():
return empty();case AddressDetailsStateData():
return data(_that.addressesItem);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function( AddressesItem addressesItem)?  data,}) {final _that = this;
switch (_that) {
case AddressDetailsStateEmpty() when empty != null:
return empty();case AddressDetailsStateData() when data != null:
return data(_that.addressesItem);case _:
  return null;

}
}

}

/// @nodoc


class AddressDetailsStateEmpty implements AddressDetailsState {
  const AddressDetailsStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressDetailsStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressDetailsState.empty()';
}


}




/// @nodoc


class AddressDetailsStateData implements AddressDetailsState {
  const AddressDetailsStateData(this.addressesItem);
  

 final  AddressesItem addressesItem;

/// Create a copy of AddressDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressDetailsStateDataCopyWith<AddressDetailsStateData> get copyWith => _$AddressDetailsStateDataCopyWithImpl<AddressDetailsStateData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressDetailsStateData&&(identical(other.addressesItem, addressesItem) || other.addressesItem == addressesItem));
}


@override
int get hashCode => Object.hash(runtimeType,addressesItem);

@override
String toString() {
  return 'AddressDetailsState.data(addressesItem: $addressesItem)';
}


}

/// @nodoc
abstract mixin class $AddressDetailsStateDataCopyWith<$Res> implements $AddressDetailsStateCopyWith<$Res> {
  factory $AddressDetailsStateDataCopyWith(AddressDetailsStateData value, $Res Function(AddressDetailsStateData) _then) = _$AddressDetailsStateDataCopyWithImpl;
@useResult
$Res call({
 AddressesItem addressesItem
});


$AddressesItemCopyWith<$Res> get addressesItem;

}
/// @nodoc
class _$AddressDetailsStateDataCopyWithImpl<$Res>
    implements $AddressDetailsStateDataCopyWith<$Res> {
  _$AddressDetailsStateDataCopyWithImpl(this._self, this._then);

  final AddressDetailsStateData _self;
  final $Res Function(AddressDetailsStateData) _then;

/// Create a copy of AddressDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? addressesItem = null,}) {
  return _then(AddressDetailsStateData(
null == addressesItem ? _self.addressesItem : addressesItem // ignore: cast_nullable_to_non_nullable
as AddressesItem,
  ));
}

/// Create a copy of AddressDetailsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressesItemCopyWith<$Res> get addressesItem {
  
  return $AddressesItemCopyWith<$Res>(_self.addressesItem, (value) {
    return _then(_self.copyWith(addressesItem: value));
  });
}
}

/// @nodoc
mixin _$AddressesWalletTypeFlag {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesWalletTypeFlag);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressesWalletTypeFlag()';
}


}

/// @nodoc
class $AddressesWalletTypeFlagCopyWith<$Res>  {
$AddressesWalletTypeFlagCopyWith(AddressesWalletTypeFlag _, $Res Function(AddressesWalletTypeFlag) __);
}


/// Adds pattern-matching-related methods to [AddressesWalletTypeFlag].
extension AddressesWalletTypeFlagPatterns on AddressesWalletTypeFlag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddressesWalletTypeFlagAll value)?  all,TResult Function( AddressesWalletTypeFlagRegular value)?  regular,TResult Function( AddressesWalletTypeFlagAmp value)?  amp,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddressesWalletTypeFlagAll() when all != null:
return all(_that);case AddressesWalletTypeFlagRegular() when regular != null:
return regular(_that);case AddressesWalletTypeFlagAmp() when amp != null:
return amp(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddressesWalletTypeFlagAll value)  all,required TResult Function( AddressesWalletTypeFlagRegular value)  regular,required TResult Function( AddressesWalletTypeFlagAmp value)  amp,}){
final _that = this;
switch (_that) {
case AddressesWalletTypeFlagAll():
return all(_that);case AddressesWalletTypeFlagRegular():
return regular(_that);case AddressesWalletTypeFlagAmp():
return amp(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddressesWalletTypeFlagAll value)?  all,TResult? Function( AddressesWalletTypeFlagRegular value)?  regular,TResult? Function( AddressesWalletTypeFlagAmp value)?  amp,}){
final _that = this;
switch (_that) {
case AddressesWalletTypeFlagAll() when all != null:
return all(_that);case AddressesWalletTypeFlagRegular() when regular != null:
return regular(_that);case AddressesWalletTypeFlagAmp() when amp != null:
return amp(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  all,TResult Function()?  regular,TResult Function()?  amp,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddressesWalletTypeFlagAll() when all != null:
return all();case AddressesWalletTypeFlagRegular() when regular != null:
return regular();case AddressesWalletTypeFlagAmp() when amp != null:
return amp();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  all,required TResult Function()  regular,required TResult Function()  amp,}) {final _that = this;
switch (_that) {
case AddressesWalletTypeFlagAll():
return all();case AddressesWalletTypeFlagRegular():
return regular();case AddressesWalletTypeFlagAmp():
return amp();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  all,TResult? Function()?  regular,TResult? Function()?  amp,}) {final _that = this;
switch (_that) {
case AddressesWalletTypeFlagAll() when all != null:
return all();case AddressesWalletTypeFlagRegular() when regular != null:
return regular();case AddressesWalletTypeFlagAmp() when amp != null:
return amp();case _:
  return null;

}
}

}

/// @nodoc


class AddressesWalletTypeFlagAll implements AddressesWalletTypeFlag {
  const AddressesWalletTypeFlagAll();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesWalletTypeFlagAll);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressesWalletTypeFlag.all()';
}


}




/// @nodoc


class AddressesWalletTypeFlagRegular implements AddressesWalletTypeFlag {
  const AddressesWalletTypeFlagRegular();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesWalletTypeFlagRegular);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressesWalletTypeFlag.regular()';
}


}




/// @nodoc


class AddressesWalletTypeFlagAmp implements AddressesWalletTypeFlag {
  const AddressesWalletTypeFlagAmp();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesWalletTypeFlagAmp);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressesWalletTypeFlag.amp()';
}


}




/// @nodoc
mixin _$AddressesAddressTypeFlag {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesAddressTypeFlag);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressesAddressTypeFlag()';
}


}

/// @nodoc
class $AddressesAddressTypeFlagCopyWith<$Res>  {
$AddressesAddressTypeFlagCopyWith(AddressesAddressTypeFlag _, $Res Function(AddressesAddressTypeFlag) __);
}


/// Adds pattern-matching-related methods to [AddressesAddressTypeFlag].
extension AddressesAddressTypeFlagPatterns on AddressesAddressTypeFlag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddressesAddressTypeFlagAll value)?  all,TResult Function( AddressesAddressTypeFlagInternal value)?  internal,TResult Function( AddressesAddressTypeFlagExternal value)?  external,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddressesAddressTypeFlagAll() when all != null:
return all(_that);case AddressesAddressTypeFlagInternal() when internal != null:
return internal(_that);case AddressesAddressTypeFlagExternal() when external != null:
return external(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddressesAddressTypeFlagAll value)  all,required TResult Function( AddressesAddressTypeFlagInternal value)  internal,required TResult Function( AddressesAddressTypeFlagExternal value)  external,}){
final _that = this;
switch (_that) {
case AddressesAddressTypeFlagAll():
return all(_that);case AddressesAddressTypeFlagInternal():
return internal(_that);case AddressesAddressTypeFlagExternal():
return external(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddressesAddressTypeFlagAll value)?  all,TResult? Function( AddressesAddressTypeFlagInternal value)?  internal,TResult? Function( AddressesAddressTypeFlagExternal value)?  external,}){
final _that = this;
switch (_that) {
case AddressesAddressTypeFlagAll() when all != null:
return all(_that);case AddressesAddressTypeFlagInternal() when internal != null:
return internal(_that);case AddressesAddressTypeFlagExternal() when external != null:
return external(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  all,TResult Function()?  internal,TResult Function()?  external,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddressesAddressTypeFlagAll() when all != null:
return all();case AddressesAddressTypeFlagInternal() when internal != null:
return internal();case AddressesAddressTypeFlagExternal() when external != null:
return external();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  all,required TResult Function()  internal,required TResult Function()  external,}) {final _that = this;
switch (_that) {
case AddressesAddressTypeFlagAll():
return all();case AddressesAddressTypeFlagInternal():
return internal();case AddressesAddressTypeFlagExternal():
return external();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  all,TResult? Function()?  internal,TResult? Function()?  external,}) {final _that = this;
switch (_that) {
case AddressesAddressTypeFlagAll() when all != null:
return all();case AddressesAddressTypeFlagInternal() when internal != null:
return internal();case AddressesAddressTypeFlagExternal() when external != null:
return external();case _:
  return null;

}
}

}

/// @nodoc


class AddressesAddressTypeFlagAll implements AddressesAddressTypeFlag {
  const AddressesAddressTypeFlagAll();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesAddressTypeFlagAll);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressesAddressTypeFlag.all()';
}


}




/// @nodoc


class AddressesAddressTypeFlagInternal implements AddressesAddressTypeFlag {
  const AddressesAddressTypeFlagInternal();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesAddressTypeFlagInternal);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressesAddressTypeFlag.internal()';
}


}




/// @nodoc


class AddressesAddressTypeFlagExternal implements AddressesAddressTypeFlag {
  const AddressesAddressTypeFlagExternal();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesAddressTypeFlagExternal);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressesAddressTypeFlag.external()';
}


}




/// @nodoc
mixin _$AddressesBalanceFlag {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesBalanceFlag);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressesBalanceFlag()';
}


}

/// @nodoc
class $AddressesBalanceFlagCopyWith<$Res>  {
$AddressesBalanceFlagCopyWith(AddressesBalanceFlag _, $Res Function(AddressesBalanceFlag) __);
}


/// Adds pattern-matching-related methods to [AddressesBalanceFlag].
extension AddressesBalanceFlagPatterns on AddressesBalanceFlag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddressesBalanceFlagShowAll value)?  showAll,TResult Function( AddressesBalanceFlagHideEmpty value)?  hideEmpty,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddressesBalanceFlagShowAll() when showAll != null:
return showAll(_that);case AddressesBalanceFlagHideEmpty() when hideEmpty != null:
return hideEmpty(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddressesBalanceFlagShowAll value)  showAll,required TResult Function( AddressesBalanceFlagHideEmpty value)  hideEmpty,}){
final _that = this;
switch (_that) {
case AddressesBalanceFlagShowAll():
return showAll(_that);case AddressesBalanceFlagHideEmpty():
return hideEmpty(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddressesBalanceFlagShowAll value)?  showAll,TResult? Function( AddressesBalanceFlagHideEmpty value)?  hideEmpty,}){
final _that = this;
switch (_that) {
case AddressesBalanceFlagShowAll() when showAll != null:
return showAll(_that);case AddressesBalanceFlagHideEmpty() when hideEmpty != null:
return hideEmpty(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  showAll,TResult Function()?  hideEmpty,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddressesBalanceFlagShowAll() when showAll != null:
return showAll();case AddressesBalanceFlagHideEmpty() when hideEmpty != null:
return hideEmpty();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  showAll,required TResult Function()  hideEmpty,}) {final _that = this;
switch (_that) {
case AddressesBalanceFlagShowAll():
return showAll();case AddressesBalanceFlagHideEmpty():
return hideEmpty();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  showAll,TResult? Function()?  hideEmpty,}) {final _that = this;
switch (_that) {
case AddressesBalanceFlagShowAll() when showAll != null:
return showAll();case AddressesBalanceFlagHideEmpty() when hideEmpty != null:
return hideEmpty();case _:
  return null;

}
}

}

/// @nodoc


class AddressesBalanceFlagShowAll implements AddressesBalanceFlag {
  const AddressesBalanceFlagShowAll();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesBalanceFlagShowAll);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressesBalanceFlag.showAll()';
}


}




/// @nodoc


class AddressesBalanceFlagHideEmpty implements AddressesBalanceFlag {
  const AddressesBalanceFlagHideEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressesBalanceFlagHideEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressesBalanceFlag.hideEmpty()';
}


}




/// @nodoc
mixin _$InputListItemExpandedState {

 int? get hash; bool get expanded;
/// Create a copy of InputListItemExpandedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InputListItemExpandedStateCopyWith<InputListItemExpandedState> get copyWith => _$InputListItemExpandedStateCopyWithImpl<InputListItemExpandedState>(this as InputListItemExpandedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InputListItemExpandedState&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.expanded, expanded) || other.expanded == expanded));
}


@override
int get hashCode => Object.hash(runtimeType,hash,expanded);

@override
String toString() {
  return 'InputListItemExpandedState(hash: $hash, expanded: $expanded)';
}


}

/// @nodoc
abstract mixin class $InputListItemExpandedStateCopyWith<$Res>  {
  factory $InputListItemExpandedStateCopyWith(InputListItemExpandedState value, $Res Function(InputListItemExpandedState) _then) = _$InputListItemExpandedStateCopyWithImpl;
@useResult
$Res call({
 int? hash, bool expanded
});




}
/// @nodoc
class _$InputListItemExpandedStateCopyWithImpl<$Res>
    implements $InputListItemExpandedStateCopyWith<$Res> {
  _$InputListItemExpandedStateCopyWithImpl(this._self, this._then);

  final InputListItemExpandedState _self;
  final $Res Function(InputListItemExpandedState) _then;

/// Create a copy of InputListItemExpandedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hash = freezed,Object? expanded = null,}) {
  return _then(_self.copyWith(
hash: freezed == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as int?,expanded: null == expanded ? _self.expanded : expanded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InputListItemExpandedState].
extension InputListItemExpandedStatePatterns on InputListItemExpandedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InputListItemExpandedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InputListItemExpandedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InputListItemExpandedState value)  $default,){
final _that = this;
switch (_that) {
case _InputListItemExpandedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InputListItemExpandedState value)?  $default,){
final _that = this;
switch (_that) {
case _InputListItemExpandedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? hash,  bool expanded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InputListItemExpandedState() when $default != null:
return $default(_that.hash,_that.expanded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? hash,  bool expanded)  $default,) {final _that = this;
switch (_that) {
case _InputListItemExpandedState():
return $default(_that.hash,_that.expanded);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? hash,  bool expanded)?  $default,) {final _that = this;
switch (_that) {
case _InputListItemExpandedState() when $default != null:
return $default(_that.hash,_that.expanded);case _:
  return null;

}
}

}

/// @nodoc


class _InputListItemExpandedState implements InputListItemExpandedState {
  const _InputListItemExpandedState({this.hash, this.expanded = true});
  

@override final  int? hash;
@override@JsonKey() final  bool expanded;

/// Create a copy of InputListItemExpandedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InputListItemExpandedStateCopyWith<_InputListItemExpandedState> get copyWith => __$InputListItemExpandedStateCopyWithImpl<_InputListItemExpandedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InputListItemExpandedState&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.expanded, expanded) || other.expanded == expanded));
}


@override
int get hashCode => Object.hash(runtimeType,hash,expanded);

@override
String toString() {
  return 'InputListItemExpandedState(hash: $hash, expanded: $expanded)';
}


}

/// @nodoc
abstract mixin class _$InputListItemExpandedStateCopyWith<$Res> implements $InputListItemExpandedStateCopyWith<$Res> {
  factory _$InputListItemExpandedStateCopyWith(_InputListItemExpandedState value, $Res Function(_InputListItemExpandedState) _then) = __$InputListItemExpandedStateCopyWithImpl;
@override @useResult
$Res call({
 int? hash, bool expanded
});




}
/// @nodoc
class __$InputListItemExpandedStateCopyWithImpl<$Res>
    implements _$InputListItemExpandedStateCopyWith<$Res> {
  __$InputListItemExpandedStateCopyWithImpl(this._self, this._then);

  final _InputListItemExpandedState _self;
  final $Res Function(_InputListItemExpandedState) _then;

/// Create a copy of InputListItemExpandedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hash = freezed,Object? expanded = null,}) {
  return _then(_InputListItemExpandedState(
hash: freezed == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as int?,expanded: null == expanded ? _self.expanded : expanded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
