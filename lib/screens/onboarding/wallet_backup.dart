import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:secure_application/secure_application_provider.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/mnemonic_table.dart';

class WalletBackup extends HookConsumerWidget {
  const WalletBackup({Key? key}) : super(key: key);

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
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 38.h, left: 16.w, right: 56.w),
            child: SizedBox(
              width: 303.w,
              height: 56.h,
              child: Text(
                'Save your 12 word recovery phrase'.tr(),
                style: GoogleFonts.roboto(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24.h, left: 16.w, right: 16.w),
            child: Text(
              'Please ensure you write down and save your 12 word recovery phrase. Without your recovery phrase, there is no way to restore access to your wallet and all balances will be irretrievably lost without recourse.'
                  .tr(),
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
            child: Text(
              'Remember to always keep a copy safely stored offline.'.tr(),
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 32.h),
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
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 40.h, left: 16.w, right: 16.w),
            child: CustomBigButton(
              width: double.maxFinite,
              height: 54.h,
              text: 'CONFIRM YOUR WORDS'.tr(),
              backgroundColor: const Color(0xFF00C5FF),
              onPressed: () {
                ref.read(walletProvider).backupNewWalletCheck();
              },
            ),
          ),
        ],
      ),
    );
  }
}
