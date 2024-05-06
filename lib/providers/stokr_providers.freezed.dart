// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stokr_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StokrSettingsModel _$StokrSettingsModelFromJson(Map<String, dynamic> json) {
  return _StokrSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$StokrSettingsModel {
  bool? get firstRun => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StokrSettingsModelCopyWith<StokrSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StokrSettingsModelCopyWith<$Res> {
  factory $StokrSettingsModelCopyWith(
          StokrSettingsModel value, $Res Function(StokrSettingsModel) then) =
      _$StokrSettingsModelCopyWithImpl<$Res, StokrSettingsModel>;
  @useResult
  $Res call({bool? firstRun});
}

/// @nodoc
class _$StokrSettingsModelCopyWithImpl<$Res, $Val extends StokrSettingsModel>
    implements $StokrSettingsModelCopyWith<$Res> {
  _$StokrSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstRun = freezed,
  }) {
    return _then(_value.copyWith(
      firstRun: freezed == firstRun
          ? _value.firstRun
          : firstRun // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StokrSettingsModelImplCopyWith<$Res>
    implements $StokrSettingsModelCopyWith<$Res> {
  factory _$$StokrSettingsModelImplCopyWith(_$StokrSettingsModelImpl value,
          $Res Function(_$StokrSettingsModelImpl) then) =
      __$$StokrSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool? firstRun});
}

/// @nodoc
class __$$StokrSettingsModelImplCopyWithImpl<$Res>
    extends _$StokrSettingsModelCopyWithImpl<$Res, _$StokrSettingsModelImpl>
    implements _$$StokrSettingsModelImplCopyWith<$Res> {
  __$$StokrSettingsModelImplCopyWithImpl(_$StokrSettingsModelImpl _value,
      $Res Function(_$StokrSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstRun = freezed,
  }) {
    return _then(_$StokrSettingsModelImpl(
      firstRun: freezed == firstRun
          ? _value.firstRun
          : firstRun // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _$StokrSettingsModelImpl implements _StokrSettingsModel {
  const _$StokrSettingsModelImpl({this.firstRun = true});

  factory _$StokrSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StokrSettingsModelImplFromJson(json);

  @override
  @JsonKey()
  final bool? firstRun;

  @override
  String toString() {
    return 'StokrSettingsModel(firstRun: $firstRun)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StokrSettingsModelImpl &&
            (identical(other.firstRun, firstRun) ||
                other.firstRun == firstRun));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, firstRun);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StokrSettingsModelImplCopyWith<_$StokrSettingsModelImpl> get copyWith =>
      __$$StokrSettingsModelImplCopyWithImpl<_$StokrSettingsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StokrSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _StokrSettingsModel implements StokrSettingsModel {
  const factory _StokrSettingsModel({final bool? firstRun}) =
      _$StokrSettingsModelImpl;

  factory _StokrSettingsModel.fromJson(Map<String, dynamic> json) =
      _$StokrSettingsModelImpl.fromJson;

  @override
  bool? get firstRun;
  @override
  @JsonKey(ignore: true)
  _$$StokrSettingsModelImplCopyWith<_$StokrSettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
