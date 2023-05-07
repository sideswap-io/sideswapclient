import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';

class SubAccountAssetList extends HookConsumerWidget {
  const SubAccountAssetList({
    Key? key,
    required this.name,
    required this.isAmp,
    required this.accounts,
  }) : super(key: key);

  final String name;
  final bool isAmp;
  final List<AccountAsset> accounts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = useState(true);
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 200),
      initialValue: 1,
    );

    final Animation<double> heightFactor = useMemoized(() {
      return controller.drive(CurveTween(curve: Curves.easeIn));
    }, [controller]);

    useEffect(() {
      if (expanded.value) {
        controller.forward();
        return;
      }

      controller.reverse();
      return;
    }, [expanded.value]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color:
                expanded.value ? const Color(0xB50F577A) : Colors.transparent,
            border: Border.all(
              color: const Color(0xFF2E7CA7),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    expanded.value
                        ? 'assets/arrow_down.svg'
                        : 'assets/arrow_up.svg',
                  ),
                  const Spacer(),
                ],
              ),
            ),
            onPressed: () {
              expanded.value = !expanded.value;
            },
          ),
        ),
        AnimatedBuilder(
          animation: controller.view,
          builder: (context, child) {
            return ClipRRect(
              child: Align(
                heightFactor: heightFactor.value,
                child: Center(
                  child: SizedBox(
                    width: 577,
                    child: Column(
                      children: List.generate(
                        accounts.length,
                        (index) {
                          return SubAccountAssetTile(
                              account: accounts[index],
                              showDivider: index < accounts.length - 1);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}

class SubAccountAssetTile extends StatelessWidget {
  const SubAccountAssetTile(
      {super.key, required this.account, this.showDivider = false});

  final AccountAsset account;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DHoverButton(
          builder: (context, states) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final icon = ref.watch(assetImageProvider).getSmallImage(
                          account.asset,
                          filterQuality: FilterQuality.medium);

                      return icon;
                    },
                  ),
                  const SizedBox(width: 8),
                  Consumer(
                    builder: (context, ref, child) {
                      final asset = ref.watch(assetsStateProvider
                          .select((value) => value[account.asset]));

                      return Text(
                        asset?.ticker ?? '',
                        style: const TextStyle(fontSize: 16),
                      );
                    },
                  ),
                  const Spacer(),
                  Consumer(
                    builder: (context, ref, child) {
                      final balance =
                          ref.watch(balancesProvider).balances[account] ?? 0;
                      final asset = ref.watch(assetsStateProvider
                          .select((value) => value[account.asset]));
                      final balanceStr = ref
                          .watch(amountToStringProvider)
                          .amountToString(AmountToStringParameters(
                              amount: balance,
                              precision: asset?.precision ?? 0));
                      return Text(
                        balanceStr,
                        style: const TextStyle(fontSize: 16),
                      );
                    },
                  ),
                ],
              ),
            );
          },
          onPressed: () {
            desktopOpenAccount(context, account);
          },
        ),
        if (showDivider) ...[
          Container(
            height: 1,
            color: SideSwapColors.jellyBean,
          ),
        ],
      ],
    );
  }
}
