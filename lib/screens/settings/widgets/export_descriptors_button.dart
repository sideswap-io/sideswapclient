import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/wallet_descriptors_gate_provider.dart';
import 'package:sideswap/providers/wallet_descriptors_provider.dart';
import 'package:sideswap/screens/settings/widgets/settings_button.dart';

/// Settings entry that reveals the watch-only wallet descriptors.
///
/// Shown for every wallet type (software and Jade) -- it is deliberately not
/// wallet-type gated. Disabled until a successful login delivers the
/// descriptors (`walletDescriptorsProvider` is `null`). Tapping the enabled
/// entry runs the access gate, which navigates to the descriptors screen once
/// the wallet's protection is satisfied.
class ExportDescriptorsButton extends ConsumerWidget {
  const ExportDescriptorsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final descriptors = ref.watch(walletDescriptorsProvider);

    return SettingsButton(
      type: SettingsButtonType.export,
      text: 'Export watch-only descriptors'.tr(),
      disabled: descriptors == null,
      onPressed: () {
        ref.read(walletDescriptorsGateProvider).open();
      },
    );
  }
}
