import 'package:logger/logger.dart' as log;

class AnyModeFilter extends log.LogFilter {
  @override
  bool shouldLog(log.LogEvent event) {
    return true;
  }
}

class ConsoleLogOutput extends log.ConsoleOutput {
  @override
  void output(log.OutputEvent event) {
    super.output(event);
  }
}

CustomLogger logger = CustomLogger();

class CustomLogger {
  factory CustomLogger() {
    return _customLogger;
  }

  CustomLogger._internal();

  static final CustomLogger _customLogger = CustomLogger._internal();

  static const String appName = 'SideSwap';

  log.Logger internalLogger = log.Logger(
    printer: log.SimplePrinter(printTime: true),
    output: ConsoleLogOutput(),
  );

  void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    internalLogger.v('$appName: $message', error, stackTrace);
  }

  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    internalLogger.d('$appName: $message', error, stackTrace);
  }

  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    internalLogger.i('$appName: $message', error, stackTrace);
  }

  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    internalLogger.w('$appName: $message', error, stackTrace);
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    internalLogger.e('$appName: $message', error, stackTrace);
  }

  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    internalLogger.wtf('$appName: $message', error, stackTrace);
  }
}
