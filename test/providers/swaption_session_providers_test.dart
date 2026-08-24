import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/swaption_session_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart' show Session;
import 'package:sideswap_logger/custom_logger.dart';

import '../utils.dart';

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // Suppress all logging to prevent async errors from path_provider
  }
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Suppress logging to prevent async errors from path_provider
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
  });

  group('SwaptionSession', () {
    group('fromJson', () {
      test('deserializes valid JSON to SwaptionSession', () {
        final json = {
          'sessionId': 'session-1',
          'domain': 'example.com',
          'isLocal': false,
        };

        final session = SwaptionSession.fromJson(json);

        expect(session.sessionId, 'session-1');
        expect(session.domain, 'example.com');
        expect(session.isLocal, false);
      });

      test('deserializes JSON with isLocal true', () {
        final json = {
          'sessionId': 'local-session',
          'domain': 'localhost',
          'isLocal': true,
        };

        final session = SwaptionSession.fromJson(json);

        expect(session.sessionId, 'local-session');
        expect(session.domain, 'localhost');
        expect(session.isLocal, true);
      });

      test('preserves all fields during deserialization', () {
        final json = {
          'sessionId': 'test-123',
          'domain': 'test.domain.com',
          'isLocal': false,
        };

        final session = SwaptionSession.fromJson(json);

        expect(session.sessionId, json['sessionId']);
        expect(session.domain, json['domain']);
        expect(session.isLocal, json['isLocal']);
      });
    });
  });

  group('SwaptionSessionNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('build', () {
      test('initializes with empty list', () {
        final state = container.read(swaptionSessionProvider);
        expect(state, isEmpty);
      });
    });

    group('addSession', () {
      test('adds new session to empty list', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session = Session(
          sessionId: 'session-1',
          domain: 'example.com',
          isLocal: false,
        );

        notifier.addSession(session);

        final state = container.read(swaptionSessionProvider);
        expect(state, hasLength(1));
        expect(state[0].sessionId, 'session-1');
        expect(state[0].domain, 'example.com');
        expect(state[0].isLocal, false);
      });

      test('adds multiple sessions sequentially', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session1 = Session(
          sessionId: 'session-1',
          domain: 'example1.com',
          isLocal: false,
        );
        final session2 = Session(
          sessionId: 'session-2',
          domain: 'example2.com',
          isLocal: true,
        );

        notifier.addSession(session1);
        notifier.addSession(session2);

        final state = container.read(swaptionSessionProvider);
        expect(state, hasLength(2));
        expect(state[0].sessionId, 'session-1');
        expect(state[1].sessionId, 'session-2');
      });

      test('does not add duplicate session with same sessionId', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session = Session(
          sessionId: 'session-1',
          domain: 'example.com',
          isLocal: false,
        );

        notifier.addSession(session);
        notifier.addSession(session);

        final state = container.read(swaptionSessionProvider);
        expect(state, hasLength(1));
      });

      test('triggers listener on successful add', () {
        final listener = ProviderListener<List<SwaptionSession>>();
        container.listen(swaptionSessionProvider, listener.call, fireImmediately: true);

        final notifier = container.read(swaptionSessionProvider.notifier);
        final session = Session(
          sessionId: 'session-1',
          domain: 'example.com',
          isLocal: false,
        );

        notifier.addSession(session);

        verifyInOrder([
          () => listener(null, any()),
          () => listener(any(), any()),
        ]);
      });

      test('does not trigger listener when adding duplicate', () {
        final listener = ProviderListener<List<SwaptionSession>>();
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session = Session(
          sessionId: 'session-1',
          domain: 'example.com',
          isLocal: false,
        );

        notifier.addSession(session);

        container.listen(swaptionSessionProvider, listener.call);

        notifier.addSession(session);

        verifyNoMoreInteractions(listener);
      });
    });

    group('removeSessions', () {
      test('removes existing session from list', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session = Session(
          sessionId: 'session-1',
          domain: 'example.com',
          isLocal: false,
        );

        notifier.addSession(session);
        expect(container.read(swaptionSessionProvider), hasLength(1));

        notifier.removeSessions('session-1');

        final state = container.read(swaptionSessionProvider);
        expect(state, isEmpty);
      });

      test('removes correct session when multiple sessions exist', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session1 = Session(
          sessionId: 'session-1',
          domain: 'example1.com',
          isLocal: false,
        );
        final session2 = Session(
          sessionId: 'session-2',
          domain: 'example2.com',
          isLocal: true,
        );
        final session3 = Session(
          sessionId: 'session-3',
          domain: 'example3.com',
          isLocal: false,
        );

        notifier.addSession(session1);
        notifier.addSession(session2);
        notifier.addSession(session3);

        notifier.removeSessions('session-2');

        final state = container.read(swaptionSessionProvider);
        expect(state, hasLength(2));
        expect(state[0].sessionId, 'session-1');
        expect(state[1].sessionId, 'session-3');
      });

      test('does nothing when removing non-existent session', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session = Session(
          sessionId: 'session-1',
          domain: 'example.com',
          isLocal: false,
        );

        notifier.addSession(session);
        notifier.removeSessions('session-999');

        final state = container.read(swaptionSessionProvider);
        expect(state, hasLength(1));
        expect(state[0].sessionId, 'session-1');
      });

      test('does nothing when list is empty', () {
        final notifier = container.read(swaptionSessionProvider.notifier);

        notifier.removeSessions('session-1');

        final state = container.read(swaptionSessionProvider);
        expect(state, isEmpty);
      });

      test('triggers listener on successful remove', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session = Session(
          sessionId: 'session-1',
          domain: 'example.com',
          isLocal: false,
        );

        notifier.addSession(session);

        final listener = ProviderListener<List<SwaptionSession>>();
        container.listen(swaptionSessionProvider, listener.call);

        notifier.removeSessions('session-1');

        verifyInOrder([
          () => listener(any(), any()),
        ]);
      });
    });

    group('replaceSessions', () {
      test('replaces empty list with new sessions', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final sessions = [
          Session(
            sessionId: 'session-1',
            domain: 'example1.com',
            isLocal: false,
          ),
          Session(
            sessionId: 'session-2',
            domain: 'example2.com',
            isLocal: true,
          ),
        ];

        notifier.replaceSessions(sessions);

        final state = container.read(swaptionSessionProvider);
        expect(state, hasLength(2));
        expect(state[0].sessionId, 'session-1');
        expect(state[1].sessionId, 'session-2');
      });

      test('replaces existing sessions with new list', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final oldSession = Session(
          sessionId: 'old-1',
          domain: 'old.com',
          isLocal: false,
        );
        final newSessions = [
          Session(
            sessionId: 'new-1',
            domain: 'new1.com',
            isLocal: true,
          ),
          Session(
            sessionId: 'new-2',
            domain: 'new2.com',
            isLocal: false,
          ),
        ];

        notifier.addSession(oldSession);
        expect(container.read(swaptionSessionProvider), hasLength(1));

        notifier.replaceSessions(newSessions);

        final state = container.read(swaptionSessionProvider);
        expect(state, hasLength(2));
        expect(state[0].sessionId, 'new-1');
        expect(state[1].sessionId, 'new-2');
        expect(
          state.every((s) => s.sessionId != 'old-1'),
          true,
        );
      });

      test('replaces with empty list', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session = Session(
          sessionId: 'session-1',
          domain: 'example.com',
          isLocal: false,
        );

        notifier.addSession(session);
        expect(container.read(swaptionSessionProvider), hasLength(1));

        notifier.replaceSessions([]);

        final state = container.read(swaptionSessionProvider);
        expect(state, isEmpty);
      });

      test('triggers listener on successful replace', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final sessions = [
          Session(
            sessionId: 'session-1',
            domain: 'example.com',
            isLocal: false,
          ),
        ];

        final listener = ProviderListener<List<SwaptionSession>>();
        container.listen(swaptionSessionProvider, listener.call);

        notifier.replaceSessions(sessions);

        verifyInOrder([
          () => listener(any(), any()),
        ]);
      });

      test('preserves domain and isLocal flags from proto session', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final sessions = [
          Session(
            sessionId: 'session-1',
            domain: 'local.example',
            isLocal: true,
          ),
          Session(
            sessionId: 'session-2',
            domain: 'remote.example',
            isLocal: false,
          ),
        ];

        notifier.replaceSessions(sessions);

        final state = container.read(swaptionSessionProvider);
        expect(state[0].domain, 'local.example');
        expect(state[0].isLocal, true);
        expect(state[1].domain, 'remote.example');
        expect(state[1].isLocal, false);
      });
    });

    group('state immutability', () {
      test('addSession creates new list instance', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session = Session(
          sessionId: 'session-1',
          domain: 'example.com',
          isLocal: false,
        );

        final stateBefore = container.read(swaptionSessionProvider);
        notifier.addSession(session);
        final stateAfter = container.read(swaptionSessionProvider);

        expect(identical(stateBefore, stateAfter), false);
      });

      test('removeSessions creates new list instance', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session = Session(
          sessionId: 'session-1',
          domain: 'example.com',
          isLocal: false,
        );

        notifier.addSession(session);
        final stateBefore = container.read(swaptionSessionProvider);

        notifier.removeSessions('session-1');
        final stateAfter = container.read(swaptionSessionProvider);

        expect(identical(stateBefore, stateAfter), false);
      });

      test('replaceSessions creates new list instance', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final stateBefore = container.read(swaptionSessionProvider);

        final sessions = [
          Session(
            sessionId: 'session-1',
            domain: 'example.com',
            isLocal: false,
          ),
        ];
        notifier.replaceSessions(sessions);

        final stateAfter = container.read(swaptionSessionProvider);
        expect(identical(stateBefore, stateAfter), false);
      });
    });

    group('combined operations', () {
      test('add, remove, add sequence works correctly', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session1 = Session(
          sessionId: 'session-1',
          domain: 'example1.com',
          isLocal: false,
        );
        final session2 = Session(
          sessionId: 'session-2',
          domain: 'example2.com',
          isLocal: true,
        );

        notifier.addSession(session1);
        expect(container.read(swaptionSessionProvider), hasLength(1));

        notifier.removeSessions('session-1');
        expect(container.read(swaptionSessionProvider), isEmpty);

        notifier.addSession(session2);
        final state = container.read(swaptionSessionProvider);
        expect(state, hasLength(1));
        expect(state[0].sessionId, 'session-2');
      });

      test('replace clears previous state from add operations', () {
        final notifier = container.read(swaptionSessionProvider.notifier);
        final session1 = Session(
          sessionId: 'session-1',
          domain: 'example1.com',
          isLocal: false,
        );
        final session2 = Session(
          sessionId: 'session-2',
          domain: 'example2.com',
          isLocal: true,
        );

        notifier.addSession(session1);
        expect(container.read(swaptionSessionProvider), hasLength(1));

        final newSessions = [session2];
        notifier.replaceSessions(newSessions);

        final state = container.read(swaptionSessionProvider);
        expect(state, hasLength(1));
        expect(state[0].sessionId, 'session-2');
      });
    });
  });
}
