import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/logging_shared_preferences.dart';
import 'package:sideswap_logger/custom_logger.dart';

import '../helpers/fake_shared_preferences.dart';
import '../helpers/test_utils.dart';

void main() {
  final capturedLog = CapturingLogOutput();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    logger = CustomLogger('SideSwap', output: capturedLog);
  });

  late FakeSharedPreferences store;
  late LoggingSharedPreferences prefs;

  setUp(() {
    capturedLog.lines.clear();
    store = FakeSharedPreferences();
    prefs = LoggingSharedPreferences(store);
  });

  /// The captured lines that name [key].
  Iterable<String> linesNaming(String key) =>
      capturedLog.lines.where((line) => line.contains(key));

  group('reads delegate to the wrapped store', () {
    test('every getter reads through to the store', () async {
      await store.setBool('b', true);
      await store.setInt('i', 7);
      await store.setDouble('d', 1.5);
      await store.setString('s', 'text');
      await store.setStringList('l', ['one', 'two']);

      expect(prefs.getBool('b'), true);
      expect(prefs.getInt('i'), 7);
      expect(prefs.getDouble('d'), 1.5);
      expect(prefs.getString('s'), 'text');
      expect(prefs.getStringList('l'), ['one', 'two']);
      expect(prefs.get('s'), 'text');
    });

    test('getKeys and containsKey', () async {
      await store.setString('s', 'text');

      expect(prefs.getKeys(), {'s'});
      expect(prefs.containsKey('s'), true);
      expect(prefs.containsKey('absent'), false);
    });
  });

  group('a write the store accepts', () {
    test('every setter lands on the disk', () async {
      expect(await prefs.setBool('b', true), true);
      expect(await prefs.setInt('i', 7), true);
      expect(await prefs.setDouble('d', 1.5), true);
      expect(await prefs.setString('s', 'text'), true);
      expect(await prefs.setStringList('l', ['one']), true);

      expect(store.snapshot, {
        'b': true,
        'i': 7,
        'd': 1.5,
        's': 'text',
        'l': ['one'],
      });
      expect(capturedLog.lines, isEmpty);
    });

    test('remove takes the key off the disk', () async {
      await prefs.setString('s', 'text');

      expect(await prefs.remove('s'), true);

      expect(store.snapshot.containsKey('s'), false);
      expect(capturedLog.lines, isEmpty);
    });

    test('clear and reload delegate', () async {
      await prefs.setString('s', 'text');

      expect(await prefs.clear(), true);
      expect(store.snapshot, isEmpty);

      await prefs.reload();
      expect(prefs.getString('s'), isNull);
    });

    test('commit delegates', () async {
      // ignore: deprecated_member_use
      expect(await prefs.commit(), true);
    });
  });

  group('a refused write', () {
    test('raises, and names the key in one log line', () async {
      store.failOn('refused_key');

      await expectLater(
        prefs.setString('refused_key', 'text'),
        throwsA(isA<RefusedSettingsWrite>()),
      );

      expect(linesNaming('refused_key').length, 1);
    });

    test('reloads the cache from the disk before it raises', () async {
      await prefs.setString('s', 'old');
      store.failOn('s');

      await expectLater(
        prefs.setString('s', 'new'),
        throwsA(isA<RefusedSettingsWrite>()),
      );

      expect(
        prefs.getString('s'),
        'old',
        reason: 'the cache must hold what the disk holds',
      );
    });

    test('raises from every write method', () async {
      for (final write in <Future<bool> Function(String)>[
        (key) => prefs.setBool(key, true),
        (key) => prefs.setInt(key, 7),
        (key) => prefs.setDouble(key, 1.5),
        (key) => prefs.setString(key, 'text'),
        (key) => prefs.setStringList(key, const ['one']),
        prefs.remove,
      ]) {
        const key = 'refused';
        store.failOn(key);
        await expectLater(write(key), throwsA(isA<RefusedSettingsWrite>()));
      }
    });

    test('the error names the key', () {
      expect(RefusedSettingsWrite('the_key').toString(), contains('the_key'));
    });
  });

  group('a re-read that fails too', () {
    test('does not replace the refusal', () async {
      store.failOn('refused_key');
      store.failReloadOnce();

      await expectLater(
        prefs.setString('refused_key', 'text'),
        throwsA(isA<RefusedSettingsWrite>()),
      );

      expect(linesNaming('refused_key').length, 2, reason: 'both are logged');
    });

    test('does not replace a thrown store error', () async {
      store.throwOn('refused_key');
      store.failReloadOnce();

      await expectLater(
        prefs.setString('refused_key', 'text'),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('a throwing write', () {
    test('rethrows, and names the key in one log line', () async {
      store.throwOn('refused_key');

      await expectLater(
        prefs.setString('refused_key', 'text'),
        throwsA(isA<StateError>()),
      );

      expect(linesNaming('refused_key').length, 1);
    });

    test('reloads the cache from the disk before it rethrows', () async {
      await prefs.setString('s', 'old');
      store.throwOn('s');

      await expectLater(
        prefs.setString('s', 'new'),
        throwsA(isA<StateError>()),
      );

      expect(prefs.getString('s'), 'old');
    });
  });
}
