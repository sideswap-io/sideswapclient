import 'package:sideswap/common_platform.dart';
import 'package:sideswap/common_platform_mobile.dart';
import 'package:sideswap/start_app.dart';

Future<void> main(List<String> args) async {
  commonPlatform = CommonPlatformMobile();

  await startApp(args);
}
