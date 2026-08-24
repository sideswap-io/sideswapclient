import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/providers/locales_provider.dart';

import '../utils.dart';

void main() {
  group('supportedLanguages', () {
    test('returns list of all supported language codes', () {
      final languages = supportedLanguages();

      expect(languages, ['ar', 'en', 'es', 'pl', 'pt', 'ru', 'sv', 'ur', 'zh']);
    });
  });

  group('localeName', () {
    final cases = [
      (input: 'ar', expected: 'اَلْعَرَبِيَّةُ'),
      (input: 'en', expected: 'English'),
      (input: 'es', expected: 'Español'),
      (input: 'pl', expected: 'Polski'),
      (input: 'pt', expected: 'Português'),
      (input: 'ru', expected: 'Русский'),
      (input: 'sv', expected: 'Svenska'),
      (input: 'ur', expected: 'اُردُو'),
      (input: 'zh', expected: '中国人'),
    ];

    for (final c in cases) {
      test('returns "${c.expected}" for language code "${c.input}"', () {
        expect(localeName(c.input), c.expected);
      });
    }

    test('returns empty string for unknown language code', () {
      expect(localeName('xx'), '');
    });

    test('returns empty string for empty input', () {
      expect(localeName(''), '');
    });

    test('handles case sensitivity - returns empty for wrong case', () {
      expect(localeName('EN'), '');
      expect(localeName('En'), '');
    });

    test('all supported languages have non-empty display names', () {
      final languages = supportedLanguages();
      for (final lang in languages) {
        expect(localeName(lang), isNotEmpty);
      }
    });
  });

  group('supportedLocales', () {
    test('returns list of Locale objects matching supported languages', () {
      final locales = supportedLocales();

      expect(locales.length, 9);
      expect(locales, [
        const Locale('ar'),
        const Locale('en'),
        const Locale('es'),
        const Locale('pl'),
        const Locale('pt'),
        const Locale('ru'),
        const Locale('sv'),
        const Locale('ur'),
        const Locale('zh'),
      ]);
    });
  });

  group('localeIconFile', () {
    final cases = ['ar', 'en', 'es', 'pl', 'pt', 'ru', 'sv', 'ur', 'zh'];

    for (final lang in cases) {
      test('returns SvgPicture for language code "$lang"', () {
        final widget = localeIconFile(lang);
        expect(widget, isA<SvgPicture>());
      });
    }

    test('returned SvgPicture has width 24 and height 18', () {
      final widget = localeIconFile('en') as SvgPicture;
      expect(widget.width, 24);
      expect(widget.height, 18);
    });
  });

  group('LocalesNotifier', () {
    group('setSelectedLang', () {
      test('updates state to given language code', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container.read(localesProvider.notifier).setSelectedLang('pl');

        expect(container.read(localesProvider), 'pl');
      });

      test('updates state on successive calls', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container.read(localesProvider.notifier).setSelectedLang('ru');
        container.read(localesProvider.notifier).setSelectedLang('zh');

        expect(container.read(localesProvider), 'zh');
      });

      test('emits state changes via listener', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<String>();
        container.listen(
          localesProvider,
          listener.call,
          fireImmediately: false,
        );

        container.read(localesProvider.notifier).setSelectedLang('es');
        container.read(localesProvider.notifier).setSelectedLang('pt');

        verifyInOrder([
          () => listener(any(), 'es'),
          () => listener(any(), 'pt'),
        ]);
        verifyNoMoreInteractions(listener);
      });
    });
  });
}
