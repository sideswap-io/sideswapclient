import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/common/utils/country_codes.dart';

final countriesProvider =
    ChangeNotifierProvider<CountriesProvider>((ref) => CountriesProvider(ref));

class CountriesProvider with ChangeNotifier {
  CountriesProvider(this.ref) {
    _loadCountries();
  }

  final Ref ref;
  List<CountryCode> countries = <CountryCode>[];

  void _loadCountries() {
    final countryCodeList = codes
        .map((e) => CountryCode(
              name: e['name'] as String,
              english: e['english'] as String,
              countryCode: e['countryCode'] as String,
              dialCode: e['dialCode'] as String,
              currencyCode: e['currencyCode'] as String,
              currencyName: e['currencyName'] as String,
              iso3Code: e['isoCode'] as String,
            ))
        .toList();

    countryCodeList.sort((a, b) {
      return a.iso3Code.toString().compareTo(b.iso3Code.toString());
    });

    countries = List.unmodifiable(countryCodeList);
  }

  CountryCode getSystemDefaultCountry() {
    final defaultCountryCode =
        WidgetsBinding.instance?.window.locales.first.countryCode;
    final countryCode = countries.firstWhere(
        (e) => e.countryCode == defaultCountryCode,
        orElse: () => countries.first);
    return countryCode;
  }
}
