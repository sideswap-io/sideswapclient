import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:secure_application/secure_application_provider.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/mnemonic_table.dart';

class WalletBackup extends HookConsumerWidget {
  const WalletBackup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockController =
        useMemoized(() => SecureApplicationProvider.of(context, listen: false));
    useEffect(() {
      lockController?.secure();
      return () {
        lockController?.open();
      };
    });

    return SideSwapPopup(
      enableInsideHorizontalPadding: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 38, left: 16, right: 56),
              child: SizedBox(
                width: 303,
                height: 56,
                child: Text(
                  'Save your 12 word recovery phrase'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
              child: Text(
                'Please ensure you write down and save your 12 word recovery phrase. Without your recovery phrase, there is no way to restore access to your wallet and all balances will be irretrievably lost without recourse.'
                    .tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text(
                'Remember to always keep a copy safely stored offline.'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Consumer(
                builder: (context, ref, child) {
                  final words = <ValueNotifier<String>>[];
                  ref.watch(walletProvider).getMnemonicWords().forEach((e) {
                    words.add(ValueNotifier<String>(e));
                  });
                  return MnemonicTable(
                    onCheckField: (_) {
                      return true;
                    },
                    onCheckError: (_) {
                      return false;
                    },
                    currentSelectedItem: -1,
                    words: words,
                  );
                },
              ),
            ),
            // const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 16, right: 16),
              child: CustomBigButton(
                width: double.maxFinite,
                height: 54,
                text: 'CONFIRM YOUR WORDS'.tr(),
                backgroundColor: const Color(0xFF00C5FF),
                onPressed: () {
                  ref.read(walletProvider).backupNewWalletCheck();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
