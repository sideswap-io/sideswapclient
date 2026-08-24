import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/decorations/side_swap_input_decoration.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_mnemonic_text_box.dart';
import 'package:sideswap/providers/mnemonic_table_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/mnemonic_table.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';

class WalletImportInputs extends HookConsumerWidget {
  const WalletImportInputs({required this.wordCount, super.key});

  final int wordCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(viewportFraction: 0.7);
    final mnemonicCounter = ref.watch(mnemonicWordsCounterProvider);
    final currentItem = ref.watch(currentMnemonicIndexProvider);

    final textEditingControllerList = useMemoized(
      () => List.generate(mnemonicCounter, (_) => TextEditingController()),
    );

    final jumpToCallback = useCallback((int index) async {
      if (index != pageController.page?.toInt()) {
        await pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 130),
          curve: Curves.linear,
        );
      }
    }, [pageController]);

    useEffect(() {
      pageController.addListener(() {
        double? page = pageController.page;
        if (page != null && page == page.roundToDouble()) {
          jumpToCallback.call(page.toInt());
          ref
              .read(currentMnemonicIndexProvider.notifier)
              .setIndex(page.toInt());
        }
      });

      return;
    }, const []);

    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: 54,
          width: screenWidth,
          child: PageView.builder(
            controller: pageController,
            itemCount: mnemonicCounter,
            physics: BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: WordAutocomplete(
                  width: 270.0,
                  index: index,
                  jumpToCallback: jumpToCallback,
                  parentTextEditingController: textEditingControllerList[index],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 38),
        MnemonicTable(
          onCheckField: (index) {
            return ref
                .read(mnemonicWordItemsProvider.notifier)
                .word(index)
                .isCorrect;
          },
          onCheckError: (index) {
            return ref
                .read(mnemonicWordItemsProvider.notifier)
                .word(index)
                .isCorrect;
          },
          onTapIndex: (index) {
            jumpToCallback(index);
          },
          currentIndex: currentItem,
        ),
      ],
    );
  }
}

class WordAutocomplete extends HookConsumerWidget {
  const WordAutocomplete({
    super.key,
    required this.jumpToCallback,
    required this.parentTextEditingController,
    this.width = 200,
    this.index = 0,
  });

  final double width;
  final int index;
  final Function(int index) jumpToCallback;
  final TextEditingController parentTextEditingController;

  Future<void> onSubmitted(String value, WidgetRef ref) async {
    await ref
        .read(mnemonicWordItemsProvider.notifier)
        .validateOnSubmit(value, index);

    final isCorrect =
        ref.read(mnemonicWordItemsProvider)[index]?.isCorrect ?? false;
    final currentItem = ref.read(currentMnemonicIndexProvider);

    if (isCorrect) {
      if (currentItem + 1 == ref.read(mnemonicWordItemsProvider).length) {
        ref.read(mnemonicWordItemsProvider.notifier).importMnemonic();
        return;
      }
      jumpToCallback(index + 1);
    }
  }

  Future<void> tryJump(String value, WidgetRef ref, FocusNode focusNode) async {
    final suggestions = await ref
        .read(mnemonicWordItemsProvider.notifier)
        .suggestions(value.toLowerCase());

    if (suggestions.length == 1) {
      await onSubmitted(value, ref);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentItem = ref.watch(currentMnemonicIndexProvider);

    final focusNode = useFocusNode();

    useEffect(() {
      if (currentItem == index) {
        focusNode.requestFocus();
      }
      return;
    }, [currentItem, index]);

    return RawAutocomplete<String>(
      textEditingController: parentTextEditingController,
      focusNode: focusNode,
      onSelected: (value) async {
        await onSubmitted(value, ref);
      },
      optionsViewBuilder:
          (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
          ) {
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: OptionsView(
                options: options,
                onSelected: onSelected,
                width: width,
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                constraints: BoxConstraints(
                  maxHeight: 17 * 12,
                  maxWidth: width,
                ),
              ),
            );
          },
      optionsBuilder: (textEditingValue) async {
        return await ref
            .read(mnemonicWordItemsProvider.notifier)
            .suggestions(textEditingValue.text.toLowerCase());
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              autofocus: true,
              inputFormatters: [LengthLimitingTextInputFormatter(8)],
              decoration: SideSwapInputDecoration(
                isDense: true,
                filled: true,
                fillColor: currentItem == index
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.3),
                contentPadding: const EdgeInsets.only(
                  left: 10,
                  bottom: 10,
                  top: 10,
                  right: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: SideSwapColors.brightTurquoise,
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                hintText: '',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              cursorColor: Colors.black,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              onChanged: (value) async {
                await ref
                    .read(mnemonicWordItemsProvider.notifier)
                    .validate(value, index);

                final isCorrect =
                    ref.read(mnemonicWordItemsProvider)[index]?.isCorrect ??
                    false;
                if (isCorrect) {
                  if (currentItem + 1 ==
                      ref.read(mnemonicWordItemsProvider).length) {
                    ref
                        .read(mnemonicWordItemsProvider.notifier)
                        .importMnemonic();
                    return;
                  }
                  jumpToCallback(index + 1);
                }
              },
              onSubmitted: (value) async {
                await onSubmitted(value, ref);
                onFieldSubmitted();
              },
              onTap: () {
                jumpToCallback(index);
              },
            );
          },
    );
  }
}

class WalletImport extends HookConsumerWidget {
  const WalletImport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mnemonicCounter = ref.watch(mnemonicWordsCounterProvider);

    return SideSwapScaffold(
      appBar: CustomAppBar(title: 'Enter your recovery phrase'.tr()),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.maxFinite,
                height: 39,
                decoration: BoxDecoration(
                  color: SideSwapColors.prussianBlue,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SwapButton(
                        color: mnemonicCounter == 12
                            ? SideSwapColors.cyanCornflowerBlue
                            : SideSwapColors.prussianBlue,
                        text: '12 words'.tr(),
                        textColor: mnemonicCounter == 12
                            ? Colors.white
                            : SideSwapColors.airSuperiorityBlue,
                        onPressed: () => ref
                            .read(mnemonicWordsCounterProvider.notifier)
                            .set12Words(),
                      ),
                    ),
                    Expanded(
                      child: SwapButton(
                        color: mnemonicCounter == 24
                            ? SideSwapColors.cyanCornflowerBlue
                            : SideSwapColors.prussianBlue,
                        text: '24 words'.tr(),
                        textColor: mnemonicCounter == 24
                            ? Colors.white
                            : SideSwapColors.airSuperiorityBlue,
                        onPressed: () => ref
                            .read(mnemonicWordsCounterProvider.notifier)
                            .set24Words(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Flexible(child: WalletImportInputs(wordCount: mnemonicCounter)),
          ],
        ),
      ),
    );
  }
}
