import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';

class CompanyInformationReq {
  String sId;
  String companyName;
//  String dateOfJoin;
//  String companyType;
  String businessType;
  String country;
  String state;
  String city;
  String address;
  String zipCode;
  String vendorCode;

  CompanyInformationReq(
      {this.sId,
        this.companyName,
//        this.dateOfJoin,
//        this.companyType,
        this.businessType,
        this.country,
        this.state,
        this.city,
        this.address,
        this.zipCode,
        this.vendorCode});

  CompanyInformationReq.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    companyName = json['companyName'];
//    dateOfJoin = json["dateOfJoin"];
//    companyType = json['companyType'];
    businessType = json['businessType'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    zipCode = json['zipCode'];
    vendorCode = json['vendorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['companyName'] = this.companyName;
//    data['dateOfJoin'] = this.dateOfJoin;
//    data['companyType'] = this.companyType;
    data['businessType'] = this.businessType;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['address'] = this.address;
    data['zipCode'] = this.zipCode;
    data['vendorCode'] = this.vendorCode;
    return data;
  }

}

class CompanyInformation {
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
  List<String> emails;
  String website;
  List<String> faxes;
//  Null phones;
  List<String> mobiles;
//  Null bank;
//  Null social;
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
//  Null androidPlayerId;
//  Null iosPlayerId;
  int status;
//  Null connectedSockets;
  String updateIp;
  String createIp;
  bool isApproved;
  String founded;
  String specialties;
  String companySize;
  String videoUrl;
  String about;
  bool showPublicly;
  String coverImage;
  int isVerified;
//  List<Null> group;
  String contactEmail;
  String contactMobile;
  bool isFm;
  String addedBy;
  String updatedBy;
//  Null grpCompany;
//  Null departmentHead;
//  Null department;
  String country;
  String state;
  String city;
  String businessType;
//  Null createdBy;
//  Null accountTerm;

  CompanyInformation(
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
        this.name,
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
//        this.phones,
        this.mobiles,
//        this.bank,
//        this.social,
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
//        this.androidPlayerId,
//        this.iosPlayerId,
        this.status,
//        this.connectedSockets,
        this.updateIp,
        this.createIp,
        this.isApproved,
        this.founded,
        this.specialties,
        this.companySize,
        this.videoUrl,
        this.about,
        this.showPublicly,
        this.coverImage,
        this.isVerified,
//        this.group,
        this.contactEmail,
        this.contactMobile,
        this.isFm,
        this.addedBy,
        this.updatedBy,
//        this.grpCompany,
//        this.departmentHead,
//        this.department,
        this.country,
        this.state,
        this.city,
        this.businessType,
//        this.createdBy,
//        this.accountTerm,
      });

