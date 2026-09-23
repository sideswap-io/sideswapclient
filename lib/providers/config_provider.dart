import 'dart:convert';
import 'dart:typed_data';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/desktop_window_geometry.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/logging_shared_preferences.dart';
import 'package:sideswap/providers/network_settings_providers.dart';

import 'package:sideswap/providers/proxy_provider.dart';
import 'package:sideswap/providers/stokr_providers.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';

part 'config_provider.freezed.dart';
part 'config_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError();
}

@freezed
sealed class SideswapSettings with _$SideswapSettings {
  factory SideswapSettings.empty({
    required Uint8List mnemonicEncrypted,
    @Default('') String jadeId,
    @Default(false) bool licenseAccepted,
    @Default(true) bool enableEndpoint,
    @Default(false) bool useBiometricProtection,
    @Default(0) int env,
    @Default('') String phoneKey,
    @Default('') String phoneNumber,
    @Default(false) bool usePinProtection,
    PinDataState? pinDataState,
    @Default(SettingsNetworkType.sideswap)
    SettingsNetworkType settingsNetworkType,
    @Default('') String networkHost,
    @Default(0) int networkPort,
    @Default(false) bool networkUseTLS,
    @Default(0) int knownNewReleaseBuild,
    @Default(false) bool showAmpOnboarding,
    NetworkSettingsModel? networkSettingsModel,
    @Default(false) bool hideTxChainingPromptValue,
    ProxySettings? proxySettings,
    @Default(false) bool useProxy,
    String? defaultCurrency,
    StokrSettingsModel? stokrSettingsModel,
    DesktopWindowGeometry? desktopWindowGeometry,
    @Default({}) Map<String, bool> autosignDomains,
  }) = _SideswapSettings;

  factory SideswapSettings({
    required String jadeId,
    required bool licenseAccepted,
    required bool enableEndpoint,
    required bool useBiometricProtection,
    required int env,
    required String phoneKey,
    required String phoneNumber,
    required bool usePinProtection,
    PinDataState? pinDataState,
    required SettingsNetworkType settingsNetworkType,
    required String networkHost,
    required int networkPort,
    required bool networkUseTLS,
    String? settings,
    required int knownNewReleaseBuild,
    required bool showAmpOnboarding,
    NetworkSettingsModel? networkSettingsModel,
    required bool hideTxChainingPromptValue,
    ProxySettings? proxySettings,
    required bool useProxy,
    String? defaultCurrency,
    StokrSettingsModel? stokrSettingsModel,
    DesktopWindowGeometry? desktopWindowGeometry,
  }) {
    return _SideswapSettings(mnemonicEncrypted: Uint8List.fromList([]));
  }

  // do not change EVER this fields. It will broke user configuration
  static const mnemonicEncryptedField = 'mnemonic_encrypted';
  static const jadeIdField = 'jade_id';
  static const licenseAcceptedField = 'license_accepted';
  static const enableEndpointField = 'enable_endpoint';
  static const useBiometricProtectionField = 'biometric_protection';
  static const envField = 'env';
  static const phoneKeyField = 'phoneKey';
  static const phoneNumberField = 'phoneNumber';
  static const usePinProtectionField = 'pinProtectionField';
  static const pinSaltField = 'pinSalt';
  static const pinEncryptedDataField = 'pinEncryptedData';
  static const pinIdentifierField = 'pinIdentifierField';
  static const pinHmacField = 'pinHmac';
  static const settingsNetworkTypeField = 'settingsNetworkTypeFieldNew';
  static const settingsHostField = 'settingsHostFieldNew';
  static const settingsPortField = 'settingsPortFieldNew';
  static const settingsUseTLSField = 'settingsUseTLSFieldNew';
  static const knownNewReleaseField = 'known_new_release';
  static const showAmpOnboardingField = 'show_amp_onboarding';
  static const networkSettingsModelField = 'network_settings_model';
  static const hideTxChainingPromptField = 'hide_tx_chaining_prompt';
  static const proxyHostField = 'proxyHost';
  static const proxyPortField = 'proxyPort';
  static const useProxyField = 'useProxy';
  static const defaultCurrencyField = 'defaultCurrency';
  static const stokrSettingsModelField = 'stokrSettings';
  static const autosignDomainsField = 'autosign_domains';
  static const desktopWindowGeometryField = 'desktop_window_geometry';
}

