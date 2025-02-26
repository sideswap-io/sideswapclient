import 'package:candlesticks/candlesticks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/button/d_url_link.dart';
import 'package:sideswap/desktop/widgets/d_back_button.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/chart_providers.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/token_market_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class DCharts extends HookConsumerWidget {
  const DCharts({this.onBackPressed, super.key});

  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartsData = ref.watch(chartsNotifierProvider);
    final optionAssetPair = ref.watch(
      marketSubscribedAssetPairNotifierProvider,
    );
    final detailsExpanded = useState(false);

    return optionAssetPair.match(
      () => SizedBox(),
      (assetPair) => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DBackButton(
                      onBackPressed:
                          onBackPressed ??
                          () {
                            ref
                                .read(
                                  chartsSubscriptionFlagNotifierProvider
                                      .notifier,
                                )
                                .unsubscribe();
                          },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Candlesticks(candles: chartsData[assetPair] ?? []),
                  ),
                ),
                const SizedBox(height: 30),
                DChartsAssetDetails(
                  expanded: false,
                  onToggled: () {
                    detailsExpanded.value = !detailsExpanded.value;
                  },
                ),
              ],
            ),
            if (detailsExpanded.value)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DChartsAssetDetails(
                    expanded: true,
                    onToggled: () {
                      detailsExpanded.value = !detailsExpanded.value;
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class DChartsAssetDetails extends HookConsumerWidget {
  const DChartsAssetDetails({
    super.key,
    required this.expanded,
    required this.onToggled,
  });

  final bool expanded;
  final VoidCallback onToggled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);

    return optionQuoteAsset.match(
      () => () {
        return SizedBox();
      },
      (asset) => () {
        final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

        useEffect(() {
          ref
              .read(tokenMarketNotifierProvider.notifier)
              .requestAssetDetails(assetId: asset.assetId);
          return;
        }, [asset]);

        final chartStatsRepository = ref.watch(
          chartStatsRepositoryProvider(asset),
        );

        return Container(
          decoration: const BoxDecoration(
            color: SideSwapColors.blumine,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DChartsAssetDetailsHeader(
                expanded: expanded,
                onToggled: onToggled,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DChartsAssetDetailsField(
                    name: '30d Low'.tr(),
                    value: chartStatsRepository.statsLowString(),
                    assetAmount: chartStatsRepository.statsLow(),
                    assetId: chartStatsRepository.priceAssetId(),
                  ),
                  DChartsAssetDetailsField(
                    name: '30d High'.tr(),
                    value: chartStatsRepository.statsHighString(),
                    assetAmount: chartStatsRepository.statsHigh(),
                    assetId: chartStatsRepository.priceAssetId(),
                  ),
                  DChartsAssetDetailsField(
                    name: 'Last'.tr(),
                    value: chartStatsRepository.statsLastString(),
                    assetAmount: chartStatsRepository.statsLast(),
                    assetId: chartStatsRepository.priceAssetId(),
                  ),
                  DChartsAssetDetailsField(
                    name: '30d Change'.tr(),
                    value: chartStatsRepository.statsChangePercentString(),
                    color:
                        chartStatsRepository.statsChangePercent() == 0
                            ? null
                            : (chartStatsRepository.statsChangePercent() > 0
                                ? SideSwapColors.turquoise
                                : SideSwapColors.bitterSweet),
                  ),
                  DChartsAssetDetailsField(
                    name: '30d Vol'.tr(),
                    value: chartStatsRepository.statsVolumeString(),
                  ),
                  DChartsAssetDetailsField(
                    name: 'Free float'.tr(),
                    value: chartStatsRepository.freeFloatString(),
                  ),
                  DChartsAssetDetailsField(
                    name: 'Total float'.tr(),
                    value: chartStatsRepository.totalFloatString(),
                  ),
                  if (chartStatsRepository.pricedInLiquid)
                    DChartsAssetDetailsField(
                      name: 'Market cap (L-BTC)'.tr(),
                      value: chartStatsRepository.marketCapString(),
                      assetAmount: chartStatsRepository.marketCap(),
                      assetId: liquidAssetId,
                    ),
                ],
              ),
              if (expanded) DChartsAssetPairDetails(),
            ],
          ),
        );
      },
    )();
  }
}

class DChartsAssetPairDetails extends ConsumerWidget {
  const DChartsAssetPairDetails({super.key});

