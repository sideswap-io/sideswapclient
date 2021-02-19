import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/models/tx_item.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/accounts/widgets/asset_details_header.dart';
import 'package:sideswap/screens/accounts/widgets/maximize_list_button.dart';
import 'package:sideswap/screens/tx/widgets/empty_tx_list_item.dart';
import 'package:sideswap/screens/tx/widgets/tx_list_item.dart';
import 'package:sliding_panel/sliding_panel.dart';

class AssetDetails extends StatefulWidget {
  AssetDetails({Key key}) : super(key: key);

  @override
  _AssetDetailsState createState() => _AssetDetailsState();
}

class _AssetDetailsState extends State<AssetDetails>
    with SingleTickerProviderStateMixin {
  final _hightPercentController = StreamController<double>.broadcast();

  static final double _maxExtent = 0.8849;
  static final double _minExtent = 0.4433;

  bool _isExpanded = false;
  PanelController _panelController;

  String _ticker;
  Map<String, List<TxItem>> _txItemMap;

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
    _ticker = context.read(walletProvider).selectedWalletAsset;
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
            final percent = snapshot.hasData ? snapshot.data : 1.0;
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
                          final ticker =
                              watch(walletProvider).selectedWalletAsset ??
                                  kLiquidBitcoinTicker;
                          final assetImagesBig =
                              watch(walletProvider).assetImagesBig[ticker];
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
            _ticker = watch(walletProvider).selectedWalletAsset;
            _txItemMap = watch(walletProvider).txItemMap;
            final assetList = _txItemMap[_ticker] ?? <TxItem>[];

            return SlidingPanel(
              panelController: _panelController,
              isDraggable: assetList.isEmpty ? false : true,
              decoration: PanelDecoration(
                backgroundColor: Color(0xFF135579),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.w),
                  topRight: Radius.circular(16.w),
                ),
              ),
              content: PanelContent(
                headerWidget: PanelHeaderWidget(
                  headerContent: Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 24.h, bottom: 18.h),
                      child: Container(
                        height: assetList.isNotEmpty ? 28.h : 50.h,
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
                            Visibility(
                              visible: assetList.isNotEmpty,
                              child: MaximizeListButton(
                                isExpanded: _isExpanded,
                                onPressed: () {
                                  if (_isExpanded) {
                                    _panelController.close();
                                    setState(() {
                                      _isExpanded = false;
                                    });
                                  } else {
                                    _panelController.expand();
                                    setState(() {
                                      _isExpanded = true;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  decoration: PanelDecoration(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    backgroundColor: Color(0xFF135579),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.w),
                      topRight: Radius.circular(16.w),
                    ),
                  ),
                  options: PanelHeaderOptions(
                    elevation: 0,
                  ),
                ),
                panelContent: assetList.isNotEmpty
                    ? List.generate(
                        assetList.length,
                        (index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: TxListItem(
                            ticker: _ticker,
                            txItem: assetList[index],
                          ),
                        ),
                      )
                    : List.generate(
                        2,
                        (index) => EmptyTxListItem(),
                      ),
              ),
              size: PanelSize(
                closedHeight: _minExtent,
                collapsedHeight: _minExtent,
                expandedHeight: _maxExtent,
              ),
              duration: Duration(milliseconds: 200),
              onPanelSlide: (value) {
                if (value == _maxExtent && !_isExpanded) {
                  setState(() {
                    _isExpanded = true;
                  });
                }

                if (value == _minExtent && _isExpanded) {
                  setState(() {
                    _isExpanded = false;
                  });
                }
                var newPercent = normalize(value, _maxExtent, _minExtent);
                _hightPercentController.add(newPercent);
              },
            );
          },
        ),
      ],
    );
  }
}