@riverpod
class Configuration extends _$Configuration {
  @override
  SideswapSettings build() {
    final subscription = listenSelf((_, _) async {
      // No mounted guard: listenSelf fires synchronously on `state =` and the
      // subscription is removed in ref.onDispose below, so the ref is always
      // mounted here.
      final prefs = ref.read(sharedPreferencesProvider);
      await _saveSettings(prefs);
    });
    ref.onDispose(() => subscription());

    final prefs = ref.watch(sharedPreferencesProvider);

    final settings = _readSettings(prefs);
    return settings;
  }

  SideswapSettings _readSettings(SharedPreferences prefs) {
    return SideswapSettings.empty(
      mnemonicEncrypted: _mnemonicEncrypted(prefs),
      jadeId: _jadeId(prefs),
      licenseAccepted: _licenseAccepted(prefs),
      enableEndpoint: _enableEndpoint(prefs),
      useBiometricProtection: _useBiometricProtection(prefs),
      env: _env(prefs),
      phoneKey: _phoneKey(prefs),
      phoneNumber: _phoneNumber(prefs),
      usePinProtection: _usePinProtection(prefs),
      pinDataState: _pinData(prefs),
      settingsNetworkType: _settingsNetworkType(prefs),
      networkHost: _networkHost(prefs),
      networkPort: _networkPort(prefs),
      networkUseTLS: _networkUseTLS(prefs),
      knownNewReleaseBuild: _knownNewReleaseBuild(prefs),
      showAmpOnboarding: _showAmpOnboarding(prefs),
      networkSettingsModel: _networkSettingsModel(prefs),
      hideTxChainingPromptValue: _hideTxChainingPromptValue(prefs),
      proxySettings: _proxySettings(prefs),
      useProxy: _useProxy(prefs),
      defaultCurrency: _defaultCurrency(prefs),
      stokrSettingsModel: _stokrSettings(prefs),
      autosignDomains: _autosignDomains(prefs),
      desktopWindowGeometry: _desktopWindowGeometry(prefs),
    );
  }

  Future<void> _pendingSave = Future<void>.value();

  Future<void> _saveSettings(SharedPreferences prefs) {
    // Snapshot before the first await. `state` throws once the notifier is
    // disposed, and a save that has started must write one consistent set of
    // values rather than stop half-way through the keys below.
    final settings = state;
    // Chain each save behind the previous one, so overlapping saves persist in
    // state-change order and the newest snapshot always writes last.
    _pendingSave = _pendingSave
        .then(
          // The decorator ends the round on a refused write, so no later key
          // is written over a state the disk never reached. See ADR-0017.
          (_) => _writeSettings(LoggingSharedPreferences(prefs), settings),
        )
        .catchError((Object error, StackTrace stackTrace) {
          // Log and resolve. A rejected `_pendingSave` would kill every later
          // round for the lifetime of the notifier, and the next round is the
          // repair: it rewrites the whole snapshot in the same fixed order.
          logger.e('The settings round failed', error, stackTrace);
        });
    return _pendingSave;
  }

  Future<void> _writeSettings(
    SharedPreferences prefs,
    SideswapSettings settings,
  ) async {
    await _setMnemonicEncrypted(prefs, settings.mnemonicEncrypted);
    await _setJadeId(prefs, settings.jadeId);
    await _setLicenseAccepted(prefs, settings.licenseAccepted);
    await _setEnableEndpoint(prefs, settings.enableEndpoint);
    await _setUseBiometricProtection(prefs, settings.useBiometricProtection);
    await _setEnv(prefs, settings.env);
    await _setPhoneKey(prefs, settings.phoneKey);
    await _setPhoneNumber(prefs, settings.phoneNumber);
    // Load-bearing order: the blob before the flag. Interrupted between the
    // two, that leaves a fresh blob with protection still off, which is
    // harmless. The reverse leaves protection on beside a stale blob, which is
    // an unlock screen that waits for a reply nobody will send.
    await _setPinData(prefs, settings.pinDataState);
    await _setUsePinProtection(prefs, settings.usePinProtection);
    await _setSettingsNetworkType(prefs, settings.settingsNetworkType);
    await _setNetworkHost(prefs, settings.networkHost);
    await _setNetworkPort(prefs, settings.networkPort);
    await _setNetworkUseTLS(prefs, settings.networkUseTLS);
    await _setKnownNewReleaseBuild(prefs, settings.knownNewReleaseBuild);
    await _setShowAmpOnboarding(prefs, settings.showAmpOnboarding);
    await _setNetworkSettingsModel(prefs, settings.networkSettingsModel);
    await _setHideTxChainingPromptValue(prefs, settings.hideTxChainingPromptValue);
    await _setProxySettings(prefs, settings.proxySettings);
    await _setUseProxy(prefs, settings.useProxy);
    await _setDefaultCurrency(prefs, settings.defaultCurrency);
    await _setStokrSettings(prefs, settings.stokrSettingsModel);
    await _setAutosignDomains(prefs, settings.autosignDomains);
    await _setDesktopWindowGeometry(prefs, settings.desktopWindowGeometry);
  }

