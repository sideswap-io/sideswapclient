import 'package:flutter/material.dart';

class PinTextField extends StatefulWidget {
  const PinTextField({
    super.key,
    this.pin = '',
    this.focusNode,
    this.onTap,
    this.enabled = true,
    this.error = false,
    this.errorMessage = '',
  });

  final String pin;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool enabled;
  final bool error;
  final String errorMessage;

  @override
  PinTextFieldState createState() => PinTextFieldState();
}

class PinTextFieldState extends State<PinTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.text = widget.pin;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
    return SizedBox(
      height: widget.error && widget.errorMessage.isNotEmpty ? 83 : 61,
      child: Column(
        children: [
          Opacity(
            opacity: widget.enabled ? 1.0 : 0.5,
            child: AbsorbPointer(
              absorbing: widget.enabled ? false : true,
              child: GestureDetector(
                onTap: widget.onTap,
                child: AbsorbPointer(
                  child: TextField(
                    controller: controller,
                    focusNode: widget.focusNode,
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
                      focusedBorder:
                          widget.error
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
          if (widget.error && widget.errorMessage.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.errorMessage,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 12,
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
