// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jade_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JadeBluetoothPermissionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeBluetoothPermissionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeBluetoothPermissionState()';
}


}

/// @nodoc
class $JadeBluetoothPermissionStateCopyWith<$Res>  {
$JadeBluetoothPermissionStateCopyWith(JadeBluetoothPermissionState _, $Res Function(JadeBluetoothPermissionState) __);
}


/// @nodoc


class JadeBluetoothPermissionStateEmpty implements JadeBluetoothPermissionState {
  const JadeBluetoothPermissionStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeBluetoothPermissionStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeBluetoothPermissionState.empty()';
}


}




/// @nodoc


class JadeBluetoothPermissionStateRequest implements JadeBluetoothPermissionState {
  const JadeBluetoothPermissionStateRequest();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeBluetoothPermissionStateRequest);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeBluetoothPermissionState.request()';
}


}




/// @nodoc
mixin _$JadeLockState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeLockState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeLockState()';
}


}

/// @nodoc
class $JadeLockStateCopyWith<$Res>  {
$JadeLockStateCopyWith(JadeLockState _, $Res Function(JadeLockState) __);
}


/// @nodoc


class JadeLockStateLocked implements JadeLockState {
  const JadeLockStateLocked();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeLockStateLocked);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeLockState.locked()';
}


}




/// @nodoc


class JadeLockStateUnlocked implements JadeLockState {
  const JadeLockStateUnlocked();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeLockStateUnlocked);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeLockState.unlocked()';
}


}




/// @nodoc


class JadeLockStateError implements JadeLockState {
  const JadeLockStateError({this.message});
  

 final  String? message;

/// Create a copy of JadeLockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JadeLockStateErrorCopyWith<JadeLockStateError> get copyWith => _$JadeLockStateErrorCopyWithImpl<JadeLockStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeLockStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'JadeLockState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $JadeLockStateErrorCopyWith<$Res> implements $JadeLockStateCopyWith<$Res> {
  factory $JadeLockStateErrorCopyWith(JadeLockStateError value, $Res Function(JadeLockStateError) _then) = _$JadeLockStateErrorCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$JadeLockStateErrorCopyWithImpl<$Res>
    implements $JadeLockStateErrorCopyWith<$Res> {
  _$JadeLockStateErrorCopyWithImpl(this._self, this._then);

  final JadeLockStateError _self;
  final $Res Function(JadeLockStateError) _then;

/// Create a copy of JadeLockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(JadeLockStateError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$JadeVerifyAddressState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeVerifyAddressState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeVerifyAddressState()';
}


}

/// @nodoc
class $JadeVerifyAddressStateCopyWith<$Res>  {
$JadeVerifyAddressStateCopyWith(JadeVerifyAddressState _, $Res Function(JadeVerifyAddressState) __);
}


/// @nodoc


class JadeVerifyAddressStateIdle implements JadeVerifyAddressState {
  const JadeVerifyAddressStateIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeVerifyAddressStateIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeVerifyAddressState.idle()';
}


}




/// @nodoc


class JadeVerifyAddressStateVerifying implements JadeVerifyAddressState {
  const JadeVerifyAddressStateVerifying();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeVerifyAddressStateVerifying);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeVerifyAddressState.verifying()';
}


}




/// @nodoc


class JadeVerifyAddressStateSuccess implements JadeVerifyAddressState {
  const JadeVerifyAddressStateSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeVerifyAddressStateSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JadeVerifyAddressState.success()';
}


}




/// @nodoc


class JadeVerifyAddressStateError implements JadeVerifyAddressState {
  const JadeVerifyAddressStateError({this.message});
  

 final  String? message;

/// Create a copy of JadeVerifyAddressState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JadeVerifyAddressStateErrorCopyWith<JadeVerifyAddressStateError> get copyWith => _$JadeVerifyAddressStateErrorCopyWithImpl<JadeVerifyAddressStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JadeVerifyAddressStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'JadeVerifyAddressState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $JadeVerifyAddressStateErrorCopyWith<$Res> implements $JadeVerifyAddressStateCopyWith<$Res> {
  factory $JadeVerifyAddressStateErrorCopyWith(JadeVerifyAddressStateError value, $Res Function(JadeVerifyAddressStateError) _then) = _$JadeVerifyAddressStateErrorCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$JadeVerifyAddressStateErrorCopyWithImpl<$Res>
    implements $JadeVerifyAddressStateErrorCopyWith<$Res> {
  _$JadeVerifyAddressStateErrorCopyWithImpl(this._self, this._then);

  final JadeVerifyAddressStateError _self;
  final $Res Function(JadeVerifyAddressStateError) _then;

/// Create a copy of JadeVerifyAddressState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(JadeVerifyAddressStateError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
