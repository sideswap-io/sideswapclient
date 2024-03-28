import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:sideswap_logger/custom_logger.dart';

CustomLogger logger = CustomLogger('SideSwap', output: SideswapOutput());

class SideswapOutput extends LogOutput {
  SideswapOutput() {
    consoleOutput = ConsoleOutput();
  }

  File? file;
  late ConsoleOutput consoleOutput;

  @override
  void output(OutputEvent event) async {
    if (kDebugMode && !(Platform.isAndroid || Platform.isIOS)) {
      if (file == null) {
        final supportDirectory = await getApplicationSupportDirectory();
        final filePath = '${supportDirectory.path}/sideswap_ui.log';

        file = File(filePath);
      }

      final writer = file!.openWrite(mode: FileMode.writeOnlyAppend);
      for (final line in event.lines) {
        writer.write("${line.toString()}\n");
      }
      await writer.close();
    }

    // default output to console as well
    consoleOutput.output(event);
  }
}
