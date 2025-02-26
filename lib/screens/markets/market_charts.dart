import 'package:candlesticks/candlesticks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_url_link.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/chart_providers.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/token_market_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MarketCharts extends HookConsumerWidget {
  const MarketCharts({this.onBackPressed, super.key});

  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartsData = ref.watch(chartsNotifierProvider);
    final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);
    final optionBaseAsset = ref.watch(marketSubscribedBaseAssetProvider);
    final optionMarketInfo = ref.watch(subscribedMarketInfoProvider);

    final detailsExpanded = useState(false);

    return optionMarketInfo.match(
      () => SizedBox(),
      (marketInfo) => optionBaseAsset.match(
        () => SizedBox(),
        (baseAsset) => optionQuoteAsset.match(
          () => SizedBox(),
          (quoteAsset) => Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Candlesticks(
                          candles: chartsData[marketInfo.assetPair] ?? [],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AssetDetails(
                      marketInfo: marketInfo,
                      baseAsset: baseAsset,
                      quoteAsset: quoteAsset,
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
                      AssetDetails(
                        marketInfo: marketInfo,
                        baseAsset: baseAsset,
                        quoteAsset: quoteAsset,
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
        ),
      ),
    );
  }
}

class AssetDetails extends HookConsumerWidget {
  const AssetDetails({
    super.key,
    required this.expanded,
    required this.onToggled,
    required this.marketInfo,
    required this.baseAsset,
    required this.quoteAsset,
  });

  final bool expanded;
  final VoidCallback? onToggled;
  final Asset baseAsset;
  final Asset quoteAsset;
  final MarketInfo marketInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

    final baseAssetIcon = ref
        .watch(assetImageRepositoryProvider)
        .getVerySmallImage(baseAsset.assetId);
    final quoteAssetIcon = ref
        .watch(assetImageRepositoryProvider)
        .getVerySmallImage(quoteAsset.assetId);

    final marketType = marketInfo.type;
    final asset = marketType == MarketType_.AMP ? baseAsset : quoteAsset;

    final isTestnet = ref.watch(envProvider.notifier).isTestnet();
    final baseAssetUrl = generateAssetUrl(
      assetId: baseAsset.assetId,
      testnet: isTestnet,
    );
    final quoteAssetUrl = generateAssetUrl(
      assetId: quoteAsset.assetId,
      testnet: isTestnet,
    );

    useEffect(() {
      ref
          .read(tokenMarketNotifierProvider.notifier)
          .requestAssetDetails(assetId: asset.assetId);
      return;
    }, [asset]);

    final chartStatsRepository = ref.watch(chartStatsRepositoryProvider(asset));

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
        children: [
          Row(
            children: [
              baseAssetIcon,
              SizedBox(width: 4),
              Text(
                baseAsset.ticker,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(' / ', style: Theme.of(context).textTheme.bodyLarge),
              quoteAssetIcon,
              SizedBox(width: 4),
              Text(
                quoteAsset.ticker,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Spacer(),
              IconButton(
                onPressed: onToggled,
                icon: SvgPicture.asset(
                  expanded ? 'assets/arrow_down2.svg' : 'assets/arrow_up2.svg',
                  colorFilter: ColorFilter.mode(
                    expanded
                        ? SideSwapColors.brightTurquoise
                        : SideSwapColors.airSuperiorityBlue,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Table(
            children: [
              TableRow(
                children: [
                  DetailsField(
                    name: '30d Low'.tr(),
                    value: chartStatsRepository.statsLowString(),
                    assetAmount: chartStatsRepository.statsLow(),
                    assetId: chartStatsRepository.priceAssetId(),
                  ),
                  DetailsField(
                    name: '30d High'.tr(),
                    value: chartStatsRepository.statsHighString(),
                    assetAmount: chartStatsRepository.statsHigh(),
                    assetId: chartStatsRepository.priceAssetId(),
                  ),
                  DetailsField(
                    name: 'Last'.tr(),
                    value: chartStatsRepository.statsLastString(),
                    assetAmount: chartStatsRepository.statsLast(),
                    assetId: chartStatsRepository.priceAssetId(),
                  ),
                ],
              ),
              TableRow(
                children: [
                  DetailsField(
                    name: '30d Change'.tr(),
                    value: chartStatsRepository.statsChangePercentString(),
                    color:
                        chartStatsRepository.statsChangePercent() == 0
                            ? null
                            : (chartStatsRepository.statsChangePercent() > 0
                                ? SideSwapColors.turquoise
                                : SideSwapColors.bitterSweet),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return DetailsField(
                        name: '30d Vol'.tr(),
                        value: chartStatsRepository.statsVolumeString(),
                      );
                    },
                  ),
                  if (chartStatsRepository.pricedInLiquid)
                    DetailsField(
                      name: 'Market cap (L-BTC)'.tr(),
                      value: chartStatsRepository.marketCapString(),
                      assetAmount: chartStatsRepository.marketCap(),
                      assetId: liquidAssetId,
                    )
                  else
                    SizedBox(),
                ],
              ),
              TableRow(
                children: [
                  DetailsField(
                    name: 'Free float'.tr(),
                    value: chartStatsRepository.floatAmountString(),
                  ),
                  DetailsField(
                    name: 'Total float'.tr(),
                    value: chartStatsRepository.totalAmountString(),
                  ),
                  SizedBox(),
                ],
              ),
            ],
          ),
          if (expanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(height: 1, color: SideSwapColors.airSuperiorityBlue),
                const SizedBox(height: 12),
                Text(
                  'Asset info'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    baseAssetIcon,
                    SizedBox(width: 4),
                    Text(baseAsset.ticker),
                    SizedBox(width: 4),
                    Text(' - '),
                    SizedBox(width: 4),
                    Text(baseAsset.name),
                  ],
                ),
                const SizedBox(height: 8),
                if (baseAsset.hasDomain() == true)
                  assetDetailsUrl('Issuer'.tr(), 'https://${baseAsset.domain}'),
                assetDetailsUrl('Asset'.tr(), baseAssetUrl),
                if (baseAsset.hasDomainAgentLink() == true)
                  assetDetailsUrl(
                    'Registration Agent'.tr(),
                    baseAsset.domainAgentLink,
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    quoteAssetIcon,
                    SizedBox(width: 4),
                    Text(quoteAsset.ticker),
                    SizedBox(width: 4),
                    Text(' - '),
                    SizedBox(width: 4),
                    Text(quoteAsset.name),
                  ],
                ),
                const SizedBox(height: 8),
                if (quoteAsset.hasDomain() == true)
                  assetDetailsUrl(
                    'Issuer'.tr(),
                    'https://${quoteAsset.domain}',
                  ),
                assetDetailsUrl('Asset'.tr(), quoteAssetUrl),
                if (quoteAsset.hasDomainAgentLink() == true)
                  assetDetailsUrl(
                    'Registration Agent'.tr(),
                    quoteAsset.domainAgentLink,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget assetDetailsUrl(String name, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$name:',
          style: const TextStyle(color: SideSwapColors.cornFlower),
        ),
        DUrlLink(text: value),
        const SizedBox(height: 8),
      ],
    );
  }
}

class DetailsField extends ConsumerWidget {
  const DetailsField({
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
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color)),
        const SizedBox(height: 4),
        if (defaultCurrencyPrice != null)
          Text(
            '≈ ${formatThousandsSep(defaultCurrencyPrice.toDouble())} $defaultCurrencyTicker',
            style: const TextStyle(
              fontSize: 12,
              color: SideSwapColors.cornFlower,
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
