// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinSetupCallerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupCallerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinSetupCallerState()';
}


}

/// @nodoc
class $PinSetupCallerStateCopyWith<$Res>  {
$PinSetupCallerStateCopyWith(PinSetupCallerState _, $Res Function(PinSetupCallerState) __);
}


/// Adds pattern-matching-related methods to [PinSetupCallerState].
extension PinSetupCallerStatePatterns on PinSetupCallerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PinSetupCallerStateEmpty value)?  empty,TResult Function( PinSetupCallerStateSettings value)?  settings,TResult Function( PinSetupCallerStatePinWelcome value)?  pinWelcome,TResult Function( PinSetupCallerStateNewWalletPinWelcome value)?  newWalletPinWelcome,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PinSetupCallerStateEmpty() when empty != null:
return empty(_that);case PinSetupCallerStateSettings() when settings != null:
return settings(_that);case PinSetupCallerStatePinWelcome() when pinWelcome != null:
return pinWelcome(_that);case PinSetupCallerStateNewWalletPinWelcome() when newWalletPinWelcome != null:
return newWalletPinWelcome(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PinSetupCallerStateEmpty value)  empty,required TResult Function( PinSetupCallerStateSettings value)  settings,required TResult Function( PinSetupCallerStatePinWelcome value)  pinWelcome,required TResult Function( PinSetupCallerStateNewWalletPinWelcome value)  newWalletPinWelcome,}){
final _that = this;
switch (_that) {
case PinSetupCallerStateEmpty():
return empty(_that);case PinSetupCallerStateSettings():
return settings(_that);case PinSetupCallerStatePinWelcome():
return pinWelcome(_that);case PinSetupCallerStateNewWalletPinWelcome():
return newWalletPinWelcome(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PinSetupCallerStateEmpty value)?  empty,TResult? Function( PinSetupCallerStateSettings value)?  settings,TResult? Function( PinSetupCallerStatePinWelcome value)?  pinWelcome,TResult? Function( PinSetupCallerStateNewWalletPinWelcome value)?  newWalletPinWelcome,}){
final _that = this;
switch (_that) {
case PinSetupCallerStateEmpty() when empty != null:
return empty(_that);case PinSetupCallerStateSettings() when settings != null:
return settings(_that);case PinSetupCallerStatePinWelcome() when pinWelcome != null:
return pinWelcome(_that);case PinSetupCallerStateNewWalletPinWelcome() when newWalletPinWelcome != null:
return newWalletPinWelcome(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  settings,TResult Function()?  pinWelcome,TResult Function()?  newWalletPinWelcome,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PinSetupCallerStateEmpty() when empty != null:
return empty();case PinSetupCallerStateSettings() when settings != null:
return settings();case PinSetupCallerStatePinWelcome() when pinWelcome != null:
return pinWelcome();case PinSetupCallerStateNewWalletPinWelcome() when newWalletPinWelcome != null:
return newWalletPinWelcome();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  settings,required TResult Function()  pinWelcome,required TResult Function()  newWalletPinWelcome,}) {final _that = this;
switch (_that) {
case PinSetupCallerStateEmpty():
return empty();case PinSetupCallerStateSettings():
return settings();case PinSetupCallerStatePinWelcome():
return pinWelcome();case PinSetupCallerStateNewWalletPinWelcome():
return newWalletPinWelcome();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  settings,TResult? Function()?  pinWelcome,TResult? Function()?  newWalletPinWelcome,}) {final _that = this;
switch (_that) {
case PinSetupCallerStateEmpty() when empty != null:
return empty();case PinSetupCallerStateSettings() when settings != null:
return settings();case PinSetupCallerStatePinWelcome() when pinWelcome != null:
return pinWelcome();case PinSetupCallerStateNewWalletPinWelcome() when newWalletPinWelcome != null:
return newWalletPinWelcome();case _:
  return null;

}
}

}

/// @nodoc


class PinSetupCallerStateEmpty implements PinSetupCallerState {
  const PinSetupCallerStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupCallerStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinSetupCallerState.empty()';
}


}




/// @nodoc


class PinSetupCallerStateSettings implements PinSetupCallerState {
  const PinSetupCallerStateSettings();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupCallerStateSettings);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinSetupCallerState.settings()';
}


}




/// @nodoc


class PinSetupCallerStatePinWelcome implements PinSetupCallerState {
  const PinSetupCallerStatePinWelcome();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupCallerStatePinWelcome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinSetupCallerState.pinWelcome()';
}


}




/// @nodoc


