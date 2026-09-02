import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/desktop/desktop_window_size.dart';
import 'package:window_size/window_size.dart' show Screen;

Screen screen({
  required Size frame,
  required Size visible,
  double scale = 1.0,
}) => Screen(
  Rect.fromLTWH(0, 0, frame.width, frame.height),
  Rect.fromLTWH(0, 0, visible.width, visible.height),
  scale,
);

void main() {
  group('logicalWorkArea', () {
    test('is the visible frame where the plugin reports logical units', () {
      // macOS: points, menu bar and dock already taken off.
      final s = screen(
        frame: const Size(1440, 900),
        visible: const Size(1440, 815),
        scale: 2.0,
      );
      expect(
        logicalWorkArea(s, workAreaIsPhysical: false),
        const Size(1440, 815),
      );
    });

    test('divides a physical work area by the scale factor', () {
      // Windows 1920x1080 @ 150 %, 48 px taskbar.
      final s = screen(
        frame: const Size(1920, 1080),
        visible: const Size(1920, 1032),
        scale: 1.5,
      );
      expect(
        logicalWorkArea(s, workAreaIsPhysical: true),
        const Size(1280, 688),
      );
    });

    test('is unknown rather than physical when the scale is unusable', () {
      for (final scale in [0.0, -1.0, double.nan, double.infinity]) {
        final s = screen(
          frame: const Size(1920, 1080),
          visible: const Size(1920, 1032),
          scale: scale,
        );
        expect(logicalWorkArea(s, workAreaIsPhysical: true), isNull);
        // The same report is fine where no conversion is needed.
        expect(
          logicalWorkArea(s, workAreaIsPhysical: false),
          const Size(1920, 1032),
        );
      }
    });

    test('never exceeds the screen frame', () {
      final s = screen(
        frame: const Size(1366, 768),
        visible: const Size(1400, 800),
      );
      expect(
        logicalWorkArea(s, workAreaIsPhysical: false),
        const Size(1366, 768),
      );
    });

    test('is unknown for an unusable frame or visible frame', () {
      expect(
        logicalWorkArea(
          screen(frame: Size.zero, visible: const Size(1366, 728)),
          workAreaIsPhysical: false,
        ),
        isNull,
      );
      expect(
        logicalWorkArea(
          screen(frame: const Size(1366, 768), visible: Size.zero),
          workAreaIsPhysical: false,
        ),
        isNull,
      );
      expect(
        logicalWorkArea(
          screen(
            frame: const Size(1366, 768),
            visible: const Size(double.infinity, 728),
          ),
          workAreaIsPhysical: false,
        ),
        isNull,
      );
    });
  });

  group('desktopWindowSizeFor', () {
    test('keeps the default when the work area is large enough', () {
      expect(desktopWindowSizeFor(const Size(2560, 1400)), desktopWindowSize);
      expect(desktopWindowSizeFor(desktopWindowSize), desktopWindowSize);
    });

    test('shrinks each axis to the work area', () {
      // 1920x1080 @ 150 % laptop: 1280x688 logical.
      expect(desktopWindowSizeFor(const Size(1280, 688)), const Size(1088, 688));
      // 1366x768 @ 100 % with a 40 px taskbar.
      expect(desktopWindowSizeFor(const Size(1366, 728)), const Size(1088, 728));
      expect(
        desktopWindowSizeFor(const Size(1000, 1000)),
        const Size(1000, 880),
      );
    });

    test('keeps the default for an unknown or unusable work area', () {
      expect(desktopWindowSizeFor(null), desktopWindowSize);
      expect(desktopWindowSizeFor(Size.zero), desktopWindowSize);
      expect(
        desktopWindowSizeFor(const Size(double.infinity, 700)),
        desktopWindowSize,
      );
    });
  });
}
