import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/markets/widgets/d_edit_order_error_dialog.dart';
import 'package:sideswap/providers/markets_provider.dart';

class EditOrderErrorListener extends HookConsumerWidget {
  const EditOrderErrorListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editOrderError = ref.watch(marketEditOrderErrorNotifierProvider);

    useEffect(() {
      editOrderError.match(
        () => () {},
        (error) => () {
          Future.microtask(() async {
            if (!context.mounted) {
              return;
            }
            await showDialog<void>(
              context: context,
              builder: (context) {
                return EditOrderErrorDialog();
              },
              routeSettings: RouteSettings(name: editOrderErrorRouteName),
              useRootNavigator: false,
            );

            // clear order submit state
            ref.invalidate(marketEditOrderErrorNotifierProvider);
          });
        },
      )();

      return;
    }, [editOrderError]);

    return Container();
  }
}
