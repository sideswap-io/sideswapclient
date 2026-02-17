// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_protection_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinUnlockState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinUnlockState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinUnlockState()';
}


}

/// @nodoc
class $PinUnlockStateCopyWith<$Res>  {
$PinUnlockStateCopyWith(PinUnlockState _, $Res Function(PinUnlockState) __);
}


/// Adds pattern-matching-related methods to [PinUnlockState].
extension PinUnlockStatePatterns on PinUnlockState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PinUnlockStateEmpty value)?  empty,TResult Function( PinUnlockStateSuccess value)?  success,TResult Function( PinUnlockStateWrong value)?  wrong,TResult Function( PinUnlockStateFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PinUnlockStateEmpty() when empty != null:
return empty(_that);case PinUnlockStateSuccess() when success != null:
return success(_that);case PinUnlockStateWrong() when wrong != null:
return wrong(_that);case PinUnlockStateFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PinUnlockStateEmpty value)  empty,required TResult Function( PinUnlockStateSuccess value)  success,required TResult Function( PinUnlockStateWrong value)  wrong,required TResult Function( PinUnlockStateFailed value)  failed,}){
final _that = this;
switch (_that) {
case PinUnlockStateEmpty():
return empty(_that);case PinUnlockStateSuccess():
return success(_that);case PinUnlockStateWrong():
return wrong(_that);case PinUnlockStateFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PinUnlockStateEmpty value)?  empty,TResult? Function( PinUnlockStateSuccess value)?  success,TResult? Function( PinUnlockStateWrong value)?  wrong,TResult? Function( PinUnlockStateFailed value)?  failed,}){
final _that = this;
switch (_that) {
case PinUnlockStateEmpty() when empty != null:
return empty(_that);case PinUnlockStateSuccess() when success != null:
return success(_that);case PinUnlockStateWrong() when wrong != null:
return wrong(_that);case PinUnlockStateFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  success,TResult Function( int attempt)?  wrong,TResult Function()?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PinUnlockStateEmpty() when empty != null:
return empty();case PinUnlockStateSuccess() when success != null:
return success();case PinUnlockStateWrong() when wrong != null:
return wrong(_that.attempt);case PinUnlockStateFailed() when failed != null:
return failed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  success,required TResult Function( int attempt)  wrong,required TResult Function()  failed,}) {final _that = this;
switch (_that) {
case PinUnlockStateEmpty():
return empty();case PinUnlockStateSuccess():
return success();case PinUnlockStateWrong():
return wrong(_that.attempt);case PinUnlockStateFailed():
return failed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  success,TResult? Function( int attempt)?  wrong,TResult? Function()?  failed,}) {final _that = this;
switch (_that) {
case PinUnlockStateEmpty() when empty != null:
return empty();case PinUnlockStateSuccess() when success != null:
return success();case PinUnlockStateWrong() when wrong != null:
return wrong(_that.attempt);case PinUnlockStateFailed() when failed != null:
return failed();case _:
  return null;

}
}

}

/// @nodoc


class PinUnlockStateEmpty implements PinUnlockState {
  const PinUnlockStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinUnlockStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinUnlockState.empty()';
}


}




/// @nodoc


class PinUnlockStateSuccess implements PinUnlockState {
  const PinUnlockStateSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinUnlockStateSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinUnlockState.success()';
}


}




/// @nodoc


class PinUnlockStateWrong implements PinUnlockState {
  const PinUnlockStateWrong({this.attempt = 0});
  

@JsonKey() final  int attempt;

/// Create a copy of PinUnlockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinUnlockStateWrongCopyWith<PinUnlockStateWrong> get copyWith => _$PinUnlockStateWrongCopyWithImpl<PinUnlockStateWrong>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinUnlockStateWrong&&(identical(other.attempt, attempt) || other.attempt == attempt));
}


@override
int get hashCode => Object.hash(runtimeType,attempt);

@override
String toString() {
  return 'PinUnlockState.wrong(attempt: $attempt)';
}


}

/// @nodoc
abstract mixin class $PinUnlockStateWrongCopyWith<$Res> implements $PinUnlockStateCopyWith<$Res> {
  factory $PinUnlockStateWrongCopyWith(PinUnlockStateWrong value, $Res Function(PinUnlockStateWrong) _then) = _$PinUnlockStateWrongCopyWithImpl;
@useResult
$Res call({
 int attempt
});




}
/// @nodoc
class _$PinUnlockStateWrongCopyWithImpl<$Res>
    implements $PinUnlockStateWrongCopyWith<$Res> {
  _$PinUnlockStateWrongCopyWithImpl(this._self, this._then);

  final PinUnlockStateWrong _self;
  final $Res Function(PinUnlockStateWrong) _then;

/// Create a copy of PinUnlockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? attempt = null,}) {
  return _then(PinUnlockStateWrong(
attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class PinUnlockStateFailed implements PinUnlockState {
  const PinUnlockStateFailed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinUnlockStateFailed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinUnlockState.failed()';
}


}




// dart format on
