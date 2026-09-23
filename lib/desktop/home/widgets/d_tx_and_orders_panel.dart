import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/home/listeners/edit_order_error_listener.dart';
import 'package:sideswap/desktop/home/widgets/d_background_panel.dart';
import 'package:sideswap/desktop/home/widgets/d_unconfirmed_tx.dart';
import 'package:sideswap/desktop/home/widgets/d_working_orders.dart';
import 'package:sideswap/desktop/home/widgets/d_working_orders_history.dart';
import 'package:sideswap/desktop/widgets/download_new_release_button.dart';
import 'package:sideswap/models/app_releases.dart';
import 'package:sideswap/providers/app_releases_provider.dart';

/// The height the tab bar takes under the 18 px `labelStyle` below.
///
/// Measured rather than derived: `TabBar` sizes itself from its label text,
/// so this is the one term of [kTxAndOrdersPanelMinHeight] with no literal
/// behind it.
const double _tabBarHeight = 36;

/// The least height [DTxAndOrdersPanel] is ever squeezed to: 6 px of top
/// padding, the tab bar, and a tab body deep enough for the working-orders
/// column header, its 1 px divider and two 43 px order rows.
///
/// Below this the panel would vanish rather than yield, and ADR-0014
/// decision 11 asks for a sensible lower bound on the history panel, not for
/// it to disappear. It does not go lower: at one row the tab bodies' own
/// empty state — a 63 px illustration above its caption — no longer fits the
/// height that leaves them.
const double kTxAndOrdersPanelMinHeight =
    6 + _tabBarHeight + (43 + 1 + 43 + 43);

/// The height the tab body is designed for, and the most it ever takes.
const double _tabBodyHeight = 186;

/// The gap between [DTxAndOrdersPanel] and the panel it shares its page
/// column with, on both pages that carry it.
const double kTxAndOrdersPanelGap = 16;

/// The largest height [DTxAndOrdersPanel] may take inside a page column that
/// must also leave [companionMinHeight] for the panel it shares the column
/// with, the two separated by [gap].
///
/// This is what makes the transactions panel the one that yields: it takes
/// its full height wherever there is room and gives the shortfall to the
/// assets list or the order column as the window shrinks, stopping at
/// [kTxAndOrdersPanelMinHeight]. The result is a height, never a change of
/// tree shape on a threshold — ADR-0014 decision 10.
double txAndOrdersPanelMaxHeight({
  required double available,
  required double gap,
  required double companionMinHeight,
}) =>
    math.max(kTxAndOrdersPanelMinHeight, available - gap - companionMinHeight);

class DTxAndOrdersPanel extends HookConsumerWidget {
  const DTxAndOrdersPanel({super.key, this.onlyWorkingOrders = false});

  final bool onlyWorkingOrders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appReleasesStateAsync = ref.watch(appReleasesStateProvider);
    final showNewReleaseAsync = ref.watch(showNewReleaseFutureProvider);
    var tabsLength = onlyWorkingOrders ? 2 : 3;

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

    final controller = useTabController(
      initialLength: tabsLength,
      keys: [tabsLength],
    );

    return Stack(
      children: [
        const EditOrderErrorListener(),
        DBackgroundPanel(
          constraints: const BoxConstraints(
            minHeight: kTxAndOrdersPanelMinHeight,
            minWidth: 512,
          ),
          decoration: const ShapeDecoration(
            color: SideSwapColors.chathamsBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            // `MainAxisSize.min` keeps the panel at its design height wherever
            // there is room: the column takes the height of its children, not
            // of the bound its parent gives it, so a page with room to spare
            // looks exactly as it does today.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TabBar(
                    controller: controller,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    indicatorColor: SideSwapColors.brightTurquoise,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: const EdgeInsets.only(left: 8, bottom: 8),
                    unselectedLabelColor: SideSwapColors.cornFlower,
                    labelColor: Colors.white,
                    dividerHeight: 1,
                    dividerColor: SideSwapColors.jellyBean,
                    indicatorPadding: EdgeInsets.zero,
                    labelStyle: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                    unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                    tabs: [
                      if (showNewRelease) ...[Text('New app release'.tr())],
                      if (!onlyWorkingOrders) ...[
                        Text('Unconfirmed transactions'.tr()),
                      ],
                      Text('Working orders'.tr()),
                      Text('Transactions'.tr()),
                    ],
                  ),
                ),
                // `Flexible` is what lets the panel yield: with room the tab
                // body takes its whole design height and the panel looks
                // exactly as it does at the design window; under a shorter
                // bound the body gives the difference back rather than
                // overflowing. The parent must bound the panel's height, and
                // both call sites do — see [txAndOrdersPanelMaxHeight].
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: SizedBox(
                      height: _tabBodyHeight,
                      child: TabBarView(
                        controller: controller,
                        children: [
                          if (showNewRelease) ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: CustomScrollView(
                                slivers: [
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'New app version available: {}. Would you like to download it now?'
                                                  .tr(
                                                    args: [
                                                      appReleases
                                                              ?.desktop
                                                              ?.version ??
                                                          '',
                                                    ],
                                                  ),
                                            ),
                                            const SizedBox(width: 32),
                                            const DownloadNewReleaseButton(
                                              yes: true,
                                            ),
                                            const SizedBox(width: 8),
                                            const DownloadNewReleaseButton(
                                              yes: false,
                                            ),
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
                          if (!onlyWorkingOrders) ...[const DUnconfirmedTx()],
                          DWorkingOrders(),
                          DWorkingHistoryOrders(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
