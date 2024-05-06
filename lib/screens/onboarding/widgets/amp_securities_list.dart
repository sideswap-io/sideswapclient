import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/amp_securities_item.dart';

class AmpSecuritiesList extends HookConsumerWidget {
  const AmpSecuritiesList({super.key, required this.items});

  final List<SecuritiesItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    return Container(
      decoration: BoxDecoration(
        color: SideSwapColors.blumine,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Listed securities'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: SideSwapColors.cornFlower),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: SizedBox(
                height: 129,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: scrollController,
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverList.builder(
                        itemBuilder: (context, index) {
                          return AmpSecuritiesItem(
                            securitiesItem: items[index],
                          );
                        },
                        itemCount: items.length,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
