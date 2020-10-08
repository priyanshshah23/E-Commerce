import 'dart:convert';

import 'package:diamnow/app/app.export.dart';

class MasterReq {
  String serverLastSync;

  MasterReq({this.serverLastSync});

  MasterReq.fromJson(Map<String, dynamic> json) {
    serverLastSync = json['lastSyncDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastSyncDate'] = this.serverLastSync;
    return data;
  }
}

class MasterResp extends BaseApiResp {
  MasterRespData data;

  MasterResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data =
        json['data'] != null ? new MasterRespData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Master {
  bool isActive;
  bool isDefault;

  // List<Null> likeKeywords;
  // List<String> subMasters;
  bool isDeleted = false;
  String sId;
  String name;
  String code;
  // String slug;
  String normalizeName;
  int sortingSequence;
  // String group;
  String description;
  String image;
  // String icon;
  String parentId;
  // String createdAt;
  // String updatedAt;
  // int iV;
  MultiLanguageData multiLanguageData;
  bool isSelected = false;

  Master(
      {this.isActive,
      this.isDefault,
      // this.likeKeywords,
      // this.subMasters,
      this.isDeleted,
      this.sId,
      this.name,
      this.code,
      // this.slug,
      this.normalizeName,
      this.sortingSequence,
      // this.group,
      this.description,
      this.image,
      // this.icon,
      this.parentId,
      // this.createdAt,
      // this.updatedAt,
      // this.iV,
      this.multiLanguageData,
      this.isSelected});

  Master.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    isDefault = json['isDefault'];
    // if (json['likeKeywords'] != null) {
    //   likeKeywords = new List<Null>();
    //   json['likeKeywords'].forEach((v) {
    //     likeKeywords.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['subMasters'] != null) {
    //   subMasters = json['subMasters'].cast<String>();
    // }
    isDeleted = json['isDeleted'];
    sId = json['_id'];
    name = json['name'];
    code = json['code'];
    // slug = json['slug'];
    normalizeName = json['normalizeName'];
    sortingSequence = json['sortingSequence'];
    // group = json['group'];
    description = json['description'];
    image = json['image'];
    // icon = json['icon'];
    parentId = json['parentId'];
    // createdAt = json['createdAt'];
    // updatedAt = json['updatedAt'];
    // iV = json['__v'];
    multiLanguageData = json['multiLanguageData'] != null
        ? new MultiLanguageData.fromJson(json['multiLanguageData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isActive'] = this.isActive;
    data['isDefault'] = this.isDefault;
    // if (this.likeKeywords != null) {
    //   data['likeKeywords'] = this.likeKeywords.map((v) => v.toJson()).toList();
    // }
    // data['subMasters'] = this.subMasters;
    data['isDeleted'] = this.isDeleted;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['code'] = this.code;
    // data['slug'] = this.slug;
    data['normalizeName'] = this.normalizeName;
    data['sortingSequence'] = this.sortingSequence;
    // data['group'] = this.group;
    data['description'] = this.description;
    data['image'] = this.image;
    // data['icon'] = this.icon;
    data['parentId'] = this.parentId;
    // data['createdAt'] = this.createdAt;
    // data['updatedAt'] = this.updatedAt;
    // data['__v'] = this.iV;
    if (this.multiLanguageData != null) {
      data['multiLanguageData'] = this.multiLanguageData.toJson();
    }
    return data;
  }

  String getName() {
    return name;
  }
}

class MasterRespData {
  String lastSyncDate;
  // User loggedInUser;
  Masters masters;

  MasterRespData({
    this.lastSyncDate,
    // this.loggedInUser,
    this.masters,
  });

  MasterRespData.fromJson(Map<String, dynamic> json) {
    lastSyncDate = json['lastSyncDate'];
    // loggedInUser = json['loggedInUser'] != null
    //     ? new User.fromJson(json['loggedInUser'])
    //     : null;
    masters =
        json['masters'] != null ? new Masters.fromJson(json['masters']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastSyncDate'] = this.lastSyncDate;
    // if (this.loggedInUser != null) {
    //   data['loggedInUser'] = this.loggedInUser.toJson();
    // }
    if (this.masters != null) {
      data['masters'] = this.masters.toJson();
    }

    return data;
  }
}

class Masters {
  List<Master> list;
  List<String> deleted;

  Masters({this.list, this.deleted});

  Masters.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<Master>();
      json['list'].forEach((v) {
        list.add(new Master.fromJson(v));
      });
    }

    if (json['deleted'] != null) {
      deleted = json['deleted'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }

    if (this.deleted != null) {
      data['deleted'] = this.deleted;
    }
    return data;
  }
}

class MultiLanguageData {
  EnUS enUS;

  MultiLanguageData({this.enUS});

  MultiLanguageData.fromJson(Map<String, dynamic> json) {
    enUS = json['en-US'] != null ? new EnUS.fromJson(json['en-US']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.enUS != null) {
      data['en-US'] = this.enUS.toJson();
    }
    return data;
  }
}

class EnUS {
  String name;

  EnUS({this.name});

  EnUS.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
