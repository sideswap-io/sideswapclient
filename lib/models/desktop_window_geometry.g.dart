// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'desktop_window_geometry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DesktopWindowGeometry _$DesktopWindowGeometryFromJson(Map json) =>
    _DesktopWindowGeometry(
      left: (json['left'] as num).toDouble(),
      top: (json['top'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      maximized: json['maximized'] as bool? ?? false,
      displayId: json['displayId'] as String?,
    );

Map<String, dynamic> _$DesktopWindowGeometryToJson(
  _DesktopWindowGeometry instance,
) => <String, dynamic>{
  'left': instance.left,
  'top': instance.top,
  'width': instance.width,
  'height': instance.height,
  'maximized': instance.maximized,
  'displayId': instance.displayId,
};
