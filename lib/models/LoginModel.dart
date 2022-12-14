import 'package:country_pickers/country.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/widgets.dart';

class CreateMpinReq {
  int mPin;
  bool isMpinAdded;
  String username;

  CreateMpinReq({this.mPin, this.isMpinAdded, this.username});

  CreateMpinReq.fromJson(Map<String, dynamic> json) {
    mPin = json['mPin'];
    isMpinAdded = json['isMpinAdded'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (!isNullEmptyOrFalse(this.mPin)) {
      data['mPin'] = this.mPin;
    }

    if (!isNullEmptyOrFalse(this.isMpinAdded)) {
      data['isMpinAdded'] = this.isMpinAdded;
    }

    if (!isNullEmptyOrFalse(this.username)) {
      data['username'] = this.username;
    }
    return data;
  }
}

class LoginReq {
  String username;
  String password;

  LoginReq({this.username, this.password});

  LoginReq.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}

class LoginResp extends BaseApiResp {
  Data data;

  LoginResp({this.data});

  LoginResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  Token token;
  User user;
  UserPermissions userPermissions;
  MastersResp masters;

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userPermissions = json['userPermissions'] != null
        ? new UserPermissions.fromJson(json['userPermissions'])
        : null;
    masters = json['masters'] != null
        ? new MastersResp.fromJson(json['masters'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.token != null) {
      data['token'] = this.token.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.userPermissions != null) {
      data['userPermissions'] = this.userPermissions.toJson();
    }
    data['masters'] = this.masters.toJson();
    return data;
  }
}

class Token {
  String jwt;

  Token({this.jwt});

  Token.fromJson(Map<String, dynamic> json) {
    jwt = json['jwt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jwt'] = this.jwt;
    return data;
  }
}

class User {
  String createdAt;
  String updatedAt;
  String id;
  String vendorNo;
  String firstName;
  String lastName;
  String middleName;
  String name;
  String companyName;
  String companyAddress;
  String username;
  String email;
  String mobile;
  int type;
  int roleType;
  String spaceCodeIp;
  String hostName;
  String macAddress;
  String toAuthenticate;
  bool isEmailVerified;
  String emailHash;
  bool isDeleted;
  String dateOfJoin;
  bool isActive;
  int isVerified;

//  Null androidPlayerId;
//  Null iosPlayerId;
  int status;

//  Null connectedSockets;
  num termsDiscount;

//  Null resetPasswordLink;
//  Null apiTokens;
//  Null defaultFilter;
  String clientSecret;
  String profileImage;

//  Null syncExtra;
  String anniversary;
  String businessId;
  String businessType;
  String countryCode;
  String designation;
  String device;
  String dob;
  String fax;
  String gender;
  String howKnow;
  String phone;
  String photoId;
  String pinCode;
  String reference;
  // List<String> roles;
  bool updateRequired;
  bool isIntoHide;
  String updateIp;
  String createIp;
  List<FingerPrints> fingerPrints;
  LoggedInSession loggedInSession;
  String whatsapp;
  String whatsappCounCode;
  String plainPassword;
  String skype;
  String zipcode;
  String wechat;
  Token token;
  int version;
  bool isTermsCondAgree;
  String termsCondAgreeAt;
  String address;
  bool kycRequired;
  bool isKycUploaded;
  int isApproved;
//  Null loginOtp;
  String group;

//  Null addedBy;
//  Null updatedBy;
  Account account;
  AccountTerm accountTerm;
  String seller;

  String country;
  String city;
  String state;
  String address2;
  String address3;
  //mpin
  bool isMpinAdded;

//  Null createdBy;

