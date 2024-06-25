// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PinDataStateEmptyImpl _$$PinDataStateEmptyImplFromJson(Map json) =>
    _$PinDataStateEmptyImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PinDataStateEmptyImplToJson(
        _$PinDataStateEmptyImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$PinDataStateErrorImpl _$$PinDataStateErrorImplFromJson(Map json) =>
    _$PinDataStateErrorImpl(
      message: json['message'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PinDataStateErrorImplToJson(
        _$PinDataStateErrorImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };

_$PinDataStateDataImpl _$$PinDataStateDataImplFromJson(Map json) =>
    _$PinDataStateDataImpl(
      salt: json['salt'] as String,
      encryptedData: json['encryptedData'] as String,
      pinIdentifier: json['pinIdentifier'] as String,
      hmac: json['hmac'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PinDataStateDataImplToJson(
        _$PinDataStateDataImpl instance) =>
    <String, dynamic>{
      'salt': instance.salt,
      'encryptedData': instance.encryptedData,
      'pinIdentifier': instance.pinIdentifier,
      'hmac': instance.hmac,
      'runtimeType': instance.$type,
    };
