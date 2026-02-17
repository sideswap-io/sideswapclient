// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_ffi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LibClientState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibClientState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LibClientState()';
}


}

/// @nodoc
class $LibClientStateCopyWith<$Res>  {
$LibClientStateCopyWith(LibClientState _, $Res Function(LibClientState) __);
}


/// Adds pattern-matching-related methods to [LibClientState].
extension LibClientStatePatterns on LibClientState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LibClientStateEmpty value)?  empty,TResult Function( LibClientStateInitialized value)?  initialized,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LibClientStateEmpty() when empty != null:
return empty(_that);case LibClientStateInitialized() when initialized != null:
return initialized(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LibClientStateEmpty value)  empty,required TResult Function( LibClientStateInitialized value)  initialized,}){
final _that = this;
switch (_that) {
case LibClientStateEmpty():
return empty(_that);case LibClientStateInitialized():
return initialized(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LibClientStateEmpty value)?  empty,TResult? Function( LibClientStateInitialized value)?  initialized,}){
final _that = this;
switch (_that) {
case LibClientStateEmpty() when empty != null:
return empty(_that);case LibClientStateInitialized() when initialized != null:
return initialized(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  initialized,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LibClientStateEmpty() when empty != null:
return empty();case LibClientStateInitialized() when initialized != null:
return initialized();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  initialized,}) {final _that = this;
switch (_that) {
case LibClientStateEmpty():
return empty();case LibClientStateInitialized():
return initialized();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  initialized,}) {final _that = this;
switch (_that) {
case LibClientStateEmpty() when empty != null:
return empty();case LibClientStateInitialized() when initialized != null:
return initialized();case _:
  return null;

}
}

}

/// @nodoc


class LibClientStateEmpty implements LibClientState {
  const LibClientStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibClientStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LibClientState.empty()';
}


}




/// @nodoc


class LibClientStateInitialized implements LibClientState {
  const LibClientStateInitialized();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibClientStateInitialized);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LibClientState.initialized()';
}


}




// dart format on
