// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preview_order_dialog_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PreviewOrderDialogModifiers {

 bool get showOrderType;
/// Create a copy of PreviewOrderDialogModifiers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreviewOrderDialogModifiersCopyWith<PreviewOrderDialogModifiers> get copyWith => _$PreviewOrderDialogModifiersCopyWithImpl<PreviewOrderDialogModifiers>(this as PreviewOrderDialogModifiers, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreviewOrderDialogModifiers&&(identical(other.showOrderType, showOrderType) || other.showOrderType == showOrderType));
}


@override
int get hashCode => Object.hash(runtimeType,showOrderType);

@override
String toString() {
  return 'PreviewOrderDialogModifiers(showOrderType: $showOrderType)';
}


}

/// @nodoc
abstract mixin class $PreviewOrderDialogModifiersCopyWith<$Res>  {
  factory $PreviewOrderDialogModifiersCopyWith(PreviewOrderDialogModifiers value, $Res Function(PreviewOrderDialogModifiers) _then) = _$PreviewOrderDialogModifiersCopyWithImpl;
@useResult
$Res call({
 bool showOrderType
});




}
/// @nodoc
class _$PreviewOrderDialogModifiersCopyWithImpl<$Res>
    implements $PreviewOrderDialogModifiersCopyWith<$Res> {
  _$PreviewOrderDialogModifiersCopyWithImpl(this._self, this._then);

  final PreviewOrderDialogModifiers _self;
  final $Res Function(PreviewOrderDialogModifiers) _then;

/// Create a copy of PreviewOrderDialogModifiers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showOrderType = null,}) {
  return _then(_self.copyWith(
showOrderType: null == showOrderType ? _self.showOrderType : showOrderType // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PreviewOrderDialogModifiers].
extension PreviewOrderDialogModifiersPatterns on PreviewOrderDialogModifiers {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreviewOrderDialogModifiers value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreviewOrderDialogModifiers() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreviewOrderDialogModifiers value)  $default,){
final _that = this;
switch (_that) {
case _PreviewOrderDialogModifiers():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreviewOrderDialogModifiers value)?  $default,){
final _that = this;
switch (_that) {
case _PreviewOrderDialogModifiers() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool showOrderType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreviewOrderDialogModifiers() when $default != null:
return $default(_that.showOrderType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool showOrderType)  $default,) {final _that = this;
switch (_that) {
case _PreviewOrderDialogModifiers():
return $default(_that.showOrderType);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool showOrderType)?  $default,) {final _that = this;
switch (_that) {
case _PreviewOrderDialogModifiers() when $default != null:
return $default(_that.showOrderType);case _:
  return null;

}
}

}

/// @nodoc


class _PreviewOrderDialogModifiers implements PreviewOrderDialogModifiers {
  const _PreviewOrderDialogModifiers({this.showOrderType = true});
  

@override@JsonKey() final  bool showOrderType;

/// Create a copy of PreviewOrderDialogModifiers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreviewOrderDialogModifiersCopyWith<_PreviewOrderDialogModifiers> get copyWith => __$PreviewOrderDialogModifiersCopyWithImpl<_PreviewOrderDialogModifiers>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreviewOrderDialogModifiers&&(identical(other.showOrderType, showOrderType) || other.showOrderType == showOrderType));
}


@override
int get hashCode => Object.hash(runtimeType,showOrderType);

@override
String toString() {
  return 'PreviewOrderDialogModifiers(showOrderType: $showOrderType)';
}


}

/// @nodoc
abstract mixin class _$PreviewOrderDialogModifiersCopyWith<$Res> implements $PreviewOrderDialogModifiersCopyWith<$Res> {
  factory _$PreviewOrderDialogModifiersCopyWith(_PreviewOrderDialogModifiers value, $Res Function(_PreviewOrderDialogModifiers) _then) = __$PreviewOrderDialogModifiersCopyWithImpl;
@override @useResult
$Res call({
 bool showOrderType
});




}
/// @nodoc
class __$PreviewOrderDialogModifiersCopyWithImpl<$Res>
    implements _$PreviewOrderDialogModifiersCopyWith<$Res> {
  __$PreviewOrderDialogModifiersCopyWithImpl(this._self, this._then);

  final _PreviewOrderDialogModifiers _self;
  final $Res Function(_PreviewOrderDialogModifiers) _then;

/// Create a copy of PreviewOrderDialogModifiers
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showOrderType = null,}) {
  return _then(_PreviewOrderDialogModifiers(
showOrderType: null == showOrderType ? _self.showOrderType : showOrderType // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PreviewOrderDialogAcceptState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreviewOrderDialogAcceptState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PreviewOrderDialogAcceptState()';
}


}

/// @nodoc
class $PreviewOrderDialogAcceptStateCopyWith<$Res>  {
$PreviewOrderDialogAcceptStateCopyWith(PreviewOrderDialogAcceptState _, $Res Function(PreviewOrderDialogAcceptState) __);
}


/// Adds pattern-matching-related methods to [PreviewOrderDialogAcceptState].
extension PreviewOrderDialogAcceptStatePatterns on PreviewOrderDialogAcceptState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PreviewOrderDialogAcceptStateEmpty value)?  empty,TResult Function( PreviewOrderDialogAcceptStateAccepting value)?  accepting,TResult Function( PreviewOrderDialogAcceptStateAccepted value)?  accepted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PreviewOrderDialogAcceptStateEmpty() when empty != null:
return empty(_that);case PreviewOrderDialogAcceptStateAccepting() when accepting != null:
return accepting(_that);case PreviewOrderDialogAcceptStateAccepted() when accepted != null:
return accepted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PreviewOrderDialogAcceptStateEmpty value)  empty,required TResult Function( PreviewOrderDialogAcceptStateAccepting value)  accepting,required TResult Function( PreviewOrderDialogAcceptStateAccepted value)  accepted,}){
final _that = this;
switch (_that) {
case PreviewOrderDialogAcceptStateEmpty():
return empty(_that);case PreviewOrderDialogAcceptStateAccepting():
return accepting(_that);case PreviewOrderDialogAcceptStateAccepted():
return accepted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PreviewOrderDialogAcceptStateEmpty value)?  empty,TResult? Function( PreviewOrderDialogAcceptStateAccepting value)?  accepting,TResult? Function( PreviewOrderDialogAcceptStateAccepted value)?  accepted,}){
final _that = this;
switch (_that) {
case PreviewOrderDialogAcceptStateEmpty() when empty != null:
return empty(_that);case PreviewOrderDialogAcceptStateAccepting() when accepting != null:
return accepting(_that);case PreviewOrderDialogAcceptStateAccepted() when accepted != null:
return accepted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  accepting,TResult Function( String txid)?  accepted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PreviewOrderDialogAcceptStateEmpty() when empty != null:
return empty();case PreviewOrderDialogAcceptStateAccepting() when accepting != null:
return accepting();case PreviewOrderDialogAcceptStateAccepted() when accepted != null:
return accepted(_that.txid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  accepting,required TResult Function( String txid)  accepted,}) {final _that = this;
switch (_that) {
case PreviewOrderDialogAcceptStateEmpty():
return empty();case PreviewOrderDialogAcceptStateAccepting():
return accepting();case PreviewOrderDialogAcceptStateAccepted():
return accepted(_that.txid);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  accepting,TResult? Function( String txid)?  accepted,}) {final _that = this;
switch (_that) {
case PreviewOrderDialogAcceptStateEmpty() when empty != null:
return empty();case PreviewOrderDialogAcceptStateAccepting() when accepting != null:
return accepting();case PreviewOrderDialogAcceptStateAccepted() when accepted != null:
return accepted(_that.txid);case _:
  return null;

}
}

}

