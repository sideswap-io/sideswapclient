// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_depth_container.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderDepthSide {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDepthSide);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderDepthSide()';
}


}

/// @nodoc
class $OrderDepthSideCopyWith<$Res>  {
$OrderDepthSideCopyWith(OrderDepthSide _, $Res Function(OrderDepthSide) __);
}


/// Adds pattern-matching-related methods to [OrderDepthSide].
extension OrderDepthSidePatterns on OrderDepthSide {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OrderDepthSideLeft value)?  left,TResult Function( OrderDepthSideRight value)?  right,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OrderDepthSideLeft() when left != null:
return left(_that);case OrderDepthSideRight() when right != null:
return right(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OrderDepthSideLeft value)  left,required TResult Function( OrderDepthSideRight value)  right,}){
final _that = this;
switch (_that) {
case OrderDepthSideLeft():
return left(_that);case OrderDepthSideRight():
return right(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OrderDepthSideLeft value)?  left,TResult? Function( OrderDepthSideRight value)?  right,}){
final _that = this;
switch (_that) {
case OrderDepthSideLeft() when left != null:
return left(_that);case OrderDepthSideRight() when right != null:
return right(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  left,TResult Function()?  right,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OrderDepthSideLeft() when left != null:
return left();case OrderDepthSideRight() when right != null:
return right();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  left,required TResult Function()  right,}) {final _that = this;
switch (_that) {
case OrderDepthSideLeft():
return left();case OrderDepthSideRight():
return right();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  left,TResult? Function()?  right,}) {final _that = this;
switch (_that) {
case OrderDepthSideLeft() when left != null:
return left();case OrderDepthSideRight() when right != null:
return right();case _:
  return null;

}
}

}

/// @nodoc


class OrderDepthSideLeft implements OrderDepthSide {
  const OrderDepthSideLeft();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDepthSideLeft);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderDepthSide.left()';
}


}




/// @nodoc


class OrderDepthSideRight implements OrderDepthSide {
  const OrderDepthSideRight();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDepthSideRight);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderDepthSide.right()';
}


}




// dart format on
