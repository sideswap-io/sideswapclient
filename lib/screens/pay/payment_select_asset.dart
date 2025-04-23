import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/screens/accounts/widgets/account_item.dart';

part 'payment_select_asset.g.dart';
part 'payment_select_asset.freezed.dart';

@freezed
sealed class PaymentAccountType with _$PaymentAccountType {
  const factory PaymentAccountType.all() = PaymentAccountTypeAll;
  const factory PaymentAccountType.regular() = PaymentAccountTypeRegular;
  const factory PaymentAccountType.amp() = PaymentAccountTypeAmp;
  const factory PaymentAccountType.btc() = PaymentAccountTypeBtc;
}

@riverpod
class PaymentAvailableAssets extends _$PaymentAvailableAssets {
  @override
  List<AccountAsset> build() {
    return [];
  }

  void setAvailableAssets(List<AccountAsset> availableAssets) {
    state = availableAssets;
  }
}

@riverpod
class PaymentDisabledAssets extends _$PaymentDisabledAssets {
  @override
  List<AccountAsset> build() {
    return [];
  }

  void setDisabledAssets(List<AccountAsset> disabledAssets) {
    state = disabledAssets;
  }
}

@riverpod
List<PaymentAccountType> paymentAssetTypes(Ref ref) {
  final filteredAccountAssets = ref.watch(
    paymentAvailableAssetsWithInputsFilteredProvider,
  );
  final paymentAccountTypes = <PaymentAccountType>[];
  if (filteredAccountAssets.isNotEmpty) {
    paymentAccountTypes.add(const PaymentAccountType.all());
  }

  if (filteredAccountAssets.any((element) => element.account.isRegular)) {
    paymentAccountTypes.add(const PaymentAccountType.regular());
  }

  if (filteredAccountAssets.any((element) => element.account.isAmp)) {
    paymentAccountTypes.add(const PaymentAccountType.amp());
  }

  // keep at least one type
  if (paymentAccountTypes.isEmpty) {
    paymentAccountTypes.add(const PaymentAccountType.all());
  }

  return paymentAccountTypes;
}

@riverpod
bool paymentIsAssetDisabled(Ref ref, AccountAsset accountAsset) {
  final disabledAssets = ref.watch(paymentDisabledAssetsProvider);
  return disabledAssets.any((element) => element == accountAsset);
}

@riverpod
List<AccountAsset> paymentAvailableAssetsWithInputsFiltered(Ref ref) {
  final allAssets = ref.watch(paymentAvailableAssetsProvider);
  final selectedInputs = ref.watch(selectedInputsNotifierProvider);
  if (selectedInputs.isEmpty) {
    return allAssets;
  }

  return allAssets
      .where(
        (element) => selectedInputs.any(
          (si) =>
              si.assetId == element.assetId && si.account == element.account.id,
        ),
      )
      .toList();
}

@riverpod
List<AccountAsset> paymentAccountAssetsByType(
  Ref ref,
  PaymentAccountType paymentAccountType,
) {
  final filteredAccountAssets = ref.watch(
    paymentAvailableAssetsWithInputsFilteredProvider,
  );

  return switch (paymentAccountType) {
    PaymentAccountTypeAll() => filteredAccountAssets,
    PaymentAccountTypeRegular() =>
      filteredAccountAssets
          .where((element) => element.account.isRegular)
          .toList(),
    PaymentAccountTypeAmp() =>
      filteredAccountAssets.where((element) => element.account.isAmp).toList(),
    PaymentAccountTypeBtc() => [],
  };
}

class PaymentSelectAsset extends HookConsumerWidget {
  const PaymentSelectAsset({
    super.key,
    required this.availableAssets,
    required this.onSelected,
    this.disabledAssets = const <AccountAsset>[],
  });

  final List<AccountAsset> availableAssets;
  final List<AccountAsset> disabledAssets;
  final ValueChanged<AccountAsset> onSelected;

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

  final ValueChanged<AccountAsset>? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAccountAssets = ref.watch(
      paymentAvailableAssetsWithInputsFilteredProvider,
    );
    final assetTypes = ref.watch(paymentAssetTypesProvider);

    return switch (filteredAccountAssets.isEmpty) {
      true => const SizedBox(),
      _ => DefaultTabController(
        length: assetTypes.length,
        initialIndex: 0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                indicatorColor: SideSwapColors.brightTurquoise,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: const EdgeInsets.only(right: 20, bottom: 9),
                unselectedLabelColor: SideSwapColors.cornFlower,
                labelColor: Colors.white,
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                tabs: [
                  ...assetTypes.map(
                    (e) => switch (e) {
                      PaymentAccountTypeAll() => const Text('All'),
                      PaymentAccountTypeRegular() => const Text('Regular'),
                      PaymentAccountTypeAmp() => const Text('AMP'),
                      PaymentAccountTypeBtc() => const Text('BTC'),
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              color: SideSwapColors.jellyBean,
              height: 1,
              thickness: 0,
            ),
            Flexible(
              child: Container(
                color: SideSwapColors.chathamsBlue,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 8),
                  child: TabBarView(
                    children: [
                      ...assetTypes.map(
                        (e) => switch (e) {
                          _ => PaymentAssetList(
                            dPaymentAccountType: e,
                            onSelected: onSelected,
                          ),
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    };
  }
}

class PaymentAssetList extends ConsumerWidget {
  const PaymentAssetList({
    required this.dPaymentAccountType,
    this.onSelected,
    super.key,
  });

  final PaymentAccountType dPaymentAccountType;
  final ValueChanged<AccountAsset>? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAssets = ref.watch(
      paymentAccountAssetsByTypeProvider(dPaymentAccountType),
    );

    return CustomScrollView(
      slivers: [
        SliverList.builder(
          itemBuilder: (context, index) {
            return Consumer(
              builder: (context, ref, child) {
                final accountAsset = accountAssets[index];
                final disabled = ref.watch(
                  paymentIsAssetDisabledProvider(accountAsset),
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AccountItem(
                    accountAsset: accountAsset,
                    disabled: disabled,
                    backgroundColor: SideSwapColors.blumine,
                    onSelected: (AccountAsset value) {
                      Navigator.of(context).pop();
                      onSelected?.call(value);
                    },
                  ),
                );
              },
            );
          },
          itemCount: accountAssets.length,
        ),
      ],
    );
  }
}
