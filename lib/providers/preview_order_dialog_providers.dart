import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/tx_provider.dart';

part 'preview_order_dialog_providers.g.dart';
part 'preview_order_dialog_providers.freezed.dart';

@freezed
sealed class PreviewOrderDialogModifiers with _$PreviewOrderDialogModifiers {
  const factory PreviewOrderDialogModifiers({
    @Default(true) bool showOrderType,
  }) = _PreviewOrderDialogModifiers;
}

@Riverpod(keepAlive: true)
class PreviewOrderDialogModifiersNotifier
    extends _$PreviewOrderDialogModifiersNotifier {
  @override
  PreviewOrderDialogModifiers build() {
    return const PreviewOrderDialogModifiers();
  }

  void setState(PreviewOrderDialogModifiers modifier) {
    state = modifier;
  }
}

@freezed
sealed class PreviewOrderDialogAcceptState
    with _$PreviewOrderDialogAcceptState {
  const factory PreviewOrderDialogAcceptState.empty() =
      PreviewOrderDialogAcceptStateEmpty;
  const factory PreviewOrderDialogAcceptState.accepting() =
      PreviewOrderDialogAcceptStateAccepting;
  const factory PreviewOrderDialogAcceptState.accepted(String txid) =
      PreviewOrderDialogAcceptStateAccepted;
}

@riverpod
PreviewOrderDialogAcceptState previewOrderDialogAcceptState(Ref ref) {
  final optionQuoteSuccess = ref.watch(
    previewOrderQuoteSuccessNotifierProvider,
  );
  final optionAccepQuoteSuccess = ref.watch(marketAcceptQuoteSuccessProvider);
  final allTxSorted = ref.watch(allTxsSortedProvider);

  return optionQuoteSuccess.match(
    () => PreviewOrderDialogAcceptState.empty(),
    (_) => optionAccepQuoteSuccess.match(
      () => PreviewOrderDialogAcceptState.empty(),
      (txid) {
        final index = allTxSorted.indexWhere((e) => e.tx.txid == txid);
        if (index < 0) {
          return PreviewOrderDialogAcceptState.accepting();
        }

        return PreviewOrderDialogAcceptState.accepted(
          allTxSorted[index].tx.txid,
        );
      },
    ),
  );
}
