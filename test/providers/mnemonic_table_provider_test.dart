import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/providers/licenses_provider.dart';
import 'package:sideswap/providers/mnemonic_table_provider.dart';
import 'package:sideswap/providers/wallet.dart';

// Mock wallet provider
class MockSideswapWallet extends Mock implements SideswapWallet {}

class FakeAssetBundle extends Fake implements AssetBundle {
  final String content;
  FakeAssetBundle([this.content = 'banana\napple\ncherry']);

  @override
  Future<String> loadString(String key, {bool cache = true}) async => content;
}

void main() {
  group('WordItem', () {
    group('constructor', () {
      test('creates instance with default values', () {
        final item = WordItem();
        expect(item.word, '');
        expect(item.isCorrect, false);
      });

      test('creates instance with custom values', () {
        final item = WordItem(word: 'test', isCorrect: true);
        expect(item.word, 'test');
        expect(item.isCorrect, true);
      });
    });

    group('copyWith', () {
      test('returns new instance with updated word', () {
        final item = WordItem(word: 'old', isCorrect: true);
        final updated = item.copyWith(word: 'new');
        expect(updated.word, 'new');
        expect(updated.isCorrect, true);
      });

      test('returns new instance with updated isCorrect', () {
        final item = WordItem(word: 'test', isCorrect: false);
        final updated = item.copyWith(isCorrect: true);
        expect(updated.word, 'test');
        expect(updated.isCorrect, true);
      });

      test('returns new instance with both fields updated', () {
        final item = WordItem(word: 'old', isCorrect: false);
        final updated = item.copyWith(word: 'new', isCorrect: true);
        expect(updated.word, 'new');
        expect(updated.isCorrect, true);
      });

      test('preserves fields when no parameters provided', () {
        final item = WordItem(word: 'test', isCorrect: true);
        final updated = item.copyWith();
        expect(updated.word, 'test');
        expect(updated.isCorrect, true);
      });
    });

    group('equality', () {
      test('items with same fields are equal', () {
        final item1 = WordItem(word: 'test', isCorrect: true);
        final item2 = WordItem(word: 'test', isCorrect: true);
        expect(item1, equals(item2));
      });

      test('items with different words are not equal', () {
        final item1 = WordItem(word: 'test1', isCorrect: true);
        final item2 = WordItem(word: 'test2', isCorrect: true);
        expect(item1, isNot(equals(item2)));
      });

      test('items with different isCorrect are not equal', () {
        final item1 = WordItem(word: 'test', isCorrect: true);
        final item2 = WordItem(word: 'test', isCorrect: false);
        expect(item1, isNot(equals(item2)));
      });

      test('identical instance equals itself', () {
        final item = WordItem(word: 'test', isCorrect: true);
        expect(item, equals(item));
      });
    });

    group('hashCode', () {
      test('equal items have same hashCode', () {
        final item1 = WordItem(word: 'test', isCorrect: true);
        final item2 = WordItem(word: 'test', isCorrect: true);
        expect(item1.hashCode, equals(item2.hashCode));
      });

      test('different items have different hashCode', () {
        final item1 = WordItem(word: 'test1', isCorrect: true);
        final item2 = WordItem(word: 'test2', isCorrect: true);
        expect(item1.hashCode, isNot(equals(item2.hashCode)));
      });
    });

    group('toString', () {
      test('returns formatted string representation', () {
        final item = WordItem(word: 'test', isCorrect: true);
        expect(item.toString(), 'WordItem(word: test, isCorrect: true)');
      });
    });
  });

  group('CurrentMnemonicIndexNotifier', () {
    group('setIndex', () {
      test('round-trip: set then read returns same value', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(currentMnemonicIndexProvider), 0);
        container.read(currentMnemonicIndexProvider.notifier).setIndex(5);
        expect(container.read(currentMnemonicIndexProvider), 5);
      });
    });
  });

  group('wordListFuture', () {
    test('returns sorted list from asset bundle', () async {
      final container = ProviderContainer.test(
        overrides: [
          assetBundleProvider.overrideWithValue(FakeAssetBundle()),
        ],
      );
      addTearDown(container.dispose);
      final result = await container.read(wordListFutureProvider.future);
      expect(result, ['apple', 'banana', 'cherry']);
    });

    test('sorts unsorted input', () async {
      final container = ProviderContainer.test(
        overrides: [
          assetBundleProvider.overrideWithValue(FakeAssetBundle('cherry\napple\nbanana')),
        ],
      );
      addTearDown(container.dispose);
      final result = await container.read(wordListFutureProvider.future);
      expect(result, ['apple', 'banana', 'cherry']);
    });
  });

  group('MnemonicWordsCounterNotifier', () {
    group('build', () {
      test('returns 12 as initial state', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(mnemonicWordsCounterProvider), 12);
      });
    });

    group('set12Words', () {
      test('sets state to 12', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        container.read(mnemonicWordsCounterProvider.notifier).set24Words();
        expect(container.read(mnemonicWordsCounterProvider), 24);
        container.read(mnemonicWordsCounterProvider.notifier).set12Words();
        expect(container.read(mnemonicWordsCounterProvider), 12);
      });
    });

    group('set24Words', () {
      test('sets state to 24', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        container.read(mnemonicWordsCounterProvider.notifier).set24Words();
        expect(container.read(mnemonicWordsCounterProvider), 24);
      });
    });

  });

  group('MnemonicWordItemsNotifier', () {
    late MockSideswapWallet mockWallet;

    setUp(() {
      mockWallet = MockSideswapWallet();
    });

    group('build', () {
      test('initializes with empty WordItems map when wallet has no words', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final state = container.read(mnemonicWordItemsProvider);
        expect(state.length, 12);
        expect(state.values.every((item) => item.word.isEmpty), true);
        expect(state.values.every((item) => !item.isCorrect), true);
      });

      test('initializes with 24 empty items when counter is 24 and wallet has no words', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            mnemonicWordsCounterProvider.overrideWithValue(24),
          ],
        );
        addTearDown(container.dispose);
        final state = container.read(mnemonicWordItemsProvider);
        expect(state.length, 24);
      });

      test('initializes with wallet words marked as correct', () {
        final words = ['apple', 'banana', 'cherry'];
        when(() => mockWallet.getMnemonicWords()).thenReturn(words);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final state = container.read(mnemonicWordItemsProvider);
        expect(state.length, 3);
        expect(state[0]?.word, 'apple');
        expect(state[0]?.isCorrect, true);
        expect(state[1]?.word, 'banana');
        expect(state[1]?.isCorrect, true);
        expect(state[2]?.word, 'cherry');
        expect(state[2]?.isCorrect, true);
      });
    });

    group('setItems', () {
      test('updates state with new map', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final newItems = {
          0: WordItem(word: 'test', isCorrect: true),
        };
        container.read(mnemonicWordItemsProvider.notifier).setItems(newItems);
        final state = container.read(mnemonicWordItemsProvider);
        expect(state.length, 1);
        expect(state[0]?.word, 'test');
      });
    });

    group('length and maxIndex', () {
      final cases = [
        (count: 0, len: 0, max: -1),
        (count: 12, len: 12, max: 11),
        (count: 24, len: 24, max: 23),
      ];
      for (final c in cases) {
        test('length is ${c.len} and maxIndex is ${c.max} for ${c.count}-word counter', () {
          when(() => mockWallet.getMnemonicWords()).thenReturn([]);
          final container = ProviderContainer.test(
            overrides: [
              walletProvider.overrideWithValue(mockWallet),
              mnemonicWordsCounterProvider.overrideWithValue(c.count),
            ],
          );
          addTearDown(container.dispose);
          final notifier = container.read(mnemonicWordItemsProvider.notifier);
          expect(notifier.length(), c.len);
          expect(notifier.maxIndex(), c.max);
        });
      }
    });

    group('word', () {
      test('returns WordItem at valid index', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            mnemonicWordsCounterProvider.overrideWithValue(12),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final word = notifier.word(0);
        expect(word.word, '');
        expect(word.isCorrect, false);
      });

      test('returns empty WordItem for negative index', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            mnemonicWordsCounterProvider.overrideWithValue(12),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final word = notifier.word(-1);
        expect(word, WordItem());
      });

      test('returns empty WordItem for index beyond maxIndex', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            mnemonicWordsCounterProvider.overrideWithValue(12),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final word = notifier.word(12);
        expect(word, WordItem());
      });

      test('returns correct item at boundary index 0', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn(['test']);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final word = notifier.word(0);
        expect(word.word, 'test');
        expect(word.isCorrect, true);
      });
    });

    group('mnemonicIsValid', () {
      test('returns true when all items are correct', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'apple', isCorrect: true),
          1: WordItem(word: 'banana', isCorrect: true),
          2: WordItem(word: 'cherry', isCorrect: true),
        };
        notifier.setItems(items);
        expect(notifier.mnemonicIsValid(), true);
      });

      test('returns false when any item is incorrect', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'apple', isCorrect: true),
          1: WordItem(word: 'invalid', isCorrect: false),
          2: WordItem(word: 'cherry', isCorrect: true),
        };
        notifier.setItems(items);
        expect(notifier.mnemonicIsValid(), false);
      });

      test('returns true for empty state (vacuous truth)', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            mnemonicWordsCounterProvider.overrideWithValue(0),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        expect(notifier.mnemonicIsValid(), true);
      });

      test('returns true when single item is correct', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'apple', isCorrect: true),
        };
        notifier.setItems(items);
        expect(notifier.mnemonicIsValid(), true);
      });

      test('returns false when single item is incorrect', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'invalid', isCorrect: false),
        };
        notifier.setItems(items);
        expect(notifier.mnemonicIsValid(), false);
      });
    });

    group('mnemonic', () {
      test('returns empty string for empty state', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            mnemonicWordsCounterProvider.overrideWithValue(0),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        expect(notifier.mnemonic(), '');
      });

      test('returns single word', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'apple', isCorrect: true),
        };
        notifier.setItems(items);
        expect(notifier.mnemonic(), 'apple');
      });

      test('returns space-separated words', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'apple', isCorrect: true),
          1: WordItem(word: 'banana', isCorrect: true),
          2: WordItem(word: 'cherry', isCorrect: true),
        };
        notifier.setItems(items);
        expect(notifier.mnemonic(), 'apple banana cherry');
      });

      test('trims whitespace from words', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: '  apple  ', isCorrect: true),
          1: WordItem(word: '  banana  ', isCorrect: true),
        };
        notifier.setItems(items);
        expect(notifier.mnemonic(), 'apple banana');
      });

      test('handles empty words in state', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'apple', isCorrect: true),
          1: WordItem(word: '', isCorrect: false),
          2: WordItem(word: 'cherry', isCorrect: true),
        };
        notifier.setItems(items);
        expect(notifier.mnemonic(), 'apple  cherry');
      });
    });

    group('nextWord', () {
      test('increments currentMnemonicIndex when conditions met', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            mnemonicWordsCounterProvider.overrideWithValue(12),
          ],
        );
        addTearDown(container.dispose);
        expect(container.read(currentMnemonicIndexProvider), 0);
        container
            .read(mnemonicWordItemsProvider.notifier)
            .nextWord(0);
        expect(container.read(currentMnemonicIndexProvider), 1);
      });

      test('does not increment when index is negative', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            mnemonicWordsCounterProvider.overrideWithValue(12),
          ],
        );
        addTearDown(container.dispose);
        container
            .read(mnemonicWordItemsProvider.notifier)
            .nextWord(-1);
        expect(container.read(currentMnemonicIndexProvider), 0);
      });

      test('does not increment when index equals maxIndex', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            mnemonicWordsCounterProvider.overrideWithValue(12),
          ],
        );
        addTearDown(container.dispose);
        container.read(currentMnemonicIndexProvider.notifier).setIndex(11);
        container
            .read(mnemonicWordItemsProvider.notifier)
            .nextWord(11);
        expect(container.read(currentMnemonicIndexProvider), 11);
      });

      test('does not increment when index exceeds maxIndex', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            mnemonicWordsCounterProvider.overrideWithValue(12),
          ],
        );
        addTearDown(container.dispose);
        container
            .read(mnemonicWordItemsProvider.notifier)
            .nextWord(12);
        expect(container.read(currentMnemonicIndexProvider), 0);
      });

      test('does not increment when index does not match currentMnemonicIndex', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            mnemonicWordsCounterProvider.overrideWithValue(12),
          ],
        );
        addTearDown(container.dispose);
        container.read(currentMnemonicIndexProvider.notifier).setIndex(5);
        container
            .read(mnemonicWordItemsProvider.notifier)
            .nextWord(0);
        expect(container.read(currentMnemonicIndexProvider), 5);
      });
    });

    group('importMnemonic', () {
      test('does nothing when mnemonic is not valid', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        when(() => mockWallet.setImportWalletResult(any())).thenReturn(null);
        when(() => mockWallet.importMnemonic(any())).thenReturn(null);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'apple', isCorrect: false),
        };
        notifier.setItems(items);
        notifier.importMnemonic();
        verifyNever(() => mockWallet.validateMnemonic(any()));
        verifyNever(() => mockWallet.importMnemonic(any()));
      });

      test('calls setImportWalletResult(false) when validateMnemonic returns false', () {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        when(() => mockWallet.validateMnemonic(any())).thenReturn(false);
        when(() => mockWallet.setImportWalletResult(any())).thenReturn(null);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'apple', isCorrect: true),
        };
        notifier.setItems(items);
        notifier.importMnemonic();
        verify(() => mockWallet.validateMnemonic('apple')).called(1);
        verify(() => mockWallet.setImportWalletResult(false)).called(1);
        verifyNever(() => mockWallet.importMnemonic(any()));
      });

      test('calls importMnemonic when mnemonic is valid and validateMnemonic returns true', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        when(() => mockWallet.validateMnemonic(any())).thenReturn(true);
        when(() => mockWallet.importMnemonic(any())).thenReturn(null);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'apple', isCorrect: true),
        };
        notifier.setItems(items);
        notifier.importMnemonic();
        // Allow microtask to execute
        await Future.microtask(() {});
        verify(() => mockWallet.validateMnemonic('apple')).called(1);
        verify(() => mockWallet.importMnemonic('apple')).called(1);
      });

      test('constructs correct mnemonic from multiple words', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        when(() => mockWallet.validateMnemonic(any())).thenReturn(true);
        when(() => mockWallet.importMnemonic(any())).thenReturn(null);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'apple', isCorrect: true),
          1: WordItem(word: 'banana', isCorrect: true),
          2: WordItem(word: 'cherry', isCorrect: true),
        };
        notifier.setItems(items);
        notifier.importMnemonic();
        // Allow microtask to execute
        await Future.microtask(() {});
        verify(() => mockWallet.validateMnemonic('apple banana cherry')).called(1);
        verify(() => mockWallet.importMnemonic('apple banana cherry')).called(1);
      });
    });

    group('validate', () {
      test('sets empty WordItem when value is empty', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        await notifier.validate('', 0);
        expect(notifier.word(0), WordItem());
      });

      test('sets word to lowercase and marks incorrect when not in wordlist', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith((ref) =>['apple', 'banana']),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        await notifier.validate('CHERRY', 0);
        expect(notifier.word(0).word, 'cherry');
        expect(notifier.word(0).isCorrect, false);
      });

      test('sets word to lowercase and marks correct when in wordlist', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith((ref) =>['apple', 'banana', 'cherry']),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        await notifier.validate('APPLE', 0);
        expect(notifier.word(0).word, 'apple');
        expect(notifier.word(0).isCorrect, true);
      });

      test('updates specific index in state', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith((ref) =>['apple', 'banana']),
            mnemonicWordsCounterProvider.overrideWithValue(3),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        await notifier.validate('apple', 1);
        expect(notifier.word(0).word, '');
        expect(notifier.word(1).word, 'apple');
        expect(notifier.word(2).word, '');
      });
    });

    group('validateOnSubmit', () {
      test('does nothing when word not in suggestions', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith((ref) =>['apple', 'apricot']),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        await notifier.validateOnSubmit('banana', 0);
        expect(notifier.word(0).word, '');
      });

      test('sets word to chosen word when found', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith((ref) => Future.value(['apple', 'apricot', 'art'])),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        await notifier.validateOnSubmit('apple', 0);
        // After async operation, state should be updated with exact match
        expect(notifier.word(0).word, 'apple');
        expect(notifier.word(0).isCorrect, true);
      });

      test('calls nextWord after setting word', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith((ref) => Future.value(['apple', 'apricot'])),
            mnemonicWordsCounterProvider.overrideWithValue(12),
          ],
        );
        addTearDown(container.dispose);
        expect(container.read(currentMnemonicIndexProvider), 0);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        await notifier.validateOnSubmit('apple', 0);
        // After async operation and state update, currentMnemonicIndex should be 1
        expect(container.read(currentMnemonicIndexProvider), 1);
      });

      test('selects correct word from multiple matches', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith(
              (ref) => Future.value(['apple', 'apricot', 'application']),
            ),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        await notifier.validateOnSubmit('apricot', 0);
        expect(notifier.word(0).word, 'apricot');
      });
    });

    group('validateAllItems', () {
      test('validates all items against wordlist', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith((ref) =>['apple', 'banana', 'cherry']),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'apple', isCorrect: false),
          1: WordItem(word: 'invalid', isCorrect: false),
          2: WordItem(word: 'cherry', isCorrect: false),
        };
        notifier.setItems(items);
        await notifier.validateAllItems();
        expect(notifier.word(0).isCorrect, true);
        expect(notifier.word(1).isCorrect, false);
        expect(notifier.word(2).isCorrect, true);
      });

      test('skips empty words', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith((ref) =>['apple']),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: '', isCorrect: true),
          1: WordItem(word: 'apple', isCorrect: false),
        };
        notifier.setItems(items);
        await notifier.validateAllItems();
        expect(notifier.word(0).word, '');
        expect(notifier.word(0).isCorrect, true);
        expect(notifier.word(1).isCorrect, true);
      });

      test('updates multiple items in single pass', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith(
              (ref) => Future.value(['apple', 'banana', 'cherry', 'date']),
            ),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final items = {
          0: WordItem(word: 'apple', isCorrect: false),
          1: WordItem(word: 'banana', isCorrect: false),
          2: WordItem(word: 'invalid', isCorrect: false),
          3: WordItem(word: 'date', isCorrect: false),
        };
        notifier.setItems(items);
        await notifier.validateAllItems();
        expect(notifier.word(0).isCorrect, true);
        expect(notifier.word(1).isCorrect, true);
        expect(notifier.word(2).isCorrect, false);
        expect(notifier.word(3).isCorrect, true);
      });
    });

    group('suggestions', () {
      test('returns empty iterable when text is empty', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final result = await notifier.suggestions('');
        expect(result, isEmpty);
      });

      test('returns words starting with text', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith(
              (ref) => Future.value(['apple', 'apricot', 'banana', 'cherry']),
            ),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final result = await notifier.suggestions('ap');
        expect(result.toList(), ['apple', 'apricot']);
      });

      test('returns empty iterable when no words match', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith(
              (ref) => Future.value(['apple', 'apricot', 'banana']),
            ),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final result = await notifier.suggestions('xyz');
        expect(result, isEmpty);
      });

      test('returns single matching word', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith((ref) =>['cherry', 'banana']),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final result = await notifier.suggestions('ch');
        expect(result.toList(), ['cherry']);
      });

      test('is case-sensitive', () async {
        when(() => mockWallet.getMnemonicWords()).thenReturn([]);
        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(mockWallet),
            wordListFutureProvider.overrideWith((ref) =>['apple', 'banana']),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(mnemonicWordItemsProvider.notifier);
        final result = await notifier.suggestions('AP');
        expect(result, isEmpty);
      });
    });
  });
}
