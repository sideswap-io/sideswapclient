import 'package:flutter/material.dart';
import 'package:sideswap/desktop/home/widgets/d_asset_list_tile.dart';
import 'package:sideswap/models/account_asset.dart';

class DAssetsList extends StatelessWidget {
  const DAssetsList({
    super.key,
    required this.accountAssets,
  });

  final List<AccountAsset> accountAssets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 7),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return DAssetListTile(accountAsset: accountAssets[index]);
              },
              childCount: accountAssets.length,
            ),
          ),
        ],
      ),
    );
  }
}
