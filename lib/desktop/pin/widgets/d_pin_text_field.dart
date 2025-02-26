import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/decorations/d_side_swap_input_decoration.dart';
import 'package:sideswap/desktop/pin/widgets/d_pin_icon_button.dart';

class DPinTextField extends HookConsumerWidget {
  const DPinTextField({
    super.key,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType = TextInputType.number,
    this.inputFormatters,
    this.enabled = true,
    this.pin = '',
    this.error = false,
    this.errorMessage = '',
    this.autofocus = false,
  });

  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final String pin;
  final bool error;
  final String errorMessage;
  final bool autofocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final obscureText = useState(true);

    controller.text = pin;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return SizedBox(
      width: 344,
      height: 69,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: AbsorbPointer(
          absorbing: enabled ? false : true,
          child: TextField(
            autofocus: true,
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText.value,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            enabled: enabled,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            decoration: DSideSwapInputDecoration(
              isDense: true,
              errorText: errorMessage.isEmpty ? null : errorMessage,
              suffixIcon: DPinIconButton(
                obscureText: obscureText.value,
                onPressed: () {
                  obscureText.value = !obscureText.value;
                },
              ),
              focusedBorder:
                  error
                      ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: SideSwapColors.bitterSweet,
                        ),
                        gapPadding: 0,
                      )
                      : null,
            ),
            onChanged: onChanged,
            onSubmitted: onSubmitted,
          ),
        ),
      ),
    );
  }
}
