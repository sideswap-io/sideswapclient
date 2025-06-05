import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/proxy_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class ProxySettingsListener extends ConsumerWidget {
  const ProxySettingsListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(proxySettingsRepositoryNotifierProvider, (_, next) {
      final toProxySettings = next.getProxySettings();
      ref.read(walletProvider).sendProxySettings(toProxySettings);
    });

    return Container();
  }
}
