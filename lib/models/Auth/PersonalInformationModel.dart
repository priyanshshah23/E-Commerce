import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/models/LoginModel.dart';

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

  String country;
  String state;
  String city;
  String zipcode;
  String skype;

  PersonalInformationReq(
      {this.id,
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
      this.city,
      this.country,
      this.state,
      this.zipcode,
//        this.skype,skype
//        this.wechat,
      });

  PersonalInformationReq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    countryCode = json['countryCode'];
//    username = json['username'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
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
    skype = json['skype']??"";
    zipcode = json['zipcode']??"";
//    wechat = json['wechat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id;
    }
    if (this.firstName != null) {
      data['firstName'] = this.firstName;
    }
    if (this.lastName != null) {
      data["lastName"] = this.lastName;
    }
    if (this.email != null) {
      data["email"] = this.email;
    }
//    data['username'] = this.username;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
//    data['pinCode'] = this.pinCode;
//    data['fax'] = this.fax;
//    data['seller'] = this.seller;
//    data['vendorNo'] = this.vendorNo;
    if (this.mobile != null) {
      data['mobile'] = this.mobile;
    }
    if (this.address != null) {
      data['address'] = this.address;
    }
//    data['account'] = this.account;
//    data['name'] = this.name;
//    data['isActive'] = this.isActive;
//    data['androidPlayerId'] = this.androidPlayerId;
//    data['iosPlayerId'] = this.iosPlayerId;
    if (this.profileImage != null) {
      data['profileImage'] = this.profileImage;
    }
    if (this.whatsapp != null) {
      data['whatsapp'] = this.whatsapp;
    }
//    data['dob'] = this.dob;
//    data['gender'] = this.gender;
//    data['phone'] = this.phone;
//    data['photoId'] = this.photoId;
//    data['reference'] = this.reference;
    if (this.whatsappCounCode != null) {
      data['whatsappCounCode'] = this.whatsappCounCode;
    }
    if (this.countryCode != null) {
      data['countryCode'] = this.countryCode;
    }
    if(!isNullEmptyOrFalse(this.skype))
      data['skype'] = this.skype;
    if(!isNullEmptyOrFalse(this.zipcode))
      data['zipcode'] = this.zipcode;
//    data['skype'] = this.skype;
//    data['wechat'] = this.wechat;
    return data;
  }
}

class PersonalInformationViewResp extends BaseApiResp {
  User data;

  PersonalInformationViewResp({this.data});

  PersonalInformationViewResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['data'] != null ? new User.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
