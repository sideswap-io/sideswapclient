import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/token_market_provider.dart';
import 'package:sideswap/models/wallet.dart';

class DAssetInfo extends ConsumerStatefulWidget {
  const DAssetInfo({
    super.key,
    required this.account,
  });

  final AccountAsset account;

  @override
  ConsumerState<DAssetInfo> createState() => _DAssetInfoState();
}

class _DAssetInfoState extends ConsumerState<DAssetInfo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(tokenMarketProvider)
          .requestAssetDetails(assetId: widget.account.asset);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallet = ref.watch(walletProvider);
    final asset = wallet.assets[widget.account.asset]!;
    final details =
        ref.watch(tokenMarketProvider).assetDetails[widget.account.asset];
    final issuedAmount = details?.stats?.issuedAmount ?? 0;
    final burnedAmount = details?.stats?.burnedAmount ?? 0;
    final circulatingAmount = issuedAmount - burnedAmount;
    final circulatingAmountStr =
        amountStr(circulatingAmount, precision: asset.precision);
    final assetImagesBig =
        ref.watch(walletProvider).assetImagesBig[widget.account.asset]!;
    final balance = ref.watch(balancesProvider).balances[widget.account] ?? 0;
    final balanceStr = amountStr(balance, precision: asset.precision);

    return DPopupWithClose(
      width: 580,
      height: 606,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 66),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Color(0xFF135579),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: assetImagesBig,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.ticker,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        asset.name,
                        style: const TextStyle(
                          color: Color(0xFF83B4D2),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        balanceStr,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 52),
            child: Column(
              children: [
                const SizedBox(height: 32),
                _Field(
                    name: 'Precision'.tr(), value: asset.precision.toString()),
                _Separator(),
                ...asset.hasDomain()
                    ? [
                        _Field(
                          name: 'Issuer Domain'.tr(),
                          valueWidget: DHoverButton(
                            builder: (context, states) {
                              return Text(
                                asset.domain,
                                style: const TextStyle(
                                    color: Color(0xFF00C5FF),
                                    decoration: TextDecoration.underline),
                              );
                            },
                            onPressed: () {
                              openUrl('https://${asset.domain}');
                            },
                          ),
                        ),
                        _Separator(),
                      ]
                    : [],
                ...asset.hasDomainAgent()
                    ? [
                        _Field(
                          name: 'Registration Agent'.tr(),
                          valueWidget: DHoverButton(
                            builder: (context, states) {
                              return Text(
                                asset.domainAgent,
                                style: const TextStyle(
                                    color: Color(0xFF00C5FF),
                                    decoration: TextDecoration.underline),
                              );
                            },
                            onPressed: () {
                              openUrl('https://${asset.domainAgent}');
                            },
                          ),
                        ),
                        _Separator(),
                      ]
                    : [],
                ...circulatingAmount != 0
                    ? [
                        _Field(
                            name: 'Circulating amount'.tr(),
                            value: circulatingAmountStr),
                        _Separator(),
                      ]
                    : [],
                _Field(name: 'Asset ID'.tr(), value: ''),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.account.asset,
                      ),
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      onPressed: () =>
                          copyToClipboard(context, widget.account.asset),
                      icon: SvgPicture.asset('assets/copy2.svg',
                          width: 22, height: 22),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            color: const Color(0xFF135579),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 52),
            child: DCustomFilledBigButton(
              child: Text('OPEN IN EXPLORER'.tr()),
              onPressed: () {
                final isTestnet = wallet.isTestnet();
                final assetUrl = generateAssetUrl(
                    assetId: widget.account.asset, testnet: isTestnet);
                openUrl(assetUrl);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.name,
    this.value,
    this.valueWidget,
  });

  final String name;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF00C5FF),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (value != null)
            Text(
              value!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          if (valueWidget != null) valueWidget!
        ],
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0x805294B9),
    );
  }
}
