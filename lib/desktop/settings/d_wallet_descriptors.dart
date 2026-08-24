import 'dart:io';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/middle_elipsis_text.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_descriptors_provider.dart';
import 'package:sideswap/screens/settings/wallet_descriptors_screen.dart';
import 'package:window_manager/window_manager.dart';

part 'd_wallet_descriptors.g.dart';

/// Whether descriptor copy is currently permitted -- driven by window focus.
///
/// Mirrors `isCopyEnabledProvider` from the recovery-phrase dialog: the
/// dialog's `WindowListener` flips it to `false` on a `'blur'` event and back
/// to `true` on `'focus'`. Both the visible Copy button and the Ctrl/Cmd+C
/// shortcut action consult it, so a blurred window copies nothing
/// (ADR-0002 decision 4).
@riverpod
class DescriptorCopyEnabled extends _$DescriptorCopyEnabled {
  @override
  bool build() => true;

  void setEnabled(bool value) => state = value;
}

/// Intent raised by the Ctrl/Cmd+C shortcut on the desktop descriptors dialog.
class CopyDescriptorIntent extends Intent {
  const CopyDescriptorIntent();
}

/// Copies the primary (native segwit) descriptor in response to a
/// [CopyDescriptorIntent].
///
/// A single key combo cannot disambiguate the two sections, so the shortcut
/// targets native segwit (bech32, derivation 84') -- the modern primary
/// account; the nested-segwit descriptor stays reachable through its own Copy
/// button. Per ADR-0002 decision 4 the focus gate is re-checked *here*, inside
/// the Action, not just on the visible button -- one-line defense-in-depth so a
/// blurred window copies nothing even through the keyboard. The provider is
/// read live on every [invoke] rather than captured, so focus changes after
/// the action was wired are always honoured.
class CopyDescriptorAction extends Action<CopyDescriptorIntent> {
  CopyDescriptorAction({required this.ref, required this.onCopy});

  final WidgetRef ref;
  final Future<void> Function()? onCopy;

  @override
  Object? invoke(covariant CopyDescriptorIntent intent) {
    if (!ref.read(descriptorCopyEnabledProvider)) {
      return null;
    }
    onCopy?.call();
    return null;
  }
}

