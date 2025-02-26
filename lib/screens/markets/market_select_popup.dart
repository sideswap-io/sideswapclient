import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/markets/widgets/product_columns.dart';

class MarketSelectPopup extends StatelessWidget {
  const MarketSelectPopup({super.key, this.onAssetSelected});

  final VoidCallback? onAssetSelected;

  Future<void> popup(BuildContext context) async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      canPop: true,
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
            onMarketSelected: () {
              if (onAssetSelected != null) {
                onAssetSelected!();
              }
              popup(context);
            },
          ),
        ),
      ),
    );
  }
}
