// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pegx_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PegxLoginState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxLoginState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegxLoginState()';
}


}

/// @nodoc
class $PegxLoginStateCopyWith<$Res>  {
$PegxLoginStateCopyWith(PegxLoginState _, $Res Function(PegxLoginState) __);
}


/// Adds pattern-matching-related methods to [PegxLoginState].
extension PegxLoginStatePatterns on PegxLoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PegxLoginStateLoading value)?  loading,TResult Function( PegxLoginStateLoginDialog value)?  loginDialog,TResult Function( PegxLoginStateLogin value)?  login,TResult Function( PegxLoginStateLogged value)?  logged,TResult Function( PegxLoginStateGaidWaiting value)?  gaidWaiting,TResult Function( PegxLoginStateGaidAdded value)?  gaidAdded,TResult Function( PegxLoginStateGaidError value)?  gaidError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PegxLoginStateLoading() when loading != null:
return loading(_that);case PegxLoginStateLoginDialog() when loginDialog != null:
return loginDialog(_that);case PegxLoginStateLogin() when login != null:
return login(_that);case PegxLoginStateLogged() when logged != null:
return logged(_that);case PegxLoginStateGaidWaiting() when gaidWaiting != null:
return gaidWaiting(_that);case PegxLoginStateGaidAdded() when gaidAdded != null:
return gaidAdded(_that);case PegxLoginStateGaidError() when gaidError != null:
return gaidError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PegxLoginStateLoading value)  loading,required TResult Function( PegxLoginStateLoginDialog value)  loginDialog,required TResult Function( PegxLoginStateLogin value)  login,required TResult Function( PegxLoginStateLogged value)  logged,required TResult Function( PegxLoginStateGaidWaiting value)  gaidWaiting,required TResult Function( PegxLoginStateGaidAdded value)  gaidAdded,required TResult Function( PegxLoginStateGaidError value)  gaidError,}){
final _that = this;
switch (_that) {
case PegxLoginStateLoading():
return loading(_that);case PegxLoginStateLoginDialog():
return loginDialog(_that);case PegxLoginStateLogin():
return login(_that);case PegxLoginStateLogged():
return logged(_that);case PegxLoginStateGaidWaiting():
return gaidWaiting(_that);case PegxLoginStateGaidAdded():
return gaidAdded(_that);case PegxLoginStateGaidError():
return gaidError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PegxLoginStateLoading value)?  loading,TResult? Function( PegxLoginStateLoginDialog value)?  loginDialog,TResult? Function( PegxLoginStateLogin value)?  login,TResult? Function( PegxLoginStateLogged value)?  logged,TResult? Function( PegxLoginStateGaidWaiting value)?  gaidWaiting,TResult? Function( PegxLoginStateGaidAdded value)?  gaidAdded,TResult? Function( PegxLoginStateGaidError value)?  gaidError,}){
final _that = this;
switch (_that) {
case PegxLoginStateLoading() when loading != null:
return loading(_that);case PegxLoginStateLoginDialog() when loginDialog != null:
return loginDialog(_that);case PegxLoginStateLogin() when login != null:
return login(_that);case PegxLoginStateLogged() when logged != null:
return logged(_that);case PegxLoginStateGaidWaiting() when gaidWaiting != null:
return gaidWaiting(_that);case PegxLoginStateGaidAdded() when gaidAdded != null:
return gaidAdded(_that);case PegxLoginStateGaidError() when gaidError != null:
return gaidError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function()?  loginDialog,TResult Function( String requestId)?  login,TResult Function()?  logged,TResult Function()?  gaidWaiting,TResult Function()?  gaidAdded,TResult Function()?  gaidError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PegxLoginStateLoading() when loading != null:
return loading();case PegxLoginStateLoginDialog() when loginDialog != null:
return loginDialog();case PegxLoginStateLogin() when login != null:
return login(_that.requestId);case PegxLoginStateLogged() when logged != null:
return logged();case PegxLoginStateGaidWaiting() when gaidWaiting != null:
return gaidWaiting();case PegxLoginStateGaidAdded() when gaidAdded != null:
return gaidAdded();case PegxLoginStateGaidError() when gaidError != null:
return gaidError();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function()  loginDialog,required TResult Function( String requestId)  login,required TResult Function()  logged,required TResult Function()  gaidWaiting,required TResult Function()  gaidAdded,required TResult Function()  gaidError,}) {final _that = this;
switch (_that) {
case PegxLoginStateLoading():
return loading();case PegxLoginStateLoginDialog():
return loginDialog();case PegxLoginStateLogin():
return login(_that.requestId);case PegxLoginStateLogged():
return logged();case PegxLoginStateGaidWaiting():
return gaidWaiting();case PegxLoginStateGaidAdded():
return gaidAdded();case PegxLoginStateGaidError():
return gaidError();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function()?  loginDialog,TResult? Function( String requestId)?  login,TResult? Function()?  logged,TResult? Function()?  gaidWaiting,TResult? Function()?  gaidAdded,TResult? Function()?  gaidError,}) {final _that = this;
switch (_that) {
case PegxLoginStateLoading() when loading != null:
return loading();case PegxLoginStateLoginDialog() when loginDialog != null:
return loginDialog();case PegxLoginStateLogin() when login != null:
return login(_that.requestId);case PegxLoginStateLogged() when logged != null:
return logged();case PegxLoginStateGaidWaiting() when gaidWaiting != null:
return gaidWaiting();case PegxLoginStateGaidAdded() when gaidAdded != null:
return gaidAdded();case PegxLoginStateGaidError() when gaidError != null:
return gaidError();case _:
  return null;

}
}

}

