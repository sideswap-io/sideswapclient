import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/markets/d_markets_root.dart';

class MarketSelectPopup extends StatelessWidget {
  const MarketSelectPopup({
    super.key,
    required this.selectedAssetId,
    required this.onAssetSelected,
  });

  final String selectedAssetId;
  final ValueChanged<String> onAssetSelected;

  Future<bool> popup(BuildContext context) async {
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      onWillPop: () => popup(context),
      appBar: CustomAppBar(
        title: 'Product'.tr(),
        onPressed: () {
          popup(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: ProductColumns(
            selectedAssetId: selectedAssetId,
            onAssetSelected: (assetId) {
              onAssetSelected(assetId);
              popup(context);
            },
          ),
        ),
      ),
    );
  }
}
