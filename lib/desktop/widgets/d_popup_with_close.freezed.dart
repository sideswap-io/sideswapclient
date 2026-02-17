// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'd_popup_with_close.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DialogReturnValue {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogReturnValue);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DialogReturnValue()';
}


}

/// @nodoc
class $DialogReturnValueCopyWith<$Res>  {
$DialogReturnValueCopyWith(DialogReturnValue _, $Res Function(DialogReturnValue) __);
}


/// Adds pattern-matching-related methods to [DialogReturnValue].
extension DialogReturnValuePatterns on DialogReturnValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DialogReturnValueCancelled value)?  cancelled,TResult Function( DialogReturnValueAccepted value)?  accepted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DialogReturnValueCancelled() when cancelled != null:
return cancelled(_that);case DialogReturnValueAccepted() when accepted != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DialogReturnValueCancelled value)  cancelled,required TResult Function( DialogReturnValueAccepted value)  accepted,}){
final _that = this;
switch (_that) {
case DialogReturnValueCancelled():
return cancelled(_that);case DialogReturnValueAccepted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DialogReturnValueCancelled value)?  cancelled,TResult? Function( DialogReturnValueAccepted value)?  accepted,}){
final _that = this;
switch (_that) {
case DialogReturnValueCancelled() when cancelled != null:
return cancelled(_that);case DialogReturnValueAccepted() when accepted != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  cancelled,TResult Function()?  accepted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DialogReturnValueCancelled() when cancelled != null:
return cancelled();case DialogReturnValueAccepted() when accepted != null:
return accepted();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  cancelled,required TResult Function()  accepted,}) {final _that = this;
switch (_that) {
case DialogReturnValueCancelled():
return cancelled();case DialogReturnValueAccepted():
return accepted();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  cancelled,TResult? Function()?  accepted,}) {final _that = this;
switch (_that) {
case DialogReturnValueCancelled() when cancelled != null:
return cancelled();case DialogReturnValueAccepted() when accepted != null:
return accepted();case _:
  return null;

}
}

}

/// @nodoc


class DialogReturnValueCancelled implements DialogReturnValue {
  const DialogReturnValueCancelled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogReturnValueCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DialogReturnValue.cancelled()';
}


}




/// @nodoc


class DialogReturnValueAccepted implements DialogReturnValue {
  const DialogReturnValueAccepted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialogReturnValueAccepted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DialogReturnValue.accepted()';
}


}




// dart format on
