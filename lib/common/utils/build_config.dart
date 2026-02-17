import 'dart:io';

import 'package:sideswap/screens/flavor_config.dart';

bool isMobile() {
  return Platform.isAndroid || Platform.isIOS;
}

bool universalLinksAvailable() {
  return isMobile() || FlavorConfig.isDesktop;
}

bool notificationServiceAvailable() {
  return isMobile();
}
