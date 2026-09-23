import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/desktop/desktop_window_size.dart';

/// The pure half of the desktop window policy: ADR-0014 decisions 2 to 6.
/// The impure half is the applier in
/// `lib/desktop/desktop_window_minimum_listener.dart`.
void main() {
  group('desktopWindowSizeFor', () {
    test('keeps the design size where the work area is larger', () {
      // 1920x1080 at 100 % with a 48 px taskbar.
      expect(
        desktopWindowSizeFor(const Size(1920, 1032)),
        desktopDesignWindowSize,
      );
      expect(
        desktopWindowSizeFor(desktopDesignWindowSize),
        desktopDesignWindowSize,
      );
    });

    test('shrinks each axis independently', () {
      // 1366x768 at 100 % with a 48 px taskbar: only the height binds.
      expect(desktopWindowSizeFor(const Size(1366, 720)), const Size(1088, 720));
      // A work area narrower than the design width: only the width binds.
      expect(
        desktopWindowSizeFor(const Size(1000, 1400)),
        const Size(1000, 880),
      );
      // Both bind.
      expect(desktopWindowSizeFor(const Size(1000, 700)), const Size(1000, 700));
    });

    test('falls back to the floor for an unknown or unusable work area', () {
      // A window smaller than it needs to be is one the user can enlarge; a
      // window larger than its screen is the defect this exists to remove.
      expect(desktopWindowSizeFor(null), desktopFloorWindowSize);
      expect(desktopWindowSizeFor(Size.zero), desktopFloorWindowSize);
      expect(
        desktopWindowSizeFor(const Size(double.infinity, 900)),
        desktopFloorWindowSize,
      );
      expect(
        desktopWindowSizeFor(const Size(1366, double.nan)),
        desktopFloorWindowSize,
      );
      expect(
        desktopWindowSizeFor(const Size(1366, -1)),
        desktopFloorWindowSize,
      );
    });

    test('subtracts the Linux decoration to make the request an outer size', () {
      // GNOME on Yaru: a 46 px header bar outside the size `setSize` takes.
      // 674 requested + 46 of header is the 720 px work area exactly.
      expect(
        desktopWindowSizeFor(const Size(1366, 720), decoration: const Size(0, 46)),
        const Size(1088, 674),
      );
      // Where the design size fits, the decoration still comes off, because
      // the design size is an outer figure: 834 requested + 46 of header is
      // the 880 px design height.
      expect(
        desktopWindowSizeFor(const Size(1366, 1032), decoration: const Size(0, 46)),
        const Size(1088, 834),
      );
      // The floor is an outer figure too, so the unknown-work-area fallback
      // carries the same allowance: 614 + 46 is the 660 px floor.
      expect(
        desktopWindowSizeFor(null, decoration: const Size(0, 46)),
        const Size(1088, 614),
      );
    });

    test('falls back to the floor when the decoration eats the work area', () {
      expect(
        desktopWindowSizeFor(const Size(1366, 40), decoration: const Size(0, 46)),
        desktopFloorWindowSize,
      );
    });
  });

  group('desktopDisplayFor', () {
    // A 1920x1080 primary with a 48 px taskbar, and a 1366x768 secondary to
    // its right with none.
    const primary = (
      visiblePosition: Offset.zero,
      size: Size(1920, 1080),
      visibleSize: Size(1920, 1032),
    );
    const secondary = (
      visiblePosition: Offset(1920, 0),
      size: Size(1366, 768),
      visibleSize: Size(1366, 768),
    );

    test('picks the display containing the point', () {
      expect(
        desktopDisplayFor(
          displays: const [primary, secondary],
          primary: primary,
          point: const Offset(2100, 400),
        ),
        secondary,
      );
      expect(
        desktopDisplayFor(
          displays: const [primary, secondary],
          primary: primary,
          point: const Offset(100, 400),
        ),
        primary,
      );
    });

    test('falls back to the primary when the point is in no display', () {
      expect(
        desktopDisplayFor(
          displays: const [primary, secondary],
          primary: primary,
          point: const Offset(-500, 400),
        ),
        primary,
      );
    });

    test('skips a display that reports no position rather than throwing', () {
      // `calcWindowPosition` force-unwraps `visiblePosition!` here. Skipping
      // the display is a property of this function only; the plugin keeps its
      // throw, and nothing here claims to fix it.
      const unplaced = (
        visiblePosition: null,
        size: Size(1366, 768),
        visibleSize: Size(1366, 768),
      );
      expect(
        desktopDisplayFor(
          displays: const [unplaced, secondary],
          primary: primary,
          point: const Offset(2100, 400),
        ),
        secondary,
      );
      expect(
        desktopDisplayFor(
          displays: const [unplaced],
          primary: primary,
          point: const Offset(100, 400),
        ),
        primary,
      );
    });

    test('falls back to the primary for an empty display list', () {
      expect(
        desktopDisplayFor(
          displays: const [],
          primary: primary,
          point: Offset.zero,
        ),
        primary,
      );
    });
  });

  group('desktopWorkAreaOf', () {
    test('is the visible size, never the display size', () {
      expect(
        desktopWorkAreaOf((
          visiblePosition: Offset.zero,
          size: const Size(1920, 1080),
          visibleSize: const Size(1920, 1032),
        )),
        const Size(1920, 1032),
      );
    });

    test('is unknown when the display reports no usable work area', () {
      // `Display.size` is not a substitute: on Windows it is
      // `rcMonitor.right/scale - rcWork.left/scale`, which is not the monitor
      // size off the primary display.
      for (final visibleSize in <Size?>[
        null,
        Size.zero,
        const Size(double.infinity, 1032),
        const Size(1920, -1),
      ]) {
        expect(
          desktopWorkAreaOf((
            visiblePosition: Offset.zero,
            size: const Size(1920, 1080),
            visibleSize: visibleSize,
          )),
          isNull,
        );
      }
    });
  });

  group('desktopMinimumSizeFor', () {
    test('is the floor plus the measured chrome where there is room', () {
      expect(
        desktopMinimumSizeFor(
          chrome: const Size(16, 40),
          workArea: const Size(1920, 1032),
        ),
        (size: const Size(1088, 660), capped: false),
      );
    });

    test('caps to the work area and reports the below-floor machine', () {
      // A 1366x768 screen with a 120 px taskbar leaves 648 px, which is less
      // than the 660 px outer floor. The window must still be shrinkable to
      // fit its own screen, so the cap wins and the caller logs it.
      expect(
        desktopMinimumSizeFor(
          chrome: const Size(16, 40),
          workArea: const Size(1366, 648),
        ),
        (size: const Size(1088, 648), capped: true),
      );
      // The width axis caps on its own.
      expect(
        desktopMinimumSizeFor(
          chrome: const Size(16, 40),
          workArea: const Size(1000, 1032),
        ),
        (size: const Size(1000, 660), capped: true),
      );
    });

    test('is the floor window size until a chrome measurement is accepted', () {
      expect(
        desktopMinimumSizeFor(chrome: null, workArea: const Size(1920, 1032)),
        (size: desktopFloorWindowSize, capped: false),
      );
      // The cap still binds before the measurement lands.
      expect(
        desktopMinimumSizeFor(chrome: null, workArea: const Size(1366, 648)),
        (size: const Size(1088, 648), capped: true),
      );
    });

    test('applies no cap when the work area is unknown or unusable', () {
      for (final workArea in <Size?>[
        null,
        Size.zero,
        const Size(double.infinity, 1032),
        const Size(1920, -1),
      ]) {
        expect(
          desktopMinimumSizeFor(chrome: const Size(16, 40), workArea: workArea),
          (size: const Size(1088, 660), capped: false),
        );
      }
    });

    test('ignores an implausible chrome rather than trusting it', () {
      expect(
        desktopMinimumSizeFor(
          chrome: const Size(16, 580),
          workArea: const Size(1920, 1032),
        ),
        (size: desktopFloorWindowSize, capped: false),
      );
    });
  });

  group('isPlausibleChrome', () {
    test('accepts the frames the three desktops actually report', () {
      // Windows, macOS, and a server-side-decorated GTK desktop.
      expect(isPlausibleChrome(const Size(16, 40)), isTrue);
      expect(isPlausibleChrome(const Size(0, 28)), isTrue);
      expect(isPlausibleChrome(Size.zero), isTrue);
    });

    test('rejects a sample outside the per-axis band', () {
      expect(isPlausibleChrome(const Size(16, 580)), isFalse);
      expect(isPlausibleChrome(const Size(200, 40)), isFalse);
      expect(isPlausibleChrome(const Size(-1, 40)), isFalse);
      expect(isPlausibleChrome(const Size(16, -1)), isFalse);
      expect(isPlausibleChrome(const Size(double.infinity, 40)), isFalse);
      expect(isPlausibleChrome(const Size(16, double.nan)), isFalse);
    });
  });

  group('desktopChromeSample', () {
    test('rejects an out-of-band sample and discards the pending one', () {
      // The window was maximized between the two samples: the client area is
      // the whole screen and the difference is nonsense.
      expect(
        desktopChromeSample(
          outer: const Size(1088, 880),
          client: const Size(1072, 300),
          pending: const Size(16, 40),
        ),
        (chrome: null, pending: null),
      );
    });

    test('holds one in-band sample without accepting it', () {
      expect(
        desktopChromeSample(
          outer: const Size(1088, 880),
          client: const Size(1072, 840),
          pending: null,
        ),
        (chrome: null, pending: const Size(16, 40)),
      );
    });

    test('accepts two consecutive equal in-band samples', () {
      expect(
        desktopChromeSample(
          outer: const Size(1088, 880),
          client: const Size(1072, 840),
          pending: const Size(16, 40),
        ),
        (chrome: const Size(16, 40), pending: const Size(16, 40)),
      );
    });

    test('replaces a pending sample the next one disagrees with', () {
      expect(
        desktopChromeSample(
          outer: const Size(1088, 880),
          client: const Size(1072, 852),
          pending: const Size(16, 40),
        ),
        (chrome: null, pending: const Size(16, 28)),
      );
    });
  });
}
