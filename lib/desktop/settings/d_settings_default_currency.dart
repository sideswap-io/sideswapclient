import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/button/d_settings_radio_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/countries_provider.dart';
import 'package:sideswap/providers/currency_rates_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class DSettingsDefaultCurrency extends ConsumerWidget {
  const DSettingsDefaultCurrency({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme =
        ref.watch(desktopAppThemeNotifierProvider).defaultDialogTheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      child: DContentDialog(
        title: DContentDialogTitle(
          onClose: () {
            ref.read(walletProvider).goBack();
          },
          content: Text('Currency'.tr()),
        ),
        content: const DSettingsDefaultCurrencyContent(),
        style: const DContentDialogThemeData().merge(defaultDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 635),
        actions: [
          Center(
            child: DCustomTextBigButton(
              width: 266,
              onPressed: () {
                ref.read(walletProvider).goBack();
              },
              child: Text(
                'BACK'.tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DSettingsDefaultCurrencyContent extends HookConsumerWidget {
  const DSettingsDefaultCurrencyContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversionRates = ref.watch(conversionRatesNotifierProvider);
    final defaultConverstionRate =
        ref.watch(defaultConversionRateNotifierProvider);
    final countryCodesValue = ref.watch(countriesFutureProvider);

    final countryCodes = switch (countryCodesValue) {
      AsyncValue(hasValue: true, value: List<CountryCode> countries) =>
        countries,
      _ => <CountryCode>[],
    };

    return Center(
      child: SizedBox(
        width: 374,
        height: 446,
        child: CustomScrollView(
          slivers: [
            SliverList.builder(
              itemBuilder: (context, index) {
                final conversionRate =
                    conversionRates.usdConversionRates[index];
                // TODO: use when conversion rates will contain country code
                // ignore: unused_local_variable
                final countryCode = countryCodes.firstWhereOrNull(
                    (e) => e.currencyCode == conversionRate.name);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 30),
                  child: DSettingsRadioButton(
                    checked: defaultConverstionRate == conversionRate,
                    onChanged: (value) {
                      ref
                          .read(defaultConversionRateNotifierProvider.notifier)
                          .setDefaultConversionRate(conversionRate);
                    },
                    content: Row(
                      children: [
                        Text(
                          conversionRate.name,
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: conversionRates.usdConversionRates.length,
            )
          ],
        ),
      ),
    );
  }
}
