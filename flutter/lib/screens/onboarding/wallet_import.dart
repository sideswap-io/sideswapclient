import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/decorations/side_swap_input_decoration.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/mnemonic_table.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';

extension Utility on BuildContext {
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (
        FocusScope.of(this).focusedChild?.context?.widget is! EditableText);
  }
}

class WalletImportInputs extends ConsumerStatefulWidget {
  const WalletImportInputs({required this.wordCount, super.key});

  final int wordCount;

  @override
  WalletImportInputsState createState() => WalletImportInputsState();
}

class WalletImportInputsState extends ConsumerState<WalletImportInputs> {
  late List<ValueNotifier<String>> words =
      List.generate(widget.wordCount, (index) => ValueNotifier(''));
  final wordList = <String>[];
  late final List<bool> _errorField =
      List<bool>.generate(widget.wordCount, (index) => false);

  final _textEditingControllerList = <TextEditingController>[];
  final _focusNodeList = <FocusNode>[];
  ScrollController? _listScrollController;
  final _suggestionsBoxController = SuggestionsBoxController();

  var _selectedItem = 0;

  double _textFieldWidth = 0;
  double _textFieldPadding = 0;
  double _textFieldLeftPadding = 0;

  String getMnemonic() {
    final result = words.fold<String>('',
        (previousValue, element) => '$previousValue ${element.value.trim()}');
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

    _textFieldWidth = 270.w;
    _textFieldPadding = 10.w;
    _textFieldLeftPadding = (SideSwapScreenUtil.screenWidth -
            _textFieldWidth -
            (2 * _textFieldPadding)) /
        2;

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
      _listScrollController
          ?.jumpTo(_listScrollController?.position.minScrollExtent ?? 0);
    } else if (index == widget.wordCount - 1) {
      _listScrollController
          ?.jumpTo(_listScrollController?.position.maxScrollExtent ?? 0);
    } else {
      _listScrollController
          ?.jumpTo((_textFieldWidth * index + additionalPadding));
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 54.h,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            controller: _listScrollController,
            scrollDirection: Axis.horizontal,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: List<Widget>.generate(
              widget.wordCount,
              (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left:
                        index == 0 ? _textFieldLeftPadding : _textFieldPadding,
                    right: index == widget.wordCount - 1
                        ? _textFieldLeftPadding + 2 * _textFieldPadding
                        : 0,
                  ),
                  child: Container(
                    width: _textFieldWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.w),
                      color: _selectedItem == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                    ),
                    child: TypeAheadFormField<String>(
                      hideOnEmpty: true,
                      hideOnLoading: true,
                      debounceDuration: Duration.zero,
                      animationDuration: Duration.zero,
                      suggestionsBoxController: _suggestionsBoxController,
                      suggestionsBoxDecoration: SuggestionsBoxDecoration(
                        constraints: BoxConstraints(maxHeight: 17.sp * 12),
                        color: const Color(0xFF1E6389),
                      ),
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _textEditingControllerList[index],
                        focusNode: _focusNodeList[index],
                        textCapitalization: TextCapitalization.none,
                        textInputAction: index == widget.wordCount - 1
                            ? TextInputAction.done
                            : TextInputAction.next,
                        style: GoogleFonts.roboto(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        decoration: SideSwapInputDecoration(
                          fillColor: Colors.transparent,
                          isDense: true,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                              left: 10, bottom: 10, top: 10, right: 10),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 16.w, right: 16.w),
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.roboto(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF00C5FF),
                              ),
                            ),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 0, minHeight: 0),
                          hintText: '',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onChanged: (value) {
                          words[index].value = value;
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
                            style: GoogleFonts.roboto(
                              fontSize: 17.sp,
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
              },
            ),
          ),
        ),
        SizedBox(
          height: 38.h,
        ),
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

  final _colorToggleBackground = const Color(0xFF043857);
  final _colorToggleOn = const Color(0xFF1F7EB1);
  final _colorToggleTextOn = const Color(0xFFFFFFFF);
  final _colorToggleTextOff = const Color(0xFF709EBA);

  bool shortMnemonic = true;

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Enter your recovery phrase'.tr(),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.maxFinite,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: _colorToggleBackground,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0.w)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SwapButton(
                                color: shortMnemonic
                                    ? _colorToggleOn
                                    : _colorToggleBackground,
                                text: '12 words'.tr(),
                                textColor: shortMnemonic
                                    ? _colorToggleTextOn
                                    : _colorToggleTextOff,
                                onPressed: () => setState(() {
                                  shortMnemonic = true;
                                }),
                              ),
                            ),
                            Expanded(
                              child: SwapButton(
                                color: !shortMnemonic
                                    ? _colorToggleOn
                                    : _colorToggleBackground,
                                text: '24 words'.tr(),
                                textColor: !shortMnemonic
                                    ? _colorToggleTextOn
                                    : _colorToggleTextOff,
                                onPressed: () => setState(() {
                                  shortMnemonic = false;
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
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
