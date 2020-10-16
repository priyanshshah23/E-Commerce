import 'package:diamnow/app/app.export.dart';

class StaticPageResp extends BaseApiResp {
  StaticPageRespData data;

  StaticPageResp({this.data});

  StaticPageResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['data'] != null
        ? new StaticPageRespData.fromJson(json['data'])
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

class StaticPageRespData {
  String createdAt;
  String updatedAt;
  String id;
  String code;
  String desc;
  MultiLanguageData multiLanguageData;

  StaticPageRespData(
      {this.createdAt, this.updatedAt, this.id, this.code, this.desc, this.multiLanguageData});

  StaticPageRespData.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    code = json['code'];
    desc = json['description'];
    multiLanguageData = json['multiLanguageData'] != null
        ? new MultiLanguageData.fromJson(json['multiLanguageData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['code'] = this.code;
    data['description'] = this.desc;
    if (this.multiLanguageData != null) {
      data['multiLanguageData'] = this.multiLanguageData.toJson();
    }
    return data;
  }
}

class MultiLanguageData {
  EnUS enUS;
  EnUS arAE;

  MultiLanguageData({this.enUS, this.arAE});

  MultiLanguageData.fromJson(Map<String, dynamic> json) {
    enUS = json['en-US'] != null ? new EnUS.fromJson(json['en-US']) : null;
    arAE = json['ar-AE'] != null ? new EnUS.fromJson(json['ar-AE']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.enUS != null) {
      data['en-US'] = this.enUS.toJson();
    }
    if (this.arAE != null) {
      data['ar-AE'] = this.arAE.toJson();
    }
    return data;
  }
}

class EnUS {
  String description;

  EnUS({this.description});

  EnUS.fromJson(Map<String, dynamic> json) {
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    return data;
  }
}