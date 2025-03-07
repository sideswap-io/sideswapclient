// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SideswapSettings {

 Uint8List get mnemonicEncrypted; String get jadeId; bool get licenseAccepted; bool get enableEndpoint; bool get useBiometricProtection; int get env; String get phoneKey; String get phoneNumber; bool get usePinProtection; PinDataState? get pinDataState; SettingsNetworkType get settingsNetworkType; String get networkHost; int get networkPort; bool get networkUseTLS; int get knownNewReleaseBuild; bool get showAmpOnboarding; NetworkSettingsModel? get networkSettingsModel; bool get hideTxChainingPromptValue; bool get hidePegInInfo; bool get hidePegOutInfo; ProxySettings? get proxySettings; bool get useProxy; String? get defaultCurrency; StokrSettingsModel? get stokrSettingsModel;
/// Create a copy of SideswapSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SideswapSettingsCopyWith<SideswapSettings> get copyWith => _$SideswapSettingsCopyWithImpl<SideswapSettings>(this as SideswapSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SideswapSettings&&const DeepCollectionEquality().equals(other.mnemonicEncrypted, mnemonicEncrypted)&&(identical(other.jadeId, jadeId) || other.jadeId == jadeId)&&(identical(other.licenseAccepted, licenseAccepted) || other.licenseAccepted == licenseAccepted)&&(identical(other.enableEndpoint, enableEndpoint) || other.enableEndpoint == enableEndpoint)&&(identical(other.useBiometricProtection, useBiometricProtection) || other.useBiometricProtection == useBiometricProtection)&&(identical(other.env, env) || other.env == env)&&(identical(other.phoneKey, phoneKey) || other.phoneKey == phoneKey)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.usePinProtection, usePinProtection) || other.usePinProtection == usePinProtection)&&(identical(other.pinDataState, pinDataState) || other.pinDataState == pinDataState)&&(identical(other.settingsNetworkType, settingsNetworkType) || other.settingsNetworkType == settingsNetworkType)&&(identical(other.networkHost, networkHost) || other.networkHost == networkHost)&&(identical(other.networkPort, networkPort) || other.networkPort == networkPort)&&(identical(other.networkUseTLS, networkUseTLS) || other.networkUseTLS == networkUseTLS)&&(identical(other.knownNewReleaseBuild, knownNewReleaseBuild) || other.knownNewReleaseBuild == knownNewReleaseBuild)&&(identical(other.showAmpOnboarding, showAmpOnboarding) || other.showAmpOnboarding == showAmpOnboarding)&&(identical(other.networkSettingsModel, networkSettingsModel) || other.networkSettingsModel == networkSettingsModel)&&(identical(other.hideTxChainingPromptValue, hideTxChainingPromptValue) || other.hideTxChainingPromptValue == hideTxChainingPromptValue)&&(identical(other.hidePegInInfo, hidePegInInfo) || other.hidePegInInfo == hidePegInInfo)&&(identical(other.hidePegOutInfo, hidePegOutInfo) || other.hidePegOutInfo == hidePegOutInfo)&&(identical(other.proxySettings, proxySettings) || other.proxySettings == proxySettings)&&(identical(other.useProxy, useProxy) || other.useProxy == useProxy)&&(identical(other.defaultCurrency, defaultCurrency) || other.defaultCurrency == defaultCurrency)&&(identical(other.stokrSettingsModel, stokrSettingsModel) || other.stokrSettingsModel == stokrSettingsModel));
}


@override
int get hashCode => Object.hashAll([runtimeType,const DeepCollectionEquality().hash(mnemonicEncrypted),jadeId,licenseAccepted,enableEndpoint,useBiometricProtection,env,phoneKey,phoneNumber,usePinProtection,pinDataState,settingsNetworkType,networkHost,networkPort,networkUseTLS,knownNewReleaseBuild,showAmpOnboarding,networkSettingsModel,hideTxChainingPromptValue,hidePegInInfo,hidePegOutInfo,proxySettings,useProxy,defaultCurrency,stokrSettingsModel]);

