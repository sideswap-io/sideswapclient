import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class AssetItem extends StatelessWidget {
  const AssetItem({
    super.key,
    required this.asset,
    required this.onSelected,
    this.disabled = false,
    this.disabledBackgroundColor = const Color(0xFF034569),
    this.backgroundColor = SideSwapColors.chathamsBlue,
  });

  final Asset asset;
  final ValueChanged<Asset> onSelected;
  final bool disabled;
  final Color disabledBackgroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final textColor = disabled ? const Color(0xFFAAAAAA) : Colors.white;
    final bgColor = disabled ? disabledBackgroundColor : backgroundColor;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 80,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: bgColor,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: disabled
              ? null
              : () {
                  onSelected(asset);
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final icon = ref
                          .watch(assetImageRepositoryProvider)
                          .getBigImage(asset.assetId);
                      return icon;
                    },
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      height: 48,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    asset.name,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                AssetItemAmount(
                                  asset: asset,
                                  disabled: disabled,
                                ),
                              ],
                            ),
                          ),
                          AccountItemConversion(asset: asset),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountItemConversion extends StatelessWidget {
  const AccountItemConversion({super.key, required this.asset});

  final Asset asset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              asset.ticker,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Color(0xFF6B91A8),
              ),
            ),
            if (asset.ampMarket)
              const AmpFlag(
                textStyle: TextStyle(
                  color: Color(0xFF73A6C5),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        Consumer(
          builder: (context, ref, child) {
            final defaultCurrencyTicker = ref.watch(
              defaultCurrencyTickerProvider,
            );
            final defaultCurrencyAssetBalance = ref.watch(
              assetBalanceInDefaultCurrencyStringProvider(asset),
            );

            return Text(
              '$defaultCurrencyAssetBalance $defaultCurrencyTicker',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Color(0xFF6B91A8),
              ),
            );
          },
        ),
      ],
    );
  }
}

class AssetItemAmount extends ConsumerWidget {
  const AssetItemAmount({
    super.key,
    required this.asset,
    this.disabled = false,
  });

  final Asset asset;
  final bool disabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetBalance = ref.watch(assetBalanceStringProvider(asset));

    final textColor = disabled ? const Color(0xFFAAAAAA) : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        assetBalance,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
      ),
    );
  }
}
