// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'swap_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SwapType {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapType);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SwapType()';
}


}

/// @nodoc
class $SwapTypeCopyWith<$Res>  {
$SwapTypeCopyWith(SwapType _, $Res Function(SwapType) __);
}


/// @nodoc


class SwapTypeAtomic implements SwapType {
  const SwapTypeAtomic();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapTypeAtomic);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SwapType.atomic()';
}


}




/// @nodoc


class SwapTypePegIn implements SwapType {
  const SwapTypePegIn();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapTypePegIn);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SwapType.pegIn()';
}


}




/// @nodoc


class SwapTypePegOut implements SwapType {
  const SwapTypePegOut();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapTypePegOut);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SwapType.pegOut()';
}


}




/// @nodoc
mixin _$SwapWallet {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapWallet);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SwapWallet()';
}


}

/// @nodoc
class $SwapWalletCopyWith<$Res>  {
$SwapWalletCopyWith(SwapWallet _, $Res Function(SwapWallet) __);
}


/// @nodoc


class SwapWalletLocal implements SwapWallet {
  const SwapWalletLocal();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapWalletLocal);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SwapWallet.local()';
}


}




/// @nodoc


class SwapWalletExtern implements SwapWallet {
  const SwapWalletExtern();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapWalletExtern);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SwapWallet.extern()';
}


}




/// @nodoc
mixin _$SwapState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SwapState()';
}


}

/// @nodoc
class $SwapStateCopyWith<$Res>  {
$SwapStateCopyWith(SwapState _, $Res Function(SwapState) __);
}


/// @nodoc


class SwapStateIdle implements SwapState {
  const SwapStateIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapStateIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SwapState.idle()';
}


}




/// @nodoc


class SwapStateSent implements SwapState {
  const SwapStateSent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapStateSent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SwapState.sent()';
}


}




/// @nodoc
mixin _$SwapAsset {

 String get assetId; Iterable<String> get assetList;
/// Create a copy of SwapAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwapAssetCopyWith<SwapAsset> get copyWith => _$SwapAssetCopyWithImpl<SwapAsset>(this as SwapAsset, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwapAsset&&(identical(other.assetId, assetId) || other.assetId == assetId)&&const DeepCollectionEquality().equals(other.assetList, assetList));
}


@override
int get hashCode => Object.hash(runtimeType,assetId,const DeepCollectionEquality().hash(assetList));

@override
String toString() {
  return 'SwapAsset(assetId: $assetId, assetList: $assetList)';
}


}

/// @nodoc
abstract mixin class $SwapAssetCopyWith<$Res>  {
  factory $SwapAssetCopyWith(SwapAsset value, $Res Function(SwapAsset) _then) = _$SwapAssetCopyWithImpl;
@useResult
$Res call({
 String assetId, Iterable<String> assetList
});




}
/// @nodoc
class _$SwapAssetCopyWithImpl<$Res>
    implements $SwapAssetCopyWith<$Res> {
  _$SwapAssetCopyWithImpl(this._self, this._then);

  final SwapAsset _self;
  final $Res Function(SwapAsset) _then;

/// Create a copy of SwapAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? assetId = null,Object? assetList = null,}) {
  return _then(_self.copyWith(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,assetList: null == assetList ? _self.assetList : assetList // ignore: cast_nullable_to_non_nullable
as Iterable<String>,
  ));
}

}


/// @nodoc


class _SwapAsset implements SwapAsset {
  const _SwapAsset({required this.assetId, required this.assetList});
  

@override final  String assetId;
@override final  Iterable<String> assetList;

/// Create a copy of SwapAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwapAssetCopyWith<_SwapAsset> get copyWith => __$SwapAssetCopyWithImpl<_SwapAsset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwapAsset&&(identical(other.assetId, assetId) || other.assetId == assetId)&&const DeepCollectionEquality().equals(other.assetList, assetList));
}


@override
int get hashCode => Object.hash(runtimeType,assetId,const DeepCollectionEquality().hash(assetList));

@override
String toString() {
  return 'SwapAsset(assetId: $assetId, assetList: $assetList)';
}


}

/// @nodoc
abstract mixin class _$SwapAssetCopyWith<$Res> implements $SwapAssetCopyWith<$Res> {
  factory _$SwapAssetCopyWith(_SwapAsset value, $Res Function(_SwapAsset) _then) = __$SwapAssetCopyWithImpl;
@override @useResult
$Res call({
 String assetId, Iterable<String> assetList
});




}
/// @nodoc
class __$SwapAssetCopyWithImpl<$Res>
    implements _$SwapAssetCopyWith<$Res> {
  __$SwapAssetCopyWithImpl(this._self, this._then);

  final _SwapAsset _self;
  final $Res Function(_SwapAsset) _then;

/// Create a copy of SwapAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? assetId = null,Object? assetList = null,}) {
  return _then(_SwapAsset(
assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,assetList: null == assetList ? _self.assetList : assetList // ignore: cast_nullable_to_non_nullable
as Iterable<String>,
  ));
}


}

// dart format on