@override
String toString() {
  return 'SideswapSettings(mnemonicEncrypted: $mnemonicEncrypted, jadeId: $jadeId, licenseAccepted: $licenseAccepted, enableEndpoint: $enableEndpoint, useBiometricProtection: $useBiometricProtection, env: $env, phoneKey: $phoneKey, phoneNumber: $phoneNumber, usePinProtection: $usePinProtection, pinDataState: $pinDataState, settingsNetworkType: $settingsNetworkType, networkHost: $networkHost, networkPort: $networkPort, networkUseTLS: $networkUseTLS, knownNewReleaseBuild: $knownNewReleaseBuild, showAmpOnboarding: $showAmpOnboarding, networkSettingsModel: $networkSettingsModel, hideTxChainingPromptValue: $hideTxChainingPromptValue, hidePegInInfo: $hidePegInInfo, hidePegOutInfo: $hidePegOutInfo, proxySettings: $proxySettings, useProxy: $useProxy, defaultCurrency: $defaultCurrency, stokrSettingsModel: $stokrSettingsModel)';
}


}

/// @nodoc
abstract mixin class $SideswapSettingsCopyWith<$Res>  {
  factory $SideswapSettingsCopyWith(SideswapSettings value, $Res Function(SideswapSettings) _then) = _$SideswapSettingsCopyWithImpl;
@useResult
$Res call({
 Uint8List mnemonicEncrypted, String jadeId, bool licenseAccepted, bool enableEndpoint, bool useBiometricProtection, int env, String phoneKey, String phoneNumber, bool usePinProtection, PinDataState? pinDataState, SettingsNetworkType settingsNetworkType, String networkHost, int networkPort, bool networkUseTLS, int knownNewReleaseBuild, bool showAmpOnboarding, NetworkSettingsModel? networkSettingsModel, bool hideTxChainingPromptValue, bool hidePegInInfo, bool hidePegOutInfo, ProxySettings? proxySettings, bool useProxy, String? defaultCurrency, StokrSettingsModel? stokrSettingsModel
});


$PinDataStateCopyWith<$Res>? get pinDataState;$NetworkSettingsModelCopyWith<$Res>? get networkSettingsModel;$ProxySettingsCopyWith<$Res>? get proxySettings;$StokrSettingsModelCopyWith<$Res>? get stokrSettingsModel;

}
/// @nodoc
class _$SideswapSettingsCopyWithImpl<$Res>
    implements $SideswapSettingsCopyWith<$Res> {
  _$SideswapSettingsCopyWithImpl(this._self, this._then);

  final SideswapSettings _self;
  final $Res Function(SideswapSettings) _then;

/// Create a copy of SideswapSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mnemonicEncrypted = null,Object? jadeId = null,Object? licenseAccepted = null,Object? enableEndpoint = null,Object? useBiometricProtection = null,Object? env = null,Object? phoneKey = null,Object? phoneNumber = null,Object? usePinProtection = null,Object? pinDataState = freezed,Object? settingsNetworkType = null,Object? networkHost = null,Object? networkPort = null,Object? networkUseTLS = null,Object? knownNewReleaseBuild = null,Object? showAmpOnboarding = null,Object? networkSettingsModel = freezed,Object? hideTxChainingPromptValue = null,Object? hidePegInInfo = null,Object? hidePegOutInfo = null,Object? proxySettings = freezed,Object? useProxy = null,Object? defaultCurrency = freezed,Object? stokrSettingsModel = freezed,}) {
  return _then(_self.copyWith(
mnemonicEncrypted: null == mnemonicEncrypted ? _self.mnemonicEncrypted : mnemonicEncrypted // ignore: cast_nullable_to_non_nullable
as Uint8List,jadeId: null == jadeId ? _self.jadeId : jadeId // ignore: cast_nullable_to_non_nullable
as String,licenseAccepted: null == licenseAccepted ? _self.licenseAccepted : licenseAccepted // ignore: cast_nullable_to_non_nullable
as bool,enableEndpoint: null == enableEndpoint ? _self.enableEndpoint : enableEndpoint // ignore: cast_nullable_to_non_nullable
as bool,useBiometricProtection: null == useBiometricProtection ? _self.useBiometricProtection : useBiometricProtection // ignore: cast_nullable_to_non_nullable
as bool,env: null == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as int,phoneKey: null == phoneKey ? _self.phoneKey : phoneKey // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,usePinProtection: null == usePinProtection ? _self.usePinProtection : usePinProtection // ignore: cast_nullable_to_non_nullable
as bool,pinDataState: freezed == pinDataState ? _self.pinDataState : pinDataState // ignore: cast_nullable_to_non_nullable
as PinDataState?,settingsNetworkType: null == settingsNetworkType ? _self.settingsNetworkType : settingsNetworkType // ignore: cast_nullable_to_non_nullable
as SettingsNetworkType,networkHost: null == networkHost ? _self.networkHost : networkHost // ignore: cast_nullable_to_non_nullable
as String,networkPort: null == networkPort ? _self.networkPort : networkPort // ignore: cast_nullable_to_non_nullable
as int,networkUseTLS: null == networkUseTLS ? _self.networkUseTLS : networkUseTLS // ignore: cast_nullable_to_non_nullable
as bool,knownNewReleaseBuild: null == knownNewReleaseBuild ? _self.knownNewReleaseBuild : knownNewReleaseBuild // ignore: cast_nullable_to_non_nullable
as int,showAmpOnboarding: null == showAmpOnboarding ? _self.showAmpOnboarding : showAmpOnboarding // ignore: cast_nullable_to_non_nullable
as bool,networkSettingsModel: freezed == networkSettingsModel ? _self.networkSettingsModel : networkSettingsModel // ignore: cast_nullable_to_non_nullable
as NetworkSettingsModel?,hideTxChainingPromptValue: null == hideTxChainingPromptValue ? _self.hideTxChainingPromptValue : hideTxChainingPromptValue // ignore: cast_nullable_to_non_nullable
as bool,hidePegInInfo: null == hidePegInInfo ? _self.hidePegInInfo : hidePegInInfo // ignore: cast_nullable_to_non_nullable
as bool,hidePegOutInfo: null == hidePegOutInfo ? _self.hidePegOutInfo : hidePegOutInfo // ignore: cast_nullable_to_non_nullable
as bool,proxySettings: freezed == proxySettings ? _self.proxySettings : proxySettings // ignore: cast_nullable_to_non_nullable
as ProxySettings?,useProxy: null == useProxy ? _self.useProxy : useProxy // ignore: cast_nullable_to_non_nullable
as bool,defaultCurrency: freezed == defaultCurrency ? _self.defaultCurrency : defaultCurrency // ignore: cast_nullable_to_non_nullable
as String?,stokrSettingsModel: freezed == stokrSettingsModel ? _self.stokrSettingsModel : stokrSettingsModel // ignore: cast_nullable_to_non_nullable
as StokrSettingsModel?,
  ));
}
/// Create a copy of SideswapSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PinDataStateCopyWith<$Res>? get pinDataState {
    if (_self.pinDataState == null) {
    return null;
  }

  return $PinDataStateCopyWith<$Res>(_self.pinDataState!, (value) {
    return _then(_self.copyWith(pinDataState: value));
  });
}/// Create a copy of SideswapSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkSettingsModelCopyWith<$Res>? get networkSettingsModel {
    if (_self.networkSettingsModel == null) {
    return null;
  }

  return $NetworkSettingsModelCopyWith<$Res>(_self.networkSettingsModel!, (value) {
    return _then(_self.copyWith(networkSettingsModel: value));
  });
}/// Create a copy of SideswapSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProxySettingsCopyWith<$Res>? get proxySettings {
    if (_self.proxySettings == null) {
    return null;
  }

  return $ProxySettingsCopyWith<$Res>(_self.proxySettings!, (value) {
    return _then(_self.copyWith(proxySettings: value));
  });
}/// Create a copy of SideswapSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StokrSettingsModelCopyWith<$Res>? get stokrSettingsModel {
    if (_self.stokrSettingsModel == null) {
    return null;
  }

  return $StokrSettingsModelCopyWith<$Res>(_self.stokrSettingsModel!, (value) {
    return _then(_self.copyWith(stokrSettingsModel: value));
  });
}
}


