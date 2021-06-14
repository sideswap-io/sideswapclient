import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/models/tx_item.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/accounts/widgets/asset_details_header.dart';
import 'package:sideswap/screens/accounts/widgets/maximize_list_button.dart';
import 'package:sideswap/screens/tx/widgets/empty_tx_list_item.dart';
import 'package:sideswap/screens/tx/widgets/tx_list_item.dart';

class AssetDetails extends StatefulWidget {
  AssetDetails({Key? key}) : super(key: key);

  @override
  _AssetDetailsState createState() => _AssetDetailsState();
}

class _AssetDetailsState extends State<AssetDetails>
    with SingleTickerProviderStateMixin {
  final _hightPercentController = StreamController<double>.broadcast();

  final double _maxExtent = 0.8849;
  final double _minExtent = 0.4433;

  bool _isExpanded = false;
  late PanelController _panelController;

  String _assetId = '';
  Map<String, List<TxItem>> _txItemMap = <String, List<TxItem>>{};

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
    _assetId = context.read(walletProvider).selectedWalletAsset;
    _txItemMap = context.read(walletProvider).txItemMap;
  }

  @override
  void dispose() {
    _hightPercentController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoHeightMax = 64.w;
    final logoHeightMin = 36.w;
    final logoPaddingMax = 32.h;
    final logoPaddingMin = 24.h;

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

            return Container(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: CustomBackButton(
                      onPressed: () {
                        final uiStateArgs = context.read(uiStateArgsProvider);
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
                        builder: (context, watch, child) {
                          final wallet = watch(walletProvider);
                          final assetId = wallet.selectedWalletAsset.isNotEmpty
                              ? wallet.selectedWalletAsset
                              : wallet.bitcoinAssetId();
                          final assetImagesBig =
                              watch(walletProvider).assetImagesBig[assetId];
                          return Container(
                            width: logoHeight,
                            height: logoHeight,
                            child: assetImagesBig,
                          );
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 106.h),
                      child: AssetDetailsHeader(
                        percent: percent,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Consumer(
          builder: (context, watch, child) {
            _assetId = watch(walletProvider).selectedWalletAsset;
            _txItemMap = watch(walletProvider).txItemMap;
            final assetList = _txItemMap[_assetId] ?? <TxItem>[];

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
                if (position == 1.0) {
                  setState(() {
                    _isExpanded = true;
                  });
                }

                if (position == 0 && _isExpanded) {
                  setState(() {
                    _isExpanded = false;
                  });
                }

                _hightPercentController.add(1 - position);
              },
              color: Color(0xFF135579),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.w),
                topRight: Radius.circular(16.w),
              ),
              header: Container(
                height: 68.h,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Container(
                          height: assetList.isNotEmpty ? 28.h : 50.h,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Transactions'.tr(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (assetList.isEmpty) ...[
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10.h),
                                        child: Text(
                                          'No transactions yet',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xFFAED7FF),
                                          ),
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
                          padding: EdgeInsets.only(right: 3.w),
                          child: MaximizeListButton(
                            isExpanded: _isExpanded,
                            onPressed: () {
                              if (_isExpanded) {
                                _panelController.close();
                                setState(() {
                                  _isExpanded = false;
                                });
                              } else {
                                _panelController.open();
                                setState(() {
                                  _isExpanded = true;
                                });
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
                  padding: EdgeInsets.only(top: 68.h),
                  child: ListView.builder(
                    controller: sc,
                    itemCount: assetList.isNotEmpty ? assetList.length : 2,
                    itemBuilder: (context, index) {
                      return assetList.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: TxListItem(
                                assetId: _assetId,
                                txItem: assetList[index],
                              ),
                            )
                          : EmptyTxListItem();
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
