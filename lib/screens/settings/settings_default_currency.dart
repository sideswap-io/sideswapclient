import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/currency_rates_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/settings/widgets/settings_checkbox_button.dart';

class SettingsDefaultCurrency extends ConsumerWidget {
  const SettingsDefaultCurrency({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversionRates = ref.watch(conversionRatesNotifierProvider);
    final defaultConverstionRate =
        ref.watch(defaultConversionRateNotifierProvider);

    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Currency'.tr(),
      ),
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
                child: SettingsCheckboxButton(
                  checked: defaultConverstionRate ==
                      conversionRates.usdConversionRates[index],
                  onChanged: (value) {
                    ref
                        .read(defaultConversionRateNotifierProvider.notifier)
                        .setDefaultConversionRate(
                            conversionRates.usdConversionRates[index]);
                  },
                  content: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      conversionRates.usdConversionRates[index].name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: conversionRates.usdConversionRates.length,
            )
          ],
        ),
      ),
    );
  }
}
