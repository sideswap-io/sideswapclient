import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';

sealed class SideswapProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    logger.w('''
      {
        "provider": "${context.provider.name ?? context.provider.runtimeType}",
        "newValue": "$newValue"
      }''');
  }
}
