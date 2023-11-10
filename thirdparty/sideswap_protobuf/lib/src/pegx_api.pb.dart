//
//  Generated code. Do not modify.
//  source: pegx_api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'pegx_api.pbenum.dart';

export 'pegx_api.pbenum.dart';

class AccountKey extends $pb.GeneratedMessage {
  factory AccountKey({
    $core.String? accountKey,
    $core.String? name,
  }) {
    final $result = create();
    if (accountKey != null) {
      $result.accountKey = accountKey;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  AccountKey._() : super();
  factory AccountKey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AccountKey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountKey', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'accountKey')
    ..aQS(2, _omitFieldNames ? '' : 'name')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AccountKey clone() => AccountKey()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AccountKey copyWith(void Function(AccountKey) updates) => super.copyWith((message) => updates(message as AccountKey)) as AccountKey;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountKey create() => AccountKey._();
  AccountKey createEmptyInstance() => create();
  static $pb.PbList<AccountKey> createRepeated() => $pb.PbList<AccountKey>();
  @$core.pragma('dart2js:noInline')
  static AccountKey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountKey>(create);
  static AccountKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccountKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

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
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (address != null) {
      $result.address = address;
    }
    if (city != null) {
      $result.city = city;
    }
    if (postcode != null) {
      $result.postcode = postcode;
    }
    if (country != null) {
      $result.country = country;
    }
    if (website != null) {
      $result.website = website;
    }
    if (regNumber != null) {
      $result.regNumber = regNumber;
    }
    if (ownerEmail != null) {
      $result.ownerEmail = ownerEmail;
    }
    return $result;
  }
  AccountDetails_OrgDetails._() : super();
  factory AccountDetails_OrgDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AccountDetails_OrgDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountDetails.OrgDetails', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'name')
    ..aQS(2, _omitFieldNames ? '' : 'address')
    ..aQS(3, _omitFieldNames ? '' : 'city')
    ..aQS(4, _omitFieldNames ? '' : 'postcode')
    ..aQS(5, _omitFieldNames ? '' : 'country')
    ..aQS(6, _omitFieldNames ? '' : 'website')
    ..aQS(7, _omitFieldNames ? '' : 'regNumber')
    ..aQS(8, _omitFieldNames ? '' : 'ownerEmail')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AccountDetails_OrgDetails clone() => AccountDetails_OrgDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AccountDetails_OrgDetails copyWith(void Function(AccountDetails_OrgDetails) updates) => super.copyWith((message) => updates(message as AccountDetails_OrgDetails)) as AccountDetails_OrgDetails;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDetails_OrgDetails create() => AccountDetails_OrgDetails._();
  AccountDetails_OrgDetails createEmptyInstance() => create();
  static $pb.PbList<AccountDetails_OrgDetails> createRepeated() => $pb.PbList<AccountDetails_OrgDetails>();
  @$core.pragma('dart2js:noInline')
  static AccountDetails_OrgDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountDetails_OrgDetails>(create);
  static AccountDetails_OrgDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get address => $_getSZ(1);
  @$pb.TagNumber(2)
  set address($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddress() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get city => $_getSZ(2);
  @$pb.TagNumber(3)
  set city($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCity() => $_has(2);
  @$pb.TagNumber(3)
  void clearCity() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get postcode => $_getSZ(3);
  @$pb.TagNumber(4)
  set postcode($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPostcode() => $_has(3);
  @$pb.TagNumber(4)
  void clearPostcode() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get country => $_getSZ(4);
  @$pb.TagNumber(5)
  set country($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCountry() => $_has(4);
  @$pb.TagNumber(5)
  void clearCountry() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get website => $_getSZ(5);
  @$pb.TagNumber(6)
  set website($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasWebsite() => $_has(5);
  @$pb.TagNumber(6)
  void clearWebsite() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get regNumber => $_getSZ(6);
  @$pb.TagNumber(7)
  set regNumber($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasRegNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearRegNumber() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get ownerEmail => $_getSZ(7);
  @$pb.TagNumber(8)
  set ownerEmail($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasOwnerEmail() => $_has(7);
  @$pb.TagNumber(8)
  void clearOwnerEmail() => clearField(8);
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
    final $result = create();
    if (firstName != null) {
      $result.firstName = firstName;
    }
    if (lastName != null) {
      $result.lastName = lastName;
    }
    if (email != null) {
      $result.email = email;
    }
    if (phoneNumber != null) {
      $result.phoneNumber = phoneNumber;
    }
    if (gender != null) {
      $result.gender = gender;
    }
    if (dateOfBirth != null) {
      $result.dateOfBirth = dateOfBirth;
    }
    if (nationality != null) {
      $result.nationality = nationality;
    }
    if (personalNumber != null) {
      $result.personalNumber = personalNumber;
    }
    if (residencyCountry != null) {
      $result.residencyCountry = residencyCountry;
    }
    if (residencyArea != null) {
      $result.residencyArea = residencyArea;
    }
    if (residencyCity != null) {
      $result.residencyCity = residencyCity;
    }
    if (residencyPostcode != null) {
      $result.residencyPostcode = residencyPostcode;
    }
    if (residencyAddress != null) {
      $result.residencyAddress = residencyAddress;
    }
    if (residencyAddress2 != null) {
      $result.residencyAddress2 = residencyAddress2;
    }
    return $result;
  }
  AccountDetails_IndividualDetails._() : super();
  factory AccountDetails_IndividualDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AccountDetails_IndividualDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountDetails.IndividualDetails', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
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
    ..aQS(14, _omitFieldNames ? '' : 'residencyAddress2')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AccountDetails_IndividualDetails clone() => AccountDetails_IndividualDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AccountDetails_IndividualDetails copyWith(void Function(AccountDetails_IndividualDetails) updates) => super.copyWith((message) => updates(message as AccountDetails_IndividualDetails)) as AccountDetails_IndividualDetails;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDetails_IndividualDetails create() => AccountDetails_IndividualDetails._();
  AccountDetails_IndividualDetails createEmptyInstance() => create();
  static $pb.PbList<AccountDetails_IndividualDetails> createRepeated() => $pb.PbList<AccountDetails_IndividualDetails>();
  @$core.pragma('dart2js:noInline')
  static AccountDetails_IndividualDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountDetails_IndividualDetails>(create);
  static AccountDetails_IndividualDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get firstName => $_getSZ(0);
  @$pb.TagNumber(1)
  set firstName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFirstName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFirstName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastName => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLastName() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get email => $_getSZ(2);
  @$pb.TagNumber(3)
  set email($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmail() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get phoneNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set phoneNumber($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPhoneNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearPhoneNumber() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get gender => $_getSZ(4);
  @$pb.TagNumber(5)
  set gender($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasGender() => $_has(4);
  @$pb.TagNumber(5)
  void clearGender() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get dateOfBirth => $_getSZ(5);
  @$pb.TagNumber(6)
  set dateOfBirth($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDateOfBirth() => $_has(5);
  @$pb.TagNumber(6)
  void clearDateOfBirth() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get nationality => $_getSZ(6);
  @$pb.TagNumber(7)
  set nationality($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasNationality() => $_has(6);
  @$pb.TagNumber(7)
  void clearNationality() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get personalNumber => $_getSZ(7);
  @$pb.TagNumber(8)
  set personalNumber($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasPersonalNumber() => $_has(7);
  @$pb.TagNumber(8)
  void clearPersonalNumber() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get residencyCountry => $_getSZ(8);
  @$pb.TagNumber(9)
  set residencyCountry($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasResidencyCountry() => $_has(8);
  @$pb.TagNumber(9)
  void clearResidencyCountry() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get residencyArea => $_getSZ(9);
  @$pb.TagNumber(10)
  set residencyArea($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasResidencyArea() => $_has(9);
  @$pb.TagNumber(10)
  void clearResidencyArea() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get residencyCity => $_getSZ(10);
  @$pb.TagNumber(11)
  set residencyCity($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasResidencyCity() => $_has(10);
  @$pb.TagNumber(11)
  void clearResidencyCity() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get residencyPostcode => $_getSZ(11);
  @$pb.TagNumber(12)
  set residencyPostcode($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasResidencyPostcode() => $_has(11);
  @$pb.TagNumber(12)
  void clearResidencyPostcode() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get residencyAddress => $_getSZ(12);
  @$pb.TagNumber(13)
  set residencyAddress($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasResidencyAddress() => $_has(12);
  @$pb.TagNumber(13)
  void clearResidencyAddress() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get residencyAddress2 => $_getSZ(13);
  @$pb.TagNumber(14)
  set residencyAddress2($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasResidencyAddress2() => $_has(13);
  @$pb.TagNumber(14)
  void clearResidencyAddress2() => clearField(14);
}

enum AccountDetails_Details {
  org, 
  individual, 
  notSet
}

class AccountDetails extends $pb.GeneratedMessage {
  factory AccountDetails({
    AccountDetails_OrgDetails? org,
    AccountDetails_IndividualDetails? individual,
    AccountState? accountState,
  }) {
    final $result = create();
    if (org != null) {
      $result.org = org;
    }
    if (individual != null) {
      $result.individual = individual;
    }
    if (accountState != null) {
      $result.accountState = accountState;
    }
    return $result;
  }
  AccountDetails._() : super();
  factory AccountDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AccountDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, AccountDetails_Details> _AccountDetails_DetailsByTag = {
    1 : AccountDetails_Details.org,
    2 : AccountDetails_Details.individual,
    0 : AccountDetails_Details.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AccountDetails', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<AccountDetails_OrgDetails>(1, _omitFieldNames ? '' : 'org', subBuilder: AccountDetails_OrgDetails.create)
    ..aOM<AccountDetails_IndividualDetails>(2, _omitFieldNames ? '' : 'individual', subBuilder: AccountDetails_IndividualDetails.create)
    ..e<AccountState>(3, _omitFieldNames ? '' : 'accountState', $pb.PbFieldType.QE, defaultOrMaker: AccountState.DISABLED, valueOf: AccountState.valueOf, enumValues: AccountState.values)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AccountDetails clone() => AccountDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AccountDetails copyWith(void Function(AccountDetails) updates) => super.copyWith((message) => updates(message as AccountDetails)) as AccountDetails;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountDetails create() => AccountDetails._();
  AccountDetails createEmptyInstance() => create();
  static $pb.PbList<AccountDetails> createRepeated() => $pb.PbList<AccountDetails>();
  @$core.pragma('dart2js:noInline')
  static AccountDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccountDetails>(create);
  static AccountDetails? _defaultInstance;

  AccountDetails_Details whichDetails() => _AccountDetails_DetailsByTag[$_whichOneof(0)]!;
  void clearDetails() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AccountDetails_OrgDetails get org => $_getN(0);
  @$pb.TagNumber(1)
  set org(AccountDetails_OrgDetails v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrg() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrg() => clearField(1);
  @$pb.TagNumber(1)
  AccountDetails_OrgDetails ensureOrg() => $_ensure(0);

  @$pb.TagNumber(2)
  AccountDetails_IndividualDetails get individual => $_getN(1);
  @$pb.TagNumber(2)
  set individual(AccountDetails_IndividualDetails v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasIndividual() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndividual() => clearField(2);
  @$pb.TagNumber(2)
  AccountDetails_IndividualDetails ensureIndividual() => $_ensure(1);

  @$pb.TagNumber(3)
  AccountState get accountState => $_getN(2);
  @$pb.TagNumber(3)
  set accountState(AccountState v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAccountState() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccountState() => clearField(3);
}

class Account extends $pb.GeneratedMessage {
  factory Account({
    $core.String? accountKey,
    AccountDetails? details,
    $core.Iterable<$core.String>? gaids,
  }) {
    final $result = create();
    if (accountKey != null) {
      $result.accountKey = accountKey;
    }
    if (details != null) {
      $result.details = details;
    }
    if (gaids != null) {
      $result.gaids.addAll(gaids);
    }
    return $result;
  }
  Account._() : super();
  factory Account.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Account.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Account', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'accountKey')
    ..aQM<AccountDetails>(2, _omitFieldNames ? '' : 'details', subBuilder: AccountDetails.create)
    ..pPS(3, _omitFieldNames ? '' : 'gaids')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Account clone() => Account()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Account copyWith(void Function(Account) updates) => super.copyWith((message) => updates(message as Account)) as Account;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Account create() => Account._();
  Account createEmptyInstance() => create();
  static $pb.PbList<Account> createRepeated() => $pb.PbList<Account>();
  @$core.pragma('dart2js:noInline')
  static Account getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Account>(create);
  static Account? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccountKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountKey() => clearField(1);

  @$pb.TagNumber(2)
  AccountDetails get details => $_getN(1);
  @$pb.TagNumber(2)
  set details(AccountDetails v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDetails() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetails() => clearField(2);
  @$pb.TagNumber(2)
  AccountDetails ensureDetails() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<$core.String> get gaids => $_getList(2);
}

class Asset extends $pb.GeneratedMessage {
  factory Asset({
    $core.String? assetId,
    $core.String? name,
    $core.String? ticker,
    $core.int? precision,
    $core.String? domain,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (ticker != null) {
      $result.ticker = ticker;
    }
    if (precision != null) {
      $result.precision = precision;
    }
    if (domain != null) {
      $result.domain = domain;
    }
    return $result;
  }
  Asset._() : super();
  factory Asset.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Asset.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Asset', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..aQS(3, _omitFieldNames ? '' : 'ticker')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'precision', $pb.PbFieldType.Q3)
    ..aQS(5, _omitFieldNames ? '' : 'domain')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Asset clone() => Asset()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Asset copyWith(void Function(Asset) updates) => super.copyWith((message) => updates(message as Asset)) as Asset;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Asset create() => Asset._();
  Asset createEmptyInstance() => create();
  static $pb.PbList<Asset> createRepeated() => $pb.PbList<Asset>();
  @$core.pragma('dart2js:noInline')
  static Asset getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Asset>(create);
  static Asset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get ticker => $_getSZ(2);
  @$pb.TagNumber(3)
  set ticker($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTicker() => $_has(2);
  @$pb.TagNumber(3)
  void clearTicker() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get precision => $_getIZ(3);
  @$pb.TagNumber(4)
  set precision($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPrecision() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrecision() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get domain => $_getSZ(4);
  @$pb.TagNumber(5)
  set domain($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDomain() => $_has(4);
  @$pb.TagNumber(5)
  void clearDomain() => clearField(5);
}

class Balance extends $pb.GeneratedMessage {
  factory Balance({
    $core.String? assetId,
    $core.double? balance,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (balance != null) {
      $result.balance = balance;
    }
    return $result;
  }
  Balance._() : super();
  factory Balance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Balance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Balance', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'balance', $pb.PbFieldType.QD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Balance clone() => Balance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Balance copyWith(void Function(Balance) updates) => super.copyWith((message) => updates(message as Balance)) as Balance;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Balance create() => Balance._();
  Balance createEmptyInstance() => create();
  static $pb.PbList<Balance> createRepeated() => $pb.PbList<Balance>();
  @$core.pragma('dart2js:noInline')
  static Balance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Balance>(create);
  static Balance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get balance => $_getN(1);
  @$pb.TagNumber(2)
  set balance($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearBalance() => clearField(2);
}

class Shares extends $pb.GeneratedMessage {
  factory Shares({
    $core.double? count,
    $core.double? total,
  }) {
    final $result = create();
    if (count != null) {
      $result.count = count;
    }
    if (total != null) {
      $result.total = total;
    }
    return $result;
  }
  Shares._() : super();
  factory Shares.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Shares.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Shares', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'count', $pb.PbFieldType.QD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'total', $pb.PbFieldType.QD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Shares clone() => Shares()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Shares copyWith(void Function(Shares) updates) => super.copyWith((message) => updates(message as Shares)) as Shares;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Shares create() => Shares._();
  Shares createEmptyInstance() => create();
  static $pb.PbList<Shares> createRepeated() => $pb.PbList<Shares>();
  @$core.pragma('dart2js:noInline')
  static Shares getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Shares>(create);
  static Shares? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get count => $_getN(0);
  @$pb.TagNumber(1)
  set count($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get total => $_getN(1);
  @$pb.TagNumber(2)
  set total($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => clearField(2);
}

class InOut extends $pb.GeneratedMessage {
  factory InOut({
    $core.double? amount,
    $core.String? gaid,
  }) {
    final $result = create();
    if (amount != null) {
      $result.amount = amount;
    }
    if (gaid != null) {
      $result.gaid = gaid;
    }
    return $result;
  }
  InOut._() : super();
  factory InOut.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InOut.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InOut', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QD)
    ..aOS(2, _omitFieldNames ? '' : 'gaid')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InOut clone() => InOut()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InOut copyWith(void Function(InOut) updates) => super.copyWith((message) => updates(message as InOut)) as InOut;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InOut create() => InOut._();
  InOut createEmptyInstance() => create();
  static $pb.PbList<InOut> createRepeated() => $pb.PbList<InOut>();
  @$core.pragma('dart2js:noInline')
  static InOut getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InOut>(create);
  static InOut? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get amount => $_getN(0);
  @$pb.TagNumber(1)
  set amount($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get gaid => $_getSZ(1);
  @$pb.TagNumber(2)
  set gaid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGaid() => $_has(1);
  @$pb.TagNumber(2)
  void clearGaid() => clearField(2);
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
    final $result = create();
    if (inputs != null) {
      $result.inputs.addAll(inputs);
    }
    if (outputs != null) {
      $result.outputs.addAll(outputs);
    }
    if (txid != null) {
      $result.txid = txid;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (unblinded != null) {
      $result.unblinded = unblinded;
    }
    if (price != null) {
      $result.price = price;
    }
    return $result;
  }
  FullTransaction._() : super();
  factory FullTransaction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FullTransaction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FullTransaction', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..pc<InOut>(1, _omitFieldNames ? '' : 'inputs', $pb.PbFieldType.PM, subBuilder: InOut.create)
    ..pc<InOut>(2, _omitFieldNames ? '' : 'outputs', $pb.PbFieldType.PM, subBuilder: InOut.create)
    ..aQS(3, _omitFieldNames ? '' : 'txid')
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aQS(5, _omitFieldNames ? '' : 'unblinded')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'price', $pb.PbFieldType.OD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FullTransaction clone() => FullTransaction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FullTransaction copyWith(void Function(FullTransaction) updates) => super.copyWith((message) => updates(message as FullTransaction)) as FullTransaction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FullTransaction create() => FullTransaction._();
  FullTransaction createEmptyInstance() => create();
  static $pb.PbList<FullTransaction> createRepeated() => $pb.PbList<FullTransaction>();
  @$core.pragma('dart2js:noInline')
  static FullTransaction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FullTransaction>(create);
  static FullTransaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<InOut> get inputs => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<InOut> get outputs => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get txid => $_getSZ(2);
  @$pb.TagNumber(3)
  set txid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTxid() => $_has(2);
  @$pb.TagNumber(3)
  void clearTxid() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get timestamp => $_getI64(3);
  @$pb.TagNumber(4)
  set timestamp($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get unblinded => $_getSZ(4);
  @$pb.TagNumber(5)
  set unblinded($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUnblinded() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnblinded() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get price => $_getN(5);
  @$pb.TagNumber(6)
  set price($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrice() => clearField(6);
}

class OwnTransaction extends $pb.GeneratedMessage {
  factory OwnTransaction({
    $core.String? txid,
    $fixnum.Int64? timestamp,
    $core.double? amount,
    $core.double? price,
  }) {
    final $result = create();
    if (txid != null) {
      $result.txid = txid;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (price != null) {
      $result.price = price;
    }
    return $result;
  }
  OwnTransaction._() : super();
  factory OwnTransaction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OwnTransaction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OwnTransaction', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'txid')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'timestamp', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'price', $pb.PbFieldType.OD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OwnTransaction clone() => OwnTransaction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OwnTransaction copyWith(void Function(OwnTransaction) updates) => super.copyWith((message) => updates(message as OwnTransaction)) as OwnTransaction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OwnTransaction create() => OwnTransaction._();
  OwnTransaction createEmptyInstance() => create();
  static $pb.PbList<OwnTransaction> createRepeated() => $pb.PbList<OwnTransaction>();
  @$core.pragma('dart2js:noInline')
  static OwnTransaction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OwnTransaction>(create);
  static OwnTransaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get txid => $_getSZ(0);
  @$pb.TagNumber(1)
  set txid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get price => $_getN(3);
  @$pb.TagNumber(4)
  set price($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrice() => clearField(4);
}

class BalanceOwner extends $pb.GeneratedMessage {
  factory BalanceOwner({
    $core.String? accountKey,
    $core.double? amount,
  }) {
    final $result = create();
    if (accountKey != null) {
      $result.accountKey = accountKey;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    return $result;
  }
  BalanceOwner._() : super();
  factory BalanceOwner.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BalanceOwner.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BalanceOwner', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'accountKey')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BalanceOwner clone() => BalanceOwner()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BalanceOwner copyWith(void Function(BalanceOwner) updates) => super.copyWith((message) => updates(message as BalanceOwner)) as BalanceOwner;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BalanceOwner create() => BalanceOwner._();
  BalanceOwner createEmptyInstance() => create();
  static $pb.PbList<BalanceOwner> createRepeated() => $pb.PbList<BalanceOwner>();
  @$core.pragma('dart2js:noInline')
  static BalanceOwner getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BalanceOwner>(create);
  static BalanceOwner? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccountKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);
}

class Serie extends $pb.GeneratedMessage {
  factory Serie({
    $fixnum.Int64? start,
    $fixnum.Int64? count,
  }) {
    final $result = create();
    if (start != null) {
      $result.start = start;
    }
    if (count != null) {
      $result.count = count;
    }
    return $result;
  }
  Serie._() : super();
  factory Serie.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Serie.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Serie', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'start', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'count', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Serie clone() => Serie()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Serie copyWith(void Function(Serie) updates) => super.copyWith((message) => updates(message as Serie)) as Serie;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Serie create() => Serie._();
  Serie createEmptyInstance() => create();
  static $pb.PbList<Serie> createRepeated() => $pb.PbList<Serie>();
  @$core.pragma('dart2js:noInline')
  static Serie getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Serie>(create);
  static Serie? _defaultInstance;

  @$pb.TagNumber(2)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(2)
  set start($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(2)
  void clearStart() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get count => $_getI64(1);
  @$pb.TagNumber(3)
  set count($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(3)
  void clearCount() => clearField(3);
}

class SerieOwner extends $pb.GeneratedMessage {
  factory SerieOwner({
    $core.String? accountKey,
    $core.Iterable<Serie>? series,
  }) {
    final $result = create();
    if (accountKey != null) {
      $result.accountKey = accountKey;
    }
    if (series != null) {
      $result.series.addAll(series);
    }
    return $result;
  }
  SerieOwner._() : super();
  factory SerieOwner.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SerieOwner.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SerieOwner', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'accountKey')
    ..pc<Serie>(2, _omitFieldNames ? '' : 'series', $pb.PbFieldType.PM, subBuilder: Serie.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SerieOwner clone() => SerieOwner()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SerieOwner copyWith(void Function(SerieOwner) updates) => super.copyWith((message) => updates(message as SerieOwner)) as SerieOwner;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SerieOwner create() => SerieOwner._();
  SerieOwner createEmptyInstance() => create();
  static $pb.PbList<SerieOwner> createRepeated() => $pb.PbList<SerieOwner>();
  @$core.pragma('dart2js:noInline')
  static SerieOwner getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SerieOwner>(create);
  static SerieOwner? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccountKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<Serie> get series => $_getList(1);
}

class Req_Login extends $pb.GeneratedMessage {
  factory Req_Login() => create();
  Req_Login._() : super();
  factory Req_Login.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_Login.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.Login', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_Login clone() => Req_Login()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_Login copyWith(void Function(Req_Login) updates) => super.copyWith((message) => updates(message as Req_Login)) as Req_Login;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_Login create() => Req_Login._();
  Req_Login createEmptyInstance() => create();
  static $pb.PbList<Req_Login> createRepeated() => $pb.PbList<Req_Login>();
  @$core.pragma('dart2js:noInline')
  static Req_Login getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_Login>(create);
  static Req_Login? _defaultInstance;
}

class Req_Register_Org extends $pb.GeneratedMessage {
  factory Req_Register_Org({
    $core.String? name,
    $core.String? address,
    $core.String? city,
    $core.String? postcode,
    $core.String? country,
    $core.String? website,
    $core.String? regNumber,
    $core.List<$core.int>? regProof,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (address != null) {
      $result.address = address;
    }
    if (city != null) {
      $result.city = city;
    }
    if (postcode != null) {
      $result.postcode = postcode;
    }
    if (country != null) {
      $result.country = country;
    }
    if (website != null) {
      $result.website = website;
    }
    if (regNumber != null) {
      $result.regNumber = regNumber;
    }
    if (regProof != null) {
      $result.regProof = regProof;
    }
    return $result;
  }
  Req_Register_Org._() : super();
  factory Req_Register_Org.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_Register_Org.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.Register.Org', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'name')
    ..aQS(2, _omitFieldNames ? '' : 'address')
    ..aQS(3, _omitFieldNames ? '' : 'city')
    ..aQS(4, _omitFieldNames ? '' : 'postcode')
    ..aQS(5, _omitFieldNames ? '' : 'country')
    ..aQS(6, _omitFieldNames ? '' : 'website')
    ..aQS(7, _omitFieldNames ? '' : 'regNumber')
    ..a<$core.List<$core.int>>(8, _omitFieldNames ? '' : 'regProof', $pb.PbFieldType.QY)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_Register_Org clone() => Req_Register_Org()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_Register_Org copyWith(void Function(Req_Register_Org) updates) => super.copyWith((message) => updates(message as Req_Register_Org)) as Req_Register_Org;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_Register_Org create() => Req_Register_Org._();
  Req_Register_Org createEmptyInstance() => create();
  static $pb.PbList<Req_Register_Org> createRepeated() => $pb.PbList<Req_Register_Org>();
  @$core.pragma('dart2js:noInline')
  static Req_Register_Org getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_Register_Org>(create);
  static Req_Register_Org? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get address => $_getSZ(1);
  @$pb.TagNumber(2)
  set address($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddress() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get city => $_getSZ(2);
  @$pb.TagNumber(3)
  set city($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCity() => $_has(2);
  @$pb.TagNumber(3)
  void clearCity() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get postcode => $_getSZ(3);
  @$pb.TagNumber(4)
  set postcode($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPostcode() => $_has(3);
  @$pb.TagNumber(4)
  void clearPostcode() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get country => $_getSZ(4);
  @$pb.TagNumber(5)
  set country($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCountry() => $_has(4);
  @$pb.TagNumber(5)
  void clearCountry() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get website => $_getSZ(5);
  @$pb.TagNumber(6)
  set website($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasWebsite() => $_has(5);
  @$pb.TagNumber(6)
  void clearWebsite() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get regNumber => $_getSZ(6);
  @$pb.TagNumber(7)
  set regNumber($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasRegNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearRegNumber() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get regProof => $_getN(7);
  @$pb.TagNumber(8)
  set regProof($core.List<$core.int> v) { $_setBytes(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasRegProof() => $_has(7);
  @$pb.TagNumber(8)
  void clearRegProof() => clearField(8);
}

class Req_Register extends $pb.GeneratedMessage {
  factory Req_Register({
    Req_Register_Org? org,
  }) {
    final $result = create();
    if (org != null) {
      $result.org = org;
    }
    return $result;
  }
  Req_Register._() : super();
  factory Req_Register.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_Register.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.Register', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aOM<Req_Register_Org>(1, _omitFieldNames ? '' : 'org', subBuilder: Req_Register_Org.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_Register clone() => Req_Register()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_Register copyWith(void Function(Req_Register) updates) => super.copyWith((message) => updates(message as Req_Register)) as Req_Register;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_Register create() => Req_Register._();
  Req_Register createEmptyInstance() => create();
  static $pb.PbList<Req_Register> createRepeated() => $pb.PbList<Req_Register>();
  @$core.pragma('dart2js:noInline')
  static Req_Register getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_Register>(create);
  static Req_Register? _defaultInstance;

  @$pb.TagNumber(1)
  Req_Register_Org get org => $_getN(0);
  @$pb.TagNumber(1)
  set org(Req_Register_Org v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrg() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrg() => clearField(1);
  @$pb.TagNumber(1)
  Req_Register_Org ensureOrg() => $_ensure(0);
}

class Req_RegisterIssuer extends $pb.GeneratedMessage {
  factory Req_RegisterIssuer({
    $core.String? email,
    $core.String? name,
    $core.String? website,
    $core.String? message,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (name != null) {
      $result.name = name;
    }
    if (website != null) {
      $result.website = website;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  Req_RegisterIssuer._() : super();
  factory Req_RegisterIssuer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_RegisterIssuer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.RegisterIssuer', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'email')
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..aQS(3, _omitFieldNames ? '' : 'website')
    ..aQS(4, _omitFieldNames ? '' : 'message')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_RegisterIssuer clone() => Req_RegisterIssuer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_RegisterIssuer copyWith(void Function(Req_RegisterIssuer) updates) => super.copyWith((message) => updates(message as Req_RegisterIssuer)) as Req_RegisterIssuer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_RegisterIssuer create() => Req_RegisterIssuer._();
  Req_RegisterIssuer createEmptyInstance() => create();
  static $pb.PbList<Req_RegisterIssuer> createRepeated() => $pb.PbList<Req_RegisterIssuer>();
  @$core.pragma('dart2js:noInline')
  static Req_RegisterIssuer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_RegisterIssuer>(create);
  static Req_RegisterIssuer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get website => $_getSZ(2);
  @$pb.TagNumber(3)
  set website($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWebsite() => $_has(2);
  @$pb.TagNumber(3)
  void clearWebsite() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => clearField(4);
}

class Req_Resume extends $pb.GeneratedMessage {
  factory Req_Resume({
    $core.String? token,
    $core.String? accountKey,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (accountKey != null) {
      $result.accountKey = accountKey;
    }
    return $result;
  }
  Req_Resume._() : super();
  factory Req_Resume.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_Resume.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.Resume', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'token')
    ..aQS(2, _omitFieldNames ? '' : 'accountKey')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_Resume clone() => Req_Resume()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_Resume copyWith(void Function(Req_Resume) updates) => super.copyWith((message) => updates(message as Req_Resume)) as Req_Resume;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_Resume create() => Req_Resume._();
  Req_Resume createEmptyInstance() => create();
  static $pb.PbList<Req_Resume> createRepeated() => $pb.PbList<Req_Resume>();
  @$core.pragma('dart2js:noInline')
  static Req_Resume getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_Resume>(create);
  static Req_Resume? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAccountKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountKey() => clearField(2);
}

class Req_Logout extends $pb.GeneratedMessage {
  factory Req_Logout() => create();
  Req_Logout._() : super();
  factory Req_Logout.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_Logout.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.Logout', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_Logout clone() => Req_Logout()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_Logout copyWith(void Function(Req_Logout) updates) => super.copyWith((message) => updates(message as Req_Logout)) as Req_Logout;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_Logout create() => Req_Logout._();
  Req_Logout createEmptyInstance() => create();
  static $pb.PbList<Req_Logout> createRepeated() => $pb.PbList<Req_Logout>();
  @$core.pragma('dart2js:noInline')
  static Req_Logout getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_Logout>(create);
  static Req_Logout? _defaultInstance;
}

class Req_AddGaid extends $pb.GeneratedMessage {
  factory Req_AddGaid({
    $core.String? gaid,
    $core.bool? acceptFreeShares,
    $core.bool? useLocalAccount,
  }) {
    final $result = create();
    if (gaid != null) {
      $result.gaid = gaid;
    }
    if (acceptFreeShares != null) {
      $result.acceptFreeShares = acceptFreeShares;
    }
    if (useLocalAccount != null) {
      $result.useLocalAccount = useLocalAccount;
    }
    return $result;
  }
  Req_AddGaid._() : super();
  factory Req_AddGaid.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_AddGaid.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.AddGaid', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'gaid')
    ..a<$core.bool>(2, _omitFieldNames ? '' : 'acceptFreeShares', $pb.PbFieldType.QB)
    ..a<$core.bool>(3, _omitFieldNames ? '' : 'useLocalAccount', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_AddGaid clone() => Req_AddGaid()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_AddGaid copyWith(void Function(Req_AddGaid) updates) => super.copyWith((message) => updates(message as Req_AddGaid)) as Req_AddGaid;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_AddGaid create() => Req_AddGaid._();
  Req_AddGaid createEmptyInstance() => create();
  static $pb.PbList<Req_AddGaid> createRepeated() => $pb.PbList<Req_AddGaid>();
  @$core.pragma('dart2js:noInline')
  static Req_AddGaid getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_AddGaid>(create);
  static Req_AddGaid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gaid => $_getSZ(0);
  @$pb.TagNumber(1)
  set gaid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGaid() => $_has(0);
  @$pb.TagNumber(1)
  void clearGaid() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get acceptFreeShares => $_getBF(1);
  @$pb.TagNumber(2)
  set acceptFreeShares($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAcceptFreeShares() => $_has(1);
  @$pb.TagNumber(2)
  void clearAcceptFreeShares() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get useLocalAccount => $_getBF(2);
  @$pb.TagNumber(3)
  set useLocalAccount($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUseLocalAccount() => $_has(2);
  @$pb.TagNumber(3)
  void clearUseLocalAccount() => clearField(3);
}

class Req_LoadAssets extends $pb.GeneratedMessage {
  factory Req_LoadAssets() => create();
  Req_LoadAssets._() : super();
  factory Req_LoadAssets.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_LoadAssets.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.LoadAssets', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_LoadAssets clone() => Req_LoadAssets()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_LoadAssets copyWith(void Function(Req_LoadAssets) updates) => super.copyWith((message) => updates(message as Req_LoadAssets)) as Req_LoadAssets;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_LoadAssets create() => Req_LoadAssets._();
  Req_LoadAssets createEmptyInstance() => create();
  static $pb.PbList<Req_LoadAssets> createRepeated() => $pb.PbList<Req_LoadAssets>();
  @$core.pragma('dart2js:noInline')
  static Req_LoadAssets getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_LoadAssets>(create);
  static Req_LoadAssets? _defaultInstance;
}

class Req_BuyShares extends $pb.GeneratedMessage {
  factory Req_BuyShares({
    $core.double? amount,
  }) {
    final $result = create();
    if (amount != null) {
      $result.amount = amount;
    }
    return $result;
  }
  Req_BuyShares._() : super();
  factory Req_BuyShares.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_BuyShares.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.BuyShares', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_BuyShares clone() => Req_BuyShares()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_BuyShares copyWith(void Function(Req_BuyShares) updates) => super.copyWith((message) => updates(message as Req_BuyShares)) as Req_BuyShares;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_BuyShares create() => Req_BuyShares._();
  Req_BuyShares createEmptyInstance() => create();
  static $pb.PbList<Req_BuyShares> createRepeated() => $pb.PbList<Req_BuyShares>();
  @$core.pragma('dart2js:noInline')
  static Req_BuyShares getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_BuyShares>(create);
  static Req_BuyShares? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get amount => $_getN(0);
  @$pb.TagNumber(1)
  set amount($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => clearField(1);
}

class Req_LoadCountries extends $pb.GeneratedMessage {
  factory Req_LoadCountries() => create();
  Req_LoadCountries._() : super();
  factory Req_LoadCountries.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_LoadCountries.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.LoadCountries', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_LoadCountries clone() => Req_LoadCountries()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_LoadCountries copyWith(void Function(Req_LoadCountries) updates) => super.copyWith((message) => updates(message as Req_LoadCountries)) as Req_LoadCountries;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_LoadCountries create() => Req_LoadCountries._();
  Req_LoadCountries createEmptyInstance() => create();
  static $pb.PbList<Req_LoadCountries> createRepeated() => $pb.PbList<Req_LoadCountries>();
  @$core.pragma('dart2js:noInline')
  static Req_LoadCountries getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_LoadCountries>(create);
  static Req_LoadCountries? _defaultInstance;
}

class Req_LoadRegs extends $pb.GeneratedMessage {
  factory Req_LoadRegs() => create();
  Req_LoadRegs._() : super();
  factory Req_LoadRegs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_LoadRegs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.LoadRegs', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_LoadRegs clone() => Req_LoadRegs()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_LoadRegs copyWith(void Function(Req_LoadRegs) updates) => super.copyWith((message) => updates(message as Req_LoadRegs)) as Req_LoadRegs;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_LoadRegs create() => Req_LoadRegs._();
  Req_LoadRegs createEmptyInstance() => create();
  static $pb.PbList<Req_LoadRegs> createRepeated() => $pb.PbList<Req_LoadRegs>();
  @$core.pragma('dart2js:noInline')
  static Req_LoadRegs getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_LoadRegs>(create);
  static Req_LoadRegs? _defaultInstance;
}

class Req_LoadFile extends $pb.GeneratedMessage {
  factory Req_LoadFile({
    $core.String? accountKey,
  }) {
    final $result = create();
    if (accountKey != null) {
      $result.accountKey = accountKey;
    }
    return $result;
  }
  Req_LoadFile._() : super();
  factory Req_LoadFile.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_LoadFile.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.LoadFile', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'accountKey')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_LoadFile clone() => Req_LoadFile()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_LoadFile copyWith(void Function(Req_LoadFile) updates) => super.copyWith((message) => updates(message as Req_LoadFile)) as Req_LoadFile;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_LoadFile create() => Req_LoadFile._();
  Req_LoadFile createEmptyInstance() => create();
  static $pb.PbList<Req_LoadFile> createRepeated() => $pb.PbList<Req_LoadFile>();
  @$core.pragma('dart2js:noInline')
  static Req_LoadFile getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_LoadFile>(create);
  static Req_LoadFile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccountKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountKey() => clearField(1);
}

class Req_UpdateReg extends $pb.GeneratedMessage {
  factory Req_UpdateReg({
    $core.String? accountKey,
    $core.bool? valid,
  }) {
    final $result = create();
    if (accountKey != null) {
      $result.accountKey = accountKey;
    }
    if (valid != null) {
      $result.valid = valid;
    }
    return $result;
  }
  Req_UpdateReg._() : super();
  factory Req_UpdateReg.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_UpdateReg.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.UpdateReg', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'accountKey')
    ..a<$core.bool>(2, _omitFieldNames ? '' : 'valid', $pb.PbFieldType.QB)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_UpdateReg clone() => Req_UpdateReg()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_UpdateReg copyWith(void Function(Req_UpdateReg) updates) => super.copyWith((message) => updates(message as Req_UpdateReg)) as Req_UpdateReg;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_UpdateReg create() => Req_UpdateReg._();
  Req_UpdateReg createEmptyInstance() => create();
  static $pb.PbList<Req_UpdateReg> createRepeated() => $pb.PbList<Req_UpdateReg>();
  @$core.pragma('dart2js:noInline')
  static Req_UpdateReg getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_UpdateReg>(create);
  static Req_UpdateReg? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccountKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get valid => $_getBF(1);
  @$pb.TagNumber(2)
  set valid($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValid() => $_has(1);
  @$pb.TagNumber(2)
  void clearValid() => clearField(2);
}

class Req_ListAllTransactions extends $pb.GeneratedMessage {
  factory Req_ListAllTransactions({
    $core.String? assetId,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    return $result;
  }
  Req_ListAllTransactions._() : super();
  factory Req_ListAllTransactions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_ListAllTransactions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.ListAllTransactions', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_ListAllTransactions clone() => Req_ListAllTransactions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_ListAllTransactions copyWith(void Function(Req_ListAllTransactions) updates) => super.copyWith((message) => updates(message as Req_ListAllTransactions)) as Req_ListAllTransactions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_ListAllTransactions create() => Req_ListAllTransactions._();
  Req_ListAllTransactions createEmptyInstance() => create();
  static $pb.PbList<Req_ListAllTransactions> createRepeated() => $pb.PbList<Req_ListAllTransactions>();
  @$core.pragma('dart2js:noInline')
  static Req_ListAllTransactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_ListAllTransactions>(create);
  static Req_ListAllTransactions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);
}

class Req_ListOwnTransactions extends $pb.GeneratedMessage {
  factory Req_ListOwnTransactions({
    $core.String? assetId,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    return $result;
  }
  Req_ListOwnTransactions._() : super();
  factory Req_ListOwnTransactions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_ListOwnTransactions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.ListOwnTransactions', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_ListOwnTransactions clone() => Req_ListOwnTransactions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_ListOwnTransactions copyWith(void Function(Req_ListOwnTransactions) updates) => super.copyWith((message) => updates(message as Req_ListOwnTransactions)) as Req_ListOwnTransactions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_ListOwnTransactions create() => Req_ListOwnTransactions._();
  Req_ListOwnTransactions createEmptyInstance() => create();
  static $pb.PbList<Req_ListOwnTransactions> createRepeated() => $pb.PbList<Req_ListOwnTransactions>();
  @$core.pragma('dart2js:noInline')
  static Req_ListOwnTransactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_ListOwnTransactions>(create);
  static Req_ListOwnTransactions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);
}

class Req_ListAllBalances extends $pb.GeneratedMessage {
  factory Req_ListAllBalances({
    $core.String? assetId,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    return $result;
  }
  Req_ListAllBalances._() : super();
  factory Req_ListAllBalances.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_ListAllBalances.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.ListAllBalances', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_ListAllBalances clone() => Req_ListAllBalances()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_ListAllBalances copyWith(void Function(Req_ListAllBalances) updates) => super.copyWith((message) => updates(message as Req_ListAllBalances)) as Req_ListAllBalances;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_ListAllBalances create() => Req_ListAllBalances._();
  Req_ListAllBalances createEmptyInstance() => create();
  static $pb.PbList<Req_ListAllBalances> createRepeated() => $pb.PbList<Req_ListAllBalances>();
  @$core.pragma('dart2js:noInline')
  static Req_ListAllBalances getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_ListAllBalances>(create);
  static Req_ListAllBalances? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);
}

class Req_ListAllSeries extends $pb.GeneratedMessage {
  factory Req_ListAllSeries({
    $core.String? assetId,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    return $result;
  }
  Req_ListAllSeries._() : super();
  factory Req_ListAllSeries.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req_ListAllSeries.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req.ListAllSeries', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req_ListAllSeries clone() => Req_ListAllSeries()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req_ListAllSeries copyWith(void Function(Req_ListAllSeries) updates) => super.copyWith((message) => updates(message as Req_ListAllSeries)) as Req_ListAllSeries;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req_ListAllSeries create() => Req_ListAllSeries._();
  Req_ListAllSeries createEmptyInstance() => create();
  static $pb.PbList<Req_ListAllSeries> createRepeated() => $pb.PbList<Req_ListAllSeries>();
  @$core.pragma('dart2js:noInline')
  static Req_ListAllSeries getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req_ListAllSeries>(create);
  static Req_ListAllSeries? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);
}

enum Req_Body {
  login, 
  register, 
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
    Req_Login? login,
    Req_Register? register,
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
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (login != null) {
      $result.login = login;
    }
    if (register != null) {
      $result.register = register;
    }
    if (resume != null) {
      $result.resume = resume;
    }
    if (logout != null) {
      $result.logout = logout;
    }
    if (registerIssuer != null) {
      $result.registerIssuer = registerIssuer;
    }
    if (addGaid != null) {
      $result.addGaid = addGaid;
    }
    if (loadAssets != null) {
      $result.loadAssets = loadAssets;
    }
    if (buyShares != null) {
      $result.buyShares = buyShares;
    }
    if (loadCountries != null) {
      $result.loadCountries = loadCountries;
    }
    if (loadRegs != null) {
      $result.loadRegs = loadRegs;
    }
    if (updateReg != null) {
      $result.updateReg = updateReg;
    }
    if (loadFile != null) {
      $result.loadFile = loadFile;
    }
    if (listAllTransactions != null) {
      $result.listAllTransactions = listAllTransactions;
    }
    if (listOwnTransactions != null) {
      $result.listOwnTransactions = listOwnTransactions;
    }
    if (listAllBalances != null) {
      $result.listAllBalances = listAllBalances;
    }
    if (listAllSeries != null) {
      $result.listAllSeries = listAllSeries;
    }
    return $result;
  }
  Req._() : super();
  factory Req.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Req.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Req_Body> _Req_BodyByTag = {
    10 : Req_Body.login,
    11 : Req_Body.register,
    12 : Req_Body.resume,
    13 : Req_Body.logout,
    14 : Req_Body.registerIssuer,
    20 : Req_Body.addGaid,
    21 : Req_Body.loadAssets,
    24 : Req_Body.buyShares,
    25 : Req_Body.loadCountries,
    26 : Req_Body.loadRegs,
    27 : Req_Body.updateReg,
    28 : Req_Body.loadFile,
    29 : Req_Body.listAllTransactions,
    30 : Req_Body.listOwnTransactions,
    31 : Req_Body.listAllBalances,
    32 : Req_Body.listAllSeries,
    0 : Req_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Req', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13, 14, 20, 21, 24, 25, 26, 27, 28, 29, 30, 31, 32])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<Req_Login>(10, _omitFieldNames ? '' : 'login', subBuilder: Req_Login.create)
    ..aOM<Req_Register>(11, _omitFieldNames ? '' : 'register', subBuilder: Req_Register.create)
    ..aOM<Req_Resume>(12, _omitFieldNames ? '' : 'resume', subBuilder: Req_Resume.create)
    ..aOM<Req_Logout>(13, _omitFieldNames ? '' : 'logout', subBuilder: Req_Logout.create)
    ..aOM<Req_RegisterIssuer>(14, _omitFieldNames ? '' : 'registerIssuer', subBuilder: Req_RegisterIssuer.create)
    ..aOM<Req_AddGaid>(20, _omitFieldNames ? '' : 'addGaid', subBuilder: Req_AddGaid.create)
    ..aOM<Req_LoadAssets>(21, _omitFieldNames ? '' : 'loadAssets', subBuilder: Req_LoadAssets.create)
    ..aOM<Req_BuyShares>(24, _omitFieldNames ? '' : 'buyShares', subBuilder: Req_BuyShares.create)
    ..aOM<Req_LoadCountries>(25, _omitFieldNames ? '' : 'loadCountries', subBuilder: Req_LoadCountries.create)
    ..aOM<Req_LoadRegs>(26, _omitFieldNames ? '' : 'loadRegs', subBuilder: Req_LoadRegs.create)
    ..aOM<Req_UpdateReg>(27, _omitFieldNames ? '' : 'updateReg', subBuilder: Req_UpdateReg.create)
    ..aOM<Req_LoadFile>(28, _omitFieldNames ? '' : 'loadFile', subBuilder: Req_LoadFile.create)
    ..aOM<Req_ListAllTransactions>(29, _omitFieldNames ? '' : 'listAllTransactions', subBuilder: Req_ListAllTransactions.create)
    ..aOM<Req_ListOwnTransactions>(30, _omitFieldNames ? '' : 'listOwnTransactions', subBuilder: Req_ListOwnTransactions.create)
    ..aOM<Req_ListAllBalances>(31, _omitFieldNames ? '' : 'listAllBalances', subBuilder: Req_ListAllBalances.create)
    ..aOM<Req_ListAllSeries>(32, _omitFieldNames ? '' : 'listAllSeries', subBuilder: Req_ListAllSeries.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Req clone() => Req()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Req copyWith(void Function(Req) updates) => super.copyWith((message) => updates(message as Req)) as Req;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Req create() => Req._();
  Req createEmptyInstance() => create();
  static $pb.PbList<Req> createRepeated() => $pb.PbList<Req>();
  @$core.pragma('dart2js:noInline')
  static Req getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Req>(create);
  static Req? _defaultInstance;

  Req_Body whichBody() => _Req_BodyByTag[$_whichOneof(0)]!;
  void clearBody() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(10)
  Req_Login get login => $_getN(1);
  @$pb.TagNumber(10)
  set login(Req_Login v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasLogin() => $_has(1);
  @$pb.TagNumber(10)
  void clearLogin() => clearField(10);
  @$pb.TagNumber(10)
  Req_Login ensureLogin() => $_ensure(1);

  @$pb.TagNumber(11)
  Req_Register get register => $_getN(2);
  @$pb.TagNumber(11)
  set register(Req_Register v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasRegister() => $_has(2);
  @$pb.TagNumber(11)
  void clearRegister() => clearField(11);
  @$pb.TagNumber(11)
  Req_Register ensureRegister() => $_ensure(2);

  @$pb.TagNumber(12)
  Req_Resume get resume => $_getN(3);
  @$pb.TagNumber(12)
  set resume(Req_Resume v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasResume() => $_has(3);
  @$pb.TagNumber(12)
  void clearResume() => clearField(12);
  @$pb.TagNumber(12)
  Req_Resume ensureResume() => $_ensure(3);

  @$pb.TagNumber(13)
  Req_Logout get logout => $_getN(4);
  @$pb.TagNumber(13)
  set logout(Req_Logout v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasLogout() => $_has(4);
  @$pb.TagNumber(13)
  void clearLogout() => clearField(13);
  @$pb.TagNumber(13)
  Req_Logout ensureLogout() => $_ensure(4);

  @$pb.TagNumber(14)
  Req_RegisterIssuer get registerIssuer => $_getN(5);
  @$pb.TagNumber(14)
  set registerIssuer(Req_RegisterIssuer v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasRegisterIssuer() => $_has(5);
  @$pb.TagNumber(14)
  void clearRegisterIssuer() => clearField(14);
  @$pb.TagNumber(14)
  Req_RegisterIssuer ensureRegisterIssuer() => $_ensure(5);

  @$pb.TagNumber(20)
  Req_AddGaid get addGaid => $_getN(6);
  @$pb.TagNumber(20)
  set addGaid(Req_AddGaid v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasAddGaid() => $_has(6);
  @$pb.TagNumber(20)
  void clearAddGaid() => clearField(20);
  @$pb.TagNumber(20)
  Req_AddGaid ensureAddGaid() => $_ensure(6);

  @$pb.TagNumber(21)
  Req_LoadAssets get loadAssets => $_getN(7);
  @$pb.TagNumber(21)
  set loadAssets(Req_LoadAssets v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasLoadAssets() => $_has(7);
  @$pb.TagNumber(21)
  void clearLoadAssets() => clearField(21);
  @$pb.TagNumber(21)
  Req_LoadAssets ensureLoadAssets() => $_ensure(7);

  @$pb.TagNumber(24)
  Req_BuyShares get buyShares => $_getN(8);
  @$pb.TagNumber(24)
  set buyShares(Req_BuyShares v) { setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasBuyShares() => $_has(8);
  @$pb.TagNumber(24)
  void clearBuyShares() => clearField(24);
  @$pb.TagNumber(24)
  Req_BuyShares ensureBuyShares() => $_ensure(8);

  @$pb.TagNumber(25)
  Req_LoadCountries get loadCountries => $_getN(9);
  @$pb.TagNumber(25)
  set loadCountries(Req_LoadCountries v) { setField(25, v); }
  @$pb.TagNumber(25)
  $core.bool hasLoadCountries() => $_has(9);
  @$pb.TagNumber(25)
  void clearLoadCountries() => clearField(25);
  @$pb.TagNumber(25)
  Req_LoadCountries ensureLoadCountries() => $_ensure(9);

  @$pb.TagNumber(26)
  Req_LoadRegs get loadRegs => $_getN(10);
  @$pb.TagNumber(26)
  set loadRegs(Req_LoadRegs v) { setField(26, v); }
  @$pb.TagNumber(26)
  $core.bool hasLoadRegs() => $_has(10);
  @$pb.TagNumber(26)
  void clearLoadRegs() => clearField(26);
  @$pb.TagNumber(26)
  Req_LoadRegs ensureLoadRegs() => $_ensure(10);

  @$pb.TagNumber(27)
  Req_UpdateReg get updateReg => $_getN(11);
  @$pb.TagNumber(27)
  set updateReg(Req_UpdateReg v) { setField(27, v); }
  @$pb.TagNumber(27)
  $core.bool hasUpdateReg() => $_has(11);
  @$pb.TagNumber(27)
  void clearUpdateReg() => clearField(27);
  @$pb.TagNumber(27)
  Req_UpdateReg ensureUpdateReg() => $_ensure(11);

  @$pb.TagNumber(28)
  Req_LoadFile get loadFile => $_getN(12);
  @$pb.TagNumber(28)
  set loadFile(Req_LoadFile v) { setField(28, v); }
  @$pb.TagNumber(28)
  $core.bool hasLoadFile() => $_has(12);
  @$pb.TagNumber(28)
  void clearLoadFile() => clearField(28);
  @$pb.TagNumber(28)
  Req_LoadFile ensureLoadFile() => $_ensure(12);

  @$pb.TagNumber(29)
  Req_ListAllTransactions get listAllTransactions => $_getN(13);
  @$pb.TagNumber(29)
  set listAllTransactions(Req_ListAllTransactions v) { setField(29, v); }
  @$pb.TagNumber(29)
  $core.bool hasListAllTransactions() => $_has(13);
  @$pb.TagNumber(29)
  void clearListAllTransactions() => clearField(29);
  @$pb.TagNumber(29)
  Req_ListAllTransactions ensureListAllTransactions() => $_ensure(13);

  @$pb.TagNumber(30)
  Req_ListOwnTransactions get listOwnTransactions => $_getN(14);
  @$pb.TagNumber(30)
  set listOwnTransactions(Req_ListOwnTransactions v) { setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasListOwnTransactions() => $_has(14);
  @$pb.TagNumber(30)
  void clearListOwnTransactions() => clearField(30);
  @$pb.TagNumber(30)
  Req_ListOwnTransactions ensureListOwnTransactions() => $_ensure(14);

  @$pb.TagNumber(31)
  Req_ListAllBalances get listAllBalances => $_getN(15);
  @$pb.TagNumber(31)
  set listAllBalances(Req_ListAllBalances v) { setField(31, v); }
  @$pb.TagNumber(31)
  $core.bool hasListAllBalances() => $_has(15);
  @$pb.TagNumber(31)
  void clearListAllBalances() => clearField(31);
  @$pb.TagNumber(31)
  Req_ListAllBalances ensureListAllBalances() => $_ensure(15);

  @$pb.TagNumber(32)
  Req_ListAllSeries get listAllSeries => $_getN(16);
  @$pb.TagNumber(32)
  set listAllSeries(Req_ListAllSeries v) { setField(32, v); }
  @$pb.TagNumber(32)
  $core.bool hasListAllSeries() => $_has(16);
  @$pb.TagNumber(32)
  void clearListAllSeries() => clearField(32);
  @$pb.TagNumber(32)
  Req_ListAllSeries ensureListAllSeries() => $_ensure(16);
}

class Resp_Login extends $pb.GeneratedMessage {
  factory Resp_Login({
    $core.String? requestId,
  }) {
    final $result = create();
    if (requestId != null) {
      $result.requestId = requestId;
    }
    return $result;
  }
  Resp_Login._() : super();
  factory Resp_Login.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_Login.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.Login', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'requestId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_Login clone() => Resp_Login()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_Login copyWith(void Function(Resp_Login) updates) => super.copyWith((message) => updates(message as Resp_Login)) as Resp_Login;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_Login create() => Resp_Login._();
  Resp_Login createEmptyInstance() => create();
  static $pb.PbList<Resp_Login> createRepeated() => $pb.PbList<Resp_Login>();
  @$core.pragma('dart2js:noInline')
  static Resp_Login getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_Login>(create);
  static Resp_Login? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => clearField(1);
}

class Resp_Register extends $pb.GeneratedMessage {
  factory Resp_Register({
    $core.String? requestId,
  }) {
    final $result = create();
    if (requestId != null) {
      $result.requestId = requestId;
    }
    return $result;
  }
  Resp_Register._() : super();
  factory Resp_Register.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_Register.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.Register', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'requestId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_Register clone() => Resp_Register()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_Register copyWith(void Function(Resp_Register) updates) => super.copyWith((message) => updates(message as Resp_Register)) as Resp_Register;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_Register create() => Resp_Register._();
  Resp_Register createEmptyInstance() => create();
  static $pb.PbList<Resp_Register> createRepeated() => $pb.PbList<Resp_Register>();
  @$core.pragma('dart2js:noInline')
  static Resp_Register getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_Register>(create);
  static Resp_Register? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => clearField(1);
}

class Resp_RegisterIssuer extends $pb.GeneratedMessage {
  factory Resp_RegisterIssuer() => create();
  Resp_RegisterIssuer._() : super();
  factory Resp_RegisterIssuer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_RegisterIssuer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.RegisterIssuer', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_RegisterIssuer clone() => Resp_RegisterIssuer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_RegisterIssuer copyWith(void Function(Resp_RegisterIssuer) updates) => super.copyWith((message) => updates(message as Resp_RegisterIssuer)) as Resp_RegisterIssuer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_RegisterIssuer create() => Resp_RegisterIssuer._();
  Resp_RegisterIssuer createEmptyInstance() => create();
  static $pb.PbList<Resp_RegisterIssuer> createRepeated() => $pb.PbList<Resp_RegisterIssuer>();
  @$core.pragma('dart2js:noInline')
  static Resp_RegisterIssuer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_RegisterIssuer>(create);
  static Resp_RegisterIssuer? _defaultInstance;
}

class Resp_Resume extends $pb.GeneratedMessage {
  factory Resp_Resume({
    Account? account,
    $core.Iterable<AccountKey>? accountKeys,
  }) {
    final $result = create();
    if (account != null) {
      $result.account = account;
    }
    if (accountKeys != null) {
      $result.accountKeys.addAll(accountKeys);
    }
    return $result;
  }
  Resp_Resume._() : super();
  factory Resp_Resume.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_Resume.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.Resume', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
    ..pc<AccountKey>(2, _omitFieldNames ? '' : 'accountKeys', $pb.PbFieldType.PM, subBuilder: AccountKey.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_Resume clone() => Resp_Resume()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_Resume copyWith(void Function(Resp_Resume) updates) => super.copyWith((message) => updates(message as Resp_Resume)) as Resp_Resume;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_Resume create() => Resp_Resume._();
  Resp_Resume createEmptyInstance() => create();
  static $pb.PbList<Resp_Resume> createRepeated() => $pb.PbList<Resp_Resume>();
  @$core.pragma('dart2js:noInline')
  static Resp_Resume getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_Resume>(create);
  static Resp_Resume? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<AccountKey> get accountKeys => $_getList(1);
}

class Resp_Logout extends $pb.GeneratedMessage {
  factory Resp_Logout() => create();
  Resp_Logout._() : super();
  factory Resp_Logout.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_Logout.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.Logout', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_Logout clone() => Resp_Logout()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_Logout copyWith(void Function(Resp_Logout) updates) => super.copyWith((message) => updates(message as Resp_Logout)) as Resp_Logout;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_Logout create() => Resp_Logout._();
  Resp_Logout createEmptyInstance() => create();
  static $pb.PbList<Resp_Logout> createRepeated() => $pb.PbList<Resp_Logout>();
  @$core.pragma('dart2js:noInline')
  static Resp_Logout getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_Logout>(create);
  static Resp_Logout? _defaultInstance;
}

class Resp_AddGaid extends $pb.GeneratedMessage {
  factory Resp_AddGaid({
    Account? account,
  }) {
    final $result = create();
    if (account != null) {
      $result.account = account;
    }
    return $result;
  }
  Resp_AddGaid._() : super();
  factory Resp_AddGaid.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_AddGaid.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.AddGaid', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQM<Account>(1, _omitFieldNames ? '' : 'account', subBuilder: Account.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_AddGaid clone() => Resp_AddGaid()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_AddGaid copyWith(void Function(Resp_AddGaid) updates) => super.copyWith((message) => updates(message as Resp_AddGaid)) as Resp_AddGaid;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_AddGaid create() => Resp_AddGaid._();
  Resp_AddGaid createEmptyInstance() => create();
  static $pb.PbList<Resp_AddGaid> createRepeated() => $pb.PbList<Resp_AddGaid>();
  @$core.pragma('dart2js:noInline')
  static Resp_AddGaid getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_AddGaid>(create);
  static Resp_AddGaid? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);
}

class Resp_LoadAssets extends $pb.GeneratedMessage {
  factory Resp_LoadAssets({
    $core.Iterable<Asset>? assets,
  }) {
    final $result = create();
    if (assets != null) {
      $result.assets.addAll(assets);
    }
    return $result;
  }
  Resp_LoadAssets._() : super();
  factory Resp_LoadAssets.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_LoadAssets.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.LoadAssets', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..pc<Asset>(1, _omitFieldNames ? '' : 'assets', $pb.PbFieldType.PM, subBuilder: Asset.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_LoadAssets clone() => Resp_LoadAssets()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_LoadAssets copyWith(void Function(Resp_LoadAssets) updates) => super.copyWith((message) => updates(message as Resp_LoadAssets)) as Resp_LoadAssets;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_LoadAssets create() => Resp_LoadAssets._();
  Resp_LoadAssets createEmptyInstance() => create();
  static $pb.PbList<Resp_LoadAssets> createRepeated() => $pb.PbList<Resp_LoadAssets>();
  @$core.pragma('dart2js:noInline')
  static Resp_LoadAssets getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_LoadAssets>(create);
  static Resp_LoadAssets? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Asset> get assets => $_getList(0);
}

class Resp_BuyShares extends $pb.GeneratedMessage {
  factory Resp_BuyShares({
    $core.String? orderId,
    $core.double? amount,
    $core.double? price,
    $core.double? bitcoinAmount,
  }) {
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (price != null) {
      $result.price = price;
    }
    if (bitcoinAmount != null) {
      $result.bitcoinAmount = bitcoinAmount;
    }
    return $result;
  }
  Resp_BuyShares._() : super();
  factory Resp_BuyShares.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_BuyShares.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.BuyShares', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'price', $pb.PbFieldType.QD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'bitcoinAmount', $pb.PbFieldType.QD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_BuyShares clone() => Resp_BuyShares()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_BuyShares copyWith(void Function(Resp_BuyShares) updates) => super.copyWith((message) => updates(message as Resp_BuyShares)) as Resp_BuyShares;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_BuyShares create() => Resp_BuyShares._();
  Resp_BuyShares createEmptyInstance() => create();
  static $pb.PbList<Resp_BuyShares> createRepeated() => $pb.PbList<Resp_BuyShares>();
  @$core.pragma('dart2js:noInline')
  static Resp_BuyShares getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_BuyShares>(create);
  static Resp_BuyShares? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get price => $_getN(2);
  @$pb.TagNumber(3)
  set price($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get bitcoinAmount => $_getN(3);
  @$pb.TagNumber(4)
  set bitcoinAmount($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBitcoinAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearBitcoinAmount() => clearField(4);
}

class Resp_LoadCountries extends $pb.GeneratedMessage {
  factory Resp_LoadCountries({
    $core.Iterable<$core.String>? list,
  }) {
    final $result = create();
    if (list != null) {
      $result.list.addAll(list);
    }
    return $result;
  }
  Resp_LoadCountries._() : super();
  factory Resp_LoadCountries.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_LoadCountries.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.LoadCountries', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'list')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_LoadCountries clone() => Resp_LoadCountries()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_LoadCountries copyWith(void Function(Resp_LoadCountries) updates) => super.copyWith((message) => updates(message as Resp_LoadCountries)) as Resp_LoadCountries;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_LoadCountries create() => Resp_LoadCountries._();
  Resp_LoadCountries createEmptyInstance() => create();
  static $pb.PbList<Resp_LoadCountries> createRepeated() => $pb.PbList<Resp_LoadCountries>();
  @$core.pragma('dart2js:noInline')
  static Resp_LoadCountries getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_LoadCountries>(create);
  static Resp_LoadCountries? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get list => $_getList(0);
}

class Resp_LoadRegs extends $pb.GeneratedMessage {
  factory Resp_LoadRegs({
    $core.Iterable<Account>? list,
  }) {
    final $result = create();
    if (list != null) {
      $result.list.addAll(list);
    }
    return $result;
  }
  Resp_LoadRegs._() : super();
  factory Resp_LoadRegs.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_LoadRegs.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.LoadRegs', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..pc<Account>(1, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: Account.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_LoadRegs clone() => Resp_LoadRegs()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_LoadRegs copyWith(void Function(Resp_LoadRegs) updates) => super.copyWith((message) => updates(message as Resp_LoadRegs)) as Resp_LoadRegs;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_LoadRegs create() => Resp_LoadRegs._();
  Resp_LoadRegs createEmptyInstance() => create();
  static $pb.PbList<Resp_LoadRegs> createRepeated() => $pb.PbList<Resp_LoadRegs>();
  @$core.pragma('dart2js:noInline')
  static Resp_LoadRegs getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_LoadRegs>(create);
  static Resp_LoadRegs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Account> get list => $_getList(0);
}

class Resp_LoadFile extends $pb.GeneratedMessage {
  factory Resp_LoadFile({
    $core.String? mimeType,
    $core.List<$core.int>? data,
  }) {
    final $result = create();
    if (mimeType != null) {
      $result.mimeType = mimeType;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  Resp_LoadFile._() : super();
  factory Resp_LoadFile.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_LoadFile.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.LoadFile', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'mimeType')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.QY)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_LoadFile clone() => Resp_LoadFile()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_LoadFile copyWith(void Function(Resp_LoadFile) updates) => super.copyWith((message) => updates(message as Resp_LoadFile)) as Resp_LoadFile;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_LoadFile create() => Resp_LoadFile._();
  Resp_LoadFile createEmptyInstance() => create();
  static $pb.PbList<Resp_LoadFile> createRepeated() => $pb.PbList<Resp_LoadFile>();
  @$core.pragma('dart2js:noInline')
  static Resp_LoadFile getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_LoadFile>(create);
  static Resp_LoadFile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mimeType => $_getSZ(0);
  @$pb.TagNumber(1)
  set mimeType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMimeType() => $_has(0);
  @$pb.TagNumber(1)
  void clearMimeType() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
}

class Resp_UpdateReg extends $pb.GeneratedMessage {
  factory Resp_UpdateReg() => create();
  Resp_UpdateReg._() : super();
  factory Resp_UpdateReg.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_UpdateReg.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.UpdateReg', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_UpdateReg clone() => Resp_UpdateReg()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_UpdateReg copyWith(void Function(Resp_UpdateReg) updates) => super.copyWith((message) => updates(message as Resp_UpdateReg)) as Resp_UpdateReg;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_UpdateReg create() => Resp_UpdateReg._();
  Resp_UpdateReg createEmptyInstance() => create();
  static $pb.PbList<Resp_UpdateReg> createRepeated() => $pb.PbList<Resp_UpdateReg>();
  @$core.pragma('dart2js:noInline')
  static Resp_UpdateReg getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_UpdateReg>(create);
  static Resp_UpdateReg? _defaultInstance;
}

class Resp_ListAllTransactions extends $pb.GeneratedMessage {
  factory Resp_ListAllTransactions({
    $core.Iterable<FullTransaction>? list,
  }) {
    final $result = create();
    if (list != null) {
      $result.list.addAll(list);
    }
    return $result;
  }
  Resp_ListAllTransactions._() : super();
  factory Resp_ListAllTransactions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_ListAllTransactions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.ListAllTransactions', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..pc<FullTransaction>(1, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: FullTransaction.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_ListAllTransactions clone() => Resp_ListAllTransactions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_ListAllTransactions copyWith(void Function(Resp_ListAllTransactions) updates) => super.copyWith((message) => updates(message as Resp_ListAllTransactions)) as Resp_ListAllTransactions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_ListAllTransactions create() => Resp_ListAllTransactions._();
  Resp_ListAllTransactions createEmptyInstance() => create();
  static $pb.PbList<Resp_ListAllTransactions> createRepeated() => $pb.PbList<Resp_ListAllTransactions>();
  @$core.pragma('dart2js:noInline')
  static Resp_ListAllTransactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_ListAllTransactions>(create);
  static Resp_ListAllTransactions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<FullTransaction> get list => $_getList(0);
}

class Resp_ListOwnTransactions extends $pb.GeneratedMessage {
  factory Resp_ListOwnTransactions({
    $core.Iterable<OwnTransaction>? list,
  }) {
    final $result = create();
    if (list != null) {
      $result.list.addAll(list);
    }
    return $result;
  }
  Resp_ListOwnTransactions._() : super();
  factory Resp_ListOwnTransactions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_ListOwnTransactions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.ListOwnTransactions', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..pc<OwnTransaction>(1, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: OwnTransaction.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_ListOwnTransactions clone() => Resp_ListOwnTransactions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_ListOwnTransactions copyWith(void Function(Resp_ListOwnTransactions) updates) => super.copyWith((message) => updates(message as Resp_ListOwnTransactions)) as Resp_ListOwnTransactions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_ListOwnTransactions create() => Resp_ListOwnTransactions._();
  Resp_ListOwnTransactions createEmptyInstance() => create();
  static $pb.PbList<Resp_ListOwnTransactions> createRepeated() => $pb.PbList<Resp_ListOwnTransactions>();
  @$core.pragma('dart2js:noInline')
  static Resp_ListOwnTransactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_ListOwnTransactions>(create);
  static Resp_ListOwnTransactions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<OwnTransaction> get list => $_getList(0);
}

class Resp_ListAllBalances extends $pb.GeneratedMessage {
  factory Resp_ListAllBalances({
    $core.Iterable<BalanceOwner>? list,
  }) {
    final $result = create();
    if (list != null) {
      $result.list.addAll(list);
    }
    return $result;
  }
  Resp_ListAllBalances._() : super();
  factory Resp_ListAllBalances.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_ListAllBalances.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.ListAllBalances', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..pc<BalanceOwner>(1, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: BalanceOwner.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_ListAllBalances clone() => Resp_ListAllBalances()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_ListAllBalances copyWith(void Function(Resp_ListAllBalances) updates) => super.copyWith((message) => updates(message as Resp_ListAllBalances)) as Resp_ListAllBalances;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_ListAllBalances create() => Resp_ListAllBalances._();
  Resp_ListAllBalances createEmptyInstance() => create();
  static $pb.PbList<Resp_ListAllBalances> createRepeated() => $pb.PbList<Resp_ListAllBalances>();
  @$core.pragma('dart2js:noInline')
  static Resp_ListAllBalances getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_ListAllBalances>(create);
  static Resp_ListAllBalances? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<BalanceOwner> get list => $_getList(0);
}

class Resp_ListAllSeries extends $pb.GeneratedMessage {
  factory Resp_ListAllSeries({
    $core.Iterable<SerieOwner>? list,
    $core.String? csv,
  }) {
    final $result = create();
    if (list != null) {
      $result.list.addAll(list);
    }
    if (csv != null) {
      $result.csv = csv;
    }
    return $result;
  }
  Resp_ListAllSeries._() : super();
  factory Resp_ListAllSeries.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp_ListAllSeries.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp.ListAllSeries', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..pc<SerieOwner>(1, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: SerieOwner.create)
    ..aQS(2, _omitFieldNames ? '' : 'csv')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp_ListAllSeries clone() => Resp_ListAllSeries()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp_ListAllSeries copyWith(void Function(Resp_ListAllSeries) updates) => super.copyWith((message) => updates(message as Resp_ListAllSeries)) as Resp_ListAllSeries;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp_ListAllSeries create() => Resp_ListAllSeries._();
  Resp_ListAllSeries createEmptyInstance() => create();
  static $pb.PbList<Resp_ListAllSeries> createRepeated() => $pb.PbList<Resp_ListAllSeries>();
  @$core.pragma('dart2js:noInline')
  static Resp_ListAllSeries getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp_ListAllSeries>(create);
  static Resp_ListAllSeries? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SerieOwner> get list => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get csv => $_getSZ(1);
  @$pb.TagNumber(2)
  set csv($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCsv() => $_has(1);
  @$pb.TagNumber(2)
  void clearCsv() => clearField(2);
}

enum Resp_Body {
  login, 
  register, 
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
    Resp_Login? login,
    Resp_Register? register,
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
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (login != null) {
      $result.login = login;
    }
    if (register != null) {
      $result.register = register;
    }
    if (resume != null) {
      $result.resume = resume;
    }
    if (logout != null) {
      $result.logout = logout;
    }
    if (registerIssuer != null) {
      $result.registerIssuer = registerIssuer;
    }
    if (addGaid != null) {
      $result.addGaid = addGaid;
    }
    if (loadAssets != null) {
      $result.loadAssets = loadAssets;
    }
    if (buyShares != null) {
      $result.buyShares = buyShares;
    }
    if (loadCountries != null) {
      $result.loadCountries = loadCountries;
    }
    if (loadRegs != null) {
      $result.loadRegs = loadRegs;
    }
    if (updateReg != null) {
      $result.updateReg = updateReg;
    }
    if (loadFile != null) {
      $result.loadFile = loadFile;
    }
    if (listAllTransactions != null) {
      $result.listAllTransactions = listAllTransactions;
    }
    if (listOwnTransactions != null) {
      $result.listOwnTransactions = listOwnTransactions;
    }
    if (listAllBalances != null) {
      $result.listAllBalances = listAllBalances;
    }
    if (listAllSeries != null) {
      $result.listAllSeries = listAllSeries;
    }
    return $result;
  }
  Resp._() : super();
  factory Resp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Resp_Body> _Resp_BodyByTag = {
    10 : Resp_Body.login,
    11 : Resp_Body.register,
    12 : Resp_Body.resume,
    13 : Resp_Body.logout,
    14 : Resp_Body.registerIssuer,
    20 : Resp_Body.addGaid,
    21 : Resp_Body.loadAssets,
    24 : Resp_Body.buyShares,
    25 : Resp_Body.loadCountries,
    26 : Resp_Body.loadRegs,
    27 : Resp_Body.updateReg,
    28 : Resp_Body.loadFile,
    29 : Resp_Body.listAllTransactions,
    30 : Resp_Body.listOwnTransactions,
    31 : Resp_Body.listAllBalances,
    32 : Resp_Body.listAllSeries,
    0 : Resp_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Resp', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13, 14, 20, 21, 24, 25, 26, 27, 28, 29, 30, 31, 32])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<Resp_Login>(10, _omitFieldNames ? '' : 'login', subBuilder: Resp_Login.create)
    ..aOM<Resp_Register>(11, _omitFieldNames ? '' : 'register', subBuilder: Resp_Register.create)
    ..aOM<Resp_Resume>(12, _omitFieldNames ? '' : 'resume', subBuilder: Resp_Resume.create)
    ..aOM<Resp_Logout>(13, _omitFieldNames ? '' : 'logout', subBuilder: Resp_Logout.create)
    ..aOM<Resp_RegisterIssuer>(14, _omitFieldNames ? '' : 'registerIssuer', subBuilder: Resp_RegisterIssuer.create)
    ..aOM<Resp_AddGaid>(20, _omitFieldNames ? '' : 'addGaid', subBuilder: Resp_AddGaid.create)
    ..aOM<Resp_LoadAssets>(21, _omitFieldNames ? '' : 'loadAssets', subBuilder: Resp_LoadAssets.create)
    ..aOM<Resp_BuyShares>(24, _omitFieldNames ? '' : 'buyShares', subBuilder: Resp_BuyShares.create)
    ..aOM<Resp_LoadCountries>(25, _omitFieldNames ? '' : 'loadCountries', subBuilder: Resp_LoadCountries.create)
    ..aOM<Resp_LoadRegs>(26, _omitFieldNames ? '' : 'loadRegs', subBuilder: Resp_LoadRegs.create)
    ..aOM<Resp_UpdateReg>(27, _omitFieldNames ? '' : 'updateReg', subBuilder: Resp_UpdateReg.create)
    ..aOM<Resp_LoadFile>(28, _omitFieldNames ? '' : 'loadFile', subBuilder: Resp_LoadFile.create)
    ..aOM<Resp_ListAllTransactions>(29, _omitFieldNames ? '' : 'listAllTransactions', subBuilder: Resp_ListAllTransactions.create)
    ..aOM<Resp_ListOwnTransactions>(30, _omitFieldNames ? '' : 'listOwnTransactions', subBuilder: Resp_ListOwnTransactions.create)
    ..aOM<Resp_ListAllBalances>(31, _omitFieldNames ? '' : 'listAllBalances', subBuilder: Resp_ListAllBalances.create)
    ..aOM<Resp_ListAllSeries>(32, _omitFieldNames ? '' : 'listAllSeries', subBuilder: Resp_ListAllSeries.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resp clone() => Resp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resp copyWith(void Function(Resp) updates) => super.copyWith((message) => updates(message as Resp)) as Resp;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resp create() => Resp._();
  Resp createEmptyInstance() => create();
  static $pb.PbList<Resp> createRepeated() => $pb.PbList<Resp>();
  @$core.pragma('dart2js:noInline')
  static Resp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resp>(create);
  static Resp? _defaultInstance;

  Resp_Body whichBody() => _Resp_BodyByTag[$_whichOneof(0)]!;
  void clearBody() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(10)
  Resp_Login get login => $_getN(1);
  @$pb.TagNumber(10)
  set login(Resp_Login v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasLogin() => $_has(1);
  @$pb.TagNumber(10)
  void clearLogin() => clearField(10);
  @$pb.TagNumber(10)
  Resp_Login ensureLogin() => $_ensure(1);

  @$pb.TagNumber(11)
  Resp_Register get register => $_getN(2);
  @$pb.TagNumber(11)
  set register(Resp_Register v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasRegister() => $_has(2);
  @$pb.TagNumber(11)
  void clearRegister() => clearField(11);
  @$pb.TagNumber(11)
  Resp_Register ensureRegister() => $_ensure(2);

  @$pb.TagNumber(12)
  Resp_Resume get resume => $_getN(3);
  @$pb.TagNumber(12)
  set resume(Resp_Resume v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasResume() => $_has(3);
  @$pb.TagNumber(12)
  void clearResume() => clearField(12);
  @$pb.TagNumber(12)
  Resp_Resume ensureResume() => $_ensure(3);

  @$pb.TagNumber(13)
  Resp_Logout get logout => $_getN(4);
  @$pb.TagNumber(13)
  set logout(Resp_Logout v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasLogout() => $_has(4);
  @$pb.TagNumber(13)
  void clearLogout() => clearField(13);
  @$pb.TagNumber(13)
  Resp_Logout ensureLogout() => $_ensure(4);

  @$pb.TagNumber(14)
  Resp_RegisterIssuer get registerIssuer => $_getN(5);
  @$pb.TagNumber(14)
  set registerIssuer(Resp_RegisterIssuer v) { setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasRegisterIssuer() => $_has(5);
  @$pb.TagNumber(14)
  void clearRegisterIssuer() => clearField(14);
  @$pb.TagNumber(14)
  Resp_RegisterIssuer ensureRegisterIssuer() => $_ensure(5);

  @$pb.TagNumber(20)
  Resp_AddGaid get addGaid => $_getN(6);
  @$pb.TagNumber(20)
  set addGaid(Resp_AddGaid v) { setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasAddGaid() => $_has(6);
  @$pb.TagNumber(20)
  void clearAddGaid() => clearField(20);
  @$pb.TagNumber(20)
  Resp_AddGaid ensureAddGaid() => $_ensure(6);

  @$pb.TagNumber(21)
  Resp_LoadAssets get loadAssets => $_getN(7);
  @$pb.TagNumber(21)
  set loadAssets(Resp_LoadAssets v) { setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasLoadAssets() => $_has(7);
  @$pb.TagNumber(21)
  void clearLoadAssets() => clearField(21);
  @$pb.TagNumber(21)
  Resp_LoadAssets ensureLoadAssets() => $_ensure(7);

  @$pb.TagNumber(24)
  Resp_BuyShares get buyShares => $_getN(8);
  @$pb.TagNumber(24)
  set buyShares(Resp_BuyShares v) { setField(24, v); }
  @$pb.TagNumber(24)
  $core.bool hasBuyShares() => $_has(8);
  @$pb.TagNumber(24)
  void clearBuyShares() => clearField(24);
  @$pb.TagNumber(24)
  Resp_BuyShares ensureBuyShares() => $_ensure(8);

  @$pb.TagNumber(25)
  Resp_LoadCountries get loadCountries => $_getN(9);
  @$pb.TagNumber(25)
  set loadCountries(Resp_LoadCountries v) { setField(25, v); }
  @$pb.TagNumber(25)
  $core.bool hasLoadCountries() => $_has(9);
  @$pb.TagNumber(25)
  void clearLoadCountries() => clearField(25);
  @$pb.TagNumber(25)
  Resp_LoadCountries ensureLoadCountries() => $_ensure(9);

  @$pb.TagNumber(26)
  Resp_LoadRegs get loadRegs => $_getN(10);
  @$pb.TagNumber(26)
  set loadRegs(Resp_LoadRegs v) { setField(26, v); }
  @$pb.TagNumber(26)
  $core.bool hasLoadRegs() => $_has(10);
  @$pb.TagNumber(26)
  void clearLoadRegs() => clearField(26);
  @$pb.TagNumber(26)
  Resp_LoadRegs ensureLoadRegs() => $_ensure(10);

  @$pb.TagNumber(27)
  Resp_UpdateReg get updateReg => $_getN(11);
  @$pb.TagNumber(27)
  set updateReg(Resp_UpdateReg v) { setField(27, v); }
  @$pb.TagNumber(27)
  $core.bool hasUpdateReg() => $_has(11);
  @$pb.TagNumber(27)
  void clearUpdateReg() => clearField(27);
  @$pb.TagNumber(27)
  Resp_UpdateReg ensureUpdateReg() => $_ensure(11);

  @$pb.TagNumber(28)
  Resp_LoadFile get loadFile => $_getN(12);
  @$pb.TagNumber(28)
  set loadFile(Resp_LoadFile v) { setField(28, v); }
  @$pb.TagNumber(28)
  $core.bool hasLoadFile() => $_has(12);
  @$pb.TagNumber(28)
  void clearLoadFile() => clearField(28);
  @$pb.TagNumber(28)
  Resp_LoadFile ensureLoadFile() => $_ensure(12);

  @$pb.TagNumber(29)
  Resp_ListAllTransactions get listAllTransactions => $_getN(13);
  @$pb.TagNumber(29)
  set listAllTransactions(Resp_ListAllTransactions v) { setField(29, v); }
  @$pb.TagNumber(29)
  $core.bool hasListAllTransactions() => $_has(13);
  @$pb.TagNumber(29)
  void clearListAllTransactions() => clearField(29);
  @$pb.TagNumber(29)
  Resp_ListAllTransactions ensureListAllTransactions() => $_ensure(13);

  @$pb.TagNumber(30)
  Resp_ListOwnTransactions get listOwnTransactions => $_getN(14);
  @$pb.TagNumber(30)
  set listOwnTransactions(Resp_ListOwnTransactions v) { setField(30, v); }
  @$pb.TagNumber(30)
  $core.bool hasListOwnTransactions() => $_has(14);
  @$pb.TagNumber(30)
  void clearListOwnTransactions() => clearField(30);
  @$pb.TagNumber(30)
  Resp_ListOwnTransactions ensureListOwnTransactions() => $_ensure(14);

  @$pb.TagNumber(31)
  Resp_ListAllBalances get listAllBalances => $_getN(15);
  @$pb.TagNumber(31)
  set listAllBalances(Resp_ListAllBalances v) { setField(31, v); }
  @$pb.TagNumber(31)
  $core.bool hasListAllBalances() => $_has(15);
  @$pb.TagNumber(31)
  void clearListAllBalances() => clearField(31);
  @$pb.TagNumber(31)
  Resp_ListAllBalances ensureListAllBalances() => $_ensure(15);

  @$pb.TagNumber(32)
  Resp_ListAllSeries get listAllSeries => $_getN(16);
  @$pb.TagNumber(32)
  set listAllSeries(Resp_ListAllSeries v) { setField(32, v); }
  @$pb.TagNumber(32)
  $core.bool hasListAllSeries() => $_has(16);
  @$pb.TagNumber(32)
  void clearListAllSeries() => clearField(32);
  @$pb.TagNumber(32)
  Resp_ListAllSeries ensureListAllSeries() => $_ensure(16);
}

class Notif_LoginFailed extends $pb.GeneratedMessage {
  factory Notif_LoginFailed({
    $core.String? text,
  }) {
    final $result = create();
    if (text != null) {
      $result.text = text;
    }
    return $result;
  }
  Notif_LoginFailed._() : super();
  factory Notif_LoginFailed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_LoginFailed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.LoginFailed', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'text')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_LoginFailed clone() => Notif_LoginFailed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_LoginFailed copyWith(void Function(Notif_LoginFailed) updates) => super.copyWith((message) => updates(message as Notif_LoginFailed)) as Notif_LoginFailed;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_LoginFailed create() => Notif_LoginFailed._();
  Notif_LoginFailed createEmptyInstance() => create();
  static $pb.PbList<Notif_LoginFailed> createRepeated() => $pb.PbList<Notif_LoginFailed>();
  @$core.pragma('dart2js:noInline')
  static Notif_LoginFailed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_LoginFailed>(create);
  static Notif_LoginFailed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);
}

class Notif_LoginSucceed extends $pb.GeneratedMessage {
  factory Notif_LoginSucceed({
    $core.String? token,
    $core.String? accountKey,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (accountKey != null) {
      $result.accountKey = accountKey;
    }
    return $result;
  }
  Notif_LoginSucceed._() : super();
  factory Notif_LoginSucceed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_LoginSucceed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.LoginSucceed', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'token')
    ..aQS(2, _omitFieldNames ? '' : 'accountKey')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_LoginSucceed clone() => Notif_LoginSucceed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_LoginSucceed copyWith(void Function(Notif_LoginSucceed) updates) => super.copyWith((message) => updates(message as Notif_LoginSucceed)) as Notif_LoginSucceed;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_LoginSucceed create() => Notif_LoginSucceed._();
  Notif_LoginSucceed createEmptyInstance() => create();
  static $pb.PbList<Notif_LoginSucceed> createRepeated() => $pb.PbList<Notif_LoginSucceed>();
  @$core.pragma('dart2js:noInline')
  static Notif_LoginSucceed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_LoginSucceed>(create);
  static Notif_LoginSucceed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAccountKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountKey() => clearField(2);
}

class Notif_EidResponse extends $pb.GeneratedMessage {
  factory Notif_EidResponse({
    $core.String? requestId,
  }) {
    final $result = create();
    if (requestId != null) {
      $result.requestId = requestId;
    }
    return $result;
  }
  Notif_EidResponse._() : super();
  factory Notif_EidResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_EidResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.EidResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'requestId')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_EidResponse clone() => Notif_EidResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_EidResponse copyWith(void Function(Notif_EidResponse) updates) => super.copyWith((message) => updates(message as Notif_EidResponse)) as Notif_EidResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_EidResponse create() => Notif_EidResponse._();
  Notif_EidResponse createEmptyInstance() => create();
  static $pb.PbList<Notif_EidResponse> createRepeated() => $pb.PbList<Notif_EidResponse>();
  @$core.pragma('dart2js:noInline')
  static Notif_EidResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_EidResponse>(create);
  static Notif_EidResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => clearField(1);
}

class Notif_RegisterFailed extends $pb.GeneratedMessage {
  factory Notif_RegisterFailed({
    $core.String? text,
  }) {
    final $result = create();
    if (text != null) {
      $result.text = text;
    }
    return $result;
  }
  Notif_RegisterFailed._() : super();
  factory Notif_RegisterFailed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_RegisterFailed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.RegisterFailed', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'text')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_RegisterFailed clone() => Notif_RegisterFailed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_RegisterFailed copyWith(void Function(Notif_RegisterFailed) updates) => super.copyWith((message) => updates(message as Notif_RegisterFailed)) as Notif_RegisterFailed;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_RegisterFailed create() => Notif_RegisterFailed._();
  Notif_RegisterFailed createEmptyInstance() => create();
  static $pb.PbList<Notif_RegisterFailed> createRepeated() => $pb.PbList<Notif_RegisterFailed>();
  @$core.pragma('dart2js:noInline')
  static Notif_RegisterFailed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_RegisterFailed>(create);
  static Notif_RegisterFailed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => clearField(1);
}

class Notif_RegisterSucceed extends $pb.GeneratedMessage {
  factory Notif_RegisterSucceed({
    $core.String? token,
    $core.String? accountKey,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (accountKey != null) {
      $result.accountKey = accountKey;
    }
    return $result;
  }
  Notif_RegisterSucceed._() : super();
  factory Notif_RegisterSucceed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_RegisterSucceed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.RegisterSucceed', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'token')
    ..aQS(2, _omitFieldNames ? '' : 'accountKey')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_RegisterSucceed clone() => Notif_RegisterSucceed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_RegisterSucceed copyWith(void Function(Notif_RegisterSucceed) updates) => super.copyWith((message) => updates(message as Notif_RegisterSucceed)) as Notif_RegisterSucceed;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_RegisterSucceed create() => Notif_RegisterSucceed._();
  Notif_RegisterSucceed createEmptyInstance() => create();
  static $pb.PbList<Notif_RegisterSucceed> createRepeated() => $pb.PbList<Notif_RegisterSucceed>();
  @$core.pragma('dart2js:noInline')
  static Notif_RegisterSucceed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_RegisterSucceed>(create);
  static Notif_RegisterSucceed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAccountKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountKey() => clearField(2);
}

class Notif_FreeShares extends $pb.GeneratedMessage {
  factory Notif_FreeShares({
    Shares? freeShares,
    $core.String? name,
    $fixnum.Int64? amount,
  }) {
    final $result = create();
    if (freeShares != null) {
      $result.freeShares = freeShares;
    }
    if (name != null) {
      $result.name = name;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    return $result;
  }
  Notif_FreeShares._() : super();
  factory Notif_FreeShares.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_FreeShares.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.FreeShares', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQM<Shares>(1, _omitFieldNames ? '' : 'freeShares', subBuilder: Shares.create)
    ..aQS(2, _omitFieldNames ? '' : 'name')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.Q6, defaultOrMaker: $fixnum.Int64.ZERO)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_FreeShares clone() => Notif_FreeShares()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_FreeShares copyWith(void Function(Notif_FreeShares) updates) => super.copyWith((message) => updates(message as Notif_FreeShares)) as Notif_FreeShares;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_FreeShares create() => Notif_FreeShares._();
  Notif_FreeShares createEmptyInstance() => create();
  static $pb.PbList<Notif_FreeShares> createRepeated() => $pb.PbList<Notif_FreeShares>();
  @$core.pragma('dart2js:noInline')
  static Notif_FreeShares getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_FreeShares>(create);
  static Notif_FreeShares? _defaultInstance;

  @$pb.TagNumber(1)
  Shares get freeShares => $_getN(0);
  @$pb.TagNumber(1)
  set freeShares(Shares v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFreeShares() => $_has(0);
  @$pb.TagNumber(1)
  void clearFreeShares() => clearField(1);
  @$pb.TagNumber(1)
  Shares ensureFreeShares() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get amount => $_getI64(2);
  @$pb.TagNumber(3)
  set amount($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);
}

class Notif_SoldShares extends $pb.GeneratedMessage {
  factory Notif_SoldShares({
    Shares? soldShares,
  }) {
    final $result = create();
    if (soldShares != null) {
      $result.soldShares = soldShares;
    }
    return $result;
  }
  Notif_SoldShares._() : super();
  factory Notif_SoldShares.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_SoldShares.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.SoldShares', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQM<Shares>(1, _omitFieldNames ? '' : 'soldShares', subBuilder: Shares.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_SoldShares clone() => Notif_SoldShares()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_SoldShares copyWith(void Function(Notif_SoldShares) updates) => super.copyWith((message) => updates(message as Notif_SoldShares)) as Notif_SoldShares;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_SoldShares create() => Notif_SoldShares._();
  Notif_SoldShares createEmptyInstance() => create();
  static $pb.PbList<Notif_SoldShares> createRepeated() => $pb.PbList<Notif_SoldShares>();
  @$core.pragma('dart2js:noInline')
  static Notif_SoldShares getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_SoldShares>(create);
  static Notif_SoldShares? _defaultInstance;

  @$pb.TagNumber(1)
  Shares get soldShares => $_getN(0);
  @$pb.TagNumber(1)
  set soldShares(Shares v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSoldShares() => $_has(0);
  @$pb.TagNumber(1)
  void clearSoldShares() => clearField(1);
  @$pb.TagNumber(1)
  Shares ensureSoldShares() => $_ensure(0);
}

class Notif_UserShares extends $pb.GeneratedMessage {
  factory Notif_UserShares({
    Shares? boughtShares,
  }) {
    final $result = create();
    if (boughtShares != null) {
      $result.boughtShares = boughtShares;
    }
    return $result;
  }
  Notif_UserShares._() : super();
  factory Notif_UserShares.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_UserShares.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.UserShares', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQM<Shares>(1, _omitFieldNames ? '' : 'boughtShares', subBuilder: Shares.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_UserShares clone() => Notif_UserShares()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_UserShares copyWith(void Function(Notif_UserShares) updates) => super.copyWith((message) => updates(message as Notif_UserShares)) as Notif_UserShares;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_UserShares create() => Notif_UserShares._();
  Notif_UserShares createEmptyInstance() => create();
  static $pb.PbList<Notif_UserShares> createRepeated() => $pb.PbList<Notif_UserShares>();
  @$core.pragma('dart2js:noInline')
  static Notif_UserShares getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_UserShares>(create);
  static Notif_UserShares? _defaultInstance;

  @$pb.TagNumber(1)
  Shares get boughtShares => $_getN(0);
  @$pb.TagNumber(1)
  set boughtShares(Shares v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBoughtShares() => $_has(0);
  @$pb.TagNumber(1)
  void clearBoughtShares() => clearField(1);
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
    final $result = create();
    if (orderId != null) {
      $result.orderId = orderId;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (price != null) {
      $result.price = price;
    }
    if (bitcoinAmount != null) {
      $result.bitcoinAmount = bitcoinAmount;
    }
    if (txid != null) {
      $result.txid = txid;
    }
    return $result;
  }
  Notif_BuyShares._() : super();
  factory Notif_BuyShares.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_BuyShares.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.BuyShares', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'orderId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.QD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'price', $pb.PbFieldType.QD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'bitcoinAmount', $pb.PbFieldType.QD)
    ..aOS(5, _omitFieldNames ? '' : 'txid')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_BuyShares clone() => Notif_BuyShares()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_BuyShares copyWith(void Function(Notif_BuyShares) updates) => super.copyWith((message) => updates(message as Notif_BuyShares)) as Notif_BuyShares;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_BuyShares create() => Notif_BuyShares._();
  Notif_BuyShares createEmptyInstance() => create();
  static $pb.PbList<Notif_BuyShares> createRepeated() => $pb.PbList<Notif_BuyShares>();
  @$core.pragma('dart2js:noInline')
  static Notif_BuyShares getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_BuyShares>(create);
  static Notif_BuyShares? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get price => $_getN(2);
  @$pb.TagNumber(3)
  set price($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get bitcoinAmount => $_getN(3);
  @$pb.TagNumber(4)
  set bitcoinAmount($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBitcoinAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearBitcoinAmount() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get txid => $_getSZ(4);
  @$pb.TagNumber(5)
  set txid($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTxid() => $_has(4);
  @$pb.TagNumber(5)
  void clearTxid() => clearField(5);
}

class Notif_UpdatePrices extends $pb.GeneratedMessage {
  factory Notif_UpdatePrices({
    $core.double? bitcoinUsdPrice,
  }) {
    final $result = create();
    if (bitcoinUsdPrice != null) {
      $result.bitcoinUsdPrice = bitcoinUsdPrice;
    }
    return $result;
  }
  Notif_UpdatePrices._() : super();
  factory Notif_UpdatePrices.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_UpdatePrices.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.UpdatePrices', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'bitcoinUsdPrice', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_UpdatePrices clone() => Notif_UpdatePrices()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_UpdatePrices copyWith(void Function(Notif_UpdatePrices) updates) => super.copyWith((message) => updates(message as Notif_UpdatePrices)) as Notif_UpdatePrices;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_UpdatePrices create() => Notif_UpdatePrices._();
  Notif_UpdatePrices createEmptyInstance() => create();
  static $pb.PbList<Notif_UpdatePrices> createRepeated() => $pb.PbList<Notif_UpdatePrices>();
  @$core.pragma('dart2js:noInline')
  static Notif_UpdatePrices getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_UpdatePrices>(create);
  static Notif_UpdatePrices? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get bitcoinUsdPrice => $_getN(0);
  @$pb.TagNumber(1)
  set bitcoinUsdPrice($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBitcoinUsdPrice() => $_has(0);
  @$pb.TagNumber(1)
  void clearBitcoinUsdPrice() => clearField(1);
}

class Notif_UpdateMarketData_Data extends $pb.GeneratedMessage {
  factory Notif_UpdateMarketData_Data({
    $core.String? assetId,
    $core.double? lastPrice,
    $core.double? volume30d,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (lastPrice != null) {
      $result.lastPrice = lastPrice;
    }
    if (volume30d != null) {
      $result.volume30d = volume30d;
    }
    return $result;
  }
  Notif_UpdateMarketData_Data._() : super();
  factory Notif_UpdateMarketData_Data.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_UpdateMarketData_Data.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.UpdateMarketData.Data', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'lastPrice', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'volume30d', $pb.PbFieldType.OD, protoName: 'volume_30d')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_UpdateMarketData_Data clone() => Notif_UpdateMarketData_Data()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_UpdateMarketData_Data copyWith(void Function(Notif_UpdateMarketData_Data) updates) => super.copyWith((message) => updates(message as Notif_UpdateMarketData_Data)) as Notif_UpdateMarketData_Data;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_UpdateMarketData_Data create() => Notif_UpdateMarketData_Data._();
  Notif_UpdateMarketData_Data createEmptyInstance() => create();
  static $pb.PbList<Notif_UpdateMarketData_Data> createRepeated() => $pb.PbList<Notif_UpdateMarketData_Data>();
  @$core.pragma('dart2js:noInline')
  static Notif_UpdateMarketData_Data getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_UpdateMarketData_Data>(create);
  static Notif_UpdateMarketData_Data? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get lastPrice => $_getN(1);
  @$pb.TagNumber(2)
  set lastPrice($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLastPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastPrice() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get volume30d => $_getN(2);
  @$pb.TagNumber(3)
  set volume30d($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVolume30d() => $_has(2);
  @$pb.TagNumber(3)
  void clearVolume30d() => clearField(3);
}

class Notif_UpdateMarketData extends $pb.GeneratedMessage {
  factory Notif_UpdateMarketData({
    $core.Iterable<Notif_UpdateMarketData_Data>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  Notif_UpdateMarketData._() : super();
  factory Notif_UpdateMarketData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_UpdateMarketData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.UpdateMarketData', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..pc<Notif_UpdateMarketData_Data>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: Notif_UpdateMarketData_Data.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_UpdateMarketData clone() => Notif_UpdateMarketData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_UpdateMarketData copyWith(void Function(Notif_UpdateMarketData) updates) => super.copyWith((message) => updates(message as Notif_UpdateMarketData)) as Notif_UpdateMarketData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_UpdateMarketData create() => Notif_UpdateMarketData._();
  Notif_UpdateMarketData createEmptyInstance() => create();
  static $pb.PbList<Notif_UpdateMarketData> createRepeated() => $pb.PbList<Notif_UpdateMarketData>();
  @$core.pragma('dart2js:noInline')
  static Notif_UpdateMarketData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_UpdateMarketData>(create);
  static Notif_UpdateMarketData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Notif_UpdateMarketData_Data> get data => $_getList(0);
}

class Notif_IssuedAmounts_Asset extends $pb.GeneratedMessage {
  factory Notif_IssuedAmounts_Asset({
    $core.String? assetId,
    $core.double? online,
    $core.double? offline,
  }) {
    final $result = create();
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (online != null) {
      $result.online = online;
    }
    if (offline != null) {
      $result.offline = offline;
    }
    return $result;
  }
  Notif_IssuedAmounts_Asset._() : super();
  factory Notif_IssuedAmounts_Asset.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_IssuedAmounts_Asset.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.IssuedAmounts.Asset', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'assetId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'online', $pb.PbFieldType.QD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'offline', $pb.PbFieldType.QD)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_IssuedAmounts_Asset clone() => Notif_IssuedAmounts_Asset()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_IssuedAmounts_Asset copyWith(void Function(Notif_IssuedAmounts_Asset) updates) => super.copyWith((message) => updates(message as Notif_IssuedAmounts_Asset)) as Notif_IssuedAmounts_Asset;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_IssuedAmounts_Asset create() => Notif_IssuedAmounts_Asset._();
  Notif_IssuedAmounts_Asset createEmptyInstance() => create();
  static $pb.PbList<Notif_IssuedAmounts_Asset> createRepeated() => $pb.PbList<Notif_IssuedAmounts_Asset>();
  @$core.pragma('dart2js:noInline')
  static Notif_IssuedAmounts_Asset getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_IssuedAmounts_Asset>(create);
  static Notif_IssuedAmounts_Asset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get online => $_getN(1);
  @$pb.TagNumber(2)
  set online($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOnline() => $_has(1);
  @$pb.TagNumber(2)
  void clearOnline() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get offline => $_getN(2);
  @$pb.TagNumber(3)
  set offline($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOffline() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffline() => clearField(3);
}

class Notif_IssuedAmounts extends $pb.GeneratedMessage {
  factory Notif_IssuedAmounts({
    $core.Iterable<Notif_IssuedAmounts_Asset>? assets,
  }) {
    final $result = create();
    if (assets != null) {
      $result.assets.addAll(assets);
    }
    return $result;
  }
  Notif_IssuedAmounts._() : super();
  factory Notif_IssuedAmounts.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_IssuedAmounts.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.IssuedAmounts', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..pc<Notif_IssuedAmounts_Asset>(1, _omitFieldNames ? '' : 'assets', $pb.PbFieldType.PM, subBuilder: Notif_IssuedAmounts_Asset.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_IssuedAmounts clone() => Notif_IssuedAmounts()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_IssuedAmounts copyWith(void Function(Notif_IssuedAmounts) updates) => super.copyWith((message) => updates(message as Notif_IssuedAmounts)) as Notif_IssuedAmounts;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_IssuedAmounts create() => Notif_IssuedAmounts._();
  Notif_IssuedAmounts createEmptyInstance() => create();
  static $pb.PbList<Notif_IssuedAmounts> createRepeated() => $pb.PbList<Notif_IssuedAmounts>();
  @$core.pragma('dart2js:noInline')
  static Notif_IssuedAmounts getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_IssuedAmounts>(create);
  static Notif_IssuedAmounts? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Notif_IssuedAmounts_Asset> get assets => $_getList(0);
}

class Notif_UpdateBalances extends $pb.GeneratedMessage {
  factory Notif_UpdateBalances({
    $core.String? accountKey,
    $core.Iterable<Balance>? balances,
  }) {
    final $result = create();
    if (accountKey != null) {
      $result.accountKey = accountKey;
    }
    if (balances != null) {
      $result.balances.addAll(balances);
    }
    return $result;
  }
  Notif_UpdateBalances._() : super();
  factory Notif_UpdateBalances.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif_UpdateBalances.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif.UpdateBalances', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aQS(1, _omitFieldNames ? '' : 'accountKey')
    ..pc<Balance>(2, _omitFieldNames ? '' : 'balances', $pb.PbFieldType.PM, subBuilder: Balance.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif_UpdateBalances clone() => Notif_UpdateBalances()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif_UpdateBalances copyWith(void Function(Notif_UpdateBalances) updates) => super.copyWith((message) => updates(message as Notif_UpdateBalances)) as Notif_UpdateBalances;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif_UpdateBalances create() => Notif_UpdateBalances._();
  Notif_UpdateBalances createEmptyInstance() => create();
  static $pb.PbList<Notif_UpdateBalances> createRepeated() => $pb.PbList<Notif_UpdateBalances>();
  @$core.pragma('dart2js:noInline')
  static Notif_UpdateBalances getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif_UpdateBalances>(create);
  static Notif_UpdateBalances? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccountKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<Balance> get balances => $_getList(1);
}

enum Notif_Body {
  loginFailed, 
  loginSucceed, 
  registerFailed, 
  registerSucceed, 
  freeShares, 
  buyShares, 
  soldShares, 
  userShares, 
  updatePrices, 
  updateMarketData, 
  issuedAmounts, 
  updateBalances, 
  eidResponse, 
  notSet
}

class Notif extends $pb.GeneratedMessage {
  factory Notif({
    Notif_LoginFailed? loginFailed,
    Notif_LoginSucceed? loginSucceed,
    Notif_RegisterFailed? registerFailed,
    Notif_RegisterSucceed? registerSucceed,
    Notif_FreeShares? freeShares,
    Notif_BuyShares? buyShares,
    Notif_SoldShares? soldShares,
    Notif_UserShares? userShares,
    Notif_UpdatePrices? updatePrices,
    Notif_UpdateMarketData? updateMarketData,
    Notif_IssuedAmounts? issuedAmounts,
    Notif_UpdateBalances? updateBalances,
    Notif_EidResponse? eidResponse,
  }) {
    final $result = create();
    if (loginFailed != null) {
      $result.loginFailed = loginFailed;
    }
    if (loginSucceed != null) {
      $result.loginSucceed = loginSucceed;
    }
    if (registerFailed != null) {
      $result.registerFailed = registerFailed;
    }
    if (registerSucceed != null) {
      $result.registerSucceed = registerSucceed;
    }
    if (freeShares != null) {
      $result.freeShares = freeShares;
    }
    if (buyShares != null) {
      $result.buyShares = buyShares;
    }
    if (soldShares != null) {
      $result.soldShares = soldShares;
    }
    if (userShares != null) {
      $result.userShares = userShares;
    }
    if (updatePrices != null) {
      $result.updatePrices = updatePrices;
    }
    if (updateMarketData != null) {
      $result.updateMarketData = updateMarketData;
    }
    if (issuedAmounts != null) {
      $result.issuedAmounts = issuedAmounts;
    }
    if (updateBalances != null) {
      $result.updateBalances = updateBalances;
    }
    if (eidResponse != null) {
      $result.eidResponse = eidResponse;
    }
    return $result;
  }
  Notif._() : super();
  factory Notif.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Notif.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Notif_Body> _Notif_BodyByTag = {
    1 : Notif_Body.loginFailed,
    2 : Notif_Body.loginSucceed,
    3 : Notif_Body.registerFailed,
    4 : Notif_Body.registerSucceed,
    5 : Notif_Body.freeShares,
    6 : Notif_Body.buyShares,
    7 : Notif_Body.soldShares,
    8 : Notif_Body.userShares,
    9 : Notif_Body.updatePrices,
    10 : Notif_Body.updateMarketData,
    11 : Notif_Body.issuedAmounts,
    12 : Notif_Body.updateBalances,
    13 : Notif_Body.eidResponse,
    0 : Notif_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Notif', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13])
    ..aOM<Notif_LoginFailed>(1, _omitFieldNames ? '' : 'loginFailed', subBuilder: Notif_LoginFailed.create)
    ..aOM<Notif_LoginSucceed>(2, _omitFieldNames ? '' : 'loginSucceed', subBuilder: Notif_LoginSucceed.create)
    ..aOM<Notif_RegisterFailed>(3, _omitFieldNames ? '' : 'registerFailed', subBuilder: Notif_RegisterFailed.create)
    ..aOM<Notif_RegisterSucceed>(4, _omitFieldNames ? '' : 'registerSucceed', subBuilder: Notif_RegisterSucceed.create)
    ..aOM<Notif_FreeShares>(5, _omitFieldNames ? '' : 'freeShares', subBuilder: Notif_FreeShares.create)
    ..aOM<Notif_BuyShares>(6, _omitFieldNames ? '' : 'buyShares', subBuilder: Notif_BuyShares.create)
    ..aOM<Notif_SoldShares>(7, _omitFieldNames ? '' : 'soldShares', subBuilder: Notif_SoldShares.create)
    ..aOM<Notif_UserShares>(8, _omitFieldNames ? '' : 'userShares', subBuilder: Notif_UserShares.create)
    ..aOM<Notif_UpdatePrices>(9, _omitFieldNames ? '' : 'updatePrices', subBuilder: Notif_UpdatePrices.create)
    ..aOM<Notif_UpdateMarketData>(10, _omitFieldNames ? '' : 'updateMarketData', subBuilder: Notif_UpdateMarketData.create)
    ..aOM<Notif_IssuedAmounts>(11, _omitFieldNames ? '' : 'issuedAmounts', subBuilder: Notif_IssuedAmounts.create)
    ..aOM<Notif_UpdateBalances>(12, _omitFieldNames ? '' : 'updateBalances', subBuilder: Notif_UpdateBalances.create)
    ..aOM<Notif_EidResponse>(13, _omitFieldNames ? '' : 'eidResponse', subBuilder: Notif_EidResponse.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Notif clone() => Notif()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Notif copyWith(void Function(Notif) updates) => super.copyWith((message) => updates(message as Notif)) as Notif;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notif create() => Notif._();
  Notif createEmptyInstance() => create();
  static $pb.PbList<Notif> createRepeated() => $pb.PbList<Notif>();
  @$core.pragma('dart2js:noInline')
  static Notif getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notif>(create);
  static Notif? _defaultInstance;

  Notif_Body whichBody() => _Notif_BodyByTag[$_whichOneof(0)]!;
  void clearBody() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Notif_LoginFailed get loginFailed => $_getN(0);
  @$pb.TagNumber(1)
  set loginFailed(Notif_LoginFailed v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoginFailed() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoginFailed() => clearField(1);
  @$pb.TagNumber(1)
  Notif_LoginFailed ensureLoginFailed() => $_ensure(0);

  @$pb.TagNumber(2)
  Notif_LoginSucceed get loginSucceed => $_getN(1);
  @$pb.TagNumber(2)
  set loginSucceed(Notif_LoginSucceed v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasLoginSucceed() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoginSucceed() => clearField(2);
  @$pb.TagNumber(2)
  Notif_LoginSucceed ensureLoginSucceed() => $_ensure(1);

  @$pb.TagNumber(3)
  Notif_RegisterFailed get registerFailed => $_getN(2);
  @$pb.TagNumber(3)
  set registerFailed(Notif_RegisterFailed v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRegisterFailed() => $_has(2);
  @$pb.TagNumber(3)
  void clearRegisterFailed() => clearField(3);
  @$pb.TagNumber(3)
  Notif_RegisterFailed ensureRegisterFailed() => $_ensure(2);

  @$pb.TagNumber(4)
  Notif_RegisterSucceed get registerSucceed => $_getN(3);
  @$pb.TagNumber(4)
  set registerSucceed(Notif_RegisterSucceed v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasRegisterSucceed() => $_has(3);
  @$pb.TagNumber(4)
  void clearRegisterSucceed() => clearField(4);
  @$pb.TagNumber(4)
  Notif_RegisterSucceed ensureRegisterSucceed() => $_ensure(3);

  @$pb.TagNumber(5)
  Notif_FreeShares get freeShares => $_getN(4);
  @$pb.TagNumber(5)
  set freeShares(Notif_FreeShares v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasFreeShares() => $_has(4);
  @$pb.TagNumber(5)
  void clearFreeShares() => clearField(5);
  @$pb.TagNumber(5)
  Notif_FreeShares ensureFreeShares() => $_ensure(4);

  @$pb.TagNumber(6)
  Notif_BuyShares get buyShares => $_getN(5);
  @$pb.TagNumber(6)
  set buyShares(Notif_BuyShares v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasBuyShares() => $_has(5);
  @$pb.TagNumber(6)
  void clearBuyShares() => clearField(6);
  @$pb.TagNumber(6)
  Notif_BuyShares ensureBuyShares() => $_ensure(5);

  @$pb.TagNumber(7)
  Notif_SoldShares get soldShares => $_getN(6);
  @$pb.TagNumber(7)
  set soldShares(Notif_SoldShares v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasSoldShares() => $_has(6);
  @$pb.TagNumber(7)
  void clearSoldShares() => clearField(7);
  @$pb.TagNumber(7)
  Notif_SoldShares ensureSoldShares() => $_ensure(6);

  @$pb.TagNumber(8)
  Notif_UserShares get userShares => $_getN(7);
  @$pb.TagNumber(8)
  set userShares(Notif_UserShares v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasUserShares() => $_has(7);
  @$pb.TagNumber(8)
  void clearUserShares() => clearField(8);
  @$pb.TagNumber(8)
  Notif_UserShares ensureUserShares() => $_ensure(7);

  @$pb.TagNumber(9)
  Notif_UpdatePrices get updatePrices => $_getN(8);
  @$pb.TagNumber(9)
  set updatePrices(Notif_UpdatePrices v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasUpdatePrices() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatePrices() => clearField(9);
  @$pb.TagNumber(9)
  Notif_UpdatePrices ensureUpdatePrices() => $_ensure(8);

  @$pb.TagNumber(10)
  Notif_UpdateMarketData get updateMarketData => $_getN(9);
  @$pb.TagNumber(10)
  set updateMarketData(Notif_UpdateMarketData v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasUpdateMarketData() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdateMarketData() => clearField(10);
  @$pb.TagNumber(10)
  Notif_UpdateMarketData ensureUpdateMarketData() => $_ensure(9);

  @$pb.TagNumber(11)
  Notif_IssuedAmounts get issuedAmounts => $_getN(10);
  @$pb.TagNumber(11)
  set issuedAmounts(Notif_IssuedAmounts v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasIssuedAmounts() => $_has(10);
  @$pb.TagNumber(11)
  void clearIssuedAmounts() => clearField(11);
  @$pb.TagNumber(11)
  Notif_IssuedAmounts ensureIssuedAmounts() => $_ensure(10);

  @$pb.TagNumber(12)
  Notif_UpdateBalances get updateBalances => $_getN(11);
  @$pb.TagNumber(12)
  set updateBalances(Notif_UpdateBalances v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasUpdateBalances() => $_has(11);
  @$pb.TagNumber(12)
  void clearUpdateBalances() => clearField(12);
  @$pb.TagNumber(12)
  Notif_UpdateBalances ensureUpdateBalances() => $_ensure(11);

  @$pb.TagNumber(13)
  Notif_EidResponse get eidResponse => $_getN(12);
  @$pb.TagNumber(13)
  set eidResponse(Notif_EidResponse v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasEidResponse() => $_has(12);
  @$pb.TagNumber(13)
  void clearEidResponse() => clearField(13);
  @$pb.TagNumber(13)
  Notif_EidResponse ensureEidResponse() => $_ensure(12);
}

class Err extends $pb.GeneratedMessage {
  factory Err({
    $fixnum.Int64? id,
    $core.String? text,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (text != null) {
      $result.text = text;
    }
    return $result;
  }
  Err._() : super();
  factory Err.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Err.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Err', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aQS(2, _omitFieldNames ? '' : 'text')
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Err clone() => Err()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Err copyWith(void Function(Err) updates) => super.copyWith((message) => updates(message as Err)) as Err;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Err create() => Err._();
  Err createEmptyInstance() => create();
  static $pb.PbList<Err> createRepeated() => $pb.PbList<Err>();
  @$core.pragma('dart2js:noInline')
  static Err getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Err>(create);
  static Err? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => clearField(2);
}

enum Res_Body {
  resp, 
  notif, 
  error, 
  notSet
}

class Res extends $pb.GeneratedMessage {
  factory Res({
    Resp? resp,
    Notif? notif,
    Err? error,
  }) {
    final $result = create();
    if (resp != null) {
      $result.resp = resp;
    }
    if (notif != null) {
      $result.notif = notif;
    }
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  Res._() : super();
  factory Res.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Res.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Res_Body> _Res_BodyByTag = {
    1 : Res_Body.resp,
    2 : Res_Body.notif,
    3 : Res_Body.error,
    0 : Res_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Res', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<Resp>(1, _omitFieldNames ? '' : 'resp', subBuilder: Resp.create)
    ..aOM<Notif>(2, _omitFieldNames ? '' : 'notif', subBuilder: Notif.create)
    ..aOM<Err>(3, _omitFieldNames ? '' : 'error', subBuilder: Err.create)
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Res clone() => Res()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Res copyWith(void Function(Res) updates) => super.copyWith((message) => updates(message as Res)) as Res;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Res create() => Res._();
  Res createEmptyInstance() => create();
  static $pb.PbList<Res> createRepeated() => $pb.PbList<Res>();
  @$core.pragma('dart2js:noInline')
  static Res getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Res>(create);
  static Res? _defaultInstance;

  Res_Body whichBody() => _Res_BodyByTag[$_whichOneof(0)]!;
  void clearBody() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Resp get resp => $_getN(0);
  @$pb.TagNumber(1)
  set resp(Resp v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResp() => $_has(0);
  @$pb.TagNumber(1)
  void clearResp() => clearField(1);
  @$pb.TagNumber(1)
  Resp ensureResp() => $_ensure(0);

  @$pb.TagNumber(2)
  Notif get notif => $_getN(1);
  @$pb.TagNumber(2)
  set notif(Notif v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasNotif() => $_has(1);
  @$pb.TagNumber(2)
  void clearNotif() => clearField(2);
  @$pb.TagNumber(2)
  Notif ensureNotif() => $_ensure(1);

  @$pb.TagNumber(3)
  Err get error => $_getN(2);
  @$pb.TagNumber(3)
  set error(Err v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => clearField(3);
  @$pb.TagNumber(3)
  Err ensureError() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
