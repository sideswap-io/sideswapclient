import 'package:flutter/material.dart';
import 'package:sideswap/desktop/home/widgets/d_asset_list_tile.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DAssetsList extends StatelessWidget {
  const DAssetsList({super.key, required this.assets});

  final Iterable<Asset> assets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return DAssetListTile(asset: assets.elementAt(index));
            }, childCount: assets.length),
          ),
        ],
      ),
    );
  }
}
