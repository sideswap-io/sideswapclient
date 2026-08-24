import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/preview_order_dialog_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(PreviewOrderDialogModifiers());
  });

  group('PreviewOrderDialogModifiers', () {
    group('factory constructor', () {
      test('creates instance with default showOrderType true', () {
        final modifiers = PreviewOrderDialogModifiers();
        expect(modifiers.showOrderType, true);
      });

      test('creates instance with custom showOrderType false', () {
        final modifiers = PreviewOrderDialogModifiers(showOrderType: false);
        expect(modifiers.showOrderType, false);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated showOrderType', () {
        final original = PreviewOrderDialogModifiers(showOrderType: true);
        final updated = original.copyWith(showOrderType: false);
        expect(updated.showOrderType, false);
        expect(original.showOrderType, true);
      });

      test('returns copy with same value when no arguments provided', () {
        final original = PreviewOrderDialogModifiers(showOrderType: false);
        final copy = original.copyWith();
        expect(copy.showOrderType, false);
      });
    });
  });

  group('PreviewOrderDialogModifiersNotifier', () {
    group('build', () {
      test('initial state has showOrderType true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final state = container.read(previewOrderDialogModifiersProvider);
        expect(state.showOrderType, true);
      });

      test('state is kept alive across reads', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final state1 = container.read(previewOrderDialogModifiersProvider);
        final state2 = container.read(previewOrderDialogModifiersProvider);
        expect(identical(state1, state2), true);
      });
    });

    group('setState', () {
      test('updates state with new PreviewOrderDialogModifiers', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(
          previewOrderDialogModifiersProvider.notifier,
        );
        final newModifiers = PreviewOrderDialogModifiers(showOrderType: false);

        notifier.setState(newModifiers);

        final state = container.read(previewOrderDialogModifiersProvider);
        expect(state.showOrderType, false);
      });

      test('can toggle showOrderType multiple times', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final notifier = container.read(
          previewOrderDialogModifiersProvider.notifier,
        );

        notifier.setState(PreviewOrderDialogModifiers(showOrderType: false));
        expect(
          container.read(previewOrderDialogModifiersProvider).showOrderType,
          false,
        );

        notifier.setState(PreviewOrderDialogModifiers(showOrderType: true));
        expect(
          container.read(previewOrderDialogModifiersProvider).showOrderType,
          true,
        );
      });

      test('notifies listeners of state changes', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<PreviewOrderDialogModifiers>();
        container.listen(
          previewOrderDialogModifiersProvider,
          listener.call,
          fireImmediately: true,
        );

        final notifier = container.read(
          previewOrderDialogModifiersProvider.notifier,
        );
        final newModifiers = PreviewOrderDialogModifiers(showOrderType: false);

        notifier.setState(newModifiers);

        verifyInOrder([
          () => listener.call(null, any()),
          () => listener.call(any(), newModifiers),
        ]);
      });
    });
  });

  group('PreviewOrderDialogAcceptState', () {
    group('empty constructor', () {
      test('creates empty state', () {
        final state = PreviewOrderDialogAcceptState.empty();
        expect(state, isA<PreviewOrderDialogAcceptStateEmpty>());
      });
    });

    group('accepting constructor', () {
      test('creates accepting state', () {
        final state = PreviewOrderDialogAcceptState.accepting();
        expect(state, isA<PreviewOrderDialogAcceptStateAccepting>());
      });
    });

    group('accepted constructor', () {
      test('creates accepted state with txid', () {
        const txid = 'abc123def456';
        final state = PreviewOrderDialogAcceptState.accepted(txid);
        expect(state, isA<PreviewOrderDialogAcceptStateAccepted>());
        expect(
          (state as PreviewOrderDialogAcceptStateAccepted).txid,
          txid,
        );
      });

      test('accepts different txids', () {
        const txid1 = 'txid1';
        const txid2 = 'txid2';
        final state1 = PreviewOrderDialogAcceptState.accepted(txid1);
        final state2 = PreviewOrderDialogAcceptState.accepted(txid2);

        expect(
          (state1 as PreviewOrderDialogAcceptStateAccepted).txid,
          txid1,
        );
        expect(
          (state2 as PreviewOrderDialogAcceptStateAccepted).txid,
          txid2,
        );
      });
    });
  });

  group('previewOrderDialogAcceptState', () {
    group('when previewOrderQuoteSuccess is none', () {
      test('returns empty state', () {
        final container = ProviderContainer.test(
          overrides: [
            previewOrderQuoteSuccessProvider
                .overrideWithValue(Option.none()),
            marketAcceptQuoteSuccessProvider.overrideWithValue(Option.none()),
            allTxsSortedProvider.overrideWithValue([]),
          ],
        );
        addTearDown(container.dispose);

        final state = container.read(previewOrderDialogAcceptStateProvider);

        expect(state, isA<PreviewOrderDialogAcceptStateEmpty>());
      });
    });

    group('when previewOrderQuoteSuccess is some', () {
      group('and marketAcceptQuoteSuccess is none', () {
        test('returns empty state', () {
          final container = ProviderContainer.test(
            overrides: [
              previewOrderQuoteSuccessProvider.overrideWithValue(
                Option.of(_createMockQuoteSuccess()),
              ),
              marketAcceptQuoteSuccessProvider.overrideWithValue(
                Option.none(),
              ),
              allTxsSortedProvider.overrideWithValue([]),
            ],
          );
          addTearDown(container.dispose);

          final state =
              container.read(previewOrderDialogAcceptStateProvider);

          expect(state, isA<PreviewOrderDialogAcceptStateEmpty>());
        });
      });

      group('and marketAcceptQuoteSuccess is some', () {
        test('returns accepting state when txid not found in allTxsSorted', () {
          final container = ProviderContainer.test(
            overrides: [
              previewOrderQuoteSuccessProvider.overrideWithValue(
                Option.of(_createMockQuoteSuccess()),
              ),
              marketAcceptQuoteSuccessProvider.overrideWithValue(
                Option.of('missing_txid'),
              ),
              allTxsSortedProvider.overrideWithValue([]),
            ],
          );
          addTearDown(container.dispose);

          final state =
              container.read(previewOrderDialogAcceptStateProvider);

          expect(state, isA<PreviewOrderDialogAcceptStateAccepting>());
        });

        test('returns accepting state when txid not yet in allTxsSorted', () {
          final container = ProviderContainer.test(
            overrides: [
              previewOrderQuoteSuccessProvider.overrideWithValue(
                Option.of(_createMockQuoteSuccess()),
              ),
              marketAcceptQuoteSuccessProvider.overrideWithValue(
                Option.of('expected_txid'),
              ),
              allTxsSortedProvider.overrideWithValue([
                _createTransItem('other_txid'),
              ]),
            ],
          );
          addTearDown(container.dispose);

          final state =
              container.read(previewOrderDialogAcceptStateProvider);

          expect(state, isA<PreviewOrderDialogAcceptStateAccepting>());
        });

        test('returns accepted state with txid when found in allTxsSorted', () {
          const expectedTxid = 'found_txid';
          final container = ProviderContainer.test(
            overrides: [
              previewOrderQuoteSuccessProvider.overrideWithValue(
                Option.of(_createMockQuoteSuccess()),
              ),
              marketAcceptQuoteSuccessProvider.overrideWithValue(
                Option.of(expectedTxid),
              ),
              allTxsSortedProvider.overrideWithValue([
                _createTransItem(expectedTxid),
              ]),
            ],
          );
          addTearDown(container.dispose);

          final state =
              container.read(previewOrderDialogAcceptStateProvider);

          expect(state, isA<PreviewOrderDialogAcceptStateAccepted>());
          expect(
            (state as PreviewOrderDialogAcceptStateAccepted).txid,
            expectedTxid,
          );
        });

        test(
          'returns accepted state with correct txid when multiple txs in list',
          () {
            const expectedTxid = 'target_txid';
            final container = ProviderContainer.test(
              overrides: [
                previewOrderQuoteSuccessProvider.overrideWithValue(
                  Option.of(_createMockQuoteSuccess()),
                ),
                marketAcceptQuoteSuccessProvider.overrideWithValue(
                  Option.of(expectedTxid),
                ),
                allTxsSortedProvider.overrideWithValue([
                  _createTransItem('txid_1'),
                  _createTransItem(expectedTxid),
                  _createTransItem('txid_3'),
                ]),
              ],
            );
            addTearDown(container.dispose);

            final state =
                container.read(previewOrderDialogAcceptStateProvider);

            expect(state, isA<PreviewOrderDialogAcceptStateAccepted>());
            expect(
              (state as PreviewOrderDialogAcceptStateAccepted).txid,
              expectedTxid,
            );
          },
        );

        test('finds txid at beginning of sorted list', () {
          const expectedTxid = 'first_txid';
          final container = ProviderContainer.test(
            overrides: [
              previewOrderQuoteSuccessProvider.overrideWithValue(
                Option.of(_createMockQuoteSuccess()),
              ),
              marketAcceptQuoteSuccessProvider.overrideWithValue(
                Option.of(expectedTxid),
              ),
              allTxsSortedProvider.overrideWithValue([
                _createTransItem(expectedTxid),
                _createTransItem('txid_2'),
              ]),
            ],
          );
          addTearDown(container.dispose);

          final state =
              container.read(previewOrderDialogAcceptStateProvider);

          expect(state, isA<PreviewOrderDialogAcceptStateAccepted>());
          expect(
            (state as PreviewOrderDialogAcceptStateAccepted).txid,
            expectedTxid,
          );
        });

        test('finds txid at end of sorted list', () {
          const expectedTxid = 'last_txid';
          final container = ProviderContainer.test(
            overrides: [
              previewOrderQuoteSuccessProvider.overrideWithValue(
                Option.of(_createMockQuoteSuccess()),
              ),
              marketAcceptQuoteSuccessProvider.overrideWithValue(
                Option.of(expectedTxid),
              ),
              allTxsSortedProvider.overrideWithValue([
                _createTransItem('txid_1'),
                _createTransItem(expectedTxid),
              ]),
            ],
          );
          addTearDown(container.dispose);

          final state =
              container.read(previewOrderDialogAcceptStateProvider);

          expect(state, isA<PreviewOrderDialogAcceptStateAccepted>());
          expect(
            (state as PreviewOrderDialogAcceptStateAccepted).txid,
            expectedTxid,
          );
        });
      });
    });

    group('state reactivity', () {
      test('returns empty state when only previewOrderQuoteSuccess is none', () {
        final container = ProviderContainer.test(
          overrides: [
            previewOrderQuoteSuccessProvider
                .overrideWithValue(Option.none()),
            marketAcceptQuoteSuccessProvider.overrideWithValue(Option.none()),
            allTxsSortedProvider.overrideWithValue([]),
          ],
        );
        addTearDown(container.dispose);

        final state = container.read(previewOrderDialogAcceptStateProvider);
        expect(state, isA<PreviewOrderDialogAcceptStateEmpty>());
      });

      test(
        'returns empty state when previewOrderQuoteSuccess is some but marketAcceptQuoteSuccess is none',
        () {
          final container = ProviderContainer.test(
            overrides: [
              previewOrderQuoteSuccessProvider.overrideWithValue(
                Option.of(_createMockQuoteSuccess()),
              ),
              marketAcceptQuoteSuccessProvider.overrideWithValue(Option.none()),
              allTxsSortedProvider.overrideWithValue([]),
            ],
          );
          addTearDown(container.dispose);

          final state =
              container.read(previewOrderDialogAcceptStateProvider);
          expect(state, isA<PreviewOrderDialogAcceptStateEmpty>());
        },
      );

      test(
        'returns correct state based on allTxsSorted contents',
        () {
          const expectedTxid = 'new_txid';
          final container = ProviderContainer.test(
            overrides: [
              previewOrderQuoteSuccessProvider.overrideWithValue(
                Option.of(_createMockQuoteSuccess()),
              ),
              marketAcceptQuoteSuccessProvider.overrideWithValue(
                Option.of(expectedTxid),
              ),
              allTxsSortedProvider.overrideWithValue([
                _createTransItem(expectedTxid),
              ]),
            ],
          );
          addTearDown(container.dispose);

          final state = container.read(previewOrderDialogAcceptStateProvider);
          expect(state, isA<PreviewOrderDialogAcceptStateAccepted>());
        },
      );
    });
  });
}

// Helper to create a QuoteSuccess for testing
QuoteSuccess _createMockQuoteSuccess() {
  // Create a QuoteSuccess with a minimal AmountToString instance
  final amountToString = AmountToString(locale: 'en');
  return QuoteSuccess(
    amountToString,
    From_Quote_Success(),
    AssetPair(),
    AssetType.BASE,
    TradeDir.BUY,
    AssetType.BASE,
    {},
    0,
  );
}

TransItem _createTransItem(String txid) {
  final tx = Tx()..txid = txid;
  final item = TransItem()..tx = tx;
  return item;
}
