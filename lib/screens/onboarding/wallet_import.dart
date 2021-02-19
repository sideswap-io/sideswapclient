import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/decorations/side_swap_input_decoration.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/onboarding/widgets/mnemonic_table.dart';

extension Utility on BuildContext {
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (FocusScope.of(this).focusedChild.context.widget is! EditableText);
  }
}

class WalletImport extends StatefulWidget {
  @override
  _WalletImportState createState() => _WalletImportState();
}

class _WalletImportState extends State<WalletImport> {
  final List<ValueNotifier<String>> words =
      List.generate(12, (index) => ValueNotifier(''));
  final wordList = <String>[];
  final _errorField = List<bool>.generate(12, (index) => false);

  final _textEditingControllerList = <TextEditingController>[];
  final _focusNodeList = <FocusNode>[];
  ScrollController _listScrollController;
  final _suggestionsBoxController = SuggestionsBoxController();
  final _scaffoldKey = GlobalKey();

  var _selectedItem = 0;

  double _textFieldWidth;
  double _textFieldPadding;
  double _textFieldLeftPadding;

  String getMnemonic() {
    final result = words.fold<String>('',
        (previousValue, element) => previousValue + ' ' + element.value.trim());
    return result.trim();
  }

  Future<List<String>> _loadWordList() async {
    if (wordList.isEmpty) {
      await rootBundle.loadString('assets/wordlist.txt').then((q) {
        for (var i in LineSplitter().convert(q)) {
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
    _textFieldLeftPadding =
        (ScreenUtil().screenWidth - _textFieldWidth - (2 * _textFieldPadding)) /
            2;

    for (var i = 0; i < 12; i++) {
      _textEditingControllerList.add(TextEditingController());
      _focusNodeList.add(FocusNode());
    }

    _listScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // focus first TextField
      await _loadWordList();
      _focusNodeList[_selectedItem].requestFocus();
    });
  }

  @override
  void dispose() {
    _textEditingControllerList.forEach((e) {
      e.dispose();
    });

    _focusNodeList.forEach((e) {
      e.dispose();
    });

    _listScrollController.dispose();
    _suggestionsBoxController.close();

    super.dispose();
  }

  void _jumpTo(int index, {bool unfocus = true}) {
    validate();

    if (index > 11) {
      _focusNodeList[11].unfocus();
      return;
    }

    if (unfocus) {
      _focusNodeList[index].unfocus();
    }

    var _additionalPadding = .0;
    if (index > 0) {
      _additionalPadding = _textFieldPadding * index;
    }

    // animate instead jumpTo may cause bugs
    if (index == 0) {
      _listScrollController
          .jumpTo(_listScrollController.position.minScrollExtent);
    } else if (index == 11) {
      _listScrollController
          .jumpTo(_listScrollController.position.maxScrollExtent);
    } else {
      _listScrollController
          .jumpTo((_textFieldWidth * index + _additionalPadding));
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
    _textEditingControllerList.forEach((e) {
      final text = e.text;
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
    });

    setState(() {});
  }

  void validateFinal() {
    var index = 0;
    words.forEach((text) {
      final suggestionList = getSuggestions(text.value);

      if (suggestionList.any((e) => e == text.value)) {
        _errorField[index] = false;
      } else {
        _errorField[index] = true;
      }

      index++;
    });

    final wrongIndex = _errorField.indexWhere((e) => e == true);

    if (wrongIndex == -1) {
      nextPage();
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

  void nextPage() {
    final mnemonic = getMnemonic();
    final wallet = context.read(walletProvider);
    if (!wallet.validateMnemonic(mnemonic)) {
      wallet.setImportWalletResult(false);
      return;
    }
    wallet.importMnemonic(mnemonic);
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h, left: 54.w, right: 54.w),
            child: Text(
              'Enter your 12 word recovery phrase'.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 40.h),
          Container(
            height: 54.h,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              controller: _listScrollController,
              scrollDirection: Axis.horizontal,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: List<Widget>.generate(
                12,
                (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0
                          ? _textFieldLeftPadding
                          : _textFieldPadding,
                      right: index == 11
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
                          color: Color(0xFF1E6389),
                        ),
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _textEditingControllerList[index],
                          focusNode: _focusNodeList[index],
                          textCapitalization: TextCapitalization.none,
                          textInputAction: index == 11
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
                            contentPadding: EdgeInsets.only(
                                left: 10, bottom: 10, top: 10, right: 10),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 16.w, right: 16.w),
                              child: Text(
                                '${index + 1}',
                                style: GoogleFonts.roboto(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF00C5FF),
                                ),
                              ),
                            ),
                            prefixIconConstraints:
                                BoxConstraints(minWidth: 0, minHeight: 0),
                            hintText: '',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          onChanged: (value) {
                            words[index].value = value;
                          },
                          onTap: () {
                            _jumpTo(index, unfocus: false);
                          },
                          onSubmitted: (value) {
                            _jumpTo(index + 1);
                            if (index >= 11) {
                              validateFinal();
                            }
                          },
                          onEditingComplete: () {
                            _jumpTo(index + 1);
                            if (index >= 11) {
                              validateFinal();
                            }
                          },
                        ),
                        suggestionsCallback: (pattern) async {
                          return getSuggestions(pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          _textEditingControllerList[index].text = suggestion;
                          setState(() {
                            _focusNodeList[index].unfocus();
                          });
                          _jumpTo(index + 1);
                          if (index >= 11) {
                            validateFinal();
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
      ),
    );
  }
}
