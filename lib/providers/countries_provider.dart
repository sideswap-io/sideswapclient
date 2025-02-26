import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/common/utils/country_codes.dart';

part 'countries_provider.g.dart';

@riverpod
FutureOr<List<CountryCode>> countriesFuture(Ref ref) {
  final countryCodeList =
      codes
          .map(
            (e) => CountryCode(
              name: e['name'] as String,
              english: e['english'] as String,
              countryCode: e['countryCode'] as String,
              dialCode: e['dialCode'] as String,
              currencyCode: e['currencyCode'] as String,
              currencyName: e['currencyName'] as String,
              iso3Code: e['isoCode'] as String,
            ),
          )
          .toList();

  countryCodeList.sort((a, b) {
    return a.iso3Code.toString().compareTo(b.iso3Code.toString());
  });

  return List.unmodifiable(countryCodeList);
}

@riverpod
class DefaultSystemCountryAsyncNotifier
    extends _$DefaultSystemCountryAsyncNotifier {
  @override
  FutureOr<CountryCode> build() {
    final countries = ref.watch(countriesFutureProvider);

    final countryCode = switch (countries) {
      AsyncValue(hasValue: true, value: List<CountryCode> countries) => () {
        final defaultCountryCode =
            WidgetsBinding
                .instance
                .platformDispatcher
                .locales
                .first
                .countryCode;
        final countryCode = countries.firstWhere(
          (e) => e.countryCode == defaultCountryCode,
          orElse: () => countries.first,
        );
        return countryCode;
      }(),
      _ => null,
    };

    if (countryCode == null) {
      return future;
    }

    return countryCode;
  }
}

// @riverpod
// FutureOr<CountryCode> defaultSystemCountryFuture(
//     DefaultSystemCountryFutureRef ref) {
//   final countries = ref.watch(countriesFutureProvider);
//   final countryCode = switch (countries) {
//     AsyncValue(hasValue: true, value: List<CountryCode> countries) => () {
//         final defaultCountryCode = WidgetsBinding
//             .instance.platformDispatcher.locales.first.countryCode;
//         final countryCode = countries.firstWhere(
//             (e) => e.countryCode == defaultCountryCode,
//             orElse: () => countries.first);
//         return countryCode;
//       }(),
//     _ => future,
//   };

//   return countryCode;
// }

// final countriesProvider =
//     ChangeNotifierProvider<CountriesProvider>((ref) => CountriesProvider(ref));

// class CountriesProvider with ChangeNotifier {
//   CountriesProvider(this.ref) {
//     _loadCountries();
//   }

//   final Ref ref;
//   List<CountryCode> countries = <CountryCode>[];

//   void _loadCountries() {
//     final countryCodeList = codes
//         .map((e) => CountryCode(
//               name: e['name'] as String,
//               english: e['english'] as String,
//               countryCode: e['countryCode'] as String,
//               dialCode: e['dialCode'] as String,
//               currencyCode: e['currencyCode'] as String,
//               currencyName: e['currencyName'] as String,
//               iso3Code: e['isoCode'] as String,
//             ))
//         .toList();

//     countryCodeList.sort((a, b) {
//       return a.iso3Code.toString().compareTo(b.iso3Code.toString());
//     });

//     countries = List.unmodifiable(countryCodeList);
//   }

//   CountryCode getSystemDefaultCountry() {
//     final defaultCountryCode =
//         WidgetsBinding.instance.platformDispatcher.locales.first.countryCode;
//     final countryCode = countries.firstWhere(
//         (e) => e.countryCode == defaultCountryCode,
//         orElse: () => countries.first);
//     return countryCode;
//   }
// }
