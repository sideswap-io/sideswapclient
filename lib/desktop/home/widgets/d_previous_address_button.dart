import 'package:easy_localization/easy_localization.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap/providers/selected_account_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class DPreviousAddressButton extends HookConsumerWidget {
  const DPreviousAddressButton({
    super.key,
    this.onButtonPressed,
    this.onTextPressed,
  });

  final VoidCallback? onButtonPressed;
  final VoidCallback? onTextPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountType = ref.watch(selectedAccountTypeNotifierProvider);
    final receiveAddress = ref.watch(currentReceiveAddressProvider);

    final regularAccountAddressess = ref.watch(regularAccountAddressesProvider);

    useEffect(() {
      if (regularAccountAddressess.isEmpty &&
          receiveAddress.recvAddress.isEmpty) {
        Future.microtask(() {
          ref
              .read(selectedAccountTypeNotifierProvider.notifier)
              .setAccountType(AccountType.reg);
          ref.read(walletProvider).toggleRecvAddrType(selectedAccountType);
        });
      } else if (receiveAddress.recvAddress.isNotEmpty &&
          receiveAddress.accountType == AccountType.reg) {
        Future.microtask(() => ref
            .read(regularAccountAddressesProvider.notifier)
            .insertAddress(receiveAddress));
      }

      return;
    }, [receiveAddress]);

    final buttonStyle = ref
        .watch(desktopAppThemeNotifierProvider)
        .mainBottomNavigationBarButtonStyle;

    return Container(
      height: 36,
      decoration: const BoxDecoration(
        color: SideSwapColors.blumine,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onTextPressed,
              child: Row(
                children: [
                  Text(
                    'Address:'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 318,
                    child: switch (regularAccountAddressess.isEmpty) {
                      true => const SizedBox(),
                      _ => ExtendedText(
                          regularAccountAddressess.last.recvAddress,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflowWidget: TextOverflowWidget(
                            position: TextOverflowPosition.middle,
                            align: TextOverflowAlign.center,
                            child: Text(
                              '...',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 32,
            height: 32,
            child: DButton(
              style: buttonStyle,
              onPressed: onButtonPressed,
              child: Center(
                child: SvgPicture.asset(
                  'assets/prev_address.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
