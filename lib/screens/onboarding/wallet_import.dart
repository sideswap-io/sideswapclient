import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/decorations/side_swap_input_decoration.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/mnemonic_table.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';

extension Utility on BuildContext {
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (FocusScope.of(this).focusedChild?.context?.widget
        is! EditableText);
  }
}

class WalletImportInputs extends ConsumerStatefulWidget {
  const WalletImportInputs({required this.wordCount, super.key});

  final int wordCount;

  @override
  WalletImportInputsState createState() => WalletImportInputsState();
}

class WalletImportInputsState extends ConsumerState<WalletImportInputs> {
  late List<ValueNotifier<String>> words = List.generate(
    widget.wordCount,
    (index) => ValueNotifier(''),
  );
  final wordList = <String>[];
  late final List<bool> _errorField = List<bool>.generate(
    widget.wordCount,
    (index) => false,
  );

  final _textEditingControllerList = <TextEditingController>[];
  final _focusNodeList = <FocusNode>[];
  ScrollController? _listScrollController;
  final _suggestionsBoxController = SuggestionsBoxController();

  var _selectedItem = 0;

  double _textFieldWidth = 0;
  double _textFieldPadding = 0;
  double _textFieldLeftPadding = 0;

  String getMnemonic() {
    final result = words.fold<String>(
      '',
      (previousValue, element) => '$previousValue ${element.value.trim()}',
    );
    return result.trim();
  }

  Future<List<String>> _loadWordList() async {
    if (wordList.isEmpty) {
      await rootBundle.loadString('assets/wordlist.txt').then((q) {
        for (var i in const LineSplitter().convert(q)) {
          wordList.add(i);
        }
      });
    }
    return wordList;
  }

  List<String> getSuggestions(String pattern) {
    if (pattern.isEmpty) {
      return <String>[];
    }
    final suggestionList =
        wordList.where((e) => e.startsWith(pattern)).toList();
    return suggestionList;
  }

