import 'package:diamnow/app/app.export.dart';

class PersonalInformationReq {
  String id;
  String firstName;
  String lastName;
  String email;

//  String username;
//  String country;
//  String state;
//  String city;
//  String pinCode;
//  String fax;
//  String seller;
//  String vendorNo;
  String mobile;
  String countryCode;

//  String account;
//  String name;
  String address;

//  bool isActive;
  String profileImage;

//  String dob;
//  String gender;
//  String phone;
//  String photoId;
//  String reference;
  String whatsapp;
  String whatsappCounCode;

//  String skype;
//  String wechat;

  PersonalInformationReq({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
//        this.username,
//        this.country,
//        this.state,
//        this.city,
//        this.pinCode,
//        this.fax,
//        this.seller,
//        this.vendorNo,
    this.mobile,
    this.countryCode,
//        this.account,
//        this.name,
    this.address,
//        this.isActive,
//        this.androidPlayerId,
//        this.iosPlayerId,
    this.profileImage,
//        this.dob,
//        this.gender,
//        this.phone,
//        this.photoId,
//        this.reference,
    this.whatsapp,
    this.whatsappCounCode,
//        this.skype,
//        this.wechat,
  });

  PersonalInformationReq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    countryCode = json['countryCode'];
//    username = json['username'];
//    country = json['country'];
//    state = json['state'];
//    city = json['city'];
//    pinCode = json['pinCode'];
//    fax = json['fax'];
//    seller = json['seller'];
//    vendorNo = json['vendorNo'];
    mobile = json['mobile'];
//    account = json['account'];
//    name = json['name'];
    address = json['address'];
//    isActive = json['isActive'];
//    androidPlayerId = json['androidPlayerId'];
//    iosPlayerId = json['iosPlayerId'];
    profileImage = json['profileImage'];
//    dob = json['dob'];
//    gender = json['gender'];
//    phone = json['phone'];
//    photoId = json['photoId'];
//    reference = json['reference'];
    whatsapp = json['whatsapp'];
    whatsappCounCode = json['whatsappCounCode'];
//    skype = json['skype'];
//    wechat = json['wechat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
//    data['username'] = this.username;
//    data['country'] = this.country;
//    data['state'] = this.state;
//    data['city'] = this.city;
//    data['pinCode'] = this.pinCode;
//    data['fax'] = this.fax;
//    data['seller'] = this.seller;
//    data['vendorNo'] = this.vendorNo;
    data['mobile'] = this.mobile;
//    data['account'] = this.account;
//    data['name'] = this.name;
    data['address'] = this.address;
//    data['isActive'] = this.isActive;
//    data['androidPlayerId'] = this.androidPlayerId;
//    data['iosPlayerId'] = this.iosPlayerId;
    data['profileImage'] = this.profileImage;
//    data['dob'] = this.dob;
//    data['gender'] = this.gender;
//    data['phone'] = this.phone;
//    data['photoId'] = this.photoId;
//    data['reference'] = this.reference;
    data['whatsapp'] = this.whatsapp;
    data['whatsappCounCode'] = this.whatsappCounCode;
    data['countryCode'] = this.countryCode;
//    data['skype'] = this.skype;
//    data['wechat'] = this.wechat;
    return data;
  }
}

class PersonalInformationViewResp extends BaseApiResp {
  PersonalInformationViewData data;

  PersonalInformationViewResp({this.data});

  PersonalInformationViewResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['data'] != null
        ? new PersonalInformationViewData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PersonalInformationViewData {
  String createdAt;
  String updatedAt;
  String id;
  String firstName;
  String lastName;
  String name;
  String companyName;
  String address;
  String companyAddress;
  String username;
  String email;
  String mobile;
  int type;
  String spaceCodeIp;
  String hostName;
  String macAddress;
  String toAuthenticate;
  bool isEmailVerified;
  bool isDeleted;
  String dateOfJoin;
  bool isActive;
  int isVerified;
  Setting setting;

//  List<Null> androidPlayerId;
//  List<Null> iosPlayerId;
  int status;

//  Null connectedSockets;
  int termsDiscount;
  ResetPasswordLink resetPasswordLink;

//  Null apiTokens;
  String clientSecret;
  String profileImage;
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
  List<TermsCondHistory> termsCondHistory;

//  LuckyFilter failedAttempts;
//  Null addedBy;
  String updatedBy;
  String account;
  String accountTerm;
  String defaultFilter;
  String city;
  String state;
  String country;
  String seller;
  String createdBy;

  PersonalInformationViewData(
      {this.createdAt,
      this.updatedAt,
      this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.companyName,
      this.address,
      this.companyAddress,
      this.username,
      this.email,
      this.mobile,
      this.type,
      this.spaceCodeIp,
      this.hostName,
      this.macAddress,
      this.toAuthenticate,
      this.isEmailVerified,
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
      this.resetPasswordLink,
//      this.apiTokens,
      this.clientSecret,
      this.profileImage,
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
      this.termsCondHistory,
//      this.failedAttempts,
//      this.addedBy,
      this.updatedBy,
      this.account,
      this.accountTerm,
      this.defaultFilter,
      this.city,
      this.state,
      this.country,
      this.seller,
      this.createdBy});

  PersonalInformationViewData.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    name = json['name'];
    companyName = json['companyName'];
    address = json['address'];
    companyAddress = json['companyAddress'];
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    type = json['type'];
    spaceCodeIp = json['SpaceCodeIp'];
    hostName = json['hostName'];
    macAddress = json['macAddress'];
    toAuthenticate = json['toAuthenticate'];
    isEmailVerified = json['isEmailVerified'];
    isDeleted = json['isDeleted'];
    dateOfJoin = json['dateOfJoin'];
    isActive = json['isActive'];
    isVerified = json['isVerified'];
    setting =
        json['setting'] != null ? new Setting.fromJson(json['setting']) : null;
//    if (json['androidPlayerId'] != null) {
//      androidPlayerId = new List<Null>();
//      json['androidPlayerId'].forEach((v) {
//        androidPlayerId.add(new Null.fromJson(v));
//      });
//    }
//    if (json['iosPlayerId'] != null) {
//      iosPlayerId = new List<Null>();
//      json['iosPlayerId'].forEach((v) {
//        iosPlayerId.add(new Null.fromJson(v));
//      });
//    }
    status = json['status'];
//    connectedSockets = json['connectedSockets'];
    termsDiscount = json['termsDiscount'];
    resetPasswordLink = json['resetPasswordLink'] != null
        ? new ResetPasswordLink.fromJson(json['resetPasswordLink'])
        : null;
//    apiTokens = json['apiTokens'];
    clientSecret = json['clientSecret'];
    profileImage = json['profileImage'];
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
    if (json['termsCondHistory'] != null) {
      termsCondHistory = new List<TermsCondHistory>();
      json['termsCondHistory'].forEach((v) {
        termsCondHistory.add(new TermsCondHistory.fromJson(v));
      });
    }
//    failedAttempts = json['failedAttempts'] != null
//        ? new LuckyFilter.fromJson(json['failedAttempts'])
//        : null;
//    addedBy = json['addedBy'];
    updatedBy = json['updatedBy'];
    account = json['account'];
    accountTerm = json['accountTerm'];
    defaultFilter = json['defaultFilter'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    seller = json['seller'];
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['name'] = this.name;
    data['companyName'] = this.companyName;
    data['address'] = this.address;
    data['companyAddress'] = this.companyAddress;
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['type'] = this.type;
    data['SpaceCodeIp'] = this.spaceCodeIp;
    data['hostName'] = this.hostName;
    data['macAddress'] = this.macAddress;
    data['toAuthenticate'] = this.toAuthenticate;
    data['isEmailVerified'] = this.isEmailVerified;
    data['isDeleted'] = this.isDeleted;
    data['dateOfJoin'] = this.dateOfJoin;
    data['isActive'] = this.isActive;
    data['isVerified'] = this.isVerified;
    if (this.setting != null) {
      data['setting'] = this.setting.toJson();
    }
//    if (this.androidPlayerId != null) {
//      data['androidPlayerId'] =
//          this.androidPlayerId.map((v) => v.toJson()).toList();
//    }
//    if (this.iosPlayerId != null) {
//      data['iosPlayerId'] = this.iosPlayerId.map((v) => v.toJson()).toList();
//    }
    data['status'] = this.status;
//    data['connectedSockets'] = this.connectedSockets;
    data['termsDiscount'] = this.termsDiscount;
    if (this.resetPasswordLink != null) {
      data['resetPasswordLink'] = this.resetPasswordLink.toJson();
    }
//    data['apiTokens'] = this.apiTokens;
    data['clientSecret'] = this.clientSecret;
    data['profileImage'] = this.profileImage;
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
    if (this.termsCondHistory != null) {
      data['termsCondHistory'] =
          this.termsCondHistory.map((v) => v.toJson()).toList();
    }
//    if (this.failedAttempts != null) {
//      data['failedAttempts'] = this.failedAttempts.toJson();
//    }
//    data['addedBy'] = this.addedBy;
    data['updatedBy'] = this.updatedBy;
    data['account'] = this.account;
    data['accountTerm'] = this.accountTerm;
    data['defaultFilter'] = this.defaultFilter;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['seller'] = this.seller;
    data['createdBy'] = this.createdBy;
    return data;
  }
}

class Setting {
  int diamondListLimit;
  int offlineStockLimit;
  AllowedOperations allowedOperations;
//  LuckyFilter luckyFilter;

  Setting(
      {this.diamondListLimit,
      this.offlineStockLimit,
      this.allowedOperations,
//      this.luckyFilter,
      });

  Setting.fromJson(Map<String, dynamic> json) {
    diamondListLimit = json['diamondListLimit'];
    offlineStockLimit = json['offlineStockLimit'];
    allowedOperations = json['allowedOperations'] != null
        ? new AllowedOperations.fromJson(json['allowedOperations'])
        : null;
//    luckyFilter = json['luckyFilter'] != null
//        ? new LuckyFilter.fromJson(json['luckyFilter'])
//        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diamondListLimit'] = this.diamondListLimit;
    data['offlineStockLimit'] = this.offlineStockLimit;
    if (this.allowedOperations != null) {
      data['allowedOperations'] = this.allowedOperations.toJson();
    }
//    if (this.luckyFilter != null) {
//      data['luckyFilter'] = this.luckyFilter.toJson();
//    }
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

class ResetPasswordLink {
  String code;
  String expireTime;

  ResetPasswordLink({this.code, this.expireTime});

  ResetPasswordLink.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    expireTime = json['expireTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['expireTime'] = this.expireTime;
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
  String device;
  String web;

  Token({this.device, this.web});

  Token.fromJson(Map<String, dynamic> json) {
    device = json['device'];
    web = json['web'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device'] = this.device;
    data['web'] = this.web;
    return data;
  }
}

class TermsCondHistory {
  int version;
  String termsCondAgreeAt;

  TermsCondHistory({this.version, this.termsCondAgreeAt});

  TermsCondHistory.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    termsCondAgreeAt = json['termsCondAgreeAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['termsCondAgreeAt'] = this.termsCondAgreeAt;
    return data;
  }
}
