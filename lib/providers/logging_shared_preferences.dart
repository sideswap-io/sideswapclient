import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';

/// Raised by [LoggingSharedPreferences] when the settings store answers a
/// write with `false`.
///
/// The store gives no reason, so the key is the whole report.
class RefusedSettingsWrite implements Exception {
  RefusedSettingsWrite(this.key);

  /// The settings key the store refused.
  final String key;

  @override
  String toString() => 'The settings store refused the write of $key';
}

/// A [SharedPreferences] that ends a persist round on a refused write.
///
/// `SharedPreferences` reports a failed platform write two ways: `false` from
/// a setter, and a thrown error. Both leave the value in the facade's cache
/// and off the disk, because the facade fills its cache before it asks the
/// platform. A round that carries on past either one writes later keys over a
/// state the disk never reached — for the PIN record, that raises the flag
/// over a blob that is not whole.
///
/// This decorator turns both reports into one: it logs the key, replaces the
/// cache with what the disk holds, and raises. The persist queue logs the
/// error and runs the next round, which rewrites the whole snapshot.
///
/// See ADR-0017.
class LoggingSharedPreferences implements SharedPreferences {
  LoggingSharedPreferences(this._prefs);

  final SharedPreferences _prefs;

  /// Runs one store write, and ends the round when the store refuses it.
  Future<bool> _guard(String key, Future<bool> Function() write) async {
    final bool written;
    try {
      written = await write();
    } catch (_) {
      await _refuse(key);
      rethrow;
    }
    if (!written) {
      await _refuse(key);
      throw RefusedSettingsWrite(key);
    }
    return true;
  }

  /// Logs the refused key and puts the cache back in step with the disk, so
  /// the next round compares against what the disk holds.
  ///
  /// A re-read that fails is logged and swallowed. It must not replace the
  /// refusal on its way out: the refused key is what names the fault, and the
  /// round has to end on that. The cache then stays ahead of the disk, and the
  /// next round compares the blob against a value the disk never took — see
  /// ADR-0017.
  Future<void> _refuse(String key) async {
    logger.e('The settings store refused the write of $key');
    try {
      await _prefs.reload();
    } catch (error, stackTrace) {
      logger.e(
        'The settings store could not be re-read after $key',
        error,
        stackTrace,
      );
    }
  }

  @override
  Future<bool> setBool(String key, bool value) =>
      _guard(key, () => _prefs.setBool(key, value));

  @override
  Future<bool> setInt(String key, int value) =>
      _guard(key, () => _prefs.setInt(key, value));

  @override
  Future<bool> setDouble(String key, double value) =>
      _guard(key, () => _prefs.setDouble(key, value));

  @override
  Future<bool> setString(String key, String value) =>
      _guard(key, () => _prefs.setString(key, value));

  @override
  Future<bool> setStringList(String key, List<String> value) =>
      _guard(key, () => _prefs.setStringList(key, value));

  @override
  Future<bool> remove(String key) => _guard(key, () => _prefs.remove(key));

  @override
  Set<String> getKeys() => _prefs.getKeys();

  @override
  Object? get(String key) => _prefs.get(key);

  @override
  bool containsKey(String key) => _prefs.containsKey(key);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  double? getDouble(String key) => _prefs.getDouble(key);

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  @override
  Future<bool> clear() => _prefs.clear();

  @Deprecated('This method is now a no-op, and should no longer be called.')
  @override
  // ignore: deprecated_member_use
  Future<bool> commit() => _prefs.commit();

  @override
  Future<void> reload() => _prefs.reload();
}
