// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chart_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChartsSubscriptionFlag {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChartsSubscriptionFlag);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChartsSubscriptionFlag()';
}


}

/// @nodoc
class $ChartsSubscriptionFlagCopyWith<$Res>  {
$ChartsSubscriptionFlagCopyWith(ChartsSubscriptionFlag _, $Res Function(ChartsSubscriptionFlag) __);
}


/// Adds pattern-matching-related methods to [ChartsSubscriptionFlag].
extension ChartsSubscriptionFlagPatterns on ChartsSubscriptionFlag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChartsSubscriptionFlagSubscribed value)?  subscribed,TResult Function( ChartsSubscriptionFlagUnsubscribed value)?  unsubscribed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChartsSubscriptionFlagSubscribed() when subscribed != null:
return subscribed(_that);case ChartsSubscriptionFlagUnsubscribed() when unsubscribed != null:
return unsubscribed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChartsSubscriptionFlagSubscribed value)  subscribed,required TResult Function( ChartsSubscriptionFlagUnsubscribed value)  unsubscribed,}){
final _that = this;
switch (_that) {
case ChartsSubscriptionFlagSubscribed():
return subscribed(_that);case ChartsSubscriptionFlagUnsubscribed():
return unsubscribed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChartsSubscriptionFlagSubscribed value)?  subscribed,TResult? Function( ChartsSubscriptionFlagUnsubscribed value)?  unsubscribed,}){
final _that = this;
switch (_that) {
case ChartsSubscriptionFlagSubscribed() when subscribed != null:
return subscribed(_that);case ChartsSubscriptionFlagUnsubscribed() when unsubscribed != null:
return unsubscribed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  subscribed,TResult Function()?  unsubscribed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChartsSubscriptionFlagSubscribed() when subscribed != null:
return subscribed();case ChartsSubscriptionFlagUnsubscribed() when unsubscribed != null:
return unsubscribed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  subscribed,required TResult Function()  unsubscribed,}) {final _that = this;
switch (_that) {
case ChartsSubscriptionFlagSubscribed():
return subscribed();case ChartsSubscriptionFlagUnsubscribed():
return unsubscribed();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  subscribed,TResult? Function()?  unsubscribed,}) {final _that = this;
switch (_that) {
case ChartsSubscriptionFlagSubscribed() when subscribed != null:
return subscribed();case ChartsSubscriptionFlagUnsubscribed() when unsubscribed != null:
return unsubscribed();case _:
  return null;

}
}

}

/// @nodoc


class ChartsSubscriptionFlagSubscribed implements ChartsSubscriptionFlag {
  const ChartsSubscriptionFlagSubscribed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChartsSubscriptionFlagSubscribed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChartsSubscriptionFlag.subscribed()';
}


}




/// @nodoc


class ChartsSubscriptionFlagUnsubscribed implements ChartsSubscriptionFlag {
  const ChartsSubscriptionFlagUnsubscribed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChartsSubscriptionFlagUnsubscribed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChartsSubscriptionFlag.unsubscribed()';
}


}




// dart format on
