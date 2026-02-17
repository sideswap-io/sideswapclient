// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_panel_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RequestOrderSortFlag {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestOrderSortFlag);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestOrderSortFlag()';
}


}

/// @nodoc
class $RequestOrderSortFlagCopyWith<$Res>  {
$RequestOrderSortFlagCopyWith(RequestOrderSortFlag _, $Res Function(RequestOrderSortFlag) __);
}


/// Adds pattern-matching-related methods to [RequestOrderSortFlag].
extension RequestOrderSortFlagPatterns on RequestOrderSortFlag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RequestOrderSortFlagAll value)?  all,TResult Function( RequestOrderSortFlagOnline value)?  online,TResult Function( RequestOrderSortFlagOffline value)?  offline,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RequestOrderSortFlagAll() when all != null:
return all(_that);case RequestOrderSortFlagOnline() when online != null:
return online(_that);case RequestOrderSortFlagOffline() when offline != null:
return offline(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RequestOrderSortFlagAll value)  all,required TResult Function( RequestOrderSortFlagOnline value)  online,required TResult Function( RequestOrderSortFlagOffline value)  offline,}){
final _that = this;
switch (_that) {
case RequestOrderSortFlagAll():
return all(_that);case RequestOrderSortFlagOnline():
return online(_that);case RequestOrderSortFlagOffline():
return offline(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RequestOrderSortFlagAll value)?  all,TResult? Function( RequestOrderSortFlagOnline value)?  online,TResult? Function( RequestOrderSortFlagOffline value)?  offline,}){
final _that = this;
switch (_that) {
case RequestOrderSortFlagAll() when all != null:
return all(_that);case RequestOrderSortFlagOnline() when online != null:
return online(_that);case RequestOrderSortFlagOffline() when offline != null:
return offline(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  all,TResult Function()?  online,TResult Function()?  offline,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RequestOrderSortFlagAll() when all != null:
return all();case RequestOrderSortFlagOnline() when online != null:
return online();case RequestOrderSortFlagOffline() when offline != null:
return offline();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  all,required TResult Function()  online,required TResult Function()  offline,}) {final _that = this;
switch (_that) {
case RequestOrderSortFlagAll():
return all();case RequestOrderSortFlagOnline():
return online();case RequestOrderSortFlagOffline():
return offline();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  all,TResult? Function()?  online,TResult? Function()?  offline,}) {final _that = this;
switch (_that) {
case RequestOrderSortFlagAll() when all != null:
return all();case RequestOrderSortFlagOnline() when online != null:
return online();case RequestOrderSortFlagOffline() when offline != null:
return offline();case _:
  return null;

}
}

}

/// @nodoc


class RequestOrderSortFlagAll implements RequestOrderSortFlag {
  const RequestOrderSortFlagAll();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestOrderSortFlagAll);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestOrderSortFlag.all()';
}


}




/// @nodoc


class RequestOrderSortFlagOnline implements RequestOrderSortFlag {
  const RequestOrderSortFlagOnline();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestOrderSortFlagOnline);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestOrderSortFlag.online()';
}


}




/// @nodoc


class RequestOrderSortFlagOffline implements RequestOrderSortFlag {
  const RequestOrderSortFlagOffline();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestOrderSortFlagOffline);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RequestOrderSortFlag.offline()';
}


}




/// @nodoc
mixin _$InternalUiOrderType {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternalUiOrderType);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InternalUiOrderType()';
}


}

/// @nodoc
class $InternalUiOrderTypeCopyWith<$Res>  {
$InternalUiOrderTypeCopyWith(InternalUiOrderType _, $Res Function(InternalUiOrderType) __);
}


/// Adds pattern-matching-related methods to [InternalUiOrderType].
extension InternalUiOrderTypePatterns on InternalUiOrderType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InternalUiOrderTypePublic value)?  public,TResult Function( InternalUiOrderTypeOwn value)?  own,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InternalUiOrderTypePublic() when public != null:
return public(_that);case InternalUiOrderTypeOwn() when own != null:
return own(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InternalUiOrderTypePublic value)  public,required TResult Function( InternalUiOrderTypeOwn value)  own,}){
final _that = this;
switch (_that) {
case InternalUiOrderTypePublic():
return public(_that);case InternalUiOrderTypeOwn():
return own(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InternalUiOrderTypePublic value)?  public,TResult? Function( InternalUiOrderTypeOwn value)?  own,}){
final _that = this;
switch (_that) {
case InternalUiOrderTypePublic() when public != null:
return public(_that);case InternalUiOrderTypeOwn() when own != null:
return own(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  public,TResult Function()?  own,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InternalUiOrderTypePublic() when public != null:
return public();case InternalUiOrderTypeOwn() when own != null:
return own();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  public,required TResult Function()  own,}) {final _that = this;
switch (_that) {
case InternalUiOrderTypePublic():
return public();case InternalUiOrderTypeOwn():
return own();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  public,TResult? Function()?  own,}) {final _that = this;
switch (_that) {
case InternalUiOrderTypePublic() when public != null:
return public();case InternalUiOrderTypeOwn() when own != null:
return own();case _:
  return null;

}
}

}

/// @nodoc


class InternalUiOrderTypePublic implements InternalUiOrderType {
  const InternalUiOrderTypePublic();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternalUiOrderTypePublic);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InternalUiOrderType.public()';
}


}




/// @nodoc


class InternalUiOrderTypeOwn implements InternalUiOrderType {
  const InternalUiOrderTypeOwn();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternalUiOrderTypeOwn);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InternalUiOrderType.own()';
}


}




// dart format on
