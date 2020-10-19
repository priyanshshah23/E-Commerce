import 'package:diamnow/app/app.export.dart';

class StateListReq {
  String country;

  StateListReq({this.country});

  StateListReq.fromJson(Map<String, dynamic> json) {
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    return data;
  }
}

class StateListResp extends BaseApiResp{
  List<StateList> data;

  StateListResp({this.data});

  StateListResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      data = new List<StateList>();
      json['data'].forEach((v) {
        data.add(new StateList.fromJson(v));
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

class StateList {
  String createdAt;
  String updatedAt;
  String id;
  String name;
  String normalizeName;
  String sTDCode;
  String stateCode;
  String stateType;
  String remark;
  bool isActive;
  bool isDeleted;
  String updateIp;
  String createIp;
//  Null addedBy;
//  Null updatedBy;
  String countryId;
//  Null createdBy;

  StateList(
      {this.createdAt,
        this.updatedAt,
        this.id,
        this.name,
        this.normalizeName,
        this.sTDCode,
        this.stateCode,
        this.stateType,
        this.remark,
        this.isActive,
        this.isDeleted,
        this.updateIp,
        this.createIp,
//        this.addedBy,
//        this.updatedBy,
        this.countryId,
//        this.createdBy,
      });

  StateList.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    name = json['name'];
    normalizeName = json['normalizeName'];
    sTDCode = json['STDCode'];
    stateCode = json['stateCode'];
    stateType = json['stateType'];
    remark = json['Remark'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];
//    addedBy = json['addedBy'];
//    updatedBy = json['updatedBy'];
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
    data['STDCode'] = this.sTDCode;
    data['stateCode'] = this.stateCode;
    data['stateType'] = this.stateType;
    data['Remark'] = this.remark;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
//    data['addedBy'] = this.addedBy;
//    data['updatedBy'] = this.updatedBy;
    data['countryId'] = this.countryId;
//    data['createdBy'] = this.createdBy;
    return data;
  }
}
