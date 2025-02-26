import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/decorations/side_swap_input_decoration.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/stokr_providers.dart';
import 'package:sideswap/providers/wallet.dart';

class StokrCountryRestrictionsInfoPopup extends HookConsumerWidget {
  const StokrCountryRestrictionsInfoPopup({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseAsset = ref.watch(marketSubscribedBaseAssetProvider).toNullable();

    return SideSwapPopup(
      onClose: () {
        ref.read(walletProvider).goBack();
      },
      canPop: false,
      child: Center(
        child: Column(
          children: [
            const StokrExclamationIcon(),
            const SizedBox(height: 16),
            Text(
              'This asset has country restrictions'.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Blocked countries'.tr(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: SideSwapColors.brightTurquoise,
                ),
              ),
            ),
            CustomBigButton(
              width: double.infinity,
              height: 54,
              backgroundColor: Colors.transparent,
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return const StokrBlockedCountriesPopup();
                  },
                );
              },
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: SideSwapColors.jellyBean,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          'Open the list'.tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomBigButton(
                width: double.infinity,
                height: 54,
                backgroundColor: SideSwapColors.brightTurquoise,
                onPressed: () {
                  if (baseAsset != null) {
                    openUrl(baseAsset.domainAgentLink);
                  }
                },
                child: Text(
                  'REGISTER ON STOKR'.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: CustomBigButton(
                width: double.infinity,
                height: 54,
                backgroundColor: Colors.transparent,
                onPressed: () {
                  ref
                      .read(configurationProvider.notifier)
                      .setStokrSettingsModel(
                        const StokrSettingsModel(firstRun: false),
                      );
                  ref.read(walletProvider).goBack();
                },
                child: Text(
                  'DON\'T SHOW AGAIN'.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StokrExclamationIcon extends StatelessWidget {
  const StokrExclamationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: SideSwapColors.yellowOrange, width: 3),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/exclamationMark.svg',
          width: 27,
          height: 27,
          colorFilter: const ColorFilter.mode(
            SideSwapColors.yellowOrange,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class StokrBlockedCountriesPopup extends HookConsumerWidget {
  const StokrBlockedCountriesPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const TextStyle defaultStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );

    final controller = useTextEditingController();
    final blacklistedCountries = useState(<CountryCode>[]);
    final allBlockedCountries = useState(<CountryCode>[]);
    final stokrCountryBlacklist = ref.watch(stokrBlockedCountriesProvider);

    useEffect(() {
      final countries = switch (stokrCountryBlacklist) {
        AsyncValue(hasValue: true, value: List<CountryCode> countries) =>
          countries,
        _ => <CountryCode>[],
      };

      allBlockedCountries.value = countries;
      blacklistedCountries.value = countries;

      return;
    }, [stokrCountryBlacklist]);

    useEffect(() {
      controller.addListener(() async {
        if (controller.text.isNotEmpty) {
          final found = await ref.read(
            stokrCountryBlacklistSearchProvider(controller.text).future,
          );
          blacklistedCountries.value = found;
          return;
        }

        blacklistedCountries.value = allBlockedCountries.value;
      });

      return;
    }, [controller]);

    return SideSwapScaffold(
      backgroundColor: SideSwapColors.blumine,
      sideSwapBackground: false,
      appBar: CustomAppBar(
        title: 'Blocked countries'.tr(),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextField(
                controller: controller,
                style: defaultStyle,
                decoration: SideSwapInputDecoration(
                  hintText: 'Search'.tr(),
                  suffixIcon: SizedBox(
                    width: 17,
                    height: 17,
                    child: Center(
                      child: SvgPicture.asset('assets/search2.svg'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Flexible(
                child: CustomScrollView(
                  slivers: [
                    SliverList.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 2),
                          child: Text(
                            '${blacklistedCountries.value[index].english ?? ''} (${blacklistedCountries.value[index].name ?? ''})',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(fontSize: 18),
                          ),
                        );
                      },
                      itemCount: blacklistedCountries.value.length,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
