import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:sideswap/common/decorations/side_swap_input_decoration.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/trimming_input_formatter.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';

typedef ShareTapCallback = void Function(BuildContext context);

class ShareCopyScanTextFormField extends HookConsumerWidget {
  const ShareCopyScanTextFormField({
    this.textFormKey,
    this.focusNode,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.hintText = '',
    this.errorText,
    this.onCopyTap,
    this.shareEnabled = true,
    this.onShareTap,
    this.onScanTap,
    this.onPasteTap,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onEditingCompleted,
    this.addrType = AddrType.elements,
    super.key,
  });

  final Key? textFormKey;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final String? hintText;
  final String? errorText;
  final VoidCallback? onCopyTap;
  final bool shareEnabled;
  final ShareTapCallback? onShareTap;
  final VoidCallback? onScanTap;
  final VoidCallback? onPasteTap;
  final bool enabled;
  final bool readOnly;
  final Function(String)? onChanged;
  final VoidCallback? onEditingCompleted;
  final AddrType addrType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaceBetween = 4.0;
    final iconWidth = 24.0;

    final emptySuffix = useState(false);

    final defaultStyle = useMemoized(
      () => const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.normal,
        color: SideSwapColors.glacier,
      ),
    );

    final suffixCounter = useState(0.0);
    final gestureAreaWidth = useMemoized(() => spaceBetween * 2 + iconWidth);
    final suffixWidth = useState(suffixCounter.value * gestureAreaWidth);

    final defaultFocusNode = focusNode ?? useFocusNode();

    final onTapSuffixCallback = useCallback(({VoidCallback? onTap}) {
      if (onTap == null) {
        return;
      }

      defaultFocusNode.unfocus();
      defaultFocusNode.canRequestFocus = false;
      controller?.clear();

      onTap();

      Future.delayed(const Duration(milliseconds: 100), () {
        defaultFocusNode.canRequestFocus = true;
      });
    });

    useEffect(() {
      if (onCopyTap == null &&
          onPasteTap == null &&
          onScanTap == null &&
          onShareTap == null) {
        emptySuffix.value = true;
      }

      if (onCopyTap != null) {
        suffixCounter.value++;
      }
      if (onShareTap != null) {
        suffixCounter.value++;
      }
      if (onScanTap != null) {
        suffixCounter.value++;
      }
      if (onPasteTap != null) {
        suffixCounter.value++;
      }

      return;
    }, const []);

    useEffect(() {
      suffixWidth.value = suffixCounter.value * gestureAreaWidth;

      return;
    }, [suffixCounter.value]);

    return SizedBox(
      width: 538,
      child: FutureBuilder<ClipboardData?>(
        future: Clipboard.getData(Clipboard.kTextPlain),
        builder: (data, clipboardData) {
          final clipboardText = clipboardData.data?.text?.trim() ?? '';
          return Consumer(
            builder: (context, ref, _) {
              final isValidAddress = ref.watch(
                isAddrTypeValidProvider(clipboardText, addrType),
              );
              final showPasteFromClipboard =
                  !FlavorConfig.isDesktop &&
                  isValidAddress &&
                  controller != null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    key: textFormKey,
                    focusNode: defaultFocusNode,
                    controller: controller,
                    style:
                        textStyle ?? defaultStyle.copyWith(color: Colors.black),
                    enabled: enabled,
                    readOnly: readOnly,
                    onChanged: onChanged,
                    contextMenuBuilder:
                        (context, editableTextState) =>
                            AdaptiveTextSelectionToolbar.buttonItems(
                              anchors: editableTextState.contextMenuAnchors,
                              buttonItems:
                                  editableTextState.contextMenuButtonItems,
                            ),
                    onEditingComplete: onEditingCompleted,
                    inputFormatters: [
                      alphaNumFormatter,
                      TrimmingTextInputFormatter(),
                    ],
                    decoration: SideSwapInputDecoration(
                      hintStyle: hintStyle,
                      hintText: hintText,
                      errorText: errorText,
                      errorStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: SideSwapColors.bitterSweet,
                      ),
                      suffixIcon: switch (emptySuffix.value) {
                        true => null,
                        _ => ShareCopyScanSuffixIcon(
                          suffixWidth: suffixWidth.value,
                          onCopyTap: onCopyTap,
                          gestureAreaWidth: gestureAreaWidth,
                          onTapSuffixCallback: onTapSuffixCallback,
                          iconWidth: iconWidth,
                          onPasteTap: onPasteTap,
                          onScanTap: onScanTap,
                          shareEnabled: shareEnabled,
                          onShareTap: onShareTap,
                          defaultFocusNode: defaultFocusNode,
                        ),
                      },
                    ),
                  ),
                  if (showPasteFromClipboard) ...[
                    const SizedBox(height: 10),
                    Container(
                      decoration: const BoxDecoration(
                        color: SideSwapColors.chathamsBlue,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setControllerValue(controller!, clipboardText);
                          onChanged?.call(clipboardText);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              width: 1.0,
                              style: BorderStyle.solid,
                              color: SideSwapColors.chathamsBlue,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Paste from clipboard'.tr(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF00B4E9),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Text(
                                        clipboardText,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.content_paste,
                                size: iconWidth,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class ShareCopyScanSuffixIcon extends StatelessWidget {
  const ShareCopyScanSuffixIcon({
    super.key,
    required this.suffixWidth,
    required this.onCopyTap,
    required this.gestureAreaWidth,
    required this.onTapSuffixCallback,
    required this.iconWidth,
    required this.onPasteTap,
    required this.onScanTap,
    required this.shareEnabled,
    required this.onShareTap,
    required this.defaultFocusNode,
  });

  final double suffixWidth;
  final VoidCallback? onCopyTap;
  final double gestureAreaWidth;
  final Null Function({VoidCallback? onTap}) onTapSuffixCallback;
  final double iconWidth;
  final VoidCallback? onPasteTap;
  final VoidCallback? onScanTap;
  final bool shareEnabled;
  final ShareTapCallback? onShareTap;
  final FocusNode defaultFocusNode;

  @override
  Widget build(BuildContext context) {
    if (suffixWidth == 0) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: suffixWidth,
        height: 24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (onCopyTap != null) ...[
              SizedBox(
                width: gestureAreaWidth,
                height: double.maxFinite,
                child: InkWell(
                  onTap: () {
                    onTapSuffixCallback();
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/copy.svg',
                      width: iconWidth,
                      height: iconWidth,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF00B4E9),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            if (onPasteTap != null) ...[
              SizedBox(
                width: gestureAreaWidth,
                height: double.maxFinite,
                child: InkWell(
                  onTap: () {
                    onTapSuffixCallback(onTap: onPasteTap);
                  },
                  child: Center(
                    child: Icon(
                      Icons.content_paste,
                      size: iconWidth,
                      color: const Color(0xFF00B4E9),
                    ),
                  ),
                ),
              ),
            ],
            if (onScanTap != null) ...[
              SizedBox(
                width: gestureAreaWidth,
                height: double.maxFinite,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (shareEnabled) {
                        onTapSuffixCallback(onTap: onScanTap);
                      }
                    },
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/qr_icon.svg',
                        width: iconWidth,
                        height: iconWidth,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF00B4E9),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            if (onShareTap != null) ...[
              SizedBox(
                width: gestureAreaWidth,
                height: double.maxFinite,
                child: Builder(
                  builder:
                      (BuildContext context) => InkWell(
                        onTap:
                            onShareTap != null
                                ? () {
                                  defaultFocusNode.unfocus();
                                  defaultFocusNode.canRequestFocus = false;
                                  if (shareEnabled) {
                                    onShareTap!(context);
                                  }
                                  Future.delayed(
                                    const Duration(milliseconds: 100),
                                    () {
                                      defaultFocusNode.canRequestFocus = true;
                                    },
                                  );
                                }
                                : null,
                        child: Center(
                          child: Icon(
                            Icons.share,
                            size: iconWidth,
                            color:
                                shareEnabled
                                    ? const Color(0xFF00B4E9)
                                    : const Color(0xFFA5A9AF),
                          ),
                        ),
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
