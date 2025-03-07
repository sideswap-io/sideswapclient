// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stokr_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StokrSettingsModel {

 bool? get firstRun;
/// Create a copy of StokrSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StokrSettingsModelCopyWith<StokrSettingsModel> get copyWith => _$StokrSettingsModelCopyWithImpl<StokrSettingsModel>(this as StokrSettingsModel, _$identity);

  /// Serializes this StokrSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StokrSettingsModel&&(identical(other.firstRun, firstRun) || other.firstRun == firstRun));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstRun);

@override
String toString() {
  return 'StokrSettingsModel(firstRun: $firstRun)';
}


}

/// @nodoc
abstract mixin class $StokrSettingsModelCopyWith<$Res>  {
  factory $StokrSettingsModelCopyWith(StokrSettingsModel value, $Res Function(StokrSettingsModel) _then) = _$StokrSettingsModelCopyWithImpl;
@useResult
$Res call({
 bool? firstRun
});




}
/// @nodoc
class _$StokrSettingsModelCopyWithImpl<$Res>
    implements $StokrSettingsModelCopyWith<$Res> {
  _$StokrSettingsModelCopyWithImpl(this._self, this._then);

  final StokrSettingsModel _self;
  final $Res Function(StokrSettingsModel) _then;

/// Create a copy of StokrSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstRun = freezed,}) {
  return _then(_self.copyWith(
firstRun: freezed == firstRun ? _self.firstRun : firstRun // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _StokrSettingsModel implements StokrSettingsModel {
  const _StokrSettingsModel({this.firstRun = true});
  factory _StokrSettingsModel.fromJson(Map<String, dynamic> json) => _$StokrSettingsModelFromJson(json);

@override@JsonKey() final  bool? firstRun;

/// Create a copy of StokrSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StokrSettingsModelCopyWith<_StokrSettingsModel> get copyWith => __$StokrSettingsModelCopyWithImpl<_StokrSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StokrSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StokrSettingsModel&&(identical(other.firstRun, firstRun) || other.firstRun == firstRun));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firstRun);

@override
String toString() {
  return 'StokrSettingsModel(firstRun: $firstRun)';
}


}

/// @nodoc
abstract mixin class _$StokrSettingsModelCopyWith<$Res> implements $StokrSettingsModelCopyWith<$Res> {
  factory _$StokrSettingsModelCopyWith(_StokrSettingsModel value, $Res Function(_StokrSettingsModel) _then) = __$StokrSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 bool? firstRun
});




}
/// @nodoc
class __$StokrSettingsModelCopyWithImpl<$Res>
    implements _$StokrSettingsModelCopyWith<$Res> {
  __$StokrSettingsModelCopyWithImpl(this._self, this._then);

  final _StokrSettingsModel _self;
  final $Res Function(_StokrSettingsModel) _then;

/// Create a copy of StokrSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstRun = freezed,}) {
  return _then(_StokrSettingsModel(
firstRun: freezed == firstRun ? _self.firstRun : firstRun // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
