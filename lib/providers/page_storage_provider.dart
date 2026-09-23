import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
// For `.select` on a provider, which `riverpod_annotation` does not export.
// Prior art: lib/providers/proxy_provider.dart.
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';

part 'page_storage_provider.g.dart';

@Riverpod(keepAlive: true)
class PageStorageKeyData extends _$PageStorageKeyData {
  @override
  String build() {
    return getRandString(5);
  }

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}

/// The scroll store of the desktop shell, scoped to the visit.
///
/// A visit is one continuous stay on one desktop navigation item; see the
/// `Visit` term in `CONTEXT.md`. The bucket is therefore new for every value of
/// `navigationItemEnum`, and the same one for everything that happens inside a
/// visit: a dialog pushed over the page, a spinner inside it, and the rebuild
/// of the shell that the return from Settings performs.
///
/// Two properties carry that rule and neither is optional. `keepAlive` makes
/// the bucket outlive the shell widget, which the return from Settings
/// destroys. The `select` makes the bucket die with the visit alone, and not
/// with any other change of `WalletMainArguments` such as `currentIndex`.
@Riverpod(keepAlive: true)
PageStorageBucket pageStorageBucket(Ref ref) {
  ref.watch(uiStateArgsProvider.select((args) => args.navigationItemEnum));
  return PageStorageBucket();
}
