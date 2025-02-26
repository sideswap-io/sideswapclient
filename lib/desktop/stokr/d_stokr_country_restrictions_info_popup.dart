import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/stokr_providers.dart';
import 'package:sideswap/providers/wallet.dart';

class DStokrCountryRestrictionsInfoPopup extends ConsumerWidget {
  const DStokrCountryRestrictionsInfoPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme =
        ref.watch(desktopAppThemeNotifierProvider).defaultDialogTheme;
    final baseAsset = ref.watch(marketSubscribedBaseAssetProvider).toNullable();

    return DContentDialog(
      title: DContentDialogTitle(
        height: 28,
        onClose: () {
          ref.read(walletProvider).goBack();
        },
      ),
      style: const DContentDialogThemeData().merge(
        defaultDialogTheme.merge(
          const DContentDialogThemeData(
            titlePadding: EdgeInsets.only(
              top: 24,
              bottom: 0,
              left: 24,
              right: 24,
            ),
          ),
        ),
      ),
      content: SizedBox(
        height: 553,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const DStokrExclamationIcon(),
              const SizedBox(height: 31),
              Text(
                'This asset has country restrictions'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Blocked countries'.tr(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.brightTurquoise,
                  ),
                ),
              ),
              const DStokrCountryBlacklistDropdown(),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DCustomTextBigButton(
                    width: 245,
                    onPressed: () {
                      ref
                          .read(configurationProvider.notifier)
                          .setStokrSettingsModel(
                            const StokrSettingsModel(firstRun: false),
                          );
                      ref.read(walletProvider).goBack();
                    },
                    child: Text('DON\'T SHOW AGAIN'.tr()),
                  ),
                  DCustomFilledBigButton(
                    width: 245,
                    onPressed: () {
                      if (baseAsset != null) {
                        openUrl(baseAsset.domainAgentLink);
                      }
                    },
                    child: Text('REGISTER ON STOKR'.tr()),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
    );
  }
}

class DStokrCountryBlacklistDropdown extends HookConsumerWidget {
  const DStokrCountryBlacklistDropdown({super.key});

  // unfocus textfield
  void onTapDownSuffix({required FocusNode focusNode}) {
    focusNode.unfocus();
    focusNode.canRequestFocus = false;

    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.canRequestFocus = true;
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    final icon = useState(Icons.expand_more);
    final expanded = useState(false);

    final blacklistedCountries = useState(<CountryCode>[]);
    final allBlockedCountries = useState(<CountryCode>[]);
    final stokrCountryBlacklist = ref.watch(stokrBlockedCountriesProvider);

    useEffect(() {
      final countries = switch (stokrCountryBlacklist) {
        AsyncValue(hasValue: true, value: List<CountryCode> countries) =>
          countries,
        _ => <CountryCode>[],
      };

      allBlockedCountries.value = [...countries];
      blacklistedCountries.value = countries;

      return;
    }, [stokrCountryBlacklist]);

    useEffect(() {
      if (expanded.value) {
        icon.value = Icons.expand_less;
        return;
      }

      icon.value = Icons.expand_more;
      return;
    }, [expanded.value]);

    useEffect(() {
      controller.addListener(() async {
        if (controller.text.isNotEmpty) {
          final found = await ref.read(
            stokrCountryBlacklistSearchProvider(controller.text).future,
          );
          blacklistedCountries.value = found;
          expanded.value = true;
          return;
        }

        blacklistedCountries.value = allBlockedCountries.value;
      });

      return;
    }, [controller]);

    return Column(
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.basic,
              child: SizedBox(
                width: 24,
                height: 24,
                child: DIconButton(
                  icon: Icon(icon.value),
                  onTapDown: () {
                    onTapDownSuffix(focusNode: focusNode);
                  },
                  onPressed: () {
                    expanded.value = !expanded.value;
                  },
                ),
              ),
            ),
            hintText: 'Open the list'.tr(),
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 18),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: SideSwapColors.airSuperiorityBlue),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: SideSwapColors.airSuperiorityBlue),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: SideSwapColors.brightTurquoise),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...switch (expanded.value) {
          true => [
            Container(
              height: 196,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: SideSwapColors.chathamsBlue,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 16,
                  left: 16,
                  right: 4,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverList.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 2),
                          child: Text(
                            '${blacklistedCountries.value[index].english ?? ''} (${blacklistedCountries.value[index].name ?? ''})',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                      itemCount: blacklistedCountries.value.length,
                    ),
                  ],
                ),
              ),
            ),
          ],
          _ => [const SizedBox()],
        },
      ],
    );
  }
}

class DStokrExclamationIcon extends StatelessWidget {
  const DStokrExclamationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: SideSwapColors.yellowOrange, width: 8),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/exclamationMark.svg',
          width: 30,
          height: 30,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
