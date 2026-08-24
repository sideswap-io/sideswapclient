import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';

part 'licenses_provider.g.dart';

@riverpod
AssetBundle assetBundle(Ref ref) => rootBundle;

@riverpod
FutureOr<bool> licensesLoaderFuture(Ref ref) {
  final bundle = ref.read(assetBundleProvider);
  logger.d('Loading licenses...');
  LicenseRegistry.addLicense(() async* {
    var license = await bundle.loadString('assets/licenses/lwk-license.txt');
    yield LicenseEntryWithLineBreaks([kPackageLwk], license);
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
Future<List<LicensesData>> licensesEntries(Ref ref) {
  return LicenseRegistry.licenses
      .map(
        (l) => LicensesData(licenseEntry: l, paragraphs: l.paragraphs.toList()),
      )
      .toList();
}