  User.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    vendorNo = json['vendorNo'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    middleName = json['middleName'];
    name = json['name'];
    companyName = json['companyName'];
    companyAddress = json['companyAddress'];
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    type = json['type'];
    roleType = json['roleType'];
    spaceCodeIp = json['SpaceCodeIp'];
    hostName = json['hostName'];
    macAddress = json['macAddress'];
    toAuthenticate = json['toAuthenticate'];
    isEmailVerified = json['isEmailVerified'];
    emailHash = json['emailHash'];
    address2 = json['address2'];
    address3 = json['address3'];

    isDeleted = json['isDeleted'];
    dateOfJoin = json['dateOfJoin'];
    isActive = json['isActive'];
    isVerified = json['isVerified'];
//    androidPlayerId = json['androidPlayerId'];
//    iosPlayerId = json['iosPlayerId'];
    status = json['status'];
//    connectedSockets = json['connectedSockets'];
    termsDiscount = json['termsDiscount'];
//    resetPasswordLink = json['resetPasswordLink'];
//    apiTokens = json['apiTokens'];
//    defaultFilter = json['defaultFilter'];
    clientSecret = json['clientSecret'];
    profileImage = json['profileImage'];
//    syncExtra = json['syncExtra'];
    anniversary = json['anniversary'];
    businessId = json['businessId'];
    businessType = json['BusinessType'];
    countryCode = json['countryCode'];
    designation = json['designation'];
    device = json['device'];
    dob = json['dob'];
    fax = json['fax'];
    gender = json['gender'];
    howKnow = json['howKnow'];
    phone = json['phone'];
    photoId = json['photoId'];
    pinCode = json['pinCode'];
    reference = json['reference'];
    // roles = json['roles'];
    updateRequired = json['updateRequired'];
    isIntoHide = json['isIntoHide'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];
    if (json['fingerPrints'] != null) {
      fingerPrints = new List<FingerPrints>();
      json['fingerPrints'].forEach((v) {
        fingerPrints.add(new FingerPrints.fromJson(v));
      });
    }
    loggedInSession = json['loggedInSession'] != null
        ? new LoggedInSession.fromJson(json['loggedInSession'])
        : null;
    whatsapp = json['whatsapp'];
    whatsappCounCode = json['whatsappCounCode'];
    plainPassword = json['plainPassword'];
    skype = json['skype'];
    zipcode = json['pinCode'];
    wechat = json['wechat'];
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
    version = json['version'];
    isTermsCondAgree = json['isTermsCondAgree'];
    termsCondAgreeAt = json['termsCondAgreeAt'];
    address = json['address'];
//    loginOtp = json['loginOtp'];

    group = json['group'];
    if (json['account'] != null) {
      if (json['account'] is Map<String, dynamic>) {
        account = new Account.fromJson(json['account']);
      }
    }

    accountTerm = json['accountTerm'] != null && json['accountTerm'] is Map
        ? new AccountTerm.fromJson(json['accountTerm'])
        : null;
    seller = json['seller'];

    if (json['city'] is Map<String, dynamic>) {
      city = json['city']['name'];
    }
    if (json['country'] is Map<String, dynamic>) {
      country = json['country']['name'];
    }
    if (json['state'] is Map<String, dynamic>) {
      state = json['state']['name'];
    }
    kycRequired = json["kycRequired"] ?? false;
    isKycUploaded = json["isKycUploaded"] ?? false;
    isApproved = json["isApproved"];

    isMpinAdded =
        !isNullEmptyOrFalse(json["isMpinAdded"]) ? json["isMpinAdded"] : false;

    // city  = json['city'];
    // state = json['state'];
    // country = json['country'];
    // city = json["city"] != null ? json['city'] is String ? json['city'] : new CityList.fromJson(json['city']) : null;
    // state = json["state"] != null ? json['state'] is String ? json['state'] : new CityList.fromJson(json['state']) : null;
    // country = json["country"] != null ? json['country'] is String ? json['country'] : new CityList.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['vendorNo'] = this.vendorNo;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['middleName'] = this.middleName;
    data['name'] = this.name;
    data['companyName'] = this.companyName;
    data['companyAddress'] = this.companyAddress;
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['type'] = this.type;
    data['roleType'] = this.roleType;
    data['SpaceCodeIp'] = this.spaceCodeIp;
    data['hostName'] = this.hostName;
    data['macAddress'] = this.macAddress;
    data['toAuthenticate'] = this.toAuthenticate;
    data['isEmailVerified'] = this.isEmailVerified;
    data['emailHash'] = this.emailHash;
    data['isDeleted'] = this.isDeleted;
    data['dateOfJoin'] = this.dateOfJoin;
    data['isActive'] = this.isActive;
    data['isVerified'] = this.isVerified;
//    data['androidPlayerId'] = this.androidPlayerId;
//    data['iosPlayerId'] = this.iosPlayerId;
    data['status'] = this.status;
//    data['connectedSockets'] = this.connectedSockets;
    data['termsDiscount'] = this.termsDiscount;
//    data['resetPasswordLink'] = this.resetPasswordLink;
//    data['apiTokens'] = this.apiTokens;
//    data['defaultFilter'] = this.defaultFilter;
    data['clientSecret'] = this.clientSecret;
    data['profileImage'] = this.profileImage;
//    data['syncExtra'] = this.syncExtra;
    data['anniversary'] = this.anniversary;
    data['businessId'] = this.businessId;
    data['BusinessType'] = this.businessType;
    data['countryCode'] = this.countryCode;
    data['designation'] = this.designation;
    data['device'] = this.device;
    data['dob'] = this.dob;
    data['fax'] = this.fax;
    data['gender'] = this.gender;
    data['howKnow'] = this.howKnow;
    data['phone'] = this.phone;
    data['photoId'] = this.photoId;
    data['pinCode'] = this.pinCode;
    data['reference'] = this.reference;
    // data['roles'] = this.roles;
    data['updateRequired'] = this.updateRequired;
    data['isIntoHide'] = this.isIntoHide;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
    data['address'] = this.address;
    data['isApproved'] = this.isApproved;
    if (this.fingerPrints != null) {
      data['fingerPrints'] = this.fingerPrints.map((v) => v.toJson()).toList();
    }
    if (this.loggedInSession != null) {
      data['loggedInSession'] = this.loggedInSession.toJson();
    }
    data['whatsapp'] = this.whatsapp;
    data['whatsappCounCode'] = this.whatsappCounCode;
    data['plainPassword'] = this.plainPassword;
    data['skype'] = this.skype;
    data['pinCode'] = this.zipcode;
    data['wechat'] = this.wechat;
    if (this.token != null) {
      data['token'] = this.token.toJson();
    }
    data['version'] = this.version;
    data['isTermsCondAgree'] = this.isTermsCondAgree;
    data['termsCondAgreeAt'] = this.termsCondAgreeAt;
//    data['loginOtp'] = this.loginOtp;
    data['group'] = this.group;
    if (this.account != null) {
      data['account'] = this.account.toJson();
    }
    if (this.accountTerm != null) {
      data['accountTerm'] = this.accountTerm.toJson();
    }
    data['seller'] = this.seller;
    data["kycRequired"] = this.kycRequired;
    data["isKycUploaded"] = this.isKycUploaded;

    //mpin
    data['isMpinAdded'] = this.isMpinAdded;
    data['address2'] = this.address2;
    data['address3'] = this.address3;
    return data;
  }

