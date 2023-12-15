import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/home/widgets/d_background_panel.dart';
import 'package:sideswap/desktop/home/widgets/d_unconfirmed_tx.dart';

class DTxAndOrdersPanel extends StatelessWidget {
  const DTxAndOrdersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return DBackgroundPanel(
      constraints: const BoxConstraints(minHeight: 237, minWidth: 512),
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
        length: 1,
        initialIndex: 0,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
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
                    Text(
                      'Unconfirmed transactions'.tr(),
                    ),
                    // TODO (malcolmpl): Enable when ready
                    // Text(
                    //   'Working orders'.tr(),
                    // ),
                  ],
                ),
              ),
              const Divider(
                color: SideSwapColors.jellyBean,
                height: 1,
                thickness: 0,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: SizedBox(
                  height: 186,
                  child: TabBarView(
                    children: [
                      DUnconfirmedTx(),
                      // TODO (malcolmpl): Enable when ready
                      // DWorkingOrders(),
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
