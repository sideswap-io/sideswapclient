// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_releases.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppReleasesDesktop _$AppReleasesDesktopFromJson(Map json) =>
    _AppReleasesDesktop(
      version: json['version'] as String?,
      build: (json['build'] as num?)?.toInt(),
      changes: json['changes'] as String?,
    );

Map<String, dynamic> _$AppReleasesDesktopToJson(_AppReleasesDesktop instance) =>
    <String, dynamic>{
      'version': instance.version,
      'build': instance.build,
      'changes': instance.changes,
    };

_AppReleasesModel _$AppReleasesModelFromJson(Map json) => _AppReleasesModel(
  desktop:
      json['desktop'] == null
          ? null
          : AppReleasesDesktop.fromJson(
            Map<String, dynamic>.from(json['desktop'] as Map),
          ),
);

Map<String, dynamic> _$AppReleasesModelToJson(_AppReleasesModel instance) =>
    <String, dynamic>{'desktop': instance.desktop};
