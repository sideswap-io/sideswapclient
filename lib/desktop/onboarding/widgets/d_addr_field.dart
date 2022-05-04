import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/desktop/widgets/d_side_swap_input_decoration.dart';
import 'package:sideswap/models/wallet.dart';

class DAddrTextField extends ConsumerStatefulWidget {
  const DAddrTextField({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.autofocus = false,
  }) : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  @override
  _DAddrTextFieldState createState() => _DAddrTextFieldState();
}

class _DAddrTextFieldState extends ConsumerState<DAddrTextField> {
  String getErrorText() {
    return ref
        .read(walletProvider)
        .commonAddrErrorStr(widget.controller.text, AddrType.elements);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorText = getErrorText();

    if (widget.controller.text.isNotEmpty && errorText.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF135579),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
        child: Row(
          children: [
            Expanded(child: Text(widget.controller.text)),
            const SizedBox(width: 8),
            DIconButton(
              icon: SvgPicture.asset(
                'assets/close3.svg',
                width: 14,
                height: 14,
              ),
              onPressed: () {
                setValue(widget.controller, '');
                widget.onChanged(widget.controller.text);
              },
            ),
          ],
        ),
      );
    }

    return TextField(
      controller: widget.controller,
      decoration: DSideSwapInputDecoration(
        hintText: 'Address',
        errorText: errorText.isEmpty ? null : errorText,
        onPastePressed: () async {
          await handlePasteSingleLine(widget.controller);
          setState(() {});
          widget.onChanged(widget.controller.text);
        },
      ),
      onChanged: (value) {
        widget.onChanged(widget.controller.text);
      },
      autofocus: widget.autofocus,
      style: const TextStyle(color: Colors.black),
    );
  }
}