  CompanyInformation.fromJson(Map<String, dynamic> json) {
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
    emails = json['emails'].cast<String>();
    website = json['Website'];
    faxes = json['faxes'].cast<String>();
//    phones = json['phones'];
    mobiles = json['mobiles'].cast<String>();
//    bank = json['bank'];
//    social = json['social'];
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
//    androidPlayerId = json['androidPlayerId'];
//    iosPlayerId = json['iosPlayerId'];
    status = json['status'];
//    connectedSockets = json['connectedSockets'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];
    isApproved = json['isApproved'];
    founded = json['founded'];
    specialties = json['specialties'];
    companySize = json['companySize'];
    videoUrl = json['videoUrl'];
    about = json['about'];
    showPublicly = json['showPublicly'];
    coverImage = json['coverImage'];
    isVerified = json['isVerified'];
//    if (json['group'] != null) {
//      group = new List<Null>();
//      json['group'].forEach((v) {
//        group.add(new Null.fromJson(v));
//      });
//    }
    contactEmail = json['contactEmail'];
    contactMobile = json['contactMobile'];
    isFm = json['isFm'];
    addedBy = json['addedBy'];
    updatedBy = json['updatedBy'];
//    grpCompany = json['grpCompany'];
//    departmentHead = json['departmentHead'];
//    department = json['department'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    businessType = json['businessType'];
//    createdBy = json['createdBy'];
//    accountTerm = json['accountTerm'];
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
//    data['phones'] = this.phones;
    data['mobiles'] = this.mobiles;
//    data['bank'] = this.bank;
//    data['social'] = this.social;
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
//    data['androidPlayerId'] = this.androidPlayerId;
//    data['iosPlayerId'] = this.iosPlayerId;
    data['status'] = this.status;
//    data['connectedSockets'] = this.connectedSockets;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
    data['isApproved'] = this.isApproved;
    data['founded'] = this.founded;
    data['specialties'] = this.specialties;
    data['companySize'] = this.companySize;
    data['videoUrl'] = this.videoUrl;
    data['about'] = this.about;
    data['showPublicly'] = this.showPublicly;
    data['coverImage'] = this.coverImage;
    data['isVerified'] = this.isVerified;
//    if (this.group != null) {
//      data['group'] = this.group.map((v) => v.toJson()).toList();
//    }
    data['contactEmail'] = this.contactEmail;
    data['contactMobile'] = this.contactMobile;
    data['isFm'] = this.isFm;
    data['addedBy'] = this.addedBy;
    data['updatedBy'] = this.updatedBy;
//    data['grpCompany'] = this.grpCompany;
//    data['departmentHead'] = this.departmentHead;
//    data['department'] = this.department;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['businessType'] = this.businessType;
//    data['createdBy'] = this.createdBy;
//    data['accountTerm'] = this.accountTerm;
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

class CompanyInformationViewResp extends BaseApiResp{
  CompanyInformationViewData data;

  CompanyInformationViewResp({ this.data});

  CompanyInformationViewResp.fromJson(Map<String, dynamic> json)  : super.fromJson(json){
    data = json['data'] != null ? new CompanyInformationViewData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class CompanyInformationViewData {
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
  String dateOfJoin;
  String dateOfAnniversary;
  String addressType;
  String address;
  String landMark;
  String street;
  String area;
  String zipCode;
//  Null emails;
  String website;
//  Null faxes;
//  Null phones;
//  Null mobiles;
//  Null bank;
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
//  Null androidPlayerId;
//  Null iosPlayerId;
  int status;
//  Null connectedSockets;
  String updateIp;
  String createIp;
  String founded;
  String companySize;
  String videoUrl;
  String about;
  bool showPublicly;
  String coverImage;
  int isVerified;
  List<Group> group;
  String addedBy;
  String updatedBy;
//  Null grpCompany;
//  Null departmentHead;
//  Null department;
  CountryList country;
  StateList state;
  CityList city;
  String seller;
  String businessType;
  String createdBy;

  CompanyInformationViewData(
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
        this.name,
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
//        this.emails,
        this.website,
//        this.faxes,
//        this.phones,
//        this.mobiles,
//        this.bank,
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
//        this.androidPlayerId,
//        this.iosPlayerId,
        this.status,
//        this.connectedSockets,
        this.updateIp,
        this.createIp,
        this.founded,
        this.companySize,
        this.videoUrl,
        this.about,
        this.showPublicly,
        this.coverImage,
        this.isVerified,
        this.group,
        this.addedBy,
        this.updatedBy,
//        this.grpCompany,
//        this.departmentHead,
//        this.department,
        this.country,
        this.state,
        this.city,
        this.seller,
        this.businessType,
        this.createdBy});

  CompanyInformationViewData.fromJson(Map<String, dynamic> json) {
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
    dateOfJoin = json['dateOfJoin'];
    dateOfAnniversary = json['dateOfAnniversary'];
    addressType = json['addressType'];
    address = json['address'];
    landMark = json['landMark'];
    street = json['street'];
    area = json['area'];
    zipCode = json['zipCode'];
//    emails = json['emails'];
    website = json['Website'];
//    faxes = json['faxes'];
//    phones = json['phones'];
//    mobiles = json['mobiles'];
//    bank = json['bank'];
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
//    androidPlayerId = json['androidPlayerId'];
//    iosPlayerId = json['iosPlayerId'];
    status = json['status'];
//    connectedSockets = json['connectedSockets'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];
    founded = json['founded'];
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
    addedBy = json['addedBy'];
    updatedBy = json['updatedBy'];
//    grpCompany = json['grpCompany'];
//    departmentHead = json['departmentHead'];
//    department = json['department'];
    country =
    json['country'] != null ? new CountryList.fromJson(json['country']) : null;
    state = json['state'] != null ? new StateList.fromJson(json['state']) : null;
    city = json['city'] != null ? new CityList.fromJson(json['city']) : null;
    seller = json['seller'];
    businessType = json['businessType'];
    createdBy = json['createdBy'];
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
//    data['faxes'] = this.faxes;
//    data['phones'] = this.phones;
//    data['mobiles'] = this.mobiles;
//    data['bank'] = this.bank;
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
//    data['androidPlayerId'] = this.androidPlayerId;
//    data['iosPlayerId'] = this.iosPlayerId;
    data['status'] = this.status;
//    data['connectedSockets'] = this.connectedSockets;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
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
    data['addedBy'] = this.addedBy;
    data['updatedBy'] = this.updatedBy;
//    data['grpCompany'] = this.grpCompany;
//    data['departmentHead'] = this.departmentHead;
//    data['department'] = this.department;
    if (this.country != null) {
      data['country'] = this.country.toJson();
    }
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    data['seller'] = this.seller;
    data['businessType'] = this.businessType;
    data['createdBy'] = this.createdBy;
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
  bool isActive;
  String time;

  Group({this.id, this.isActive, this.time});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['isActive'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isActive'] = this.isActive;
    data['time'] = this.time;
    return data;
  }
}
