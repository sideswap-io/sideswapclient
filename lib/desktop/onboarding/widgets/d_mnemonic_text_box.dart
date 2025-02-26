import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';
import 'package:sideswap/providers/mnemonic_table_provider.dart';

class DMnemonicTextBox extends HookConsumerWidget {
  const DMnemonicTextBox(this.focusNode, {super.key, this.currentIndex = 1});

  final int currentIndex;
  final FocusNode focusNode;

  Future<void> onSubmitted(
    String value,
    WidgetRef ref,
    FocusNode focusNode,
  ) async {
    await ref
        .read(mnemonicWordItemsNotifierProvider.notifier)
        .validateOnSubmit(value, currentIndex);
    focusNode.requestFocus();
  }

  Future<void> tryJump(String value, WidgetRef ref) async {
    final suggestions = await ref
        .read(mnemonicWordItemsNotifierProvider.notifier)
        .suggestions(value.toLowerCase());

    if (suggestions.length == 1) {
      await onSubmitted(value, ref, focusNode);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyboardListenerFocusNode = useFocusNode();
    final controller = useTextEditingController();

    final currentWord = ref
        .watch(mnemonicWordItemsNotifierProvider.notifier)
        .word(currentIndex);

    controller.text = currentWord.word;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    final words = ref.watch(mnemonicWordItemsNotifierProvider);
    useAsyncEffect(() async {
      if (words.isNotEmpty) {
        ref.read(mnemonicWordItemsNotifierProvider.notifier).importMnemonic();
      }

      return;
    }, [words]);

    return Container(
      width: 460,
      height: 49,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: RawAutocomplete<String>(
              focusNode: focusNode,
              textEditingController: controller,
              optionsBuilder: (TextEditingValue textEditingValue) {
                return ref
                    .read(mnemonicWordItemsNotifierProvider.notifier)
                    .suggestions(textEditingValue.text.toLowerCase());
              },
              onSelected: (value) async {
                await onSubmitted(value, ref, focusNode);
              },
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return KeyboardListener(
                  focusNode: keyboardListenerFocusNode,
                  onKeyEvent: (value) async {
                    if (HardwareKeyboard.instance.isLogicalKeyPressed(
                          LogicalKeyboardKey.tab,
                        ) ||
                        HardwareKeyboard.instance.isLogicalKeyPressed(
                          LogicalKeyboardKey.enter,
                        )) {
                      await onSubmitted(
                        textEditingController.text,
                        ref,
                        focusNode,
                      );
                      onFieldSubmitted();
                      final wordItems = ref.read(
                        mnemonicWordItemsNotifierProvider,
                      );
                      if (currentIndex + 1 == wordItems.length) {
                        ref
                            .read(mnemonicWordItemsNotifierProvider.notifier)
                            .importMnemonic();
                      }
                    }
                  },
                  child: TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    inputFormatters: [LengthLimitingTextInputFormatter(8)],
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
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
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
                    onChanged: (value) async {
                      final oldValue =
                          ref
                              .read(
                                mnemonicWordItemsNotifierProvider,
                              )[currentIndex]
                              ?.word ??
                          '';
                      await ref
                          .read(mnemonicWordItemsNotifierProvider.notifier)
                          .validate(value, currentIndex);

                      if (oldValue != value) {
                        await tryJump(value, ref);
                      }
                    },
                    onSubmitted: (value) async {
                      await onSubmitted(value, ref, focusNode);
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
                return OptionsView(options: options, onSelected: onSelected);
              },
            ),
          ),
          const SizedBox(width: 16),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200, maxWidth: 200),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: List.generate(options.length, (index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Builder(
                      builder: (BuildContext context) {
                        final bool highlight =
                            AutocompleteHighlightedOption.of(context) == index;
                        if (highlight) {
                          SchedulerBinding.instance.addPostFrameCallback((
                            Duration timeStamp,
                          ) {
                            Scrollable.ensureVisible(context);
                          });
                        }
                        return Container(
                          height: 54,
                          width: 200,
                          color:
                              highlight
                                  ? SideSwapColors.navyBlue
                                  : const Color(0xFF062d44),
                          padding: const EdgeInsets.all(16.0),
                          child: Text(option),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
