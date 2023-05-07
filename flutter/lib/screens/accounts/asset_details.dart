import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/models/tx_item.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/accounts/widgets/asset_details_header.dart';
import 'package:sideswap/screens/accounts/widgets/maximize_list_button.dart';
import 'package:sideswap/screens/tx/widgets/empty_tx_list_item.dart';
import 'package:sideswap/screens/tx/widgets/tx_list_item.dart';

class AssetDetails extends ConsumerStatefulWidget {
  const AssetDetails({super.key});

  @override
  AssetDetailsState createState() => AssetDetailsState();
}

class AssetDetailsState extends ConsumerState<AssetDetails>
    with SingleTickerProviderStateMixin {
  final _hightPercentController = StreamController<double>.broadcast();

  final double _maxExtent = 0.8849;
  final double _minExtent = 0.35;

  double _panelPosition = .0;

  late PanelController _panelController;

  double normalize(double value, double min, double max) {
    return (value - min) / (max - min);
  }

  double heightPercent(double percent, double min, double max) {
    return ((max - min) * percent) + min;
  }

  @override
  void initState() {
    super.initState();
    _panelController = PanelController();
  }

  @override
  void dispose() {
    _hightPercentController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const logoHeightMax = 64.0;
    const logoHeightMin = 36.0;
    const logoPaddingMax = 32.0;
    const logoPaddingMin = 24.0;

    return Stack(
      children: [
        StreamBuilder<double>(
          stream: _hightPercentController.stream,
          builder: (context, snapshot) {
            final percent = snapshot.hasData ? snapshot.data ?? 1.0 : 1.0;
            final logoHeight =
                heightPercent(percent, logoHeightMin, logoHeightMax);
            final logoPadding =
                heightPercent(percent, logoPaddingMin, logoPaddingMax);

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: CustomBackButton(
                    onPressed: () {
                      final uiStateArgs = ref.read(uiStateArgsProvider);
                      uiStateArgs.walletMainArguments =
                          uiStateArgs.walletMainArguments.copyWith(
                              navigationItem:
                                  WalletMainNavigationItem.accounts);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: logoPadding),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final selectedWalletAsset =
                            ref.watch(selectedWalletAssetProvider);
                        final assetId = selectedWalletAsset?.asset;
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
        ),
        Consumer(
          builder: (context, ref, child) {
            final selectedWalletAsset = ref.watch(selectedWalletAssetProvider);
            final allAssets = ref.watch(allAssetsProvider);
            final assetList = allAssets[selectedWalletAsset] ?? <TxItem>[];

            final minimizedPadding = MediaQuery.of(context).padding.top + 40;
            final maximizedPadding = MediaQuery.of(context).padding.top + 70;
            final screenHeight = MediaQuery.of(context).size.height;

            return SlidingUpPanel(
              controller: _panelController,
              backdropEnabled: false,
              parallaxEnabled: false,
              isDraggable: assetList.isEmpty ? false : true,
              minHeight: _minExtent * screenHeight - minimizedPadding,
              maxHeight: _maxExtent * screenHeight - maximizedPadding,
              onPanelSlide: (position) {
                setState(() {
                  _panelPosition = position;
                });

                _hightPercentController.add(1 - position);
              },
              color: SideSwapColors.chathamsBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              header: SizedBox(
                height: 73,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: SizedBox(
                          height: assetList.isNotEmpty ? 32 : 55,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Transactions'.tr(),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (assetList.isEmpty) ...[
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'No transactions yet',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFFAED7FF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: assetList.isNotEmpty,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: MaximizeListButton(
                            position: _panelPosition,
                            onPressed: () {
                              if (_panelPosition == 1) {
                                _panelController.close();
                              } else {
                                _panelController.open();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              panelBuilder: (sc) {
                return Padding(
                  padding: const EdgeInsets.only(top: 68),
                  child: ListView.builder(
                    controller: sc,
                    itemCount: assetList.isNotEmpty ? assetList.length : 2,
                    itemBuilder: (context, index) {
                      return assetList.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TxListItem(
                                assetId: selectedWalletAsset?.asset ?? '',
                                accountType: selectedWalletAsset?.account ??
                                    AccountType.reg,
                                txItem: assetList[index],
                              ),
                            )
                          : const EmptyTxListItem();
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
