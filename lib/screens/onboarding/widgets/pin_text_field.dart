import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';

class PinTextField extends StatefulWidget {
  PinTextField({
    Key key,
    this.pin,
    this.focusNode,
    this.onTap,
    this.enabled = true,
    this.error = false,
    this.errorMessage = '',
  }) : super(key: key);

  final String pin;
  final FocusNode focusNode;
  final VoidCallback onTap;
  final bool enabled;
  final bool error;
  final String errorMessage;

  @override
  _PinTextFieldState createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  TextEditingController controller;

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
        TextPosition(offset: controller.text.length));
    return Container(
      height: widget.error && widget.errorMessage.isNotEmpty ? 75.h : 58.h,
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
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    cursorHeight: 20.h,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.fromLTRB(10.w, 18.h, 10.w, 18.h),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: widget.error
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.red),
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
              padding: EdgeInsets.only(top: 6.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.errorMessage,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
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