class PinSetupCallerStateNewWalletPinWelcome implements PinSetupCallerState {
  const PinSetupCallerStateNewWalletPinWelcome();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupCallerStateNewWalletPinWelcome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinSetupCallerState.newWalletPinWelcome()';
}


}




/// @nodoc
mixin _$PinSetupExitState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupExitState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinSetupExitState()';
}


}

/// @nodoc
class $PinSetupExitStateCopyWith<$Res>  {
$PinSetupExitStateCopyWith(PinSetupExitState _, $Res Function(PinSetupExitState) __);
}


/// Adds pattern-matching-related methods to [PinSetupExitState].
extension PinSetupExitStatePatterns on PinSetupExitState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PinSetupExitStateEmpty value)?  empty,TResult Function( PinSetupExitStateBack value)?  back,TResult Function( PinSetupExitStateSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PinSetupExitStateEmpty() when empty != null:
return empty(_that);case PinSetupExitStateBack() when back != null:
return back(_that);case PinSetupExitStateSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PinSetupExitStateEmpty value)  empty,required TResult Function( PinSetupExitStateBack value)  back,required TResult Function( PinSetupExitStateSuccess value)  success,}){
final _that = this;
switch (_that) {
case PinSetupExitStateEmpty():
return empty(_that);case PinSetupExitStateBack():
return back(_that);case PinSetupExitStateSuccess():
return success(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PinSetupExitStateEmpty value)?  empty,TResult? Function( PinSetupExitStateBack value)?  back,TResult? Function( PinSetupExitStateSuccess value)?  success,}){
final _that = this;
switch (_that) {
case PinSetupExitStateEmpty() when empty != null:
return empty(_that);case PinSetupExitStateBack() when back != null:
return back(_that);case PinSetupExitStateSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  back,TResult Function()?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PinSetupExitStateEmpty() when empty != null:
return empty();case PinSetupExitStateBack() when back != null:
return back();case PinSetupExitStateSuccess() when success != null:
return success();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  back,required TResult Function()  success,}) {final _that = this;
switch (_that) {
case PinSetupExitStateEmpty():
return empty();case PinSetupExitStateBack():
return back();case PinSetupExitStateSuccess():
return success();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  back,TResult? Function()?  success,}) {final _that = this;
switch (_that) {
case PinSetupExitStateEmpty() when empty != null:
return empty();case PinSetupExitStateBack() when back != null:
return back();case PinSetupExitStateSuccess() when success != null:
return success();case _:
  return null;

}
}

}

/// @nodoc


class PinSetupExitStateEmpty implements PinSetupExitState {
  const PinSetupExitStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupExitStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinSetupExitState.empty()';
}


}




/// @nodoc


class PinSetupExitStateBack implements PinSetupExitState {
  const PinSetupExitStateBack();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupExitStateBack);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinSetupExitState.back()';
}


}




/// @nodoc


class PinSetupExitStateSuccess implements PinSetupExitState {
  const PinSetupExitStateSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupExitStateSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinSetupExitState.success()';
}


}




/// @nodoc
mixin _$PinFieldState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinFieldState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinFieldState()';
}


}

/// @nodoc
class $PinFieldStateCopyWith<$Res>  {
$PinFieldStateCopyWith(PinFieldState _, $Res Function(PinFieldState) __);
}


/// Adds pattern-matching-related methods to [PinFieldState].
extension PinFieldStatePatterns on PinFieldState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PinFieldStateFirst value)?  first,TResult Function( PinFieldStateSecond value)?  second,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PinFieldStateFirst() when first != null:
return first(_that);case PinFieldStateSecond() when second != null:
return second(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PinFieldStateFirst value)  first,required TResult Function( PinFieldStateSecond value)  second,}){
final _that = this;
switch (_that) {
case PinFieldStateFirst():
return first(_that);case PinFieldStateSecond():
return second(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PinFieldStateFirst value)?  first,TResult? Function( PinFieldStateSecond value)?  second,}){
final _that = this;
switch (_that) {
case PinFieldStateFirst() when first != null:
return first(_that);case PinFieldStateSecond() when second != null:
return second(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  first,TResult Function()?  second,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PinFieldStateFirst() when first != null:
return first();case PinFieldStateSecond() when second != null:
return second();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  first,required TResult Function()  second,}) {final _that = this;
switch (_that) {
case PinFieldStateFirst():
return first();case PinFieldStateSecond():
return second();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  first,TResult? Function()?  second,}) {final _that = this;
switch (_that) {
case PinFieldStateFirst() when first != null:
return first();case PinFieldStateSecond() when second != null:
return second();case _:
  return null;

}
}

}

/// @nodoc


