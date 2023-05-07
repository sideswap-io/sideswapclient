import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/wallet.dart';

final currentMnemonicIndexProvider = StateProvider.autoDispose<int>((ref) {
  ref.watch(mnemonicWordsCounterProvider);
  return 0;
});

final wordListFutureProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final List<String> wordList = [];
  await rootBundle.loadString('assets/wordlist.txt').then((q) {
    for (var i in const LineSplitter().convert(q)) {
      wordList.add(i);
    }
  });
  wordList.sort();
  return wordList;
});

class WordItem {
  final String word;
  final bool correct;

  WordItem(this.word, this.correct);
}

final mnemonicWordsCounterProvider =
    StateNotifierProvider.autoDispose<MnemonicWordsCounterProvider, int>(
        (ref) => MnemonicWordsCounterProvider(ref));

class MnemonicWordsCounterProvider extends StateNotifier<int> {
  final Ref ref;

  MnemonicWordsCounterProvider(this.ref) : super(12);

  void set12Words() {
    state = 12;
  }

  void set24Words() {
    state = 24;
  }
}

final mnemonicWordItemsProvider =
    StateProvider.autoDispose<Map<int, WordItem>>((ref) {
  final mnemonicCounter = ref.watch(mnemonicWordsCounterProvider);
  return Map.fromEntries(List.generate(
      mnemonicCounter, (index) => MapEntry(index, WordItem('', false))));
});

final mnemonicTableProvider =
    ChangeNotifierProvider.autoDispose<MnemonicTableProvider>((ref) {
  ref.keepAlive();
  final wordItems = ref.watch(mnemonicWordItemsProvider);
  final wordList = ref
      .watch(wordListFutureProvider)
      .maybeWhen(data: (data) => data, orElse: () => <String>[]);

  return MnemonicTableProvider(ref, wordItems, wordList);
});

class MnemonicTableProvider extends ChangeNotifier {
  final Ref ref;
  Map<int, WordItem> wordItems;
  final List<String> wordlist;

  MnemonicTableProvider(this.ref, this.wordItems, this.wordlist);

  void setWordItems(Map<int, WordItem> value) {
    wordItems = value;
    notifyListeners();
  }

  int maxIndex() {
    return length() - 1;
  }

  int length() {
    return wordItems.length;
  }

  WordItem word(int index) {
    if (index < 0 || index > maxIndex()) {
      return WordItem('', false);
    }

    return wordItems[index]!;
  }

  bool mnemonicIsValid() {
    for (var wordItem in wordItems.values) {
      if (!wordItem.correct) {
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
    ref.read(walletProvider).importMnemonic(newMnemonic);
  }

  String mnemonic() {
    final wordList = <String>[];
    for (var wordItem in wordItems.values) {
      wordList.add(wordItem.word);
    }
    final result = wordList.fold<String>(
        '', (previousValue, element) => '$previousValue ${element.trim()}');
    return result.trim();
  }

  void validate(String value, int currentIndex) {
    final searchWord = value.toLowerCase();

    if (searchWord.isEmpty) {
      wordItems[currentIndex] = WordItem('', false);
      notifyListeners();
      return;
    }

    final previousValue = wordItems[currentIndex]!.word;
    if (previousValue.length > searchWord.length &&
        previousValue.startsWith(searchWord)) {
      final found = wordlist.any((e) => e == searchWord);
      wordItems[currentIndex] = WordItem(searchWord, found);
      notifyListeners();
      return;
    }

    // final List<String> choosedWords = [];
    // for (var w in wordlist) {
    //   if (w.startsWith(searchWord)) {
    //     choosedWords.add(w);
    //   }
    // }

    // if (choosedWords.length == 1 && searchWord.length > 3) {
    //   wordItems[currentIndex] = WordItem(choosedWords[0], true);
    //   nextWord(currentIndex);
    //   notifyListeners();
    // } else {
    //   final found = wordlist.any((e) => e == searchWord);
    //   if (found) {
    //     wordItems[currentIndex] = WordItem(searchWord, true);
    //   } else {
    //     wordItems[currentIndex] = WordItem(searchWord, false);
    //   }
    //   notifyListeners();
    // }
  }

  void validateOnSubmit(String value, int currentIndex) {
    final List<String> choosedWords = [];
    final searchWord = value.toLowerCase();

    for (var w in wordlist) {
      if (w.startsWith(searchWord)) {
        choosedWords.add(w);
      }
    }

    if (choosedWords.contains(searchWord)) {
      final choosedIndex = choosedWords.indexOf(searchWord);
      wordItems[currentIndex] = WordItem(choosedWords[choosedIndex], true);
      nextWord(currentIndex);
      notifyListeners();
    }
  }

  void nextWord(int currentIndex) {
    if (currentIndex >= 0 &&
        currentIndex < maxIndex() &&
        currentIndex == ref.read(currentMnemonicIndexProvider)) {
      ref.read(currentMnemonicIndexProvider.notifier).state++;
    }
  }

  void validateAllItems() {
    for (var index in wordItems.keys) {
      final searchWord = wordItems[index]?.word ?? '';
      if (searchWord.isNotEmpty) {
        final found = wordlist.any((e) => e == searchWord);
        wordItems[index] = WordItem(searchWord, found);
      }
    }
    notifyListeners();
  }

  Iterable<String> suggestions(String text) {
    if (text.isEmpty) {
      return const Iterable.empty();
    }
    return wordlist.where((word) => word.startsWith(text));
  }
}
