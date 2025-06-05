// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tx_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoadTransactionsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTransactionsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoadTransactionsState()';
}


}

/// @nodoc
class $LoadTransactionsStateCopyWith<$Res>  {
$LoadTransactionsStateCopyWith(LoadTransactionsState _, $Res Function(LoadTransactionsState) __);
}


/// @nodoc


class LoadTransactionsStateEmpty implements LoadTransactionsState {
  const LoadTransactionsStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTransactionsStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoadTransactionsState.empty()';
}


}




/// @nodoc


class LoadTransactionsStateLoading implements LoadTransactionsState {
  const LoadTransactionsStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTransactionsStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoadTransactionsState.loading()';
}


}




/// @nodoc


class LoadTransactionsStateError implements LoadTransactionsState {
  const LoadTransactionsStateError({this.errorMsg});
  

 final  String? errorMsg;

/// Create a copy of LoadTransactionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadTransactionsStateErrorCopyWith<LoadTransactionsStateError> get copyWith => _$LoadTransactionsStateErrorCopyWithImpl<LoadTransactionsStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTransactionsStateError&&(identical(other.errorMsg, errorMsg) || other.errorMsg == errorMsg));
}


@override
int get hashCode => Object.hash(runtimeType,errorMsg);

@override
String toString() {
  return 'LoadTransactionsState.error(errorMsg: $errorMsg)';
}


}

/// @nodoc
abstract mixin class $LoadTransactionsStateErrorCopyWith<$Res> implements $LoadTransactionsStateCopyWith<$Res> {
  factory $LoadTransactionsStateErrorCopyWith(LoadTransactionsStateError value, $Res Function(LoadTransactionsStateError) _then) = _$LoadTransactionsStateErrorCopyWithImpl;
@useResult
$Res call({
 String? errorMsg
});




}
/// @nodoc
class _$LoadTransactionsStateErrorCopyWithImpl<$Res>
    implements $LoadTransactionsStateErrorCopyWith<$Res> {
  _$LoadTransactionsStateErrorCopyWithImpl(this._self, this._then);

  final LoadTransactionsStateError _self;
  final $Res Function(LoadTransactionsStateError) _then;

/// Create a copy of LoadTransactionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMsg = freezed,}) {
  return _then(LoadTransactionsStateError(
errorMsg: freezed == errorMsg ? _self.errorMsg : errorMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
