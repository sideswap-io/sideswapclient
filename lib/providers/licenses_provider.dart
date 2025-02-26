import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';

part 'licenses_provider.g.dart';

@riverpod
FutureOr<bool> licensesLoaderFuture(Ref ref) {
  logger.d('Loading licenses...');
  LicenseRegistry.addLicense(() async* {
    var license = await rootBundle.loadString(
      'assets/licenses/gdk-license.txt',
    );
    yield LicenseEntryWithLineBreaks([kPackageGdk], license);
  });
  return true;
}

class LicensesData {
  LicenseEntry licenseEntry;
  List<LicenseParagraph> paragraphs;

  LicensesData({required this.licenseEntry, required this.paragraphs});

  LicensesData copyWith({
    LicenseEntry? licenseEntry,
    List<LicenseParagraph>? paragraphs,
  }) {
    return LicensesData(
      licenseEntry: licenseEntry ?? this.licenseEntry,
      paragraphs: paragraphs ?? this.paragraphs,
    );
  }

  @override
  String toString() =>
      'LicensesData(licenseEntry: $licenseEntry, paragraphs: $paragraphs)';

  @override
  bool operator ==(covariant LicensesData other) {
    if (identical(this, other)) return true;

    return other.licenseEntry == licenseEntry &&
        listEquals(other.paragraphs, paragraphs);
  }

  @override
  int get hashCode => licenseEntry.hashCode ^ paragraphs.hashCode;
}

@riverpod
FutureOr<List<LicensesData>> licensesEntries(Ref ref) async {
  final licenses = <LicensesData>[];
  await for (final LicenseEntry license in LicenseRegistry.licenses) {
    licenses.add(
      LicensesData(
        licenseEntry: license,
        paragraphs: license.paragraphs.toList(),
      ),
    );
  }

  return licenses;
}
