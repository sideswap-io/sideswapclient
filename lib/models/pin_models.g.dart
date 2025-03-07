// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PinDataStateEmpty _$PinDataStateEmptyFromJson(Map json) =>
    PinDataStateEmpty($type: json['runtimeType'] as String?);

Map<String, dynamic> _$PinDataStateEmptyToJson(PinDataStateEmpty instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

PinDataStateError _$PinDataStateErrorFromJson(Map json) => PinDataStateError(
  message: json['message'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PinDataStateErrorToJson(PinDataStateError instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };

PinDataStateData _$PinDataStateDataFromJson(Map json) => PinDataStateData(
  salt: json['salt'] as String,
  encryptedData: json['encryptedData'] as String,
  pinIdentifier: json['pinIdentifier'] as String,
  hmac: json['hmac'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PinDataStateDataToJson(PinDataStateData instance) =>
    <String, dynamic>{
      'salt': instance.salt,
      'encryptedData': instance.encryptedData,
      'pinIdentifier': instance.pinIdentifier,
      'hmac': instance.hmac,
      'runtimeType': instance.$type,
    };
