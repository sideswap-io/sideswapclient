import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locales_provider.g.dart';

List<String> supportedLanguages() {
  return ['ar', 'en', 'es', 'pl', 'pt', 'ru', 'sv', 'ur', 'zh'];
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

@Riverpod(keepAlive: true)
class LocalesNotifier extends _$LocalesNotifier {
  @override
  String build() => 'en';

  void setSelectedLang(String value) {
    state = value;
  }
}
