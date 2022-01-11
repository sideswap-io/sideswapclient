import 'dart:io';

bool isMobile() {
  return Platform.isAndroid || Platform.isIOS;
}

bool universalLinksAvailable() {
  return isMobile();
}

bool notificationServiceAvailable() {
  return isMobile();
}