/// @nodoc


class PegxLoginStateLoading implements PegxLoginState {
  const PegxLoginStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxLoginStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegxLoginState.loading()';
}


}




/// @nodoc


class PegxLoginStateLoginDialog implements PegxLoginState {
  const PegxLoginStateLoginDialog();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxLoginStateLoginDialog);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegxLoginState.loginDialog()';
}


}




/// @nodoc


class PegxLoginStateLogin implements PegxLoginState {
  const PegxLoginStateLogin({required this.requestId});
  

 final  String requestId;

/// Create a copy of PegxLoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PegxLoginStateLoginCopyWith<PegxLoginStateLogin> get copyWith => _$PegxLoginStateLoginCopyWithImpl<PegxLoginStateLogin>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxLoginStateLogin&&(identical(other.requestId, requestId) || other.requestId == requestId));
}


@override
int get hashCode => Object.hash(runtimeType,requestId);

@override
String toString() {
  return 'PegxLoginState.login(requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class $PegxLoginStateLoginCopyWith<$Res> implements $PegxLoginStateCopyWith<$Res> {
  factory $PegxLoginStateLoginCopyWith(PegxLoginStateLogin value, $Res Function(PegxLoginStateLogin) _then) = _$PegxLoginStateLoginCopyWithImpl;
@useResult
$Res call({
 String requestId
});




}
/// @nodoc
class _$PegxLoginStateLoginCopyWithImpl<$Res>
    implements $PegxLoginStateLoginCopyWith<$Res> {
  _$PegxLoginStateLoginCopyWithImpl(this._self, this._then);

  final PegxLoginStateLogin _self;
  final $Res Function(PegxLoginStateLogin) _then;

/// Create a copy of PegxLoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? requestId = null,}) {
  return _then(PegxLoginStateLogin(
requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PegxLoginStateLogged implements PegxLoginState {
  const PegxLoginStateLogged();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxLoginStateLogged);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegxLoginState.logged()';
}


}




/// @nodoc


class PegxLoginStateGaidWaiting implements PegxLoginState {
  const PegxLoginStateGaidWaiting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxLoginStateGaidWaiting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegxLoginState.gaidWaiting()';
}


}




/// @nodoc


class PegxLoginStateGaidAdded implements PegxLoginState {
  const PegxLoginStateGaidAdded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxLoginStateGaidAdded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegxLoginState.gaidAdded()';
}


}




