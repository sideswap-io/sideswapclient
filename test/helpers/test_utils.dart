import 'package:logger/logger.dart';

/// A no-op log output that suppresses all log messages.
/// Use in tests to silence logger output.
class NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

/// A log output that suppresses log messages but keeps the lines, so tests can
/// assert on what was logged.
///
/// Hold one instance per test file and clear [lines] in `setUp` (never in
/// `tearDown`) so a failed expectation cannot leave it dirty for the next test.
class CapturingLogOutput extends LogOutput {
  final List<String> lines = [];

  @override
  void output(OutputEvent event) {
    lines.addAll(event.lines);
  }
}
