import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/home/listeners/portfolio_prices_listener.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/token_market_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/accounts/widgets/assets_header.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/models/tx_item.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/screens/accounts/widgets/asset_details_header.dart';
import 'package:sideswap/screens/accounts/widgets/maximize_list_button.dart';

part 'asset_details.g.dart';

@riverpod
StreamController<double> heightPercentController(
    HeightPercentControllerRef ref) {
  ref.onDispose(() => ref.state.close());
  return StreamController<double>();
}

@riverpod
class PanelPositionNotifier extends _$PanelPositionNotifier {
  @override
  double build() {
    return 0;
  }

  void setPanelPosition(double value) {
    state = value;
  }
}

class AssetDetails extends HookConsumerWidget {
  const AssetDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16, top: 18),
            child: WalletTransactions(
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        PortfolioPricesListener(),
        AssetDetailsTopHeader(),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: AssetDetailsBackButton(),
        ),
        AssetDetailsTransactionsPanel(),
      ],
    );
  }
}

class AssetDetailsTransactionsPanel extends HookConsumerWidget {
  const AssetDetailsTransactionsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelController = useMemoized(() => PanelController());

    const maxExtent = 0.8849;
    const minExtent = 0.4043;

    final minimizedPadding = MediaQuery.of(context).padding.top + 40;
    final maximizedPadding = MediaQuery.of(context).padding.top + 70;
    final screenHeight = MediaQuery.of(context).size.height;

    final selectedWalletAccountAsset =
        ref.watch(selectedWalletAccountAssetNotifierProvider);
    final allAssets = ref.watch(accountAssetTransactionsProvider);
    final assetList = allAssets[selectedWalletAccountAsset] ?? <TxItem>[];
    final hightPercentController = ref.watch(heightPercentControllerProvider);

    return SlidingUpPanel(
      controller: panelController,
      backdropEnabled: false,
      parallaxEnabled: false,
      isDraggable: assetList.isEmpty ? false : true,
      minHeight: minExtent * screenHeight - minimizedPadding,
      maxHeight: maxExtent * screenHeight - maximizedPadding,
      onPanelSlide: (position) {
        ref
            .read(panelPositionNotifierProvider.notifier)
            .setPanelPosition(position);
        hightPercentController.add(1 - position);
      },
      color: SideSwapColors.chathamsBlue,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      header: AssetDetailsSlidingPanelHeader(
        panelController: panelController,
      ),
      panelBuilder: (sc) {
        return const AssetDetailsPanelBuilder();
      },
    );
  }
}

class AssetDetailsPanelBuilder extends HookConsumerWidget {
  const AssetDetailsPanelBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWalletAccountAsset =
        ref.watch(selectedWalletAccountAssetNotifierProvider);
    final asset = ref.watch(assetsStateProvider
        .select((value) => value[selectedWalletAccountAsset?.assetId]));

    useEffect(() {
      ref
          .read(tokenMarketProvider)
          .requestAssetDetails(assetId: asset?.assetId);

      return;
    }, [asset]);

    return switch (asset) {
      Asset asset => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 68),
              ...switch (asset.hasDomain()) {
                true => [
                    AssetDetailsText(text: 'Issuer domain'.tr()),
                    AssetDetailsUnderlineButton(
                      text: asset.domain,
                      onPressed: () {
                        openUrl('https://${asset.domain}');
                      },
                    ),
                  ],
                _ => [const SizedBox()],
              },
              AssetDetailsText(text: 'Asset'.tr()),
              Consumer(
                builder: (context, ref, child) {
                  final isTestnet = ref.read(envProvider.notifier).isTestnet();
                  final assetUrl = generateAssetUrl(
                      assetId: asset.assetId, testnet: isTestnet);
                  return AssetDetailsUnderlineButton(
                    text: assetUrl,
                    onPressed: () {
                      openUrl(assetUrl);
                    },
                  );
                },
              ),
              ...switch (asset.hasDomainAgent()) {
                true => [
                    AssetDetailsText(text: 'Registration Agent'.tr()),
                    AssetDetailsUnderlineButton(
                      text: asset.domainAgent,
                      onPressed: () {
                        openUrl(asset.domainAgent);
                      },
                    ),
                  ],
                _ => [const SizedBox()],
              },
              AssetDetailsText(text: 'Precision'.tr()),
              Consumer(
                builder: (context, ref, child) {
                  final assetPrecision = ref
                      .watch(assetUtilsProvider)
                      .getPrecisionForAssetId(assetId: asset.assetId);
                  return AssetDetailsText(
                    text: '$assetPrecision',
                    padding: 16,
                    color: Colors.white,
                    useSelectable: true,
                  );
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final details =
                      ref.watch(tokenMarketAssetDetailsProvider)[asset.assetId];
                  final issuedAmount = details?.stats?.issuedAmount ?? 0;
                  final burnedAmount = details?.stats?.burnedAmount ?? 0;
                  final circulatingAmount = issuedAmount - burnedAmount;
                  final amountProvider = ref.watch(amountToStringProvider);
                  final assetPrecision = ref
                      .watch(assetUtilsProvider)
                      .getPrecisionForAssetId(assetId: asset.assetId);
                  final circulatingAmountStr = amountProvider.amountToString(
                      AmountToStringParameters(
                          amount: circulatingAmount,
                          precision: assetPrecision));

                  return switch (circulatingAmount) {
                    0 => const SizedBox(),
                    _ => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AssetDetailsText(text: 'Circulating amount'.tr()),
                          AssetDetailsText(
                            text: circulatingAmountStr,
                            padding: 16,
                            color: Colors.white,
                            useSelectable: true,
                          ),
                        ],
                      ),
                  };
                },
              ),
              AssetDetailsText(text: 'Asset ID'.tr()),
              AssetDetailsText(
                text: asset.assetId,
                padding: 16,
                color: Colors.white,
                useSelectable: true,
              ),
            ],
          ),
        ),
      _ => const SizedBox(),
    };
  }
}

