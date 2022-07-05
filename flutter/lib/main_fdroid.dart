import 'package:sideswap/common_platform.dart';
import 'package:sideswap/common_platform_fdroid.dart';
import 'package:sideswap/start_app.dart';

Future<void> main(List<String> args) async {
  commonPlatform = CommonPlatformFdroid();

  await startApp(args);
}
