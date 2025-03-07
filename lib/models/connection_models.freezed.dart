// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
