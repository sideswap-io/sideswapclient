import 'package:flutter/material.dart';

class RegexTextHighlight extends StatelessWidget {
  final String text;
  final RegExp highlightRegex;
  final TextStyle highlightStyle;
  final TextStyle nonHighlightStyle;
  final int? maxLines;
  final bool ignoreCase;

  const RegexTextHighlight({
    super.key,
    required this.text,
    required this.highlightRegex,
    required this.highlightStyle,
    required this.nonHighlightStyle,
    this.maxLines,
    this.ignoreCase = true,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return Text('', style: nonHighlightStyle);
    }

    final spans = <TextSpan>[];
    var start = 0;
    while (true) {
      final highlight = ignoreCase
          ? highlightRegex.stringMatch(text.toLowerCase().substring(start))
          : highlightRegex.stringMatch(text.substring(start));
      if (highlight == null) {
        // no highlight
        spans.add(_normalSpan(text.substring(start)));
        break;
      }

      final indexOfHighlight = ignoreCase
          ? text.toLowerCase().indexOf(highlight, start)
          : text.indexOf(highlight, start);

      if (indexOfHighlight == start) {
        // starts with highlight
        spans.add(_highlightSpan(text.substring(
            indexOfHighlight, indexOfHighlight + highlight.length)));
        start += highlight.length;
      } else {
        // normal + highlight
        spans.add(_normalSpan(text.substring(start, indexOfHighlight)));
        spans.add(_highlightSpan(text.substring(
            indexOfHighlight, indexOfHighlight + highlight.length)));
        start = indexOfHighlight + highlight.length;
      }
    }

    return RichText(
      maxLines: maxLines,
      text: TextSpan(
        style: nonHighlightStyle,
        children: spans,
      ),
    );
  }

  TextSpan _highlightSpan(String content) {
    return TextSpan(text: content, style: highlightStyle);
  }

  TextSpan _normalSpan(String content) {
    return TextSpan(text: content);
  }
}