  @override
  void initState() {
    super.initState();

    _textFieldWidth = 270.0;
    _textFieldPadding = 10.0;

    for (var i = 0; i < widget.wordCount; i++) {
      _textEditingControllerList.add(TextEditingController());
      _focusNodeList.add(FocusNode());
    }

    _listScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // focus first TextField
      _focusNodeList[_selectedItem].requestFocus();
      await _loadWordList();
    });
  }

  @override
  void dispose() {
    for (var controller in _textEditingControllerList) {
      controller.dispose();
    }

    for (var focusNode in _focusNodeList) {
      focusNode.dispose();
    }

    _listScrollController?.dispose();
    _suggestionsBoxController.close();

    super.dispose();
  }

  void _jumpTo(int index, {bool unfocus = true}) {
    validate();

    if (index >= widget.wordCount) {
      _focusNodeList[widget.wordCount - 1].unfocus();
      return;
    }

    if (unfocus) {
      _focusNodeList[index].unfocus();
    }

    var additionalPadding = .0;
    if (index > 0) {
      additionalPadding = _textFieldPadding * index;
    }

    // animate instead jumpTo may cause bugs
    if (index == 0) {
      _listScrollController?.jumpTo(
        _listScrollController?.position.minScrollExtent ?? 0,
      );
    } else if (index == widget.wordCount - 1) {
      _listScrollController?.jumpTo(
        _listScrollController?.position.maxScrollExtent ?? 0,
      );
    } else {
      _listScrollController?.jumpTo(
        (_textFieldWidth * index + additionalPadding),
      );
    }

    if (index < _focusNodeList.length) {
      _focusNodeList[index].requestFocus();
    }

    setState(() {
      _selectedItem = index;
    });
  }

  void validate() {
    var index = 0;
    for (var controller in _textEditingControllerList) {
      final text = controller.text;
      final suggestionList = getSuggestions(text);

      words[index].value = text;

      if (text.isEmpty) {
        _errorField[index] = false;
      } else if (suggestionList.any((e) => e == text)) {
        _errorField[index] = false;
      } else {
        _errorField[index] = true;
      }

      index++;
    }

    setState(() {});
  }

  Future<void> validateFinal(WidgetRef ref) async {
    var index = 0;
    for (var word in words) {
      final suggestionList = getSuggestions(word.value);

      if (suggestionList.any((e) => e == word.value)) {
        _errorField[index] = false;
      } else {
        _errorField[index] = true;
      }

      index++;
    }

    final wrongIndex = _errorField.indexWhere((e) => e == true);

    if (wrongIndex == -1) {
      await nextPage(ref);
      return;
    }

    _textEditingControllerList[wrongIndex].text = '';
    _jumpTo(wrongIndex);

    setState(() {});
  }

  bool isCorrectWord(int index) {
    if (words[index].value.isEmpty) {
      return false;
    }

    final suggestionList = getSuggestions(words[index].value);
    if (suggestionList.any((e) => e == words[index].value)) {
      return true;
    }

    return false;
  }

  Future<void> nextPage(WidgetRef ref) async {
    for (var focusNode in _focusNodeList) {
      focusNode.unfocus();
    }

    FocusManager.instance.primaryFocus?.unfocus();
    final mnemonic = getMnemonic();
    final wallet = ref.read(walletProvider);
    if (!wallet.validateMnemonic(mnemonic)) {
      wallet.setImportWalletResult(false);
      return;
    }
    wallet.importMnemonic(mnemonic);
  }

  void tryJump(int index) {
    if (words[index].value.isEmpty) {
      return;
    }

    final suggestionList = getSuggestions(words[index].value);
    if (suggestionList.length != 1) {
      return;
    }

    if (isCorrectWord(index)) {
      if (index >= widget.wordCount - 1) {
        validateFinal(ref);
      }

      Future.delayed(const Duration(milliseconds: 30), () {
        _jumpTo(index + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    _textFieldLeftPadding = max(
      (screenWidth - _textFieldWidth - (8 * _textFieldPadding)) / 2,
      0,
    );

    return Column(
      children: [
        SizedBox(
          height: 54,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            controller: _listScrollController,
            scrollDirection: Axis.horizontal,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: List<Widget>.generate(widget.wordCount, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? _textFieldLeftPadding : _textFieldPadding,
                  right:
                      index == widget.wordCount - 1
                          ? _textFieldLeftPadding + 2 * _textFieldPadding
                          : 0,
                ),
                child: Container(
                  width: _textFieldWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        _selectedItem == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.3),
                  ),
                  child: TypeAheadFormField<String>(
                    hideOnEmpty: true,
                    hideOnLoading: true,
                    debounceDuration: Duration.zero,
                    animationDuration: Duration.zero,
                    suggestionsBoxController: _suggestionsBoxController,
                    suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                      constraints: BoxConstraints(maxHeight: 17 * 12),
                      color: Color(0xFF1E6389),
                    ),
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _textEditingControllerList[index],
                      focusNode: _focusNodeList[index],
                      textCapitalization: TextCapitalization.none,
                      textInputAction:
                          index == widget.wordCount - 1
                              ? TextInputAction.done
                              : TextInputAction.next,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      decoration: SideSwapInputDecoration(
                        fillColor: Colors.transparent,
                        isDense: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          bottom: 10,
                          top: 10,
                          right: 10,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        hintText: '',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        final oldValue = words[index].value;
                        words[index].value = value;

                        if (oldValue != value) {
                          tryJump(index);
                        }
                      },
                      onTap: () {
                        _jumpTo(index, unfocus: false);
                      },
                      onSubmitted: (value) async {
                        _jumpTo(index + 1);
                        if (index >= widget.wordCount - 1) {
                          await validateFinal(ref);
                        }
                      },
                      onEditingComplete: () async {
                        _jumpTo(index + 1);
                        if (index >= widget.wordCount - 1) {
                          await validateFinal(ref);
                        }
                      },
                    ),
                    suggestionsCallback: (pattern) async {
                      return getSuggestions(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(
                          suggestion,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) async {
                      _textEditingControllerList[index].text = suggestion;
                      setState(() {
                        _focusNodeList[index].unfocus();
                      });
                      _jumpTo(index + 1);
                      if (index >= widget.wordCount - 1) {
                        await validateFinal(ref);
                      }
                    },
                    onSaved: (value) {},
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 38),
        MnemonicTable(
          onCheckField: (index) {
            return isCorrectWord(index) && !_errorField[index];
          },
          onTapIndex: (index) {
            _jumpTo(index);
          },
          onCheckError: (index) {
            return _errorField[index];
          },
          currentSelectedItem: _selectedItem,
          words: words,
        ),
      ],
    );
  }
}

class WalletImport extends StatefulWidget {
  const WalletImport({super.key});

  @override
  WalletImportState createState() => WalletImportState();
}

class WalletImportState extends State<WalletImport> {
  final _scaffoldKey = GlobalKey();

  final _colorToggleBackground = SideSwapColors.prussianBlue;
  final _colorToggleOn = const Color(0xFF1F7EB1);
  final _colorToggleTextOn = const Color(0xFFFFFFFF);
  final _colorToggleTextOff = SideSwapColors.airSuperiorityBlue;

  bool shortMnemonic = true;

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: 'Enter your recovery phrase'.tr()),
      body: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: double.maxFinite,
                            height: 39,
                            decoration: BoxDecoration(
                              color: _colorToggleBackground,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SwapButton(
                                    color:
                                        shortMnemonic
                                            ? _colorToggleOn
                                            : _colorToggleBackground,
                                    text: '12 words'.tr(),
                                    textColor:
                                        shortMnemonic
                                            ? _colorToggleTextOn
                                            : _colorToggleTextOff,
                                    onPressed:
                                        () => setState(() {
                                          shortMnemonic = true;
                                        }),
                                  ),
                                ),
                                Expanded(
                                  child: SwapButton(
                                    color:
                                        !shortMnemonic
                                            ? _colorToggleOn
                                            : _colorToggleBackground,
                                    text: '24 words'.tr(),
                                    textColor:
                                        !shortMnemonic
                                            ? _colorToggleTextOn
                                            : _colorToggleTextOff,
                                    onPressed:
                                        () => setState(() {
                                          shortMnemonic = false;
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        WalletImportInputs(
                          key: ValueKey(shortMnemonic),
                          wordCount: shortMnemonic ? 12 : 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
