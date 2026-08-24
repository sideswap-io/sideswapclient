import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/middle_elipsis_text.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet_descriptors.dart';
import 'package:sideswap/providers/wallet_descriptors_provider.dart';

/// Read-only "Wallet descriptors" export screen (mobile).
///
/// Shows the two watch-only descriptors -- Native segwit and Nested segwit --
/// each with a middle-ellipsised preview and Copy + Share actions. The
/// first transfer action (copy or share) of a screen visit is preceded by a
/// single confirmation dialog (the descriptor leaves the app's control once it
/// reaches the clipboard or the OS share sheet); later actions in the same
/// visit do not re-prompt. Because the acknowledgement flag is per-widget-
/// instance state, leaving and re-entering the screen re-arms the dialog.
class WalletDescriptorsScreen extends HookConsumerWidget {
  const WalletDescriptorsScreen({super.key, this.shareDescriptor = shareText});

  /// Injected OS-share seam. Defaults to [shareText] (share_plus) in
  /// production; widget tests override it to capture the shared payload without
  /// touching the platform channel.
  final Future<void> Function(String descriptor) shareDescriptor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final descriptors = ref.watch(walletDescriptorsProvider);
    final acknowledged = useState(false);

    // The confirmation dialog is a per-visit gate shared by Copy and Share:
    // the first transfer action prompts, later ones do not. Returns whether the
    // caller may proceed.
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
      // The confirmation dialog is the copy acknowledgement, so the transient
      // "Copied" flushbar is suppressed here.
      await copyToClipboard(context, descriptor, displaySnackbar: false);
    }

    Future<void> handleShare(String descriptor) async {
      if (!await ensureAcknowledged()) {
        return;
      }
      await shareDescriptor(descriptor);
    }

    return SideSwapScaffold(
      appBar: CustomAppBar(title: 'Wallet descriptors'.tr()),
      body: SafeArea(
        child: descriptors == null
            ? const SizedBox.shrink()
            : _WalletDescriptorsBody(
                descriptors: descriptors,
                onCopy: handleCopy,
                onShare: handleShare,
              ),
      ),
    );
  }
}

class _WalletDescriptorsBody extends StatelessWidget {
  const _WalletDescriptorsBody({
    required this.descriptors,
    required this.onCopy,
    required this.onShare,
  });

  final WalletDescriptors descriptors;
  final Future<void> Function(String descriptor) onCopy;
  final Future<void> Function(String descriptor) onShare;

  @override
  Widget build(BuildContext context) {
    // Fill at least the viewport height so the SideSwapScaffold gradient (a
    // CustomPaint that sizes to this body) reaches the bottom of the screen.
    // Without this the short, QR-less content lets the body shrink to it and
    // the gradient cuts off just below the Nested-segwit actions. Matches the
    // fill idiom used by sibling settings screens (settings_custom_host,
    // settings_licenses); no IntrinsicHeight is needed here as nothing flexes.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
            minHeight: constraints.maxHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anyone with these descriptors can see your full transaction history and future activity, but cannot spend your funds. Share them only with wallets you trust.'
                      .tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                _DescriptorSection(
                  title: 'Native segwit'.tr(),
                  descriptor: descriptors.nativeSegwit,
                  copyKey: const Key('copy_native_segwit_descriptor'),
                  shareKey: const Key('share_native_segwit_descriptor'),
                  onCopy: () => onCopy(descriptors.nativeSegwit),
                  onShare: () => onShare(descriptors.nativeSegwit),
                ),
                const SizedBox(height: 24),
                _DescriptorSection(
                  title: 'Nested segwit'.tr(),
                  descriptor: descriptors.nestedSegwit,
                  copyKey: const Key('copy_nested_segwit_descriptor'),
                  shareKey: const Key('share_nested_segwit_descriptor'),
                  onCopy: () => onCopy(descriptors.nestedSegwit),
                  onShare: () => onShare(descriptors.nestedSegwit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DescriptorSection extends StatelessWidget {
  const _DescriptorSection({
    required this.title,
    required this.descriptor,
    required this.copyKey,
    required this.shareKey,
    required this.onCopy,
    required this.onShare,
  });

  final String title;
  final String descriptor;
  final Key copyKey;
  final Key shareKey;
  final VoidCallback onCopy;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
          // tail stay visible; the full string is carried for copy/share.
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
        // Align so the shrink-wrapped Wrap block genuinely right-aligns (a bare
        // WrapAlignment.end has no free space under the start-aligned column).
        Align(
          alignment: Alignment.centerRight,
          // Wrap (not Row) so the two actions fall onto a second line rather
          // than overflowing on narrow devices under long localized labels.
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 12,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                key: shareKey,
                onPressed: onShare,
                style: _filledActionStyle(),
                icon: const Icon(Icons.share, size: 16),
                label: Text('Share'.tr()),
              ),
              FilledButton.icon(
                key: copyKey,
                onPressed: onCopy,
                style: _filledActionStyle(),
                icon: const Icon(Icons.copy, size: 16),
                label: Text('Copy'.tr()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Confirmation shown before the first copy or share of a visit. Resolves to
/// `true` when the user accepts, `false`/`null` when they cancel or dismiss.
Future<bool?> showDescriptorCopyConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: SideSwapColors.blumine,
        // Cap the dialog shell to the app-standard 580 (a no-op on mobile,
        // where 580 exceeds device width). The `constraints` property bounds
        // the shell -- a ConstrainedBox on `content` only bounds the body.
        constraints: const BoxConstraints(maxWidth: 580),
        title: Text(
          'Copy descriptor'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          'The descriptor will be copied to your system clipboard and may remain there, outside SideSwap\'s control, until you clear it.'
              .tr(),
          style: const TextStyle(color: Colors.white),
        ),
        // Cancel and Copy stay as the two `actions` entries: Material's
        // OverflowBar stacks them on a narrow width, so two filled buttons do
        // not overflow. Both are filled brightTurquoise + white for legibility
        // against the blumine fill (navy-on-navy TextButtons were invisible).
        actions: [
          FilledButton(
            key: const Key('descriptor_copy_cancel'),
            style: _filledActionStyle(),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'.tr()),
          ),
          FilledButton(
            key: const Key('descriptor_copy_confirm'),
            style: _filledActionStyle(),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Copy'.tr()),
          ),
        ],
      );
    },
  );
}

/// The primary-blue filled style shared by every action button on this screen
/// (Share/Copy and the confirmation dialog's Cancel/Copy): brightTurquoise fill
/// with a white foreground for legibility against the darker surfaces.
ButtonStyle _filledActionStyle() => FilledButton.styleFrom(
  backgroundColor: SideSwapColors.brightTurquoise,
  foregroundColor: Colors.white,
);
