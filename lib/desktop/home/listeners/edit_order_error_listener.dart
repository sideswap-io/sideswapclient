import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/markets/widgets/d_edit_order_error_dialog.dart';
import 'package:sideswap/providers/markets_provider.dart';

class EditOrderErrorListener extends HookConsumerWidget {
  const EditOrderErrorListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editOrderError = ref.watch(marketEditOrderErrorProvider);

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
            ref.invalidate(marketEditOrderErrorProvider);
          });
        },
      )();

      return;
    }, [editOrderError]);

    // A listener occupies no space. A bare `Container()` expands to the
    // biggest size its constraints allow, so under the bounded parent
    // `DTxAndOrdersPanel` now has it would size that panel's `Stack` to the
    // whole bound instead of to the panel itself.
    return const SizedBox.shrink();
  }
}
