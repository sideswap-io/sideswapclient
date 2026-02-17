import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/sideswap_slider/sideswap_slider.dart';
import 'package:sideswap/common/widgets/sideswap_slider/sideswap_slider_theme.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/instant_swap/widgets/d_max_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/providers/limit_review_order_providers.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/server_status_providers.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/instant_swap/widgets/max_button.dart';

class FeeRatesDialog extends HookConsumerWidget {
  const FeeRatesDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (FlavorConfig.isDesktop) {
      true => const DesktopFeeRatesDialog(),
      false => const MobileFeeRatesDialog(),
    };
  }
}

class MobileFeeRatesDialog extends ConsumerWidget {
  const MobileFeeRatesDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 360,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: MobileFeeRatesDialogContent(),
        ),
      ),
    );
  }
}

class DesktopFeeRatesDialog extends HookConsumerWidget {
  const DesktopFeeRatesDialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DPopupWithClose(
      width: 580,
      height: 371,
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          const SizedBox(height: 44),
          Text(
            'Fee Rate'.tr(),
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 24),
          DesktopFeeRatesDialogContent(),
        ],
      ),
    );
  }
}

class DesktopFeeRatesDialogContent extends HookConsumerWidget {
  const DesktopFeeRatesDialogContent({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feeRates = ref.watch(bitcoinFeeRatesProvider);

    final distinctFeeRates = feeRates.map((e) => e.value).toSet().toList();

    final pegOutEditFeeRateHelper = ref.watch(
      pegOutEditFeeRateHelperProvider(Option.none()),
    );
    final sliderValues = pegOutEditFeeRateHelper.sliderValues();

    final minFeeStr = '${sliderValues.minFee} sats';
    final maxFeeStr = '${sliderValues.maxFee} sats';

    final trackingRangeConverter = ref.watch(trackingRangeConverterProvider);
    final optionCurrentFeeRate = ref.watch(bitcoinCurrentFeeRateProvider);

    final currentSliderFee = useState(
      optionCurrentFeeRate.match(() => sliderValues.currentFee, (value) {
        return max(value, sliderValues.currentFee);
      }),
    );

    useEffect(() {
      if (currentSliderFee.value > sliderValues.maxFee) {
        currentSliderFee.value = sliderValues.maxFee;
      }

      return;
    }, [sliderValues.maxFee]);

    final defaultButtonStyle = Theme.of(
      context,
    ).extension<DMaxButtonStyle>()?.buttonStyle;

    final scrollController = useScrollController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: [
          Container(
            height: 165,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: SideSwapColors.chathamsBlueDark,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      Text(
                        'Custom fee rate:'.tr(),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 14),
                      SideSwapSlider(
                        value: currentSliderFee.value,
                        onChanged: (value) {
                          final newValue = trackingRangeConverter
                              .toRangeWithPrecision(
                                value,
                                precision: 2,
                                newMin: sliderValues.minFee,
                                newMax: sliderValues.maxFee,
                              );
                          currentSliderFee.value = newValue;
                        },
                        min: sliderValues.minFee,
                        max: sliderValues.maxFee,
                        themeData: SideSwapSliderThemeData(
                          trackHeight: 3,
                          axisInteraction: SideSwapSliderAxisInteraction.center,
                          activeTrackColor: SideSwapColors.bitterSweet,
                          inactiveTrackMarkColor: SideSwapColors.turquoise,
                          activeTrackMarkColor: Colors.white,
                          inactiveTrackColor: SideSwapColors.navyBlue,
                          trackShape: SideSwapDefaultSliderTrackShape(
                            leftGradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                SideSwapColors.bitterSweet,
                                SideSwapColors.navyBlue
                                    .withValues(alpha: 0.24)
                                    .withValues(alpha: .1),
                              ],
                            ),
                            rightGradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                SideSwapColors.navyBlue
                                    .withValues(alpha: 0.24)
                                    .withValues(alpha: .1),
                                SideSwapColors.turquoise,
                              ],
                            ),
                          ),
                          trackDot: SideSwapDefaultTrackDot(),
                          hatchMarkShape: SideSwapDefaultSliderHatchMarkShape(
                            markHeight: 0,
                            padding: 4.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            minFeeStr,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            'New fee: {}'.tr(
                              args: ['${currentSliderFee.value} sats'],
                            ),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            maxFeeStr,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Divider(color: SideSwapColors.blumine),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    height: 23,
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: scrollController,
                      child: ListView.separated(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Center(
                            child: DButton(
                              style: defaultButtonStyle,
                              onPressed: () {
                                currentSliderFee.value =
                                    distinctFeeRates[index];
                              },

                              child: SizedBox(
                                width: 73,
                                height: 23,
                                child: Center(
                                  child: Text('${distinctFeeRates[index]} sat'),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 4);
                        },
                        itemCount: distinctFeeRates.length,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: DCustomButton(
                  width: double.maxFinite,
                  height: 44,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'.tr()),
                ),
              ),
              SizedBox(width: 16),
              Flexible(
                child: DCustomButton(
                  width: double.maxFinite,
                  height: 44,
                  isFilled: true,
                  onPressed: () {
                    ref
                        .read(bitcoinCurrentFeeRateProvider.notifier)
                        .setFeeRate(currentSliderFee.value);
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MobileFeeRatesDialogContent extends HookConsumerWidget {
  const MobileFeeRatesDialogContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feeRates = ref.watch(bitcoinFeeRatesProvider);

    final distinctFeeRates = feeRates.map((e) => e.value).toSet().toList();

    final pegOutEditFeeRateHelper = ref.watch(
      pegOutEditFeeRateHelperProvider(Option.none()),
    );
    final sliderValues = pegOutEditFeeRateHelper.sliderValues();

    final minFeeStr = '${sliderValues.minFee} sats';
    final maxFeeStr = '${sliderValues.maxFee} sats';

    final trackingRangeConverter = ref.watch(trackingRangeConverterProvider);
    final optionCurrentFeeRate = ref.watch(bitcoinCurrentFeeRateProvider);

    final currentSliderFee = useState(
      optionCurrentFeeRate.match(() => sliderValues.currentFee, (value) {
        return max(value, sliderValues.currentFee);
      }),
    );

    useEffect(() {
      if (currentSliderFee.value > sliderValues.maxFee) {
        currentSliderFee.value = sliderValues.maxFee;
      }

      return;
    }, [sliderValues.maxFee]);

    final scrollController = useScrollController();

    return Column(
      children: [
        const SizedBox(height: 16),
        Text('Fee Rate'.tr(), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Container(
          height: 165,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SideSwapColors.chathamsBlueDark,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    Text(
                      'Custom fee rate:'.tr(),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 14),
                    SideSwapSlider(
                      value: currentSliderFee.value,
                      onChanged: (value) {
                        final newValue = trackingRangeConverter
                            .toRangeWithPrecision(
                              value,
                              precision: 2,
                              newMin: sliderValues.minFee,
                              newMax: sliderValues.maxFee,
                            );
                        currentSliderFee.value = newValue;
                      },
                      min: sliderValues.minFee,
                      max: sliderValues.maxFee,
                      themeData: SideSwapSliderThemeData(
                        trackHeight: 3,
                        axisInteraction: SideSwapSliderAxisInteraction.center,
                        activeTrackColor: SideSwapColors.bitterSweet,
                        inactiveTrackMarkColor: SideSwapColors.turquoise,
                        activeTrackMarkColor: Colors.white,
                        inactiveTrackColor: SideSwapColors.navyBlue,
                        trackShape: SideSwapDefaultSliderTrackShape(
                          leftGradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              SideSwapColors.bitterSweet,
                              SideSwapColors.navyBlue
                                  .withValues(alpha: 0.24)
                                  .withValues(alpha: .1),
                            ],
                          ),
                          rightGradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              SideSwapColors.navyBlue
                                  .withValues(alpha: 0.24)
                                  .withValues(alpha: .1),
                              SideSwapColors.turquoise,
                            ],
                          ),
                        ),
                        trackDot: SideSwapDefaultTrackDot(),
                        hatchMarkShape: SideSwapDefaultSliderHatchMarkShape(
                          markHeight: 0,
                          padding: 4.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          minFeeStr,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'New fee: {}'.tr(
                            args: ['${currentSliderFee.value} sats'],
                          ),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          maxFeeStr,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Divider(color: SideSwapColors.blumine),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  height: 23,
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: scrollController,
                    child: ListView.separated(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Center(
                          child: TextButton(
                            style: Theme.of(
                              context,
                            ).extension<MaxButtonStyle>()?.buttonStyle,
                            onPressed: () {
                              currentSliderFee.value = distinctFeeRates[index];
                            },

                            child: SizedBox(
                              width: 73,
                              height: 23,
                              child: Center(
                                child: Text('${distinctFeeRates[index]} sat'),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 4);
                      },
                      itemCount: distinctFeeRates.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CustomBigButton(
          width: double.maxFinite,
          height: 44,
          backgroundColor: SideSwapColors.brightTurquoise,
          onPressed: () {
            ref
                .read(bitcoinCurrentFeeRateProvider.notifier)
                .setFeeRate(currentSliderFee.value);
            Navigator.of(context).pop();
          },
          child: Text('Save'.tr()),
        ),
        const SizedBox(height: 16),
        CustomBigButton(
          width: double.maxFinite,
          height: 44,
          backgroundColor: Colors.transparent,
          textColor: SideSwapColors.brightTurquoise,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'.tr()),
        ),
      ],
    );
  }
}
