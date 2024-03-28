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

StokrAllowedCountry _$StokrAllowedCountryFromJson(Map<String, dynamic> json) {
  return _StokrAllowedCountry.fromJson(json);
}

/// @nodoc
mixin _$StokrAllowedCountry {
  String get name => throw _privateConstructorUsedError;
  bool get isAllowed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StokrAllowedCountryCopyWith<StokrAllowedCountry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StokrAllowedCountryCopyWith<$Res> {
  factory $StokrAllowedCountryCopyWith(
          StokrAllowedCountry value, $Res Function(StokrAllowedCountry) then) =
      _$StokrAllowedCountryCopyWithImpl<$Res, StokrAllowedCountry>;
  @useResult
  $Res call({String name, bool isAllowed});
}

/// @nodoc
class _$StokrAllowedCountryCopyWithImpl<$Res, $Val extends StokrAllowedCountry>
    implements $StokrAllowedCountryCopyWith<$Res> {
  _$StokrAllowedCountryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? isAllowed = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isAllowed: null == isAllowed
          ? _value.isAllowed
          : isAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StokrAllowedCountryImplCopyWith<$Res>
    implements $StokrAllowedCountryCopyWith<$Res> {
  factory _$$StokrAllowedCountryImplCopyWith(_$StokrAllowedCountryImpl value,
          $Res Function(_$StokrAllowedCountryImpl) then) =
      __$$StokrAllowedCountryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, bool isAllowed});
}

/// @nodoc
class __$$StokrAllowedCountryImplCopyWithImpl<$Res>
    extends _$StokrAllowedCountryCopyWithImpl<$Res, _$StokrAllowedCountryImpl>
    implements _$$StokrAllowedCountryImplCopyWith<$Res> {
  __$$StokrAllowedCountryImplCopyWithImpl(_$StokrAllowedCountryImpl _value,
      $Res Function(_$StokrAllowedCountryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? isAllowed = null,
  }) {
    return _then(_$StokrAllowedCountryImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isAllowed: null == isAllowed
          ? _value.isAllowed
          : isAllowed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StokrAllowedCountryImpl implements _StokrAllowedCountry {
  const _$StokrAllowedCountryImpl({required this.name, this.isAllowed = false});

  factory _$StokrAllowedCountryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StokrAllowedCountryImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey()
  final bool isAllowed;

  @override
  String toString() {
    return 'StokrAllowedCountry(name: $name, isAllowed: $isAllowed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StokrAllowedCountryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isAllowed, isAllowed) ||
                other.isAllowed == isAllowed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, isAllowed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StokrAllowedCountryImplCopyWith<_$StokrAllowedCountryImpl> get copyWith =>
      __$$StokrAllowedCountryImplCopyWithImpl<_$StokrAllowedCountryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StokrAllowedCountryImplToJson(
      this,
    );
  }
}

abstract class _StokrAllowedCountry implements StokrAllowedCountry {
  const factory _StokrAllowedCountry(
      {required final String name,
      final bool isAllowed}) = _$StokrAllowedCountryImpl;

  factory _StokrAllowedCountry.fromJson(Map<String, dynamic> json) =
      _$StokrAllowedCountryImpl.fromJson;

  @override
  String get name;
  @override
  bool get isAllowed;
  @override
  @JsonKey(ignore: true)
  _$$StokrAllowedCountryImplCopyWith<_$StokrAllowedCountryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StokrAllowedCountryList _$StokrAllowedCountryListFromJson(
    Map<String, dynamic> json) {
  return _StokrAllowedCountryList.fromJson(json);
}

/// @nodoc
mixin _$StokrAllowedCountryList {
  List<StokrAllowedCountry>? get countries =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StokrAllowedCountryListCopyWith<StokrAllowedCountryList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StokrAllowedCountryListCopyWith<$Res> {
  factory $StokrAllowedCountryListCopyWith(StokrAllowedCountryList value,
          $Res Function(StokrAllowedCountryList) then) =
      _$StokrAllowedCountryListCopyWithImpl<$Res, StokrAllowedCountryList>;
  @useResult
  $Res call({List<StokrAllowedCountry>? countries});
}

/// @nodoc
class _$StokrAllowedCountryListCopyWithImpl<$Res,
        $Val extends StokrAllowedCountryList>
    implements $StokrAllowedCountryListCopyWith<$Res> {
  _$StokrAllowedCountryListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countries = freezed,
  }) {
    return _then(_value.copyWith(
      countries: freezed == countries
          ? _value.countries
          : countries // ignore: cast_nullable_to_non_nullable
              as List<StokrAllowedCountry>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StokrAllowedCountryListImplCopyWith<$Res>
    implements $StokrAllowedCountryListCopyWith<$Res> {
  factory _$$StokrAllowedCountryListImplCopyWith(
          _$StokrAllowedCountryListImpl value,
          $Res Function(_$StokrAllowedCountryListImpl) then) =
      __$$StokrAllowedCountryListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<StokrAllowedCountry>? countries});
}

/// @nodoc
class __$$StokrAllowedCountryListImplCopyWithImpl<$Res>
    extends _$StokrAllowedCountryListCopyWithImpl<$Res,
        _$StokrAllowedCountryListImpl>
    implements _$$StokrAllowedCountryListImplCopyWith<$Res> {
  __$$StokrAllowedCountryListImplCopyWithImpl(
      _$StokrAllowedCountryListImpl _value,
      $Res Function(_$StokrAllowedCountryListImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? countries = freezed,
  }) {
    return _then(_$StokrAllowedCountryListImpl(
      countries: freezed == countries
          ? _value._countries
          : countries // ignore: cast_nullable_to_non_nullable
              as List<StokrAllowedCountry>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StokrAllowedCountryListImpl implements _StokrAllowedCountryList {
  const _$StokrAllowedCountryListImpl(
      {final List<StokrAllowedCountry>? countries})
      : _countries = countries;

  factory _$StokrAllowedCountryListImpl.fromJson(Map<String, dynamic> json) =>
      _$$StokrAllowedCountryListImplFromJson(json);

  final List<StokrAllowedCountry>? _countries;
  @override
  List<StokrAllowedCountry>? get countries {
    final value = _countries;
    if (value == null) return null;
    if (_countries is EqualUnmodifiableListView) return _countries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'StokrAllowedCountryList(countries: $countries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StokrAllowedCountryListImpl &&
            const DeepCollectionEquality()
                .equals(other._countries, _countries));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_countries));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StokrAllowedCountryListImplCopyWith<_$StokrAllowedCountryListImpl>
      get copyWith => __$$StokrAllowedCountryListImplCopyWithImpl<
          _$StokrAllowedCountryListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StokrAllowedCountryListImplToJson(
      this,
    );
  }
}

abstract class _StokrAllowedCountryList implements StokrAllowedCountryList {
  const factory _StokrAllowedCountryList(
          {final List<StokrAllowedCountry>? countries}) =
      _$StokrAllowedCountryListImpl;

  factory _StokrAllowedCountryList.fromJson(Map<String, dynamic> json) =
      _$StokrAllowedCountryListImpl.fromJson;

  @override
  List<StokrAllowedCountry>? get countries;
  @override
  @JsonKey(ignore: true)
  _$$StokrAllowedCountryListImplCopyWith<_$StokrAllowedCountryListImpl>
      get copyWith => throw _privateConstructorUsedError;
}