/// @nodoc


class _SideswapSettings implements SideswapSettings {
   _SideswapSettings({required this.mnemonicEncrypted, this.jadeId = '', this.licenseAccepted = false, this.enableEndpoint = true, this.useBiometricProtection = false, this.env = 0, this.phoneKey = '', this.phoneNumber = '', this.usePinProtection = false, this.pinDataState, this.settingsNetworkType = SettingsNetworkType.sideswap, this.networkHost = '', this.networkPort = 0, this.networkUseTLS = false, this.knownNewReleaseBuild = 0, this.showAmpOnboarding = true, this.networkSettingsModel, this.hideTxChainingPromptValue = false, this.hidePegInInfo = false, this.hidePegOutInfo = false, this.proxySettings, this.useProxy = false, this.defaultCurrency, this.stokrSettingsModel});
  

@override final  Uint8List mnemonicEncrypted;
@override@JsonKey() final  String jadeId;
@override@JsonKey() final  bool licenseAccepted;
@override@JsonKey() final  bool enableEndpoint;
@override@JsonKey() final  bool useBiometricProtection;
@override@JsonKey() final  int env;
@override@JsonKey() final  String phoneKey;
@override@JsonKey() final  String phoneNumber;
@override@JsonKey() final  bool usePinProtection;
@override final  PinDataState? pinDataState;
@override@JsonKey() final  SettingsNetworkType settingsNetworkType;
@override@JsonKey() final  String networkHost;
@override@JsonKey() final  int networkPort;
@override@JsonKey() final  bool networkUseTLS;
@override@JsonKey() final  int knownNewReleaseBuild;
@override@JsonKey() final  bool showAmpOnboarding;
@override final  NetworkSettingsModel? networkSettingsModel;
@override@JsonKey() final  bool hideTxChainingPromptValue;
@override@JsonKey() final  bool hidePegInInfo;
@override@JsonKey() final  bool hidePegOutInfo;
@override final  ProxySettings? proxySettings;
@override@JsonKey() final  bool useProxy;
@override final  String? defaultCurrency;
@override final  StokrSettingsModel? stokrSettingsModel;

/// Create a copy of SideswapSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SideswapSettingsCopyWith<_SideswapSettings> get copyWith => __$SideswapSettingsCopyWithImpl<_SideswapSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SideswapSettings&&const DeepCollectionEquality().equals(other.mnemonicEncrypted, mnemonicEncrypted)&&(identical(other.jadeId, jadeId) || other.jadeId == jadeId)&&(identical(other.licenseAccepted, licenseAccepted) || other.licenseAccepted == licenseAccepted)&&(identical(other.enableEndpoint, enableEndpoint) || other.enableEndpoint == enableEndpoint)&&(identical(other.useBiometricProtection, useBiometricProtection) || other.useBiometricProtection == useBiometricProtection)&&(identical(other.env, env) || other.env == env)&&(identical(other.phoneKey, phoneKey) || other.phoneKey == phoneKey)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.usePinProtection, usePinProtection) || other.usePinProtection == usePinProtection)&&(identical(other.pinDataState, pinDataState) || other.pinDataState == pinDataState)&&(identical(other.settingsNetworkType, settingsNetworkType) || other.settingsNetworkType == settingsNetworkType)&&(identical(other.networkHost, networkHost) || other.networkHost == networkHost)&&(identical(other.networkPort, networkPort) || other.networkPort == networkPort)&&(identical(other.networkUseTLS, networkUseTLS) || other.networkUseTLS == networkUseTLS)&&(identical(other.knownNewReleaseBuild, knownNewReleaseBuild) || other.knownNewReleaseBuild == knownNewReleaseBuild)&&(identical(other.showAmpOnboarding, showAmpOnboarding) || other.showAmpOnboarding == showAmpOnboarding)&&(identical(other.networkSettingsModel, networkSettingsModel) || other.networkSettingsModel == networkSettingsModel)&&(identical(other.hideTxChainingPromptValue, hideTxChainingPromptValue) || other.hideTxChainingPromptValue == hideTxChainingPromptValue)&&(identical(other.hidePegInInfo, hidePegInInfo) || other.hidePegInInfo == hidePegInInfo)&&(identical(other.hidePegOutInfo, hidePegOutInfo) || other.hidePegOutInfo == hidePegOutInfo)&&(identical(other.proxySettings, proxySettings) || other.proxySettings == proxySettings)&&(identical(other.useProxy, useProxy) || other.useProxy == useProxy)&&(identical(other.defaultCurrency, defaultCurrency) || other.defaultCurrency == defaultCurrency)&&(identical(other.stokrSettingsModel, stokrSettingsModel) || other.stokrSettingsModel == stokrSettingsModel));
}


