import 'package:easy_localization/easy_localization.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/colored_container.dart';
import 'package:sideswap/desktop/addresses/d_addresses_address_type_popup_menu.dart';
import 'package:sideswap/desktop/addresses/d_addresses_balance_type_popup_menu.dart';
import 'package:sideswap/desktop/addresses/d_addresses_wallet_type_popup_menu.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/d_flexes_row.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/page_storage_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class DAddresses extends HookConsumerWidget {
  const DAddresses({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAddresses = ref.watch(filteredAddressesAsyncProvider);

    useEffect(() {
      Future.microtask(() => ref.invalidate(pageStorageKeyDataProvider));

      return;
    }, const []);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 23),
      child: Column(
        children: [
          Flexible(
            child: switch (filteredAddresses) {
              AsyncValue(isLoading: true) =>
                const Center(child: CircularProgressIndicator()),
              AsyncValue(error: Object()) => Center(
                  child: Text('Error loading addresses'.tr()),
                ),
              AsyncValue(hasValue: true, value: AddressesModel _) =>
                const DAddressesList(),
              _ => const SizedBox(),
            },
          ),
          const SizedBox(height: 16),
          const DAddressesBottomPanel(),
        ],
      ),
    );
  }
}

class DAddressesList extends HookConsumerWidget {
  const DAddressesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAddresses = ref.watch(filteredAddressesAsyncProvider);
    final pageStorageKeyData = ref.watch(pageStorageKeyDataProvider);
    final storageKey = useMemoized(() => PageStorageKey(pageStorageKeyData));
    final flexes = [60, 80, 45, 700, 60, 110];
    final scrollController = useScrollController();

    return switch (filteredAddresses) {
      AsyncValue(hasValue: true, value: AddressesModel addressesModel)
          when addressesModel.addresses != null =>
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: SideSwapColors.cornFlower, fontSize: 12) ??
                    const TextStyle(),
                child: DFlexesRow(flexes: flexes, children: [
                  Text('Wallet'.tr()),
                  Text('Type'.tr()),
                  Text('Index'.tr()),
                  Text('Address'.tr()),
                  Text('Asset'.tr()),
                  Text('Amount'.tr()),
                ]),
              ),
            ),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                child: CustomScrollView(
                  controller: scrollController,
                  key: storageKey,
                  slivers: [
                    SliverList.builder(
                      itemBuilder: (context, index) {
                        return DAddressesListItem(
                          addressesItem: addressesModel.addresses![index],
                          index: index,
                          flexes: flexes,
                        );
                      },
                      itemCount: addressesModel.addresses!.length,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      _ => const SizedBox(),
    };
  }
}

class DAddressesListItem extends ConsumerWidget {
  const DAddressesListItem(
      {required this.addressesItem,
      required this.index,
      required this.flexes,
      super.key});

