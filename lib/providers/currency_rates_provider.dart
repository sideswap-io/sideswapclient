import 'dart:async';

import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'currency_rates_provider.g.dart';
part 'currency_rates_provider.freezed.dart';

@Riverpod(keepAlive: true)
class RequestConversionRates extends _$RequestConversionRates {
  @override
  void build() {
    final libClientState = ref.watch(libClientStateProvider);

    if (libClientState == const LibClientStateEmpty()) {
      return;
    }

    final timer = Timer.periodic(const Duration(seconds: 10), (_) {
      ref.invalidateSelf();
    });

    ref.onDispose(() {
      timer.cancel();
    });

    requestConversionRates();
  }

  void requestConversionRates() {
    final msg = To();
    msg.conversionRates = Empty();
    try {
      ref.read(walletProvider).sendMsg(msg);
    } catch (e) {
      logger.e(e);
    }
  }
}

@freezed
sealed class ConversionRate with _$ConversionRate {
  const factory ConversionRate({required String name, required Decimal rate}) =
      _ConversionRate;
}

@freezed
sealed class ConversionRates with _$ConversionRates {
  const factory ConversionRates({
    required List<ConversionRate> usdConversionRates,
  }) = _UsdConversionRates;
}

@Riverpod(keepAlive: true)
class ConversionRatesNotifier extends _$ConversionRatesNotifier {
  @override
  ConversionRates build() {
    return const ConversionRates(usdConversionRates: []);
  }

  void setConversionRates(From_ConversionRates fromConversionRates) {
    final usdConversionRates = <ConversionRate>[...state.usdConversionRates];
    bool update = false;

    for (final key in fromConversionRates.usdConversionRates.keys) {
      final rate =
          Decimal.tryParse(
            '${fromConversionRates.usdConversionRates[key] ?? .0}',
          ) ??
          Decimal.zero;
      if (rate == Decimal.zero) {
        logger.w('$key conversion rate is zero!');
        continue;
      }

      final index = usdConversionRates.indexWhere(
        (element) => element.name == key,
      );

      final newConversionRate = ConversionRate(name: key, rate: rate);
      (switch (index) {
        -1 => () {
          usdConversionRates.add(newConversionRate);
          update = true;
        }(),
        _ => () {
          final oldConversionRate = usdConversionRates[index];
          if (oldConversionRate.name == key && oldConversionRate.rate != rate) {
            usdConversionRates[index] = newConversionRate;
            update = true;
          }
        }(),
      });
    }

    if (update) {
      usdConversionRates.sort((a, b) => a.name.compareTo(b.name));
      state = ConversionRates(usdConversionRates: usdConversionRates);
    }
  }
}

/// Default conversion rate helpers ============
@riverpod
class DefaultConversionRateNotifier extends _$DefaultConversionRateNotifier {
  @override
  ConversionRate? build() {
    final defaultCurrency = ref.watch(configurationProvider).defaultCurrency;
    final conversionRates =
        ref.watch(conversionRatesNotifierProvider).usdConversionRates;

    // try to find saved assetId
    final savedCurrency = switch (defaultCurrency) {
      final defaultCurrency? => () {
        return conversionRates.firstWhereOrNull(
          (element) => element.name == defaultCurrency,
        );
      }(),
      _ => null,
    };

    // if nothing is saved or saved is not found on the list then try usdt as default currency
    return switch (savedCurrency) {
      final savedCurrency? => savedCurrency,
      _ => () {
        const defaultCurrencyName = 'USD';
        return conversionRates.firstWhereOrNull(
          (element) => element.name == defaultCurrencyName,
        );
      }(),
    };
  }

  void setDefaultConversionRate(ConversionRate conversionRate) {
    // save currency in configuration
    if (conversionRate.name.isNotEmpty) {
      ref
          .read(configurationProvider.notifier)
          .setDefaultCurrency(conversionRate.name);
      state = conversionRate;
    }
  }
}

@riverpod
Decimal defaultConversionRateMultiplier(Ref ref) {
  final conversionRate = ref.watch(defaultConversionRateNotifierProvider);
  return switch (conversionRate) {
    final conversionRate? => conversionRate.rate,
    _ => Decimal.one,
  };
}
