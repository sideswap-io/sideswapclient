import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/accounts/widgets/account_item.dart';

class Accounts extends ConsumerWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncComplete = ref.watch(walletProvider).syncComplete;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24.h),
                child: Row(
                  children: [
                    Text(
                      'Assets'.tr(),
                      style: GoogleFonts.roboto(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ).tr(),
                    const Spacer(),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final wallet = ref.read(walletProvider);
                          final list =
                              exportTxList(wallet.allTxs.values, wallet.assets);
                          final csv = convertToCsv(list);
                          shareCsv(csv);
                        },
                        borderRadius: BorderRadius.circular(21.w),
                        child: Container(
                          width: 42.w,
                          height: 42.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.only(right: 6.w),
                                child: SvgPicture.asset(
                                  'assets/export.svg',
                                  width: 22.w,
                                  height: 21.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          final uiStateArgs = ref.read(uiStateArgsProvider);
                          uiStateArgs.walletMainArguments =
                              uiStateArgs.walletMainArguments.copyWith(
                                  navigationItem:
                                      WalletMainNavigationItem.assetSelect);

                          ref.read(walletProvider).selectAvailableAssets();
                        },
                        borderRadius: BorderRadius.circular(21.w),
                        child: Container(
                          width: 42.w,
                          height: 42.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.only(right: 6.w),
                                child: SvgPicture.asset(
                                  'assets/filter.svg',
                                  width: 22.w,
                                  height: 21.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final wallet = ref.watch(walletProvider);
                      final disabledAccounts = wallet.disabledAccounts;
                      final availableAssets = wallet
                          .getAllAccounts()
                          .where((item) => !disabledAccounts.contains(item))
                          .toList();
                      return ListView(
                        children: List<Widget>.generate(
                          availableAssets.length,
                          (index) {
                            final accountAsset = availableAssets[index];
                            final balance = ref
                                    .watch(balancesProvider)
                                    .balances[accountAsset] ??
                                0;
                            return AccountItem(
                              balance: balance,
                              accountAsset: availableAssets[index],
                              onSelected: (AccountAsset value) {
                                final uiStateArgs =
                                    ref.read(uiStateArgsProvider);
                                uiStateArgs.walletMainArguments =
                                    uiStateArgs.walletMainArguments.copyWith(
                                        navigationItem: WalletMainNavigationItem
                                            .assetDetails);
                                wallet.selectAssetDetails(accountAsset);
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
        if (!syncComplete)
          const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