  final AddressesItem addressesItem;
  final int index;
  final List<int> flexes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesItemHelper =
        ref.watch(addressesItemHelperProvider(addressesItem));
    final buttonStyle = ref
        .watch(desktopAppThemeNotifierProvider)
        .addressDetailsItemButtonStyle();

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: DButton(
        onPressed: () async {
          ref
              .read(addressDetailsDialogNotifierProvider.notifier)
              .setAddressDetailsItem(addressesItemHelper.addressesItem);
          await Navigator.of(context).push(
            RawDialogRoute<Widget>(
              pageBuilder: (_, __, ___) => const DAddressesDetails(),
            ),
          );
        },
        style: buttonStyle,
        child: SizedBox(
          height: 42,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...switch (index) {
                0 => [
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: SideSwapColors.jellyBean,
                    ),
                  ],
                _ => [const SizedBox(height: 1)],
              },
              DFlexesRow(
                flexes: flexes,
                children: [
                  Text(addressesItemHelper.isRegular() ? 'Regular' : 'AMP',
                      textAlign: TextAlign.left),
                  Text(
                      addressesItemHelper.isInternal()
                          ? 'Internal'.tr()
                          : 'External'.tr(),
                      textAlign: TextAlign.left),
                  Text('${addressesItemHelper.addressIndex()}',
                      textAlign: TextAlign.left),
                  ExtendedText(
                    addressesItemHelper.address(),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflowWidget: const TextOverflowWidget(
                      position: TextOverflowPosition.middle,
                      align: TextOverflowAlign.center,
                      child: Text(
                        '...',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: addressesItemHelper.asset(),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: addressesItemHelper.amount(),
                  ),
                ],
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: SideSwapColors.jellyBean,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DAddressesTopPanel extends ConsumerWidget {
  const DAddressesTopPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredContainer(
      width: double.infinity,
      height: 72,
      backgroundColor: SideSwapColors.blumine,
      borderColor: SideSwapColors.blumine,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/liquid_logo.svg',
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 4),
          const Text(
            'Liquid',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class DAddressesDetails extends ConsumerWidget {
  const DAddressesDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme = ref
        .watch(desktopAppThemeNotifierProvider)
        .defaultDialogTheme
        .merge(const DContentDialogThemeData(
            titlePadding:
                EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30)));

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: DContentDialog(
          alignment: Alignment.topCenter,
          title: DContentDialogTitle(
            contentAlignment: Alignment.bottomLeft,
            content: Text(
              'Address details'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            onClose: () {
              Navigator.of(context).pop();
            },
          ),
          content: const Center(
            child: SizedBox(
              height: 279.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    DAddressDetailsHeader(),
                    SizedBox(height: 32),
                    DAddressDetailsColumn(),
                  ],
                ),
              ),
            ),
          ),
          style: const DContentDialogThemeData().merge(defaultDialogTheme),
          constraints: const BoxConstraints(maxWidth: 984, maxHeight: 383),
        ),
      ),
    );
  }
}

class DAddressDetailsHeader extends ConsumerWidget {
  const DAddressDetailsHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressDetailsState = ref.watch(addressDetailsDialogNotifierProvider);
    final buttonStyle = ref
        .watch(desktopAppThemeNotifierProvider)
        .mainBottomNavigationBarButtonStyle;