  String getFullName() {
    var fn = "";
    if (!isNullEmptyOrFalse(firstName)) {
      fn = firstName
          .trim()
          .split(' ')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' ');
    }
    var ln = "";
    if (!isNullEmptyOrFalse(lastName)) {
      ln = lastName
          .trim()
          .split(' ')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' ');
    }
    return fn + " " + ln;
  }
}

class FingerPrints {
  String fingerPrint;
  bool isVerified;

  FingerPrints({this.fingerPrint, this.isVerified});

  FingerPrints.fromJson(Map<String, dynamic> json) {
    fingerPrint = json['fingerPrint'];
    isVerified = json['isVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fingerPrint'] = this.fingerPrint;
    data['isVerified'] = this.isVerified;
    return data;
  }
}

class LoggedInSession {
  Current current;
  Current previous;

  LoggedInSession({this.current, this.previous});

  LoggedInSession.fromJson(Map<String, dynamic> json) {
    current =
        json['current'] != null ? new Current.fromJson(json['current']) : null;
    previous = json['previous'] != null
        ? new Current.fromJson(json['previous'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.current != null) {
      data['current'] = this.current.toJson();
    }
    if (this.previous != null) {
      data['previous'] = this.previous.toJson();
    }
    return data;
  }
}

class MastersResp {
  List<Master> sHAPE;
  MastersResp({
    this.sHAPE,
  });

