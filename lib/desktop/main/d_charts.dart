import 'package:candlesticks/candlesticks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/button/d_url_link.dart';
import 'package:sideswap/desktop/markets/d_markets_root.dart';
import 'package:sideswap/models/market_data_provider.dart';
import 'package:sideswap/models/token_market_provider.dart';
import 'package:sideswap/models/wallet.dart';

class DCharts extends ConsumerStatefulWidget {
  const DCharts({
    Key? key,
    required this.assetId,
    required this.onBackPressed,
  }) : super(key: key);

  final String assetId;
  final VoidCallback onBackPressed;

  @override
  ConsumerState<DCharts> createState() => _DChartsState();
}

class _DChartsState extends ConsumerState<DCharts> {
  late MarketDataNotifier marketData;

  bool detailsExpanded = false;

  @override
  void initState() {
    super.initState();
    marketData = ref.read(marketDataProvider);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      marketData.marketDataSubscribe(widget.assetId);
      ref
          .read(tokenMarketProvider)
          .requestAssetDetails(assetId: widget.assetId);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DHoverButton(
                    builder: (context, states) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(
                            color: const Color(0xFF00C5FF),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/arrow_back3.svg'),
                            const SizedBox(width: 7),
                            Text('Back'.tr()),
                          ],
                        ),
                      );
                    },
                    onPressed: widget.onBackPressed,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Candlesticks(
                    candles: candles,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _AssetDetails(
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
                _AssetDetails(
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

class _AssetDetails extends ConsumerWidget {
  const _AssetDetails({
    Key? key,
    required this.assetId,
    required this.expanded,
    required this.onToggled,
  }) : super(key: key);

  final String assetId;
  final bool expanded;
  final VoidCallback onToggled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.read(walletProvider);
    final asset = wallet.assets[assetId]!;
    final icon = wallet.assetImagesSmall[assetId]!;
    final issuerDetails = ref.watch(tokenMarketProvider).assetDetails[assetId];
    final isTestnet = wallet.isTestnet();
    final assetUrl = generateAssetUrl(assetId: assetId, testnet: isTestnet);
    final stats = ref.watch(marketDataProvider).getStats();

    final floatAmount = (issuerDetails?.stats?.issuedAmount ?? 0) -
        (issuerDetails?.stats?.burnedAmount ?? 0);
    final offlineAmount = issuerDetails?.stats?.offlineAmount ?? 0;

    final totalAmount = floatAmount + offlineAmount;
    final marketCap =
        toFloat(totalAmount, precision: asset.precision) * stats.last;
    final pricedInLiquid = isPricedInLiquid(asset);
    final priceAssetId = pricedInLiquid ? wallet.liquidAssetId() : assetId;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C6086),
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
              const SizedBox(width: 8),
              Text(
                asset.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                asset.ticker,
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
              const Spacer(),
              DHoverButton(
                builder: (context, states) {
                  return SvgPicture.asset(
                    expanded
                        ? 'assets/arrow_down2.svg'
                        : 'assets/arrow_up2.svg',
                    color: states.isHovering ? Colors.white : null,
                  );
                },
                onPressed: onToggled,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DetailsField(
                name: '3d Low'.tr(),
                value: priceStr(stats.low, pricedInLiquid),
                assetAmount: stats.low,
                assetId: priceAssetId,
              ),
              _DetailsField(
                name: '3d High'.tr(),
                value: priceStr(stats.high, pricedInLiquid),
                assetAmount: stats.high,
                assetId: priceAssetId,
              ),
              _DetailsField(
                name: 'Last'.tr(),
                value: priceStr(stats.last, pricedInLiquid),
                assetAmount: stats.last,
                assetId: priceAssetId,
              ),
              _DetailsField(
                name: '30d Change'.tr(),
                value: '${stats.changePercent.toStringAsFixed(2)}%',
                color: stats.changePercent == 0
                    ? null
                    : (stats.changePercent > 0
                        ? const Color(0xFF2CCCBF)
                        : const Color(0xFFFF7878)),
              ),
              _DetailsField(
                name: '30d Vol'.tr(),
                value: amountStr(
                    toIntAmount(stats.volume, precision: asset.precision),
                    precision: asset.precision),
              ),
              _DetailsField(
                name: 'Free float'.tr(),
                value: amountStr(floatAmount, precision: asset.precision),
              ),
              _DetailsField(
                name: 'Total float'.tr(),
                value: amountStr(totalAmount, precision: asset.precision),
              ),
              if (pricedInLiquid)
                _DetailsField(
                  name: 'Market cap (L-BTC)'.tr(),
                  value: marketCap.toStringAsFixed(2),
                  assetAmount: marketCap,
                  assetId: wallet.liquidAssetId(),
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
                Table(
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  children: [
                    assetDetailsUrl(
                      'Issuer'.tr(),
                      'https://${asset.domain}',
                    ),
                    assetDetailsUrl(
                      'Asset'.tr(),
                      assetUrl,
                    ),
                    if (asset.hasDomainAgent())
                      assetDetailsUrl(
                        'Registration Agent'.tr(),
                        'https://${asset.domainAgent}',
                      ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  TableRow assetDetailsUrl(String name, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, right: 16),
          child: Text(
            '$name:',
            style: const TextStyle(
              color: Color(0xFF87C1E1),
            ),
          ),
        ),
        DUrlLink(
          text: value,
        ),
      ],
    );
  }
}

class _DetailsField extends ConsumerWidget {
  const _DetailsField({
    Key? key,
    required this.name,
    required this.value,
    this.color,
    this.assetAmount,
    this.assetId,
  }) : super(key: key);

  final String name;
  final String value;
  final Color? color;
  final double? assetAmount;
  final String? assetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dollarPrice = (assetAmount != null && assetId != null)
        ? ref.watch(walletProvider).getAmountUsd(assetId, assetAmount!)
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFF87C1E1),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        if (dollarPrice != null)
          Text(
            '≈ \$ ${dollarPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF87C1E1),
            ),
          ),
      ],
    );
  }
}