/// @nodoc


class PreviewOrderDialogAcceptStateEmpty implements PreviewOrderDialogAcceptState {
  const PreviewOrderDialogAcceptStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreviewOrderDialogAcceptStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PreviewOrderDialogAcceptState.empty()';
}


}




/// @nodoc


class PreviewOrderDialogAcceptStateAccepting implements PreviewOrderDialogAcceptState {
  const PreviewOrderDialogAcceptStateAccepting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreviewOrderDialogAcceptStateAccepting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PreviewOrderDialogAcceptState.accepting()';
}


}




/// @nodoc


class PreviewOrderDialogAcceptStateAccepted implements PreviewOrderDialogAcceptState {
  const PreviewOrderDialogAcceptStateAccepted(this.txid);
  

 final  String txid;

/// Create a copy of PreviewOrderDialogAcceptState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreviewOrderDialogAcceptStateAcceptedCopyWith<PreviewOrderDialogAcceptStateAccepted> get copyWith => _$PreviewOrderDialogAcceptStateAcceptedCopyWithImpl<PreviewOrderDialogAcceptStateAccepted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreviewOrderDialogAcceptStateAccepted&&(identical(other.txid, txid) || other.txid == txid));
}


@override
int get hashCode => Object.hash(runtimeType,txid);

@override
String toString() {
  return 'PreviewOrderDialogAcceptState.accepted(txid: $txid)';
}


}

/// @nodoc
abstract mixin class $PreviewOrderDialogAcceptStateAcceptedCopyWith<$Res> implements $PreviewOrderDialogAcceptStateCopyWith<$Res> {
  factory $PreviewOrderDialogAcceptStateAcceptedCopyWith(PreviewOrderDialogAcceptStateAccepted value, $Res Function(PreviewOrderDialogAcceptStateAccepted) _then) = _$PreviewOrderDialogAcceptStateAcceptedCopyWithImpl;
@useResult
$Res call({
 String txid
});




}
/// @nodoc
class _$PreviewOrderDialogAcceptStateAcceptedCopyWithImpl<$Res>
    implements $PreviewOrderDialogAcceptStateAcceptedCopyWith<$Res> {
  _$PreviewOrderDialogAcceptStateAcceptedCopyWithImpl(this._self, this._then);

  final PreviewOrderDialogAcceptStateAccepted _self;
  final $Res Function(PreviewOrderDialogAcceptStateAccepted) _then;

/// Create a copy of PreviewOrderDialogAcceptState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? txid = null,}) {
  return _then(PreviewOrderDialogAcceptStateAccepted(
null == txid ? _self.txid : txid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
