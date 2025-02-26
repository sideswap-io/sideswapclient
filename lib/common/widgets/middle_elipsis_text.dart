import 'package:flutter/material.dart';

class MiddleEllipsisText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final bool? softWrap;

  const MiddleEllipsisText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Measure the width of the text
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: Directionality.of(context),
          textAlign: textAlign,
        )..layout(minWidth: 0, maxWidth: double.infinity);

        if (textPainter.width <= (constraints.maxWidth * maxLines!)) {
          // Text fits without truncation
          return Text(
            text,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            softWrap: softWrap,
          );
        }

        // Calculate the truncation point
        final ellipsis = '...';
        final ellipsisPainter = TextPainter(
          text: TextSpan(text: ellipsis, style: style),
          maxLines: maxLines,
          textDirection: Directionality.of(context),
        )..layout(minWidth: 0, maxWidth: double.infinity);

        final ellipsisWidth = ellipsisPainter.width;
        final availableWidth = constraints.maxWidth - ellipsisWidth;
        final charWidth = textPainter.width / text.length;

        // Determine the number of characters that can fit on each side of the ellipsis
        final charsToShow = (availableWidth / (2 * charWidth)).floor();
        final startText = text.substring(0, charsToShow);
        final endText = text.substring(text.length - charsToShow);

        // Create the final truncated text
        final truncatedText = '$startText$ellipsis$endText';

        return Text(
          truncatedText,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          softWrap: softWrap,
        );
      },
    );
  }
}
