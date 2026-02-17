// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerLoginState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerLoginState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerLoginState()';
}


}

/// @nodoc
class $ServerLoginStateCopyWith<$Res>  {
$ServerLoginStateCopyWith(ServerLoginState _, $Res Function(ServerLoginState) __);
}


/// Adds pattern-matching-related methods to [ServerLoginState].
extension ServerLoginStatePatterns on ServerLoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ServerLoginStateLogout value)?  logout,TResult Function( ServerLoginStateLogin value)?  login,TResult Function( ServerLoginStateError value)?  error,TResult Function( ServerLoginStateLoginProcessing value)?  loginProcessing,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ServerLoginStateLogout() when logout != null:
return logout(_that);case ServerLoginStateLogin() when login != null:
return login(_that);case ServerLoginStateError() when error != null:
return error(_that);case ServerLoginStateLoginProcessing() when loginProcessing != null:
return loginProcessing(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ServerLoginStateLogout value)  logout,required TResult Function( ServerLoginStateLogin value)  login,required TResult Function( ServerLoginStateError value)  error,required TResult Function( ServerLoginStateLoginProcessing value)  loginProcessing,}){
final _that = this;
switch (_that) {
case ServerLoginStateLogout():
return logout(_that);case ServerLoginStateLogin():
return login(_that);case ServerLoginStateError():
return error(_that);case ServerLoginStateLoginProcessing():
return loginProcessing(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ServerLoginStateLogout value)?  logout,TResult? Function( ServerLoginStateLogin value)?  login,TResult? Function( ServerLoginStateError value)?  error,TResult? Function( ServerLoginStateLoginProcessing value)?  loginProcessing,}){
final _that = this;
switch (_that) {
case ServerLoginStateLogout() when logout != null:
return logout(_that);case ServerLoginStateLogin() when login != null:
return login(_that);case ServerLoginStateError() when error != null:
return error(_that);case ServerLoginStateLoginProcessing() when loginProcessing != null:
return loginProcessing(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  logout,TResult Function()?  login,TResult Function( String? message)?  error,TResult Function()?  loginProcessing,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ServerLoginStateLogout() when logout != null:
return logout();case ServerLoginStateLogin() when login != null:
return login();case ServerLoginStateError() when error != null:
return error(_that.message);case ServerLoginStateLoginProcessing() when loginProcessing != null:
return loginProcessing();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  logout,required TResult Function()  login,required TResult Function( String? message)  error,required TResult Function()  loginProcessing,}) {final _that = this;
switch (_that) {
case ServerLoginStateLogout():
return logout();case ServerLoginStateLogin():
return login();case ServerLoginStateError():
return error(_that.message);case ServerLoginStateLoginProcessing():
return loginProcessing();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  logout,TResult? Function()?  login,TResult? Function( String? message)?  error,TResult? Function()?  loginProcessing,}) {final _that = this;
switch (_that) {
case ServerLoginStateLogout() when logout != null:
return logout();case ServerLoginStateLogin() when login != null:
return login();case ServerLoginStateError() when error != null:
return error(_that.message);case ServerLoginStateLoginProcessing() when loginProcessing != null:
return loginProcessing();case _:
  return null;

}
}

}

/// @nodoc


class ServerLoginStateLogout implements ServerLoginState {
  const ServerLoginStateLogout();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerLoginStateLogout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerLoginState.logout()';
}


}




/// @nodoc


class ServerLoginStateLogin implements ServerLoginState {
  const ServerLoginStateLogin();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerLoginStateLogin);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerLoginState.login()';
}


}




/// @nodoc


class ServerLoginStateError implements ServerLoginState {
  const ServerLoginStateError({this.message});
  

 final  String? message;

/// Create a copy of ServerLoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerLoginStateErrorCopyWith<ServerLoginStateError> get copyWith => _$ServerLoginStateErrorCopyWithImpl<ServerLoginStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerLoginStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ServerLoginState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ServerLoginStateErrorCopyWith<$Res> implements $ServerLoginStateCopyWith<$Res> {
  factory $ServerLoginStateErrorCopyWith(ServerLoginStateError value, $Res Function(ServerLoginStateError) _then) = _$ServerLoginStateErrorCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$ServerLoginStateErrorCopyWithImpl<$Res>
    implements $ServerLoginStateErrorCopyWith<$Res> {
  _$ServerLoginStateErrorCopyWithImpl(this._self, this._then);

  final ServerLoginStateError _self;
  final $Res Function(ServerLoginStateError) _then;

/// Create a copy of ServerLoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(ServerLoginStateError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ServerLoginStateLoginProcessing implements ServerLoginState {
  const ServerLoginStateLoginProcessing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerLoginStateLoginProcessing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerLoginState.loginProcessing()';
}


}




// dart format on
