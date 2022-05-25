import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';

final initProvider = FutureProvider<bool>((ref) async {
  LicenseRegistry.addLicense(() async* {
    var license =
        await rootBundle.loadString('assets/licenses/gdk-license.txt');
    yield LicenseEntryWithLineBreaks([kPackageGdk], license);
  });

  return true;
});
