
import 'package:diamnow/app/app.export.dart';

class VersionUpdateResp extends BaseApiResp {
  Data data;

  VersionUpdateResp({
    this.data,
  });

  VersionUpdateResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
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
  VersionModel ios;
  VersionModel android;

  Data({this.ios, this.android});

  Data.fromJson(Map<String, dynamic> json) {
    ios = json['ios'] != null ? new VersionModel.fromJson(json['ios']) : null;
    android = json['android'] != null
        ? new VersionModel.fromJson(json['android'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ios != null) {
      data['ios'] = this.ios.toJson();
    }
    if (this.android != null) {
      data['android'] = this.android.toJson();
    }
    return data;
  }
}

class VersionModel {
  String createdAt;
  String updatedAt;
  String id;
  String name;
  int platform;
  bool isActive;
  bool isHardUpdate;
  num number;

//  Null addedBy;
//  Null updatedBy;
//  Null createdBy;

  VersionModel({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.name,
    this.platform,
    this.isActive,
    this.isHardUpdate,
    this.number,
//    this.addedBy,
//    this.updatedBy,
//    this.createdBy,
  });

  VersionModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    name = json['name'];
    platform = json['platform'];
    isActive = json['isActive'];
    isHardUpdate = json['isHardUpdate'];
    number = json['number'];
//    addedBy = json['addedBy'];
//    updatedBy = json['updatedBy'];
//    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['platform'] = this.platform;
    data['isActive'] = this.isActive;
    data['isHardUpdate'] = this.isHardUpdate;
    data['number'] = this.number;
//    data['addedBy'] = this.addedBy;
//    data['updatedBy'] = this.updatedBy;
//    data['createdBy'] = this.createdBy;
    return data;
  }
}
