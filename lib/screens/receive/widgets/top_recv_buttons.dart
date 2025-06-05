import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/receive_address_providers.dart';

import 'package:sideswap/screens/swap/widgets/swap_button.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class TopRecvButtons extends StatelessWidget {
  const TopRecvButtons({
    super.key,
    required this.onRegularPressed,
    required this.onAmpPressed,
  });

  final _colorToggleBackground = SideSwapColors.prussianBlue;
  final _colorToggleOn = const Color(0xFF1F7EB1);
  final _colorToggleTextOn = const Color(0xFFFFFFFF);
  final _colorToggleTextOff = SideSwapColors.airSuperiorityBlue;
  final VoidCallback onRegularPressed;
  final VoidCallback onAmpPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite, //286.w,
      height: 39,
      decoration: BoxDecoration(
        color: _colorToggleBackground,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final receiveAddress = ref.watch(currentReceiveAddressProvider);
          final isAmp = receiveAddress.account == Account.AMP_;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SwapButton(
                  color: !isAmp ? _colorToggleOn : _colorToggleBackground,
                  text: 'Regular wallet'.tr(),
                  textColor: !isAmp ? _colorToggleTextOn : _colorToggleTextOff,
                  onPressed: onRegularPressed,
                ),
              ),
              Expanded(
                child: SwapButton(
                  color: isAmp ? _colorToggleOn : _colorToggleBackground,
                  text: 'AMP wallet'.tr(),
                  textColor: isAmp ? _colorToggleTextOn : _colorToggleTextOff,
                  onPressed: onAmpPressed,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
