import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/mnemonic_table_provider.dart';

class DMnemonicTextBox extends ConsumerWidget {
  const DMnemonicTextBox({
    Key? key,
    this.currentIndex = 1,
    this.focusNode,
  }) : super(key: key);

  final int currentIndex;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 460,
      height: 49,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final currentWord = ref.watch(
                    mnemonicTableProvider.select((p) => p.word(currentIndex)));
                final controller = TextEditingController();
                controller.text = currentWord.word;
                controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length));
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(8),
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        '${currentIndex + 1}',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00C5FF),
                        ),
                      ),
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  cursorColor: Colors.black,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    ref
                        .read(mnemonicTableProvider)
                        .validate(value, currentIndex);
                  },
                  onSubmitted: (value) {
                    ref
                        .read(mnemonicTableProvider)
                        .validateOnSubmit(value, currentIndex);
                    ref.read(mnemonicTableProvider).importMnemonic();
                    focusNode?.requestFocus();
                  },
                );
              },
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}
