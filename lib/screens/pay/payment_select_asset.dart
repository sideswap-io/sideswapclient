import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/accounts/widgets/asset_item.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'payment_select_asset.g.dart';

@riverpod
class PaymentAvailableAssets extends _$PaymentAvailableAssets {
  @override
  Iterable<String> build() {
    return [];
  }

  void setAvailableAssets(Iterable<String> availableAssets) {
    state = availableAssets;
  }
}

@riverpod
class PaymentDisabledAssets extends _$PaymentDisabledAssets {
  @override
  Iterable<String> build() {
    return [];
  }

  void setDisabledAssets(Iterable<String> disabledAssets) {
    state = disabledAssets;
  }
}

@riverpod
bool paymentIsAssetDisabled(Ref ref, String assetId) {
  final disabledAssets = ref.watch(paymentDisabledAssetsProvider);
  return disabledAssets.any((element) => element == assetId);
}

@riverpod
Iterable<String> paymentAvailableAssetsWithInputsFiltered(Ref ref) {
  final allAssets = ref.watch(paymentAvailableAssetsProvider);
  final selectedInputs = ref.watch(selectedInputsNotifierProvider);
  if (selectedInputs.isEmpty) {
    return allAssets;
  }

  return allAssets.where(
    (assetId) => selectedInputs.any((utxoItem) => utxoItem.assetId == assetId),
  );
}

class PaymentSelectAsset extends HookConsumerWidget {
  const PaymentSelectAsset({
    super.key,
    required this.availableAssets,
    required this.onSelected,
    this.disabledAssets = const <String>[],
  });

  final Iterable<String> availableAssets;
  final Iterable<String> disabledAssets;
  final ValueChanged<Asset> onSelected;

  Future<void> popup(BuildContext context) async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAsyncEffect(() async {
      ref
          .read(paymentAvailableAssetsProvider.notifier)
          .setAvailableAssets(availableAssets);
      ref
          .read(paymentDisabledAssetsProvider.notifier)
          .setDisabledAssets(disabledAssets);

      return;
    }, const []);

    return SideSwapScaffold(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          popup(context);
        }
      },
      appBar: CustomAppBar(
        title: 'Select currency'.tr(),
        onPressed: () {
          popup(context);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Flexible(child: PaymentSelectAssetTabBar(onSelected: onSelected)),
          ],
        ),
      ),
    );
  }
}

class PaymentSelectAssetTabBar extends HookConsumerWidget {
  const PaymentSelectAssetTabBar({this.onSelected, super.key});

  final ValueChanged<Asset>? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAccountAssets = ref.watch(
      paymentAvailableAssetsWithInputsFilteredProvider,
    );

    return switch (filteredAccountAssets.isEmpty) {
      true => const SizedBox(),
      _ => Container(
        color: SideSwapColors.chathamsBlue,
        child: PaymentAssetList(onSelected: onSelected),
      ),
    };
  }
}

class PaymentAssetList extends ConsumerWidget {
  const PaymentAssetList({this.onSelected, super.key});

  final ValueChanged<Asset>? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableAssets = ref
        .watch(paymentAvailableAssetsWithInputsFilteredProvider)
        .toList();

    return CustomScrollView(
      slivers: [
        SliverList.builder(
          itemBuilder: (context, index) {
            return Consumer(
              builder: (context, ref, child) {
                final assetId = availableAssets[index];
                final disabled = ref.watch(
                  paymentIsAssetDisabledProvider(assetId),
                );
                final asset = ref.watch(assetsStateProvider)[assetId];

                return switch (asset) {
                  Asset() => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AssetItem(
                      asset: asset,
                      disabled: disabled,
                      backgroundColor: SideSwapColors.blumine,
                      onSelected: (Asset value) {
                        Navigator.of(context).pop();
                        onSelected?.call(value);
                      },
                    ),
                  ),
                  _ => const SizedBox(),
                };
              },
            );
          },
          itemCount: availableAssets.length,
        ),
      ],
    );
  }
}
