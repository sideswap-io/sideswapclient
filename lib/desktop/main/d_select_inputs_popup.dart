import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/common/widgets/animated_dropdown_arrow.dart';
import 'package:sideswap/common/widgets/colored_container.dart';
import 'package:sideswap/common/widgets/custom_check_box.dart';
import 'package:sideswap/common/widgets/middle_elipsis_text.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/main/widgets/d_select_inputs_wallet_type_flag_popup_menu.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/d_flexes_row.dart';
import 'package:sideswap/providers/addresses_providers.dart';

class DSelectInputsPopup extends HookConsumerWidget {
  const DSelectInputsPopup({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme = ref
        .watch(desktopAppThemeNotifierProvider)
        .dialogTheme
        .merge(
          const DContentDialogThemeData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: SideSwapColors.blumine,
            ),
          ),
        );

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 1040, maxHeight: 808),
      style: defaultDialogTheme,
      title: DContentDialogTitle(
        content: Text('Select inputs'.tr()),
        onClose: () {
          Navigator.of(context).pop();
        },
      ),
      content: SizedBox(
        height: 712,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DInputsListHeader(),
            const SizedBox(height: 12),
            const Divider(
              height: 1,
              thickness: 1,
              color: SideSwapColors.jellyBean,
            ),
            const DInputsList(),
            SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet:'.tr(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: SideSwapColors.brightTurquoise,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const DSelectInputsWalletTypeFlagPopupMenu(),
                  ],
                ),
              ),
            ),
            const Spacer(),
            const DInputsDetails(),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                const textColor = SideSwapColors.turquoise;

                return Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Network fees will be visible on the transaction review screen.'
                              .tr(),
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(color: textColor),
                        ),
                      ],
                    ),
                    const Spacer(),
                    DCustomButton(
                      width: 245,
                      height: 44,
                      isFilled: true,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('CONTINUE'.tr()),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class DInputsListHeader extends StatelessWidget {
  const DInputsListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DFlexesRow(
      flexes: const [865, 132, 132],
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            Consumer(
              builder: (context, ref, child) {
                final inputsAddresses = ref.watch(inputsAddressesAsyncProvider);
                final selectedInputsHelper = ref.watch(
                  selectedInputsHelperProvider,
                );

                return switch (inputsAddresses) {
                  AsyncValue(
                    hasValue: true,
                    value: AddressesModel addressesModel,
                  ) =>
                    CustomCheckBox(
                      value: selectedInputsHelper.containsModel(addressesModel),
                      onChecked: (value) {
                        if (value) {
                          ref
                              .read(selectedInputsNotifierProvider.notifier)
                              .addAllItemsFromModel(addressesModel);
                          return;
                        }

                        ref
                            .read(selectedInputsNotifierProvider.notifier)
                            .removeAll();
                      },
                    ),
                  _ => const SizedBox(),
                };
              },
            ),
            const SizedBox(width: 10),
            Text(
              'Address/Hash'.tr(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: SideSwapColors.cornFlower,
              ),
            ),
          ],
        ),
        Text(
          'Asset'.tr(),
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: SideSwapColors.cornFlower),
        ),
        Text(
          'Balance'.tr(),
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: SideSwapColors.cornFlower),
        ),
      ],
    );
  }
}

