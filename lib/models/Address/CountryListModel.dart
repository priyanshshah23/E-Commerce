import 'package:diamnow/app/app.export.dart';

class CountryListResp extends BaseApiResp{
  List<CountryList> data;

  CountryListResp({ this.data});

  CountryListResp.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    if (json['data'] != null) {
      data = new List<CountryList>();
      json['data'].forEach((v) {
        data.add(new CountryList.fromJson(v));
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

class CountryList {
  String createdAt;
  String updatedAt;
  String id;
  String name;
  String normalizeName;
  String code;
  String iSDCode;
  String timeZone;
  String localIsoTime;
  String remark;
  bool isActive;
  bool isDeleted;
  String updateIp;
  String createIp;
  int sortingSequence;
//  Null addedBy;
//  Null updatedBy;
//  Null createdBy;
  List<String> likeKeyWords;

  CountryList(
      {this.createdAt,
        this.updatedAt,
        this.id,
        this.name,
        this.normalizeName,
        this.code,
        this.iSDCode,
        this.timeZone,
        this.localIsoTime,
        this.remark,
        this.isActive,
        this.isDeleted,
        this.updateIp,
        this.createIp,
        this.sortingSequence,
//        this.addedBy,
//        this.updatedBy,
//        this.createdBy,
        this.likeKeyWords});

  CountryList.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    name = json['name'];
    normalizeName = json['normalizeName'];
    code = json['code'];
    iSDCode = json['ISDCode'];
    timeZone = json['timeZone'];
    localIsoTime = json['localIsoTime'];
    remark = json['Remark'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];
    sortingSequence = json['sortingSequence'];
//    addedBy = json['addedBy'];
//    updatedBy = json['updatedBy'];
//    createdBy = json['createdBy'];
    likeKeyWords = json['likeKeyWords'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['normalizeName'] = this.normalizeName;
    data['code'] = this.code;
    data['ISDCode'] = this.iSDCode;
    data['timeZone'] = this.timeZone;
    data['localIsoTime'] = this.localIsoTime;
    data['Remark'] = this.remark;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
    data['sortingSequence'] = this.sortingSequence;
//    data['addedBy'] = this.addedBy;
//    data['updatedBy'] = this.updatedBy;
//    data['createdBy'] = this.createdBy;
    data['likeKeyWords'] = this.likeKeyWords;
    return data;
  }
}