  Widget assetDetailsUrl(String name, String value) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            '$name:',
            style: const TextStyle(color: SideSwapColors.cornFlower),
          ),
        ),
        DUrlLink(text: value),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionBaseAsset = ref.watch(marketSubscribedBaseAssetProvider);
    final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);

    return optionBaseAsset.match(
      () => SizedBox(),
      (baseAsset) => optionQuoteAsset.match(
        () => SizedBox(),
        (quoteAsset) => Consumer(
          builder: (context, ref, child) {
            final isTestnet = ref.watch(envProvider.notifier).isTestnet();

            final baseAssetUrl = generateAssetUrl(
              assetId: baseAsset.assetId,
              testnet: isTestnet,
            );
            final baseIcon = ref
                .watch(assetImageRepositoryProvider)
                .getSmallImage(baseAsset.assetId);

            final quoteIcon = ref
                .watch(assetImageRepositoryProvider)
                .getSmallImage(quoteAsset.assetId);
            final quoteAssetUrl = generateAssetUrl(
              assetId: quoteAsset.assetId,
              testnet: isTestnet,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: const Color(0xFF4693BD)),
                Row(
                  children: [
                    baseIcon,
                    const SizedBox(width: 16),
                    Text(
                      baseAsset.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      baseAsset.ticker,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                baseAsset.domain.isNotEmpty
                    ? assetDetailsUrl(
                      'Issuer'.tr(),
                      'https://${baseAsset.domain}',
                    )
                    : SizedBox(),
                assetDetailsUrl('Asset'.tr(), baseAssetUrl),
                baseAsset.hasDomainAgentLink()
                    ? assetDetailsUrl(
                      'Registration Agent'.tr(),
                      baseAsset.domainAgentLink,
                    )
                    : SizedBox(),
                SizedBox(height: 16),
                Row(
                  children: [
                    quoteIcon,
                    const SizedBox(width: 8),
                    Text(
                      quoteAsset.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      quoteAsset.ticker,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                quoteAsset.domain.isNotEmpty
                    ? assetDetailsUrl(
                      'Issuer'.tr(),
                      'https://${quoteAsset.domain}',
                    )
                    : SizedBox(),
                assetDetailsUrl('Asset'.tr(), quoteAssetUrl),
                quoteAsset.hasDomainAgentLink()
                    ? assetDetailsUrl(
                      'Registration Agent'.tr(),
                      quoteAsset.domainAgentLink,
                    )
                    : SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DChartsAssetDetailsHeader extends ConsumerWidget {
  const DChartsAssetDetailsHeader({
    super.key,
    required this.expanded,
    required this.onToggled,
  });

  final bool expanded;
  final VoidCallback onToggled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionBaseAsset = ref.watch(marketSubscribedBaseAssetProvider);
    final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);

    return optionBaseAsset.match(
      () => SizedBox(),
      (baseAsset) => optionQuoteAsset.match(
        () => SizedBox(),
        (quoteAsset) => Row(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final icon = ref
                    .watch(assetImageRepositoryProvider)
                    .getSmallImage(baseAsset.assetId);
                return icon;
              },
            ),
            const SizedBox(width: 8),
            Text(
              baseAsset.ticker,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(width: 8),
            Text('/', style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Consumer(
              builder: (context, ref, child) {
                final icon = ref
                    .watch(assetImageRepositoryProvider)
                    .getSmallImage(quoteAsset.assetId);
                return icon;
              },
            ),
            const SizedBox(width: 8),
            Text(
              quoteAsset.ticker,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const Spacer(),
            DHoverButton(
              builder: (context, states) {
                return SvgPicture.asset(
                  expanded ? 'assets/arrow_down2.svg' : 'assets/arrow_up2.svg',
                  colorFilter: ColorFilter.mode(
                    states.isHovering
                        ? Colors.white
                        : SideSwapColors.brightTurquoise,
                    BlendMode.srcIn,
                  ),
                );
              },
              onPressed: onToggled,
            ),
          ],
        ),
      ),
    );
  }
}

class DChartsAssetDetailsField extends ConsumerWidget {
  const DChartsAssetDetailsField({
    super.key,
    required this.name,
    required this.value,
    this.color,
    this.assetAmount,
    this.assetId,
  });

  final String name;
  final String value;
  final Color? color;
  final double? assetAmount;
  final String? assetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultCurrencyPrice =
        (assetAmount != null && assetId != null)
            ? ref.watch(
              amountUsdInDefaultCurrencyProvider(assetId, assetAmount!),
            )
            : null;
    final defaultCurrencyTicker = ref.read(defaultCurrencyTickerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(color: SideSwapColors.cornFlower)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: color)),
        const SizedBox(height: 8),
        Text(
          defaultCurrencyPrice != null
              ? '≈ ${formatThousandsSep(defaultCurrencyPrice.toDouble())} $defaultCurrencyTicker'
              : '',
          style: const TextStyle(
            fontSize: 12,
            color: SideSwapColors.cornFlower,
          ),
        ),
      ],
    );
  }
}
