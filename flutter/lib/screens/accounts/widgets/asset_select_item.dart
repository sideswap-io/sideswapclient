import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';

class AssetSelectItem extends ConsumerWidget {
  final AccountAsset account;
  const AssetSelectItem({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = ref.watch(assetImageProvider).getBigImage(account.asset);
    final asset =
        ref.watch(assetsStateProvider.select((value) => value[account.asset]));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 71,
        child: Material(
          color: SideSwapColors.chathamsBlue,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              await ref.read(walletProvider).toggleAssetVisibility(account);
            },
            child: AbsorbPointer(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: icon,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                asset?.name ?? '',
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  asset?.ticker ?? '',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF6B91A8),
                                  ),
                                ),
                                if (account.account.isAmp()) const AmpFlag()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final wallet = ref.read(walletProvider);
                        final balances = ref.watch(balancesProvider);
                        final selected = !wallet.disabledAssetAccount(account);
                        final liquidAssetId = ref.watch(liquidAssetIdProvider);
                        final forceEnabled =
                            (account.account == AccountType.reg &&
                                    account.asset == liquidAssetId) ||
                                (balances.balances[account] ?? 0) > 0;

                        return FlutterSwitch(
                          value: selected || forceEnabled,
                          disabled: forceEnabled,
                          onToggle: (val) {},
                          width: 51,
                          height: 31,
                          toggleSize: 27,
                          padding: 2,
                          activeColor: SideSwapColors.brightTurquoise,
                          inactiveColor: const Color(0xFF164D6A),
                          toggleColor: Colors.white,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