  bool isRegistered() {
    final prefs = ref.read(sharedPreferencesProvider);
    final mnemonic = _mnemonicEncrypted(prefs);
    return mnemonic.isNotEmpty;
  }

  void setSettings(SideswapSettings sideswapSettings) {
    // The PIN record is not this setter's to move. It carries whatever the
    // state already holds, so no caller can raise the flag or swap the blob
    // through a wholesale replacement.
    state = sideswapSettings.copyWith(
      usePinProtection: state.usePinProtection,
      pinDataState: state.pinDataState,
    );
  }

  void setDefaultCurrency(String defaultCurrency) {
    state = state.copyWith(defaultCurrency: defaultCurrency);
  }

  void setMnemonicEncrypted(Uint8List mnemonicEncrypted) {
    state = state.copyWith(mnemonicEncrypted: mnemonicEncrypted);
  }

  void setJadeId(String jadeId) {
    state = state.copyWith(jadeId: jadeId);
  }

  void setLicenseAccepted(bool licenseAccepted) {
    state = state.copyWith(licenseAccepted: licenseAccepted);
  }

  void setEnableEndpoint(bool enableEndpoint) {
    state = state.copyWith(enableEndpoint: enableEndpoint);
  }

  void setUseBiometricProtection(bool useBiometricProtection) {
    state = state.copyWith(useBiometricProtection: useBiometricProtection);
  }

  void setEnv(int env) {
    state = state.copyWith(env: env);
  }

  void setPhoneKey(String phoneKey) {
    state = state.copyWith(phoneKey: phoneKey);
  }

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  /// Turns PIN protection on. The blob, the flag and biometric-off travel in
  /// one state change, so one persist round carries the whole transition and
  /// the two halves of the PIN record cannot diverge.
  void activatePinProtection(PinDataStateData pinData) {
    // The store keeps a blob that is not whole as no blob at all, so raising
    // the flag over one is the wallet-losing state. `PinHelper.onPinData`
    // rejects these too and tells the user; this guard is what the notifier
    // owes on its own, being the one entrance to the transition.
    if (!pinData.isWhole) {
      return;
    }

    state = state.copyWith(
      pinDataState: pinData,
      usePinProtection: true,
      useBiometricProtection: false,
    );
  }

  /// Turns PIN protection off, in two persist rounds.
  ///
  /// One fixed key order cannot be safe in both directions: enabling wants
  /// blob-then-flag, disabling wants flag-then-blob. So disabling takes two
  /// state changes, and they belong to one operation rather than to a public
  /// primitive a caller could invoke on its own — dropping the blob while the
  /// flag still stands is the wallet-losing state.
  ///
  /// Round one stores the fallback mnemonic in the same state change that
  /// drops the flag, and `_writeSettings` writes the mnemonic before the flag,
  /// so no window exists in which neither credential opens the wallet.
  /// Round two drops the blob, which nothing reads once the flag is off.
  /// Interrupted between the rounds, the wallet is left protection-off beside
  /// a blob nobody reads, which is harmless.
  void deactivatePinProtection({required Uint8List mnemonicEncrypted}) {
    state = state.copyWith(
      mnemonicEncrypted: mnemonicEncrypted,
      usePinProtection: false,
    );
    state = state.copyWith(pinDataState: null);
  }