class PinFieldStateFirst implements PinFieldState {
  const PinFieldStateFirst();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinFieldStateFirst);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinFieldState.first()';
}


}




/// @nodoc


class PinFieldStateSecond implements PinFieldState {
  const PinFieldStateSecond();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinFieldStateSecond);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinFieldState.second()';
}


}




/// @nodoc
mixin _$PinSetupState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinSetupState()';
}


}

/// @nodoc
class $PinSetupStateCopyWith<$Res>  {
$PinSetupStateCopyWith(PinSetupState _, $Res Function(PinSetupState) __);
}


/// Adds pattern-matching-related methods to [PinSetupState].
extension PinSetupStatePatterns on PinSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PinSetupStateIdle value)?  idle,TResult Function( PinSetupStateError value)?  error,TResult Function( PinSetupStateDone value)?  done,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PinSetupStateIdle() when idle != null:
return idle(_that);case PinSetupStateError() when error != null:
return error(_that);case PinSetupStateDone() when done != null:
return done(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PinSetupStateIdle value)  idle,required TResult Function( PinSetupStateError value)  error,required TResult Function( PinSetupStateDone value)  done,}){
final _that = this;
switch (_that) {
case PinSetupStateIdle():
return idle(_that);case PinSetupStateError():
return error(_that);case PinSetupStateDone():
return done(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PinSetupStateIdle value)?  idle,TResult? Function( PinSetupStateError value)?  error,TResult? Function( PinSetupStateDone value)?  done,}){
final _that = this;
switch (_that) {
case PinSetupStateIdle() when idle != null:
return idle(_that);case PinSetupStateError() when error != null:
return error(_that);case PinSetupStateDone() when done != null:
return done(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function( String message)?  error,TResult Function()?  done,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PinSetupStateIdle() when idle != null:
return idle();case PinSetupStateError() when error != null:
return error(_that.message);case PinSetupStateDone() when done != null:
return done();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function( String message)  error,required TResult Function()  done,}) {final _that = this;
switch (_that) {
case PinSetupStateIdle():
return idle();case PinSetupStateError():
return error(_that.message);case PinSetupStateDone():
return done();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function( String message)?  error,TResult? Function()?  done,}) {final _that = this;
switch (_that) {
case PinSetupStateIdle() when idle != null:
return idle();case PinSetupStateError() when error != null:
return error(_that.message);case PinSetupStateDone() when done != null:
return done();case _:
  return null;

}
}

}

/// @nodoc


class PinSetupStateIdle implements PinSetupState {
  const PinSetupStateIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupStateIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinSetupState.idle()';
}


}




/// @nodoc


class PinSetupStateError implements PinSetupState {
  const PinSetupStateError({required this.message});
  

 final  String message;

/// Create a copy of PinSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinSetupStateErrorCopyWith<PinSetupStateError> get copyWith => _$PinSetupStateErrorCopyWithImpl<PinSetupStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PinSetupState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PinSetupStateErrorCopyWith<$Res> implements $PinSetupStateCopyWith<$Res> {
  factory $PinSetupStateErrorCopyWith(PinSetupStateError value, $Res Function(PinSetupStateError) _then) = _$PinSetupStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PinSetupStateErrorCopyWithImpl<$Res>
    implements $PinSetupStateErrorCopyWith<$Res> {
  _$PinSetupStateErrorCopyWithImpl(this._self, this._then);

  final PinSetupStateError _self;
  final $Res Function(PinSetupStateError) _then;

/// Create a copy of PinSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PinSetupStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PinSetupStateDone implements PinSetupState {
  const PinSetupStateDone();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupStateDone);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinSetupState.done()';
}


}




PinDataState _$PinDataStateFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'empty':
          return PinDataStateEmpty.fromJson(
            json
          );
                case 'error':
          return PinDataStateError.fromJson(
            json
          );
                case 'data':
          return PinDataStateData.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'PinDataState',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$PinDataState {



  /// Serializes this PinDataState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinDataState);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinDataState()';
}


}

/// @nodoc
class $PinDataStateCopyWith<$Res>  {
$PinDataStateCopyWith(PinDataState _, $Res Function(PinDataState) __);
}


