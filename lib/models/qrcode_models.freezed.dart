// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qrcode_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QrCodeResultModel {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrCodeResultModel);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QrCodeResultModel()';
}


}

/// @nodoc
class $QrCodeResultModelCopyWith<$Res>  {
$QrCodeResultModelCopyWith(QrCodeResultModel _, $Res Function(QrCodeResultModel) __);
}


/// @nodoc


class QrCodeResultModelEmpty implements QrCodeResultModel {
  const QrCodeResultModelEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrCodeResultModelEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QrCodeResultModel.empty()';
}


}




/// @nodoc


class QrCodeResultModelData implements QrCodeResultModel {
  const QrCodeResultModelData({this.result});
  

 final  QrCodeResult? result;

/// Create a copy of QrCodeResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrCodeResultModelDataCopyWith<QrCodeResultModelData> get copyWith => _$QrCodeResultModelDataCopyWithImpl<QrCodeResultModelData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrCodeResultModelData&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,result);

@override
String toString() {
  return 'QrCodeResultModel.data(result: $result)';
}


}

/// @nodoc
abstract mixin class $QrCodeResultModelDataCopyWith<$Res> implements $QrCodeResultModelCopyWith<$Res> {
  factory $QrCodeResultModelDataCopyWith(QrCodeResultModelData value, $Res Function(QrCodeResultModelData) _then) = _$QrCodeResultModelDataCopyWithImpl;
@useResult
$Res call({
 QrCodeResult? result
});




}
/// @nodoc
class _$QrCodeResultModelDataCopyWithImpl<$Res>
    implements $QrCodeResultModelDataCopyWith<$Res> {
  _$QrCodeResultModelDataCopyWithImpl(this._self, this._then);

  final QrCodeResultModelData _self;
  final $Res Function(QrCodeResultModelData) _then;

/// Create a copy of QrCodeResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? result = freezed,}) {
  return _then(QrCodeResultModelData(
result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as QrCodeResult?,
  ));
}


}

// dart format on
