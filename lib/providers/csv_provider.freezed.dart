// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'csv_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CvsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CvsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CvsState()';
}


}

/// @nodoc
class $CvsStateCopyWith<$Res>  {
$CvsStateCopyWith(CvsState _, $Res Function(CvsState) __);
}


/// @nodoc


class CvsStateEmpty implements CvsState {
  const CvsStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CvsStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CvsState.empty()';
}


}




/// @nodoc


class CvsStateSuccess implements CvsState {
  const CvsStateSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CvsStateSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CvsState.success()';
}


}




/// @nodoc
mixin _$ExportCsvState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportCsvState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportCsvState()';
}


}

/// @nodoc
class $ExportCsvStateCopyWith<$Res>  {
$ExportCsvStateCopyWith(ExportCsvState _, $Res Function(ExportCsvState) __);
}


/// @nodoc


class ExportCsvStateEmpty implements ExportCsvState {
  const ExportCsvStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportCsvStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportCsvState.empty()';
}


}




/// @nodoc


class ExportCsvStateLoading implements ExportCsvState {
  const ExportCsvStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportCsvStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExportCsvState.loading()';
}


}




/// @nodoc


class ExportCsvStateError implements ExportCsvState {
  const ExportCsvStateError([this.errorMsg]);
  

 final  String? errorMsg;

/// Create a copy of ExportCsvState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportCsvStateErrorCopyWith<ExportCsvStateError> get copyWith => _$ExportCsvStateErrorCopyWithImpl<ExportCsvStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportCsvStateError&&(identical(other.errorMsg, errorMsg) || other.errorMsg == errorMsg));
}


@override
int get hashCode => Object.hash(runtimeType,errorMsg);

@override
String toString() {
  return 'ExportCsvState.error(errorMsg: $errorMsg)';
}


}

/// @nodoc
abstract mixin class $ExportCsvStateErrorCopyWith<$Res> implements $ExportCsvStateCopyWith<$Res> {
  factory $ExportCsvStateErrorCopyWith(ExportCsvStateError value, $Res Function(ExportCsvStateError) _then) = _$ExportCsvStateErrorCopyWithImpl;
@useResult
$Res call({
 String? errorMsg
});




}
/// @nodoc
class _$ExportCsvStateErrorCopyWithImpl<$Res>
    implements $ExportCsvStateErrorCopyWith<$Res> {
  _$ExportCsvStateErrorCopyWithImpl(this._self, this._then);

  final ExportCsvStateError _self;
  final $Res Function(ExportCsvStateError) _then;

/// Create a copy of ExportCsvState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorMsg = freezed,}) {
  return _then(ExportCsvStateError(
freezed == errorMsg ? _self.errorMsg : errorMsg // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ExportCsvStateLoaded implements ExportCsvState {
  const ExportCsvStateLoaded([final  List<TransItem>? txs]): _txs = txs;
  

 final  List<TransItem>? _txs;
 List<TransItem>? get txs {
  final value = _txs;
  if (value == null) return null;
  if (_txs is EqualUnmodifiableListView) return _txs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ExportCsvState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportCsvStateLoadedCopyWith<ExportCsvStateLoaded> get copyWith => _$ExportCsvStateLoadedCopyWithImpl<ExportCsvStateLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportCsvStateLoaded&&const DeepCollectionEquality().equals(other._txs, _txs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_txs));

@override
String toString() {
  return 'ExportCsvState.loaded(txs: $txs)';
}


}

/// @nodoc
abstract mixin class $ExportCsvStateLoadedCopyWith<$Res> implements $ExportCsvStateCopyWith<$Res> {
  factory $ExportCsvStateLoadedCopyWith(ExportCsvStateLoaded value, $Res Function(ExportCsvStateLoaded) _then) = _$ExportCsvStateLoadedCopyWithImpl;
@useResult
$Res call({
 List<TransItem>? txs
});




}
/// @nodoc
class _$ExportCsvStateLoadedCopyWithImpl<$Res>
    implements $ExportCsvStateLoadedCopyWith<$Res> {
  _$ExportCsvStateLoadedCopyWithImpl(this._self, this._then);

  final ExportCsvStateLoaded _self;
  final $Res Function(ExportCsvStateLoaded) _then;

/// Create a copy of ExportCsvState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? txs = freezed,}) {
  return _then(ExportCsvStateLoaded(
freezed == txs ? _self._txs : txs // ignore: cast_nullable_to_non_nullable
as List<TransItem>?,
  ));
}


}

// dart format on
