import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/trimming_input_formatter.dart';
import 'package:sideswap/desktop/common/d_text_icon_container.dart';
import 'package:sideswap/desktop/common/decorations/d_side_swap_paste_icon_input_decoration.dart';
import 'package:sideswap/desktop/main/providers/d_send_popup_providers.dart';

class DAddrTextField extends ConsumerWidget {
  final TextEditingController? controller;
  final bool autofocus;
  final FocusNode? focusNode;
  final void Function()? onPressed;
  final double? height;

  const DAddrTextField({
    super.key,
    this.controller,
    this.autofocus = false,
    this.focusNode,
    this.onPressed,
    this.height = 98,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parseAddressResult = ref.watch(sendPopupParseAddressProvider);
    final address = parseAddressResult.match((l) => '', (r) => r.address);
    final errorText =
        address.isNotEmpty
            ? parseAddressResult.match((l) => false, (r) => true)
                ? ''
                : 'Invalid address'.tr()
            : '';

    return SizedBox(
      height: height,
      child: switch (address.isNotEmpty && errorText.isEmpty) {
        true => DTextIconContainer(
          height: height,
          text: address,
          onPressed: () {
            controller?.text = '';
            onPressed?.call();
          },
        ),
        _ => Column(
          children: [
            TextField(
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
              inputFormatters: [TrimmingTextInputFormatter()],
            ),
          ],
        ),
      },
    );
  }
}
