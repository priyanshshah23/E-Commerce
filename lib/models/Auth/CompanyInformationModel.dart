import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:diamnow/models/LoginModel.dart';

class CompanyInformationReq {
  String sId;
  String companyName;
//  String dateOfJoin;
//  String companyType;
  String businessType;
  String natureOfOrg;
  String country;
  String state;
  String city;
  String address;
  String landMark;
  String zipCode;
  String vendorCode;
  String businessId;

  CompanyInformationReq(
      {this.sId,
      this.companyName,
//        this.dateOfJoin,
//        this.companyType,
      this.businessType,
      this.natureOfOrg,
      this.country,
      this.state,
      this.city,
      this.address,
      this.landMark,
      this.zipCode,
      this.businessId,
      this.vendorCode});

  CompanyInformationReq.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    companyName = json['companyName'];
//    dateOfJoin = json["dateOfJoin"];
//    companyType = json['companyType'];
    businessType = json['businessType'];
    natureOfOrg = json['natureOfOrg'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    landMark = json['landMark'];
    businessId = json['businessId'];
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
    data['natureOfOrg'] = this.natureOfOrg;
    data['country'] = this.country;
    data['businessId'] = this.businessId;
    data['state'] = this.state;
    data['city'] = this.city;
    data['address'] = this.address;
    data['landMark'] = this.landMark;
    data['zipCode'] = this.zipCode;
    data['vendorCode'] = this.vendorCode;
    return data;
  }
}

class CompanyInformationViewResp extends BaseApiResp {
  Account data;

  CompanyInformationViewResp({this.data});

  CompanyInformationViewResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['data'] != null ? new Account.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