@override
int get hashCode => Object.hashAll([runtimeType,const DeepCollectionEquality().hash(mnemonicEncrypted),jadeId,licenseAccepted,enableEndpoint,useBiometricProtection,env,phoneKey,phoneNumber,usePinProtection,pinDataState,settingsNetworkType,networkHost,networkPort,networkUseTLS,knownNewReleaseBuild,showAmpOnboarding,networkSettingsModel,hideTxChainingPromptValue,hidePegInInfo,hidePegOutInfo,proxySettings,useProxy,defaultCurrency,stokrSettingsModel]);

@override
String toString() {
  return 'SideswapSettings.empty(mnemonicEncrypted: $mnemonicEncrypted, jadeId: $jadeId, licenseAccepted: $licenseAccepted, enableEndpoint: $enableEndpoint, useBiometricProtection: $useBiometricProtection, env: $env, phoneKey: $phoneKey, phoneNumber: $phoneNumber, usePinProtection: $usePinProtection, pinDataState: $pinDataState, settingsNetworkType: $settingsNetworkType, networkHost: $networkHost, networkPort: $networkPort, networkUseTLS: $networkUseTLS, knownNewReleaseBuild: $knownNewReleaseBuild, showAmpOnboarding: $showAmpOnboarding, networkSettingsModel: $networkSettingsModel, hideTxChainingPromptValue: $hideTxChainingPromptValue, hidePegInInfo: $hidePegInInfo, hidePegOutInfo: $hidePegOutInfo, proxySettings: $proxySettings, useProxy: $useProxy, defaultCurrency: $defaultCurrency, stokrSettingsModel: $stokrSettingsModel)';
}


}

