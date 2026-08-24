// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_descriptors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletDescriptors {

 String get nativeSegwit; String get nestedSegwit;
/// Create a copy of WalletDescriptors
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletDescriptorsCopyWith<WalletDescriptors> get copyWith => _$WalletDescriptorsCopyWithImpl<WalletDescriptors>(this as WalletDescriptors, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletDescriptors&&(identical(other.nativeSegwit, nativeSegwit) || other.nativeSegwit == nativeSegwit)&&(identical(other.nestedSegwit, nestedSegwit) || other.nestedSegwit == nestedSegwit));
}


@override
int get hashCode => Object.hash(runtimeType,nativeSegwit,nestedSegwit);

@override
String toString() {
  return 'WalletDescriptors(nativeSegwit: $nativeSegwit, nestedSegwit: $nestedSegwit)';
}


}

/// @nodoc
abstract mixin class $WalletDescriptorsCopyWith<$Res>  {
  factory $WalletDescriptorsCopyWith(WalletDescriptors value, $Res Function(WalletDescriptors) _then) = _$WalletDescriptorsCopyWithImpl;
@useResult
$Res call({
 String nativeSegwit, String nestedSegwit
});




}
/// @nodoc
class _$WalletDescriptorsCopyWithImpl<$Res>
    implements $WalletDescriptorsCopyWith<$Res> {
  _$WalletDescriptorsCopyWithImpl(this._self, this._then);

  final WalletDescriptors _self;
  final $Res Function(WalletDescriptors) _then;

/// Create a copy of WalletDescriptors
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nativeSegwit = null,Object? nestedSegwit = null,}) {
  return _then(_self.copyWith(
nativeSegwit: null == nativeSegwit ? _self.nativeSegwit : nativeSegwit // ignore: cast_nullable_to_non_nullable
as String,nestedSegwit: null == nestedSegwit ? _self.nestedSegwit : nestedSegwit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletDescriptors].
extension WalletDescriptorsPatterns on WalletDescriptors {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletDescriptors value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletDescriptors() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletDescriptors value)  $default,){
final _that = this;
switch (_that) {
case _WalletDescriptors():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletDescriptors value)?  $default,){
final _that = this;
switch (_that) {
case _WalletDescriptors() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nativeSegwit,  String nestedSegwit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletDescriptors() when $default != null:
return $default(_that.nativeSegwit,_that.nestedSegwit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nativeSegwit,  String nestedSegwit)  $default,) {final _that = this;
switch (_that) {
case _WalletDescriptors():
return $default(_that.nativeSegwit,_that.nestedSegwit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nativeSegwit,  String nestedSegwit)?  $default,) {final _that = this;
switch (_that) {
case _WalletDescriptors() when $default != null:
return $default(_that.nativeSegwit,_that.nestedSegwit);case _:
  return null;

}
}

}

/// @nodoc


class _WalletDescriptors implements WalletDescriptors {
  const _WalletDescriptors({required this.nativeSegwit, required this.nestedSegwit});
  

@override final  String nativeSegwit;
@override final  String nestedSegwit;

/// Create a copy of WalletDescriptors
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletDescriptorsCopyWith<_WalletDescriptors> get copyWith => __$WalletDescriptorsCopyWithImpl<_WalletDescriptors>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletDescriptors&&(identical(other.nativeSegwit, nativeSegwit) || other.nativeSegwit == nativeSegwit)&&(identical(other.nestedSegwit, nestedSegwit) || other.nestedSegwit == nestedSegwit));
}


@override
int get hashCode => Object.hash(runtimeType,nativeSegwit,nestedSegwit);

@override
String toString() {
  return 'WalletDescriptors(nativeSegwit: $nativeSegwit, nestedSegwit: $nestedSegwit)';
}


}

/// @nodoc
abstract mixin class _$WalletDescriptorsCopyWith<$Res> implements $WalletDescriptorsCopyWith<$Res> {
  factory _$WalletDescriptorsCopyWith(_WalletDescriptors value, $Res Function(_WalletDescriptors) _then) = __$WalletDescriptorsCopyWithImpl;
@override @useResult
$Res call({
 String nativeSegwit, String nestedSegwit
});




}
/// @nodoc
class __$WalletDescriptorsCopyWithImpl<$Res>
    implements _$WalletDescriptorsCopyWith<$Res> {
  __$WalletDescriptorsCopyWithImpl(this._self, this._then);

  final _WalletDescriptors _self;
  final $Res Function(_WalletDescriptors) _then;

/// Create a copy of WalletDescriptors
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nativeSegwit = null,Object? nestedSegwit = null,}) {
  return _then(_WalletDescriptors(
nativeSegwit: null == nativeSegwit ? _self.nativeSegwit : nativeSegwit // ignore: cast_nullable_to_non_nullable
as String,nestedSegwit: null == nestedSegwit ? _self.nestedSegwit : nestedSegwit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