/// @nodoc


class PegxLoginStateGaidError implements PegxLoginState {
  const PegxLoginStateGaidError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxLoginStateGaidError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegxLoginState.gaidError()';
}


}




/// @nodoc
mixin _$PegxGaidState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxGaidState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegxGaidState()';
}


}

/// @nodoc
class $PegxGaidStateCopyWith<$Res>  {
$PegxGaidStateCopyWith(PegxGaidState _, $Res Function(PegxGaidState) __);
}


/// Adds pattern-matching-related methods to [PegxGaidState].
extension PegxGaidStatePatterns on PegxGaidState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PegxGaidStateEmpty value)?  empty,TResult Function( PegxGaidStateLoading value)?  loading,TResult Function( PegxGaidStateRegistered value)?  registered,TResult Function( PegxGaidStateUnregistered value)?  unregistered,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PegxGaidStateEmpty() when empty != null:
return empty(_that);case PegxGaidStateLoading() when loading != null:
return loading(_that);case PegxGaidStateRegistered() when registered != null:
return registered(_that);case PegxGaidStateUnregistered() when unregistered != null:
return unregistered(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PegxGaidStateEmpty value)  empty,required TResult Function( PegxGaidStateLoading value)  loading,required TResult Function( PegxGaidStateRegistered value)  registered,required TResult Function( PegxGaidStateUnregistered value)  unregistered,}){
final _that = this;
switch (_that) {
case PegxGaidStateEmpty():
return empty(_that);case PegxGaidStateLoading():
return loading(_that);case PegxGaidStateRegistered():
return registered(_that);case PegxGaidStateUnregistered():
return unregistered(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PegxGaidStateEmpty value)?  empty,TResult? Function( PegxGaidStateLoading value)?  loading,TResult? Function( PegxGaidStateRegistered value)?  registered,TResult? Function( PegxGaidStateUnregistered value)?  unregistered,}){
final _that = this;
switch (_that) {
case PegxGaidStateEmpty() when empty != null:
return empty(_that);case PegxGaidStateLoading() when loading != null:
return loading(_that);case PegxGaidStateRegistered() when registered != null:
return registered(_that);case PegxGaidStateUnregistered() when unregistered != null:
return unregistered(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  loading,TResult Function()?  registered,TResult Function()?  unregistered,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PegxGaidStateEmpty() when empty != null:
return empty();case PegxGaidStateLoading() when loading != null:
return loading();case PegxGaidStateRegistered() when registered != null:
return registered();case PegxGaidStateUnregistered() when unregistered != null:
return unregistered();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  loading,required TResult Function()  registered,required TResult Function()  unregistered,}) {final _that = this;
switch (_that) {
case PegxGaidStateEmpty():
return empty();case PegxGaidStateLoading():
return loading();case PegxGaidStateRegistered():
return registered();case PegxGaidStateUnregistered():
return unregistered();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  loading,TResult? Function()?  registered,TResult? Function()?  unregistered,}) {final _that = this;
switch (_that) {
case PegxGaidStateEmpty() when empty != null:
return empty();case PegxGaidStateLoading() when loading != null:
return loading();case PegxGaidStateRegistered() when registered != null:
return registered();case PegxGaidStateUnregistered() when unregistered != null:
return unregistered();case _:
  return null;

}
}

}

/// @nodoc


class PegxGaidStateEmpty implements PegxGaidState {
  const PegxGaidStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxGaidStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegxGaidState.empty()';
}


}




/// @nodoc


class PegxGaidStateLoading implements PegxGaidState {
  const PegxGaidStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxGaidStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegxGaidState.loading()';
}


}




/// @nodoc


class PegxGaidStateRegistered implements PegxGaidState {
  const PegxGaidStateRegistered();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxGaidStateRegistered);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegxGaidState.registered()';
}


}




/// @nodoc


class PegxGaidStateUnregistered implements PegxGaidState {
  const PegxGaidStateUnregistered();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PegxGaidStateUnregistered);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PegxGaidState.unregistered()';
}


}




// dart format on
