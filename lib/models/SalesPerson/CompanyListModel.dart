

class CompanyListData {
  List<CompanyModel> list;
  int count;

  CompanyListData({this.list, this.count});

  CompanyListData.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<CompanyModel>();
      json['list'].forEach((v) {
        list.add(new CompanyModel.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class CompanyModel {
  String createdAt;
  String updatedAt;
  String id;
  String firstName;
  String lastName;
  String middleName;
  String stockCategory;
  String vendorLogo;
  String vendorCode;
  String vendorNormalizeCode;
  String vendorNo;
  String prefix;
  String gender;
  String profileImage;
  String code;
  String displayName;
  String companyName;
  String companyNormalizeName;
  String companyType;
  String ledgerType;
  String normalizeName;
  String accountType;
  String dateOfJoin;
  String dateOfAnniversary;
  String addressType;
  String address;
  String landMark;
  String street;
  String area;
  String zipCode;
//  List<String> emails;
  String website;
  List<String> faxes;
  String phones;
  List<String> mobiles;
  List<Bank> bank;
  Social social;
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
  String verifyBy;
  String verifyDate;
  String designation;
  String howKnow;
  String referenceFrom;
  bool isDeleted;
  bool isActive;
  Null androidPlayerId;
  Null iosPlayerId;
  int status;
  Null connectedSockets;
  String updateIp;
  String createIp;
//  int isApproved;
  bool isKycUploaded;
  String founded;
  String companySize;
  String videoUrl;
  String about;
  bool showPublicly;
  String coverImage;
  int isVerified;
  List<Group> group;
  String contactEmail;
  String contactMobile;
  String name;
  List<String> natureOfOrg;
  List<Kyc> kyc;
  String lastLoginDate;
  Null addedBy;
  String updatedBy;
  Broker broker;
  Null grpCompany;
  Null departmentHead;
  Null department;
  String country;
  String state;
  String city;
  Seller seller;
  String businessType;
  String createdBy;
  User user;
  bool hasBroker;
  BrokerInfo brokerInfo;
  int registrationType;
  String panNo;
  String specialties;
  Null accountTerm;
  List<References> references;
  String syncId;
  Null syncExtra;
  bool isFm;
  Null approvedBy;
  Null companyId;
  Null deptId;
  String approvedAt;
  String businessId;
  bool isSpam;
  bool isSyncAccount;
  bool isDefault;

  CompanyModel({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.stockCategory,
    this.vendorLogo,
    this.vendorCode,
    this.vendorNormalizeCode,
    this.vendorNo,
    this.prefix,
    this.gender,
    this.profileImage,
    this.code,
    this.displayName,
    this.companyName,
    this.companyNormalizeName,
    this.companyType,
    this.ledgerType,
    this.normalizeName,
    this.accountType,
    this.dateOfJoin,
    this.dateOfAnniversary,
    this.addressType,
    this.address,
    this.landMark,
    this.street,
    this.area,
    this.zipCode,
//    this.emails,
    this.website,
    this.faxes,
    this.phones,
    this.mobiles,
    this.bank,
    this.social,
    this.defaultNarration,
    this.orderEmail,
    this.newStoneEmail,
    this.newsEventEmail,
    this.noOfEmployee,
    this.contactSource,
    this.dateOfBirth,
    this.accountName,
    this.isSubscribeForNewGoodFavourite,
    this.isSubscribeForNewGoodPurchase,
    this.isSubscribeForNotification,
    this.gstNo,
    this.verifyBy,
    this.verifyDate,
    this.designation,
    this.howKnow,
    this.referenceFrom,
    this.isDeleted,
    this.isActive,
    this.androidPlayerId,
    this.iosPlayerId,
    this.status,
    this.connectedSockets,
    this.updateIp,
    this.createIp,
//    this.isApproved,
    this.isKycUploaded,
    this.founded,
    this.companySize,
    this.videoUrl,
    this.about,
    this.showPublicly,
    this.coverImage,
    this.isVerified,
    this.group,
    this.contactEmail,
    this.contactMobile,
    this.name,
    this.natureOfOrg,
    this.kyc,
    this.lastLoginDate,
    this.addedBy,
    this.updatedBy,
    this.broker,
    this.grpCompany,
    this.departmentHead,
    this.department,
    this.country,
    this.state,
    this.city,
    this.seller,
    this.businessType,
    this.createdBy,
    this.user,
    this.hasBroker,
    this.brokerInfo,
    this.registrationType,
    this.panNo,
    this.specialties,
    this.accountTerm,
    this.references,
    this.syncId,
    this.syncExtra,
    this.isFm,
    this.approvedBy,
    this.companyId,
    this.deptId,
    this.approvedAt,
    this.businessId,
    this.isSpam,
    this.isSyncAccount,
    this.isDefault,
  });

  CompanyModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    firstName = json['firstName']!=null?json['firstName']:json['companyName'];
    lastName =  json['lastName']!=null?json['lastName']:"";
    stockCategory = json['stockCategory'];
    vendorLogo = json['vendorLogo'];
    vendorCode = json['vendorCode'];
    vendorNormalizeCode = json['vendorNormalizeCode'];
    vendorNo = json['vendorNo'];
    prefix = json['prefix'];
    gender = json['gender'];
    profileImage = json['profileImage'];
    code = json['code'];
    displayName = json['displayName'];
    companyName = json['companyName'];
    companyNormalizeName = json['companyNormalizeName'];
    companyType = json['companyType'];
    ledgerType = json['ledgerType'];
    normalizeName = json['normalizeName'];
    accountType = json['accountType'];
    dateOfJoin = json['dateOfJoin'];
    dateOfAnniversary = json['dateOfAnniversary'];
    addressType = json['addressType'];
    landMark = json['landMark'];
    street = json['street'];
    area = json['area'];
    zipCode = json['zipCode'];
    website = json['Website'];
    phones = json['phones'];
    if (json['bank'] != null) {
      bank = new List<Bank>();
      json['bank'].forEach((v) {
        bank.add(new Bank.fromJson(v));
      });
    }
    social =
        json['social'] != null ? new Social.fromJson(json['social']) : null;
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
    verifyBy = json['verifyBy'];
    verifyDate = json['verifyDate'];
    designation = json['designation'];
    howKnow = json['howKnow'];
    referenceFrom = json['referenceFrom'];
    isDeleted = json['isDeleted'];
    isActive = json['isActive'];
    androidPlayerId = json['androidPlayerId'];
    status = json['status'];
    connectedSockets = json['connectedSockets'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];
//    isApproved = json['isApproved'];
    isKycUploaded = json['isKycUploaded'];
    founded = json['founded'];
    companySize = json['companySize'];
    videoUrl = json['videoUrl'];
    about = json['about'];
  isVerified = json['isVerified'];
    contactEmail = json['contactEmail'];
    contactMobile = json['contactMobile'];
    name = json['name'];
    addedBy = json['addedBy'];
    updatedBy = json['updatedBy'];
    broker =
        json['broker'] != null ? new Broker.fromJson(json['broker']) : null;
    grpCompany = json['grpCompany'];
    departmentHead = json['departmentHead'];
    department = json['department'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    seller =
        json['seller'] != null ? new Seller.fromJson(json['seller']) : null;
    businessType = json['businessType'];
    createdBy = json['createdBy'];
//    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    hasBroker = json['hasBroker'];
    brokerInfo = json['brokerInfo'] != null
        ? new BrokerInfo.fromJson(json['brokerInfo'])
        : null;
    registrationType = json['registrationType'];
    panNo = json['panNo'];
    specialties = json['specialties'];
    accountTerm = json['accountTerm'];
    if (json['references'] != null) {
      references = new List<References>();
      json['references'].forEach((v) {
        references.add(new References.fromJson(v));
      });
    }
    syncId = json['syncId'];
    companyId = json['companyId'];
    deptId = json['deptId'];
    approvedAt = json['approvedAt'];
    businessId = json['businessId'];
    isSyncAccount = json['isSyncAccount'];
    isDefault = json['isDefault'];
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
    data['profileImage'] = this.profileImage;
    data['code'] = this.code;
    data['displayName'] = this.displayName;
    data['companyName'] = this.companyName;
    data['companyNormalizeName'] = this.companyNormalizeName;
    data['companyType'] = this.companyType;
    data['ledgerType'] = this.ledgerType;
    data['normalizeName'] = this.normalizeName;
    data['accountType'] = this.accountType;
    data['dateOfJoin'] = this.dateOfJoin;
    data['dateOfAnniversary'] = this.dateOfAnniversary;
    data['addressType'] = this.addressType;
    data['address'] = this.address;
    data['landMark'] = this.landMark;
    data['street'] = this.street;
    data['area'] = this.area;
    data['zipCode'] = this.zipCode;
//    data['emails'] = this.emails;
    data['Website'] = this.website;
    data['faxes'] = this.faxes;
    data['phones'] = this.phones;
    data['mobiles'] = this.mobiles;
    if (this.bank != null) {
      data['bank'] = this.bank.map((v) => v.toJson()).toList();
    }
    if (this.social != null) {
      data['social'] = this.social.toJson();
    }
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
    data['gstNo'] = this.gstNo;
    data['verifyBy'] = this.verifyBy;
    data['verifyDate'] = this.verifyDate;
    data['designation'] = this.designation;
    data['howKnow'] = this.howKnow;
    data['referenceFrom'] = this.referenceFrom;
    data['isDeleted'] = this.isDeleted;
    data['isActive'] = this.isActive;
    data['androidPlayerId'] = this.androidPlayerId;
    data['iosPlayerId'] = this.iosPlayerId;
    data['status'] = this.status;
    data['connectedSockets'] = this.connectedSockets;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
//    data['isApproved'] = this.isApproved;
    data['isKycUploaded'] = this.isKycUploaded;
    data['founded'] = this.founded;
    data['companySize'] = this.companySize;
    data['videoUrl'] = this.videoUrl;
    data['about'] = this.about;
    data['showPublicly'] = this.showPublicly;
    data['coverImage'] = this.coverImage;
    data['isVerified'] = this.isVerified;
    if (this.group != null) {
      data['group'] = this.group.map((v) => v.toJson()).toList();
    }
    data['contactEmail'] = this.contactEmail;
    data['contactMobile'] = this.contactMobile;
    data['name'] = this.name;
    data['natureOfOrg'] = this.natureOfOrg;
    if (this.kyc != null) {
      data['kyc'] = this.kyc.map((v) => v.toJson()).toList();
    }
    data['lastLoginDate'] = this.lastLoginDate;
    data['addedBy'] = this.addedBy;
    data['updatedBy'] = this.updatedBy;
    if (this.broker != null) {
      data['broker'] = this.broker.toJson();
    }
    data['grpCompany'] = this.grpCompany;
    data['departmentHead'] = this.departmentHead;
    data['department'] = this.department;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    if (this.seller != null) {
      data['seller'] = this.seller.toJson();
    }
    data['businessType'] = this.businessType;
    data['createdBy'] = this.createdBy;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['hasBroker'] = this.hasBroker;
    if (this.brokerInfo != null) {
      data['brokerInfo'] = this.brokerInfo.toJson();
    }
    data['registrationType'] = this.registrationType;
    data['panNo'] = this.panNo;
    data['specialties'] = this.specialties;
    data['accountTerm'] = this.accountTerm;
    if (this.references != null) {
      data['references'] = this.references.map((v) => v.toJson()).toList();
    }
    data['syncId'] = this.syncId;
    data['syncExtra'] = this.syncExtra;
    data['isFm'] = this.isFm;
    data['approvedBy'] = this.approvedBy;
    data['companyId'] = this.companyId;
    data['deptId'] = this.deptId;
    data['approvedAt'] = this.approvedAt;
    data['businessId'] = this.businessId;
    data['isSpam'] = this.isSpam;
    data['isSyncAccount'] = this.isSyncAccount;
    data['isDefault'] = this.isDefault;
    return data;
  }
}

class Bank {
  String bankName;
  String branchName;
  String currency;
  String account;
  String acNo;
  String acType;
  String ifsc;
  String swiftCode;

  Bank(
      {this.bankName,
      this.branchName,
      this.currency,
      this.account,
      this.acNo,
      this.acType,
      this.ifsc,
      this.swiftCode});

  Bank.fromJson(Map<String, dynamic> json) {
    bankName = json['bankName'];
    branchName = json['branchName'];
    currency = json['currency'];
    account = json['account'];
    acNo = json['acNo'];
    acType = json['acType'];
    ifsc = json['ifsc'];
    swiftCode = json['swiftCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankName'] = this.bankName;
    data['branchName'] = this.branchName;
    data['currency'] = this.currency;
    data['account'] = this.account;
    data['acNo'] = this.acNo;
    data['acType'] = this.acType;
    data['ifsc'] = this.ifsc;
    data['swiftCode'] = this.swiftCode;
    return data;
  }
}

class Social {
  String facebook;
  String pinterest;
  String instagram;

  Social({this.facebook, this.pinterest, this.instagram});

  Social.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'];
    pinterest = json['pinterest'];
    instagram = json['instagram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facebook'] = this.facebook;
    data['pinterest'] = this.pinterest;
    data['instagram'] = this.instagram;
    return data;
  }
}

class Group {
  String id;
  String time;
  bool isActive;

  Group({this.id, this.time, this.isActive});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['isActive'] = this.isActive;
    return data;
  }
}

class Kyc {
  String path;
  String status;
  String docType;

  Kyc({this.path, this.status, this.docType});

  Kyc.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    status = json['status'];
    docType = json['docType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['status'] = this.status;
    data['docType'] = this.docType;
    return data;
  }
}

class Broker {
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
  List<String> emails;
  String website;
  List<String> faxes;
  Null phones;
  List<String> mobiles;
  List<Bank> bank;
  Null social;
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
  String designation;
  String howKnow;
  String referenceFrom;
  bool isDeleted;
  bool isActive;
  Null androidPlayerId;
  Null iosPlayerId;
  int status;
  Null connectedSockets;
  String updateIp;
  String createIp;
  String approvedAt;
  bool isApproved;
  bool isKycUploaded;
  String founded;
  String specialties;
  String companySize;
  String videoUrl;
  String about;
  bool showPublicly;
  String coverImage;
  int isVerified;
  List<Group> group;
  List<References> references;
  String contactEmail;
  String contactMobile;
  String name;
  String syncId;
  Null syncExtra;
  bool isFm;
  List<String> natureOfOrg;
  List<Kyc> kyc;
  Null addedBy;
  String updatedBy;
  Null broker;
  Null grpCompany;
  Null departmentHead;
  Null department;
  String country;
  String state;
  String city;
  String seller;
  String businessType;
  Null createdBy;
  Null accountTerm;
  Null approvedBy;
  Null companyId;
  Null deptId;
  String user;

  Broker(
      {this.createdAt,
      this.updatedAt,
      this.id,
      this.stockCategory,
      this.vendorLogo,
      this.vendorCode,
      this.vendorNormalizeCode,
      this.vendorNo,
      this.prefix,
      this.gender,
      this.profileImage,
      this.code,
      this.displayName,
      this.companyName,
      this.companyNormalizeName,
      this.companyType,
      this.ledgerType,
      this.normalizeName,
      this.accountType,
      this.hasBroker,
      this.brokerInfo,
      this.registrationType,
      this.dateOfJoin,
      this.dateOfAnniversary,
      this.addressType,
      this.address,
      this.landMark,
      this.street,
      this.area,
      this.zipCode,
      this.emails,
      this.website,
      this.faxes,
      this.phones,
      this.mobiles,
      this.bank,
      this.social,
      this.defaultNarration,
      this.orderEmail,
      this.newStoneEmail,
      this.newsEventEmail,
      this.noOfEmployee,
      this.contactSource,
      this.dateOfBirth,
      this.accountName,
      this.isSubscribeForNewGoodFavourite,
      this.isSubscribeForNewGoodPurchase,
      this.isSubscribeForNotification,
      this.gstNo,
      this.panNo,
      this.verifyBy,
      this.verifyDate,
      this.designation,
      this.howKnow,
      this.referenceFrom,
      this.isDeleted,
      this.isActive,
      this.androidPlayerId,
      this.iosPlayerId,
      this.status,
      this.connectedSockets,
      this.updateIp,
      this.createIp,
      this.approvedAt,
      this.isApproved,
      this.isKycUploaded,
      this.founded,
      this.specialties,
      this.companySize,
      this.videoUrl,
      this.about,
      this.showPublicly,
      this.coverImage,
      this.isVerified,
      this.group,
      this.references,
      this.contactEmail,
      this.contactMobile,
      this.name,
      this.syncId,
      this.syncExtra,
      this.isFm,
      this.natureOfOrg,
      this.kyc,
      this.addedBy,
      this.updatedBy,
      this.broker,
      this.grpCompany,
      this.departmentHead,
      this.department,
      this.country,
      this.state,
      this.city,
      this.seller,
      this.businessType,
      this.createdBy,
      this.accountTerm,
      this.approvedBy,
      this.companyId,
      this.deptId,
      this.user});

  Broker.fromJson(Map<String, dynamic> json) {
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
    profileImage = json['profileImage'];
    code = json['code'];
    displayName = json['displayName'];
    companyName = json['companyName'];
    companyNormalizeName = json['companyNormalizeName'];
    companyType = json['companyType'];
    ledgerType = json['ledgerType'];
    normalizeName = json['normalizeName'];
    accountType = json['accountType'];
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
//    emails = json['emails'].cast<String>();
    website = json['Website'];
//    faxes = json['faxes'].cast<String>();
    phones = json['phones'];
//    mobiles = json['mobiles'].cast<String>();
    if (json['bank'] != null) {
      bank = new List<Bank>();
      json['bank'].forEach((v) {
        bank.add(new Bank.fromJson(v));
      });
    }
    social = json['social'];
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
    designation = json['designation'];
    howKnow = json['howKnow'];
    referenceFrom = json['referenceFrom'];
    isDeleted = json['isDeleted'];
    isActive = json['isActive'];
    androidPlayerId = json['androidPlayerId'];
    iosPlayerId = json['iosPlayerId'];
    status = json['status'];
    connectedSockets = json['connectedSockets'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];
    approvedAt = json['approvedAt'];
//    isApproved = json['isApproved'];
    isKycUploaded = json['isKycUploaded'];
    founded = json['founded'];
    specialties = json['specialties'];
    companySize = json['companySize'];
    videoUrl = json['videoUrl'];
    about = json['about'];
    showPublicly = json['showPublicly'];
    coverImage = json['coverImage'];
    isVerified = json['isVerified'];
    if (json['group'] != null) {
      group = new List<Group>();
      json['group'].forEach((v) {
        group.add(new Group.fromJson(v));
      });
    }
    if (json['references'] != null) {
      references = new List<References>();
      json['references'].forEach((v) {
        references.add(new References.fromJson(v));
      });
    }
    contactEmail = json['contactEmail'];
    contactMobile = json['contactMobile'];
    name = json['name'];
    syncId = json['syncId'];
    syncExtra = json['syncExtra'];
    isFm = json['isFm'];
//    natureOfOrg = json['natureOfOrg'].cast<String>();
    if (json['kyc'] != null) {
      kyc = new List<Kyc>();
      json['kyc'].forEach((v) {
        kyc.add(new Kyc.fromJson(v));
      });
    }
    addedBy = json['addedBy'];
    updatedBy = json['updatedBy'];
    broker = json['broker'];
    grpCompany = json['grpCompany'];
    departmentHead = json['departmentHead'];
    department = json['department'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    seller = json['seller'];
    businessType = json['businessType'];
    createdBy = json['createdBy'];
    accountTerm = json['accountTerm'];
    approvedBy = json['approvedBy'];
    companyId = json['companyId'];
    deptId = json['deptId'];
    user = json['user'];
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
    data['profileImage'] = this.profileImage;
    data['code'] = this.code;
    data['displayName'] = this.displayName;
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
    data['emails'] = this.emails;
    data['Website'] = this.website;
    data['faxes'] = this.faxes;
    data['phones'] = this.phones;
    data['mobiles'] = this.mobiles;
    if (this.bank != null) {
      data['bank'] = this.bank.map((v) => v.toJson()).toList();
    }
    data['social'] = this.social;
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
    data['gstNo'] = this.gstNo;
    data['panNo'] = this.panNo;
    data['verifyBy'] = this.verifyBy;
    data['verifyDate'] = this.verifyDate;
    data['designation'] = this.designation;
    data['howKnow'] = this.howKnow;
    data['referenceFrom'] = this.referenceFrom;
    data['isDeleted'] = this.isDeleted;
    data['isActive'] = this.isActive;
    data['androidPlayerId'] = this.androidPlayerId;
    data['iosPlayerId'] = this.iosPlayerId;
    data['status'] = this.status;
    data['connectedSockets'] = this.connectedSockets;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
    data['approvedAt'] = this.approvedAt;
    data['isApproved'] = this.isApproved;
    data['isKycUploaded'] = this.isKycUploaded;
    data['founded'] = this.founded;
    data['specialties'] = this.specialties;
    data['companySize'] = this.companySize;
    data['videoUrl'] = this.videoUrl;
    data['about'] = this.about;
    data['showPublicly'] = this.showPublicly;
    data['coverImage'] = this.coverImage;
    data['isVerified'] = this.isVerified;
    if (this.group != null) {
      data['group'] = this.group.map((v) => v.toJson()).toList();
    }
    if (this.references != null) {
      data['references'] = this.references.map((v) => v.toJson()).toList();
    }
    data['contactEmail'] = this.contactEmail;
    data['contactMobile'] = this.contactMobile;
    data['name'] = this.name;
    data['syncId'] = this.syncId;
    data['syncExtra'] = this.syncExtra;
    data['isFm'] = this.isFm;
    data['natureOfOrg'] = this.natureOfOrg;
    if (this.kyc != null) {
      data['kyc'] = this.kyc.map((v) => v.toJson()).toList();
    }
    data['addedBy'] = this.addedBy;
    data['updatedBy'] = this.updatedBy;
    data['broker'] = this.broker;
    data['grpCompany'] = this.grpCompany;
    data['departmentHead'] = this.departmentHead;
    data['department'] = this.department;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['seller'] = this.seller;
    data['businessType'] = this.businessType;
    data['createdBy'] = this.createdBy;
    data['accountTerm'] = this.accountTerm;
    data['approvedBy'] = this.approvedBy;
    data['companyId'] = this.companyId;
    data['deptId'] = this.deptId;
    data['user'] = this.user;
    return data;
  }
}

class References {
  String companyName;
  String personName;
  String mobile;

  References({this.companyName, this.personName, this.mobile});

  References.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    personName = json['personName'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyName'] = this.companyName;
    data['personName'] = this.personName;
    data['mobile'] = this.mobile;
    return data;
  }
}

/*class Kyc {
  String path;

  Kyc({this.path});

  Kyc.fromJson(Map<String, dynamic> json) {
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    return data;
  }
}*/

class Seller {
  String updatedAt;
  String id;
  String firstName;
  String lastName;
  String name;
  String address;
  int otpNumber;
  String username;
  String email;
  String mobile;
  int type;
  bool isEmailVerified;
  int isVerified;
  int status;
  SyncExtra syncExtra;
  String designation;
  String pinCode;
  List<String> roles;
  FailedAttempts failedAttempts;
  int noKycLogInAttempts;
  String state;
  String country;
  String createdAt;
  String companyName;
  String companyAddress;
  String spaceCodeIp;
  String hostName;
  String macAddress;
  String toAuthenticate;
  bool isDeleted;
  bool isActive;
  Setting setting;
  Null androidPlayerId;
  Null iosPlayerId;
  Null connectedSockets;
  int termsDiscount;
  ResetPasswordLink resetPasswordLink;
  Null apiTokens;
  String anniversary;
  String businessId;
  String businessType;
  String countryCode;
  String device;
  String dob;
  String fax;
  String gender;
  String howKnow;
  String phone;
  String photoId;
  String reference;
  bool updateRequired;
  bool isIntoHide;
  String updateIp;
  String createIp;
  BrokerInfo loggedInSession;
  String updatedBy;

//  Null account;
//  Null accountTerm;
//  Null defaultFilter;
//  Null city;
  String createdBy;
  String vendorNo;
  String middleName;
  bool isOtpVerified;
  int roleType;
  String emailHash;
  String dateOfJoin;
  String clientSecret;
  String profileImage;
  String whatsapp;
  String whatsappCounCode;
  String skype;
  String wechat;
  BrokerInfo token;
  int version;
  bool isTermsCondAgree;
  String termsCondAgreeAt;
  List<Null> termsCondHistory;
  Null loginOtp;
  String group;
  bool sendPromotions;
  Null addedBy;
  Null seller;
  Null companyId;
  Null deptId;
  String mPin;
  bool isMpinAdded;
  Null resetmPinLink;

  Seller(
      {this.updatedAt,
      this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.address,
      this.otpNumber,
      this.username,
      this.email,
      this.mobile,
      this.type,
      this.isEmailVerified,
      this.isVerified,
      this.status,
      this.syncExtra,
      this.designation,
      this.pinCode,
      this.roles,
      this.failedAttempts,
      this.noKycLogInAttempts,
      this.state,
      this.country,
      this.createdAt,
      this.companyName,
      this.companyAddress,
      this.spaceCodeIp,
      this.hostName,
      this.macAddress,
      this.toAuthenticate,
      this.isDeleted,
      this.isActive,
      this.setting,
      this.androidPlayerId,
      this.iosPlayerId,
      this.connectedSockets,
      this.termsDiscount,
      this.resetPasswordLink,
      this.apiTokens,
      this.anniversary,
      this.businessId,
      this.businessType,
      this.countryCode,
      this.device,
      this.dob,
      this.fax,
      this.gender,
      this.howKnow,
      this.phone,
      this.photoId,
      this.reference,
      this.updateRequired,
      this.isIntoHide,
      this.updateIp,
      this.createIp,
      this.loggedInSession,
      this.updatedBy,
      this.createdBy,
      this.vendorNo,
      this.middleName,
      this.isOtpVerified,
      this.roleType,
      this.emailHash,
      this.dateOfJoin,
      this.clientSecret,
      this.profileImage,
      this.whatsapp,
      this.whatsappCounCode,
      this.skype,
      this.wechat,
      this.token,
      this.version,
      this.isTermsCondAgree,
      this.termsCondAgreeAt,
      this.termsCondHistory,
      this.loginOtp,
      this.group,
      this.sendPromotions,
      this.addedBy,
      this.seller,
      this.companyId,
      this.deptId,
      this.mPin,
      this.isMpinAdded,
      this.resetmPinLink});

  Seller.fromJson(Map<String, dynamic> json) {
    updatedAt = json['updatedAt'];
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    name = json['name'];
    address = json['address'];
    otpNumber = json['otpNumber'];
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    type = json['type'];
    isEmailVerified = json['isEmailVerified'];
    isVerified = json['isVerified'];
    status = json['status'];
    syncExtra = json['syncExtra'] != null
        ? new SyncExtra.fromJson(json['syncExtra'])
        : null;
    designation = json['designation'];
    pinCode = json['pinCode'];
    roles = json['roles'].cast<String>();
    failedAttempts = json['failedAttempts'] != null
        ? new FailedAttempts.fromJson(json['failedAttempts'])
        : null;
    noKycLogInAttempts = json['noKycLogInAttempts'];
    state = json['state'];
    country = json['country'];
    createdAt = json['createdAt'];
    companyName = json['companyName'];
    companyAddress = json['companyAddress'];
    spaceCodeIp = json['SpaceCodeIp'];
    hostName = json['hostName'];
    macAddress = json['macAddress'];
    toAuthenticate = json['toAuthenticate'];
    isDeleted = json['isDeleted'];
    isActive = json['isActive'];
    setting =
        json['setting'] != null ? new Setting.fromJson(json['setting']) : null;
    androidPlayerId = json['androidPlayerId'];
    iosPlayerId = json['iosPlayerId'];
    connectedSockets = json['connectedSockets'];
    termsDiscount = json['termsDiscount'];
    resetPasswordLink = json['resetPasswordLink'] != null
        ? new ResetPasswordLink.fromJson(json['resetPasswordLink'])
        : null;
    apiTokens = json['apiTokens'];
    anniversary = json['anniversary'];
    businessId = json['businessId'];
    businessType = json['BusinessType'];
    countryCode = json['countryCode'];
    device = json['device'];
    dob = json['dob'];
    fax = json['fax'];
    gender = json['gender'];
    howKnow = json['howKnow'];
    phone = json['phone'];
    photoId = json['photoId'];
    reference = json['reference'];

    updateRequired = json['updateRequired'];
    isIntoHide = json['isIntoHide'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];

    loggedInSession = json['loggedInSession'] != null
        ? new BrokerInfo.fromJson(json['loggedInSession'])
        : null;
    updatedBy = json['updatedBy'];
//    account = json['account'];
//    accountTerm = json['accountTerm'];
//    defaultFilter = json['defaultFilter'];
//    city = json['city'];
    createdBy = json['createdBy'];
    vendorNo = json['vendorNo'];
    middleName = json['middleName'];
    isOtpVerified = json['isOtpVerified'];
    roleType = json['roleType'];
    emailHash = json['emailHash'];
    dateOfJoin = json['dateOfJoin'];
    clientSecret = json['clientSecret'];
    profileImage = json['profileImage'];
    whatsapp = json['whatsapp'];
    whatsappCounCode = json['whatsappCounCode'];
    skype = json['skype'];
    wechat = json['wechat'];
    token =
        json['token'] != null ? new BrokerInfo.fromJson(json['token']) : null;
    version = json['version'];
    isTermsCondAgree = json['isTermsCondAgree'];
    termsCondAgreeAt = json['termsCondAgreeAt'];
    loginOtp = json['loginOtp'];
    group = json['group'];
    sendPromotions = json['sendPromotions'];
    addedBy = json['addedBy'];
    seller = json['seller'];
    companyId = json['companyId'];
    deptId = json['deptId'];
    mPin = json['mPin'];
    isMpinAdded = json['isMpinAdded'];
    resetmPinLink = json['resetmPinLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['name'] = this.name;
    data['address'] = this.address;
    data['otpNumber'] = this.otpNumber;
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['type'] = this.type;
    data['isEmailVerified'] = this.isEmailVerified;
    data['isVerified'] = this.isVerified;
    data['status'] = this.status;
    if (this.syncExtra != null) {
      data['syncExtra'] = this.syncExtra.toJson();
    }
    data['designation'] = this.designation;
    data['pinCode'] = this.pinCode;
    data['roles'] = this.roles;
    if (this.failedAttempts != null) {
      data['failedAttempts'] = this.failedAttempts.toJson();
    }
    data['noKycLogInAttempts'] = this.noKycLogInAttempts;
    data['state'] = this.state;
    data['country'] = this.country;
    data['createdAt'] = this.createdAt;
    data['companyName'] = this.companyName;
    data['companyAddress'] = this.companyAddress;
    data['SpaceCodeIp'] = this.spaceCodeIp;
    data['hostName'] = this.hostName;
    data['macAddress'] = this.macAddress;
    data['toAuthenticate'] = this.toAuthenticate;
    data['isDeleted'] = this.isDeleted;
    data['isActive'] = this.isActive;
    if (this.setting != null) {
      data['setting'] = this.setting.toJson();
    }
    data['androidPlayerId'] = this.androidPlayerId;
    data['iosPlayerId'] = this.iosPlayerId;
    data['connectedSockets'] = this.connectedSockets;
    data['termsDiscount'] = this.termsDiscount;
    if (this.resetPasswordLink != null) {
      data['resetPasswordLink'] = this.resetPasswordLink.toJson();
    }
    data['apiTokens'] = this.apiTokens;
    data['anniversary'] = this.anniversary;
    data['businessId'] = this.businessId;
    data['BusinessType'] = this.businessType;
    data['countryCode'] = this.countryCode;
    data['device'] = this.device;
    data['dob'] = this.dob;
    data['fax'] = this.fax;
    data['gender'] = this.gender;
    data['howKnow'] = this.howKnow;
    data['phone'] = this.phone;
    data['photoId'] = this.photoId;
    data['reference'] = this.reference;

    data['updateRequired'] = this.updateRequired;
    data['isIntoHide'] = this.isIntoHide;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;

    if (this.loggedInSession != null) {
      data['loggedInSession'] = this.loggedInSession.toJson();
    }
    data['updatedBy'] = this.updatedBy;
//    data['account'] = this.account;
//    data['accountTerm'] = this.accountTerm;
//    data['defaultFilter'] = this.defaultFilter;
//    data['city'] = this.city;
    data['createdBy'] = this.createdBy;
    data['vendorNo'] = this.vendorNo;
    data['middleName'] = this.middleName;
    data['isOtpVerified'] = this.isOtpVerified;
    data['roleType'] = this.roleType;
    data['emailHash'] = this.emailHash;
    data['dateOfJoin'] = this.dateOfJoin;
    data['clientSecret'] = this.clientSecret;
    data['profileImage'] = this.profileImage;
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

    data['loginOtp'] = this.loginOtp;
    data['group'] = this.group;
    data['sendPromotions'] = this.sendPromotions;
    data['addedBy'] = this.addedBy;
    data['seller'] = this.seller;
    data['companyId'] = this.companyId;
    data['deptId'] = this.deptId;
    data['mPin'] = this.mPin;
    data['isMpinAdded'] = this.isMpinAdded;
    data['resetmPinLink'] = this.resetmPinLink;
    return data;
  }
}

class SyncExtra {
  Null middleName;
  String webEmailId;
  String webUserId;
  int addSeq;
  Null address2;
  Null address3;
  Null city;
  String phoneNo;
  int citySeq;
  int stateSeq;
  int countrySeq;
  int designationSeq;
  Null insTime;
  Null updTime;
  Null webUserName;
  Null country;
  String emailId;
  Null mobileNo;
  String address1;

  SyncExtra(
      {this.middleName,
      this.webEmailId,
      this.webUserId,
      this.addSeq,
      this.address2,
      this.address3,
      this.city,
      this.phoneNo,
      this.citySeq,
      this.stateSeq,
      this.countrySeq,
      this.designationSeq,
      this.insTime,
      this.updTime,
      this.webUserName,
      this.country,
      this.emailId,
      this.mobileNo,
      this.address1});

  SyncExtra.fromJson(Map<String, dynamic> json) {
    middleName = json['middle_name'];
    webEmailId = json['web_email_id'];
    webUserId = json['web_user_id'];
    addSeq = json['add_seq'];
    address2 = json['address_2'];
    address3 = json['address_3'];
    city = json['city'];
    phoneNo = json['phone_no'];
    citySeq = json['city_seq'];
    stateSeq = json['state_seq'];
    countrySeq = json['country_seq'];
    designationSeq = json['designation_seq'];
    insTime = json['ins_time'];
    updTime = json['upd_time'];
    webUserName = json['web_user_name'];
    country = json['country'];
    emailId = json['email_id'];
    mobileNo = json['mobile_no'];
    address1 = json['address_1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['middle_name'] = this.middleName;
    data['web_email_id'] = this.webEmailId;
    data['web_user_id'] = this.webUserId;
    data['add_seq'] = this.addSeq;
    data['address_2'] = this.address2;
    data['address_3'] = this.address3;
    data['city'] = this.city;
    data['phone_no'] = this.phoneNo;
    data['city_seq'] = this.citySeq;
    data['state_seq'] = this.stateSeq;
    data['country_seq'] = this.countrySeq;
    data['designation_seq'] = this.designationSeq;
    data['ins_time'] = this.insTime;
    data['upd_time'] = this.updTime;
    data['web_user_name'] = this.webUserName;
    data['country'] = this.country;
    data['email_id'] = this.emailId;
    data['mobile_no'] = this.mobileNo;
    data['address_1'] = this.address1;
    return data;
  }
}

class FailedAttempts {
  String firstFail;
  int count;

  FailedAttempts({this.firstFail, this.count});

  FailedAttempts.fromJson(Map<String, dynamic> json) {
    firstFail = json['firstFail'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstFail'] = this.firstFail;
    data['count'] = this.count;
    return data;
  }
}

class Setting {
  int diamondListLimit;
  int offlineStockLimit;
  AllowedOperations allowedOperations;
  BrokerInfo luckyFilter;

  Setting(
      {this.diamondListLimit,
      this.offlineStockLimit,
      this.allowedOperations,
      this.luckyFilter});

  Setting.fromJson(Map<String, dynamic> json) {
    diamondListLimit = json['diamondListLimit'];
    offlineStockLimit = json['offlineStockLimit'];
    allowedOperations = json['allowedOperations'] != null
        ? new AllowedOperations.fromJson(json['allowedOperations'])
        : null;
    luckyFilter = json['luckyFilter'] != null
        ? new BrokerInfo.fromJson(json['luckyFilter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diamondListLimit'] = this.diamondListLimit;
    data['offlineStockLimit'] = this.offlineStockLimit;
    if (this.allowedOperations != null) {
      data['allowedOperations'] = this.allowedOperations.toJson();
    }
    if (this.luckyFilter != null) {
      data['luckyFilter'] = this.luckyFilter.toJson();
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

class User {
  String id;
  String firstName;
  String lastName;
  String name;
  String username;
  String email;
  String mobile;
  String account;
  Null accountTerm;
  String seller;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.username,
      this.email,
      this.mobile,
      this.account,
      this.accountTerm,
      this.seller});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    account = json['account'];
    accountTerm = json['accountTerm'];
    seller = json['seller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['account'] = this.account;
    data['accountTerm'] = this.accountTerm;
    data['seller'] = this.seller;
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
