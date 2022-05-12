import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  void onSubmitted(String value, WidgetRef ref, FocusNode focusNode) {
    ref.read(mnemonicTableProvider).validateOnSubmit(value, currentIndex);
    ref.read(mnemonicTableProvider).importMnemonic();
    focusNode.requestFocus();
  }

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

                return RawAutocomplete<String>(
                  textEditingController: controller,
                  focusNode: focusNode,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return ref
                        .read(mnemonicTableProvider)
                        .suggestions(textEditingValue.text.toLowerCase());
                  },
                  onSelected: (value) {
                    onSubmitted(value, ref, focusNode!);
                  },
                  fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    return TextField(
                      controller: textEditingController,
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
                        onSubmitted(value, ref, focusNode);
                        onFieldSubmitted();
                      },
                    );
                  },
                  optionsViewBuilder: (
                    BuildContext context,
                    AutocompleteOnSelected<String> onSelected,
                    Iterable<String> options,
                  ) {
                    return OptionsView(
                      options: options,
                      onSelected: onSelected,
                    );
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

class OptionsView extends StatelessWidget {
  const OptionsView({
    Key? key,
    required this.options,
    required this.onSelected,
  }) : super(key: key);

  final Iterable<String> options;
  final AutocompleteOnSelected<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200, maxWidth: 200),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final String option = options.elementAt(index);
              return InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Builder(builder: (BuildContext context) {
                  final bool highlight =
                      AutocompleteHighlightedOption.of(context) == index;
                  if (highlight) {
                    SchedulerBinding.instance
                        .addPostFrameCallback((Duration timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    });
                  }
                  return Container(
                    color: highlight
                        ? const Color(0xFF1b8bc8)
                        : const Color(0xFF062d44),
                    padding: const EdgeInsets.all(16.0),
                    child: Text(option),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
