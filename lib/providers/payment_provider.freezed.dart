// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateTxState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTxState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CreateTxState()';
}


}

/// @nodoc
class $CreateTxStateCopyWith<$Res>  {
$CreateTxStateCopyWith(CreateTxState _, $Res Function(CreateTxState) __);
}


/// @nodoc


class CreateTxStateEmpty implements CreateTxState {
  const CreateTxStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTxStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CreateTxState.empty()';
}


}




/// @nodoc


class CreateTxStateCreating implements CreateTxState {
  const CreateTxStateCreating();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTxStateCreating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CreateTxState.creating()';
}


}




/// @nodoc


class CreateTxStateCreated implements CreateTxState {
  const CreateTxStateCreated(this.createdTx);
  

 final  CreatedTx createdTx;

/// Create a copy of CreateTxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTxStateCreatedCopyWith<CreateTxStateCreated> get copyWith => _$CreateTxStateCreatedCopyWithImpl<CreateTxStateCreated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTxStateCreated&&(identical(other.createdTx, createdTx) || other.createdTx == createdTx));
}


@override
int get hashCode => Object.hash(runtimeType,createdTx);

@override
String toString() {
  return 'CreateTxState.created(createdTx: $createdTx)';
}


}

/// @nodoc
abstract mixin class $CreateTxStateCreatedCopyWith<$Res> implements $CreateTxStateCopyWith<$Res> {
  factory $CreateTxStateCreatedCopyWith(CreateTxStateCreated value, $Res Function(CreateTxStateCreated) _then) = _$CreateTxStateCreatedCopyWithImpl;
@useResult
$Res call({
 CreatedTx createdTx
});




}
/// @nodoc
class _$CreateTxStateCreatedCopyWithImpl<$Res>
    implements $CreateTxStateCreatedCopyWith<$Res> {
  _$CreateTxStateCreatedCopyWithImpl(this._self, this._then);

  final CreateTxStateCreated _self;
  final $Res Function(CreateTxStateCreated) _then;

/// Create a copy of CreateTxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? createdTx = null,}) {
  return _then(CreateTxStateCreated(
null == createdTx ? _self.createdTx : createdTx // ignore: cast_nullable_to_non_nullable
as CreatedTx,
  ));
}


}

/// @nodoc


class CreateTxStateError implements CreateTxState {
  const CreateTxStateError({this.errorMsg});
  

 final  String? errorMsg;

/// Create a copy of CreateTxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTxStateErrorCopyWith<CreateTxStateError> get copyWith => _$CreateTxStateErrorCopyWithImpl<CreateTxStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTxStateError&&(identical(other.errorMsg, errorMsg) || other.errorMsg == errorMsg));
}


@override
int get hashCode => Object.hash(runtimeType,errorMsg);

@override
String toString() {
  return 'CreateTxState.error(errorMsg: $errorMsg)';
}


}

/// @nodoc
abstract mixin class $CreateTxStateErrorCopyWith<$Res> implements $CreateTxStateCopyWith<$Res> {
  factory $CreateTxStateErrorCopyWith(CreateTxStateError value, $Res Function(CreateTxStateError) _then) = _$CreateTxStateErrorCopyWithImpl;
@useResult
$Res call({
 String? errorMsg
});




}
/// @nodoc
class _$CreateTxStateErrorCopyWithImpl<$Res>
    implements $CreateTxStateErrorCopyWith<$Res> {
  _$CreateTxStateErrorCopyWithImpl(this._self, this._then);

  final CreateTxStateError _self;
  final $Res Function(CreateTxStateError) _then;

/// Create a copy of CreateTxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMsg = freezed,}) {
  return _then(CreateTxStateError(
errorMsg: freezed == errorMsg ? _self.errorMsg : errorMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SendTxState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendTxState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SendTxState()';
}


}

/// @nodoc
class $SendTxStateCopyWith<$Res>  {
$SendTxStateCopyWith(SendTxState _, $Res Function(SendTxState) __);
}


/// @nodoc


class SendTxStateEmpty implements SendTxState {
  const SendTxStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendTxStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SendTxState.empty()';
}


}




/// @nodoc


class SendTxStateSending implements SendTxState {
  const SendTxStateSending();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendTxStateSending);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SendTxState.sending()';
}


}




// dart format on