/// Desktop "Wallet descriptors" export dialog.
///
/// Mirrors the recovery-phrase dialog (`d_settings_view_backup.dart`): a
/// warning, the two watch-only descriptors (Native segwit / Nested segwit) each
/// with a middle-ellipsised preview and a focus-gated Copy button, and a
/// BACK/close action that
/// returns to the settings dialog. The first copy of a visit is preceded by a
/// single confirmation dialog (shared verbatim with the mobile screen); later
/// copies in the same visit do not re-prompt. There is no share action on
/// desktop.
class DWalletDescriptors extends StatefulHookConsumerWidget {
  const DWalletDescriptors({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DWalletDescriptorsState();
}

class _DWalletDescriptorsState extends ConsumerState<DWalletDescriptors>
    with WindowListener {
  @override
  void onWindowEvent(String eventName) {
    if (eventName == 'blur') {
      ref.read(descriptorCopyEnabledProvider.notifier).setEnabled(false);
    }

    if (eventName == 'focus') {
      ref.read(descriptorCopyEnabledProvider.notifier).setEnabled(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final desktopTheme = ref.watch(desktopAppThemeProvider);
    final defaultDialogTheme = desktopTheme.defaultDialogTheme;
    // State-aware filled style: brightTurquoise when enabled, dimmed when the
    // focus gate disables the button -- not an unconditional colour, which
    // would paint the disabled (unfocused) button as if it were still enabled.
    final filledButtonStyle = desktopTheme.buttonThemeData.filledButtonStyle;
    final descriptors = ref.watch(walletDescriptorsProvider);
    final copyEnabled = ref.watch(descriptorCopyEnabledProvider);
    final acknowledged = useState(false);
    final scrollController = useScrollController();

    useEffect(() {
      WindowManager.instance.addListener(this);

      return () {
        WindowManager.instance.removeListener(this);
      };
    }, const []);

    // Per-visit confirmation gate shared by every copy (button or shortcut):
    // the first copy prompts, later ones do not. Returns whether to proceed.
    Future<bool> ensureAcknowledged() async {
      if (acknowledged.value) {
        return true;
      }
      final accepted = await showDescriptorCopyConfirmationDialog(context);
      if (accepted != true || !context.mounted) {
        return false;
      }
      acknowledged.value = true;
      return true;
    }

    Future<void> handleCopy(String descriptor) async {
      if (!await ensureAcknowledged()) {
        return;
      }
      if (!context.mounted) {
        return;
      }
      // Defense-in-depth for the pinned focus gate (ADR-0002 decision 4): the
      // window may have blurred while the confirmation dialog was open, so the
      // live flag is re-read across the async gap and the copy aborts if focus
      // was lost -- the gate is not only the button's disabled state.
      if (!ref.read(descriptorCopyEnabledProvider)) {
        return;
      }
      // The confirmation dialog is the copy acknowledgement, so the transient
      // "Copied" flushbar is suppressed here (matches the mobile screen).
      await copyToClipboard(context, descriptor, displaySnackbar: false);
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          if (Platform.isLinux || Platform.isFuchsia) ...{
            LogicalKeySet(
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.shift,
              LogicalKeyboardKey.keyC,
            ): const CopyDescriptorIntent(),
          },
          if (Platform.isWindows) ...{
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC):
                const CopyDescriptorIntent(),
          },
          if (Platform.isMacOS) ...{
            LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyC):
                const CopyDescriptorIntent(),
          },
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            CopyDescriptorIntent: CopyDescriptorAction(
              ref: ref,
              onCopy: descriptors == null
                  ? null
                  : () => handleCopy(descriptors.nativeSegwit),
            ),
          },
          child: Focus(
            autofocus: true,
            child: DContentDialog(
              title: DContentDialogTitle(
                content: Text('Wallet descriptors'.tr()),
                onClose: () {
                  ref.read(walletProvider).goBack();
                },
              ),
              content: Center(
                child: SizedBox(
                  width: 500,
                  height: 460,
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: scrollController,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Anyone with these descriptors can see your full transaction history and future activity, but cannot spend your funds. Share them only with wallets you trust.'
                                .tr(),
                          ),
                          const SizedBox(height: 24),
                          if (descriptors != null) ...[
                            _DDescriptorSection(
                              title: 'Native segwit'.tr(),
                              descriptor: descriptors.nativeSegwit,
                              copyKey: const Key(
                                'copy_native_segwit_descriptor',
                              ),
                              copyStyle: filledButtonStyle,
                              onCopy: copyEnabled
                                  ? () => handleCopy(descriptors.nativeSegwit)
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            _DDescriptorSection(
                              title: 'Nested segwit'.tr(),
                              descriptor: descriptors.nestedSegwit,
                              copyKey: const Key(
                                'copy_nested_segwit_descriptor',
                              ),
                              copyStyle: filledButtonStyle,
                              onCopy: copyEnabled
                                  ? () => handleCopy(descriptors.nestedSegwit)
                                  : null,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                Center(
                  child: DCustomTextBigButton(
                    width: 266,
                    onPressed: () {
                      ref.read(walletProvider).goBack();
                    },
                    child: Text('BACK'.tr()),
                  ),
                ),
              ],
              style: const DContentDialogThemeData().merge(defaultDialogTheme),
              constraints: const BoxConstraints(maxWidth: 580),
            ),
          ),
        ),
      ),
    );
  }
}

class _DDescriptorSection extends StatelessWidget {
  const _DDescriptorSection({
    required this.title,
    required this.descriptor,
    required this.copyKey,
    required this.copyStyle,
    required this.onCopy,
  });

  final String title;
  final String descriptor;
  final Key copyKey;

  /// The state-aware filled style routed into the Copy button so it shows
  /// brightTurquoise when enabled and dims when the focus gate disables it.
  final DButtonStyle? copyStyle;

  /// The copy handler, or `null` when copy is focus-gated off -- a `null`
  /// handler renders the Copy button disabled (`DButton` greys out on a `null`
  /// `onPressed`), which is the visible half of the focus gate.
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: SideSwapColors.chathamsBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          // Descriptor syntax is inherently left-to-right; force LTR so it is
          // not visually scrambled under an RTL (Arabic/Urdu) layout. The
          // preview middle-ellipsises so both the script-type prefix and the
          // tail stay visible; the full string is carried for copy.
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MiddleEllipsisText(
              text: descriptor,
              maxLines: 1,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Row(end), not Align: it hands the DButton unbounded width, so the
        // button's inner max-Row shrinks to content instead of stretching --
        // matching the copy-mnemonic button's narrow, right-aligned layout.
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DButton(
              key: copyKey,
              onPressed: onCopy,
              style: copyStyle,
              child: SizedBox(
                height: 34,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tint the copy icon white: copy3.svg is stroked
                      // brightTurquoise, which would vanish against the button's
                      // brightTurquoise fill -- white matches the label and the
                      // mobile white-icon buttons.
                      SvgPicture.asset(
                        'assets/copy3.svg',
                        width: 16,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Copy'.tr()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
