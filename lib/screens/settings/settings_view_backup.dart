import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:secure_application/secure_application.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/mnemonic_table.dart';

class SettingsViewBackup extends StatefulWidget {
  const SettingsViewBackup({Key? key}) : super(key: key);

  @override
  _SettingsViewBackupState createState() => _SettingsViewBackupState();
}

class _SettingsViewBackupState extends State<SettingsViewBackup> {
  SecureApplicationController? lockController;
  @override
  void initState() {
    lockController = SecureApplicationProvider.of(context, listen: false);
    lockController?.secure();
    super.initState();
  }

  @override
  void dispose() {
    lockController?.open();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Recovery phrase'.tr(),
      ),
      body: SafeArea(
        child: Consumer(builder: (context, watch, child) {
          final mnemonicWords = watch(walletProvider).getMnemonicWords();
          final words = List<ValueNotifier<String>>.generate(
              mnemonicWords.length, (index) => ValueNotifier(''));
          var index = 0;
          for (var word in mnemonicWords) {
            words[index].value = word;
            index++;
          }
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Your ${words.length} word recovery phrase is your wallets backup. Write it down and store it somewhere safe, preferably offline.'
                        .tr(),
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              MnemonicTable(
                onCheckError: (index) {
                  return false;
                },
                currentSelectedItem: -1,
                onCheckField: (index) {
                  return true;
                },
                words: words,
              ),
            ],
          );
        }),
      ),
    );
  }
}
