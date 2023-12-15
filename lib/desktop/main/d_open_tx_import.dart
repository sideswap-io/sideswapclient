import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/providers/universal_link_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class DOpenTxImport extends HookConsumerWidget {
  const DOpenTxImport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textFieldFocusNode = useFocusNode();
    final textFieldHasFocus = useState(false);

    useEffect(() {
      textFieldFocusNode.addListener(() {
        if (textFieldFocusNode.hasFocus) {
          textFieldHasFocus.value = true;
          return;
        }

        textFieldHasFocus.value = false;
      });

      return;
    }, [textFieldFocusNode]);

    final scrollController = useScrollController();
    final textController = useTextEditingController();
    final errorText = useState<String?>(null);
    final continueEnabled = useState(false);

    useEffect(() {
      textController.addListener(() {
        if (textController.text.isEmpty) {
          errorText.value = null;
          continueEnabled.value = false;
          return;
        }

        final handleResult = ref
            .read(universalLinkProvider)
            .handleAppUrlStr(textController.text);

        return switch (handleResult) {
          HandleResult.unknownScheme => () {
              // maybe it's only order id?
              if (textController.text.length == 64) {
                ref.read(walletProvider).linkOrder(textController.text);
              }
            }(),
          HandleResult.success => () {
              continueEnabled.value = true;
            }(),
          _ => () {
              errorText.value = 'Invalid hash or url';
              continueEnabled.value = false;
            }(),
        };
      });

      return;
    }, [textController]);

    final onPasteCallback = useCallback(() async {
      final navigatorContext = Navigator.of(context);
      await handlePasteSingleLine(textController);
      final handleResult =
          ref.read(universalLinkProvider).handleAppUrlStr(textController.text);

      if (handleResult == HandleResult.success) {
        navigatorContext.pop();
        return;
      }

      errorText.value = 'Invalid hash or url';
      continueEnabled.value = false;
    }, []);

    return DPopupWithClose(
      width: 580,
      height: 321,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'Import transaction or private swap proposal'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: 0.10,
              ),
            ),
            const SizedBox(height: 28),
            TextFormField(
              focusNode: textFieldFocusNode,
              scrollController: scrollController,
              controller: textController,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 3,
              selectionControls: DesktopTextSelectionControls(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                isDense: true,
                fillColor: Colors.white,
                filled: true,
                labelText: 'Paste transaction hash'.tr(),
                labelStyle: const TextStyle(
                  color: SideSwapColors.glacier,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: '',
                errorText: errorText.value,
                errorStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: SideSwapColors.bitterSweet,
                ),
                suffixIcon: textFieldHasFocus.value
                    ? null
                    : SizedBox(
                        width: 24,
                        height: 24,
                        child: TextButton(
                          onPressed: onPasteCallback,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: const Icon(
                            Icons.paste,
                            size: 24,
                            color: SideSwapColors.brightTurquoise,
                          ),
                        ),
                      ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: SideSwapColors.bitterSweet),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: SideSwapColors.bitterSweet),
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DCustomButton(
                  width: 245,
                  height: 44,
                  // onPressed: () {},
                  child: Text('IMPORT FILE'.tr()),
                ),
                DCustomButton(
                  width: 245,
                  height: 44,
                  isFilled: true,
                  onPressed: continueEnabled.value ? () {} : null,
                  child: Text('CONTINUE'.tr()),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
