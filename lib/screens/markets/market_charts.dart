import 'package:candlesticks/candlesticks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/button/d_url_link.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/market_data_provider.dart';
import 'package:sideswap/providers/token_market_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class MarketCharts extends ConsumerStatefulWidget {
  const MarketCharts({
    super.key,
    required this.assetId,
    required this.onBackPressed,
  });

  final String? assetId;
  final VoidCallback? onBackPressed;

  @override
  ConsumerState<MarketCharts> createState() => DChartsState();
}

class DChartsState extends ConsumerState<MarketCharts> {
  late MarketDataNotifier marketData;

  bool detailsExpanded = false;

  @override
  void initState() {
    super.initState();
    marketData = ref.read(marketDataProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      marketData.marketDataSubscribe(widget.assetId);
      ref
          .read(tokenMarketProvider)
          .requestAssetDetails(assetId: widget.assetId);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      marketData.marketDataUnsubscribe();
    });
    super.dispose();
  }

  void handleDetailsToggled() {
    setState(() {
      detailsExpanded = !detailsExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final candles = ref.watch(marketDataProvider).marketData;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Candlesticks(
                    candles: candles,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              AssetDetails(
                assetId: widget.assetId,
                expanded: false,
                onToggled: handleDetailsToggled,
              ),
            ],
          ),
          if (detailsExpanded)
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AssetDetails(
                  assetId: widget.assetId,
                  expanded: true,
                  onToggled: handleDetailsToggled,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class AssetDetails extends ConsumerWidget {
  const AssetDetails({
    super.key,
    required this.assetId,
    required this.expanded,
    required this.onToggled,
  });

  final String? assetId;
  final bool expanded;
  final VoidCallback? onToggled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset =
        ref.watch(assetsStateProvider.select((value) => value[assetId]));
    final icon = ref.watch(assetImageProvider).getSmallImage(assetId);
    final issuerDetails = ref.watch(tokenMarketAssetDetailsProvider)[assetId];
    final isTestnet = ref.watch(envProvider.notifier).isTestnet();
    final assetUrl = generateAssetUrl(assetId: assetId, testnet: isTestnet);
    final stats = ref.watch(marketDataProvider).getStats();

    final floatAmount = (issuerDetails?.stats?.issuedAmount ?? 0) -
        (issuerDetails?.stats?.burnedAmount ?? 0);
    final offlineAmount = issuerDetails?.stats?.offlineAmount ?? 0;

    final totalAmount = floatAmount + offlineAmount;
    final assetPrecision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: asset?.assetId);
    final marketCap =
        toFloat(totalAmount, precision: assetPrecision) * stats.last;
    final pricedInLiquid =
        ref.watch(assetUtilsProvider).isPricedInLiquid(asset: asset);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final priceAssetId = pricedInLiquid ? liquidAssetId : assetId;

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
          Row(
            children: [
              icon,
              const SizedBox(width: 4),
              Expanded(
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${asset?.name ?? ''} ',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: asset?.ticker ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              DHoverButton(
                builder: (context, states) {
                  return SvgPicture.asset(
                    expanded
                        ? 'assets/arrow_down2.svg'
                        : 'assets/arrow_up2.svg',
                    colorFilter: ColorFilter.mode(
                        states.isHovering ? Colors.white : Colors.red,
                        BlendMode.srcIn),
                  );
                },
                onPressed: onToggled,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Table(
            children: [
              TableRow(
                children: [
                  DetailsField(
                    name: '30d Low'.tr(),
                    value: priceStr(stats.low, pricedInLiquid),
                    assetAmount: stats.low,
                    assetId: priceAssetId,
                  ),
                  DetailsField(
                    name: '30d High'.tr(),
                    value: priceStr(stats.high, pricedInLiquid),
                    assetAmount: stats.high,
                    assetId: priceAssetId,
                  ),
                  DetailsField(
                    name: 'Last'.tr(),
                    value: priceStr(stats.last, pricedInLiquid),
                    assetAmount: stats.last,
                    assetId: priceAssetId,
                  ),
                ],
              ),
              TableRow(
                children: [
                  DetailsField(
                    name: '30d Change'.tr(),
                    value: '${stats.changePercent.toStringAsFixed(2)}%',
                    color: stats.changePercent == 0
                        ? null
                        : (stats.changePercent > 0
                            ? SideSwapColors.turquoise
                            : SideSwapColors.bitterSweet),
                  ),
                  Consumer(builder: (context, ref, child) {
                    final amount =
                        toIntAmount(stats.volume, precision: assetPrecision);
                    final amountProvider = ref.watch(amountToStringProvider);
                    final value = amountProvider.amountToString(
                        AmountToStringParameters(
                            amount: amount, precision: assetPrecision));
                    return DetailsField(
                      name: '30d Vol'.tr(),
                      value: value,
                    );
                  }),
                  if (pricedInLiquid)
                    DetailsField(
                      name: 'Market cap (L-BTC)'.tr(),
                      value: marketCap.toStringAsFixed(2),
                      assetAmount: marketCap,
                      assetId: liquidAssetId,
                    )
                  else
                    Container()
                ],
              ),
              TableRow(
                children: [
                  DetailsField(
                    name: 'Free float'.tr(),
                    value: toFloat(floatAmount, precision: assetPrecision)
                        .toString(),
                  ),
                  DetailsField(
                    name: 'Total float'.tr(),
                    value: toFloat(totalAmount, precision: assetPrecision)
                        .toString(),
                  ),
                  Container()
                ],
              ),
            ],
          ),
          if (expanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  color: const Color(0xFF4693BD),
                ),
                const SizedBox(height: 24),
                Text(
                  'Asset info'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                if (asset?.hasDomain() == true)
                  assetDetailsUrl(
                    'Issuer'.tr(),
                    'https://${asset?.domain ?? ''}',
                  ),
                assetDetailsUrl(
                  'Asset'.tr(),
                  assetUrl,
                ),
                if (asset?.hasDomainAgent() == true)
                  assetDetailsUrl(
                    'Registration Agent'.tr(),
                    'https://${asset?.domainAgent ?? ''}',
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
          style: const TextStyle(
            color: Color(0xFF87C1E1),
          ),
        ),
        DUrlLink(
          text: value,
        ),
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
    final defaultCurrencyPrice = (assetAmount != null && assetId != null)
        ? ref.watch(amountUsdInDefaultCurrencyProvider(assetId, assetAmount!))
        : null;
    final defaultCurrencyTicker = ref.read(defaultCurrencyTickerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFF87C1E1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        if (defaultCurrencyPrice != null)
          Text(
            '≈ ${formatThousandsSep(defaultCurrencyPrice.toDouble())} $defaultCurrencyTicker',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF87C1E1),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