/// Adds pattern-matching-related methods to [PinDataState].
extension PinDataStatePatterns on PinDataState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PinDataStateEmpty value)?  empty,TResult Function( PinDataStateError value)?  error,TResult Function( PinDataStateData value)?  data,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PinDataStateEmpty() when empty != null:
return empty(_that);case PinDataStateError() when error != null:
return error(_that);case PinDataStateData() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PinDataStateEmpty value)  empty,required TResult Function( PinDataStateError value)  error,required TResult Function( PinDataStateData value)  data,}){
final _that = this;
switch (_that) {
case PinDataStateEmpty():
return empty(_that);case PinDataStateError():
return error(_that);case PinDataStateData():
return data(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PinDataStateEmpty value)?  empty,TResult? Function( PinDataStateError value)?  error,TResult? Function( PinDataStateData value)?  data,}){
final _that = this;
switch (_that) {
case PinDataStateEmpty() when empty != null:
return empty(_that);case PinDataStateError() when error != null:
return error(_that);case PinDataStateData() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function( String message)?  error,TResult Function( String salt,  String encryptedData,  String pinIdentifier,  String hmac)?  data,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PinDataStateEmpty() when empty != null:
return empty();case PinDataStateError() when error != null:
return error(_that.message);case PinDataStateData() when data != null:
return data(_that.salt,_that.encryptedData,_that.pinIdentifier,_that.hmac);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function( String message)  error,required TResult Function( String salt,  String encryptedData,  String pinIdentifier,  String hmac)  data,}) {final _that = this;
switch (_that) {
case PinDataStateEmpty():
return empty();case PinDataStateError():
return error(_that.message);case PinDataStateData():
return data(_that.salt,_that.encryptedData,_that.pinIdentifier,_that.hmac);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function( String message)?  error,TResult? Function( String salt,  String encryptedData,  String pinIdentifier,  String hmac)?  data,}) {final _that = this;
switch (_that) {
case PinDataStateEmpty() when empty != null:
return empty();case PinDataStateError() when error != null:
return error(_that.message);case PinDataStateData() when data != null:
return data(_that.salt,_that.encryptedData,_that.pinIdentifier,_that.hmac);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class PinDataStateEmpty implements PinDataState {
  const PinDataStateEmpty({final  String? $type}): $type = $type ?? 'empty';
  factory PinDataStateEmpty.fromJson(Map<String, dynamic> json) => _$PinDataStateEmptyFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$PinDataStateEmptyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinDataStateEmpty);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinDataState.empty()';
}


}




/// @nodoc
@JsonSerializable()

class PinDataStateError implements PinDataState {
  const PinDataStateError({required this.message, final  String? $type}): $type = $type ?? 'error';
  factory PinDataStateError.fromJson(Map<String, dynamic> json) => _$PinDataStateErrorFromJson(json);

 final  String message;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of PinDataState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinDataStateErrorCopyWith<PinDataStateError> get copyWith => _$PinDataStateErrorCopyWithImpl<PinDataStateError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PinDataStateErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinDataStateError&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PinDataState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PinDataStateErrorCopyWith<$Res> implements $PinDataStateCopyWith<$Res> {
  factory $PinDataStateErrorCopyWith(PinDataStateError value, $Res Function(PinDataStateError) _then) = _$PinDataStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$PinDataStateErrorCopyWithImpl<$Res>
    implements $PinDataStateErrorCopyWith<$Res> {
  _$PinDataStateErrorCopyWithImpl(this._self, this._then);

  final PinDataStateError _self;
  final $Res Function(PinDataStateError) _then;

/// Create a copy of PinDataState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(PinDataStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PinDataStateData implements PinDataState {
  const PinDataStateData({required this.salt, required this.encryptedData, required this.pinIdentifier, required this.hmac, final  String? $type}): $type = $type ?? 'data';
  factory PinDataStateData.fromJson(Map<String, dynamic> json) => _$PinDataStateDataFromJson(json);

 final  String salt;
 final  String encryptedData;
 final  String pinIdentifier;
 final  String hmac;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of PinDataState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinDataStateDataCopyWith<PinDataStateData> get copyWith => _$PinDataStateDataCopyWithImpl<PinDataStateData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PinDataStateDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinDataStateData&&(identical(other.salt, salt) || other.salt == salt)&&(identical(other.encryptedData, encryptedData) || other.encryptedData == encryptedData)&&(identical(other.pinIdentifier, pinIdentifier) || other.pinIdentifier == pinIdentifier)&&(identical(other.hmac, hmac) || other.hmac == hmac));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,salt,encryptedData,pinIdentifier,hmac);

@override
String toString() {
  return 'PinDataState.data(salt: $salt, encryptedData: $encryptedData, pinIdentifier: $pinIdentifier, hmac: $hmac)';
}


}

