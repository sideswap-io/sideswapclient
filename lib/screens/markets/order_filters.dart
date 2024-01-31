import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/orders_panel_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class OrderFilters extends ConsumerWidget {
  const OrderFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      backgroundColor: SideSwapColors.chathamsBlue,
      sideSwapBackground: false,
      appBar: AppBar(
        backgroundColor: SideSwapColors.chathamsBlue,
        flexibleSpace: SafeArea(
          child: SizedBox(
            height: kToolbarHeight,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: kToolbarHeight,
                      child: CustomBackButton(
                        color: SideSwapColors.freshAir,
                        onPressed: () {
                          ref.read(walletProvider).goBack();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Filters'.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(letterSpacing: 0.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              OrderTypeFilter(),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderTypeFilter extends ConsumerWidget {
  const OrderTypeFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: ShapeDecoration(
        color: SideSwapColors.blueSapphire,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      height: 94,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order type',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: SideSwapColors.brightTurquoise),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OrderTypeFilterButton(
                  text: 'All'.tr(),
                  buttonType: const RequestOrderSortFlagAll(),
                  onPressed: () {
                    ref
                        .read(requestOrderSortFlagNotifierProvider.notifier)
                        .setSortFlag(const RequestOrderSortFlagAll());
                  },
                ),
                OrderTypeFilterButton(
                  text: 'Offline'.tr(),
                  buttonType: const RequestOrderSortFlagOffline(),
                  onPressed: () {
                    ref
                        .read(requestOrderSortFlagNotifierProvider.notifier)
                        .setSortFlag(const RequestOrderSortFlagOffline());
                  },
                ),
                OrderTypeFilterButton(
                  text: 'Online'.tr(),
                  buttonType: const RequestOrderSortFlagOnline(),
                  onPressed: () {
                    ref
                        .read(requestOrderSortFlagNotifierProvider.notifier)
                        .setSortFlag(const RequestOrderSortFlagOnline());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderTypeFilterButton extends ConsumerWidget {
  const OrderTypeFilterButton({
    super.key,
    this.text,
    required this.buttonType,
    this.onPressed,
  });

  final String? text;
  final RequestOrderSortFlag buttonType;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestOrderSortFlag =
        ref.watch(requestOrderSortFlagNotifierProvider);

    return CustomBigButton(
      width: 100,
      height: 32,
      text: text,
      textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: requestOrderSortFlag == buttonType
                ? Colors.white
                : SideSwapColors.ceruleanFrost,
          ),
      backgroundColor: requestOrderSortFlag == buttonType
          ? SideSwapColors.brightTurquoise
          : SideSwapColors.blueSapphire,
      side: BorderSide(
        color: requestOrderSortFlag == buttonType
            ? Colors.transparent
            : SideSwapColors.ceruleanFrost,
      ),
      onPressed: onPressed,
    );
  }
}
