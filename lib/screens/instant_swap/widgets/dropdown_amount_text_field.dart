import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/instant_swap/widgets/d_max_button.dart';
import 'package:sideswap/desktop/main/d_payment_select_asset.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/instant_swap/widgets/amount_text_field.dart';
import 'package:sideswap/screens/instant_swap/widgets/asset_ticker_button.dart';
import 'package:sideswap/screens/instant_swap/widgets/max_button.dart';
import 'package:sideswap/screens/pay/payment_select_asset.dart';

class DropdownAmountTextField extends HookConsumerWidget {
  const DropdownAmountTextField({
    this.controller,
    this.focusNode,
    required this.accountAssets,
    required this.accountAsset,
    this.label,
    this.hideDivider = false,
    this.bottomLabel,
    this.disabledAmount = false,
    this.disabledDropdown = false,
    this.errorText,
    this.showMaxButton = false,
    this.showBalance = true,
    this.onMaxPressed,
    this.onAccountAssetChanged,
    this.onChanged,
    this.balanceAlignment,
    super.key,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<AccountAsset> accountAssets;
  final AccountAsset accountAsset;
  final Widget? label;
  final Widget? bottomLabel;
  final bool hideDivider;
  final bool disabledAmount;
  final bool disabledDropdown;
  final String? errorText;
  final bool showMaxButton;
  final bool showBalance;
  final void Function()? onMaxPressed;
  final void Function(AccountAsset accountAsset)? onAccountAssetChanged;
  final void Function(String value)? onChanged;
  final MainAxisAlignment? balanceAlignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasFocus = useState(false);
    final textFieldFocusNode = focusNode ?? useFocusNode();

    final assetImageRepostory = ref.watch(assetImageRepositoryProvider);
    final optionAsset = ref.watch(
      assetFromAssetIdProvider(accountAsset.assetId),
    );

    final icon = useMemoized(() {
      return assetImageRepostory.getSmallImage(accountAsset.assetId);
    }, [accountAsset, assetImageRepostory]);

    useEffect(() {
      textFieldFocusNode.addListener(() {
        if (!context.mounted) {
          return;
        }

        if (disabledAmount) {
          return;
        }

        hasFocus.value = textFieldFocusNode.hasFocus;
      });

      return;
    }, const []);

    final selectAssetCallback = useCallback(() async {
      final dialogRoute = switch (FlavorConfig.isDesktop) {
        true => DialogRoute(
          barrierColor: Colors.transparent,
          builder: (context) {
            return DPaymentSelectAsset(
              availableAssets: accountAssets,
              disabledAssets: [],
              onSelected: (value) {
                onAccountAssetChanged?.call(value);
              },
            );
          },
          context: context,
        ),
        _ => MaterialPageRoute(
          builder: (context) {
            return PaymentSelectAsset(
              availableAssets: accountAssets,
              disabledAssets: [],
              onSelected: (AccountAsset value) {
                onAccountAssetChanged?.call(value);
              },
            );
          },
        ),
      };

      await Navigator.of(context, rootNavigator: true).push<void>(dialogRoute);
    }, [accountAssets]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        switch (label) {
          Widget label => label,
          _ => const SizedBox(),
        },
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: switch (hideDivider) {
              true => null,
              _ => Border(
                bottom: BorderSide(
                  color: switch (errorText) {
                    String() when !disabledAmount => SideSwapColors.bitterSweet,
                    _ => switch (hasFocus.value) {
                      true when !disabledAmount =>
                        SideSwapColors.brightTurquoise,
                      _ => SideSwapColors.jellyBean,
                    },
                  },
                  style: BorderStyle.solid,
                  width: 1,
                ),
              ),
            },
          ),
          child: Row(
            children: [
              AssetTickerButton(
                onPressed: switch (disabledDropdown) {
                  true => null,
                  _ => selectAssetCallback,
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon,
                    SizedBox(width: 8),
                    optionAsset.match(
                      () => const SizedBox(),
                      (asset) => Text(
                        asset.ticker,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    switch (disabledDropdown) {
                      true => const SizedBox(),
                      _ => const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    },
                  ],
                ),
              ),
              Flexible(
                child: optionAsset.match(
                  () => const SizedBox(),
                  (asset) => AmountTextField(
                    controller: controller,
                    focusNode: textFieldFocusNode,
                    precision: asset.precision,
                    disabledAmount: disabledAmount,
                    onChanged: onChanged,
                  ),
                ),
              ),
              if (showMaxButton) ...[
                SizedBox(width: 16),
                ...switch (FlavorConfig.isDesktop) {
                  true => [
                    DMaxButton(width: 51, height: 21, onPressed: onMaxPressed),
                  ],
                  _ => [
                    MaxButton(width: 54, height: 24, onPressed: onMaxPressed),
                  ],
                },
              ],
            ],
          ),
        ),
        switch (errorText) {
          String errorText => Tooltip(
            message: errorText,
            child: SelectableText(
              errorText,
              maxLines: 1,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          _ => const SizedBox(),
        },
        switch (showBalance) {
          true => Align(
            alignment: Alignment.centerRight,
            child: DropdownAmountBalanceLine(accountAsset: accountAsset),
          ),
          false => const SizedBox(),
        },
        bottomLabel ?? SizedBox(),
      ],
    );
  }
}

class DropdownAmountBalanceLine extends ConsumerWidget {
  final AccountAsset accountAsset;
  final MainAxisAlignment balanceAlignment;

  const DropdownAmountBalanceLine({
    required this.accountAsset,
    this.balanceAlignment = MainAxisAlignment.end,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetBalance = ref.watch(
      totalMaxAvailableBalanceForAssetAsStringProvider(accountAsset.assetId),
    );

    final textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: 13,
      color: SideSwapColors.airSuperiorityBlue,
    );

    final balanceHint = 'Balance'.tr();
    final asset =
        ref.watch(assetFromAssetIdProvider(accountAsset.assetId)).toNullable();

    return Column(
      children: [
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: balanceAlignment,
          children: [
            Text('$balanceHint:', style: textStyle),
            Row(
              children: [
                const SizedBox(width: 4),
                SelectableText(assetBalance, style: textStyle),
                const SizedBox(width: 4),
                Consumer(
                  builder: (context, ref, _) {
                    final icon = ref
                        .watch(assetImageRepositoryProvider)
                        .getSmallImage(accountAsset.assetId);

                    return SizedBox(width: 16, height: 16, child: icon);
                  },
                ),
                const SizedBox(width: 4),
                Text(asset?.ticker ?? '', style: textStyle),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
