// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