    return Column(
      children: [
        Row(
          children: [
            Text(
              'Address:'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14, color: SideSwapColors.brightTurquoise),
            ),
            const SizedBox(width: 8),
            SelectableText(
              switch (addressDetailsState) {
                AddressDetailsStateData(
                  addressesItem: AddressesItem addressesItem
                )
                    when addressesItem.address != null =>
                  '${addressesItem.address}',
                _ => '',
              },
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                  ),
            ),
            const Spacer(),
            ...switch (addressDetailsState) {
              AddressDetailsStateData(
                addressesItem: AddressesItem addressesItem
              )
                  when addressesItem.address != null =>
                [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: DButton(
                      style: buttonStyle,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/copy2.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      onPressed: () async {
                        await copyToClipboard(
                          context,
                          addressesItem.address!,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: DButton(
                      style: buttonStyle,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/share3.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      onPressed: () async {
                        final isTestnet =
                            ref.read(envProvider.notifier).isTestnet();
                        final addressUrl = generateAddressUrl(
                            address: addressesItem.address, testnet: isTestnet);
                        await openUrl(addressUrl);
                      },
                    ),
                  ),
                ],
              _ => [const SizedBox()],
            },
            const SizedBox(width: 8),
            SizedBox(
              width: 52,
              child: RichText(
                text: TextSpan(
                  text: '#Tx:'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: SideSwapColors.brightTurquoise,
                      ),
                  children: [
                    ...switch (addressDetailsState) {
                      AddressDetailsStateData(
                        addressesItem: AddressesItem addressesItem
                      )
                          when addressesItem.utxos != null =>
                        [
                          TextSpan(
                            text: ' ${addressesItem.utxos?.length}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 14,
                                ),
                          ),
                        ],
                      _ => [const TextSpan()],
                    }
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Unblinded address:'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14, color: SideSwapColors.brightTurquoise),
            ),
            const SizedBox(width: 8),
            SelectableText(
              switch (addressDetailsState) {
                AddressDetailsStateData(
                  addressesItem: AddressesItem addressesItem
                )
                    when addressesItem.unconfidentialAddress != null =>
                  '${addressesItem.unconfidentialAddress}',
                _ => '',
              },
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                  ),
            ),
            const Spacer(),
            ...switch (addressDetailsState) {
              AddressDetailsStateData(
                addressesItem: AddressesItem addressesItem
              )
                  when addressesItem.unconfidentialAddress != null =>
                [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: DButton(
                      style: buttonStyle,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/copy2.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      onPressed: () async {
                        await copyToClipboard(
                          context,
                          addressesItem.unconfidentialAddress!,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: DButton(
                      style: buttonStyle,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/share2.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      onPressed: () async {
                        final isTestnet =
                            ref.read(envProvider.notifier).isTestnet();
                        final addressUrl = generateAddressUrl(
                            address: addressesItem.unconfidentialAddress,
                            testnet: isTestnet);
                        await openUrl(addressUrl);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  const SizedBox(width: 52),
                ],
              _ => [const SizedBox()],
            },
          ],
        ),
      ],
    );
  }
}

class DAddressDetailsColumn extends HookConsumerWidget {
  const DAddressDetailsColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const flexes = [580, 60, 120, 80, 55, 65];

    final addressDetailsState = ref.watch(addressDetailsDialogNotifierProvider);
    final buttonStyle = ref
        .watch(desktopAppThemeNotifierProvider)
        .mainBottomNavigationBarButtonStyle;

    final scrollController = useScrollController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DefaultTextStyle(
            style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: SideSwapColors.halfBaked) ??
                const TextStyle(),
            child: DFlexesRow(
              flexes: flexes,
              children: [
                Text('Tx'.tr()),
                Text('Asset'.tr()),
                Text('Amount'.tr()),
                Text('Type'.tr()),
                Text('Blinded'.tr()),
                Text('Unblinded'.tr()),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ColoredContainer(
          borderColor: SideSwapColors.chathamsBlue,
          backgroundColor: SideSwapColors.chathamsBlue,
          width: double.infinity,
          height: 127,
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                ...switch (addressDetailsState) {
                  AddressDetailsStateData(
                    addressesItem: AddressesItem addressesItem
                  )
                      when addressesItem.utxos != null =>
                    [
                      SliverList.builder(
                        itemBuilder: (context, index) {
                          final utxo = addressesItem.utxos![index];
                          final assetIcon = ref
                              .watch(assetImageProvider)
                              .getCustomImage(utxo.assetId,
                                  width: 24, height: 24);
                          final precision = ref
                              .watch(assetUtilsProvider)
                              .getPrecisionForAssetId(assetId: utxo.assetId);
                          final amountStr = ref
                              .watch(amountToStringProvider)
                              .amountToString(AmountToStringParameters(
                                  amount: utxo.amount ?? 0,
                                  precision: precision));
                          0;

                          return SizedBox(
                            height: 42,
                            child: DefaultTextStyle(
                              style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 14) ??
                                  const TextStyle(),
                              child: Column(
                                children: [
                                  const Spacer(),
                                  DFlexesRow(
                                    flexes: flexes,
                                    children: [
                                      SelectableText(utxo.txid ?? '',
                                          textAlign: TextAlign.left),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: assetIcon,
                                      ),
                                      SelectableText(amountStr,
                                          textAlign: TextAlign.left),
                                      Text(
                                          utxo.isInternal == true
                                              ? 'Internal'.tr()
                                              : 'External'.tr(),
                                          textAlign: TextAlign.left),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: DButton(
                                            style: buttonStyle?.merge(
                                              DButtonStyle(
                                                padding: ButtonState.all(
                                                    EdgeInsets.zero),
                                              ),
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'assets/share3.svg',
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                            onPressed: () async {
                                              await openTxidUrl(ref,
                                                  utxo.txid ?? '', true, false);
                                            },
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: DButton(
                                            style: buttonStyle?.merge(
                                              DButtonStyle(
                                                padding: ButtonState.all(
                                                    EdgeInsets.zero),
                                              ),
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'assets/share2.svg',
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                            onPressed: () async {
                                              await openTxidUrl(ref,
                                                  utxo.txid ?? '', true, true);
                                            },
                                          ),
                                        ),
                                      ),
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
                            ),
                          );
                        },
                        itemCount: addressesItem.utxos!.length,
                      ),
                    ],
                  _ => [const SizedBox()],
                },
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DAddressesBottomPanel extends StatelessWidget {
  const DAddressesBottomPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredContainer(
      width: double.infinity,
      height: 102,
      backgroundColor: SideSwapColors.blumine,
      borderColor: SideSwapColors.blumine,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          const Row(
            children: [
              DAddressesWalletTypePopupMenu(),
              SizedBox(width: 8),
              DAddressesAddressTypePopupMenu(),
              SizedBox(width: 8),
              DAddressesBalanceTypePopupMenu(),
            ],
          ),
        ],
      ),
    );
  }
}
