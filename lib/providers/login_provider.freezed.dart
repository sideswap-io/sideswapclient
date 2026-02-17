// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState()';
}


}

/// @nodoc
class $LoginStateCopyWith<$Res>  {
$LoginStateCopyWith(LoginState _, $Res Function(LoginState) __);
}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoginStateEmpty value)?  empty,TResult Function( LoginStateLogin value)?  login,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoginStateEmpty() when empty != null:
return empty(_that);case LoginStateLogin() when login != null:
return login(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoginStateEmpty value)  empty,required TResult Function( LoginStateLogin value)  login,}){
final _that = this;
switch (_that) {
case LoginStateEmpty():
return empty(_that);case LoginStateLogin():
return login(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoginStateEmpty value)?  empty,TResult? Function( LoginStateLogin value)?  login,}){
final _that = this;
switch (_that) {
case LoginStateEmpty() when empty != null:
return empty(_that);case LoginStateLogin() when login != null:
return login(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function( String? mnemonic,  String? jadeId)?  login,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoginStateEmpty() when empty != null:
return empty();case LoginStateLogin() when login != null:
return login(_that.mnemonic,_that.jadeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function( String? mnemonic,  String? jadeId)  login,}) {final _that = this;
switch (_that) {
case LoginStateEmpty():
return empty();case LoginStateLogin():
return login(_that.mnemonic,_that.jadeId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function( String? mnemonic,  String? jadeId)?  login,}) {final _that = this;
switch (_that) {
case LoginStateEmpty() when empty != null:
return empty();case LoginStateLogin() when login != null:
return login(_that.mnemonic,_that.jadeId);case _:
  return null;

}
}

}

/// @nodoc


class LoginStateEmpty implements LoginState {
  const LoginStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState.empty()';
}


}




/// @nodoc


class LoginStateLogin implements LoginState {
  const LoginStateLogin({this.mnemonic, this.jadeId});
  

 final  String? mnemonic;
 final  String? jadeId;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateLoginCopyWith<LoginStateLogin> get copyWith => _$LoginStateLoginCopyWithImpl<LoginStateLogin>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateLogin&&(identical(other.mnemonic, mnemonic) || other.mnemonic == mnemonic)&&(identical(other.jadeId, jadeId) || other.jadeId == jadeId));
}


@override
int get hashCode => Object.hash(runtimeType,mnemonic,jadeId);

@override
String toString() {
  return 'LoginState.login(mnemonic: $mnemonic, jadeId: $jadeId)';
}


}

/// @nodoc
abstract mixin class $LoginStateLoginCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory $LoginStateLoginCopyWith(LoginStateLogin value, $Res Function(LoginStateLogin) _then) = _$LoginStateLoginCopyWithImpl;
@useResult
$Res call({
 String? mnemonic, String? jadeId
});




}
/// @nodoc
class _$LoginStateLoginCopyWithImpl<$Res>
    implements $LoginStateLoginCopyWith<$Res> {
  _$LoginStateLoginCopyWithImpl(this._self, this._then);

  final LoginStateLogin _self;
  final $Res Function(LoginStateLogin) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mnemonic = freezed,Object? jadeId = freezed,}) {
  return _then(LoginStateLogin(
mnemonic: freezed == mnemonic ? _self.mnemonic : mnemonic // ignore: cast_nullable_to_non_nullable
as String?,jadeId: freezed == jadeId ? _self.jadeId : jadeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
