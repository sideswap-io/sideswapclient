import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/settings/settings_security.dart';
import 'package:sideswap/screens/settings/widgets/settings_button.dart';
import 'package:sideswap/screens/settings/widgets/settings_delete_wallet_dialog.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Settings'.tr(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: SettingsButton(
                  type: SettingsButtonType.recovery,
                  text: 'View my recovery phrase'.tr(),
                  onPressed: () {
                    context.read(walletProvider).settingsViewBackup();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: SettingsButton(
                  type: SettingsButtonType.about,
                  text: 'About us'.tr(),
                  onPressed: () {
                    context.read(walletProvider).settingsViewAboutUs();
                  },
                ),
              ),
              SettingsSecurity(),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 48.w),
                child: SettingsButton(
                  type: SettingsButtonType.delete,
                  text: 'Delete wallet',
                  transparent: true,
                  onPressed: () {
                    showDeleteWalletDialog(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
