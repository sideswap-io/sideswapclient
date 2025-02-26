import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/providers/wallet.dart';

part 'mnemonic_table_provider.g.dart';

@riverpod
class CurrentMnemonicIndexNotifier extends _$CurrentMnemonicIndexNotifier {
  @override
  int build() {
    return 0;
  }

  void setIndex(int value) {
    state = value;
  }
}

@riverpod
FutureOr<List<String>> wordListFuture(Ref ref) async {
  return [
    ...const LineSplitter().convert(
      await rootBundle.loadString('assets/wordlist.txt'),
    ),
  ]..sort();
}

class WordItem {
  final String word;
  final bool isCorrect;
  WordItem({this.word = '', this.isCorrect = false});

  WordItem copyWith({String? word, bool? isCorrect}) {
    return WordItem(
      word: word ?? this.word,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  String toString() => 'WordItem(word: $word, isCorrect: $isCorrect)';

  @override
  bool operator ==(covariant WordItem other) {
    if (identical(this, other)) return true;

    return other.word == word && other.isCorrect == isCorrect;
  }

  @override
  int get hashCode => word.hashCode ^ isCorrect.hashCode;
}

@Riverpod(keepAlive: true)
class MnemonicWordsCounterNotifier extends _$MnemonicWordsCounterNotifier {
  @override
  int build() {
    return 12;
  }

  void set12Words() {
    state = 12;
  }

  void set24Words() {
    state = 24;
  }
}

@Riverpod(keepAlive: true)
class MnemonicWordItemsNotifier extends _$MnemonicWordItemsNotifier {
  @override
  Map<int, WordItem> build() {
    final mnemonicCounter = ref.watch(mnemonicWordsCounterNotifierProvider);
    final words = ref.watch(walletProvider).getMnemonicWords();
    if (words.isNotEmpty) {
      return Map.fromEntries(
        List.generate(
          words.length,
          (index) =>
              MapEntry(index, WordItem(word: words[index], isCorrect: true)),
        ),
      );
    }
    return Map.fromEntries(
      List.generate(mnemonicCounter, (index) => MapEntry(index, WordItem())),
    );
  }

  void setItems(Map<int, WordItem> value) {
    state = value;
  }

  int maxIndex() {
    return length() - 1;
  }

  int length() {
    return state.length;
  }

  WordItem word(int index) {
    if (index < 0 || index > maxIndex()) {
      return WordItem();
    }

    return state[index] ?? WordItem();
  }

  bool mnemonicIsValid() {
    for (var wordItem in state.values) {
      if (!wordItem.isCorrect) {
        return false;
      }
    }

    return true;
  }

  void importMnemonic() {
    if (!mnemonicIsValid()) {
      return;
    }

    final newMnemonic = mnemonic();
    if (!ref.read(walletProvider).validateMnemonic(newMnemonic)) {
      ref.read(walletProvider).setImportWalletResult(false);
      return;
    }

    Future.microtask(
      () => ref.read(walletProvider).importMnemonic(newMnemonic),
    );
  }

  String mnemonic() {
    final wordList = <String>[];
    for (var wordItem in state.values) {
      wordList.add(wordItem.word);
    }
    final result = wordList.fold<String>(
      '',
      (previousValue, element) => '$previousValue ${element.trim()}',
    );
    return result.trim();
  }

  Future<void> validate(String value, int currentIndex) async {
    final searchWord = value.toLowerCase();

    final wordItems = {...state};

    if (searchWord.isEmpty) {
      wordItems[currentIndex] = WordItem();
      state = wordItems;
      return;
    }

    final previousValue = wordItems[currentIndex]!.word;
    if (previousValue.length > searchWord.length &&
        previousValue.startsWith(searchWord)) {
      final wordlist = await ref.read(wordListFutureProvider.future);
      final found = wordlist.any((e) => e == searchWord);
      wordItems[currentIndex] = WordItem(word: searchWord, isCorrect: found);
      state = wordItems;
      return;
    }
  }

  Future<void> validateOnSubmit(String value, int currentIndex) async {
    final List<String> choosedWords = [];
    final searchWord = value.toLowerCase();
    final wordlist = await ref.read(wordListFutureProvider.future);

    for (var w in wordlist) {
      if (w.startsWith(searchWord)) {
        choosedWords.add(w);
      }
    }

    if (choosedWords.contains(searchWord)) {
      final choosedIndex = choosedWords.indexOf(searchWord);
      final wordItems = {...state};
      wordItems[currentIndex] = WordItem(
        word: choosedWords[choosedIndex],
        isCorrect: true,
      );
      nextWord(currentIndex);
      state = wordItems;
    }
  }

  void nextWord(int index) {
    final currentIndex = ref.read(currentMnemonicIndexNotifierProvider);

    if (index >= 0 && index < maxIndex() && index == currentIndex) {
      ref
          .read(currentMnemonicIndexNotifierProvider.notifier)
          .setIndex(currentIndex + 1);
    }
  }

  Future<void> validateAllItems() async {
    final wordItems = {...state};
    final wordlist = await ref.read(wordListFutureProvider.future);

    for (var index in wordItems.keys) {
      final searchWord = wordItems[index]?.word ?? '';
      if (searchWord.isNotEmpty) {
        final found = wordlist.any((e) => e == searchWord);
        wordItems[index] = WordItem(word: searchWord, isCorrect: found);
      }
    }
    state = wordItems;
  }

  Future<Iterable<String>> suggestions(String text) async {
    if (text.isEmpty) {
      return const Iterable.empty();
    }

    final wordlist = await ref.read(wordListFutureProvider.future);
    return wordlist.where((word) => word.startsWith(text));
  }
}