  /// Turns biometric protection on. Registering a biometric credential drops
  /// the PIN flag in the same state change, so the two never both stand.
  void activateBiometricProtection() {
    state = state.copyWith(
      useBiometricProtection: true,
      usePinProtection: false,
    );
  }

  void setSettingsNetworkType(SettingsNetworkType settingsNetworkType) {
    state = state.copyWith(settingsNetworkType: settingsNetworkType);
  }

  void setNetworkHost(String networkHost) {
    state = state.copyWith(networkHost: networkHost);
  }

  void setNetworkPort(int networkPort) {
    state = state.copyWith(networkPort: networkPort);
  }

  void setNetworkUseTLS(bool networkUseTLS) {
    state = state.copyWith(networkUseTLS: networkUseTLS);
  }

  void setKnownNewReleaseBuild(int knownNewReleaseBuild) {
    state = state.copyWith(knownNewReleaseBuild: knownNewReleaseBuild);
  }

  void setShowAmpOnboarding(bool showAmpOnboarding) {
    state = state.copyWith(showAmpOnboarding: showAmpOnboarding);
  }

  void setNetworkSettingsModel(NetworkSettingsModel? networkSettingsModel) {
    state = state.copyWith(networkSettingsModel: networkSettingsModel);
  }

  void setDesktopWindowGeometry(DesktopWindowGeometry? geometry) {
    state = state.copyWith(desktopWindowGeometry: geometry);
  }

  void setStokrSettingsModel(StokrSettingsModel? stokrSettingsModel) {
    state = state.copyWith(stokrSettingsModel: stokrSettingsModel);
  }

  void setHideTxChainingPromptValue(bool hideTxChainingPromptValue) {
    state = state.copyWith(
      hideTxChainingPromptValue: hideTxChainingPromptValue,
    );
  }

  void setProxySettings(ProxySettings? proxySettings) {
    state = state.copyWith(proxySettings: proxySettings);
  }

  void setUseProxy(bool useProxy) {
    state = state.copyWith(useProxy: useProxy);
  }

  void setAutosignForDomain(String domain, bool enabled) {
    final next = Map<String, bool>.from(state.autosignDomains);
    if (enabled) {
      next[domain] = true;
    } else {
      next.remove(domain);
    }
    state = state.copyWith(autosignDomains: next);
  }

  Future<void> deleteConfig() async {
    final currentEnv = state.env;
    final currentDesktopWindowGeometry = state.desktopWindowGeometry;
    state = SideswapSettings.empty(
      mnemonicEncrypted: Uint8List.fromList([]),
      env: currentEnv,
      showAmpOnboarding: false,
      desktopWindowGeometry: currentDesktopWindowGeometry,
    );

    final prefs = ref.read(sharedPreferencesProvider);
    await _saveSettings(prefs);
  }

  ///
  /// Shared preferences functions
  String? _defaultCurrency(SharedPreferences prefs) {
    return prefs.getString(SideswapSettings.defaultCurrencyField);
  }

  Uint8List _mnemonicEncrypted(SharedPreferences prefs) {
    final encryptedMnemonic =
        prefs.getString(SideswapSettings.mnemonicEncryptedField) ?? '';
    return base64.decode(encryptedMnemonic);
  }

  Future<void> _setMnemonicEncrypted(
    SharedPreferences prefs,
    Uint8List mnemonicEncrypted,
  ) async {
    return await switch (mnemonicEncrypted.isEmpty) {
      true => () async {
        await prefs.remove(SideswapSettings.mnemonicEncryptedField);
      }(),
      _ => () async {
        await prefs.setString(
          SideswapSettings.mnemonicEncryptedField,
          base64.encode(mnemonicEncrypted),
        );
      }(),
    };
  }

  String _jadeId(SharedPreferences prefs) {
    return prefs.getString(SideswapSettings.jadeIdField) ?? '';
  }

  Future<void> _setJadeId(SharedPreferences prefs, String jadeId) async {
    await prefs.setString(SideswapSettings.jadeIdField, jadeId);
  }

