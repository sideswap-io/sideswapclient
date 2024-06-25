// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_releases.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppReleasesDesktopImpl _$$AppReleasesDesktopImplFromJson(Map json) =>
    _$AppReleasesDesktopImpl(
      version: json['version'] as String?,
      build: (json['build'] as num?)?.toInt(),
      changes: json['changes'] as String?,
    );

Map<String, dynamic> _$$AppReleasesDesktopImplToJson(
        _$AppReleasesDesktopImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'build': instance.build,
      'changes': instance.changes,
    };

_$AppReleasesModelImpl _$$AppReleasesModelImplFromJson(Map json) =>
    _$AppReleasesModelImpl(
      desktop: json['desktop'] == null
          ? null
          : AppReleasesDesktop.fromJson(
              Map<String, dynamic>.from(json['desktop'] as Map)),
    );

Map<String, dynamic> _$$AppReleasesModelImplToJson(
        _$AppReleasesModelImpl instance) =>
    <String, dynamic>{
      'desktop': instance.desktop,
    };
