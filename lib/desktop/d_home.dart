import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/d_tx_history.dart';
import 'package:sideswap/desktop/widgets/amp_id_panel.dart';
import 'package:sideswap/desktop/widgets/asset_header_item.dart';
import 'package:sideswap/desktop/widgets/download_new_release_button.dart';
import 'package:sideswap/desktop/widgets/subaccount_asset_list.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/app_releases_provider.dart';
import 'package:sideswap/providers/csv_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

class DesktopHome extends HookConsumerWidget {
  const DesktopHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: [
                      Text('Wallet view'.tr(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )),
                      const Spacer(),
                      Consumer(
                        builder: (context, ref, child) {
                          final ampId = ref.watch(ampIdProvider);

                          if (ampId.isNotEmpty) {
                            return AmpIdPanel(
                              ampId: ampId,
                              onTap: () {
                                ref
                                    .read(pageStatusStateProvider.notifier)
                                    .setStatus(Status.ampRegister);
                              },
                            );
                          }

                          return Container();
                        },
                      ),
                      const SizedBox(width: 16),
                      Consumer(
                        builder: (context, ref, child) {
                          final csvNotifier = ref.watch(csvNotifierProvider);
                          final disabled = switch (csvNotifier) {
                            AsyncData(hasValue: true) => false,
                            AsyncError() => false,
                            _ => true,
                          };
                          return DHoverButton(
                            builder: (context, states) {
                              return SvgPicture.asset(
                                'assets/export.svg',
                                width: 17,
                                height: 23,
                                colorFilter: ColorFilter.mode(
                                  disabled
                                      ? SideSwapColors.jellyBean
                                      : Colors.white,
                                  BlendMode.srcIn,
                                ),
                              );
                            },
                            onPressed: disabled
                                ? null
                                : () async {
                                    await ref
                                        .read(csvNotifierProvider.notifier)
                                        .save();
                                  },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(children: [
                    Expanded(
                      child: AssetHeaderitem(text: 'Type of asset'.tr()),
                    ),
                    SizedBox(
                      width: 577,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AssetHeaderitem(text: 'Asset'.tr()),
                          AssetHeaderitem(text: 'Balance'.tr()),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ]),
                ),
                const SizedBox(height: 10),
                const DesktopHomeAssets(),
              ],
            ),
          ),
        ),
        const DesktopHomeBottomPanel(),
      ],
    );
  }
}

class DesktopHomeAssets extends HookConsumerWidget {
  const DesktopHomeAssets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Consumer(
          builder: (context, ref, child) {
            final regularAccounts = ref.watch(regularAccountAssetsProvider);

            return SubAccountAssetList(
              name: 'Regular assets'.tr(),
              accounts: regularAccounts,
            );
          },
        ),
        Consumer(
          builder: (context, ref, child) {
            final ampAccounts = ref.watch(ampAccountAssetsProvider);

            return SubAccountAssetList(
              name: 'AMP assets'.tr(),
              accounts: ampAccounts,
            );
          },
        ),
      ],
    );
  }
}

class DesktopHomeBottomPanel extends HookConsumerWidget {
  const DesktopHomeBottomPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allNewTxSorted = ref.watch(allNewTxsSortedProvider);
    final syncComplete = ref.watch(syncCompleteStateProvider);
    final appReleases = ref.watch(appReleasesProvider);
    final showNewRelease = appReleases.newDesktopReleaseAvailable();
    final showUnconfirmed = allNewTxSorted.isNotEmpty && syncComplete;
    final unconfirmedHeight = min(allNewTxSorted.length, 3) * 40 + 50;

    if (showUnconfirmed) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: const BoxDecoration(
              color: SideSwapColors.blumine,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Unconfirmed transactions'.tr(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: unconfirmedHeight.toDouble(),
                child: const DTxHistory(
                  horizontalPadding: 16,
                  newTxsOnly: true,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (showNewRelease) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: const BoxDecoration(
              color: SideSwapColors.blumine,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              )),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'New app version available: {}. Would you like to download it now?'
                                .tr(args: [appReleases.versionDesktopLatest!]),
                          ),
                          const SizedBox(width: 32),
                          const DownloadNewReleaseButton(yes: true),
                          const SizedBox(width: 8),
                          const DownloadNewReleaseButton(yes: false),
                        ],
                      ),
                      if (appReleases.changesDesktopLatest != null)
                        Text(appReleases.changesDesktopLatest!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container();
  }
}
