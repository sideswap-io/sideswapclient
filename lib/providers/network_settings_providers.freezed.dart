// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_settings_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
NetworkSettingsModel _$NetworkSettingsModelFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'empty':
          return NetworkSettingsModelEmpty.fromJson(
            json
          );
                case 'apply':
          return NetworkSettingsModelApply.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'NetworkSettingsModel',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$NetworkSettingsModel {

 SettingsNetworkType? get settingsNetworkType; int? get env; String? get host; int? get port; bool? get useTls;
/// Create a copy of NetworkSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkSettingsModelCopyWith<NetworkSettingsModel> get copyWith => _$NetworkSettingsModelCopyWithImpl<NetworkSettingsModel>(this as NetworkSettingsModel, _$identity);

  /// Serializes this NetworkSettingsModel to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'NetworkSettingsModel(settingsNetworkType: $settingsNetworkType, env: $env, host: $host, port: $port, useTls: $useTls)';
}


}

/// @nodoc
abstract mixin class $NetworkSettingsModelCopyWith<$Res>  {
  factory $NetworkSettingsModelCopyWith(NetworkSettingsModel value, $Res Function(NetworkSettingsModel) _then) = _$NetworkSettingsModelCopyWithImpl;
@useResult
$Res call({
 SettingsNetworkType? settingsNetworkType, int? env, String? host, int? port, bool? useTls
});




}
/// @nodoc
class _$NetworkSettingsModelCopyWithImpl<$Res>
    implements $NetworkSettingsModelCopyWith<$Res> {
  _$NetworkSettingsModelCopyWithImpl(this._self, this._then);

  final NetworkSettingsModel _self;
  final $Res Function(NetworkSettingsModel) _then;

/// Create a copy of NetworkSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? settingsNetworkType = freezed,Object? env = freezed,Object? host = freezed,Object? port = freezed,Object? useTls = freezed,}) {
  return _then(_self.copyWith(
settingsNetworkType: freezed == settingsNetworkType ? _self.settingsNetworkType : settingsNetworkType // ignore: cast_nullable_to_non_nullable
as SettingsNetworkType?,env: freezed == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as int?,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,useTls: freezed == useTls ? _self.useTls : useTls // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class NetworkSettingsModelEmpty implements NetworkSettingsModel {
  const NetworkSettingsModelEmpty({this.settingsNetworkType, this.env, this.host, this.port, this.useTls, final  String? $type}): $type = $type ?? 'empty';
  factory NetworkSettingsModelEmpty.fromJson(Map<String, dynamic> json) => _$NetworkSettingsModelEmptyFromJson(json);

@override final  SettingsNetworkType? settingsNetworkType;
@override final  int? env;
@override final  String? host;
@override final  int? port;
@override final  bool? useTls;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of NetworkSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkSettingsModelEmptyCopyWith<NetworkSettingsModelEmpty> get copyWith => _$NetworkSettingsModelEmptyCopyWithImpl<NetworkSettingsModelEmpty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetworkSettingsModelEmptyToJson(this, );
}



@override
String toString() {
  return 'NetworkSettingsModel.empty(settingsNetworkType: $settingsNetworkType, env: $env, host: $host, port: $port, useTls: $useTls)';
}


}

/// @nodoc
abstract mixin class $NetworkSettingsModelEmptyCopyWith<$Res> implements $NetworkSettingsModelCopyWith<$Res> {
  factory $NetworkSettingsModelEmptyCopyWith(NetworkSettingsModelEmpty value, $Res Function(NetworkSettingsModelEmpty) _then) = _$NetworkSettingsModelEmptyCopyWithImpl;
@override @useResult
$Res call({
 SettingsNetworkType? settingsNetworkType, int? env, String? host, int? port, bool? useTls
});




}
/// @nodoc
class _$NetworkSettingsModelEmptyCopyWithImpl<$Res>
    implements $NetworkSettingsModelEmptyCopyWith<$Res> {
  _$NetworkSettingsModelEmptyCopyWithImpl(this._self, this._then);

  final NetworkSettingsModelEmpty _self;
  final $Res Function(NetworkSettingsModelEmpty) _then;

/// Create a copy of NetworkSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? settingsNetworkType = freezed,Object? env = freezed,Object? host = freezed,Object? port = freezed,Object? useTls = freezed,}) {
  return _then(NetworkSettingsModelEmpty(
settingsNetworkType: freezed == settingsNetworkType ? _self.settingsNetworkType : settingsNetworkType // ignore: cast_nullable_to_non_nullable
as SettingsNetworkType?,env: freezed == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as int?,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,useTls: freezed == useTls ? _self.useTls : useTls // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

/// @nodoc
@JsonSerializable()

class NetworkSettingsModelApply implements NetworkSettingsModel {
  const NetworkSettingsModelApply({this.settingsNetworkType, this.env, this.host, this.port, this.useTls, final  String? $type}): $type = $type ?? 'apply';
  factory NetworkSettingsModelApply.fromJson(Map<String, dynamic> json) => _$NetworkSettingsModelApplyFromJson(json);

@override final  SettingsNetworkType? settingsNetworkType;
@override final  int? env;
@override final  String? host;
@override final  int? port;
@override final  bool? useTls;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of NetworkSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkSettingsModelApplyCopyWith<NetworkSettingsModelApply> get copyWith => _$NetworkSettingsModelApplyCopyWithImpl<NetworkSettingsModelApply>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetworkSettingsModelApplyToJson(this, );
}



@override
String toString() {
  return 'NetworkSettingsModel.apply(settingsNetworkType: $settingsNetworkType, env: $env, host: $host, port: $port, useTls: $useTls)';
}


}

/// @nodoc
abstract mixin class $NetworkSettingsModelApplyCopyWith<$Res> implements $NetworkSettingsModelCopyWith<$Res> {
  factory $NetworkSettingsModelApplyCopyWith(NetworkSettingsModelApply value, $Res Function(NetworkSettingsModelApply) _then) = _$NetworkSettingsModelApplyCopyWithImpl;
@override @useResult
$Res call({
 SettingsNetworkType? settingsNetworkType, int? env, String? host, int? port, bool? useTls
});




}
/// @nodoc
class _$NetworkSettingsModelApplyCopyWithImpl<$Res>
    implements $NetworkSettingsModelApplyCopyWith<$Res> {
  _$NetworkSettingsModelApplyCopyWithImpl(this._self, this._then);

  final NetworkSettingsModelApply _self;
  final $Res Function(NetworkSettingsModelApply) _then;

/// Create a copy of NetworkSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? settingsNetworkType = freezed,Object? env = freezed,Object? host = freezed,Object? port = freezed,Object? useTls = freezed,}) {
  return _then(NetworkSettingsModelApply(
settingsNetworkType: freezed == settingsNetworkType ? _self.settingsNetworkType : settingsNetworkType // ignore: cast_nullable_to_non_nullable
as SettingsNetworkType?,env: freezed == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as int?,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,useTls: freezed == useTls ? _self.useTls : useTls // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