  MastersResp.fromJson(Map<String, dynamic> json) {
    if (json['SHAPE'] != null) {
      sHAPE = new List<Master>();
      json['SHAPE'].forEach((v) {
        sHAPE.add(new Master.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sHAPE != null) {
      data['SHAPE'] = this.sHAPE.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SHAPE {
  List<String> id;
  String name;
  String normalizeName;
  String code;
  String description;
  String webDisplay;
  bool isActive;
  bool isDefault;
  int sortingSequence;
  String image;
  String parentCode;
  String parentId;
  List<Master> grouped = [];

  SHAPE({
    this.id,
    this.name,
    this.normalizeName,
    this.code,
    this.description,
    this.webDisplay,
    this.isActive,
    this.isDefault,
    this.sortingSequence,
    this.image,
    this.parentCode,
    this.parentId,
  });

  SHAPE.fromJson(Map<String, dynamic> json) {
    id = json['id'].cast<String>();
    name = json['name'];
    normalizeName = json['normalizeName'];
    code = json['code'];
    description = json['description'];
    webDisplay = json['webDisplay'] ?? "";
    isActive = json['isActive'] ?? false;
    isDefault = json['isDefault'] ?? false;
    sortingSequence = json['sortingSequence'] ?? 0;
    image = json['image'] ?? "";
    parentCode = json['parentCode'] ?? "";
    parentId = json['parentId'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['normalizeName'] = this.normalizeName;
    data['code'] = this.code;
    data['description'] = this.description;
    data['webDisplay'] = this.webDisplay;
    data['isActive'] = this.isActive;
    data['isDefault'] = this.isDefault;
    data['sortingSequence'] = this.sortingSequence;
    data['image'] = this.image;
    data['parentCode'] = this.parentCode;
    data['parentId'] = this.parentId;
    return data;
  }
}

class Current {
  String ip;
  Address address;
  String time;

  Current({this.ip, this.address, this.time});

  Current.fromJson(Map<String, dynamic> json) {
    ip = json['ip'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ip'] = this.ip;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['time'] = this.time;
    return data;
  }
}

class Address {
  String country;
  String region;
  String city;
  String postalCode;
  String latitude;
  String longitude;
  String timezone;

  Address(
      {this.country,
      this.region,
      this.city,
      this.postalCode,
      this.latitude,
      this.longitude,
      this.timezone});

  Address.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    region = json['region'];
    city = json['city'];
    postalCode = json['postalCode'];
    // latitude = json['latitude'];
    // longitude = json['longitude'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['region'] = this.region;
    data['city'] = this.city;
    data['postalCode'] = this.postalCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['timezone'] = this.timezone;
    return data;
  }
}

class UserToken {
  String web;
  String device;

  UserToken({this.web, this.device});

  UserToken.fromJson(Map<String, dynamic> json) {
    web = json['web'];
    device = json['device'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['web'] = this.web;
    data['device'] = this.device;
    return data;
  }
}

class Account {
  String createdAt;
  String updatedAt;
  String id;
  String stockCategory;
  String vendorLogo;
  String vendorCode;
  String vendorNormalizeCode;
  String vendorNo;
  String prefix;
  String gender;
  String name;
  String profileImage;
  String code;
  String displayName;
  String companyName;
  String companyNormalizeName;
  String companyType;
  String ledgerType;
  String normalizeName;
  String accountType;
  bool hasBroker;
  BrokerInfo brokerInfo;
  int registrationType;
  String dateOfJoin;
  String dateOfAnniversary;
  String addressType;
  String address;
  String landMark;
  String street;
  String area;
  String zipCode;
  String defaultNarration;
  String orderEmail;
  String newStoneEmail;
  String newsEventEmail;
  String noOfEmployee;
  String contactSource;
  String dateOfBirth;
  String accountName;
  String isSubscribeForNewGoodFavourite;
  String isSubscribeForNewGoodPurchase;
  String isSubscribeForNotification;
  String gstNo;
  String panNo;
  String verifyBy;
  String verifyDate;
  String businessType;
  String natureOfOrg;
  String designation;
  String howKnow;
  String referenceFrom;
  bool isDeleted;
  int isApproved;
  bool isActive;
  int status;
  String updateIp;
  String createIp;
  String founded;
  String specialties;
  String companySize;
  String videoUrl;
  String about;
  bool showPublicly;
  String coverImage;
  int isVerified;
  CountryList country;
  StateList state;
  CityList city;
  List<Kyc> kyc;
  bool isKycUploaded;
  String businessId;
  int crdLmt;

  Account.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    stockCategory = json['stockCategory'];
    vendorLogo = json['vendorLogo'];
    vendorCode = json['vendorCode'];
    vendorNormalizeCode = json['vendorNormalizeCode'];
    vendorNo = json['vendorNo'];
    prefix = json['prefix'];
    gender = json['gender'];
    name = json['name'];
    profileImage = json['profileImage'];
    code = json['code'];
    displayName = json['displayName'];
    companyName = json['companyName'];
    companyNormalizeName = json['companyNormalizeName'];
    companyType = json['companyType'];
    ledgerType = json['ledgerType'];
    normalizeName = json['normalizeName'];
    accountType = json['accountType'];
    businessId = json['businessId'];
    hasBroker = json['hasBroker'];
    brokerInfo = json['brokerInfo'] != null
        ? new BrokerInfo.fromJson(json['brokerInfo'])
        : null;
    registrationType = json['registrationType'];
    dateOfJoin = json['dateOfJoin'];
    dateOfAnniversary = json['dateOfAnniversary'];
    addressType = json['addressType'];
    address = json['address'];
    landMark = json['landMark'];
    street = json['street'];
    area = json['area'];
    zipCode = json['zipCode'];
    isApproved = json["isApproved"];
    defaultNarration = json['defaultNarration'];
    orderEmail = json['orderEmail'];
    newStoneEmail = json['newStoneEmail'];
    newsEventEmail = json['newsEventEmail'];
    noOfEmployee = json['noOfEmployee'];
    contactSource = json['contactSource'];
    dateOfBirth = json['dateOfBirth'];
    accountName = json['accountName'];
    isSubscribeForNewGoodFavourite = json['isSubscribeForNewGoodFavourite'];
    isSubscribeForNewGoodPurchase = json['isSubscribeForNewGoodPurchase'];
    isSubscribeForNotification = json['isSubscribeForNotification'];
    gstNo = json['gstNo'];
    panNo = json['panNo'];
    verifyBy = json['verifyBy'];
    verifyDate = json['verifyDate'];
    businessType = json['businessType'];
    if (json["natureOfOrg"] is List<dynamic>) {
      if (!isNullEmptyOrFalse(json["natureOfOrg"])) {
        natureOfOrg = json["natureOfOrg"].first;
      }
    } else if (json["natureOfOrg"] is String) {
      natureOfOrg = json["natureOfOrg"];
    }
    designation = json['designation'];
    crdLmt = json['crdLmt'] ?? 0;
    howKnow = json['howKnow'];
    referenceFrom = json['referenceFrom'];
    isDeleted = json['isDeleted'];
    isActive = json['isActive'];
    status = json['status'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];
    founded = json['founded'];
    specialties = json['specialties'];
    companySize = json['companySize'];
    videoUrl = json['videoUrl'];
    about = json['about'];
    showPublicly = json['showPublicly'];
    coverImage = json['coverImage'];
    isVerified = json['isVerified'];
    if (json['kyc'] != null) {
      kyc = new List<Kyc>();
      json['kyc'].forEach((v) {
        kyc.add(new Kyc.fromJson(v));
      });
    }
    if (json["country"] is Map<String, dynamic>) {
      country = json['country'] != null
          ? new CountryList.fromJson(json['country'])
          : null;
    }
    if (json["state"] is Map<String, dynamic>) {
      state =
          json['state'] != null ? new StateList.fromJson(json['state']) : null;
    }
    if (json["city"] is Map<String, dynamic>) {
      city = json['city'] != null ? new CityList.fromJson(json['city']) : null;
    }
    isKycUploaded = json["isKycUploaded"] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['stockCategory'] = this.stockCategory;
    data['vendorLogo'] = this.vendorLogo;
    data['vendorCode'] = this.vendorCode;
    data['vendorNormalizeCode'] = this.vendorNormalizeCode;
    data['vendorNo'] = this.vendorNo;
    data['prefix'] = this.prefix;
    data['gender'] = this.gender;
    data['name'] = this.name;
    if (this.businessId != null) {
      data['businessId'] = this.businessId;
    }
    data['profileImage'] = this.profileImage;
    data['code'] = this.code;
    data['displayName'] = this.displayName;
    data["isApproved"] = this.isApproved;
    data['companyName'] = this.companyName;
    data['companyNormalizeName'] = this.companyNormalizeName;
    data['companyType'] = this.companyType;
    data['ledgerType'] = this.ledgerType;
    data['normalizeName'] = this.normalizeName;
    data['accountType'] = this.accountType;
    data['hasBroker'] = this.hasBroker;
    if (this.brokerInfo != null) {
      data['brokerInfo'] = this.brokerInfo.toJson();
    }
    data['registrationType'] = this.registrationType;
    data['dateOfJoin'] = this.dateOfJoin;
    data['dateOfAnniversary'] = this.dateOfAnniversary;
    data['addressType'] = this.addressType;
    data['address'] = this.address;
    data['landMark'] = this.landMark;
    data['street'] = this.street;
    data['area'] = this.area;
    data['zipCode'] = this.zipCode;
    data['defaultNarration'] = this.defaultNarration;
    data['orderEmail'] = this.orderEmail;
    data['newStoneEmail'] = this.newStoneEmail;
    data['newsEventEmail'] = this.newsEventEmail;
    data['noOfEmployee'] = this.noOfEmployee;
    data['contactSource'] = this.contactSource;
    data['dateOfBirth'] = this.dateOfBirth;
    data['accountName'] = this.accountName;
    data['isSubscribeForNewGoodFavourite'] =
        this.isSubscribeForNewGoodFavourite;
    data['isSubscribeForNewGoodPurchase'] = this.isSubscribeForNewGoodPurchase;
    data['isSubscribeForNotification'] = this.isSubscribeForNotification;
    if (this.kyc != null) {
      data['kyc'] = this.kyc.map((v) => v.toJson()).toList();
    }
    data['gstNo'] = this.gstNo;
    data['panNo'] = this.panNo;
    data['verifyBy'] = this.verifyBy;
    data['verifyDate'] = this.verifyDate;
    data['businessType'] = this.businessType;
    data['natureOfOrg'] = this.natureOfOrg;
    data['designation'] = this.designation;
    data['howKnow'] = this.howKnow;
    data['referenceFrom'] = this.referenceFrom;
    data['isDeleted'] = this.isDeleted;
    data['isActive'] = this.isActive;
    data['status'] = this.status;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
    data['founded'] = this.founded;
    data['specialties'] = this.specialties;
    data['companySize'] = this.companySize;
    data['videoUrl'] = this.videoUrl;
    data['about'] = this.about;
    data['showPublicly'] = this.showPublicly;
    data['coverImage'] = this.coverImage;
    data['isVerified'] = this.isVerified;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data["isKycUploaded"] = this.isKycUploaded;
    if (this.crdLmt != null) {
      data['crdLmt'] = this.crdLmt;
    }
    return data;
  }
}

class Kyc {
  String path;
  String docType;

  Kyc({this.path, this.docType});

  Kyc.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    docType = json["docType"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data["docType"] = this.docType;
    return data;
  }
}

class BrokerInfo {
  String brokerName;
  String brokerEmail;
  String brokerMobile;
  String brokerPhoneNo;

  BrokerInfo(
      {this.brokerName,
      this.brokerEmail,
      this.brokerMobile,
      this.brokerPhoneNo});

  BrokerInfo.fromJson(Map<String, dynamic> json) {
    brokerName = json['brokerName'];
    brokerEmail = json['brokerEmail'];
    brokerMobile = json['brokerMobile'];
    brokerPhoneNo = json['brokerPhoneNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brokerName'] = this.brokerName;
    data['brokerEmail'] = this.brokerEmail;
    data['brokerMobile'] = this.brokerMobile;
    data['brokerPhoneNo'] = this.brokerPhoneNo;
    return data;
  }
}

class UserPermissions {
  List<UserPermissionsData> data;

  UserPermissions({this.data});

  UserPermissions.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<UserPermissionsData>();
      json['data'].forEach((v) {
        data.add(new UserPermissionsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserPermissionsData {
  String module;
  bool view;
  bool insert;
  bool update;
  bool delete;
  bool downloadExcel;
  Permissions permissions;

  UserPermissionsData({this.module});

  UserPermissionsData.fromJson(Map<String, dynamic> json) {
    module = json['module'];
    permissions = json['permissions'] != null
        ? new Permissions.fromJson(json['permissions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['module'] = this.module;
    data['permissions'] = this.permissions;
    return data;
  }
}

class Permissions {
  bool view;
  bool insert;
  bool update;
  bool delete;
  bool downloadExcel;
  bool all;

  Permissions({
    this.view,
    this.insert,
    this.update,
    this.delete,
    this.downloadExcel,
    this.all,
  });

  Permissions.fromJson(Map<String, dynamic> json) {
    view = json['view'] ?? false;
    insert = json['insert'] ?? false;
    update = json['update'] ?? false;
    delete = json['delete'] ?? false;
    downloadExcel = json['downloadExcel'] ?? false;
    all = json['all'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['view'] = this.view;
    data['insert'] = this.insert;
    data['update'] = this.update;
    data['delete'] = this.delete;
    data['downloadExcel'] = this.downloadExcel;
    data['all'] = this.all;
    return data;
  }
}

class AccountTerm {
  String createdAt;
  String updatedAt;
  String id;
  String deliveryType;
  String deliveryDays;
  num extraAmt;
  num extraPer;
  num rapPer;
  num creditLimit;
  num memoLimit;
  num adatCommission;
  num brokerCommission;
  int type;
  String dFTermId;
  bool isApproved;
  bool isActive;
  bool isDeleted;
  bool isDefault;
  String syncId;
  String parentId;
  String approvedOn;
  String stockCategory;
  String addedBy;
  String currencyId;
  String dayTermsId;
  String createdBy;

  AccountTerm({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.deliveryType,
    this.deliveryDays,
    this.extraAmt,
    this.extraPer,
    this.rapPer,
    this.creditLimit,
    this.memoLimit,
    this.adatCommission,
    this.brokerCommission,
    this.type,
    this.dFTermId,
    this.isApproved,
    this.isActive,
    this.isDeleted,
    this.isDefault,
    this.syncId,
    this.parentId,
    this.approvedOn,
    this.stockCategory,
    this.addedBy,
    this.currencyId,
    this.dayTermsId,
    this.createdBy,
  });

  AccountTerm.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    deliveryType = json['deliveryType'];
    deliveryDays = json['deliveryDays'];
    extraAmt = json['extraAmt'];
    extraPer = json['extraPer'];
    rapPer = json['rapPer'];
    creditLimit = json['creditLimit'];
    memoLimit = json['memoLimit'];
    adatCommission = json['adatCommission'];
    brokerCommission = json['brokerCommission'];
    type = json['type'];
    dFTermId = json['DFTermId'];
    isApproved = json['isApproved'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isDefault = json['isDefault'];
    syncId = json['syncId'];
    parentId = json['parentId'];
    approvedOn = json['approvedOn'];
    stockCategory = json['stockCategory'];
    addedBy = json['addedBy'];
    currencyId = json['currencyId'];
    dayTermsId = json['dayTermsId'];
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['deliveryType'] = this.deliveryType;
    data['deliveryDays'] = this.deliveryDays;
    data['extraAmt'] = this.extraAmt;
    data['extraPer'] = this.extraPer;
    data['rapPer'] = this.rapPer;
    data['creditLimit'] = this.creditLimit;
    data['memoLimit'] = this.memoLimit;
    data['adatCommission'] = this.adatCommission;
    data['brokerCommission'] = this.brokerCommission;
    data['type'] = this.type;
    data['DFTermId'] = this.dFTermId;
    data['isApproved'] = this.isApproved;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['isDefault'] = this.isDefault;
    data['syncId'] = this.syncId;
    data['parentId'] = this.parentId;
    data['approvedOn'] = this.approvedOn;
    data['stockCategory'] = this.stockCategory;
    data['addedBy'] = this.addedBy;
    data['currencyId'] = this.currencyId;
    data['dayTermsId'] = this.dayTermsId;
    data['createdBy'] = this.createdBy;
    return data;
  }
}

class Documents {
  String type;
  String fileImage;
  String fileUrl;

  Documents({this.type, this.fileImage, this.fileUrl});

  Documents.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    fileImage = json['file_image'];
    fileUrl = json['file_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['file_image'] = this.fileImage;
    data['file_url'] = this.fileUrl;
    return data;
  }
}
