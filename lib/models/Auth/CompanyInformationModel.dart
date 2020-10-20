import 'package:diamnow/app/app.export.dart';

class CompanyInformationReq {
  String id;
  String companyName;
  String dateOfJoin;
  String companyType;
  String businessType;
  bool isActive;

  CompanyInformationReq(
      {this.id,
      this.companyName,
      this.dateOfJoin,
      this.companyType,
      this.businessType,
      this.isActive});

  CompanyInformationReq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['companyName'];
    dateOfJoin = json['dateOfJoin'];
    companyType = json['companyType'];
    businessType = json['businessType'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyName'] = this.companyName;
    data['dateOfJoin'] = this.dateOfJoin;
    data['companyType'] = this.companyType;
    data['businessType'] = this.businessType;
    data['isActive'] = this.isActive;
    return data;
  }
}

class CompanyInformationResp extends BaseApiResp{
  CompanyInformation data;

  CompanyInformationResp({ this.data});

  CompanyInformationResp.fromJson(Map<String, dynamic> json)  : super.fromJson(json){
    data = json['data'] != null ? new CompanyInformation.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class CompanyInformation {
  String createdAt;
  String updatedAt;
  String id;
  String vendorNo;
  String firstName;
  String lastName;
  String name;
  String companyName;
//  Null address;
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
  Setting setting;
//  Null androidPlayerId;
//  Null iosPlayerId;
  int status;
//  Null connectedSockets;
  int termsDiscount;
//  Null resetPasswordLink;
//  Null apiTokens;
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
  List<String> roles;
//  List<Null> adminRoles;
  bool updateRequired;
  bool isIntoHide;
  String updateIp;
  String createIp;
  List<FingerPrints> fingerPrints;
  LoggedInSession loggedInSession;
  String whatsapp;
  String whatsappCounCode;
  String skype;
  String wechat;
  Token token;
  int version;
  bool isTermsCondAgree;
  String termsCondAgreeAt;
//  List<Null> termsCondHistory;
//  Null loginOtp;

//  FailedAttempts failedAttempts;
  String group;
//  Null addedBy;
  String updatedBy;
  String account;
//  Null accountTerm;
//  Null defaultFilter;
  String city;
  String state;
  String country;
  String seller;
//  Null createdBy;

  CompanyInformation(
      {this.createdAt,
      this.updatedAt,
      this.id,
      this.vendorNo,
      this.firstName,
      this.lastName,
      this.name,
      this.companyName,
//      this.address,
      this.companyAddress,
      this.username,
      this.email,
      this.mobile,
      this.type,
      this.roleType,
      this.spaceCodeIp,
      this.hostName,
      this.macAddress,
      this.toAuthenticate,
      this.isEmailVerified,
      this.emailHash,
      this.isDeleted,
      this.dateOfJoin,
      this.isActive,
      this.isVerified,
      this.setting,
//      this.androidPlayerId,
//      this.iosPlayerId,
      this.status,
//      this.connectedSockets,
      this.termsDiscount,
//      this.resetPasswordLink,
//      this.apiTokens,
      this.clientSecret,
      this.profileImage,
//      this.syncExtra,
      this.anniversary,
      this.businessId,
      this.businessType,
      this.countryCode,
      this.designation,
      this.device,
      this.dob,
      this.fax,
      this.gender,
      this.howKnow,
      this.phone,
      this.photoId,
      this.pinCode,
      this.reference,
      this.roles,
//      this.adminRoles,
      this.updateRequired,
      this.isIntoHide,
      this.updateIp,
      this.createIp,
      this.fingerPrints,
      this.loggedInSession,
      this.whatsapp,
      this.whatsappCounCode,
      this.skype,
      this.wechat,
      this.token,
      this.version,
      this.isTermsCondAgree,
      this.termsCondAgreeAt,
//      this.termsCondHistory,
//      this.loginOtp,
//      this.failedAttempts,
      this.group,
//      this.addedBy,
      this.updatedBy,
      this.account,
//      this.accountTerm,
//      this.defaultFilter,
      this.city,
      this.state,
      this.country,
      this.seller,
//      this.createdBy,
      });

  CompanyInformation.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    vendorNo = json['vendorNo'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    name = json['name'];
    companyName = json['companyName'];
//    address = json['address'];
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
    isDeleted = json['isDeleted'];
    dateOfJoin = json['dateOfJoin'];
    isActive = json['isActive'];
    isVerified = json['isVerified'];
    setting =
        json['setting'] != null ? new Setting.fromJson(json['setting']) : null;
//    androidPlayerId = json['androidPlayerId'];
//    iosPlayerId = json['iosPlayerId'];
    status = json['status'];
//    connectedSockets = json['connectedSockets'];
    termsDiscount = json['termsDiscount'];
//    resetPasswordLink = json['resetPasswordLink'];
//    apiTokens = json['apiTokens'];
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
    roles = json['roles'].cast<String>();
//    if (json['adminRoles'] != null) {
//      adminRoles = new List<Null>();
//      json['adminRoles'].forEach((v) {
//        adminRoles.add(new Null.fromJson(v));
//      });
//    }
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
    skype = json['skype'];
    wechat = json['wechat'];
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
    version = json['version'];
    isTermsCondAgree = json['isTermsCondAgree'];
    termsCondAgreeAt = json['termsCondAgreeAt'];
//    if (json['termsCondHistory'] != null) {
//      termsCondHistory = new List<Null>();
//      json['termsCondHistory'].forEach((v) {
//        termsCondHistory.add(new Null.fromJson(v));
//      });
//    }
//    loginOtp = json['loginOtp'];
//    failedAttempts = json['failedAttempts'] != null
//        ? new FailedAttempts.fromJson(json['failedAttempts'])
//        : null;
    group = json['group'];
//    addedBy = json['addedBy'];
    updatedBy = json['updatedBy'];
    account = json['account'];
//    accountTerm = json['accountTerm'];
//    defaultFilter = json['defaultFilter'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    seller = json['seller'];
//    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['vendorNo'] = this.vendorNo;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['name'] = this.name;
    data['companyName'] = this.companyName;
//    data['address'] = this.address;
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
    if (this.setting != null) {
      data['setting'] = this.setting.toJson();
    }
//    data['androidPlayerId'] = this.androidPlayerId;
//    data['iosPlayerId'] = this.iosPlayerId;
    data['status'] = this.status;
//    data['connectedSockets'] = this.connectedSockets;
    data['termsDiscount'] = this.termsDiscount;
//    data['resetPasswordLink'] = this.resetPasswordLink;
//    data['apiTokens'] = this.apiTokens;
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
    data['roles'] = this.roles;
//    if (this.adminRoles != null) {
//      data['adminRoles'] = this.adminRoles.map((v) => v.toJson()).toList();
//    }
    data['updateRequired'] = this.updateRequired;
    data['isIntoHide'] = this.isIntoHide;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
    if (this.fingerPrints != null) {
      data['fingerPrints'] = this.fingerPrints.map((v) => v.toJson()).toList();
    }
    if (this.loggedInSession != null) {
      data['loggedInSession'] = this.loggedInSession.toJson();
    }
    data['whatsapp'] = this.whatsapp;
    data['whatsappCounCode'] = this.whatsappCounCode;
    data['skype'] = this.skype;
    data['wechat'] = this.wechat;
    if (this.token != null) {
      data['token'] = this.token.toJson();
    }
    data['version'] = this.version;
    data['isTermsCondAgree'] = this.isTermsCondAgree;
    data['termsCondAgreeAt'] = this.termsCondAgreeAt;
//    if (this.termsCondHistory != null) {
//      data['termsCondHistory'] =
//          this.termsCondHistory.map((v) => v.toJson()).toList();
//    }
//    data['loginOtp'] = this.loginOtp;
//    if (this.failedAttempts != null) {
//      data['failedAttempts'] = this.failedAttempts.toJson();
//    }
    data['group'] = this.group;
//    data['addedBy'] = this.addedBy;
    data['updatedBy'] = this.updatedBy;
    data['account'] = this.account;
//    data['accountTerm'] = this.accountTerm;
//    data['defaultFilter'] = this.defaultFilter;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['seller'] = this.seller;
//    data['createdBy'] = this.createdBy;
    return data;
  }
}

class Setting {
  int diamondListLimit;
  int offlineStockLimit;
  AllowedOperations allowedOperations;

  Setting(
      {this.diamondListLimit, this.offlineStockLimit, this.allowedOperations});

  Setting.fromJson(Map<String, dynamic> json) {
    diamondListLimit = json['diamondListLimit'];
    offlineStockLimit = json['offlineStockLimit'];
    allowedOperations = json['allowedOperations'] != null
        ? new AllowedOperations.fromJson(json['allowedOperations'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diamondListLimit'] = this.diamondListLimit;
    data['offlineStockLimit'] = this.offlineStockLimit;
    if (this.allowedOperations != null) {
      data['allowedOperations'] = this.allowedOperations.toJson();
    }
    return data;
  }
}

class AllowedOperations {
  bool placeOrder;

  AllowedOperations({this.placeOrder});

  AllowedOperations.fromJson(Map<String, dynamic> json) {
    placeOrder = json['placeOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['placeOrder'] = this.placeOrder;
    return data;
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
  double latitude;
  double longitude;
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
    latitude = json['latitude'];
    longitude = json['longitude'];
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

class Token {
  String web;
  String device;

  Token({this.web, this.device});

  Token.fromJson(Map<String, dynamic> json) {
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
