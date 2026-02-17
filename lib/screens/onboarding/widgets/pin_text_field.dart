import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PinTextField extends HookConsumerWidget {
  const PinTextField({
    super.key,
    this.pin = '',
    this.focusNode,
    this.onTap,
    this.enabled = true,
    this.error = false,
    this.errorMessage = '',
    this.attempt = 0,
  });

  final String pin;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool enabled;
  final bool error;
  final String errorMessage;
  final int attempt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: pin);

    useEffect(() {
      controller.text = pin;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );

      return;
    }, [pin]);

    return SizedBox(
      height: error && errorMessage.isNotEmpty ? 160 : 61,
      child: Column(
        children: [
          Opacity(
            opacity: enabled ? 1.0 : 0.5,
            child: AbsorbPointer(
              absorbing: enabled ? false : true,
              child: GestureDetector(
                onTap: onTap,
                child: AbsorbPointer(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    readOnly: true,
                    obscureText: true,
                    showCursor: true,
                    cursorColor: Colors.black,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    cursorHeight: 20,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 18, 10, 18),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: error
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.red),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (error && errorMessage.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.only(top: attempt == 2 ? 16 : 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    fontSize: attempt == 2 ? 16 : 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
