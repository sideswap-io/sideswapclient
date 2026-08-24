import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sideswap/providers/csv_provider.dart';

class RealCsvFileIo implements CsvFileIo {
  const RealCsvFileIo();

  @override
  Future<void> saveXFileTo(XFile file, String path) => file.saveTo(path);

  @override
  Future<void> writeAndShare(String path, String content) async {
    await File(path).writeAsString(content);
    final filesToShare = [XFile(path, mimeType: 'text/csv')];
    await SharePlus.instance.share(ShareParams(files: filesToShare));
  }
}

class DesktopCsvPathResolver implements CsvPathResolver {
  const DesktopCsvPathResolver();

  @override
  Future<String> resolve() async {
    final defaultPath = await getApplicationDocumentsDirectory();
    const defaultName = 'transactions.csv';
    final saveLocation = await getSaveLocation(
      initialDirectory: defaultPath.path,
      suggestedName: defaultName,
    );

    if (saveLocation == null) {
      return Future.error('Invalid path or canceled by user');
    }

    return saveLocation.path;
  }
}

class MobileCsvPathResolver implements CsvPathResolver {
  const MobileCsvPathResolver();

  @override
  Future<String> resolve() async {
    final dir = (await getTemporaryDirectory()).path;
    return '$dir/data.csv';
  }
}
