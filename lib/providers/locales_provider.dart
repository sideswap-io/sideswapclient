import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';

part 'locales_provider.g.dart';

List<String> supportedLanguages() {
  return [
    'ar',
    'en',
    'es',
    'pl',
    'pt',
    'ru',
    'sv',
    'ur',
    'zh',
  ];
}

String localeName(String lang) {
  return switch (lang) {
    'ar' => 'اَلْعَرَبِيَّةُ',
    'en' => 'English',
    'es' => 'Español',
    'pl' => 'Polski',
    'pt' => 'Português',
    'ru' => 'Русский',
    'sv' => 'Svenska',
    'ur' => 'اُردُو',
    'zh' => '中国人',
    _ => '',
  };
}

Widget localeIconFile(String lang) {
  return SvgPicture.asset(
    'assets/translations/icons/$lang.svg',
    width: 24,
    height: 18,
  );
}

List<Locale> supportedLocales() {
  return supportedLanguages().map((e) => Locale(e)).toList();
}

@riverpod
class LocalesNotifier extends _$LocalesNotifier {
  @override
  String build() {
    final context = ref.watch(navigatorKeyProvider).currentContext;
    if (context == null) {
      return 'en';
    }

    return context.locale.languageCode;
  }

  Future<void> setSelectedLang(String value) async {
    final context = ref.read(navigatorKeyProvider).currentContext;
    if (context == null) {
      return;
    }

    await context.setLocale(Locale(value));

    // Workaround for https://github.com/aissat/easy_localization/issues/370
    Future.delayed(const Duration(milliseconds: 30), () {
      state = context.locale.languageCode;
    });
  }
}
