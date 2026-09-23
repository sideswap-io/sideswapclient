import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the copy the QR scanner shows when it declines an outputs payload.
///
/// The mobile scanner recognises a `sideswap_app` version `2` document and
/// answers with this message instead of accepting it (ADR-0012, decision 2).
/// A widget test cannot catch a key that is missing from a locale file --
/// easy_localization silently echoes the key, which happens to be the English
/// string, so the screen looks right in every test and wrong only to a user
/// reading one of the other eight languages.
void main() {
  const declineKey = 'This file can only be imported on desktop';
  const locales = ['ar', 'en', 'es', 'pl', 'pt', 'ru', 'sv', 'ur', 'zh'];

  Map<String, dynamic> translations(String locale) =>
      jsonDecode(
            File('assets/translations/$locale.json').readAsStringSync(),
          )
          as Map<String, dynamic>;

  group('outputs payload decline copy', () {
    test('the decline message exists in every locale', () {
      for (final locale in locales) {
        expect(
          translations(locale),
          contains(declineKey),
          reason: '$locale.json is missing the outputs payload decline message',
        );
      }
    });

    test('the decline message is translated, not left in English', () {
      for (final locale in locales.where((l) => l != 'en')) {
        expect(
          translations(locale)[declineKey],
          isNot(declineKey),
          reason: '$locale.json still carries the English decline message',
        );
      }
    });

    test('the decline message sits at the same position in every locale', () {
      // The files are insertion-ordered, not sorted. What keeps them
      // comparable is that every file lists the same keys in the same order,
      // so the new key goes to one position and stays there.
      final keys = <String, List<String>>{
        for (final locale in locales)
          locale: translations(locale).keys.toList(),
      };

      final reference = keys['en']!.indexOf(declineKey);
      final predecessor = keys['en']![reference - 1];
      expect(predecessor, 'This asset has country restrictions');
      // The one ordering claim the files can bear: the key sits after its
      // nearest alphabetical predecessor. Asserting a fully sorted file would
      // fail -- these files are insertion-ordered.
      expect(predecessor.compareTo(declineKey), lessThan(0));
      expect(keys['en']![reference + 1], 'Blocked countries');

      for (final locale in locales) {
        expect(
          keys[locale]!.indexOf(declineKey),
          reference,
          reason: '$locale.json carries the decline message out of position',
        );
      }
    });
  });
}
