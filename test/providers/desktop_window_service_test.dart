import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/desktop_attention_service.dart';
import 'package:sideswap/providers/desktop_window_service.dart';
import 'package:sideswap/providers/notification_removal_reason.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:window_manager/window_manager.dart';

import '../helpers/test_utils.dart';

class MockWindowManager extends Mock implements WindowManager {}

class MockDesktopAttentionService extends Mock
    implements DesktopAttentionService {}

class _FakeWindowListener extends Fake implements WindowListener {}

void main() {
  registerFallbackValue(_FakeWindowListener());

  // Required: the default DesktopWindowService reaches WindowManager.instance,
  // whose constructor installs a method-call handler on the binary messenger.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('desktopWindowServiceProvider', () {
    test('creates a DesktopWindowService from the container', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final service = container.read(desktopWindowServiceProvider);

      expect(service, isA<DesktopWindowService>());
    });
  });

  group('WindowDisposition', () {
    // One row per line of ADR-0005 decision 1's table. The dispositions overlap
    // as measured, so each row states every fact its own precedence turns on and
    // lets the defaults supply the rest: what is asserted is which fact wins, so
    // the facts a row is about are never left to a default.
    WindowDisposition dispositionOf({
      bool isOnActiveSpace = true,
      bool isHidden = false,
      bool isMinimized = false,
      bool isVisible = false,
      bool isFocused = false,
    }) => WindowDisposition.of(
      isOnActiveSpace: isOnActiveSpace,
      isHidden: isHidden,
      isMinimized: isMinimized,
      isVisible: isVisible,
      isFocused: isFocused,
    );

    test('a window on another Space outranks every other fact about it', () {
      expect(
        dispositionOf(
          isOnActiveSpace: false,
          isHidden: true,
          isMinimized: true,
          isVisible: true,
          isFocused: true,
        ),
        WindowDisposition.offActiveSpace,
      );
    });

    test('a hidden app outranks a minimized window', () {
      // The row ADR-0005 calls out by name: a raise would un-hide as well as
      // de-miniaturize, and the only undo the app has is minimize().
      expect(
        dispositionOf(isHidden: true, isMinimized: true),
        WindowDisposition.hidden,
      );
    });

    test('a hidden app whose window is not minimized is still hidden', () {
      expect(dispositionOf(isHidden: true), WindowDisposition.hidden);
    });

    test(
      'a minimized window on the active Space of an app that is not hidden is '
      'the one disposition the app can put back',
      () {
        expect(dispositionOf(isMinimized: true), WindowDisposition.minimized);
      },
    );

    test('a window the user can see but is not typing into is inactive', () {
      expect(
        dispositionOf(isVisible: true),
        WindowDisposition.visibleInactive,
      );
    });

    test('a window that is neither minimized nor visible is inactive', () {
      expect(dispositionOf(), WindowDisposition.visibleInactive);
    });

    test('a window in front of the user with the keyboard in it is active', () {
      expect(
        dispositionOf(isVisible: true, isFocused: true),
        WindowDisposition.active,
      );
    });
  });

  group('DesktopWindowService.raise', () {
    late MockWindowManager mockWindowManager;

    setUp(() {
      mockWindowManager = MockWindowManager();
      when(() => mockWindowManager.restore()).thenAnswer((_) async {});
      when(() => mockWindowManager.show()).thenAnswer((_) async {});
      when(() => mockWindowManager.focus()).thenAnswer((_) async {});
      when(
        () => mockWindowManager.setAlwaysOnTop(any()),
      ).thenAnswer((_) async {});
    });

    DesktopWindowService buildService({
      required bool togglesAlwaysOnTopOnRaise,
    }) {
      return DesktopWindowService(
        windowManager: mockWindowManager,
        capabilities: DesktopWindowCapabilities(
          togglesAlwaysOnTopOnRaise: togglesAlwaysOnTopOnRaise,
          requestsUserAttentionOnRaise: false,
          // raise() is issued once the disposition has already decided; none of
          // the capabilities below reaches it.
          raisesOnlyFromMinimizedWindow: false,
          readsNativeWindowPlacement: false,
          showsPendingBadge: false,
        ),
      );
    }

    test(
      'issues restore, show and focus and nothing else when the capability is off',
      () async {
        final service = buildService(togglesAlwaysOnTopOnRaise: false);

        await service.raise();

        verifyInOrder([
          () => mockWindowManager.restore(),
          () => mockWindowManager.show(),
          () => mockWindowManager.focus(),
        ]);
        verifyNoMoreInteractions(mockWindowManager);
      },
    );

    test(
      'appends the always-on-top toggle when the capability is on',
      () async {
        final service = buildService(togglesAlwaysOnTopOnRaise: true);

        await service.raise();

        verifyInOrder([
          () => mockWindowManager.restore(),
          () => mockWindowManager.show(),
          () => mockWindowManager.focus(),
          () => mockWindowManager.setAlwaysOnTop(true),
          () => mockWindowManager.setAlwaysOnTop(false),
        ]);
        verifyNoMoreInteractions(mockWindowManager);
      },
    );

    test(
      'clears always-on-top even when setting it fails, so the window is not '
      'left pinned above everything',
      () async {
        when(
          () => mockWindowManager.setAlwaysOnTop(true),
        ).thenThrow(Exception('window manager refused'));
        final service = buildService(togglesAlwaysOnTopOnRaise: true);

        await expectLater(service.raise(), throwsException);

        verify(() => mockWindowManager.setAlwaysOnTop(false)).called(1);
      },
    );

    group('default capabilities', () {
      // The production default is a platform read, so each value is asserted on
      // the platform that produces it (docs/TESTING.md: platform-gated branches
      // are covered, not exempted). Observed through raise(), the only public
      // surface that reveals the capability.
      test('omit the always-on-top toggle on macOS', () async {
        final service = DesktopWindowService(windowManager: mockWindowManager);

        await service.raise();

        verifyNever(() => mockWindowManager.setAlwaysOnTop(any()));
      }, testOn: 'mac-os');

      test('keep the always-on-top toggle off macOS', () async {
        final service = DesktopWindowService(windowManager: mockWindowManager);

        await service.raise();

        verifyInOrder([
          () => mockWindowManager.setAlwaysOnTop(true),
          () => mockWindowManager.setAlwaysOnTop(false),
        ]);
      }, testOn: '!mac-os');
    });
  });

  group('DesktopWindowService raise episode', () {
    late MockWindowManager mockWindowManager;
    late MockDesktopAttentionService mockAttentionService;

    setUp(() {
      mockWindowManager = MockWindowManager();
      when(() => mockWindowManager.restore()).thenAnswer((_) async {});
      when(() => mockWindowManager.show()).thenAnswer((_) async {});
      when(() => mockWindowManager.focus()).thenAnswer((_) async {});
      when(() => mockWindowManager.minimize()).thenAnswer((_) async {});
      // Default disposition: the window is minimized, so an episode opens.
      when(() => mockWindowManager.isMinimized()).thenAnswer((_) async => true);
      when(() => mockWindowManager.isVisible()).thenAnswer((_) async => false);
      when(() => mockWindowManager.isFocused()).thenAnswer((_) async => false);

      // The service logs a refused attention channel; the default output
      // reaches path_provider, which has no implementation under test.
      logger = CustomLogger('SideSwap', output: NoOpLogOutput());

      mockAttentionService = MockDesktopAttentionService();
      when(
        () => mockAttentionService.requestCriticalAttention(),
      ).thenAnswer((_) async => 7);
      when(
        () => mockAttentionService.cancelAttention(any()),
      ).thenAnswer((_) async {});
      // Default placement: the window is where a raise would be harmless, so
      // the disposition is decided by the window manager predicates alone.
      when(
        () => mockAttentionService.readWindowPlacement(),
      ).thenAnswer((_) async => WindowPlacement.fallback);
    });

    // Defaults to the Windows and Linux arm, so every test that does not name
    // the capability is asserting the shipped behaviour.
    DesktopWindowService buildService({
      bool requestsUserAttentionOnRaise = true,
      bool raisesOnlyFromMinimizedWindow = false,
      bool readsNativeWindowPlacement = false,
      bool showsPendingBadge = false,
    }) => DesktopWindowService(
      windowManager: mockWindowManager,
      attentionService: mockAttentionService,
      capabilities: DesktopWindowCapabilities(
        togglesAlwaysOnTopOnRaise: false,
        requestsUserAttentionOnRaise: requestsUserAttentionOnRaise,
        raisesOnlyFromMinimizedWindow: raisesOnlyFromMinimizedWindow,
        readsNativeWindowPlacement: readsNativeWindowPlacement,
        showsPendingBadge: showsPendingBadge,
      ),
    );

    /// The macOS arm: the app raises only from a minimized window and asks the
    /// platform where that window is before it decides.
    DesktopWindowService buildMacOsService() => buildService(
      raisesOnlyFromMinimizedWindow: true,
      readsNativeWindowPlacement: true,
    );

    /// Answers the native query with a placement of the app's choosing.
    void stubPlacement({bool isOnActiveSpace = true, bool isHidden = false}) {
      when(() => mockAttentionService.readWindowPlacement()).thenAnswer(
        (_) async => WindowPlacement(
          isOnActiveSpace: isOnActiveSpace,
          isHidden: isHidden,
        ),
      );
    }

    /// Delivers [requestId] and lets the raise settle by reporting the window
    /// transition the raise asked for, the way the platform would.
    Future<void> deliverAndSettle(
      DesktopWindowService service,
      int requestId,
    ) async {
      final delivered = service.onRequestDelivered(requestId);
      await pumpEventQueue();
      service.onWindowRestore();
      await delivered;
    }

    /// Puts the window where the user can see it but is not typing into it —
    /// the one disposition the two capability arms disagree about.
    void stubVisibleButInactiveWindow() {
      when(
        () => mockWindowManager.isMinimized(),
      ).thenAnswer((_) async => false);
      when(() => mockWindowManager.isVisible()).thenAnswer((_) async => true);
      when(() => mockWindowManager.isFocused()).thenAnswer((_) async => false);
    }

    /// Puts the window in front of the user with the keyboard in it: the one
    /// disposition both capability arms leave alone.
    void stubActiveWindow() {
      when(
        () => mockWindowManager.isMinimized(),
      ).thenAnswer((_) async => false);
      when(() => mockWindowManager.isVisible()).thenAnswer((_) async => true);
      // Stated rather than inherited from the outer setUp: a helper that leaves
      // a predicate to it would start supplying an unintended disposition if
      // the predicates are ever sampled in a different order.
      when(() => mockWindowManager.isFocused()).thenAnswer((_) async => true);
    }

    /// Puts the window off the screen without minimizing it, as far as the
    /// window manager can tell.
    ///
    /// Deliberately not called "hidden": these three predicates cannot say
    /// whether the app is hidden — a window off the active Space reports the
    /// same, and so does one merely occluded on some window managers. Hidden is
    /// what the native placement query answers, and a test about it stubs that
    /// (ADR-0005 decision 1).
    void stubOffScreenButNotMinimizedWindow() {
      when(
        () => mockWindowManager.isMinimized(),
      ).thenAnswer((_) async => false);
      when(() => mockWindowManager.isVisible()).thenAnswer((_) async => false);
      // Stated rather than inherited from the group default, for the same
      // reason as in [stubActiveWindow] above.
      when(() => mockWindowManager.isFocused()).thenAnswer((_) async => false);
    }

    test(
      'a platform with no attention capability issues no attention call, so '
      'Windows and Linux never reach the channel',
      () async {
        final service = buildService(requestsUserAttentionOnRaise: false);

        await deliverAndSettle(service, 1);
        service.onWindowFocus();

        verifyZeroInteractions(mockAttentionService);
      },
    );

    test(
      'a request delivered to a window the user cannot see asks the OS for '
      'critical attention as well as raising it',
      () async {
        final service = buildService();

        await deliverAndSettle(service, 1);

        verify(() => mockAttentionService.requestCriticalAttention()).called(1);
        verify(() => mockWindowManager.focus()).called(1);
      },
    );

    test(
      'a second request joining the episode does not orphan the bounce the '
      'first one started',
      () async {
        final issuedIds = [7, 9];
        when(
          () => mockAttentionService.requestCriticalAttention(),
        ).thenAnswer((_) async => issuedIds.removeAt(0));
        final service = buildService();
        await deliverAndSettle(service, 1);

        await service.onRequestDelivered(2);
        service.onWindowFocus();

        verify(() => mockAttentionService.requestCriticalAttention()).called(1);
        verify(() => mockAttentionService.cancelAttention(7)).called(1);
        verifyNever(() => mockAttentionService.cancelAttention(9));
      },
    );

    group('the pending badge', () {
      // The count itself belongs to the notifications notifier (ADR-0005
      // decision 3); what is asserted here is that the service forwards it and
      // never derives one of its own from the episode's unresolved ids.
      setUp(() {
        when(
          () => mockAttentionService.setPendingBadge(any()),
        ).thenAnswer((_) async {});
      });

      test('the count is passed to the platform unchanged', () async {
        final service = buildService(showsPendingBadge: true);

        await service.setPendingBadge(3);

        verify(() => mockAttentionService.setPendingBadge(3)).called(1);
      });

      test(
        'a count of zero is forwarded too, so an emptied list is written out '
        'rather than left standing',
        () async {
          final service = buildService(showsPendingBadge: true);

          await service.setPendingBadge(0);

          verify(() => mockAttentionService.setPendingBadge(0)).called(1);
        },
      );

      test(
        'the count the notifier hands over is forwarded even while the episode '
        'holds a different number of ids',
        () async {
          // ADR-0005 decision 3: a request carrying both a connect and a sign
          // payload is two entries under one id, and the notifier is the single
          // authority for the badge.
          final service = buildService(showsPendingBadge: true);
          await deliverAndSettle(service, 1);

          await service.setPendingBadge(2);

          verify(() => mockAttentionService.setPendingBadge(2)).called(1);
        },
      );

      test('a platform without a badge is asked for nothing', () async {
        final service = buildService();

        await service.setPendingBadge(3);

        verifyNever(() => mockAttentionService.setPendingBadge(any()));
      });

      test(
        'a refused badge channel does not escape to the notifier',
        () async {
          when(
            () => mockAttentionService.setPendingBadge(any()),
          ).thenThrow(Exception('no badge channel on this platform'));
          final service = buildService(showsPendingBadge: true);

          await expectLater(service.setPendingBadge(1), completes);
        },
      );

      test(
        'a badge written after the provider is disposed still reaches the '
        'platform',
        () async {
          // The notifier clears the badge as it is disposed, and the window
          // service may already have been. A guard here would leave a stale
          // count on an icon nothing is left to correct.
          final service = buildService(showsPendingBadge: true);
          service.dispose();

          await service.setPendingBadge(0);

          verify(() => mockAttentionService.setPendingBadge(0)).called(1);
        },
      );
    });

    test(
      'a refused attention request does not cost the user the raise',
      () async {
        when(
          () => mockAttentionService.requestCriticalAttention(),
        ).thenThrow(Exception('no attention channel on this platform'));
        final service = buildService();

        await deliverAndSettle(service, 1);

        verifyInOrder([
          () => mockWindowManager.restore(),
          () => mockWindowManager.show(),
          () => mockWindowManager.focus(),
        ]);
        // The episode is intact despite the refusal: it still owns the window
        // it raised, and still puts it back.
        await service.onRequestResolved(
          1,
          NotificationRemovalReason.acceptedByUser,
        );
        verify(() => mockWindowManager.minimize()).called(1);
      },
    );

    test(
      'a refused cancellation leaves the episode working, and does not escape '
      'the platform callback that triggered it',
      () async {
        when(
          () => mockAttentionService.cancelAttention(any()),
        ).thenAnswer((_) async => throw Exception('channel gone'));
        final service = buildService();
        await deliverAndSettle(service, 1);

        service.onWindowFocus();
        await pumpEventQueue();

        await service.onRequestResolved(
          1,
          NotificationRemovalReason.acceptedByUser,
        );
        verify(() => mockWindowManager.minimize()).called(1);
      },
    );

    // Ending an episode removes the window listener, so after it no focus
    // event can ever arrive to stop a bounce still outstanding.
    group('ending the episode stops the bounce', () {
      test('when the episode is abandoned', () async {
        final service = buildService();
        await deliverAndSettle(service, 1);

        await service.abandonEpisode();

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
      });

      test('when the service is disposed', () async {
        final service = buildService();
        await deliverAndSettle(service, 1);

        service.dispose();

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
      });

      test('when the last request is resolved', () async {
        final service = buildService();
        await deliverAndSettle(service, 1);

        await service.onRequestResolved(
          1,
          NotificationRemovalReason.acceptedByUser,
        );

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
      });

      test('when the window manager refuses the raise', () async {
        // The attention request precedes the raise, so without this the refusal
        // would leave an id stored with no episode left to cancel it.
        when(
          () => mockWindowManager.restore(),
        ).thenThrow(Exception('window manager refused activation'));
        final service = buildService();

        await expectLater(service.onRequestDelivered(1), throwsException);

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
      });
    });

    // The listener is what carries the focus event that stops a bounce, so it
    // cannot be scoped to the episode any more: a bounce now happens with no
    // episode at all. ADR-0005 decision 2.
    group('the listener lives as long as a bounce or an episode', () {
      test('a bounce with no episode still listens for the focus that stops '
          'it', () async {
        stubVisibleButInactiveWindow();
        final service = buildService(raisesOnlyFromMinimizedWindow: true);

        await service.onRequestDelivered(1);

        verify(() => mockWindowManager.addListener(service)).called(1);
        verifyNever(() => mockWindowManager.removeListener(any()));
      });

      test('the focus that stops a bounce with no episode also ends the '
          'listening', () async {
        stubVisibleButInactiveWindow();
        final service = buildService(raisesOnlyFromMinimizedWindow: true);
        await service.onRequestDelivered(1);

        service.onWindowFocus();

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
        verify(() => mockWindowManager.removeListener(service)).called(1);
      });

      // Vacuous on macOS by construction — the capability gate is what stops
      // this arm short of the listener — so it is the Windows and Linux
      // baseline, not the macOS negative half. That one is the declined-bounce
      // test below.
      test('a platform that never bounces registers no listener for a delivery '
          'that opens no episode', () async {
        stubActiveWindow();
        final service = buildService(requestsUserAttentionOnRaise: false);

        await service.onRequestDelivered(1);

        verifyNever(() => mockWindowManager.addListener(any()));
        verifyZeroInteractions(mockAttentionService);
      });

      test('disposing while a bounce with no episode is outstanding withdraws '
          'it and stops listening', () async {
        stubVisibleButInactiveWindow();
        final service = buildService(raisesOnlyFromMinimizedWindow: true);
        await service.onRequestDelivered(1);

        service.dispose();

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
        verify(() => mockWindowManager.removeListener(service)).called(1);
      });

      test('resolving the last request that a bounce with no episode stood for '
          'withdraws it and stops listening', () async {
        stubVisibleButInactiveWindow();
        final service = buildService(raisesOnlyFromMinimizedWindow: true);
        await service.onRequestDelivered(1);

        // Nothing is waiting on the user any more, so a Dock still bouncing
        // would be asking for them on behalf of a request that is gone — and
        // the id it holds would suppress the bounce for every request after it.
        await service.onRequestResolved(1, NotificationRemovalReason.expired);

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
        verify(() => mockWindowManager.removeListener(service)).called(1);
      });

      test('a bounce with no episode outlives a request resolved while others '
          'are still pending', () async {
        stubVisibleButInactiveWindow();
        final service = buildService(raisesOnlyFromMinimizedWindow: true);
        await service.onRequestDelivered(1);
        await service.onRequestDelivered(2);

        await service.onRequestResolved(1, NotificationRemovalReason.expired);

        verifyNever(() => mockAttentionService.cancelAttention(any()));
        verifyNever(() => mockWindowManager.removeListener(any()));
      });

      test('a transient bounce the platform declines takes its listener back '
          'down', () async {
        // The app was already frontmost, so the native side issues nothing —
        // but the listener was registered before the round trip, because a
        // focus event can arrive while it is still in flight.
        stubActiveWindow();
        when(
          () => mockAttentionService.requestCriticalAttention(),
        ).thenAnswer((_) async => null);
        final service = buildService(raisesOnlyFromMinimizedWindow: true);

        await service.onRequestDelivered(1);

        verify(() => mockWindowManager.addListener(service)).called(1);
        verify(() => mockWindowManager.removeListener(service)).called(1);
      });

      test('an episode keeps the listener the bounce that preceded it stopped '
          'needing', () async {
        // The focus event stops the bounce, but the episode the raise opened
        // still needs to hear the transitions that settle it.
        final service = buildService();
        await deliverAndSettle(service, 1);

        service.onWindowFocus();

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
        verifyNever(() => mockWindowManager.removeListener(any()));
      });
    });

    test(
      'a slow attention round trip does not spend the window the raise needs '
      'to have its own transitions attributed to it',
      () {
        fakeAsync((async) {
          final replied = Completer<int?>();
          when(
            () => mockAttentionService.requestCriticalAttention(),
          ).thenAnswer((_) => replied.future);
          final service = buildService();
          service.onRequestDelivered(1);
          async.flushMicrotasks();

          // The platform takes longer to answer than the whole grace period,
          // and only then does the raise it precedes get issued.
          async.elapse(kWindowTransitionGrace * 2);
          replied.complete(7);
          async.flushMicrotasks();
          service.onWindowRestore();
          async.flushMicrotasks();

          service.onRequestResolved(
            1,
            NotificationRemovalReason.acceptedByUser,
          );
          async.elapse(kOwnershipSettleTimeout);
          async.flushMicrotasks();

          verify(() => mockWindowManager.minimize()).called(1);
        });
      },
    );

    group('an attention id that lands too late is still cancelled', () {
      /// Delivers [requestId] while the platform has not yet answered the
      /// attention request, and hands back the reply to release it with.
      Completer<int?> deliverWithAttentionInFlight(
        DesktopWindowService service,
        int requestId,
      ) {
        final replied = Completer<int?>();
        when(
          () => mockAttentionService.requestCriticalAttention(),
        ).thenAnswer((_) => replied.future);
        unawaited(service.onRequestDelivered(requestId));
        return replied;
      }

      test('when the service was disposed while it was in flight', () async {
        final service = buildService();
        final replied = deliverWithAttentionInFlight(service, 1);
        await pumpEventQueue();

        service.dispose();
        replied.complete(7);
        await pumpEventQueue();

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
      });

      test(
        'and the raise it preceded is dropped, so nothing touches the window '
        'after disposal',
        () {
          fakeAsync((async) {
            final replied = Completer<int?>();
            when(
              () => mockAttentionService.requestCriticalAttention(),
            ).thenAnswer((_) => replied.future);
            final service = buildService();
            service.onRequestDelivered(1);
            async.flushMicrotasks();

            service.dispose();
            replied.complete(7);
            async.flushMicrotasks();

            verifyNever(() => mockWindowManager.restore());
            expect(async.pendingTimers, isEmpty);
          });
        },
      );

      test(
        'and disposing while the window disposition is still being sampled '
        'leaves nothing behind',
        () {
          fakeAsync((async) {
            final sampled = Completer<bool>();
            when(
              () => mockWindowManager.isMinimized(),
            ).thenAnswer((_) => sampled.future);
            final service = buildService();
            service.onRequestDelivered(1);
            async.flushMicrotasks();

            // Disposal lands after the attention round trip but before the
            // platform has said what the window was doing.
            service.dispose();
            sampled.complete(true);
            async.flushMicrotasks();

            verifyNever(() => mockWindowManager.restore());
            expect(async.pendingTimers, isEmpty);
          });
        },
      );

      test('when the user focused the window while it was in flight', () async {
        final service = buildService();
        final replied = deliverWithAttentionInFlight(service, 1);
        await pumpEventQueue();

        // The user reaches the app themselves, before the OS has even said
        // which request id it issued.
        service.onWindowFocus();
        replied.complete(7);
        await pumpEventQueue();

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
      });

      test('when the user focused the window with no episode open at all, so '
          'no episode end would have caught the id either', () async {
        stubVisibleButInactiveWindow();
        final service = buildService(raisesOnlyFromMinimizedWindow: true);
        final replied = deliverWithAttentionInFlight(service, 1);
        await pumpEventQueue();

        // Nothing but the flag is left to catch the id: the app left the window
        // where it was, so there is no episode whose end would cancel it.
        service.onWindowFocus();
        replied.complete(7);
        await pumpEventQueue();

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
      });
    });

    test(
      'a second request arriving while a bounce with no episode is outstanding '
      'does not bounce again',
      () async {
        stubVisibleButInactiveWindow();
        final service = buildService(raisesOnlyFromMinimizedWindow: true);

        await service.onRequestDelivered(1);
        await service.onRequestDelivered(2);

        // The second request adds to the count, which is what the pending badge
        // is for; the bounce already means "something needs you".
        verify(() => mockAttentionService.requestCriticalAttention()).called(1);
        verify(() => mockWindowManager.addListener(service)).called(1);
      },
    );

    test(
      'a platform with no attention capability issues no attention call from a '
      'disposition it leaves alone either',
      () async {
        stubVisibleButInactiveWindow();
        final service = buildService(
          requestsUserAttentionOnRaise: false,
          raisesOnlyFromMinimizedWindow: true,
        );

        await service.onRequestDelivered(1);
        service.onWindowFocus();

        verifyZeroInteractions(mockAttentionService);
      },
    );

    test(
      'a request that found the app already active does not suppress the '
      'bounce for the request after it',
      () async {
        final replies = <int?>[null, 9];
        when(
          () => mockAttentionService.requestCriticalAttention(),
        ).thenAnswer((_) async => replies.removeAt(0));
        final service = buildService();
        await deliverAndSettle(service, 1);

        await service.onRequestDelivered(2);

        verify(() => mockAttentionService.requestCriticalAttention()).called(2);
      },
    );

    test('a focus event outside any raise cancels nothing', () {
      final service = buildService();

      service.onWindowFocus();

      verifyNever(() => mockAttentionService.cancelAttention(any()));
    });

    test(
      'focusing again after the bounce already stopped cancels nothing more',
      () async {
        final service = buildService();
        await deliverAndSettle(service, 1);

        service.onWindowFocus();
        service.onWindowFocus();

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
      },
    );

    test(
      'the attention request is stored before the raise, so a focus event the '
      'raise itself produces still stops the bounce',
      () async {
        late final DesktopWindowService service;
        // The raise brings the window forward and the platform reports focus
        // before the raise call returns — the tightest ordering the OS can
        // produce, and the one an id stored after the raise would miss.
        when(() => mockWindowManager.restore()).thenAnswer((_) async {
          service.onWindowFocus();
        });
        service = buildService();

        await service.onRequestDelivered(1);

        verify(() => mockAttentionService.cancelAttention(7)).called(1);
      },
    );

    test(
      'the app being already frontmost issues no bounce, so focus has nothing '
      'to cancel',
      () async {
        // The activity check lives natively: a null reply is the platform
        // saying it declined to issue a request.
        when(
          () => mockAttentionService.requestCriticalAttention(),
        ).thenAnswer((_) async => null);
        final service = buildService();

        await deliverAndSettle(service, 1);
        service.onWindowFocus();

        verifyNever(() => mockAttentionService.cancelAttention(any()));
      },
    );

    test(
      'a request delivered to a window the user cannot see raises it and '
      'starts listening for window transitions',
      () async {
        final service = buildService();

        await deliverAndSettle(service, 1);

        verifyInOrder([
          () => mockWindowManager.restore(),
          () => mockWindowManager.show(),
          () => mockWindowManager.focus(),
        ]);
        verify(() => mockWindowManager.addListener(service)).called(1);
      },
    );

    test(
      'a request arriving while the user already had the window open opens no '
      'episode, so resolving it does not minimize',
      () async {
        when(
          () => mockWindowManager.isMinimized(),
        ).thenAnswer((_) async => false);
        when(() => mockWindowManager.isVisible()).thenAnswer((_) async => true);
        when(() => mockWindowManager.isFocused()).thenAnswer((_) async => true);
        final service = buildService();

        await service.onRequestDelivered(1);
        await service.onRequestResolved(
          1,
          NotificationRemovalReason.acceptedByUser,
        );

        verifyNever(() => mockWindowManager.restore());
        verifyNever(() => mockWindowManager.minimize());
      },
    );

    test('accepting a request the app raised for minimizes the window', () async {
      final service = buildService();
      await deliverAndSettle(service, 1);

      await service.onRequestResolved(
        1,
        NotificationRemovalReason.acceptedByUser,
      );

      verify(() => mockWindowManager.minimize()).called(1);
    });

    test('rejecting a request the app raised for minimizes the window', () async {
      final service = buildService();
      await deliverAndSettle(service, 1);

      await service.onRequestResolved(
        1,
        NotificationRemovalReason.rejectedByUser,
      );

      verify(() => mockWindowManager.minimize()).called(1);
    });

    test('a request left to expire never minimizes the window', () async {
      final service = buildService();
      await deliverAndSettle(service, 1);

      await service.onRequestResolved(1, NotificationRemovalReason.expired);

      verifyNever(() => mockWindowManager.minimize());
    });

    test(
      'a request cancelled by the remote origin never minimizes the window',
      () async {
        final service = buildService();
        await deliverAndSettle(service, 1);

        await service.onRequestResolved(
          1,
          NotificationRemovalReason.remoteCancel,
        );

        verifyNever(() => mockWindowManager.minimize());
      },
    );

    test(
      'a window transition the app never asked for revokes ownership, so the '
      'user keeps the window they took over',
      () {
        fakeAsync((async) {
          final service = buildService();
          service.onRequestDelivered(1);
          async.flushMicrotasks();
          service.onWindowRestore();
          async.flushMicrotasks();

          // Long after the raise, so this transition cannot be attributed to
          // any command the app issued: the user reopened the window.
          async.elapse(kWindowTransitionGrace * 2);
          service.onWindowRestore();

          service.onRequestResolved(
            1,
            NotificationRemovalReason.acceptedByUser,
          );
          async.flushMicrotasks();

          verifyNever(() => mockWindowManager.minimize());
        });
      },
    );

    test(
      'the app\'s own raise reporting its transition twice does not revoke the '
      'ownership it just established',
      () async {
        final service = buildService();
        final delivered = service.onRequestDelivered(1);
        await pumpEventQueue();
        service.onWindowRestore();
        service.onWindowRestore();
        service.onWindowFocus();
        await delivered;

        await service.onRequestResolved(
          1,
          NotificationRemovalReason.acceptedByUser,
        );

        verify(() => mockWindowManager.minimize()).called(1);
      },
    );

    test('a focus transition alone settles the raise', () async {
      final service = buildService();
      final delivered = service.onRequestDelivered(1);
      await pumpEventQueue();
      service.onWindowFocus();
      await delivered;

      await service.onRequestResolved(
        1,
        NotificationRemovalReason.acceptedByUser,
      );

      verify(() => mockWindowManager.minimize()).called(1);
    });

    test(
      'two overlapping requests form one episode: the window stays up until '
      'both are resolved, then minimizes once',
      () async {
        final service = buildService();
        await deliverAndSettle(service, 1);
        await service.onRequestDelivered(2);

        await service.onRequestResolved(
          1,
          NotificationRemovalReason.acceptedByUser,
        );
        verifyNever(() => mockWindowManager.minimize());

        await service.onRequestResolved(
          2,
          NotificationRemovalReason.acceptedByUser,
        );
        verify(() => mockWindowManager.minimize()).called(1);
      },
    );

    test(
      'a raise whose postconditions never settle times out instead of leaving '
      'the episode pending forever',
      () {
        fakeAsync((async) {
          final service = buildService();
          var delivered = false;
          service.onRequestDelivered(1).then((_) => delivered = true);
          async.flushMicrotasks();

          // The window manager refuses activation: no transition is ever
          // reported.
          expect(delivered, isFalse);
          async.elapse(kOwnershipSettleTimeout);
          async.flushMicrotasks();

          expect(delivered, isTrue);

          service.onRequestResolved(
            1,
            NotificationRemovalReason.acceptedByUser,
          );
          async.flushMicrotasks();

          verifyNever(() => mockWindowManager.minimize());
        });
      },
    );

    test('resolving an id the episode never held changes nothing', () async {
      final service = buildService();
      await deliverAndSettle(service, 1);

      await service.onRequestResolved(
        99,
        NotificationRemovalReason.acceptedByUser,
      );
      verifyNever(() => mockWindowManager.minimize());

      await service.onRequestResolved(
        1,
        NotificationRemovalReason.acceptedByUser,
      );
      verify(() => mockWindowManager.minimize()).called(1);
    });

    test(
      'resolving the same id twice minimizes once — one notification id can '
      'back both a connect and a sign entry',
      () async {
        final service = buildService();
        await deliverAndSettle(service, 1);

        await service.onRequestResolved(
          1,
          NotificationRemovalReason.acceptedByUser,
        );
        await service.onRequestResolved(
          1,
          NotificationRemovalReason.acceptedByUser,
        );

        verify(() => mockWindowManager.minimize()).called(1);
      },
    );

    test(
      'a resolution arriving while the raise is still in flight runs after it, '
      'so ownership is established before it is read',
      () async {
        final service = buildService();
        final delivered = service.onRequestDelivered(1);
        final resolved = service.onRequestResolved(
          1,
          NotificationRemovalReason.acceptedByUser,
        );
        await pumpEventQueue();
        service.onWindowRestore();
        await Future.wait([delivered, resolved]);

        verify(() => mockWindowManager.minimize()).called(1);
      },
    );

    test('disposing the service stops listening for window transitions', () async {
      final service = buildService();
      await deliverAndSettle(service, 1);

      service.dispose();

      verify(() => mockWindowManager.removeListener(service)).called(1);
    });

    test(
      'a request delivered while the window was open is still unresolved when '
      'a later request opens an episode, and holds the minimize back',
      () async {
        when(
          () => mockWindowManager.isMinimized(),
        ).thenAnswer((_) async => false);
        when(() => mockWindowManager.isVisible()).thenAnswer((_) async => true);
        when(() => mockWindowManager.isFocused()).thenAnswer((_) async => true);
        final service = buildService();
        await service.onRequestDelivered(1);

        // The user minimizes the window themselves, then a second request
        // arrives while the first is still pending.
        when(
          () => mockWindowManager.isMinimized(),
        ).thenAnswer((_) async => true);
        await deliverAndSettle(service, 2);

        await service.onRequestResolved(
          2,
          NotificationRemovalReason.acceptedByUser,
        );
        verifyNever(() => mockWindowManager.minimize());

        await service.onRequestResolved(
          1,
          NotificationRemovalReason.acceptedByUser,
        );
        verify(() => mockWindowManager.minimize()).called(1);
      },
    );

    test(
      'disposing before a queued delivery runs leaves no listener behind',
      () async {
        final service = buildService();

        // Not awaited and not flushed: the delivery is still only queued.
        final delivered = service.onRequestDelivered(1);
        service.dispose();
        await delivered;

        verifyNever(() => mockWindowManager.addListener(any()));
        verifyNever(() => mockWindowManager.restore());
      },
    );

    test(
      'abandoning the episode stops listening and leaves the window alone',
      () async {
        final service = buildService();
        await deliverAndSettle(service, 1);

        await service.abandonEpisode();

        verify(() => mockWindowManager.removeListener(service)).called(1);
        verifyNever(() => mockWindowManager.minimize());
      },
    );

    test(
      'a request delivered after the episode was abandoned opens a new one',
      () async {
        final service = buildService();
        await deliverAndSettle(service, 1);
        await service.abandonEpisode();

        await deliverAndSettle(service, 2);
        await service.onRequestResolved(
          2,
          NotificationRemovalReason.acceptedByUser,
        );

        verify(() => mockWindowManager.minimize()).called(1);
      },
    );

    test('a raise the window manager refuses closes the episode', () async {
      when(
        () => mockWindowManager.restore(),
      ).thenThrow(Exception('window manager refused activation'));
      final service = buildService();

      await expectLater(service.onRequestDelivered(1), throwsException);

      verify(() => mockWindowManager.removeListener(service)).called(1);
      // The next request is free to open an episode of its own — and the
      // request whose raise was refused is still pending, so it joins it.
      when(() => mockWindowManager.restore()).thenAnswer((_) async {});
      await deliverAndSettle(service, 2);
      await service.onRequestResolved(
        2,
        NotificationRemovalReason.acceptedByUser,
      );
      verifyNever(() => mockWindowManager.minimize());

      await service.onRequestResolved(
        1,
        NotificationRemovalReason.acceptedByUser,
      );
      verify(() => mockWindowManager.minimize()).called(1);
    });

    test(
      'disposing the service while a raise is still settling abandons it',
      () {
        fakeAsync((async) {
          final service = buildService();
          service.onRequestDelivered(1);
          async.flushMicrotasks();

          service.dispose();
          service.onWindowRestore();
          async.flushMicrotasks();

          service.onRequestResolved(
            1,
            NotificationRemovalReason.acceptedByUser,
          );
          async.flushMicrotasks();

          verifyNever(() => mockWindowManager.minimize());
          // No timer outlives the service.
          expect(async.pendingTimers, isEmpty);
        });
      },
    );

    group('default capabilities', () {
      // The production default is a platform read, so each value is asserted
      // on the platform that produces it (docs/TESTING.md: platform-gated
      // branches are covered, not exempted).
      DesktopWindowService buildDefaultService() {
        when(
          () => mockWindowManager.setAlwaysOnTop(any()),
        ).thenAnswer((_) async {});
        return DesktopWindowService(
          windowManager: mockWindowManager,
          attentionService: mockAttentionService,
            );
      }

      test('ask the OS for critical attention on macOS', () async {
        final service = buildDefaultService();

        await deliverAndSettle(service, 1);

        verify(() => mockAttentionService.requestCriticalAttention()).called(1);
      }, testOn: 'mac-os');

      test('issue no attention call off macOS', () async {
        final service = buildDefaultService();

        await deliverAndSettle(service, 1);

        verifyZeroInteractions(mockAttentionService);
      }, testOn: '!mac-os');

      test('put the pending count on the app icon on macOS', () async {
        when(
          () => mockAttentionService.setPendingBadge(any()),
        ).thenAnswer((_) async {});
        final service = buildDefaultService();

        await service.setPendingBadge(2);

        verify(() => mockAttentionService.setPendingBadge(2)).called(1);
      }, testOn: 'mac-os');

      test('write no badge off macOS', () async {
        final service = buildDefaultService();

        await service.setPendingBadge(2);

        verifyNever(() => mockAttentionService.setPendingBadge(any()));
      }, testOn: '!mac-os');

      // The pair below asserts from a visible-but-inactive window rather than
      // from the group's minimized default, which both arms raise from and
      // which would therefore pass whatever the platform read returns.
      test('leave a visible but inactive window alone on macOS', () async {
        stubVisibleButInactiveWindow();
        final service = buildDefaultService();

        await service.onRequestDelivered(1);

        verifyNever(() => mockWindowManager.restore());
        verifyNever(() => mockWindowManager.show());
        verifyNever(() => mockWindowManager.focus());
      }, testOn: 'mac-os');

      test('raise a visible but inactive window off macOS', () async {
        stubVisibleButInactiveWindow();
        final service = buildDefaultService();

        await deliverAndSettle(service, 1);

        verify(() => mockWindowManager.addListener(service)).called(1);
      }, testOn: '!mac-os');

      test('ask the platform where the window is on macOS', () async {
        final service = buildDefaultService();

        await deliverAndSettle(service, 1);

        verify(() => mockAttentionService.readWindowPlacement()).called(1);
      }, testOn: 'mac-os');

      test('never ask where the window is off macOS', () async {
        final service = buildDefaultService();

        await deliverAndSettle(service, 1);

        verifyNever(() => mockAttentionService.readWindowPlacement());
      }, testOn: '!mac-os');
    });

    group('raising only from a minimized window', () {
      test('a request delivered to a minimized window raises it', () async {
        final service = buildService(raisesOnlyFromMinimizedWindow: true);

        await deliverAndSettle(service, 1);

        verifyInOrder([
          () => mockWindowManager.restore(),
          () => mockWindowManager.show(),
          () => mockWindowManager.focus(),
        ]);
        verify(() => mockWindowManager.addListener(service)).called(1);
      });

      test(
        'accepting a request the app raised from a minimized window still '
        'minimizes it back',
        () async {
          final service = buildService(raisesOnlyFromMinimizedWindow: true);
          await deliverAndSettle(service, 1);

          await service.onRequestResolved(
            1,
            NotificationRemovalReason.acceptedByUser,
          );

          verify(() => mockWindowManager.minimize()).called(1);
        },
      );

      test(
        'a request the app raised from a minimized window and then left to '
        'expire never minimizes it back',
        () async {
          final service = buildService(raisesOnlyFromMinimizedWindow: true);
          await deliverAndSettle(service, 1);

          await service.onRequestResolved(1, NotificationRemovalReason.expired);

          verifyNever(() => mockWindowManager.minimize());
        },
      );

      test(
        'a second request joining an open episode raises again whatever the '
        'window is doing by then, and the episode still minimizes back once',
        () async {
          final service = buildService(raisesOnlyFromMinimizedWindow: true);
          await deliverAndSettle(service, 1);

          // The raise worked, so by the time the second request arrives the
          // window is up. The disposition is not sampled again: joining an
          // open episode is post-raise behaviour, which this slice leaves
          // exactly as it shipped.
          stubVisibleButInactiveWindow();
          await deliverAndSettle(service, 2);

          verify(() => mockWindowManager.restore()).called(2);

          await service.onRequestResolved(
            1,
            NotificationRemovalReason.acceptedByUser,
          );
          verifyNever(() => mockWindowManager.minimize());

          await service.onRequestResolved(
            2,
            NotificationRemovalReason.acceptedByUser,
          );
          verify(() => mockWindowManager.minimize()).called(1);
        },
      );
    });

    group('gating the raise on the native window placement', () {
      test(
        'a minimized window on the active Space of an app that is not hidden '
        'is the one the app raises',
        () async {
          stubPlacement();
          final service = buildMacOsService();

          await deliverAndSettle(service, 1);

          verifyInOrder([
            () => mockAttentionService.requestCriticalAttention(),
            () => mockWindowManager.restore(),
            () => mockWindowManager.show(),
            () => mockWindowManager.focus(),
          ]);
        },
      );

      test(
        'a minimized window is decided without asking whether it is visible: '
        'a hop that cannot change the answer is one more way the raise can be '
        'lost',
        () async {
          stubPlacement();
          final service = buildMacOsService();

          await deliverAndSettle(service, 1);

          verifyNever(() => mockWindowManager.isVisible());
          verifyNever(() => mockWindowManager.isFocused());
        },
      );

      test(
        'a minimized window on another Space is left there: deminiaturizing it '
        'would pull the user off what they are in',
        () async {
          stubPlacement(isOnActiveSpace: false);
          final service = buildMacOsService();

          await service.onRequestDelivered(1);

          verify(() => mockAttentionService.requestCriticalAttention()).called(1);
          verifyNever(() => mockWindowManager.restore());
        },
      );

      test(
        'a minimized window of a hidden app is left alone: a raise would '
        'un-hide the app and minimize would not put that back',
        () async {
          stubPlacement(isHidden: true);
          final service = buildMacOsService();

          await service.onRequestDelivered(1);

          verify(() => mockAttentionService.requestCriticalAttention()).called(1);
          verifyNever(() => mockWindowManager.restore());
        },
      );

      test('a hidden app whose window is not minimized is left alone', () async {
        stubVisibleButInactiveWindow();
        stubPlacement(isHidden: true);
        final service = buildMacOsService();

        await service.onRequestDelivered(1);

        verify(() => mockAttentionService.requestCriticalAttention()).called(1);
        verifyNever(() => mockWindowManager.restore());
      });

      test(
        'a window the user can see but is not typing into is left alone even '
        'on the active Space of an app that is not hidden',
        () async {
          stubVisibleButInactiveWindow();
          stubPlacement();
          final service = buildMacOsService();

          await service.onRequestDelivered(1);

          verifyNever(() => mockWindowManager.restore());
        },
      );

      test('the window the user is already typing into is left alone', () async {
        stubActiveWindow();
        stubPlacement();
        final service = buildMacOsService();

        await service.onRequestDelivered(1);

        verifyNever(() => mockWindowManager.restore());
      });

      // Every way the query can fail to answer resolves to the same fallback,
      // under which the app raises: a missing raise next to a missing badge
      // would leave the user with no signal at all (ADR-0005 decision 1).
      test('a platform that refuses the query still raises', () async {
        when(
          () => mockAttentionService.readWindowPlacement(),
        ).thenThrow(PlatformException(code: 'no_window'));
        final service = buildMacOsService();

        await deliverAndSettle(service, 1);

        verify(() => mockWindowManager.restore()).called(1);
      });

      test('a build with no handler for the query still raises', () async {
        when(
          () => mockAttentionService.readWindowPlacement(),
        ).thenThrow(MissingPluginException('no handler'));
        final service = buildMacOsService();

        await deliverAndSettle(service, 1);

        verify(() => mockWindowManager.restore()).called(1);
      });

      test('a reply the app cannot read still raises', () async {
        // The seam has already turned a null, a non-map and a wrong-typed
        // reply into this one answer; the app cannot tell them apart, by
        // design.
        when(
          () => mockAttentionService.readWindowPlacement(),
        ).thenAnswer((_) async => null);
        final service = buildMacOsService();

        await deliverAndSettle(service, 1);

        verify(() => mockWindowManager.restore()).called(1);
      });

      test('a query that never answers still raises, once the bound passes', () {
        fakeAsync((async) {
          when(
            () => mockAttentionService.readWindowPlacement(),
          ).thenAnswer((_) => Completer<WindowPlacement>().future);
          final service = buildMacOsService();

          service.onRequestDelivered(1);
          async.flushMicrotasks();

          verifyNever(() => mockWindowManager.restore());

          async.elapse(kWindowPlacementQueryTimeout);
          async.flushMicrotasks();

          verify(() => mockWindowManager.restore()).called(1);
        });
      });

      test(
        'a query that never answers does not wedge the chain: later '
        'deliveries and resolutions still run',
        () {
          fakeAsync((async) {
            when(
              () => mockAttentionService.readWindowPlacement(),
            ).thenAnswer((_) => Completer<WindowPlacement>().future);
            final service = buildMacOsService();

            service.onRequestDelivered(1);
            async.elapse(kWindowPlacementQueryTimeout);
            async.flushMicrotasks();
            // The raise settles, so the episode owns the window.
            service.onWindowRestore();
            async.flushMicrotasks();

            var deliveredLater = false;
            service.onRequestDelivered(2).then((_) => deliveredLater = true);
            async.elapse(kWindowPlacementQueryTimeout);
            async.flushMicrotasks();
            expect(deliveredLater, isTrue);

            service.onRequestResolved(
              1,
              NotificationRemovalReason.acceptedByUser,
            );
            service.onRequestResolved(
              2,
              NotificationRemovalReason.acceptedByUser,
            );
            async.flushMicrotasks();

            verify(() => mockWindowManager.minimize()).called(1);
          });
        },
      );

      test(
        'disposing the service while the query is in flight leaves the window '
        'alone',
        () async {
          final answered = Completer<WindowPlacement>();
          when(
            () => mockAttentionService.readWindowPlacement(),
          ).thenAnswer((_) => answered.future);
          final service = buildMacOsService();

          final delivered = service.onRequestDelivered(1);
          await pumpEventQueue();
          service.dispose();
          answered.complete(WindowPlacement.fallback);
          await delivered;

          // The bounce issued at the delivery boundary registered the listener
          // before the query; what disposal must prevent is the episode and the
          // raise below it, which nobody would be left to take back down.
          verifyNever(() => mockWindowManager.restore());
        },
      );

      test(
        'a second request joining an open episode does not query again: '
        'joining is post-raise behaviour',
        () async {
          stubPlacement();
          final service = buildMacOsService();
          await deliverAndSettle(service, 1);

          await deliverAndSettle(service, 2);

          verify(() => mockAttentionService.readWindowPlacement()).called(1);
        },
      );

      test(
        'a platform without the capability never reaches the query, so Windows '
        'and Linux keep the behaviour they ship',
        () async {
          final service = buildService();

          await deliverAndSettle(service, 1);
          await service.onRequestResolved(
            1,
            NotificationRemovalReason.acceptedByUser,
          );

          verifyNever(() => mockAttentionService.readWindowPlacement());
          verify(() => mockWindowManager.minimize()).called(1);
        },
      );
    });

    group('window disposition', () {
      // Two dispositions that used to open an episode no longer do where the
      // app raises only from a minimized window. These assert the reversal;
      // the arm that keeps raising from them is the regression baseline
      // below (ADR-0005 decision 5).
      //
      // Neither loses its signal: the bounce is issued at the delivery
      // boundary, so it survives the app declining to touch the window.
      //
      // The rows the *native* placement decides — off the active Space, and
      // hidden — are asserted against the query that answers them, in the
      // group above; they are not something these three window-manager
      // predicates can express.
      test('an unfocused window is left alone but still bounces', () async {
        stubVisibleButInactiveWindow();
        final service = buildService(raisesOnlyFromMinimizedWindow: true);

        await service.onRequestDelivered(1);

        verify(() => mockAttentionService.requestCriticalAttention()).called(1);
        verifyNever(() => mockWindowManager.restore());
        verifyNever(() => mockWindowManager.show());
        verifyNever(() => mockWindowManager.focus());
      });

      // The baselines below assert the whole episode-opening sequence, not
      // just that one opened: what they defend is that Windows and Linux keep
      // the behaviour they ship, and a raise that lost a step or gained one
      // would still register a listener.
      test(
        'a window that is off the screen without being minimized is still not '
        'available to the user where the app raises from any disposition',
        () async {
          stubOffScreenButNotMinimizedWindow();
          final service = buildService(raisesOnlyFromMinimizedWindow: false);

          await deliverAndSettle(service, 1);

          // Nothing was asked of the platform: without the capability the app
          // assumes the fallback placement, so this arm reaches the same
          // decision from the same three predicates it always did.
          verifyNever(() => mockAttentionService.readWindowPlacement());
          verifyInOrder([
            () => mockAttentionService.requestCriticalAttention(),
            () => mockWindowManager.restore(),
            () => mockWindowManager.show(),
            () => mockWindowManager.focus(),
          ]);
          verify(() => mockWindowManager.addListener(service)).called(1);
          verifyNever(() => mockWindowManager.setAlwaysOnTop(any()));
        },
      );

      test(
        'an unfocused window is still not available to the user where the app '
        'raises from any disposition',
        () async {
          stubVisibleButInactiveWindow();
          final service = buildService(raisesOnlyFromMinimizedWindow: false);

          await deliverAndSettle(service, 1);

          verifyInOrder([
            () => mockAttentionService.requestCriticalAttention(),
            () => mockWindowManager.restore(),
            () => mockWindowManager.show(),
            () => mockWindowManager.focus(),
          ]);
          verify(() => mockWindowManager.addListener(service)).called(1);
          verifyNever(() => mockWindowManager.setAlwaysOnTop(any()));
        },
      );

      test(
        'a minimized window is decided from that alone where the app raises '
        'from any disposition too, exactly as it shipped',
        () async {
          final service = buildService(raisesOnlyFromMinimizedWindow: false);

          await deliverAndSettle(service, 1);

          verifyNever(() => mockWindowManager.isVisible());
          verifyNever(() => mockWindowManager.isFocused());
        },
      );

      test(
        'a window the user cannot see is never asked about focus: it is not '
        'the one they are typing into whatever the platform would answer',
        () async {
          stubOffScreenButNotMinimizedWindow();
          final service = buildService(raisesOnlyFromMinimizedWindow: false);

          await deliverAndSettle(service, 1);

          verifyNever(() => mockWindowManager.isFocused());
          verify(() => mockWindowManager.restore()).called(1);
        },
      );

      test(
        'a window the user could already see is never minimized on resolve, '
        'only one the app took off the screen is put back',
        () async {
          stubVisibleButInactiveWindow();
          final service = buildService();
          await deliverAndSettle(service, 1);

          await service.onRequestResolved(
            1,
            NotificationRemovalReason.acceptedByUser,
          );

          verifyNever(() => mockWindowManager.minimize());
        },
      );
    });
  });
}
