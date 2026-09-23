import 'package:freezed_annotation/freezed_annotation.dart';

part 'desktop_window_geometry.freezed.dart';
part 'desktop_window_geometry.g.dart';

/// The desktop window placement the app stores between launches.
///
/// The bounds are the window's *normal* bounds in logical pixels: the
/// rectangle the window returns to when it is not maximized. A maximized
/// window stores the flag beside the normal bounds it came from, never the
/// maximized rectangle. Full-screen is never stored.
///
/// [displayId] is a diagnostic slot for the display the window was on. The
/// launch decision never reads it: it checks the bounds against the present
/// work areas, because a display id is not stable across a replug. The
/// desktop recorder leaves it unset today. ADR-0016 decision 10.
@freezed
sealed class DesktopWindowGeometry with _$DesktopWindowGeometry {
  const factory DesktopWindowGeometry({
    required double left,
    required double top,
    required double width,
    required double height,
    @Default(false) bool maximized,
    String? displayId,
  }) = _DesktopWindowGeometry;

  factory DesktopWindowGeometry.fromJson(Map<String, dynamic> json) =>
      _$DesktopWindowGeometryFromJson(json);
}
