import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/send_asset_provider.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/token_market_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';

class DAssetInfo extends ConsumerStatefulWidget {
  const DAssetInfo({
    super.key,
    required this.account,
  });

  final AccountAsset account;

  @override
  ConsumerState<DAssetInfo> createState() => DAssetInfoState();
}

class DAssetInfoState extends ConsumerState<DAssetInfo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(tokenMarketProvider)
          .requestAssetDetails(assetId: widget.account.assetId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asset = ref.watch(
        assetsStateProvider.select((value) => value[widget.account.assetId]));
    final assetPrecision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: asset?.assetId);
    final details =
        ref.watch(tokenMarketAssetDetailsProvider)[widget.account.assetId];
    final issuedAmount = details?.stats?.issuedAmount ?? 0;
    final burnedAmount = details?.stats?.burnedAmount ?? 0;
    final circulatingAmount = issuedAmount - burnedAmount;
    final amountProvider = ref.watch(amountToStringProvider);
    final circulatingAmountStr = amountProvider.amountToString(
        AmountToStringParameters(
            amount: circulatingAmount, precision: assetPrecision));
    final assetImagesBig =
        ref.watch(assetImageProvider).getBigImage(asset?.assetId);
    final accountBalance =
        ref.watch(balancesNotifierProvider)[widget.account] ?? 0;
    final balanceStr = amountProvider.amountToString(AmountToStringParameters(
        amount: accountBalance, precision: assetPrecision));
    final balance = double.tryParse(balanceStr) ?? .0;
    final defaultCurrencyAmount =
        ref.watch(amountUsdInDefaultCurrencyProvider(asset?.assetId, balance));
    final defaultCurrencyTicker = ref.read(defaultCurrencyTickerProvider);
    var defaultCurrencyConversion = '0.0';
    defaultCurrencyConversion = defaultCurrencyAmount.toStringAsFixed(2);
    defaultCurrencyConversion = replaceCharacterOnPosition(
        input: defaultCurrencyConversion, currencyChar: defaultCurrencyTicker);
    final visibleConversion =
        ref.read(walletProvider).isAmountUsdAvailable(asset?.assetId);

    return DPopupWithClose(
      width: 580,
      height: 632,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 66),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: SideSwapColors.chathamsBlue,
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
                        asset?.ticker ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        asset?.name ?? '',
                        style: const TextStyle(
                          color: SideSwapColors.halfBaked,
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
                      ),
                      Text(
                        visibleConversion ? '≈ $defaultCurrencyConversion' : '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: SideSwapColors.halfBaked,
                        ),
                      ),
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
                DAssetInfoField(
                    name: 'Precision'.tr(), value: assetPrecision.toString()),
                const DAssetInfoSeparator(),
                ...asset?.hasDomain() == true
                    ? [
                        DAssetInfoField(
                          name: 'Issuer Domain'.tr(),
                          valueWidget: DHoverButton(
                            cursor: SystemMouseCursors.click,
                            builder: (context, states) {
                              return Text(
                                asset?.domain ?? '',
                                style: const TextStyle(
                                    color: SideSwapColors.brightTurquoise,
                                    decoration: TextDecoration.underline),
                              );
                            },
                            onPressed: () {
                              openUrl('https://${asset?.domain ?? ''}');
                            },
                          ),
                        ),
                        const DAssetInfoSeparator(),
                      ]
                    : [],
                ...asset?.hasDomainAgentLink() == true
                    ? [
                        DAssetInfoField(
                          name: 'Registration Agent'.tr(),
                          valueWidget: DHoverButton(
                            cursor: SystemMouseCursors.click,
                            builder: (context, states) {
                              return Text(
                                asset?.domainAgentLink ?? '',
                                style: const TextStyle(
                                    color: SideSwapColors.brightTurquoise,
                                    decoration: TextDecoration.underline),
                              );
                            },
                            onPressed: () {
                              openUrl(asset?.domainAgentLink ?? '');
                            },
                          ),
                        ),
                        const DAssetInfoSeparator(),
                      ]
                    : [],
                ...circulatingAmount != 0
                    ? [
                        DAssetInfoField(
                            name: 'Circulating amount'.tr(),
                            value: circulatingAmountStr),
                        const DAssetInfoSeparator(),
                      ]
                    : [],
                DAssetInfoField(
                  name: 'View in Explorer'.tr(),
                  valueWidget: DHoverButton(
                    cursor: SystemMouseCursors.click,
                    builder: (context, states) {
                      return Row(
                        children: [
                          Text(
                            'open in explorer'.tr(),
                            style: const TextStyle(
                                color: SideSwapColors.brightTurquoise,
                                decoration: TextDecoration.underline),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          SvgPicture.asset(
                            'assets/link2.svg',
                            width: 20,
                            height: 20,
                          ),
                        ],
                      );
                    },
                    onPressed: () {
                      final isTestnet =
                          ref.read(envProvider.notifier).isTestnet();
                      final assetUrl = generateAssetUrl(
                          assetId: widget.account.assetId, testnet: isTestnet);
                      openUrl(assetUrl);
                    },
                  ),
                ),
                DAssetInfoField(name: 'Asset ID'.tr(), value: ''),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.account.assetId ?? '',
                      ),
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      onPressed: () => copyToClipboard(
                          context, widget.account.assetId ?? ''),
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
            height: 124,
            color: SideSwapColors.chathamsBlue,
            child: Column(
              children: [
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      label: 'Swap'.tr(),
                      onTap: () {
                        Navigator.pop(context);
                        ref.read(swapProvider).swapReset();
                        final walletMainArguments =
                            ref.watch(uiStateArgsNotifierProvider);
                        ref
                            .read(uiStateArgsNotifierProvider.notifier)
                            .setWalletMainArguments(
                                walletMainArguments.fromIndexDesktop(1));
                        ref.read(swapProvider).switchToSwaps();
                      },
                      icon: 'assets/asset_swap_arrows.svg',
                    ),
                    const SizedBox(width: 48),
                    CustomIconButton(
                      label: 'Send'.tr(),
                      onTap: () {
                        ref.invalidate(createTxStateNotifierProvider);
                        Navigator.pop(context);
                        ref
                            .read(sendAssetNotifierProvider.notifier)
                            .setSendAsset(widget.account);

                        ref.read(desktopDialogProvider).showSendTx();
                      },
                      icon: 'assets/top_right_arrow.svg',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends HookConsumerWidget {
  const CustomIconButton({
    super.key,
    required this.label,
    this.onTap,
    required this.icon,
  });

  final String label;
  final VoidCallback? onTap;
  final String icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mouseHoover = useState(false);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        mouseHoover.value = true;
      },
      onExit: (event) {
        mouseHoover.value = false;
      },
      child: RoundedButtonWithLabel(
        iconWidth: 48,
        iconHeight: 48,
        iconBorderRadius: BorderRadius.circular(48),
        onTap: onTap,
        label: label,
        labelPadding: const EdgeInsets.only(top: 8),
        labelTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        buttonBackground:
            mouseHoover.value ? SideSwapColors.brightTurquoise : Colors.white,
        child: SvgPicture.asset(
          icon,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
            mouseHoover.value ? Colors.white : SideSwapColors.chathamsBlueDark,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class DAssetInfoField extends StatelessWidget {
  const DAssetInfoField({
    super.key,
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
              color: SideSwapColors.brightTurquoise,
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

class DAssetInfoSeparator extends StatelessWidget {
  const DAssetInfoSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0x805294B9),
    );
  }
}