/// @nodoc
abstract mixin class _$SideswapSettingsCopyWith<$Res> implements $SideswapSettingsCopyWith<$Res> {
  factory _$SideswapSettingsCopyWith(_SideswapSettings value, $Res Function(_SideswapSettings) _then) = __$SideswapSettingsCopyWithImpl;
@override @useResult
$Res call({
 Uint8List mnemonicEncrypted, String jadeId, bool licenseAccepted, bool enableEndpoint, bool useBiometricProtection, int env, String phoneKey, String phoneNumber, bool usePinProtection, PinDataState? pinDataState, SettingsNetworkType settingsNetworkType, String networkHost, int networkPort, bool networkUseTLS, int knownNewReleaseBuild, bool showAmpOnboarding, NetworkSettingsModel? networkSettingsModel, bool hideTxChainingPromptValue, bool hidePegInInfo, bool hidePegOutInfo, ProxySettings? proxySettings, bool useProxy, String? defaultCurrency, StokrSettingsModel? stokrSettingsModel
});


@override $PinDataStateCopyWith<$Res>? get pinDataState;@override $NetworkSettingsModelCopyWith<$Res>? get networkSettingsModel;@override $ProxySettingsCopyWith<$Res>? get proxySettings;@override $StokrSettingsModelCopyWith<$Res>? get stokrSettingsModel;

}
/// @nodoc
class __$SideswapSettingsCopyWithImpl<$Res>
    implements _$SideswapSettingsCopyWith<$Res> {
  __$SideswapSettingsCopyWithImpl(this._self, this._then);

  final _SideswapSettings _self;
  final $Res Function(_SideswapSettings) _then;

/// Create a copy of SideswapSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mnemonicEncrypted = null,Object? jadeId = null,Object? licenseAccepted = null,Object? enableEndpoint = null,Object? useBiometricProtection = null,Object? env = null,Object? phoneKey = null,Object? phoneNumber = null,Object? usePinProtection = null,Object? pinDataState = freezed,Object? settingsNetworkType = null,Object? networkHost = null,Object? networkPort = null,Object? networkUseTLS = null,Object? knownNewReleaseBuild = null,Object? showAmpOnboarding = null,Object? networkSettingsModel = freezed,Object? hideTxChainingPromptValue = null,Object? hidePegInInfo = null,Object? hidePegOutInfo = null,Object? proxySettings = freezed,Object? useProxy = null,Object? defaultCurrency = freezed,Object? stokrSettingsModel = freezed,}) {
  return _then(_SideswapSettings(
mnemonicEncrypted: null == mnemonicEncrypted ? _self.mnemonicEncrypted : mnemonicEncrypted // ignore: cast_nullable_to_non_nullable
as Uint8List,jadeId: null == jadeId ? _self.jadeId : jadeId // ignore: cast_nullable_to_non_nullable
as String,licenseAccepted: null == licenseAccepted ? _self.licenseAccepted : licenseAccepted // ignore: cast_nullable_to_non_nullable
as bool,enableEndpoint: null == enableEndpoint ? _self.enableEndpoint : enableEndpoint // ignore: cast_nullable_to_non_nullable
as bool,useBiometricProtection: null == useBiometricProtection ? _self.useBiometricProtection : useBiometricProtection // ignore: cast_nullable_to_non_nullable
as bool,env: null == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as int,phoneKey: null == phoneKey ? _self.phoneKey : phoneKey // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,usePinProtection: null == usePinProtection ? _self.usePinProtection : usePinProtection // ignore: cast_nullable_to_non_nullable
as bool,pinDataState: freezed == pinDataState ? _self.pinDataState : pinDataState // ignore: cast_nullable_to_non_nullable
as PinDataState?,settingsNetworkType: null == settingsNetworkType ? _self.settingsNetworkType : settingsNetworkType // ignore: cast_nullable_to_non_nullable
as SettingsNetworkType,networkHost: null == networkHost ? _self.networkHost : networkHost // ignore: cast_nullable_to_non_nullable
as String,networkPort: null == networkPort ? _self.networkPort : networkPort // ignore: cast_nullable_to_non_nullable
as int,networkUseTLS: null == networkUseTLS ? _self.networkUseTLS : networkUseTLS // ignore: cast_nullable_to_non_nullable
as bool,knownNewReleaseBuild: null == knownNewReleaseBuild ? _self.knownNewReleaseBuild : knownNewReleaseBuild // ignore: cast_nullable_to_non_nullable
as int,showAmpOnboarding: null == showAmpOnboarding ? _self.showAmpOnboarding : showAmpOnboarding // ignore: cast_nullable_to_non_nullable
as bool,networkSettingsModel: freezed == networkSettingsModel ? _self.networkSettingsModel : networkSettingsModel // ignore: cast_nullable_to_non_nullable
as NetworkSettingsModel?,hideTxChainingPromptValue: null == hideTxChainingPromptValue ? _self.hideTxChainingPromptValue : hideTxChainingPromptValue // ignore: cast_nullable_to_non_nullable
as bool,hidePegInInfo: null == hidePegInInfo ? _self.hidePegInInfo : hidePegInInfo // ignore: cast_nullable_to_non_nullable
as bool,hidePegOutInfo: null == hidePegOutInfo ? _self.hidePegOutInfo : hidePegOutInfo // ignore: cast_nullable_to_non_nullable
as bool,proxySettings: freezed == proxySettings ? _self.proxySettings : proxySettings // ignore: cast_nullable_to_non_nullable
as ProxySettings?,useProxy: null == useProxy ? _self.useProxy : useProxy // ignore: cast_nullable_to_non_nullable
as bool,defaultCurrency: freezed == defaultCurrency ? _self.defaultCurrency : defaultCurrency // ignore: cast_nullable_to_non_nullable
as String?,stokrSettingsModel: freezed == stokrSettingsModel ? _self.stokrSettingsModel : stokrSettingsModel // ignore: cast_nullable_to_non_nullable
as StokrSettingsModel?,
  ));
}

