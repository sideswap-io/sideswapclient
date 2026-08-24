import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_settings_button.dart';
import 'package:sideswap/providers/wallet_descriptors_gate_provider.dart';
import 'package:sideswap/providers/wallet_descriptors_provider.dart';

/// Desktop settings entry that reveals the watch-only wallet descriptors.
///
/// Shown for every wallet type (software and Jade) -- it is deliberately not
/// wallet-type gated. Disabled until a successful login delivers the
/// descriptors (`walletDescriptorsProvider` is `null`). Tapping the enabled
/// entry runs the access gate, which navigates to the export dialog once the
/// wallet's protection is satisfied.
class DExportDescriptorsButton extends ConsumerWidget {
  const DExportDescriptorsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final descriptors = ref.watch(walletDescriptorsProvider);

    return DSettingsButton(
      title: 'Export watch-only descriptors'.tr(),
      icon: DSettingsButtonIcon.export,
      disabled: descriptors == null,
      onPressed: () {
        ref.read(walletDescriptorsGateProvider).open();
      },
    );
  }
}
