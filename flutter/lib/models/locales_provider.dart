import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<String> supportedLanguages() {
  return [
    'en',
    'sv',
    'pl',
    'ru',
    'ar',
    'ur',
  ];
}

String localeName(String lang) {
  switch (lang) {
    case 'en':
      return 'English';
    case 'sv':
      return 'Svenska';
    case 'pl':
      return 'Polski';
    case 'ru':
      return 'Русский';
    case 'ar':
      return 'اَلْعَرَبِيَّةُ';
    case 'ur':
      return 'اُردُو';
  }
  return lang;
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

final localesProvider = ChangeNotifierProvider<LocalesChangeNotifier>((ref) {
  return LocalesChangeNotifier();
});

class LocalesChangeNotifier with ChangeNotifier {
  String selectedLang(BuildContext context) {
    return context.locale.languageCode;
  }

  Future<void> setSelectedLang(BuildContext context, String value) async {
    await context.setLocale(Locale(value));
    // Workaround for https://github.com/aissat/easy_localization/issues/370
    Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
