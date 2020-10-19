
import 'package:diamnow/app/base/BaseApiResp.dart';

class CityListReq {
  String state;
  String country;

  CityListReq({this.state, this.country,});

  CityListReq.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['country'] = this.country;
    return data;
  }
}

class CityListResp extends BaseApiResp {
  List<CityList> data;

  CityListResp({this.data});

  CityListResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      data = new List<CityList>();
      json['data'].forEach((v) {
        data.add(new CityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityList {
  String createdAt;
  String updatedAt;
  String id;
  String name;
  String normalizeName;
  String remark;
  bool isActive;
  bool isDeleted;
  String updateIp;
  String createIp;
//  Null addedBy;
//  Null updatedBy;
  String stateId;
  String countryId;
//  Null createdBy;

  CityList(
      {this.createdAt,
        this.updatedAt,
        this.id,
        this.name,
        this.normalizeName,
        this.remark,
        this.isActive,
        this.isDeleted,
        this.updateIp,
        this.createIp,
//        this.addedBy,
//        this.updatedBy,
        this.stateId,
        this.countryId,
//        this.createdBy,
      });

  CityList.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    name = json['name'];
    normalizeName = json['normalizeName'];
    remark = json['Remark'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];
//    addedBy = json['addedBy'];
//    updatedBy = json['updatedBy'];
    stateId = json['stateId'];
    countryId = json['countryId'];
//    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['normalizeName'] = this.normalizeName;
    data['Remark'] = this.remark;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
//    data['addedBy'] = this.addedBy;
//    data['updatedBy'] = this.updatedBy;
    data['stateId'] = this.stateId;
    data['countryId'] = this.countryId;
//    data['createdBy'] = this.createdBy;
    return data;
  }
}