class AssetDetailsText extends StatelessWidget {
  const AssetDetailsText({
    super.key,
    required this.text,
    this.padding = 4,
    this.color = SideSwapColors.cornFlower,
    this.useSelectable = false,
  });

  final String text;
  final double padding;
  final Color color;
  final bool useSelectable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        switch (useSelectable) {
          true => SelectableText(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: color,
                  ),
            ),
          _ => Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: color,
                  ),
            ),
        },
        SizedBox(height: padding),
      ],
    );
  }
}

class AssetDetailsUnderlineButton extends StatelessWidget {
  const AssetDetailsUnderlineButton(
      {super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14, decoration: TextDecoration.underline),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class AssetDetailsSlidingPanelHeader extends StatelessWidget {
  const AssetDetailsSlidingPanelHeader(
      {super.key, required this.panelController});

  final PanelController panelController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Asset Info'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(letterSpacing: 0.35),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final panelPosition =
                          ref.watch(panelPositionNotifierProvider);

                      return MaximizeListButton(
                        position: panelPosition,
                        onPressed: () {
                          if (panelPosition == 1) {
                            panelController.close();
                          } else {
                            panelController.open();
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AssetDetailsBackButton extends ConsumerWidget {
  const AssetDetailsBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomBackButton(
      onPressed: () {
        final walletMainArguments = ref.read(uiStateArgsNotifierProvider);
        ref.read(uiStateArgsNotifierProvider.notifier).setWalletMainArguments(
              walletMainArguments.copyWith(
                navigationItemEnum: WalletMainNavigationItemEnum.accounts,
              ),
            );
      },
    );
  }
}

class AssetDetailsTopHeader extends HookConsumerWidget {
  const AssetDetailsTopHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hightPercentController = ref.watch(heightPercentControllerProvider);

    const logoHeightMax = 64.0;
    const logoHeightMin = 36.0;
    const logoPaddingMax = 32.0;
    const logoPaddingMin = 24.0;

    final heightPercentCallback =
        useCallback((double percent, double min, double max) {
      return ((max - min) * percent) + min;
    }, []);

    return StreamBuilder<double>(
      stream: hightPercentController.stream,
      builder: (context, snapshot) {
        final percent = snapshot.hasData ? snapshot.data ?? 1.0 : 1.0;
        final logoHeight =
            heightPercentCallback(percent, logoHeightMin, logoHeightMax);
        final logoPadding =
            heightPercentCallback(percent, logoPaddingMin, logoPaddingMax);

        return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: logoPadding),
                child: Consumer(
                  builder: (context, ref, child) {
                    final selectedWalletAccountAsset =
                        ref.watch(selectedWalletAccountAssetNotifierProvider);
                    final assetId = selectedWalletAccountAsset?.assetId;
                    final icon =
                        ref.watch(assetImageProvider).getBigImage(assetId);
                    return SizedBox(
                      width: logoHeight,
                      height: logoHeight,
                      child: icon,
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 106),
                child: AssetDetailsHeader(
                  percent: percent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
