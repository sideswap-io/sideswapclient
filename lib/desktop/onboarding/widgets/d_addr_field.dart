import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/desktop/common/decorations/d_side_swap_paste_icon_input_decoration.dart';
import 'package:sideswap/desktop/main/providers/d_send_popup_providers.dart';
import 'package:sideswap/providers/wallet.dart';

class DAddrTextField extends ConsumerWidget {
  final TextEditingController? controller;
  final bool autofocus;
  final FocusNode? focusNode;

  const DAddrTextField({
    super.key,
    this.controller,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(sendPopupAddressNotifierProvider);
    final errorText = ref
        .watch(walletProvider)
        .commonAddrErrorStr(address, AddrType.elements);

    if (address.isNotEmpty && errorText.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          color: SideSwapColors.chathamsBlue,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
        child: Row(
          children: [
            Expanded(child: Text(address)),
            const SizedBox(width: 8),
            DIconButton(
              icon: SvgPicture.asset(
                'assets/close3.svg',
                width: 14,
                height: 14,
              ),
              onPressed: () {
                controller?.text = '';
              },
            ),
          ],
        ),
      );
    }

    return TextField(
      focusNode: focusNode,
      controller: controller,
      decoration: DSideSwapPasteIconInputDecoration(
        hintText: 'Address'.tr(),
        errorText: errorText.isEmpty ? null : errorText,
        onPastePressed: () async {
          await handlePasteSingleLine(controller);
        },
      ),
      autofocus: autofocus,
      style: const TextStyle(color: Colors.black),
      inputFormatters: [
        alphaNumFormatter,
      ],
    );
  }
}
