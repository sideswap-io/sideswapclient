import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/screens/markets/market_charts.dart';

class MarketChartsPopup extends StatelessWidget {
  const MarketChartsPopup({
    super.key,
    required this.assetId,
  });

  final String? assetId;

  Future<void> popup(BuildContext context) async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          popup(context);
        }
      },
      appBar: CustomAppBar(
        title: 'Chart'.tr(),
        onPressed: () {
          popup(context);
        },
      ),
      body: SafeArea(
        child: MarketCharts(
          assetId: assetId,
          onBackPressed: () {
            popup(context);
          },
        ),
      ),
    );
  }
}
