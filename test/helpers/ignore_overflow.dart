import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Drops overflow errors for the rest of the test; every other error still
/// fails it.
///
/// Widgets that lay out to fixed sizes tuned to the app's own font overflow
/// under the test binding, which substitutes a block font whose glyphs are
/// wider and taller. That is a rendering artifact of the harness rather than
/// anything these tests assert.
///
/// Call this from inside the test body: the widget tester replaces
/// [FlutterError.onError] when the test starts, so a `setUp` would be
/// overwritten before the first pump.
void ignoreOverflow() {
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('overflowed')) {
      return;
    }
    previous?.call(details);
  };
  addTearDown(() => FlutterError.onError = previous);
}

/// Collects overflow errors into the returned list for the rest of the test,
/// so the absence of a *vertical* one can be asserted explicitly.
///
/// [ignoreOverflow] would swallow the very overflow a layout test asserts the
/// absence of, which is what makes a naive "no overflow" assertion vacuous.
/// Only overflow is diverted here; every other framework error still reaches
/// the handler the tester installed and still fails the test. Filter the
/// result with [verticalOverflows]: the horizontal ones are the block font's
/// wider glyphs and are the harness's, not the layout's.
///
/// Call this from inside the test body, for the same reason
/// [ignoreOverflow] must be called there.
List<String> captureOverflowErrors() {
  final errors = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final text = details.exceptionAsString();
    if (text.contains('overflowed')) {
      errors.add(text);
      return;
    }
    previous?.call(details);
  };
  addTearDown(() => FlutterError.onError = previous);
  return errors;
}

/// The vertical overflows among [errors] collected by
/// [captureOverflowErrors], which are already known to be overflows.
Iterable<String> verticalOverflows(List<String> errors) =>
    errors.where((e) => e.contains('on the bottom'));
