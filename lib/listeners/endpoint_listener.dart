import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/endpoint_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';

class EndpointListener extends HookConsumerWidget {
  const EndpointListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!FlavorConfig.enableLocalEndpoint) {
      return const SizedBox();
    }

    final endpointServer = ref.watch(endpointServerProvider);
    final enableEndpoint = ref.watch(configurationProvider).enableEndpoint;

    useEffect(() {
      if (enableEndpoint) {
        endpointServer.serve();
      } else {
        endpointServer.stop();
      }

      return;
    }, [endpointServer, enableEndpoint]);

    return const SizedBox();
  }
}