class DInputsDetails extends StatelessWidget {
  const DInputsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 254,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inputs details'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(),
          ColoredContainer(
            height: 224,
            theme: ColoredContainerStyle(
              backgroundColor: SideSwapColors.chathamsBlue,
              borderColor: SideSwapColors.chathamsBlue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction inputs:'.tr(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: SideSwapColors.brightTurquoise,
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final selectedInputsHelper = ref.watch(
                          selectedInputsHelperProvider,
                        );

                        return Text(
                          '${selectedInputsHelper.count()}',
                          style: Theme.of(context).textTheme.titleSmall,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: SideSwapColors.jellyBean,
                ),
                const SizedBox(height: 8),
                Text(
                  'Total amounts:'.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.brightTurquoise,
                  ),
                ),
                const SizedBox(height: 4),
                ColoredContainer(
                  theme: ColoredContainerStyle(
                    backgroundColor: SideSwapColors.chathamsBlue.lerpWith(
                      Colors.black,
                      0.1,
                    ),
                    borderColor: SideSwapColors.chathamsBlue.lerpWith(
                      Colors.black,
                      0.1,
                    ),
                  ),
                  child: const DInputsTotalAmountList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DInputsTotalAmountList extends HookConsumerWidget {
  const DInputsTotalAmountList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flexes = [800, 130];

    final scrollController = useScrollController();

    return SizedBox(
      height: 135,
      child: Column(
        children: [
          SizedBox(
            height: 16,
            child: DFlexesRow(
              flexes: flexes,
              children: [
                Text(
                  'Asset'.tr(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: SideSwapColors.cornFlower,
                  ),
                ),
                Text(
                  'Balance'.tr(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: SideSwapColors.cornFlower,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(
            height: 1,
            thickness: 1,
            color: SideSwapColors.jellyBean,
          ),
          Consumer(
            builder: (context, ref, child) {
              final selectedInputsHelper = ref.watch(
                selectedInputsHelperProvider,
              );
              final totalAmounts = selectedInputsHelper.totalAmounts();

              return Flexible(
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: scrollController,
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverList.builder(
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 36,
                            child: Column(
                              children: [
                                const Spacer(),
                                DFlexesRow(
                                  flexes: flexes,
                                  children: [
                                    Row(
                                      children: [
                                        totalAmounts[index].asset,
                                        const SizedBox(width: 6),
                                        Text(totalAmounts[index].ticker),
                                      ],
                                    ),
                                    Text(totalAmounts[index].amount),
                                  ],
                                ),
                                const Spacer(),
                                const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: SideSwapColors.jellyBean,
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: totalAmounts.length,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DInputsList extends HookConsumerWidget {
  const DInputsList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputsAddresses = ref.watch(inputsAddressesAsyncProvider);

    final scrollController = useScrollController();

    return Container(
      constraints: const BoxConstraints(minHeight: 76, maxHeight: 307),
      child: Column(
        children: [
          Flexible(
            child: switch (inputsAddresses) {
              AsyncValue(isLoading: true) => const Center(
                child: CircularProgressIndicator(
                  color: SideSwapColors.brightTurquoise,
                ),
              ),
              AsyncValue(error: Object()) => Center(
                child: Text('Error loading inputs'.tr()),
              ),
              AsyncValue(
                hasValue: true,
                value: AddressesModel addressesModel,
              ) =>
                Scrollbar(
                  thumbVisibility: true,
                  controller: scrollController,
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverList.builder(
                        itemBuilder: (context, index) {
                          return DInputsListItem(
                            addressesItem: addressesModel.addresses![index],
                          );
                        },
                        itemCount: addressesModel.addresses?.length,
                      ),
                    ],
                  ),
                ),
              _ => const SizedBox(),
            },
          ),
        ],
      ),
    );
  }
}

class DInputsListItem extends HookConsumerWidget {
  const DInputsListItem({
    super.key,
    required this.addressesItem,
    this.height = 43,
  });

  final AddressesItem addressesItem;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = ref.watch(
      inputListItemExpandedStateProvider(addressesItem.hashCode),
    );

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
      initialValue: expanded ? 1 : 0,
    );

    final Animation<double> heightFactor = useMemoized(() {
      return animationController.drive(CurveTween(curve: Curves.easeIn));
    }, [animationController]);

    useEffect(() {
      if (expanded) {
        animationController.forward();
        return;
      }

      animationController.reverse();
      return;
    }, [expanded]);

    final drawProductColumns = useState<bool>(false);

    useEffect(() {
      animationController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          drawProductColumns.value = false;
          return;
        }

        if (!drawProductColumns.value) {
          drawProductColumns.value = true;
        }
      });

      return;
    }, [animationController]);

    return SizedBox(
      height:
          expanded == true
              ? height * (addressesItem.utxos!.length) + height
              : height,
      child: Column(
        children: [
          DHoverButton(
            builder: (context, states) {
              return Container(
                height: height,
                color:
                    expanded ? SideSwapColors.chathamsBlue : Colors.transparent,
                child: Column(
                  children: [
                    const Spacer(),
                    DFlexesRow(
                      flexes: const [865, 132, 132],
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Consumer(
                              builder: (context, ref, child) {
                                final selectedInputsHelper = ref.watch(
                                  selectedInputsHelperProvider,
                                );

                                return CustomCheckBox(
                                  value: selectedInputsHelper.containsAll(
                                    addressesItem.utxos,
                                  ),
                                  onChecked: (value) {
                                    if (value) {
                                      ref
                                          .read(
                                            selectedInputsNotifierProvider
                                                .notifier,
                                          )
                                          .addAllItems(addressesItem.utxos);
                                      return;
                                    }

                                    ref
                                        .read(
                                          selectedInputsNotifierProvider
                                              .notifier,
                                        )
                                        .removeAllItems(addressesItem.utxos);
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 350,
                                  child: MiddleEllipsisText(
                                    text: addressesItem.address ?? '',
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(fontSize: 14),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                AnimatedDropdownArrow(
                                  target: expanded ? 1 : 0,
                                  initFrom: expanded ? 1 : 0,
                                  iconColor:
                                      expanded
                                          ? SideSwapColors.brightTurquoise
                                          : Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(),
                        const SizedBox(),
                      ],
                    ),
                    const Spacer(),
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 150),
                      padding: EdgeInsets.only(left: expanded ? 39 : 0),
                      child: const Divider(
                        height: 1,
                        thickness: 1,
                        color: SideSwapColors.jellyBean,
                      ),
                    ),
                  ],
                ),
              );
            },
            onPressed: () {
              ref
                  .read(inputListItemExpandedStatesNotifierProvider.notifier)
                  .updateState(addressesItem.hashCode, !expanded);
            },
          ),
          Flexible(
            child: AnimatedBuilder(
              animation: animationController.view,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    heightFactor: heightFactor.value,
                    child: child,
                  ),
                );
              },
              child: DInputsListItemTx(
                expanded: expanded,
                addressesItem: addressesItem,
                height: height,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DInputsListItemTx extends StatelessWidget {
  const DInputsListItemTx({
    super.key,
    required this.expanded,
    required this.addressesItem,
    required this.height,
  });

  final bool expanded;
  final AddressesItem addressesItem;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: expanded ? SideSwapColors.chathamsBlue : Colors.transparent,
      child: Column(
        children: [
          ...List.generate(addressesItem.utxos?.length ?? 0, ((index) {
            return HookConsumer(
              builder: (context, ref, child) {
                final selectedInputs = ref.watch(
                  selectedInputsNotifierProvider,
                );
                final selectedInputsHelper = ref.watch(
                  selectedInputsHelperProvider,
                );

                final checkboxValue = useState(false);

                useEffect(() {
                  checkboxValue.value = selectedInputsHelper.contains(
                    addressesItem.utxos?[index],
                  );

                  return;
                }, [selectedInputs]);
                return DHoverButton(
                  builder: (context, states) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 39),
                      child: SizedBox(
                        height: height - 1, // 1 pixel for divider at the bottom
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            DFlexesRow(
                              flexes: const [804, 156, 135],
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 10),
                                    AbsorbPointer(
                                      child: CustomCheckBox(
                                        value: checkboxValue.value,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      addressesItem.utxos?[index].txid ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(fontSize: 14),
                                    ),
                                  ],
                                ),
                                Consumer(
                                  builder: (context, ref, child) {
                                    final selectedInputsHelper = ref.watch(
                                      selectedInputsHelperProvider,
                                    );

                                    return Row(
                                      children: [
                                        selectedInputsHelper.utxoAsset(
                                          utxo: addressesItem.utxos?[index],
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          selectedInputsHelper.utxoTicker(
                                            utxo: addressesItem.utxos?[index],
                                          ),
                                        ),
                                        selectedInputsHelper.utxoAccount(
                                          utxo: addressesItem.utxos?[index],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                Consumer(
                                  builder: (context, ref, child) {
                                    final selectedInputsHelper = ref.watch(
                                      selectedInputsHelperProvider,
                                    );

                                    return Text(
                                      selectedInputsHelper.utxoAmount(
                                        utxo: addressesItem.utxos?[index],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            ...switch (expanded) {
                              true
                                  when index + 1 !=
                                      addressesItem.utxos?.length =>
                                [
                                  const Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: SideSwapColors.jellyBean,
                                  ),
                                ],
                              _ => [const SizedBox()],
                            },
                          ],
                        ),
                      ),
                    );
                  },
                  onPressed: () {
                    if (!checkboxValue.value) {
                      ref
                          .read(selectedInputsNotifierProvider.notifier)
                          .addItem(addressesItem.utxos?[index]);
                      return;
                    }

                    ref
                        .read(selectedInputsNotifierProvider.notifier)
                        .removeItem(addressesItem.utxos?[index]);
                  },
                );
              },
            );
          })),
          const Spacer(),
          const Divider(
            height: 1,
            thickness: 1,
            color: SideSwapColors.jellyBean,
          ),
        ],
      ),
    );
  }
}
