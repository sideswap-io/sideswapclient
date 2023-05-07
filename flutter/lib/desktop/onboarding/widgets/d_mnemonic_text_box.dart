import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/mnemonic_table_provider.dart';

class DMnemonicTextBox extends HookConsumerWidget {
  const DMnemonicTextBox(
    this.focusNode, {
    super.key,
    this.currentIndex = 1,
  });

  final int currentIndex;
  final FocusNode focusNode;

  void onSubmitted(String value, WidgetRef ref, FocusNode focusNode) {
    ref.read(mnemonicTableProvider).validateOnSubmit(value, currentIndex);
    focusNode.requestFocus();
  }

  void tryJump(String value, WidgetRef ref) {
    final suggestions =
        ref.read(mnemonicTableProvider).suggestions(value.toLowerCase());

    if (suggestions.length == 1) {
      onSubmitted(value, ref, focusNode);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyboardListenerFocusNode = useFocusNode();
    final controller = useTextEditingController();

    final currentWord =
        ref.watch(mnemonicTableProvider.select((p) => p.word(currentIndex)));

    useEffect(() {
      Future.microtask(() {
        controller.text = currentWord.word;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
      });

      return;
    }, [currentWord]);

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
            child: RawAutocomplete<String>(
              focusNode: focusNode,
              textEditingController: controller,
              optionsBuilder: (TextEditingValue textEditingValue) {
                return ref
                    .read(mnemonicTableProvider)
                    .suggestions(textEditingValue.text.toLowerCase());
              },
              onSelected: (value) {
                onSubmitted(value, ref, focusNode);
              },
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return RawKeyboardListener(
                  focusNode: keyboardListenerFocusNode,
                  onKey: (RawKeyEvent event) {
                    if (event.isKeyPressed(LogicalKeyboardKey.tab) ||
                        event.isKeyPressed(LogicalKeyboardKey.enter)) {
                      onSubmitted(textEditingController.text, ref, focusNode);
                      onFieldSubmitted();
                      final wordItems =
                          ref.read(mnemonicTableProvider).wordItems;
                      if (currentIndex + 1 == wordItems.length) {
                        ref.read(mnemonicTableProvider).importMnemonic();
                      }
                    }
                  },
                  child: TextField(
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
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: SideSwapColors.brightTurquoise,
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      final oldValue = ref
                              .read(mnemonicTableProvider)
                              .wordItems[currentIndex]
                              ?.word ??
                          '';
                      ref
                          .read(mnemonicTableProvider)
                          .validate(value, currentIndex);

                      if (oldValue != value) {
                        tryJump(value, ref);
                      }
                    },
                    onSubmitted: (value) {
                      onSubmitted(value, ref, focusNode);
                      onFieldSubmitted();
                    },
                  ),
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
    super.key,
    required this.options,
    required this.onSelected,
  });

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
                        ? SideSwapColors.navyBlue
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