/// Create a copy of SideswapSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PinDataStateCopyWith<$Res>? get pinDataState {
    if (_self.pinDataState == null) {
    return null;
  }

  return $PinDataStateCopyWith<$Res>(_self.pinDataState!, (value) {
    return _then(_self.copyWith(pinDataState: value));
  });
}/// Create a copy of SideswapSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkSettingsModelCopyWith<$Res>? get networkSettingsModel {
    if (_self.networkSettingsModel == null) {
    return null;
  }

  return $NetworkSettingsModelCopyWith<$Res>(_self.networkSettingsModel!, (value) {
    return _then(_self.copyWith(networkSettingsModel: value));
  });
}/// Create a copy of SideswapSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProxySettingsCopyWith<$Res>? get proxySettings {
    if (_self.proxySettings == null) {
    return null;
  }

  return $ProxySettingsCopyWith<$Res>(_self.proxySettings!, (value) {
    return _then(_self.copyWith(proxySettings: value));
  });
}/// Create a copy of SideswapSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StokrSettingsModelCopyWith<$Res>? get stokrSettingsModel {
    if (_self.stokrSettingsModel == null) {
    return null;
  }

  return $StokrSettingsModelCopyWith<$Res>(_self.stokrSettingsModel!, (value) {
    return _then(_self.copyWith(stokrSettingsModel: value));
  });
}
}

// dart format on
