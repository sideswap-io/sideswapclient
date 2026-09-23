import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/desktop/onboarding/d_pin_setup.dart';
import 'package:sideswap/models/pin_models.dart';

/// ADR-0013 decision 8 reserves a constant height under the confirm field so
/// the field never shrinks when a message appears. The number is a measurement,
/// and this test is the measurement.
///
/// `ar`, `ur` and `zh` are laid out in the test fallback face, because Roboto
/// carries no glyphs for them. That is the same allowance the ADR made.
void main() {
  setUpAll(() async {
    final loader = FontLoader('Roboto');
    for (final face in const [
      'Roboto-Regular.ttf',
      'Roboto-Medium.ttf',
      'Roboto-Bold.ttf',
    ]) {
      final bytes = File('assets/fonts/Roboto/$face').readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  });

  testWidgets('the reserve fits the tallest message in every locale', (
    tester,
  ) async {
    var tallest = 0.0;
    var tallestWhere = '';

    final files = Directory('assets/translations')
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.json'))
        .toList();

    expect(files, isNotEmpty);

    for (final file in files) {
      final translations =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

      for (final key in pinSetupMessageKeys) {
        final message = (translations[key] as String?) ?? key;

        final painter = TextPainter(
          text: TextSpan(text: message, style: dPinSetupMessageTextStyle),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: dPinSetupFieldWidth);

        if (painter.height > tallest) {
          tallest = painter.height;
          tallestWhere = '${file.path} / $key';
        }
      }
    }

    expect(
      dPinSetupMessageReserveHeight,
      greaterThanOrEqualTo(tallest + dPinSetupMessageGap),
      reason:
          'tallest message is $tallest px, in $tallestWhere; '
          'the reserve must hold it plus a $dPinSetupMessageGap px gap',
    );
  });
}
