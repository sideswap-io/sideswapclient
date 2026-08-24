// This is a generated file - do not edit.
//
// Generated from pegx_api.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'pegx_api.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'pegx_api.pbenum.dart';

class AccountDetails_OrgDetails extends $pb.GeneratedMessage {
  factory AccountDetails_OrgDetails({
    $core.String? name,
    $core.String? address,
    $core.String? city,
    $core.String? postcode,
    $core.String? country,
    $core.String? website,
    $core.String? regNumber,
    $core.String? ownerEmail,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (address != null) result.address = address;
    if (city != null) result.city = city;
    if (postcode != null) result.postcode = postcode;
    if (country != null) result.country = country;
    if (website != null) result.website = website;
    if (regNumber != null) result.regNumber = regNumber;
    if (ownerEmail != null) result.ownerEmail = ownerEmail;
    return result;
  }

  AccountDetails_OrgDetails._();

  factory AccountDetails_OrgDetails.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountDetails_OrgDetails.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountDetails.OrgDetails',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'name')
    ..aQS(2, _omitFieldNames ? '' : 'address')
    ..aQS(3, _omitFieldNames ? '' : 'city')
    ..aQS(4, _omitFieldNames ? '' : 'postcode')
    ..aQS(5, _omitFieldNames ? '' : 'country')
    ..aQS(6, _omitFieldNames ? '' : 'website')
    ..aQS(7, _omitFieldNames ? '' : 'regNumber')
    ..aQS(8, _omitFieldNames ? '' : 'ownerEmail');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDetails_OrgDetails clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDetails_OrgDetails copyWith(
          void Function(AccountDetails_OrgDetails) updates) =>
      super.copyWith((message) => updates(message as AccountDetails_OrgDetails))
          as AccountDetails_OrgDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDetails_OrgDetails create() => AccountDetails_OrgDetails._();
  @$core.override
  AccountDetails_OrgDetails createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountDetails_OrgDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountDetails_OrgDetails>(create);
  static AccountDetails_OrgDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get address => $_getSZ(1);
  @$pb.TagNumber(2)
  set address($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddress() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get city => $_getSZ(2);
  @$pb.TagNumber(3)
  set city($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCity() => $_has(2);
  @$pb.TagNumber(3)
  void clearCity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get postcode => $_getSZ(3);
  @$pb.TagNumber(4)
  set postcode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPostcode() => $_has(3);
  @$pb.TagNumber(4)
  void clearPostcode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get country => $_getSZ(4);
  @$pb.TagNumber(5)
  set country($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCountry() => $_has(4);
  @$pb.TagNumber(5)
  void clearCountry() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get website => $_getSZ(5);
  @$pb.TagNumber(6)
  set website($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWebsite() => $_has(5);
  @$pb.TagNumber(6)
  void clearWebsite() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get regNumber => $_getSZ(6);
  @$pb.TagNumber(7)
  set regNumber($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRegNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearRegNumber() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get ownerEmail => $_getSZ(7);
  @$pb.TagNumber(8)
  set ownerEmail($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOwnerEmail() => $_has(7);
  @$pb.TagNumber(8)
  void clearOwnerEmail() => $_clearField(8);
}

class AccountDetails_IndividualDetails extends $pb.GeneratedMessage {
  factory AccountDetails_IndividualDetails({
    $core.String? firstName,
    $core.String? lastName,
    $core.String? email,
    $core.String? phoneNumber,
    $core.String? gender,
    $core.String? dateOfBirth,
    $core.String? nationality,
    $core.String? personalNumber,
    $core.String? residencyCountry,
    $core.String? residencyArea,
    $core.String? residencyCity,
    $core.String? residencyPostcode,
    $core.String? residencyAddress,
    $core.String? residencyAddress2,
  }) {
    final result = create();
    if (firstName != null) result.firstName = firstName;
    if (lastName != null) result.lastName = lastName;
    if (email != null) result.email = email;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (gender != null) result.gender = gender;
    if (dateOfBirth != null) result.dateOfBirth = dateOfBirth;
    if (nationality != null) result.nationality = nationality;
    if (personalNumber != null) result.personalNumber = personalNumber;
    if (residencyCountry != null) result.residencyCountry = residencyCountry;
    if (residencyArea != null) result.residencyArea = residencyArea;
    if (residencyCity != null) result.residencyCity = residencyCity;
    if (residencyPostcode != null) result.residencyPostcode = residencyPostcode;
    if (residencyAddress != null) result.residencyAddress = residencyAddress;
    if (residencyAddress2 != null) result.residencyAddress2 = residencyAddress2;
    return result;
  }

  AccountDetails_IndividualDetails._();

  factory AccountDetails_IndividualDetails.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountDetails_IndividualDetails.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountDetails.IndividualDetails',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'firstName')
    ..aQS(2, _omitFieldNames ? '' : 'lastName')
    ..aQS(3, _omitFieldNames ? '' : 'email')
    ..aQS(4, _omitFieldNames ? '' : 'phoneNumber')
    ..aQS(5, _omitFieldNames ? '' : 'gender')
    ..aQS(6, _omitFieldNames ? '' : 'dateOfBirth')
    ..aQS(7, _omitFieldNames ? '' : 'nationality')
    ..aQS(8, _omitFieldNames ? '' : 'personalNumber')
    ..aQS(9, _omitFieldNames ? '' : 'residencyCountry')
    ..aQS(10, _omitFieldNames ? '' : 'residencyArea')
    ..aQS(11, _omitFieldNames ? '' : 'residencyCity')
    ..aQS(12, _omitFieldNames ? '' : 'residencyPostcode')
    ..aQS(13, _omitFieldNames ? '' : 'residencyAddress')
    ..aQS(14, _omitFieldNames ? '' : 'residencyAddress2');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDetails_IndividualDetails clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDetails_IndividualDetails copyWith(
          void Function(AccountDetails_IndividualDetails) updates) =>
      super.copyWith(
              (message) => updates(message as AccountDetails_IndividualDetails))
          as AccountDetails_IndividualDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDetails_IndividualDetails create() =>
      AccountDetails_IndividualDetails._();
  @$core.override
  AccountDetails_IndividualDetails createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountDetails_IndividualDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountDetails_IndividualDetails>(
          create);
  static AccountDetails_IndividualDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get firstName => $_getSZ(0);
  @$pb.TagNumber(1)
  set firstName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFirstName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFirstName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastName => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastName() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get email => $_getSZ(2);
  @$pb.TagNumber(3)
  set email($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get phoneNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set phoneNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPhoneNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearPhoneNumber() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get gender => $_getSZ(4);
  @$pb.TagNumber(5)
  set gender($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGender() => $_has(4);
  @$pb.TagNumber(5)
  void clearGender() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get dateOfBirth => $_getSZ(5);
  @$pb.TagNumber(6)
  set dateOfBirth($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDateOfBirth() => $_has(5);
  @$pb.TagNumber(6)
  void clearDateOfBirth() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get nationality => $_getSZ(6);
  @$pb.TagNumber(7)
  set nationality($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNationality() => $_has(6);
  @$pb.TagNumber(7)
  void clearNationality() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get personalNumber => $_getSZ(7);
  @$pb.TagNumber(8)
  set personalNumber($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPersonalNumber() => $_has(7);
  @$pb.TagNumber(8)
  void clearPersonalNumber() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get residencyCountry => $_getSZ(8);
  @$pb.TagNumber(9)
  set residencyCountry($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasResidencyCountry() => $_has(8);
  @$pb.TagNumber(9)
  void clearResidencyCountry() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get residencyArea => $_getSZ(9);
  @$pb.TagNumber(10)
  set residencyArea($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasResidencyArea() => $_has(9);
  @$pb.TagNumber(10)
  void clearResidencyArea() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get residencyCity => $_getSZ(10);
  @$pb.TagNumber(11)
  set residencyCity($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasResidencyCity() => $_has(10);
  @$pb.TagNumber(11)
  void clearResidencyCity() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get residencyPostcode => $_getSZ(11);
  @$pb.TagNumber(12)
  set residencyPostcode($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasResidencyPostcode() => $_has(11);
  @$pb.TagNumber(12)
  void clearResidencyPostcode() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get residencyAddress => $_getSZ(12);
  @$pb.TagNumber(13)
  set residencyAddress($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasResidencyAddress() => $_has(12);
  @$pb.TagNumber(13)
  void clearResidencyAddress() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get residencyAddress2 => $_getSZ(13);
  @$pb.TagNumber(14)
  set residencyAddress2($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasResidencyAddress2() => $_has(13);
  @$pb.TagNumber(14)
  void clearResidencyAddress2() => $_clearField(14);
}

enum AccountDetails_Details { org, individual, notSet }

class AccountDetails extends $pb.GeneratedMessage {
  factory AccountDetails({
    AccountDetails_OrgDetails? org,
    AccountDetails_IndividualDetails? individual,
    AccountState? accountState,
  }) {
    final result = create();
    if (org != null) result.org = org;
    if (individual != null) result.individual = individual;
    if (accountState != null) result.accountState = accountState;
    return result;
  }

  AccountDetails._();

  factory AccountDetails.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountDetails.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, AccountDetails_Details>
      _AccountDetails_DetailsByTag = {
    1: AccountDetails_Details.org,
    2: AccountDetails_Details.individual,
    0: AccountDetails_Details.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountDetails',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<AccountDetails_OrgDetails>(1, _omitFieldNames ? '' : 'org',
        subBuilder: AccountDetails_OrgDetails.create)
    ..aOM<AccountDetails_IndividualDetails>(
        2, _omitFieldNames ? '' : 'individual',
        subBuilder: AccountDetails_IndividualDetails.create)
    ..aE<AccountState>(3, _omitFieldNames ? '' : 'accountState',
        fieldType: $pb.PbFieldType.QE, enumValues: AccountState.values);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDetails clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountDetails copyWith(void Function(AccountDetails) updates) =>
      super.copyWith((message) => updates(message as AccountDetails))
          as AccountDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDetails create() => AccountDetails._();
  @$core.override
  AccountDetails createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccountDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountDetails>(create);
  static AccountDetails? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  AccountDetails_Details whichDetails() =>
      _AccountDetails_DetailsByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearDetails() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AccountDetails_OrgDetails get org => $_getN(0);
  @$pb.TagNumber(1)
  set org(AccountDetails_OrgDetails value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrg() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrg() => $_clearField(1);
  @$pb.TagNumber(1)
  AccountDetails_OrgDetails ensureOrg() => $_ensure(0);

  @$pb.TagNumber(2)
  AccountDetails_IndividualDetails get individual => $_getN(1);
  @$pb.TagNumber(2)
  set individual(AccountDetails_IndividualDetails value) =>
      $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasIndividual() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndividual() => $_clearField(2);
  @$pb.TagNumber(2)
  AccountDetails_IndividualDetails ensureIndividual() => $_ensure(1);

  @$pb.TagNumber(3)
  AccountState get accountState => $_getN(2);
  @$pb.TagNumber(3)
  set accountState(AccountState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAccountState() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccountState() => $_clearField(3);
}

class Asset extends $pb.GeneratedMessage {
  factory Asset({
    $core.String? assetId,
    $core.String? name,
    $core.String? ticker,
    $core.int? precision,
    $core.String? domain,
    $core.String? iconUrl,
    $core.double? online,
    $core.double? offline,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (name != null) result.name = name;
    if (ticker != null) result.ticker = ticker;
    if (precision != null) result.precision = precision;
    if (domain != null) result.domain = domain;
    if (iconUrl != null) result.iconUrl = iconUrl;
    if (online != null) result.online = online;
    if (offline != null) result.offline = offline;
    return result;
  }

  Asset._();

  factory Asset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Asset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Asset',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..aQS(3, _omitFieldNames ? '' : 'ticker')
    ..aI(4, _omitFieldNames ? '' : 'precision', fieldType: $pb.PbFieldType.Q3)
    ..aQS(5, _omitFieldNames ? '' : 'domain')
    ..aQS(6, _omitFieldNames ? '' : 'iconUrl')
    ..aD(7, _omitFieldNames ? '' : 'online', fieldType: $pb.PbFieldType.QD)
    ..aD(8, _omitFieldNames ? '' : 'offline', fieldType: $pb.PbFieldType.QD);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset copyWith(void Function(Asset) updates) =>
      super.copyWith((message) => updates(message as Asset)) as Asset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Asset create() => Asset._();
  @$core.override
  Asset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Asset getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Asset>(create);
  static Asset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ticker => $_getSZ(2);
  @$pb.TagNumber(3)
  set ticker($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTicker() => $_has(2);
  @$pb.TagNumber(3)
  void clearTicker() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get precision => $_getIZ(3);
  @$pb.TagNumber(4)
  set precision($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPrecision() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrecision() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get domain => $_getSZ(4);
  @$pb.TagNumber(5)
  set domain($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDomain() => $_has(4);
  @$pb.TagNumber(5)
  void clearDomain() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get iconUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set iconUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIconUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearIconUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get online => $_getN(6);
  @$pb.TagNumber(7)
  set online($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOnline() => $_has(6);
  @$pb.TagNumber(7)
  void clearOnline() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get offline => $_getN(7);
  @$pb.TagNumber(8)
  set offline($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOffline() => $_has(7);
  @$pb.TagNumber(8)
  void clearOffline() => $_clearField(8);
}

class Account extends $pb.GeneratedMessage {
  factory Account({
    $core.String? accountKey,
    AccountDetails? details,
    $core.Iterable<$core.String>? gaids,
    $core.String? name,
  }) {
    final result = create();
    if (accountKey != null) result.accountKey = accountKey;
    if (details != null) result.details = details;
    if (gaids != null) result.gaids.addAll(gaids);
    if (name != null) result.name = name;
    return result;
  }

  Account._();

  factory Account.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Account.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Account',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'accountKey')
    ..aQM<AccountDetails>(2, _omitFieldNames ? '' : 'details',
        subBuilder: AccountDetails.create)
    ..pPS(3, _omitFieldNames ? '' : 'gaids')
    ..aQS(4, _omitFieldNames ? '' : 'name');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Account clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Account copyWith(void Function(Account) updates) =>
      super.copyWith((message) => updates(message as Account)) as Account;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Account create() => Account._();
  @$core.override
  Account createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Account getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Account>(create);
  static Account? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountKey() => $_clearField(1);

  @$pb.TagNumber(2)
  AccountDetails get details => $_getN(1);
  @$pb.TagNumber(2)
  set details(AccountDetails value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDetails() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetails() => $_clearField(2);
  @$pb.TagNumber(2)
  AccountDetails ensureDetails() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get gaids => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);
}

class Balance extends $pb.GeneratedMessage {
  factory Balance({
    $core.String? assetId,
    $core.double? balance,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (balance != null) result.balance = balance;
    return result;
  }

  Balance._();

  factory Balance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Balance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Balance',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..aD(2, _omitFieldNames ? '' : 'balance', fieldType: $pb.PbFieldType.QD);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Balance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Balance copyWith(void Function(Balance) updates) =>
      super.copyWith((message) => updates(message as Balance)) as Balance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Balance create() => Balance._();
  @$core.override
  Balance createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Balance getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Balance>(create);
  static Balance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get balance => $_getN(1);
  @$pb.TagNumber(2)
  set balance($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearBalance() => $_clearField(2);
}

class Shares extends $pb.GeneratedMessage {
  factory Shares({
    $core.double? count,
    $core.double? total,
  }) {
    final result = create();
    if (count != null) result.count = count;
    if (total != null) result.total = total;
    return result;
  }

  Shares._();

  factory Shares.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Shares.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Shares',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'count', fieldType: $pb.PbFieldType.QD)
    ..aD(2, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.QD);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Shares clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Shares copyWith(void Function(Shares) updates) =>
      super.copyWith((message) => updates(message as Shares)) as Shares;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Shares create() => Shares._();
  @$core.override
  Shares createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Shares getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Shares>(create);
  static Shares? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get count => $_getN(0);
  @$pb.TagNumber(1)
  set count($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get total => $_getN(1);
  @$pb.TagNumber(2)
  set total($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class InOut extends $pb.GeneratedMessage {
  factory InOut({
    $core.double? amount,
    $core.String? gaid,
  }) {
    final result = create();
    if (amount != null) result.amount = amount;
    if (gaid != null) result.gaid = gaid;
    return result;
  }

  InOut._();

  factory InOut.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InOut.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InOut',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'amount', fieldType: $pb.PbFieldType.QD)
    ..aOS(2, _omitFieldNames ? '' : 'gaid');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InOut clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InOut copyWith(void Function(InOut) updates) =>
      super.copyWith((message) => updates(message as InOut)) as InOut;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InOut create() => InOut._();
  @$core.override
  InOut createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InOut getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InOut>(create);
  static InOut? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get amount => $_getN(0);
  @$pb.TagNumber(1)
  set amount($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get gaid => $_getSZ(1);
  @$pb.TagNumber(2)
  set gaid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGaid() => $_has(1);
  @$pb.TagNumber(2)
  void clearGaid() => $_clearField(2);
}

class FullTransaction extends $pb.GeneratedMessage {
  factory FullTransaction({
    $core.Iterable<InOut>? inputs,
    $core.Iterable<InOut>? outputs,
    $core.String? txid,
    $fixnum.Int64? timestamp,
    $core.String? unblinded,
    $core.double? price,
  }) {
    final result = create();
    if (inputs != null) result.inputs.addAll(inputs);
    if (outputs != null) result.outputs.addAll(outputs);
    if (txid != null) result.txid = txid;
    if (timestamp != null) result.timestamp = timestamp;
    if (unblinded != null) result.unblinded = unblinded;
    if (price != null) result.price = price;
    return result;
  }

  FullTransaction._();

  factory FullTransaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FullTransaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FullTransaction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..pPM<InOut>(1, _omitFieldNames ? '' : 'inputs', subBuilder: InOut.create)
    ..pPM<InOut>(2, _omitFieldNames ? '' : 'outputs', subBuilder: InOut.create)
    ..aQS(3, _omitFieldNames ? '' : 'txid')
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(5, _omitFieldNames ? '' : 'unblinded')
    ..aD(6, _omitFieldNames ? '' : 'price');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FullTransaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FullTransaction copyWith(void Function(FullTransaction) updates) =>
      super.copyWith((message) => updates(message as FullTransaction))
          as FullTransaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FullTransaction create() => FullTransaction._();
  @$core.override
  FullTransaction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FullTransaction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FullTransaction>(create);
  static FullTransaction? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<InOut> get inputs => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<InOut> get outputs => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get txid => $_getSZ(2);
  @$pb.TagNumber(3)
  set txid($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTxid() => $_has(2);
  @$pb.TagNumber(3)
  void clearTxid() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get unblinded => $_getSZ(4);
  @$pb.TagNumber(5)
  set unblinded($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnblinded() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnblinded() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get price => $_getN(5);
  @$pb.TagNumber(6)
  set price($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrice() => $_clearField(6);
}

class OwnTransaction extends $pb.GeneratedMessage {
  factory OwnTransaction({
    $core.String? txid,
    $fixnum.Int64? timestamp,
    $core.double? amount,
    $core.double? price,
  }) {
    final result = create();
    if (txid != null) result.txid = txid;
    if (timestamp != null) result.timestamp = timestamp;
    if (amount != null) result.amount = amount;
    if (price != null) result.price = price;
    return result;
  }

  OwnTransaction._();

  factory OwnTransaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OwnTransaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OwnTransaction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'txid')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aD(3, _omitFieldNames ? '' : 'amount', fieldType: $pb.PbFieldType.QD)
    ..aD(4, _omitFieldNames ? '' : 'price');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OwnTransaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OwnTransaction copyWith(void Function(OwnTransaction) updates) =>
      super.copyWith((message) => updates(message as OwnTransaction))
          as OwnTransaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OwnTransaction create() => OwnTransaction._();
  @$core.override
  OwnTransaction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OwnTransaction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OwnTransaction>(create);
  static OwnTransaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get price => $_getN(3);
  @$pb.TagNumber(4)
  set price($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrice() => $_clearField(4);
}

class BalanceOwner extends $pb.GeneratedMessage {
  factory BalanceOwner({
    Account? account,
    $core.double? amount,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (amount != null) result.amount = amount;
    return result;
  }

  BalanceOwner._();

  factory BalanceOwner.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BalanceOwner.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BalanceOwner',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQM<Account>(1, _omitFieldNames ? '' : 'account',
        subBuilder: Account.create)
    ..aD(2, _omitFieldNames ? '' : 'amount', fieldType: $pb.PbFieldType.QD);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BalanceOwner clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BalanceOwner copyWith(void Function(BalanceOwner) updates) =>
      super.copyWith((message) => updates(message as BalanceOwner))
          as BalanceOwner;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BalanceOwner create() => BalanceOwner._();
  @$core.override
  BalanceOwner createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BalanceOwner getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BalanceOwner>(create);
  static BalanceOwner? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => $_clearField(2);
}

class Serie extends $pb.GeneratedMessage {
  factory Serie({
    $fixnum.Int64? start,
    $fixnum.Int64? count,
  }) {
    final result = create();
    if (start != null) result.start = start;
    if (count != null) result.count = count;
    return result;
  }

  Serie._();

  factory Serie.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Serie.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Serie',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'start', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'count', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Serie clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Serie copyWith(void Function(Serie) updates) =>
      super.copyWith((message) => updates(message as Serie)) as Serie;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Serie create() => Serie._();
  @$core.override
  Serie createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Serie getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Serie>(create);
  static Serie? _defaultInstance;

  @$pb.TagNumber(2)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(2)
  set start($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(2)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(2)
  void clearStart() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get count => $_getI64(1);
  @$pb.TagNumber(3)
  set count($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(3)
  void clearCount() => $_clearField(3);
}

class SerieOwner extends $pb.GeneratedMessage {
  factory SerieOwner({
    $core.String? accountKey,
    $core.Iterable<Serie>? series,
  }) {
    final result = create();
    if (accountKey != null) result.accountKey = accountKey;
    if (series != null) result.series.addAll(series);
    return result;
  }

  SerieOwner._();

  factory SerieOwner.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SerieOwner.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SerieOwner',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'accountKey')
    ..pPM<Serie>(2, _omitFieldNames ? '' : 'series', subBuilder: Serie.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerieOwner clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerieOwner copyWith(void Function(SerieOwner) updates) =>
      super.copyWith((message) => updates(message as SerieOwner)) as SerieOwner;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SerieOwner create() => SerieOwner._();
  @$core.override
  SerieOwner createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SerieOwner getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SerieOwner>(create);
  static SerieOwner? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Serie> get series => $_getList(1);
}

class Req_LoginOrRegister_Org extends $pb.GeneratedMessage {
  factory Req_LoginOrRegister_Org({
    $core.String? name,
    $core.String? address,
    $core.String? city,
    $core.String? postcode,
    $core.String? country,
    $core.String? website,
    $core.String? regNumber,
    $core.List<$core.int>? regProof,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (address != null) result.address = address;
    if (city != null) result.city = city;
    if (postcode != null) result.postcode = postcode;
    if (country != null) result.country = country;
    if (website != null) result.website = website;
    if (regNumber != null) result.regNumber = regNumber;
    if (regProof != null) result.regProof = regProof;
    return result;
  }

  Req_LoginOrRegister_Org._();

  factory Req_LoginOrRegister_Org.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_LoginOrRegister_Org.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.LoginOrRegister.Org',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'name')
    ..aQS(2, _omitFieldNames ? '' : 'address')
    ..aQS(3, _omitFieldNames ? '' : 'city')
    ..aQS(4, _omitFieldNames ? '' : 'postcode')
    ..aQS(5, _omitFieldNames ? '' : 'country')
    ..aQS(6, _omitFieldNames ? '' : 'website')
    ..aQS(7, _omitFieldNames ? '' : 'regNumber')
    ..a<$core.List<$core.int>>(
        8, _omitFieldNames ? '' : 'regProof', $pb.PbFieldType.QY);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_LoginOrRegister_Org clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_LoginOrRegister_Org copyWith(
          void Function(Req_LoginOrRegister_Org) updates) =>
      super.copyWith((message) => updates(message as Req_LoginOrRegister_Org))
          as Req_LoginOrRegister_Org;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_LoginOrRegister_Org create() => Req_LoginOrRegister_Org._();
  @$core.override
  Req_LoginOrRegister_Org createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_LoginOrRegister_Org getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_LoginOrRegister_Org>(create);
  static Req_LoginOrRegister_Org? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get address => $_getSZ(1);
  @$pb.TagNumber(2)
  set address($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddress() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get city => $_getSZ(2);
  @$pb.TagNumber(3)
  set city($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCity() => $_has(2);
  @$pb.TagNumber(3)
  void clearCity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get postcode => $_getSZ(3);
  @$pb.TagNumber(4)
  set postcode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPostcode() => $_has(3);
  @$pb.TagNumber(4)
  void clearPostcode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get country => $_getSZ(4);
  @$pb.TagNumber(5)
  set country($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCountry() => $_has(4);
  @$pb.TagNumber(5)
  void clearCountry() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get website => $_getSZ(5);
  @$pb.TagNumber(6)
  set website($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWebsite() => $_has(5);
  @$pb.TagNumber(6)
  void clearWebsite() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get regNumber => $_getSZ(6);
  @$pb.TagNumber(7)
  set regNumber($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRegNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearRegNumber() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get regProof => $_getN(7);
  @$pb.TagNumber(8)
  set regProof($core.List<$core.int> value) => $_setBytes(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRegProof() => $_has(7);
  @$pb.TagNumber(8)
  void clearRegProof() => $_clearField(8);
}

class Req_LoginOrRegister extends $pb.GeneratedMessage {
  factory Req_LoginOrRegister({
    Req_LoginOrRegister_Org? org,
  }) {
    final result = create();
    if (org != null) result.org = org;
    return result;
  }

  Req_LoginOrRegister._();

  factory Req_LoginOrRegister.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_LoginOrRegister.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.LoginOrRegister',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aOM<Req_LoginOrRegister_Org>(1, _omitFieldNames ? '' : 'org',
        subBuilder: Req_LoginOrRegister_Org.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_LoginOrRegister clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_LoginOrRegister copyWith(void Function(Req_LoginOrRegister) updates) =>
      super.copyWith((message) => updates(message as Req_LoginOrRegister))
          as Req_LoginOrRegister;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_LoginOrRegister create() => Req_LoginOrRegister._();
  @$core.override
  Req_LoginOrRegister createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_LoginOrRegister getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_LoginOrRegister>(create);
  static Req_LoginOrRegister? _defaultInstance;

  @$pb.TagNumber(1)
  Req_LoginOrRegister_Org get org => $_getN(0);
  @$pb.TagNumber(1)
  set org(Req_LoginOrRegister_Org value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrg() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrg() => $_clearField(1);
  @$pb.TagNumber(1)
  Req_LoginOrRegister_Org ensureOrg() => $_ensure(0);
}

class Req_RegisterIssuer extends $pb.GeneratedMessage {
  factory Req_RegisterIssuer({
    $core.String? email,
    $core.String? name,
    $core.String? website,
    $core.String? message,
  }) {
    final result = create();
    if (email != null) result.email = email;
    if (name != null) result.name = name;
    if (website != null) result.website = website;
    if (message != null) result.message = message;
    return result;
  }

  Req_RegisterIssuer._();

  factory Req_RegisterIssuer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_RegisterIssuer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.RegisterIssuer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'email')
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..aQS(3, _omitFieldNames ? '' : 'website')
    ..aQS(4, _omitFieldNames ? '' : 'message');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_RegisterIssuer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_RegisterIssuer copyWith(void Function(Req_RegisterIssuer) updates) =>
      super.copyWith((message) => updates(message as Req_RegisterIssuer))
          as Req_RegisterIssuer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_RegisterIssuer create() => Req_RegisterIssuer._();
  @$core.override
  Req_RegisterIssuer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_RegisterIssuer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_RegisterIssuer>(create);
  static Req_RegisterIssuer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get website => $_getSZ(2);
  @$pb.TagNumber(3)
  set website($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWebsite() => $_has(2);
  @$pb.TagNumber(3)
  void clearWebsite() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => $_clearField(4);
}

class Req_Resume extends $pb.GeneratedMessage {
  factory Req_Resume({
    $core.String? token,
  }) {
    final result = create();
    if (token != null) result.token = token;
    return result;
  }

  Req_Resume._();

  factory Req_Resume.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_Resume.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.Resume',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'token');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_Resume clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_Resume copyWith(void Function(Req_Resume) updates) =>
      super.copyWith((message) => updates(message as Req_Resume)) as Req_Resume;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_Resume create() => Req_Resume._();
  @$core.override
  Req_Resume createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_Resume getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_Resume>(create);
  static Req_Resume? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

class Req_Logout extends $pb.GeneratedMessage {
  factory Req_Logout() => create();

  Req_Logout._();

  factory Req_Logout.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_Logout.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.Logout',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_Logout clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_Logout copyWith(void Function(Req_Logout) updates) =>
      super.copyWith((message) => updates(message as Req_Logout)) as Req_Logout;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_Logout create() => Req_Logout._();
  @$core.override
  Req_Logout createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_Logout getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_Logout>(create);
  static Req_Logout? _defaultInstance;
}

class Req_AddGaid extends $pb.GeneratedMessage {
  factory Req_AddGaid({
    $core.String? gaid,
    $core.String? accountKey,
  }) {
    final result = create();
    if (gaid != null) result.gaid = gaid;
    if (accountKey != null) result.accountKey = accountKey;
    return result;
  }

  Req_AddGaid._();

  factory Req_AddGaid.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_AddGaid.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.AddGaid',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'gaid')
    ..aQS(2, _omitFieldNames ? '' : 'accountKey');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_AddGaid clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_AddGaid copyWith(void Function(Req_AddGaid) updates) =>
      super.copyWith((message) => updates(message as Req_AddGaid))
          as Req_AddGaid;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_AddGaid create() => Req_AddGaid._();
  @$core.override
  Req_AddGaid createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_AddGaid getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_AddGaid>(create);
  static Req_AddGaid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gaid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gaid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGaid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGaid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccountKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountKey() => $_clearField(2);
}

class Req_LoadAssets extends $pb.GeneratedMessage {
  factory Req_LoadAssets() => create();

  Req_LoadAssets._();

  factory Req_LoadAssets.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_LoadAssets.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.LoadAssets',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_LoadAssets clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_LoadAssets copyWith(void Function(Req_LoadAssets) updates) =>
      super.copyWith((message) => updates(message as Req_LoadAssets))
          as Req_LoadAssets;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_LoadAssets create() => Req_LoadAssets._();
  @$core.override
  Req_LoadAssets createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_LoadAssets getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_LoadAssets>(create);
  static Req_LoadAssets? _defaultInstance;
}

class Req_BuyShares extends $pb.GeneratedMessage {
  factory Req_BuyShares({
    $core.double? amount,
  }) {
    final result = create();
    if (amount != null) result.amount = amount;
    return result;
  }

  Req_BuyShares._();

  factory Req_BuyShares.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_BuyShares.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.BuyShares',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'amount', fieldType: $pb.PbFieldType.QD);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_BuyShares clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_BuyShares copyWith(void Function(Req_BuyShares) updates) =>
      super.copyWith((message) => updates(message as Req_BuyShares))
          as Req_BuyShares;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_BuyShares create() => Req_BuyShares._();
  @$core.override
  Req_BuyShares createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_BuyShares getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_BuyShares>(create);
  static Req_BuyShares? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get amount => $_getN(0);
  @$pb.TagNumber(1)
  set amount($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => $_clearField(1);
}

class Req_LoadCountries extends $pb.GeneratedMessage {
  factory Req_LoadCountries() => create();

  Req_LoadCountries._();

  factory Req_LoadCountries.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_LoadCountries.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.LoadCountries',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_LoadCountries clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_LoadCountries copyWith(void Function(Req_LoadCountries) updates) =>
      super.copyWith((message) => updates(message as Req_LoadCountries))
          as Req_LoadCountries;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_LoadCountries create() => Req_LoadCountries._();
  @$core.override
  Req_LoadCountries createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_LoadCountries getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_LoadCountries>(create);
  static Req_LoadCountries? _defaultInstance;
}

class Req_LoadRegs extends $pb.GeneratedMessage {
  factory Req_LoadRegs() => create();

  Req_LoadRegs._();

  factory Req_LoadRegs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_LoadRegs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.LoadRegs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_LoadRegs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_LoadRegs copyWith(void Function(Req_LoadRegs) updates) =>
      super.copyWith((message) => updates(message as Req_LoadRegs))
          as Req_LoadRegs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_LoadRegs create() => Req_LoadRegs._();
  @$core.override
  Req_LoadRegs createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_LoadRegs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_LoadRegs>(create);
  static Req_LoadRegs? _defaultInstance;
}

class Req_LoadFile extends $pb.GeneratedMessage {
  factory Req_LoadFile({
    $core.String? accountKey,
  }) {
    final result = create();
    if (accountKey != null) result.accountKey = accountKey;
    return result;
  }

  Req_LoadFile._();

  factory Req_LoadFile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_LoadFile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.LoadFile',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'accountKey');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_LoadFile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_LoadFile copyWith(void Function(Req_LoadFile) updates) =>
      super.copyWith((message) => updates(message as Req_LoadFile))
          as Req_LoadFile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_LoadFile create() => Req_LoadFile._();
  @$core.override
  Req_LoadFile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_LoadFile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_LoadFile>(create);
  static Req_LoadFile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountKey() => $_clearField(1);
}

class Req_UpdateReg extends $pb.GeneratedMessage {
  factory Req_UpdateReg({
    $core.String? accountKey,
    $core.bool? valid,
  }) {
    final result = create();
    if (accountKey != null) result.accountKey = accountKey;
    if (valid != null) result.valid = valid;
    return result;
  }

  Req_UpdateReg._();

  factory Req_UpdateReg.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_UpdateReg.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.UpdateReg',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'accountKey')
    ..a<$core.bool>(2, _omitFieldNames ? '' : 'valid', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_UpdateReg clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_UpdateReg copyWith(void Function(Req_UpdateReg) updates) =>
      super.copyWith((message) => updates(message as Req_UpdateReg))
          as Req_UpdateReg;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_UpdateReg create() => Req_UpdateReg._();
  @$core.override
  Req_UpdateReg createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_UpdateReg getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_UpdateReg>(create);
  static Req_UpdateReg? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get valid => $_getBF(1);
  @$pb.TagNumber(2)
  set valid($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValid() => $_has(1);
  @$pb.TagNumber(2)
  void clearValid() => $_clearField(2);
}

class Req_ListAllTransactions extends $pb.GeneratedMessage {
  factory Req_ListAllTransactions({
    $core.String? assetId,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  Req_ListAllTransactions._();

  factory Req_ListAllTransactions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_ListAllTransactions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.ListAllTransactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_ListAllTransactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_ListAllTransactions copyWith(
          void Function(Req_ListAllTransactions) updates) =>
      super.copyWith((message) => updates(message as Req_ListAllTransactions))
          as Req_ListAllTransactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_ListAllTransactions create() => Req_ListAllTransactions._();
  @$core.override
  Req_ListAllTransactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_ListAllTransactions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_ListAllTransactions>(create);
  static Req_ListAllTransactions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);
}

class Req_ListOwnTransactions extends $pb.GeneratedMessage {
  factory Req_ListOwnTransactions({
    $core.String? assetId,
    $core.String? accountKey,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (accountKey != null) result.accountKey = accountKey;
    return result;
  }

  Req_ListOwnTransactions._();

  factory Req_ListOwnTransactions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_ListOwnTransactions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.ListOwnTransactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..aQS(2, _omitFieldNames ? '' : 'accountKey');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_ListOwnTransactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_ListOwnTransactions copyWith(
          void Function(Req_ListOwnTransactions) updates) =>
      super.copyWith((message) => updates(message as Req_ListOwnTransactions))
          as Req_ListOwnTransactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_ListOwnTransactions create() => Req_ListOwnTransactions._();
  @$core.override
  Req_ListOwnTransactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_ListOwnTransactions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_ListOwnTransactions>(create);
  static Req_ListOwnTransactions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccountKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountKey() => $_clearField(2);
}

class Req_ListAllBalances extends $pb.GeneratedMessage {
  factory Req_ListAllBalances({
    $core.String? assetId,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  Req_ListAllBalances._();

  factory Req_ListAllBalances.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_ListAllBalances.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.ListAllBalances',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_ListAllBalances clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_ListAllBalances copyWith(void Function(Req_ListAllBalances) updates) =>
      super.copyWith((message) => updates(message as Req_ListAllBalances))
          as Req_ListAllBalances;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_ListAllBalances create() => Req_ListAllBalances._();
  @$core.override
  Req_ListAllBalances createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_ListAllBalances getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_ListAllBalances>(create);
  static Req_ListAllBalances? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);
}

class Req_ListAllSeries extends $pb.GeneratedMessage {
  factory Req_ListAllSeries({
    $core.String? assetId,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  Req_ListAllSeries._();

  factory Req_ListAllSeries.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req_ListAllSeries.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req.ListAllSeries',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_ListAllSeries clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req_ListAllSeries copyWith(void Function(Req_ListAllSeries) updates) =>
      super.copyWith((message) => updates(message as Req_ListAllSeries))
          as Req_ListAllSeries;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_ListAllSeries create() => Req_ListAllSeries._();
  @$core.override
  Req_ListAllSeries createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req_ListAllSeries getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Req_ListAllSeries>(create);
  static Req_ListAllSeries? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);
}

enum Req_Body {
  loginOrRegister,
  resume,
  logout,
  registerIssuer,
  addGaid,
  loadAssets,
  buyShares,
  loadCountries,
  loadRegs,
  updateReg,
  loadFile,
  listAllTransactions,
  listOwnTransactions,
  listAllBalances,
  listAllSeries,
  notSet
}

class Req extends $pb.GeneratedMessage {
  factory Req({
    $fixnum.Int64? id,
    Req_LoginOrRegister? loginOrRegister,
    Req_Resume? resume,
    Req_Logout? logout,
    Req_RegisterIssuer? registerIssuer,
    Req_AddGaid? addGaid,
    Req_LoadAssets? loadAssets,
    Req_BuyShares? buyShares,
    Req_LoadCountries? loadCountries,
    Req_LoadRegs? loadRegs,
    Req_UpdateReg? updateReg,
    Req_LoadFile? loadFile,
    Req_ListAllTransactions? listAllTransactions,
    Req_ListOwnTransactions? listOwnTransactions,
    Req_ListAllBalances? listAllBalances,
    Req_ListAllSeries? listAllSeries,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (loginOrRegister != null) result.loginOrRegister = loginOrRegister;
    if (resume != null) result.resume = resume;
    if (logout != null) result.logout = logout;
    if (registerIssuer != null) result.registerIssuer = registerIssuer;
    if (addGaid != null) result.addGaid = addGaid;
    if (loadAssets != null) result.loadAssets = loadAssets;
    if (buyShares != null) result.buyShares = buyShares;
    if (loadCountries != null) result.loadCountries = loadCountries;
    if (loadRegs != null) result.loadRegs = loadRegs;
    if (updateReg != null) result.updateReg = updateReg;
    if (loadFile != null) result.loadFile = loadFile;
    if (listAllTransactions != null)
      result.listAllTransactions = listAllTransactions;
    if (listOwnTransactions != null)
      result.listOwnTransactions = listOwnTransactions;
    if (listAllBalances != null) result.listAllBalances = listAllBalances;
    if (listAllSeries != null) result.listAllSeries = listAllSeries;
    return result;
  }

  Req._();

  factory Req.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Req.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Req_Body> _Req_BodyByTag = {
    11: Req_Body.loginOrRegister,
    12: Req_Body.resume,
    13: Req_Body.logout,
    14: Req_Body.registerIssuer,
    20: Req_Body.addGaid,
    21: Req_Body.loadAssets,
    24: Req_Body.buyShares,
    25: Req_Body.loadCountries,
    26: Req_Body.loadRegs,
    27: Req_Body.updateReg,
    28: Req_Body.loadFile,
    29: Req_Body.listAllTransactions,
    30: Req_Body.listOwnTransactions,
    31: Req_Body.listAllBalances,
    32: Req_Body.listAllSeries,
    0: Req_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Req',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..oo(0, [11, 12, 13, 14, 20, 21, 24, 25, 26, 27, 28, 29, 30, 31, 32])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<Req_LoginOrRegister>(11, _omitFieldNames ? '' : 'loginOrRegister',
        subBuilder: Req_LoginOrRegister.create)
    ..aOM<Req_Resume>(12, _omitFieldNames ? '' : 'resume',
        subBuilder: Req_Resume.create)
    ..aOM<Req_Logout>(13, _omitFieldNames ? '' : 'logout',
        subBuilder: Req_Logout.create)
    ..aOM<Req_RegisterIssuer>(14, _omitFieldNames ? '' : 'registerIssuer',
        subBuilder: Req_RegisterIssuer.create)
    ..aOM<Req_AddGaid>(20, _omitFieldNames ? '' : 'addGaid',
        subBuilder: Req_AddGaid.create)
    ..aOM<Req_LoadAssets>(21, _omitFieldNames ? '' : 'loadAssets',
        subBuilder: Req_LoadAssets.create)
    ..aOM<Req_BuyShares>(24, _omitFieldNames ? '' : 'buyShares',
        subBuilder: Req_BuyShares.create)
    ..aOM<Req_LoadCountries>(25, _omitFieldNames ? '' : 'loadCountries',
        subBuilder: Req_LoadCountries.create)
    ..aOM<Req_LoadRegs>(26, _omitFieldNames ? '' : 'loadRegs',
        subBuilder: Req_LoadRegs.create)
    ..aOM<Req_UpdateReg>(27, _omitFieldNames ? '' : 'updateReg',
        subBuilder: Req_UpdateReg.create)
    ..aOM<Req_LoadFile>(28, _omitFieldNames ? '' : 'loadFile',
        subBuilder: Req_LoadFile.create)
    ..aOM<Req_ListAllTransactions>(
        29, _omitFieldNames ? '' : 'listAllTransactions',
        subBuilder: Req_ListAllTransactions.create)
    ..aOM<Req_ListOwnTransactions>(
        30, _omitFieldNames ? '' : 'listOwnTransactions',
        subBuilder: Req_ListOwnTransactions.create)
    ..aOM<Req_ListAllBalances>(31, _omitFieldNames ? '' : 'listAllBalances',
        subBuilder: Req_ListAllBalances.create)
    ..aOM<Req_ListAllSeries>(32, _omitFieldNames ? '' : 'listAllSeries',
        subBuilder: Req_ListAllSeries.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Req copyWith(void Function(Req) updates) =>
      super.copyWith((message) => updates(message as Req)) as Req;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req create() => Req._();
  @$core.override
  Req createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Req getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req>(create);
  static Req? _defaultInstance;

  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  Req_Body whichBody() => _Req_BodyByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  void clearBody() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(11)
  Req_LoginOrRegister get loginOrRegister => $_getN(1);
  @$pb.TagNumber(11)
  set loginOrRegister(Req_LoginOrRegister value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLoginOrRegister() => $_has(1);
  @$pb.TagNumber(11)
  void clearLoginOrRegister() => $_clearField(11);
  @$pb.TagNumber(11)
  Req_LoginOrRegister ensureLoginOrRegister() => $_ensure(1);

  @$pb.TagNumber(12)
  Req_Resume get resume => $_getN(2);
  @$pb.TagNumber(12)
  set resume(Req_Resume value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasResume() => $_has(2);
  @$pb.TagNumber(12)
  void clearResume() => $_clearField(12);
  @$pb.TagNumber(12)
  Req_Resume ensureResume() => $_ensure(2);

  @$pb.TagNumber(13)
  Req_Logout get logout => $_getN(3);
  @$pb.TagNumber(13)
  set logout(Req_Logout value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasLogout() => $_has(3);
  @$pb.TagNumber(13)
  void clearLogout() => $_clearField(13);
  @$pb.TagNumber(13)
  Req_Logout ensureLogout() => $_ensure(3);

  @$pb.TagNumber(14)
  Req_RegisterIssuer get registerIssuer => $_getN(4);
  @$pb.TagNumber(14)
  set registerIssuer(Req_RegisterIssuer value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasRegisterIssuer() => $_has(4);
  @$pb.TagNumber(14)
  void clearRegisterIssuer() => $_clearField(14);
  @$pb.TagNumber(14)
  Req_RegisterIssuer ensureRegisterIssuer() => $_ensure(4);

  @$pb.TagNumber(20)
  Req_AddGaid get addGaid => $_getN(5);
  @$pb.TagNumber(20)
  set addGaid(Req_AddGaid value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasAddGaid() => $_has(5);
  @$pb.TagNumber(20)
  void clearAddGaid() => $_clearField(20);
  @$pb.TagNumber(20)
  Req_AddGaid ensureAddGaid() => $_ensure(5);

  @$pb.TagNumber(21)
  Req_LoadAssets get loadAssets => $_getN(6);
  @$pb.TagNumber(21)
  set loadAssets(Req_LoadAssets value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasLoadAssets() => $_has(6);
  @$pb.TagNumber(21)
  void clearLoadAssets() => $_clearField(21);
  @$pb.TagNumber(21)
  Req_LoadAssets ensureLoadAssets() => $_ensure(6);

  @$pb.TagNumber(24)
  Req_BuyShares get buyShares => $_getN(7);
  @$pb.TagNumber(24)
  set buyShares(Req_BuyShares value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasBuyShares() => $_has(7);
  @$pb.TagNumber(24)
  void clearBuyShares() => $_clearField(24);
  @$pb.TagNumber(24)
  Req_BuyShares ensureBuyShares() => $_ensure(7);

  @$pb.TagNumber(25)
  Req_LoadCountries get loadCountries => $_getN(8);
  @$pb.TagNumber(25)
  set loadCountries(Req_LoadCountries value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasLoadCountries() => $_has(8);
  @$pb.TagNumber(25)
  void clearLoadCountries() => $_clearField(25);
  @$pb.TagNumber(25)
  Req_LoadCountries ensureLoadCountries() => $_ensure(8);

  @$pb.TagNumber(26)
  Req_LoadRegs get loadRegs => $_getN(9);
  @$pb.TagNumber(26)
  set loadRegs(Req_LoadRegs value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasLoadRegs() => $_has(9);
  @$pb.TagNumber(26)
  void clearLoadRegs() => $_clearField(26);
  @$pb.TagNumber(26)
  Req_LoadRegs ensureLoadRegs() => $_ensure(9);

  @$pb.TagNumber(27)
  Req_UpdateReg get updateReg => $_getN(10);
  @$pb.TagNumber(27)
  set updateReg(Req_UpdateReg value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasUpdateReg() => $_has(10);
  @$pb.TagNumber(27)
  void clearUpdateReg() => $_clearField(27);
  @$pb.TagNumber(27)
  Req_UpdateReg ensureUpdateReg() => $_ensure(10);

  @$pb.TagNumber(28)
  Req_LoadFile get loadFile => $_getN(11);
  @$pb.TagNumber(28)
  set loadFile(Req_LoadFile value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasLoadFile() => $_has(11);
  @$pb.TagNumber(28)
  void clearLoadFile() => $_clearField(28);
  @$pb.TagNumber(28)
  Req_LoadFile ensureLoadFile() => $_ensure(11);

  @$pb.TagNumber(29)
  Req_ListAllTransactions get listAllTransactions => $_getN(12);
  @$pb.TagNumber(29)
  set listAllTransactions(Req_ListAllTransactions value) =>
      $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasListAllTransactions() => $_has(12);
  @$pb.TagNumber(29)
  void clearListAllTransactions() => $_clearField(29);
  @$pb.TagNumber(29)
  Req_ListAllTransactions ensureListAllTransactions() => $_ensure(12);

  @$pb.TagNumber(30)
  Req_ListOwnTransactions get listOwnTransactions => $_getN(13);
  @$pb.TagNumber(30)
  set listOwnTransactions(Req_ListOwnTransactions value) =>
      $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasListOwnTransactions() => $_has(13);
  @$pb.TagNumber(30)
  void clearListOwnTransactions() => $_clearField(30);
  @$pb.TagNumber(30)
  Req_ListOwnTransactions ensureListOwnTransactions() => $_ensure(13);

  @$pb.TagNumber(31)
  Req_ListAllBalances get listAllBalances => $_getN(14);
  @$pb.TagNumber(31)
  set listAllBalances(Req_ListAllBalances value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasListAllBalances() => $_has(14);
  @$pb.TagNumber(31)
  void clearListAllBalances() => $_clearField(31);
  @$pb.TagNumber(31)
  Req_ListAllBalances ensureListAllBalances() => $_ensure(14);

  @$pb.TagNumber(32)
  Req_ListAllSeries get listAllSeries => $_getN(15);
  @$pb.TagNumber(32)
  set listAllSeries(Req_ListAllSeries value) => $_setField(32, value);
  @$pb.TagNumber(32)
  $core.bool hasListAllSeries() => $_has(15);
  @$pb.TagNumber(32)
  void clearListAllSeries() => $_clearField(32);
  @$pb.TagNumber(32)
  Req_ListAllSeries ensureListAllSeries() => $_ensure(15);
}

class Resp_LoginOrRegister extends $pb.GeneratedMessage {
  factory Resp_LoginOrRegister({
    $core.String? requestId,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  Resp_LoginOrRegister._();

  factory Resp_LoginOrRegister.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_LoginOrRegister.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.LoginOrRegister',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'requestId');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_LoginOrRegister clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_LoginOrRegister copyWith(void Function(Resp_LoginOrRegister) updates) =>
      super.copyWith((message) => updates(message as Resp_LoginOrRegister))
          as Resp_LoginOrRegister;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_LoginOrRegister create() => Resp_LoginOrRegister._();
  @$core.override
  Resp_LoginOrRegister createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_LoginOrRegister getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_LoginOrRegister>(create);
  static Resp_LoginOrRegister? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);
}

class Resp_RegisterIssuer extends $pb.GeneratedMessage {
  factory Resp_RegisterIssuer() => create();

  Resp_RegisterIssuer._();

  factory Resp_RegisterIssuer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_RegisterIssuer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.RegisterIssuer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_RegisterIssuer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_RegisterIssuer copyWith(void Function(Resp_RegisterIssuer) updates) =>
      super.copyWith((message) => updates(message as Resp_RegisterIssuer))
          as Resp_RegisterIssuer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_RegisterIssuer create() => Resp_RegisterIssuer._();
  @$core.override
  Resp_RegisterIssuer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_RegisterIssuer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_RegisterIssuer>(create);
  static Resp_RegisterIssuer? _defaultInstance;
}

class Resp_Resume extends $pb.GeneratedMessage {
  factory Resp_Resume({
    $core.Iterable<Account>? accounts,
    $core.Iterable<Asset>? managedAssets,
    $core.bool? issuer,
  }) {
    final result = create();
    if (accounts != null) result.accounts.addAll(accounts);
    if (managedAssets != null) result.managedAssets.addAll(managedAssets);
    if (issuer != null) result.issuer = issuer;
    return result;
  }

  Resp_Resume._();

  factory Resp_Resume.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_Resume.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.Resume',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..pPM<Account>(1, _omitFieldNames ? '' : 'accounts',
        subBuilder: Account.create)
    ..pPM<Asset>(2, _omitFieldNames ? '' : 'managedAssets',
        subBuilder: Asset.create)
    ..a<$core.bool>(3, _omitFieldNames ? '' : 'issuer', $pb.PbFieldType.QB);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_Resume clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_Resume copyWith(void Function(Resp_Resume) updates) =>
      super.copyWith((message) => updates(message as Resp_Resume))
          as Resp_Resume;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_Resume create() => Resp_Resume._();
  @$core.override
  Resp_Resume createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_Resume getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_Resume>(create);
  static Resp_Resume? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Account> get accounts => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<Asset> get managedAssets => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get issuer => $_getBF(2);
  @$pb.TagNumber(3)
  set issuer($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIssuer() => $_has(2);
  @$pb.TagNumber(3)
  void clearIssuer() => $_clearField(3);
}

class Resp_Logout extends $pb.GeneratedMessage {
  factory Resp_Logout() => create();

  Resp_Logout._();

  factory Resp_Logout.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_Logout.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.Logout',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_Logout clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_Logout copyWith(void Function(Resp_Logout) updates) =>
      super.copyWith((message) => updates(message as Resp_Logout))
          as Resp_Logout;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_Logout create() => Resp_Logout._();
  @$core.override
  Resp_Logout createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_Logout getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_Logout>(create);
  static Resp_Logout? _defaultInstance;
}

class Resp_AddGaid extends $pb.GeneratedMessage {
  factory Resp_AddGaid() => create();

  Resp_AddGaid._();

  factory Resp_AddGaid.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_AddGaid.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.AddGaid',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_AddGaid clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_AddGaid copyWith(void Function(Resp_AddGaid) updates) =>
      super.copyWith((message) => updates(message as Resp_AddGaid))
          as Resp_AddGaid;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_AddGaid create() => Resp_AddGaid._();
  @$core.override
  Resp_AddGaid createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_AddGaid getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_AddGaid>(create);
  static Resp_AddGaid? _defaultInstance;
}

class Resp_LoadAssets extends $pb.GeneratedMessage {
  factory Resp_LoadAssets({
    $core.Iterable<Asset>? assets,
  }) {
    final result = create();
    if (assets != null) result.assets.addAll(assets);
    return result;
  }

  Resp_LoadAssets._();

  factory Resp_LoadAssets.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_LoadAssets.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.LoadAssets',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..pPM<Asset>(1, _omitFieldNames ? '' : 'assets', subBuilder: Asset.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_LoadAssets clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_LoadAssets copyWith(void Function(Resp_LoadAssets) updates) =>
      super.copyWith((message) => updates(message as Resp_LoadAssets))
          as Resp_LoadAssets;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_LoadAssets create() => Resp_LoadAssets._();
  @$core.override
  Resp_LoadAssets createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_LoadAssets getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_LoadAssets>(create);
  static Resp_LoadAssets? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Asset> get assets => $_getList(0);
}

class Resp_BuyShares extends $pb.GeneratedMessage {
  factory Resp_BuyShares({
    $core.String? orderId,
    $core.double? amount,
    $core.double? price,
    $core.double? bitcoinAmount,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (amount != null) result.amount = amount;
    if (price != null) result.price = price;
    if (bitcoinAmount != null) result.bitcoinAmount = bitcoinAmount;
    return result;
  }

  Resp_BuyShares._();

  factory Resp_BuyShares.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_BuyShares.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.BuyShares',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..aD(2, _omitFieldNames ? '' : 'amount', fieldType: $pb.PbFieldType.QD)
    ..aD(3, _omitFieldNames ? '' : 'price', fieldType: $pb.PbFieldType.QD)
    ..aD(4, _omitFieldNames ? '' : 'bitcoinAmount',
        fieldType: $pb.PbFieldType.QD);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_BuyShares clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_BuyShares copyWith(void Function(Resp_BuyShares) updates) =>
      super.copyWith((message) => updates(message as Resp_BuyShares))
          as Resp_BuyShares;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_BuyShares create() => Resp_BuyShares._();
  @$core.override
  Resp_BuyShares createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_BuyShares getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_BuyShares>(create);
  static Resp_BuyShares? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get price => $_getN(2);
  @$pb.TagNumber(3)
  set price($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get bitcoinAmount => $_getN(3);
  @$pb.TagNumber(4)
  set bitcoinAmount($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBitcoinAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearBitcoinAmount() => $_clearField(4);
}

class Resp_LoadCountries extends $pb.GeneratedMessage {
  factory Resp_LoadCountries({
    $core.Iterable<$core.String>? list,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    return result;
  }

  Resp_LoadCountries._();

  factory Resp_LoadCountries.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_LoadCountries.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.LoadCountries',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'list')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_LoadCountries clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_LoadCountries copyWith(void Function(Resp_LoadCountries) updates) =>
      super.copyWith((message) => updates(message as Resp_LoadCountries))
          as Resp_LoadCountries;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_LoadCountries create() => Resp_LoadCountries._();
  @$core.override
  Resp_LoadCountries createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_LoadCountries getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_LoadCountries>(create);
  static Resp_LoadCountries? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get list => $_getList(0);
}

class Resp_LoadRegs extends $pb.GeneratedMessage {
  factory Resp_LoadRegs({
    $core.Iterable<Account>? list,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    return result;
  }

  Resp_LoadRegs._();

  factory Resp_LoadRegs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_LoadRegs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.LoadRegs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..pPM<Account>(1, _omitFieldNames ? '' : 'list',
        subBuilder: Account.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_LoadRegs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_LoadRegs copyWith(void Function(Resp_LoadRegs) updates) =>
      super.copyWith((message) => updates(message as Resp_LoadRegs))
          as Resp_LoadRegs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_LoadRegs create() => Resp_LoadRegs._();
  @$core.override
  Resp_LoadRegs createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_LoadRegs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_LoadRegs>(create);
  static Resp_LoadRegs? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Account> get list => $_getList(0);
}

class Resp_LoadFile extends $pb.GeneratedMessage {
  factory Resp_LoadFile({
    $core.String? mimeType,
    $core.List<$core.int>? data,
  }) {
    final result = create();
    if (mimeType != null) result.mimeType = mimeType;
    if (data != null) result.data = data;
    return result;
  }

  Resp_LoadFile._();

  factory Resp_LoadFile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_LoadFile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.LoadFile',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'mimeType')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.QY);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_LoadFile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_LoadFile copyWith(void Function(Resp_LoadFile) updates) =>
      super.copyWith((message) => updates(message as Resp_LoadFile))
          as Resp_LoadFile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_LoadFile create() => Resp_LoadFile._();
  @$core.override
  Resp_LoadFile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_LoadFile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_LoadFile>(create);
  static Resp_LoadFile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mimeType => $_getSZ(0);
  @$pb.TagNumber(1)
  set mimeType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMimeType() => $_has(0);
  @$pb.TagNumber(1)
  void clearMimeType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => $_clearField(2);
}

class Resp_UpdateReg extends $pb.GeneratedMessage {
  factory Resp_UpdateReg() => create();

  Resp_UpdateReg._();

  factory Resp_UpdateReg.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_UpdateReg.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.UpdateReg',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_UpdateReg clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_UpdateReg copyWith(void Function(Resp_UpdateReg) updates) =>
      super.copyWith((message) => updates(message as Resp_UpdateReg))
          as Resp_UpdateReg;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_UpdateReg create() => Resp_UpdateReg._();
  @$core.override
  Resp_UpdateReg createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_UpdateReg getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_UpdateReg>(create);
  static Resp_UpdateReg? _defaultInstance;
}

class Resp_ListAllTransactions extends $pb.GeneratedMessage {
  factory Resp_ListAllTransactions({
    $core.Iterable<FullTransaction>? list,
    $core.Iterable<Account>? accounts,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    if (accounts != null) result.accounts.addAll(accounts);
    return result;
  }

  Resp_ListAllTransactions._();

  factory Resp_ListAllTransactions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_ListAllTransactions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.ListAllTransactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..pPM<FullTransaction>(1, _omitFieldNames ? '' : 'list',
        subBuilder: FullTransaction.create)
    ..pPM<Account>(2, _omitFieldNames ? '' : 'accounts',
        subBuilder: Account.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_ListAllTransactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_ListAllTransactions copyWith(
          void Function(Resp_ListAllTransactions) updates) =>
      super.copyWith((message) => updates(message as Resp_ListAllTransactions))
          as Resp_ListAllTransactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_ListAllTransactions create() => Resp_ListAllTransactions._();
  @$core.override
  Resp_ListAllTransactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_ListAllTransactions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_ListAllTransactions>(create);
  static Resp_ListAllTransactions? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FullTransaction> get list => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<Account> get accounts => $_getList(1);
}

class Resp_ListOwnTransactions extends $pb.GeneratedMessage {
  factory Resp_ListOwnTransactions({
    $core.Iterable<OwnTransaction>? list,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    return result;
  }

  Resp_ListOwnTransactions._();

  factory Resp_ListOwnTransactions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_ListOwnTransactions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.ListOwnTransactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..pPM<OwnTransaction>(1, _omitFieldNames ? '' : 'list',
        subBuilder: OwnTransaction.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_ListOwnTransactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_ListOwnTransactions copyWith(
          void Function(Resp_ListOwnTransactions) updates) =>
      super.copyWith((message) => updates(message as Resp_ListOwnTransactions))
          as Resp_ListOwnTransactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_ListOwnTransactions create() => Resp_ListOwnTransactions._();
  @$core.override
  Resp_ListOwnTransactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_ListOwnTransactions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_ListOwnTransactions>(create);
  static Resp_ListOwnTransactions? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<OwnTransaction> get list => $_getList(0);
}

class Resp_ListAllBalances extends $pb.GeneratedMessage {
  factory Resp_ListAllBalances({
    $core.Iterable<BalanceOwner>? list,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    return result;
  }

  Resp_ListAllBalances._();

  factory Resp_ListAllBalances.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_ListAllBalances.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.ListAllBalances',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..pPM<BalanceOwner>(1, _omitFieldNames ? '' : 'list',
        subBuilder: BalanceOwner.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_ListAllBalances clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_ListAllBalances copyWith(void Function(Resp_ListAllBalances) updates) =>
      super.copyWith((message) => updates(message as Resp_ListAllBalances))
          as Resp_ListAllBalances;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_ListAllBalances create() => Resp_ListAllBalances._();
  @$core.override
  Resp_ListAllBalances createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_ListAllBalances getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_ListAllBalances>(create);
  static Resp_ListAllBalances? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BalanceOwner> get list => $_getList(0);
}

class Resp_ListAllSeries extends $pb.GeneratedMessage {
  factory Resp_ListAllSeries({
    $core.Iterable<SerieOwner>? list,
    $core.String? csv,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    if (csv != null) result.csv = csv;
    return result;
  }

  Resp_ListAllSeries._();

  factory Resp_ListAllSeries.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp_ListAllSeries.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp.ListAllSeries',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..pPM<SerieOwner>(1, _omitFieldNames ? '' : 'list',
        subBuilder: SerieOwner.create)
    ..aQS(2, _omitFieldNames ? '' : 'csv');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_ListAllSeries clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp_ListAllSeries copyWith(void Function(Resp_ListAllSeries) updates) =>
      super.copyWith((message) => updates(message as Resp_ListAllSeries))
          as Resp_ListAllSeries;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_ListAllSeries create() => Resp_ListAllSeries._();
  @$core.override
  Resp_ListAllSeries createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp_ListAllSeries getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Resp_ListAllSeries>(create);
  static Resp_ListAllSeries? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SerieOwner> get list => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get csv => $_getSZ(1);
  @$pb.TagNumber(2)
  set csv($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCsv() => $_has(1);
  @$pb.TagNumber(2)
  void clearCsv() => $_clearField(2);
}

enum Resp_Body {
  loginOrRegister,
  resume,
  logout,
  registerIssuer,
  addGaid,
  loadAssets,
  buyShares,
  loadCountries,
  loadRegs,
  updateReg,
  loadFile,
  listAllTransactions,
  listOwnTransactions,
  listAllBalances,
  listAllSeries,
  notSet
}

class Resp extends $pb.GeneratedMessage {
  factory Resp({
    $fixnum.Int64? id,
    Resp_LoginOrRegister? loginOrRegister,
    Resp_Resume? resume,
    Resp_Logout? logout,
    Resp_RegisterIssuer? registerIssuer,
    Resp_AddGaid? addGaid,
    Resp_LoadAssets? loadAssets,
    Resp_BuyShares? buyShares,
    Resp_LoadCountries? loadCountries,
    Resp_LoadRegs? loadRegs,
    Resp_UpdateReg? updateReg,
    Resp_LoadFile? loadFile,
    Resp_ListAllTransactions? listAllTransactions,
    Resp_ListOwnTransactions? listOwnTransactions,
    Resp_ListAllBalances? listAllBalances,
    Resp_ListAllSeries? listAllSeries,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (loginOrRegister != null) result.loginOrRegister = loginOrRegister;
    if (resume != null) result.resume = resume;
    if (logout != null) result.logout = logout;
    if (registerIssuer != null) result.registerIssuer = registerIssuer;
    if (addGaid != null) result.addGaid = addGaid;
    if (loadAssets != null) result.loadAssets = loadAssets;
    if (buyShares != null) result.buyShares = buyShares;
    if (loadCountries != null) result.loadCountries = loadCountries;
    if (loadRegs != null) result.loadRegs = loadRegs;
    if (updateReg != null) result.updateReg = updateReg;
    if (loadFile != null) result.loadFile = loadFile;
    if (listAllTransactions != null)
      result.listAllTransactions = listAllTransactions;
    if (listOwnTransactions != null)
      result.listOwnTransactions = listOwnTransactions;
    if (listAllBalances != null) result.listAllBalances = listAllBalances;
    if (listAllSeries != null) result.listAllSeries = listAllSeries;
    return result;
  }

  Resp._();

  factory Resp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Resp_Body> _Resp_BodyByTag = {
    11: Resp_Body.loginOrRegister,
    12: Resp_Body.resume,
    13: Resp_Body.logout,
    14: Resp_Body.registerIssuer,
    20: Resp_Body.addGaid,
    21: Resp_Body.loadAssets,
    24: Resp_Body.buyShares,
    25: Resp_Body.loadCountries,
    26: Resp_Body.loadRegs,
    27: Resp_Body.updateReg,
    28: Resp_Body.loadFile,
    29: Resp_Body.listAllTransactions,
    30: Resp_Body.listOwnTransactions,
    31: Resp_Body.listAllBalances,
    32: Resp_Body.listAllSeries,
    0: Resp_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..oo(0, [11, 12, 13, 14, 20, 21, 24, 25, 26, 27, 28, 29, 30, 31, 32])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<Resp_LoginOrRegister>(11, _omitFieldNames ? '' : 'loginOrRegister',
        subBuilder: Resp_LoginOrRegister.create)
    ..aOM<Resp_Resume>(12, _omitFieldNames ? '' : 'resume',
        subBuilder: Resp_Resume.create)
    ..aOM<Resp_Logout>(13, _omitFieldNames ? '' : 'logout',
        subBuilder: Resp_Logout.create)
    ..aOM<Resp_RegisterIssuer>(14, _omitFieldNames ? '' : 'registerIssuer',
        subBuilder: Resp_RegisterIssuer.create)
    ..aOM<Resp_AddGaid>(20, _omitFieldNames ? '' : 'addGaid',
        subBuilder: Resp_AddGaid.create)
    ..aOM<Resp_LoadAssets>(21, _omitFieldNames ? '' : 'loadAssets',
        subBuilder: Resp_LoadAssets.create)
    ..aOM<Resp_BuyShares>(24, _omitFieldNames ? '' : 'buyShares',
        subBuilder: Resp_BuyShares.create)
    ..aOM<Resp_LoadCountries>(25, _omitFieldNames ? '' : 'loadCountries',
        subBuilder: Resp_LoadCountries.create)
    ..aOM<Resp_LoadRegs>(26, _omitFieldNames ? '' : 'loadRegs',
        subBuilder: Resp_LoadRegs.create)
    ..aOM<Resp_UpdateReg>(27, _omitFieldNames ? '' : 'updateReg',
        subBuilder: Resp_UpdateReg.create)
    ..aOM<Resp_LoadFile>(28, _omitFieldNames ? '' : 'loadFile',
        subBuilder: Resp_LoadFile.create)
    ..aOM<Resp_ListAllTransactions>(
        29, _omitFieldNames ? '' : 'listAllTransactions',
        subBuilder: Resp_ListAllTransactions.create)
    ..aOM<Resp_ListOwnTransactions>(
        30, _omitFieldNames ? '' : 'listOwnTransactions',
        subBuilder: Resp_ListOwnTransactions.create)
    ..aOM<Resp_ListAllBalances>(31, _omitFieldNames ? '' : 'listAllBalances',
        subBuilder: Resp_ListAllBalances.create)
    ..aOM<Resp_ListAllSeries>(32, _omitFieldNames ? '' : 'listAllSeries',
        subBuilder: Resp_ListAllSeries.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resp copyWith(void Function(Resp) updates) =>
      super.copyWith((message) => updates(message as Resp)) as Resp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp create() => Resp._();
  @$core.override
  Resp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp>(create);
  static Resp? _defaultInstance;

  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  Resp_Body whichBody() => _Resp_BodyByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  void clearBody() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(11)
  Resp_LoginOrRegister get loginOrRegister => $_getN(1);
  @$pb.TagNumber(11)
  set loginOrRegister(Resp_LoginOrRegister value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLoginOrRegister() => $_has(1);
  @$pb.TagNumber(11)
  void clearLoginOrRegister() => $_clearField(11);
  @$pb.TagNumber(11)
  Resp_LoginOrRegister ensureLoginOrRegister() => $_ensure(1);

  @$pb.TagNumber(12)
  Resp_Resume get resume => $_getN(2);
  @$pb.TagNumber(12)
  set resume(Resp_Resume value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasResume() => $_has(2);
  @$pb.TagNumber(12)
  void clearResume() => $_clearField(12);
  @$pb.TagNumber(12)
  Resp_Resume ensureResume() => $_ensure(2);

  @$pb.TagNumber(13)
  Resp_Logout get logout => $_getN(3);
  @$pb.TagNumber(13)
  set logout(Resp_Logout value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasLogout() => $_has(3);
  @$pb.TagNumber(13)
  void clearLogout() => $_clearField(13);
  @$pb.TagNumber(13)
  Resp_Logout ensureLogout() => $_ensure(3);

  @$pb.TagNumber(14)
  Resp_RegisterIssuer get registerIssuer => $_getN(4);
  @$pb.TagNumber(14)
  set registerIssuer(Resp_RegisterIssuer value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasRegisterIssuer() => $_has(4);
  @$pb.TagNumber(14)
  void clearRegisterIssuer() => $_clearField(14);
  @$pb.TagNumber(14)
  Resp_RegisterIssuer ensureRegisterIssuer() => $_ensure(4);

  @$pb.TagNumber(20)
  Resp_AddGaid get addGaid => $_getN(5);
  @$pb.TagNumber(20)
  set addGaid(Resp_AddGaid value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasAddGaid() => $_has(5);
  @$pb.TagNumber(20)
  void clearAddGaid() => $_clearField(20);
  @$pb.TagNumber(20)
  Resp_AddGaid ensureAddGaid() => $_ensure(5);

  @$pb.TagNumber(21)
  Resp_LoadAssets get loadAssets => $_getN(6);
  @$pb.TagNumber(21)
  set loadAssets(Resp_LoadAssets value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasLoadAssets() => $_has(6);
  @$pb.TagNumber(21)
  void clearLoadAssets() => $_clearField(21);
  @$pb.TagNumber(21)
  Resp_LoadAssets ensureLoadAssets() => $_ensure(6);

  @$pb.TagNumber(24)
  Resp_BuyShares get buyShares => $_getN(7);
  @$pb.TagNumber(24)
  set buyShares(Resp_BuyShares value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasBuyShares() => $_has(7);
  @$pb.TagNumber(24)
  void clearBuyShares() => $_clearField(24);
  @$pb.TagNumber(24)
  Resp_BuyShares ensureBuyShares() => $_ensure(7);

  @$pb.TagNumber(25)
  Resp_LoadCountries get loadCountries => $_getN(8);
  @$pb.TagNumber(25)
  set loadCountries(Resp_LoadCountries value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasLoadCountries() => $_has(8);
  @$pb.TagNumber(25)
  void clearLoadCountries() => $_clearField(25);
  @$pb.TagNumber(25)
  Resp_LoadCountries ensureLoadCountries() => $_ensure(8);

  @$pb.TagNumber(26)
  Resp_LoadRegs get loadRegs => $_getN(9);
  @$pb.TagNumber(26)
  set loadRegs(Resp_LoadRegs value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasLoadRegs() => $_has(9);
  @$pb.TagNumber(26)
  void clearLoadRegs() => $_clearField(26);
  @$pb.TagNumber(26)
  Resp_LoadRegs ensureLoadRegs() => $_ensure(9);

  @$pb.TagNumber(27)
  Resp_UpdateReg get updateReg => $_getN(10);
  @$pb.TagNumber(27)
  set updateReg(Resp_UpdateReg value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasUpdateReg() => $_has(10);
  @$pb.TagNumber(27)
  void clearUpdateReg() => $_clearField(27);
  @$pb.TagNumber(27)
  Resp_UpdateReg ensureUpdateReg() => $_ensure(10);

  @$pb.TagNumber(28)
  Resp_LoadFile get loadFile => $_getN(11);
  @$pb.TagNumber(28)
  set loadFile(Resp_LoadFile value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasLoadFile() => $_has(11);
  @$pb.TagNumber(28)
  void clearLoadFile() => $_clearField(28);
  @$pb.TagNumber(28)
  Resp_LoadFile ensureLoadFile() => $_ensure(11);

  @$pb.TagNumber(29)
  Resp_ListAllTransactions get listAllTransactions => $_getN(12);
  @$pb.TagNumber(29)
  set listAllTransactions(Resp_ListAllTransactions value) =>
      $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasListAllTransactions() => $_has(12);
  @$pb.TagNumber(29)
  void clearListAllTransactions() => $_clearField(29);
  @$pb.TagNumber(29)
  Resp_ListAllTransactions ensureListAllTransactions() => $_ensure(12);

  @$pb.TagNumber(30)
  Resp_ListOwnTransactions get listOwnTransactions => $_getN(13);
  @$pb.TagNumber(30)
  set listOwnTransactions(Resp_ListOwnTransactions value) =>
      $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasListOwnTransactions() => $_has(13);
  @$pb.TagNumber(30)
  void clearListOwnTransactions() => $_clearField(30);
  @$pb.TagNumber(30)
  Resp_ListOwnTransactions ensureListOwnTransactions() => $_ensure(13);

  @$pb.TagNumber(31)
  Resp_ListAllBalances get listAllBalances => $_getN(14);
  @$pb.TagNumber(31)
  set listAllBalances(Resp_ListAllBalances value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasListAllBalances() => $_has(14);
  @$pb.TagNumber(31)
  void clearListAllBalances() => $_clearField(31);
  @$pb.TagNumber(31)
  Resp_ListAllBalances ensureListAllBalances() => $_ensure(14);

  @$pb.TagNumber(32)
  Resp_ListAllSeries get listAllSeries => $_getN(15);
  @$pb.TagNumber(32)
  set listAllSeries(Resp_ListAllSeries value) => $_setField(32, value);
  @$pb.TagNumber(32)
  $core.bool hasListAllSeries() => $_has(15);
  @$pb.TagNumber(32)
  void clearListAllSeries() => $_clearField(32);
  @$pb.TagNumber(32)
  Resp_ListAllSeries ensureListAllSeries() => $_ensure(15);
}

class Notif_LoginOrRegisterFailed extends $pb.GeneratedMessage {
  factory Notif_LoginOrRegisterFailed({
    $core.String? text,
  }) {
    final result = create();
    if (text != null) result.text = text;
    return result;
  }

  Notif_LoginOrRegisterFailed._();

  factory Notif_LoginOrRegisterFailed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notif_LoginOrRegisterFailed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notif.LoginOrRegisterFailed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'text');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_LoginOrRegisterFailed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_LoginOrRegisterFailed copyWith(
          void Function(Notif_LoginOrRegisterFailed) updates) =>
      super.copyWith(
              (message) => updates(message as Notif_LoginOrRegisterFailed))
          as Notif_LoginOrRegisterFailed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_LoginOrRegisterFailed create() =>
      Notif_LoginOrRegisterFailed._();
  @$core.override
  Notif_LoginOrRegisterFailed createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notif_LoginOrRegisterFailed getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notif_LoginOrRegisterFailed>(create);
  static Notif_LoginOrRegisterFailed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);
}

class Notif_LoginOrRegisterSucceed extends $pb.GeneratedMessage {
  factory Notif_LoginOrRegisterSucceed({
    $core.String? token,
  }) {
    final result = create();
    if (token != null) result.token = token;
    return result;
  }

  Notif_LoginOrRegisterSucceed._();

  factory Notif_LoginOrRegisterSucceed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notif_LoginOrRegisterSucceed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notif.LoginOrRegisterSucceed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'token');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_LoginOrRegisterSucceed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_LoginOrRegisterSucceed copyWith(
          void Function(Notif_LoginOrRegisterSucceed) updates) =>
      super.copyWith(
              (message) => updates(message as Notif_LoginOrRegisterSucceed))
          as Notif_LoginOrRegisterSucceed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_LoginOrRegisterSucceed create() =>
      Notif_LoginOrRegisterSucceed._();
  @$core.override
  Notif_LoginOrRegisterSucceed createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notif_LoginOrRegisterSucceed getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notif_LoginOrRegisterSucceed>(create);
  static Notif_LoginOrRegisterSucceed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

class Notif_FreeShares extends $pb.GeneratedMessage {
  factory Notif_FreeShares({
    Shares? freeShares,
    $core.String? name,
    $fixnum.Int64? amount,
  }) {
    final result = create();
    if (freeShares != null) result.freeShares = freeShares;
    if (name != null) result.name = name;
    if (amount != null) result.amount = amount;
    return result;
  }

  Notif_FreeShares._();

  factory Notif_FreeShares.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notif_FreeShares.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notif.FreeShares',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQM<Shares>(1, _omitFieldNames ? '' : 'freeShares',
        subBuilder: Shares.create)
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.Q6,
        defaultOrMaker: $fixnum.Int64.ZERO);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_FreeShares clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_FreeShares copyWith(void Function(Notif_FreeShares) updates) =>
      super.copyWith((message) => updates(message as Notif_FreeShares))
          as Notif_FreeShares;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_FreeShares create() => Notif_FreeShares._();
  @$core.override
  Notif_FreeShares createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notif_FreeShares getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notif_FreeShares>(create);
  static Notif_FreeShares? _defaultInstance;

  @$pb.TagNumber(1)
  Shares get freeShares => $_getN(0);
  @$pb.TagNumber(1)
  set freeShares(Shares value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFreeShares() => $_has(0);
  @$pb.TagNumber(1)
  void clearFreeShares() => $_clearField(1);
  @$pb.TagNumber(1)
  Shares ensureFreeShares() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get amount => $_getI64(2);
  @$pb.TagNumber(3)
  set amount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);
}

class Notif_SoldShares extends $pb.GeneratedMessage {
  factory Notif_SoldShares({
    Shares? soldShares,
  }) {
    final result = create();
    if (soldShares != null) result.soldShares = soldShares;
    return result;
  }

  Notif_SoldShares._();

  factory Notif_SoldShares.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notif_SoldShares.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notif.SoldShares',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQM<Shares>(1, _omitFieldNames ? '' : 'soldShares',
        subBuilder: Shares.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_SoldShares clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_SoldShares copyWith(void Function(Notif_SoldShares) updates) =>
      super.copyWith((message) => updates(message as Notif_SoldShares))
          as Notif_SoldShares;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_SoldShares create() => Notif_SoldShares._();
  @$core.override
  Notif_SoldShares createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notif_SoldShares getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notif_SoldShares>(create);
  static Notif_SoldShares? _defaultInstance;

  @$pb.TagNumber(1)
  Shares get soldShares => $_getN(0);
  @$pb.TagNumber(1)
  set soldShares(Shares value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSoldShares() => $_has(0);
  @$pb.TagNumber(1)
  void clearSoldShares() => $_clearField(1);
  @$pb.TagNumber(1)
  Shares ensureSoldShares() => $_ensure(0);
}

class Notif_UserShares extends $pb.GeneratedMessage {
  factory Notif_UserShares({
    Shares? boughtShares,
  }) {
    final result = create();
    if (boughtShares != null) result.boughtShares = boughtShares;
    return result;
  }

  Notif_UserShares._();

  factory Notif_UserShares.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notif_UserShares.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notif.UserShares',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQM<Shares>(1, _omitFieldNames ? '' : 'boughtShares',
        subBuilder: Shares.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_UserShares clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_UserShares copyWith(void Function(Notif_UserShares) updates) =>
      super.copyWith((message) => updates(message as Notif_UserShares))
          as Notif_UserShares;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_UserShares create() => Notif_UserShares._();
  @$core.override
  Notif_UserShares createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notif_UserShares getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notif_UserShares>(create);
  static Notif_UserShares? _defaultInstance;

  @$pb.TagNumber(1)
  Shares get boughtShares => $_getN(0);
  @$pb.TagNumber(1)
  set boughtShares(Shares value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBoughtShares() => $_has(0);
  @$pb.TagNumber(1)
  void clearBoughtShares() => $_clearField(1);
  @$pb.TagNumber(1)
  Shares ensureBoughtShares() => $_ensure(0);
}

class Notif_BuyShares extends $pb.GeneratedMessage {
  factory Notif_BuyShares({
    $core.String? orderId,
    $core.double? amount,
    $core.double? price,
    $core.double? bitcoinAmount,
    $core.String? txid,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (amount != null) result.amount = amount;
    if (price != null) result.price = price;
    if (bitcoinAmount != null) result.bitcoinAmount = bitcoinAmount;
    if (txid != null) result.txid = txid;
    return result;
  }

  Notif_BuyShares._();

  factory Notif_BuyShares.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notif_BuyShares.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notif.BuyShares',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..aD(2, _omitFieldNames ? '' : 'amount', fieldType: $pb.PbFieldType.QD)
    ..aD(3, _omitFieldNames ? '' : 'price', fieldType: $pb.PbFieldType.QD)
    ..aD(4, _omitFieldNames ? '' : 'bitcoinAmount',
        fieldType: $pb.PbFieldType.QD)
    ..aOS(5, _omitFieldNames ? '' : 'txid');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_BuyShares clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_BuyShares copyWith(void Function(Notif_BuyShares) updates) =>
      super.copyWith((message) => updates(message as Notif_BuyShares))
          as Notif_BuyShares;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_BuyShares create() => Notif_BuyShares._();
  @$core.override
  Notif_BuyShares createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notif_BuyShares getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notif_BuyShares>(create);
  static Notif_BuyShares? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get price => $_getN(2);
  @$pb.TagNumber(3)
  set price($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get bitcoinAmount => $_getN(3);
  @$pb.TagNumber(4)
  set bitcoinAmount($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBitcoinAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearBitcoinAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get txid => $_getSZ(4);
  @$pb.TagNumber(5)
  set txid($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTxid() => $_has(4);
  @$pb.TagNumber(5)
  void clearTxid() => $_clearField(5);
}

class Notif_UpdatePrices extends $pb.GeneratedMessage {
  factory Notif_UpdatePrices({
    $core.double? bitcoinUsdPrice,
  }) {
    final result = create();
    if (bitcoinUsdPrice != null) result.bitcoinUsdPrice = bitcoinUsdPrice;
    return result;
  }

  Notif_UpdatePrices._();

  factory Notif_UpdatePrices.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notif_UpdatePrices.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notif.UpdatePrices',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'bitcoinUsdPrice')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_UpdatePrices clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_UpdatePrices copyWith(void Function(Notif_UpdatePrices) updates) =>
      super.copyWith((message) => updates(message as Notif_UpdatePrices))
          as Notif_UpdatePrices;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_UpdatePrices create() => Notif_UpdatePrices._();
  @$core.override
  Notif_UpdatePrices createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notif_UpdatePrices getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notif_UpdatePrices>(create);
  static Notif_UpdatePrices? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get bitcoinUsdPrice => $_getN(0);
  @$pb.TagNumber(1)
  set bitcoinUsdPrice($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBitcoinUsdPrice() => $_has(0);
  @$pb.TagNumber(1)
  void clearBitcoinUsdPrice() => $_clearField(1);
}

class Notif_UpdateMarketData_Data extends $pb.GeneratedMessage {
  factory Notif_UpdateMarketData_Data({
    $core.String? assetId,
    $core.double? lastPrice,
    $core.double? volume30d,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (lastPrice != null) result.lastPrice = lastPrice;
    if (volume30d != null) result.volume30d = volume30d;
    return result;
  }

  Notif_UpdateMarketData_Data._();

  factory Notif_UpdateMarketData_Data.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notif_UpdateMarketData_Data.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notif.UpdateMarketData.Data',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..aD(2, _omitFieldNames ? '' : 'lastPrice')
    ..aD(3, _omitFieldNames ? '' : 'volume30d', protoName: 'volume_30d');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_UpdateMarketData_Data clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_UpdateMarketData_Data copyWith(
          void Function(Notif_UpdateMarketData_Data) updates) =>
      super.copyWith(
              (message) => updates(message as Notif_UpdateMarketData_Data))
          as Notif_UpdateMarketData_Data;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_UpdateMarketData_Data create() =>
      Notif_UpdateMarketData_Data._();
  @$core.override
  Notif_UpdateMarketData_Data createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notif_UpdateMarketData_Data getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notif_UpdateMarketData_Data>(create);
  static Notif_UpdateMarketData_Data? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get lastPrice => $_getN(1);
  @$pb.TagNumber(2)
  set lastPrice($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastPrice() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get volume30d => $_getN(2);
  @$pb.TagNumber(3)
  set volume30d($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVolume30d() => $_has(2);
  @$pb.TagNumber(3)
  void clearVolume30d() => $_clearField(3);
}

class Notif_UpdateMarketData extends $pb.GeneratedMessage {
  factory Notif_UpdateMarketData({
    $core.Iterable<Notif_UpdateMarketData_Data>? data,
  }) {
    final result = create();
    if (data != null) result.data.addAll(data);
    return result;
  }

  Notif_UpdateMarketData._();

  factory Notif_UpdateMarketData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notif_UpdateMarketData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notif.UpdateMarketData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..pPM<Notif_UpdateMarketData_Data>(1, _omitFieldNames ? '' : 'data',
        subBuilder: Notif_UpdateMarketData_Data.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_UpdateMarketData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_UpdateMarketData copyWith(
          void Function(Notif_UpdateMarketData) updates) =>
      super.copyWith((message) => updates(message as Notif_UpdateMarketData))
          as Notif_UpdateMarketData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_UpdateMarketData create() => Notif_UpdateMarketData._();
  @$core.override
  Notif_UpdateMarketData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notif_UpdateMarketData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notif_UpdateMarketData>(create);
  static Notif_UpdateMarketData? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Notif_UpdateMarketData_Data> get data => $_getList(0);
}

class Notif_UpdateBalances extends $pb.GeneratedMessage {
  factory Notif_UpdateBalances({
    $core.String? accountKey,
    $core.Iterable<Balance>? balances,
  }) {
    final result = create();
    if (accountKey != null) result.accountKey = accountKey;
    if (balances != null) result.balances.addAll(balances);
    return result;
  }

  Notif_UpdateBalances._();

  factory Notif_UpdateBalances.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notif_UpdateBalances.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notif.UpdateBalances',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'accountKey')
    ..pPM<Balance>(2, _omitFieldNames ? '' : 'balances',
        subBuilder: Balance.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_UpdateBalances clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif_UpdateBalances copyWith(void Function(Notif_UpdateBalances) updates) =>
      super.copyWith((message) => updates(message as Notif_UpdateBalances))
          as Notif_UpdateBalances;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_UpdateBalances create() => Notif_UpdateBalances._();
  @$core.override
  Notif_UpdateBalances createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notif_UpdateBalances getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notif_UpdateBalances>(create);
  static Notif_UpdateBalances? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Balance> get balances => $_getList(1);
}

enum Notif_Body {
  loginOrRegisterFailed,
  loginOrRegisterSucceed,
  freeShares,
  buyShares,
  soldShares,
  userShares,
  updatePrices,
  updateMarketData,
  updateBalances,
  notSet
}

class Notif extends $pb.GeneratedMessage {
  factory Notif({
    Notif_LoginOrRegisterFailed? loginOrRegisterFailed,
    Notif_LoginOrRegisterSucceed? loginOrRegisterSucceed,
    Notif_FreeShares? freeShares,
    Notif_BuyShares? buyShares,
    Notif_SoldShares? soldShares,
    Notif_UserShares? userShares,
    Notif_UpdatePrices? updatePrices,
    Notif_UpdateMarketData? updateMarketData,
    Notif_UpdateBalances? updateBalances,
  }) {
    final result = create();
    if (loginOrRegisterFailed != null)
      result.loginOrRegisterFailed = loginOrRegisterFailed;
    if (loginOrRegisterSucceed != null)
      result.loginOrRegisterSucceed = loginOrRegisterSucceed;
    if (freeShares != null) result.freeShares = freeShares;
    if (buyShares != null) result.buyShares = buyShares;
    if (soldShares != null) result.soldShares = soldShares;
    if (userShares != null) result.userShares = userShares;
    if (updatePrices != null) result.updatePrices = updatePrices;
    if (updateMarketData != null) result.updateMarketData = updateMarketData;
    if (updateBalances != null) result.updateBalances = updateBalances;
    return result;
  }

  Notif._();

  factory Notif.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notif.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Notif_Body> _Notif_BodyByTag = {
    3: Notif_Body.loginOrRegisterFailed,
    4: Notif_Body.loginOrRegisterSucceed,
    5: Notif_Body.freeShares,
    6: Notif_Body.buyShares,
    7: Notif_Body.soldShares,
    8: Notif_Body.userShares,
    9: Notif_Body.updatePrices,
    10: Notif_Body.updateMarketData,
    12: Notif_Body.updateBalances,
    0: Notif_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notif',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6, 7, 8, 9, 10, 12])
    ..aOM<Notif_LoginOrRegisterFailed>(
        3, _omitFieldNames ? '' : 'loginOrRegisterFailed',
        subBuilder: Notif_LoginOrRegisterFailed.create)
    ..aOM<Notif_LoginOrRegisterSucceed>(
        4, _omitFieldNames ? '' : 'loginOrRegisterSucceed',
        subBuilder: Notif_LoginOrRegisterSucceed.create)
    ..aOM<Notif_FreeShares>(5, _omitFieldNames ? '' : 'freeShares',
        subBuilder: Notif_FreeShares.create)
    ..aOM<Notif_BuyShares>(6, _omitFieldNames ? '' : 'buyShares',
        subBuilder: Notif_BuyShares.create)
    ..aOM<Notif_SoldShares>(7, _omitFieldNames ? '' : 'soldShares',
        subBuilder: Notif_SoldShares.create)
    ..aOM<Notif_UserShares>(8, _omitFieldNames ? '' : 'userShares',
        subBuilder: Notif_UserShares.create)
    ..aOM<Notif_UpdatePrices>(9, _omitFieldNames ? '' : 'updatePrices',
        subBuilder: Notif_UpdatePrices.create)
    ..aOM<Notif_UpdateMarketData>(10, _omitFieldNames ? '' : 'updateMarketData',
        subBuilder: Notif_UpdateMarketData.create)
    ..aOM<Notif_UpdateBalances>(12, _omitFieldNames ? '' : 'updateBalances',
        subBuilder: Notif_UpdateBalances.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notif copyWith(void Function(Notif) updates) =>
      super.copyWith((message) => updates(message as Notif)) as Notif;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif create() => Notif._();
  @$core.override
  Notif createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notif getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif>(create);
  static Notif? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(12)
  Notif_Body whichBody() => _Notif_BodyByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(12)
  void clearBody() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(3)
  Notif_LoginOrRegisterFailed get loginOrRegisterFailed => $_getN(0);
  @$pb.TagNumber(3)
  set loginOrRegisterFailed(Notif_LoginOrRegisterFailed value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLoginOrRegisterFailed() => $_has(0);
  @$pb.TagNumber(3)
  void clearLoginOrRegisterFailed() => $_clearField(3);
  @$pb.TagNumber(3)
  Notif_LoginOrRegisterFailed ensureLoginOrRegisterFailed() => $_ensure(0);

  @$pb.TagNumber(4)
  Notif_LoginOrRegisterSucceed get loginOrRegisterSucceed => $_getN(1);
  @$pb.TagNumber(4)
  set loginOrRegisterSucceed(Notif_LoginOrRegisterSucceed value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLoginOrRegisterSucceed() => $_has(1);
  @$pb.TagNumber(4)
  void clearLoginOrRegisterSucceed() => $_clearField(4);
  @$pb.TagNumber(4)
  Notif_LoginOrRegisterSucceed ensureLoginOrRegisterSucceed() => $_ensure(1);

  @$pb.TagNumber(5)
  Notif_FreeShares get freeShares => $_getN(2);
  @$pb.TagNumber(5)
  set freeShares(Notif_FreeShares value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFreeShares() => $_has(2);
  @$pb.TagNumber(5)
  void clearFreeShares() => $_clearField(5);
  @$pb.TagNumber(5)
  Notif_FreeShares ensureFreeShares() => $_ensure(2);

  @$pb.TagNumber(6)
  Notif_BuyShares get buyShares => $_getN(3);
  @$pb.TagNumber(6)
  set buyShares(Notif_BuyShares value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasBuyShares() => $_has(3);
  @$pb.TagNumber(6)
  void clearBuyShares() => $_clearField(6);
  @$pb.TagNumber(6)
  Notif_BuyShares ensureBuyShares() => $_ensure(3);

  @$pb.TagNumber(7)
  Notif_SoldShares get soldShares => $_getN(4);
  @$pb.TagNumber(7)
  set soldShares(Notif_SoldShares value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSoldShares() => $_has(4);
  @$pb.TagNumber(7)
  void clearSoldShares() => $_clearField(7);
  @$pb.TagNumber(7)
  Notif_SoldShares ensureSoldShares() => $_ensure(4);

  @$pb.TagNumber(8)
  Notif_UserShares get userShares => $_getN(5);
  @$pb.TagNumber(8)
  set userShares(Notif_UserShares value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasUserShares() => $_has(5);
  @$pb.TagNumber(8)
  void clearUserShares() => $_clearField(8);
  @$pb.TagNumber(8)
  Notif_UserShares ensureUserShares() => $_ensure(5);

  @$pb.TagNumber(9)
  Notif_UpdatePrices get updatePrices => $_getN(6);
  @$pb.TagNumber(9)
  set updatePrices(Notif_UpdatePrices value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatePrices() => $_has(6);
  @$pb.TagNumber(9)
  void clearUpdatePrices() => $_clearField(9);
  @$pb.TagNumber(9)
  Notif_UpdatePrices ensureUpdatePrices() => $_ensure(6);

  @$pb.TagNumber(10)
  Notif_UpdateMarketData get updateMarketData => $_getN(7);
  @$pb.TagNumber(10)
  set updateMarketData(Notif_UpdateMarketData value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUpdateMarketData() => $_has(7);
  @$pb.TagNumber(10)
  void clearUpdateMarketData() => $_clearField(10);
  @$pb.TagNumber(10)
  Notif_UpdateMarketData ensureUpdateMarketData() => $_ensure(7);

  @$pb.TagNumber(12)
  Notif_UpdateBalances get updateBalances => $_getN(8);
  @$pb.TagNumber(12)
  set updateBalances(Notif_UpdateBalances value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasUpdateBalances() => $_has(8);
  @$pb.TagNumber(12)
  void clearUpdateBalances() => $_clearField(12);
  @$pb.TagNumber(12)
  Notif_UpdateBalances ensureUpdateBalances() => $_ensure(8);
}

class Err extends $pb.GeneratedMessage {
  factory Err({
    $fixnum.Int64? id,
    $core.String? text,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (text != null) result.text = text;
    return result;
  }

  Err._();

  factory Err.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Err.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Err',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aQS(2, _omitFieldNames ? '' : 'text');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Err clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Err copyWith(void Function(Err) updates) =>
      super.copyWith((message) => updates(message as Err)) as Err;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Err create() => Err._();
  @$core.override
  Err createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Err getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Err>(create);
  static Err? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);
}

enum Res_Body { resp, notif, error, notSet }

class Res extends $pb.GeneratedMessage {
  factory Res({
    Resp? resp,
    Notif? notif,
    Err? error,
  }) {
    final result = create();
    if (resp != null) result.resp = resp;
    if (notif != null) result.notif = notif;
    if (error != null) result.error = error;
    return result;
  }

  Res._();

  factory Res.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Res.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Res_Body> _Res_BodyByTag = {
    1: Res_Body.resp,
    2: Res_Body.notif,
    3: Res_Body.error,
    0: Res_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Res',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<Resp>(1, _omitFieldNames ? '' : 'resp', subBuilder: Resp.create)
    ..aOM<Notif>(2, _omitFieldNames ? '' : 'notif', subBuilder: Notif.create)
    ..aOM<Err>(3, _omitFieldNames ? '' : 'error', subBuilder: Err.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Res clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Res copyWith(void Function(Res) updates) =>
      super.copyWith((message) => updates(message as Res)) as Res;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Res create() => Res._();
  @$core.override
  Res createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Res getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Res>(create);
  static Res? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  Res_Body whichBody() => _Res_BodyByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearBody() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Resp get resp => $_getN(0);
  @$pb.TagNumber(1)
  set resp(Resp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResp() => $_has(0);
  @$pb.TagNumber(1)
  void clearResp() => $_clearField(1);
  @$pb.TagNumber(1)
  Resp ensureResp() => $_ensure(0);

  @$pb.TagNumber(2)
  Notif get notif => $_getN(1);
  @$pb.TagNumber(2)
  set notif(Notif value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNotif() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotif() => $_clearField(2);
  @$pb.TagNumber(2)
  Notif ensureNotif() => $_ensure(1);

  @$pb.TagNumber(3)
  Err get error => $_getN(2);
  @$pb.TagNumber(3)
  set error(Err value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
  @$pb.TagNumber(3)
  Err ensureError() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
