import 'package:sideswap/common/utils/custom_logger.dart';

class CountryCode {
  const CountryCode({
    this.name,
    this.english,
    this.countryCode,
    this.dialCode,
    this.currencyCode,
    this.currencyName,
    this.iso3Code,
  });

  final String name;
  final String english;
  final String countryCode;
  final String dialCode;
  final String currencyCode;
  final String currencyName;
  final String iso3Code;

  // Transform a country acronym to an emoji flag
  static final OFFSET = 127397;

  String isoUnicode(String value) {
    if (value == null) {
      logger.d(name);
    }
    // final isoRegExp = RegExp(r'^[a-z]{2}$');
    // if (!isoRegExp.hasMatch(value.toLowerCase())) {
    //   throw Exception(
    //       'argument must be an ISO 3166-1 alpha-2 string, but got ${countryCode.runtimeType} instead.');
    // }
    final chars = [...value.toUpperCase().codeUnits].map((e) => e + OFFSET);
    return String.fromCharCodes(chars);
  }

  String get isoUnicodeFlag => isoUnicode(countryCode);
  String get isoUnicodeCurrencyFlag {
    if (currencyCode == 'EUR') {
      return isoUnicode('EU');
    }
    if (currencyCode == 'USD') {
      return isoUnicode('US');
    }
    if (currencyCode == 'GBP') {
      return isoUnicode('GB');
    }

    return isoUnicode(countryCode);
  }

  @override
  String toString() {
    return 'CountryCode(name: $name, english: $english, countryCode: $countryCode, dialCode: $dialCode, currencyCode: $currencyCode, currencyName: $currencyName, iso3Code: $iso3Code)';
  }
}
