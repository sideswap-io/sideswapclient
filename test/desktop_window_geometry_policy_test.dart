import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/desktop/desktop_window_geometry_policy.dart';

/// The pure restore-placement decision behind the launch geometry policy.
void main() {
  group('desktopRestorePlacement', () {
    const ordinaryBounds = Rect.fromLTWH(100, 100, 400, 300);

    DesktopDisplayGeometry display({
      required Rect workArea,
      double scaleFactor = 1,
    }) => (workArea: workArea, scaleFactor: scaleFactor);

    final primary = display(workArea: const Rect.fromLTWH(0, 0, 1920, 1032));
    final secondary = display(
      workArea: const Rect.fromLTWH(1920, 0, 1366, 768),
    );

    test('rejects a null stored geometry', () {
      expect(
        desktopRestorePlacement(
          storedBounds: null,
          storedMaximized: false,
          displays: [primary, secondary],
        ),
        isNull,
      );
    });

    test('rejects bounds with a non-finite left', () {
      expect(
        desktopRestorePlacement(
          storedBounds: const Rect.fromLTWH(double.nan, 100, 400, 300),
          storedMaximized: false,
          displays: [primary],
        ),
        isNull,
      );
    });

    test('rejects bounds with zero width', () {
      expect(
        desktopRestorePlacement(
          storedBounds: const Rect.fromLTWH(100, 100, 0, 300),
          storedMaximized: false,
          displays: [primary],
        ),
        isNull,
      );
    });

    test('rejects bounds with a negative height', () {
      expect(
        desktopRestorePlacement(
          storedBounds: const Rect.fromLTWH(100, 100, 400, -300),
          storedMaximized: false,
          displays: [primary],
        ),
        isNull,
      );
    });

    test('rejects an empty display list', () {
      expect(
        desktopRestorePlacement(
          storedBounds: ordinaryBounds,
          storedMaximized: false,
          displays: const [],
        ),
        isNull,
      );
    });

    test('rejects a mixed-DPI display set', () {
      final scaledSecondary = display(
        workArea: const Rect.fromLTWH(1920, 0, 1366, 768),
        scaleFactor: 1.5,
      );
      expect(
        desktopRestorePlacement(
          storedBounds: ordinaryBounds,
          storedMaximized: false,
          displays: [primary, scaledSecondary],
        ),
        isNull,
      );
    });

    test('rejects a display reporting a zero scale factor', () {
      final zeroScale = display(
        workArea: const Rect.fromLTWH(0, 0, 1920, 1032),
        scaleFactor: 0,
      );
      expect(
        desktopRestorePlacement(
          storedBounds: ordinaryBounds,
          storedMaximized: false,
          displays: [zeroScale],
        ),
        isNull,
      );
    });

    test('rejects a display reporting an infinite scale factor', () {
      final infiniteScale = display(
        workArea: const Rect.fromLTWH(0, 0, 1920, 1032),
        scaleFactor: double.infinity,
      );
      expect(
        desktopRestorePlacement(
          storedBounds: ordinaryBounds,
          storedMaximized: false,
          displays: [infiniteScale],
        ),
        isNull,
      );
    });

    test('rejects bounds straddling two same-scale displays side by side', () {
      const straddling = Rect.fromLTWH(1800, 100, 240, 300);
      expect(
        desktopRestorePlacement(
          storedBounds: straddling,
          storedMaximized: false,
          displays: [primary, secondary],
        ),
        isNull,
      );
    });

    test('rejects bounds that fell inside a display now absent (unplugged monitor)', () {
      const onlySecondaryFits = Rect.fromLTWH(2000, 100, 400, 300);
      expect(
        desktopRestorePlacement(
          storedBounds: onlySecondaryFits,
          storedMaximized: false,
          displays: [primary],
        ),
        isNull,
      );
    });

    test('rejects maximized bounds that fell inside a display now absent', () {
      // AC: a window maximized on the secondary must not restore maximized
      // once that display is gone. The flag never survives on its own; it
      // rides the normal bounds, and those bounds fail the visibility check.
      const onlySecondaryFits = Rect.fromLTWH(2000, 100, 400, 300);
      expect(
        desktopRestorePlacement(
          storedBounds: onlySecondaryFits,
          storedMaximized: true,
          displays: [primary],
        ),
        isNull,
      );
    });

    test('rejects bounds overflowing the only work area by one pixel', () {
      const overflowing = Rect.fromLTWH(1521, 100, 400, 300);
      // Right edge is 1921, one pixel past the 1920-wide work area's edge.
      expect(overflowing.right, primary.workArea.right + 1);
      expect(
        desktopRestorePlacement(
          storedBounds: overflowing,
          storedMaximized: false,
          displays: [primary],
        ),
        isNull,
      );
    });

    test('rejects non-empty bounds against a zero-width work area', () {
      final zeroWidth = display(workArea: const Rect.fromLTWH(0, 0, 0, 1032));
      expect(
        desktopRestorePlacement(
          storedBounds: ordinaryBounds,
          storedMaximized: false,
          displays: [zeroWidth],
        ),
        isNull,
      );
    });

    test('accepts bounds strictly inside the only work area', () {
      expect(
        desktopRestorePlacement(
          storedBounds: ordinaryBounds,
          storedMaximized: false,
          displays: [primary],
        ),
        (bounds: ordinaryBounds, maximized: false, workArea: primary.workArea),
      );
    });

    test('accepts bounds strictly inside the second of two displays', () {
      const onSecondary = Rect.fromLTWH(2000, 100, 400, 300);
      expect(
        desktopRestorePlacement(
          storedBounds: onSecondary,
          storedMaximized: false,
          displays: [primary, secondary],
        ),
        (bounds: onSecondary, maximized: false, workArea: secondary.workArea),
      );
    });

    test('accepts bounds exactly equal to the work area (inclusive edges)', () {
      expect(
        desktopRestorePlacement(
          storedBounds: primary.workArea,
          storedMaximized: false,
          displays: [primary],
        ),
        (
          bounds: primary.workArea,
          maximized: false,
          workArea: primary.workArea,
        ),
      );
    });

    test('accepts a maximized restore, keeping the normal bounds', () {
      expect(
        desktopRestorePlacement(
          storedBounds: ordinaryBounds,
          storedMaximized: true,
          displays: [primary],
        ),
        (bounds: ordinaryBounds, maximized: true, workArea: primary.workArea),
      );
    });

    test('skips a degenerate work area rather than failing on it', () {
      final degenerate = display(workArea: const Rect.fromLTWH(0, 0, 500, 0));
      expect(
        desktopRestorePlacement(
          storedBounds: ordinaryBounds,
          storedMaximized: false,
          displays: [primary, degenerate],
        ),
        (bounds: ordinaryBounds, maximized: false, workArea: primary.workArea),
      );
    });

    test("reports the second display's work area, not the first's, when the "
        'second accepts the bounds', () {
      const onSecondary = Rect.fromLTWH(2200, 200, 300, 200);
      final result = desktopRestorePlacement(
        storedBounds: onSecondary,
        storedMaximized: false,
        displays: [primary, secondary],
      );
      expect(result?.workArea, secondary.workArea);
      expect(result?.workArea, isNot(primary.workArea));
    });
  });
}
