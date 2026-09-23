import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A store-backed [SharedPreferences] that a test can read back, count writes
/// on, stall part-way through a write round, and refuse a chosen key on.
///
/// A `mocktail` mock cannot do any of those: its writes go nowhere and its
/// reads are stubbed constants, so rebuilding a provider over it returns the
/// seed rather than what the provider persisted.
///
/// The cache and the disk are two maps, as they are in the real facade. The
/// facade sets `_preferenceCache[key]` and *then* asks the platform
/// (`shared_preferences_legacy.dart:171-190`), so a refused write leaves the
/// new value in the cache and the old value on the disk. [snapshot] reads the
/// disk; every `get*` reads the cache; [reload] copies the disk over the
/// cache. A fake with one map would prove a repair the real facade does not
/// deliver.
///
/// Build a fresh instance in `setUp` so a failed expectation cannot leave one
/// dirty for the next test.
class FakeSharedPreferences extends Fake implements SharedPreferences {
  FakeSharedPreferences([Map<String, Object?> initial = const {}]) {
    // A store that has just been opened agrees with itself.
    _disk.addAll(initial);
    _cache.addAll(initial);
  }

  final Map<String, Object?> _disk = {};
  final Map<String, Object?> _cache = {};

  /// One entry per [remove] or `set*` call, in call order.
  final List<String> writeLog = [];

  String? _hangKey;
  Completer<void>? _reachedHangKey;
  bool _hung = false;
  String? _failKey;
  int _failTimes = 0;
  String? _throwKey;
  int _throwTimes = 0;
  bool _failReload = false;

  /// The values the disk holds right now. This is what the next app start
  /// loads, and what every invariant about a failed round is asserted against.
  Map<String, Object?> get snapshot => Map.unmodifiable(_disk);

  /// How many times [key] was written or removed.
  int writeCount(String key) => writeLog.where((k) => k == key).length;

  /// Waits until the chained persist rounds stop writing. A fixed number of
  /// microtask rounds is calibrated for one round against a mock whose writes
  /// go nowhere; a store-backed fake needs the whole chain.
  Future<void> settle() async {
    // Several quiet ticks, not one: a round that ever awaits a real async
    // boundary would go quiet for a tick mid-chain, and a single-tick settle
    // would return early and make every assertion after it vacuous.
    var quiet = 0;
    var seen = -1;
    while (quiet < 5) {
      quiet = writeLog.length == seen ? quiet + 1 : 0;
      seen = writeLog.length;
      await Future<void>.delayed(Duration.zero);
    }
  }

  /// Arms the stall. The write of [key] logs the key, completes
  /// [reachedHangKey] and then never returns, and no later write lands either
  /// — what a process killed mid-round looks like from the store.
  void hangOn(String key) {
    _hangKey = key;
    _reachedHangKey = Completer<void>();
  }

  /// Completes when the armed write of the [hangOn] key is reached.
  Future<void> get reachedHangKey => _reachedHangKey!.future;

  /// Arms [times] refused platform writes on [key].
  ///
  /// Each write of [key] logs the key, updates the cache, leaves the disk and
  /// returns `false` — what `shared_preferences_windows` returns when the I/O
  /// it wraps fails. The arm counts down and then stops, so a later round sees
  /// a store that answers again. That is the failure the persist queue is
  /// built to repair.
  ///
  /// Raise [times] to model a lock that outlives one write. A file lock from
  /// another process spans several rounds, and a key written once per round is
  /// then refused in each of them.
  void failOn(String key, {int times = 1}) {
    _failKey = key;
    _failTimes = times;
  }

  /// Arms [times] throwing platform writes on [key].
  ///
  /// Each write of [key] logs the key, updates the cache, leaves the disk and
  /// returns a rejected future — what a platform channel raises when the reply
  /// cannot be decoded. [times] counts down as for [failOn].
  void throwOn(String key, {int times = 1}) {
    _throwKey = key;
    _throwTimes = times;
  }

  static void _apply(Map<String, Object?> map, String key, Object? value) {
    if (value == null) {
      map.remove(key);
    } else {
      map[key] = value;
    }
  }

  Future<bool> _write(String key, Object? value) {
    if (_hung) {
      return Completer<bool>().future;
    }

    writeLog.add(key);
    // The cache moves before the platform answers, whatever the answer is.
    _apply(_cache, key, value);

    if (key == _hangKey) {
      _hung = true;
      _reachedHangKey!.complete();
      return Completer<bool>().future;
    }

    if (key == _throwKey) {
      _throwTimes -= 1;
      if (_throwTimes == 0) {
        _throwKey = null;
      }
      return Future.error(
        StateError('write of $key failed'),
        StackTrace.current,
      );
    }

    if (key == _failKey) {
      _failTimes -= 1;
      if (_failTimes == 0) {
        _failKey = null;
      }
      return Future.value(false);
    }

    _apply(_disk, key, value);
    return Future.value(true);
  }

  /// Arms one throwing [reload]. The platform that just refused a write is the
  /// platform the re-read has to go through, so the two fail together.
  void failReloadOnce() {
    _failReload = true;
  }

  @override
  Future<void> reload() async {
    if (_failReload) {
      _failReload = false;
      throw StateError('the store could not be re-read');
    }
    _cache
      ..clear()
      ..addAll(_disk);
  }

  @override
  Set<String> getKeys() => Set<String>.from(_cache.keys);

  @override
  Object? get(String key) => _cache[key];

  @override
  bool containsKey(String key) => _cache.containsKey(key);

  @override
  bool? getBool(String key) => _cache[key] as bool?;

  @override
  int? getInt(String key) => _cache[key] as int?;

  @override
  double? getDouble(String key) => _cache[key] as double?;

  @override
  String? getString(String key) => _cache[key] as String?;

  @override
  List<String>? getStringList(String key) =>
      (_cache[key] as List<dynamic>?)?.cast<String>().toList();

  @override
  Future<bool> remove(String key) => _write(key, null);

  @override
  Future<bool> setBool(String key, bool value) => _write(key, value);

  @override
  Future<bool> setInt(String key, int value) => _write(key, value);

  @override
  Future<bool> setDouble(String key, double value) => _write(key, value);

  @override
  Future<bool> setString(String key, String value) => _write(key, value);

  @override
  Future<bool> setStringList(String key, List<String> value) =>
      _write(key, value);

  @Deprecated('This method is now a no-op, and should no longer be called.')
  @override
  Future<bool> commit() async => true;

  @override
  Future<bool> clear() async {
    _cache.clear();
    _disk.clear();
    return true;
  }
}
