import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the copy the locked screen falls back to when the client reports a
/// failure with nothing in it.
///
/// `WalletLocked` renders this key whenever the login error carries a null or
/// empty message. A widget test cannot catch a key that is missing from a
/// locale file -- easy_localization silently echoes the key, which happens to
/// be the English string, so the screen looks right in every test and wrong
/// only to a user reading one of the other eight languages.
void main() {
  const fallbackKey = 'Could not unlock your wallet. Please try again.';
  const locales = ['ar', 'en', 'es', 'pl', 'pt', 'ru', 'sv', 'ur', 'zh'];

  Map<String, dynamic> translations(String locale) =>
      jsonDecode(
            File('assets/translations/$locale.json').readAsStringSync(),
          )
          as Map<String, dynamic>;

  group('unlock failure copy', () {
    test('the fallback exists in every locale', () {
      for (final locale in locales) {
        expect(
          translations(locale),
          contains(fallbackKey),
          reason: '$locale.json is missing the unlock failure fallback',
        );
      }
    });

    test('the fallback is translated, not left in English', () {
      for (final locale in locales.where((l) => l != 'en')) {
        expect(
          translations(locale)[fallbackKey],
          isNot(fallbackKey),
          reason: '$locale.json still carries the English fallback',
        );
      }
    });

    test('"Unknown error" stays parameterised, so it cannot stand in', () {
      // Every locale carries a placeholder, which is exactly why this key
      // cannot be reused: given nothing to interpolate it renders a dangling
      // separator rather than a sentence.
      for (final locale in locales) {
        expect(
          translations(locale)['Unknown error'],
          contains('{}'),
          reason: '$locale.json: "Unknown error" is expected to interpolate',
        );
      }
    });
  });
}
