import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/screens/accounts/widgets/account_item.dart';

class PaymentSelectAccount extends StatelessWidget {
  const PaymentSelectAccount({
    Key? key,
    required this.availableAssets,
    required this.onSelected,
    this.disabledAssets = const <AccountAsset>[],
  }) : super(key: key);

  final List<AccountAsset> availableAssets;
  final List<AccountAsset> disabledAssets;
  final ValueChanged<AccountAsset> onSelected;

  Future<bool> popup(BuildContext context) async {
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      onWillPop: () => popup(context),
      appBar: CustomAppBar(
        title: 'Select currency'.tr(),
        onPressed: () {
          popup(context);
        },
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Consumer(
                      builder: (context, watch, child) {
                        return ListView(
                          children: List<Widget>.generate(
                            availableAssets.length,
                            (index) {
                              final accountAsset = availableAssets[index];
                              final balance = watch(balancesProvider)
                                      .balances[accountAsset] ??
                                  0;
                              final asset = availableAssets[index];
                              final disabled = disabledAssets.contains(asset);
                              return AccountItem(
                                balance: balance,
                                accountAsset: asset,
                                disabled: disabled,
                                onSelected: (AccountAsset value) {
                                  popup(context);
                                  onSelected(value);
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}