  bool _licenseAccepted(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.licenseAcceptedField) ?? false;
  }

  Future<void> _setLicenseAccepted(
    SharedPreferences prefs,
    bool licenseAccepted,
  ) async {
    await prefs.setBool(SideswapSettings.licenseAcceptedField, licenseAccepted);
  }

  bool _enableEndpoint(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.enableEndpointField) ?? true;
  }

  Future<void> _setEnableEndpoint(
    SharedPreferences prefs,
    bool enableEndpoint,
  ) async {
    await prefs.setBool(SideswapSettings.enableEndpointField, enableEndpoint);
  }

  bool _useBiometricProtection(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.useBiometricProtectionField) ?? false;
  }

  Future<void> _setUseBiometricProtection(
    SharedPreferences prefs,
    bool useBiometricProtection,
  ) async {
    await prefs.setBool(
      SideswapSettings.useBiometricProtectionField,
      useBiometricProtection,
    );
  }

  int _env(SharedPreferences prefs) {
    return prefs.getInt(SideswapSettings.envField) ?? 0;
  }

  Future<void> _setEnv(SharedPreferences prefs, int env) async {
    await prefs.setInt(SideswapSettings.envField, env);
  }

  Future<void> _setPhoneKey(SharedPreferences prefs, String phoneKey) async {
    await prefs.setString(SideswapSettings.phoneKeyField, phoneKey);
  }

  String _phoneKey(SharedPreferences prefs) {
    return prefs.getString(SideswapSettings.phoneKeyField) ?? '';
  }

  Future<void> _setPhoneNumber(
    SharedPreferences prefs,
    String phoneNumber,
  ) async {
    await prefs.setString(SideswapSettings.phoneNumberField, phoneNumber);
  }

  String _phoneNumber(SharedPreferences prefs) {
    return prefs.getString(SideswapSettings.phoneNumberField) ?? '';
  }

  Future<void> _setUsePinProtection(
    SharedPreferences prefs,
    bool usePinProtection,
  ) async {
    await prefs.setBool(
      SideswapSettings.usePinProtectionField,
      usePinProtection,
    );
  }

  bool _usePinProtection(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.usePinProtectionField) ?? false;
  }

  PinDataState? _pinData(SharedPreferences prefs) {
    final salt = prefs.getString(SideswapSettings.pinSaltField);
    final encryptedData = prefs.getString(
      SideswapSettings.pinEncryptedDataField,
    );
    final pinIdentifier = prefs.getString(SideswapSettings.pinIdentifierField);
    final pinHmac = prefs.getString(SideswapSettings.pinHmacField);

    final pinData = PinDataStateData(
      salt: salt ?? '',
      encryptedData: encryptedData ?? '',
      pinIdentifier: pinIdentifier ?? '',
      hmac: pinHmac ?? '',
    );

    return switch (pinData) {
      PinDataStateData() when pinData.isWhole => pinData,
      _ => const PinDataStateEmpty(),
    };
  }

  Future<void> _setDefaultCurrency(
    SharedPreferences prefs,
    String? defaultCurrency,
  ) async {
    (switch (defaultCurrency) {
      final defaultCurrency? => await prefs.setString(
        SideswapSettings.defaultCurrencyField,
        defaultCurrency,
      ),
      _ => () {}(),
    });
  }

  Future<void> _setPinData(
    SharedPreferences prefs,
    PinDataState? pinData,
  ) async {
    return await switch (pinData) {
      PinDataStateData(
        salt: final salt,
        encryptedData: final encryptedData,
        pinIdentifier: final pinIdentifier,
        hmac: final pinHmac,
      )
          when pinData.isWhole =>
        () async {
          // Skip only an unchanged blob. `_writeSettings` re-runs every key on
          // every settings change, so re-writing the same blob is waste; a
          // *different* blob must be written, or the next app start loads the
          // old one and the new PIN fails against it.
          final previousData = _pinData(prefs);
          if (previousData == pinData) {
            return;
          }
          await prefs.setString(SideswapSettings.pinSaltField, salt);
          await prefs.setString(
            SideswapSettings.pinEncryptedDataField,
            encryptedData,
          );
          await prefs.setString(
            SideswapSettings.pinIdentifierField,
            pinIdentifier,
          );
          await prefs.setString(SideswapSettings.pinHmacField, pinHmac);
        }(),
      _ => () async {
        await prefs.remove(SideswapSettings.pinEncryptedDataField);
        await prefs.remove(SideswapSettings.pinIdentifierField);
        await prefs.remove(SideswapSettings.pinSaltField);
        await prefs.remove(SideswapSettings.pinHmacField);
      }(),
    };
  }

  Future<void> _setSettingsNetworkType(
    SharedPreferences prefs,
    SettingsNetworkType type,
  ) async {
    await prefs.setString(
      SideswapSettings.settingsNetworkTypeField,
      EnumToString.convertToString(type),
    );
  }

  SettingsNetworkType _settingsNetworkType(SharedPreferences prefs) {
    final typeString = prefs.getString(
      SideswapSettings.settingsNetworkTypeField,
    );

    final settingsNetworkType = switch (typeString) {
      final notNullString? => EnumToString.fromString(
        SettingsNetworkType.values,
        notNullString,
      ),
      _ => null,
    };

    final context = ref.read(navigatorKeyProvider).currentContext;
    final lang = ref.read(localesProvider);
    if (settingsNetworkType == null && context != null && lang == 'zh') {
      return SettingsNetworkType.sideswapChina;
    }

    if (settingsNetworkType == null) {
      return SettingsNetworkType.sideswap;
    }

    return settingsNetworkType;
  }

  Future<void> _setNetworkHost(SharedPreferences prefs, String host) async {
    await prefs.setString(SideswapSettings.settingsHostField, host);
  }

  String _networkHost(SharedPreferences prefs) {
    return prefs.getString(SideswapSettings.settingsHostField) ?? '';
  }

  Future<void> _setNetworkPort(SharedPreferences prefs, int port) async {
    await prefs.setInt(SideswapSettings.settingsPortField, port);
  }

  int _networkPort(SharedPreferences prefs) {
    return prefs.getInt(SideswapSettings.settingsPortField) ?? 0;
  }

  Future<void> _setNetworkUseTLS(SharedPreferences prefs, bool value) async {
    await prefs.setBool(SideswapSettings.settingsUseTLSField, value);
  }

  bool _networkUseTLS(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.settingsUseTLSField) ?? false;
  }

  Future<void> _setKnownNewReleaseBuild(
    SharedPreferences prefs,
    int value,
  ) async {
    await prefs.setInt(SideswapSettings.knownNewReleaseField, value);
  }

  int _knownNewReleaseBuild(SharedPreferences prefs) {
    return prefs.getInt(SideswapSettings.knownNewReleaseField) ?? 0;
  }

  Future<void> _setShowAmpOnboarding(
    SharedPreferences prefs,
    bool value,
  ) async {
    await prefs.setBool(SideswapSettings.showAmpOnboardingField, value);
  }

  bool _showAmpOnboarding(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.showAmpOnboardingField) ?? false;
  }

  Future<void> _setNetworkSettingsModel(
    SharedPreferences prefs,
    NetworkSettingsModel? model,
  ) async {
    return await switch (model) {
      final model? => () async {
        final encoded = jsonEncode(model.toJson());
        await prefs.setString(
          SideswapSettings.networkSettingsModelField,
          encoded,
        );
      }(),
      _ => () async {
        await prefs.remove(SideswapSettings.networkSettingsModelField);
      }(),
    };
  }

  NetworkSettingsModel _networkSettingsModel(SharedPreferences prefs) {
    final encoded = prefs.getString(SideswapSettings.networkSettingsModelField);

    try {
      return switch (encoded) {
        final encodedJson? => () {
          final json = jsonDecode(encodedJson) as Map<String, dynamic>;
          return NetworkSettingsModel.fromJson(json);
        }(),
        _ => () {
          return NetworkSettingsModelEmpty(
            settingsNetworkType: _settingsNetworkType(prefs),
            env: _env(prefs),
          );
        }(),
      };
    } catch (e) {
      logger.w(e);
    }

    return NetworkSettingsModelEmpty(
      settingsNetworkType: _settingsNetworkType(prefs),
      env: _env(prefs),
    );
  }

  Future<void> _setDesktopWindowGeometry(
    SharedPreferences prefs,
    DesktopWindowGeometry? geometry,
  ) async {
    return await switch (geometry) {
      final geometry? => () async {
        await prefs.setString(
          SideswapSettings.desktopWindowGeometryField,
          jsonEncode(geometry.toJson()),
        );
      }(),
      _ => () async {
        await prefs.remove(SideswapSettings.desktopWindowGeometryField);
      }(),
    };
  }

  /// The stored geometry, or null when nothing is stored and when the stored
  /// text does not decode. A geometry the app cannot read is a hint it drops,
  /// never a launch failure.
  DesktopWindowGeometry? _desktopWindowGeometry(SharedPreferences prefs) {
    final encoded = prefs.getString(
      SideswapSettings.desktopWindowGeometryField,
    );
    if (encoded == null) {
      return null;
    }

    try {
      return DesktopWindowGeometry.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
    } catch (e) {
      logger.w(e);
      return null;
    }
  }

  Future<void> _setStokrSettings(
    SharedPreferences prefs,
    StokrSettingsModel? model,
  ) async {
    return await switch (model) {
      final model? => () async {
        final encoded = jsonEncode(model.toJson());
        await prefs.setString(
          SideswapSettings.stokrSettingsModelField,
          encoded,
        );
      }(),
      _ => () async {
        await prefs.remove(SideswapSettings.stokrSettingsModelField);
      }(),
    };
  }

  StokrSettingsModel _stokrSettings(SharedPreferences prefs) {
    final encoded = prefs.getString(SideswapSettings.stokrSettingsModelField);

    try {
      return switch (encoded) {
        final encodedJson? => () {
          final json = jsonDecode(encodedJson) as Map<String, dynamic>;
          return StokrSettingsModel.fromJson(json);
        }(),
        _ => () {
          return const StokrSettingsModel();
        }(),
      };
    } catch (e) {
      logger.e(e);
    }

    return const StokrSettingsModel();
  }

  Map<String, bool> _autosignDomains(SharedPreferences prefs) {
    final encoded = prefs.getString(SideswapSettings.autosignDomainsField);
    try {
      return switch (encoded) {
        final encodedJson? => () {
            final decoded = jsonDecode(encodedJson);
            if (decoded is! Map) return <String, bool>{};
            return <String, bool>{
              for (final e in decoded.entries)
                if (e.value is bool) e.key as String: e.value as bool,
            };
          }(),
        _ => <String, bool>{},
      };
    } catch (e) {
      logger.w(e);
      return {};
    }
  }

  Future<void> _setAutosignDomains(
    SharedPreferences prefs,
    Map<String, bool> map,
  ) async {
    return await switch (map.isEmpty) {
      true => () async {
          await prefs.remove(SideswapSettings.autosignDomainsField);
        }(),
      _ => () async {
          await prefs.setString(
            SideswapSettings.autosignDomainsField,
            jsonEncode(map),
          );
        }(),
    };
  }

  Future<void> _setHideTxChainingPromptValue(
    SharedPreferences prefs,
    bool value,
  ) async {
    await prefs.setBool(SideswapSettings.hideTxChainingPromptField, value);
  }

  bool _hideTxChainingPromptValue(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.hideTxChainingPromptField) ?? false;
  }

  Future<void> _setProxySettings(
    SharedPreferences prefs,
    ProxySettings? proxySettings,
  ) async {
    return await switch (proxySettings) {
      ProxySettings(host: String host, port: int port) => () async {
        await prefs.setString(SideswapSettings.proxyHostField, host);
        await prefs.setInt(SideswapSettings.proxyPortField, port);
      }(),
      _ => () async {
        await prefs.remove(SideswapSettings.proxyHostField);
        await prefs.remove(SideswapSettings.proxyPortField);
      }(),
    };
  }

  ProxySettings? _proxySettings(SharedPreferences prefs) {
    final host = prefs.getString(SideswapSettings.proxyHostField);
    final port = prefs.getInt(SideswapSettings.proxyPortField);

    final proxySettings = ProxySettings(host: host, port: port);

    return switch (proxySettings) {
      ProxySettings(host: String _, port: int _) => proxySettings,
      _ => null,
    };
  }

  Future<void> _setUseProxy(SharedPreferences prefs, bool useProxy) async {
    await prefs.setBool(SideswapSettings.useProxyField, useProxy);
  }

  bool _useProxy(SharedPreferences prefs) {
    return prefs.getBool(SideswapSettings.useProxyField) ?? false;
  }
}
