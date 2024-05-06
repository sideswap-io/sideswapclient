import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/home/widgets/d_background_panel.dart';
import 'package:sideswap/desktop/home/widgets/d_unconfirmed_tx.dart';
import 'package:sideswap/desktop/home/widgets/d_working_orders.dart';
import 'package:sideswap/desktop/widgets/download_new_release_button.dart';
import 'package:sideswap/models/app_releases.dart';
import 'package:sideswap/providers/app_releases_provider.dart';

class DTxAndOrdersPanel extends ConsumerWidget {
  const DTxAndOrdersPanel({super.key, this.onlyWorkingOrders = false});

  final bool onlyWorkingOrders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO (malcolmpl): check in flutter higher than 3.19.6 if it's still crashing when tabs are changed
    // https://github.com/flutter/flutter/issues/144087

    final appReleasesStateAsync = ref.watch(appReleasesStateNotifierProvider);
    final showNewReleaseAsync = ref.watch(showNewReleaseFutureProvider);
    var tabsLength = onlyWorkingOrders ? 1 : 2;

    final appReleases = switch (appReleasesStateAsync) {
      AsyncValue(hasValue: true, value: AppReleasesModelState modelState)
          when modelState is AppReleasesModelStateData =>
        () {
          return modelState.model;
        }(),
      _ => null,
    };

    final showNewRelease = switch (showNewReleaseAsync) {
      AsyncValue(hasValue: true, value: bool showNewRelease) => showNewRelease,
      _ => false,
    };

    if (showNewRelease) {
      tabsLength = tabsLength + 1;
    }

    return DBackgroundPanel(
      constraints: const BoxConstraints(minHeight: 227, minWidth: 512),
      decoration: const ShapeDecoration(
        color: SideSwapColors.chathamsBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
      ),
      child: DefaultTabController(
        length: tabsLength,
        initialIndex: 0,
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  indicatorColor: SideSwapColors.brightTurquoise,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: const EdgeInsets.all(8),
                  unselectedLabelColor: SideSwapColors.cornFlower,
                  labelColor: Colors.white,
                  labelStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                  unselectedLabelStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                  tabs: [
                    if (showNewRelease) ...[
                      Text(
                        'New app release'.tr(),
                      ),
                    ],
                    if (!onlyWorkingOrders) ...[
                      Text(
                        'Unconfirmed transactions'.tr(),
                      ),
                    ],
                    Text(
                      'Working orders'.tr(),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: SideSwapColors.jellyBean,
                height: 1,
                thickness: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SizedBox(
                  height: 186,
                  child: TabBarView(
                    children: [
                      if (showNewRelease) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: CustomScrollView(
                            slivers: [
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'New app version available: {}. Would you like to download it now?'
                                              .tr(args: [
                                            appReleases?.desktop?.version ?? '',
                                          ]),
                                        ),
                                        const SizedBox(width: 32),
                                        const DownloadNewReleaseButton(
                                            yes: true),
                                        const SizedBox(width: 8),
                                        const DownloadNewReleaseButton(
                                            yes: false),
                                      ],
                                    ),
                                    if (appReleases?.desktop?.changes !=
                                        null) ...[
                                      Text(
                                        appReleases!.desktop!.changes!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (!onlyWorkingOrders) ...[
                        const DUnconfirmedTx(),
                      ],
                      const DWorkingOrders(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
