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
    this.autofocus = false,
  });

  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final String pin;

  /// Draws the red border. The message itself belongs to the screen, in a box
  /// of its own outside this field's fixed height. ADR-0013 decision 8.
  final bool error;
  final bool autofocus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final obscureText = useState(true);

    // Keyed on `error` as well as `pin`: a mismatch changes no digit, and the
    // caret has to come back to the end so the user can fix a wrong one with
    // backspace. ADR-0013 decision 5.
    useEffect(() {
      controller.text = pin;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
      return;
    }, [pin, error]);

    return Column(
      children: [
        SizedBox(
          width: 344,
          height: 49,
          child: Opacity(
            opacity: enabled ? 1.0 : 0.5,
            child: AbsorbPointer(
              absorbing: !enabled,
              child: TextField(
                autofocus: autofocus,
                // Stated, not inherited: the platform default selects the whole
                // value on focus on desktop, and has changed before.
                selectAllOnFocus: false,
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
                  suffixIcon: DPinIconButton(
                    obscureText: obscureText.value,
                    onPressed: () {
                      obscureText.value = !obscureText.value;
                    },
                  ),
                  focusedBorder: error
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
        ),
      ],
    );
  }
}
