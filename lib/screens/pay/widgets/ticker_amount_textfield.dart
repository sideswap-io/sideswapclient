import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/common/utils/number_spaced_formatter.dart';
import 'package:sideswap/desktop/main/d_payment_select_asset.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pay/payment_select_asset.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class TickerAmountTextField extends HookConsumerWidget {
  const TickerAmountTextField({
    super.key,
    this.text,
    this.onDropdownChanged,
    required this.dropdownValue,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.availableAssets = const <String>[],
    this.disabledAssets = const <String>[],
    this.readOnly = false,
    this.dropdownReadOnly = false,
    this.showError = false,
    this.hintText = '',
    this.showHintText = false,
    this.onSubmitted,
    this.onEditingComplete,
    this.textInputAction,
    this.showAccountsInPopup = false,
  });

  final String? text;
  final void Function(String)? onDropdownChanged;
  final String dropdownValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final Iterable<String> availableAssets;
  final Iterable<String> disabledAssets;
  final bool readOnly;
  final bool dropdownReadOnly;
  final bool showError;
  final String hintText;
  final bool showHintText;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final TextInputAction? textInputAction;
  final bool showAccountsInPopup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const textFieldStyle = TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    );

    final optionAsset = ref.watch(assetFromAssetIdProvider(dropdownValue));

    final swapType = ref.watch(swapTypeProvider);

    final textfieldFocusNode = focusNode ?? useFocusNode();
    final visibleHintText = useState(
      swapType == const SwapType.pegIn() && readOnly ? false : showHintText,
    );

    final hasFocus = useState(false);

    useEffect(() {
      textfieldFocusNode.addListener(() {
        if (!context.mounted) {
          return;
        }

        hasFocus.value = textfieldFocusNode.hasFocus;

        if (swapType == const SwapType.pegIn() && readOnly) {
          return;
        }

        if (textfieldFocusNode.hasFocus && !readOnly) {
          visibleHintText.value = false;
          return;
        }

        visibleHintText.value = showHintText;
      });

      return;
    }, const []);

    void showAccountsPopup() {
      Navigator.of(context, rootNavigator: true).push<void>(
        FlavorConfig.isDesktop
            ? DialogRoute(
                barrierColor: Colors.transparent,
                builder: (context) {
                  return DPaymentSelectAsset(
                    availableAssets: availableAssets,
                    disabledAssets: disabledAssets,
                    onSelected: (value) {
                      onDropdownChanged?.call(value.assetId);
                    },
                  );
                },
                context: context,
              )
            : MaterialPageRoute(
                builder: (context) {
                  return PaymentSelectAsset(
                    availableAssets: availableAssets,
                    disabledAssets: disabledAssets,
                    onSelected: (Asset value) {
                      onDropdownChanged?.call(value.assetId);
                    },
                  );
                },
              ),
      );
    }

    return optionAsset.match(
      () => const SizedBox(),
      (asset) => Container(
        height: 43,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border(
            bottom: BorderSide(
              color: switch (showError) {
                true when !readOnly => SideSwapColors.bitterSweet,
                _ => switch (hasFocus.value) {
                  true when !readOnly => SideSwapColors.brightTurquoise,
                  _ => SideSwapColors.jellyBean,
                },
              },
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 42,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Consumer(
                        builder: (context, ref, _) {
                          final icon = ref
                              .watch(assetImageRepositoryProvider)
                              .getSmallImage(asset.assetId);

                          return icon;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: (showAccountsInPopup)
                            ? GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: dropdownReadOnly
                                    ? null
                                    : showAccountsPopup,
                                child: IgnorePointer(
                                  child: TickerAmountDropdown(
                                    dropdownValue: dropdownValue,
                                    onDropdownChanged: onDropdownChanged,
                                    dropdownReadOnly: dropdownReadOnly,
                                    availableAssets: availableAssets,
                                  ),
                                ),
                              )
                            : TickerAmountDropdown(
                                dropdownValue: dropdownValue,
                                onDropdownChanged: onDropdownChanged,
                                dropdownReadOnly: dropdownReadOnly,
                                availableAssets: availableAssets,
                              ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: TextField(
                        autofocus: false,
                        readOnly: readOnly,
                        controller: controller,
                        focusNode: textfieldFocusNode,
                        textAlign: TextAlign.end,
                        style: textFieldStyle,
                        cursorColor: Colors.white,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          CommaTextInputFormatter(),
                          if (asset.precision == 0) ...[
                            FilteringTextInputFormatter.deny(
                              RegExp('[\\-|,\\ .A-Za-z]'),
                            ),
                          ] else ...[
                            FilteringTextInputFormatter.deny(
                              RegExp('[\\-|,\\ ]A-Za-z'),
                            ),
                          ],
                          DecimalTextInputFormatter(
                            decimalRange: asset.precision,
                          ),
                          NumberSpacedFormatter(),
                        ],
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                        textInputAction: textInputAction,
                        onEditingComplete: onEditingComplete,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: visibleHintText.value ? hintText : '',
                          hintStyle: textFieldStyle.copyWith(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}

class TickerAmountDropdown extends HookConsumerWidget {
  const TickerAmountDropdown({
    this.dropdownReadOnly = false,
    this.onDropdownChanged,
    required this.dropdownValue,
    this.availableAssets = const [],
    super.key,
  });

  final bool dropdownReadOnly;
  final void Function(String)? onDropdownChanged;
  final String dropdownValue;
  final Iterable<String> availableAssets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const dropdownTextStyle = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    );

    final dropdownItems = availableAssets.map((value) {
      final optionAsset = ref.watch(assetFromAssetIdProvider(value));

      return DropdownMenuItem<String>(
        value: value,
        child: Row(
          children: [
            optionAsset.match(() => const SizedBox(), (asset) {
              final image = ref
                  .watch(assetImageRepositoryProvider)
                  .getSmallImage(asset.assetId);

              return image;
            }),
            Container(width: 8),
            optionAsset.match(() => const SizedBox(), (asset) {
              return Expanded(
                child: Text(
                  asset.ticker,
                  textAlign: TextAlign.left,
                  style: dropdownTextStyle,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              );
            }),
          ],
        ),
      );
    }).toList();

    return SizedBox(
      width: 90,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          icon: switch (dropdownReadOnly) {
            true => const SizedBox(),
            _ => const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          },
          dropdownColor: SideSwapColors.jellyBean,
          style: dropdownTextStyle,
          onChanged: switch (dropdownReadOnly) {
            true => null,
            _ => (value) {
              return switch (value) {
                final value? => onDropdownChanged?.call(value),
                _ => () {}(),
              };
            },
          },
          disabledHint: switch (dropdownReadOnly) {
            true => Row(
              children: [
                Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final optionAsset = ref.watch(
                        assetFromAssetIdProvider(dropdownValue),
                      );

                      return optionAsset.match(
                        () => const SizedBox(),
                        (asset) => Text(
                          asset.ticker,
                          textAlign: TextAlign.left,
                          style: dropdownTextStyle,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            _ => null,
          },
          value: dropdownValue,
          items: dropdownItems,
          selectedItemBuilder: (context) {
            return availableAssets.map((value) {
              return Consumer(
                builder: (context, ref, _) {
                  final optionAsset = ref.watch(
                    assetFromAssetIdProvider(value),
                  );

                  return optionAsset.match(
                    () => const SizedBox(),
                    (asset) => Row(
                      children: [
                        Expanded(
                          child: Text(
                            asset.ticker,
                            textAlign: TextAlign.left,
                            style: dropdownTextStyle,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