/// @nodoc
abstract mixin class $PinDataStateDataCopyWith<$Res> implements $PinDataStateCopyWith<$Res> {
  factory $PinDataStateDataCopyWith(PinDataStateData value, $Res Function(PinDataStateData) _then) = _$PinDataStateDataCopyWithImpl;
@useResult
$Res call({
 String salt, String encryptedData, String pinIdentifier, String hmac
});




}
/// @nodoc
class _$PinDataStateDataCopyWithImpl<$Res>
    implements $PinDataStateDataCopyWith<$Res> {
  _$PinDataStateDataCopyWithImpl(this._self, this._then);

  final PinDataStateData _self;
  final $Res Function(PinDataStateData) _then;

/// Create a copy of PinDataState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? salt = null,Object? encryptedData = null,Object? pinIdentifier = null,Object? hmac = null,}) {
  return _then(PinDataStateData(
salt: null == salt ? _self.salt : salt // ignore: cast_nullable_to_non_nullable
as String,encryptedData: null == encryptedData ? _self.encryptedData : encryptedData // ignore: cast_nullable_to_non_nullable
as String,pinIdentifier: null == pinIdentifier ? _self.pinIdentifier : pinIdentifier // ignore: cast_nullable_to_non_nullable
as String,hmac: null == hmac ? _self.hmac : hmac // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PinProtectionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinProtectionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinProtectionState()';
}


}

/// @nodoc
class $PinProtectionStateCopyWith<$Res>  {
$PinProtectionStateCopyWith(PinProtectionState _, $Res Function(PinProtectionState) __);
}


/// Adds pattern-matching-related methods to [PinProtectionState].
extension PinProtectionStatePatterns on PinProtectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PinProtectionStateIdle value)?  idle,TResult Function( PinProtectionStateWaiting value)?  waiting,TResult Function( PinProtectionStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PinProtectionStateIdle() when idle != null:
return idle(_that);case PinProtectionStateWaiting() when waiting != null:
return waiting(_that);case PinProtectionStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PinProtectionStateIdle value)  idle,required TResult Function( PinProtectionStateWaiting value)  waiting,required TResult Function( PinProtectionStateError value)  error,}){
final _that = this;
switch (_that) {
case PinProtectionStateIdle():
return idle(_that);case PinProtectionStateWaiting():
return waiting(_that);case PinProtectionStateError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PinProtectionStateIdle value)?  idle,TResult? Function( PinProtectionStateWaiting value)?  waiting,TResult? Function( PinProtectionStateError value)?  error,}){
final _that = this;
switch (_that) {
case PinProtectionStateIdle() when idle != null:
return idle(_that);case PinProtectionStateWaiting() when waiting != null:
return waiting(_that);case PinProtectionStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  waiting,TResult Function( String? message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PinProtectionStateIdle() when idle != null:
return idle();case PinProtectionStateWaiting() when waiting != null:
return waiting();case PinProtectionStateError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  waiting,required TResult Function( String? message)  error,}) {final _that = this;
switch (_that) {
case PinProtectionStateIdle():
return idle();case PinProtectionStateWaiting():
return waiting();case PinProtectionStateError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  waiting,TResult? Function( String? message)?  error,}) {final _that = this;
switch (_that) {
case PinProtectionStateIdle() when idle != null:
return idle();case PinProtectionStateWaiting() when waiting != null:
return waiting();case PinProtectionStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class PinProtectionStateIdle implements PinProtectionState {
  const PinProtectionStateIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinProtectionStateIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinProtectionState.idle()';
}


}




/// @nodoc


class PinProtectionStateWaiting implements PinProtectionState {
  const PinProtectionStateWaiting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinProtectionStateWaiting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinProtectionState.waiting()';
}


}




/// @nodoc


class PinProtectionStateError implements PinProtectionState {
  const PinProtectionStateError({this.message});
  

 final  String? message;

/// Create a copy of PinProtectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinProtectionStateErrorCopyWith<PinProtectionStateError> get copyWith => _$PinProtectionStateErrorCopyWithImpl<PinProtectionStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinProtectionStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'PinProtectionState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $PinProtectionStateErrorCopyWith<$Res> implements $PinProtectionStateCopyWith<$Res> {
  factory $PinProtectionStateErrorCopyWith(PinProtectionStateError value, $Res Function(PinProtectionStateError) _then) = _$PinProtectionStateErrorCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$PinProtectionStateErrorCopyWithImpl<$Res>
    implements $PinProtectionStateErrorCopyWith<$Res> {
  _$PinProtectionStateErrorCopyWithImpl(this._self, this._then);

  final PinProtectionStateError _self;
  final $Res Function(PinProtectionStateError) _then;

/// Create a copy of PinProtectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(PinProtectionStateError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
