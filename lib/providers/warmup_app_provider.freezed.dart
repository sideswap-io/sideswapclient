// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warmup_app_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WarmupAppState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WarmupAppState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WarmupAppState()';
}


}

/// @nodoc
class $WarmupAppStateCopyWith<$Res>  {
$WarmupAppStateCopyWith(WarmupAppState _, $Res Function(WarmupAppState) __);
}


/// Adds pattern-matching-related methods to [WarmupAppState].
extension WarmupAppStatePatterns on WarmupAppState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WarmupAppStateUninitialized value)?  uninitialized,TResult Function( WarmupAppStateInitialized value)?  initialized,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WarmupAppStateUninitialized() when uninitialized != null:
return uninitialized(_that);case WarmupAppStateInitialized() when initialized != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WarmupAppStateUninitialized value)  uninitialized,required TResult Function( WarmupAppStateInitialized value)  initialized,}){
final _that = this;
switch (_that) {
case WarmupAppStateUninitialized():
return uninitialized(_that);case WarmupAppStateInitialized():
return initialized(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WarmupAppStateUninitialized value)?  uninitialized,TResult? Function( WarmupAppStateInitialized value)?  initialized,}){
final _that = this;
switch (_that) {
case WarmupAppStateUninitialized() when uninitialized != null:
return uninitialized(_that);case WarmupAppStateInitialized() when initialized != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  uninitialized,TResult Function()?  initialized,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WarmupAppStateUninitialized() when uninitialized != null:
return uninitialized();case WarmupAppStateInitialized() when initialized != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  uninitialized,required TResult Function()  initialized,}) {final _that = this;
switch (_that) {
case WarmupAppStateUninitialized():
return uninitialized();case WarmupAppStateInitialized():
return initialized();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  uninitialized,TResult? Function()?  initialized,}) {final _that = this;
switch (_that) {
case WarmupAppStateUninitialized() when uninitialized != null:
return uninitialized();case WarmupAppStateInitialized() when initialized != null:
return initialized();case _:
  return null;

}
}

}

/// @nodoc


class WarmupAppStateUninitialized implements WarmupAppState {
  const WarmupAppStateUninitialized();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WarmupAppStateUninitialized);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WarmupAppState.uninitialized()';
}


}




/// @nodoc


class WarmupAppStateInitialized implements WarmupAppState {
  const WarmupAppStateInitialized();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WarmupAppStateInitialized);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WarmupAppState.initialized()';
}


}




// dart format on
