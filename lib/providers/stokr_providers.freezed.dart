// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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


/// Adds pattern-matching-related methods to [StokrSettingsModel].
extension StokrSettingsModelPatterns on StokrSettingsModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StokrSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StokrSettingsModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StokrSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _StokrSettingsModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StokrSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _StokrSettingsModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? firstRun)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StokrSettingsModel() when $default != null:
return $default(_that.firstRun);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? firstRun)  $default,) {final _that = this;
switch (_that) {
case _StokrSettingsModel():
return $default(_that.firstRun);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? firstRun)?  $default,) {final _that = this;
switch (_that) {
case _StokrSettingsModel() when $default != null:
return $default(_that.firstRun);case _:
  return null;

}
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
