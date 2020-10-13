import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MasterReq {
  String serverLastSync;
  String user;

  MasterReq({this.serverLastSync, this.user});

  MasterReq.fromJson(Map<String, dynamic> json) {
    if (json['lastSyncDate'] != null) {
      serverLastSync = json['lastSyncDate'];
    }
    if (json['user'] != null) {
      user = json['user'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.serverLastSync != null) {
      data['lastSyncDate'] = this.serverLastSync;
    }
    if (this.user != null) {
      data['user'] = this.user;
    }
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
  bool isDeleted = false;
  String sId;
  String name;
  String code;
  String normalizeName;
  String marketingDisplay;
  String webDisplay;
  int sortingSequence;
  String description;
  String image;
  String parentId;
  String group;
  String sizeCategory;
  MultiLanguageData multiLanguageData;
  bool isSelected = false;

  List<Master> grouped = [];

  Master(
      {this.isActive,
      this.isDefault,
      this.isDeleted,
      this.marketingDisplay,
      this.webDisplay,
      this.sId,
      this.name,
      this.code,
      this.group,
      this.sizeCategory,
      this.normalizeName,
      this.sortingSequence,
      this.description,
      this.image,
      this.parentId,
      this.multiLanguageData,
      this.isSelected = false});

  Master.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    isDefault = json['isDefault'];
    marketingDisplay = json['marketingDisplay'];
    webDisplay = json['webDisplay'];
    isDeleted = json['isDeleted'];
    sizeCategory = json["sizeCategory"];
    sId = json['id'];
    name = json['name'];
    code = json['code'];
    group = json['group'];
    normalizeName = json['normalizeName'];
    sortingSequence = json['sortingSequence'];
    description = json['description'];
    image = json['image'];
    parentId = json['parentId'];
    multiLanguageData = json['multiLanguageData'] != null
        ? new MultiLanguageData.fromJson(json['multiLanguageData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isActive'] = this.isActive;
    data['isDefault'] = this.isDefault;
    data['marketingDisplay'] = this.marketingDisplay;
    data['webDisplay'] = this.webDisplay;
    data['isDeleted'] = this.isDeleted;
    data['id'] = this.sId;
    data['group'] = this.group;
    data['sizeCategory'] = this.sizeCategory;
    data['name'] = this.name;
    data['code'] = this.code;
    data['normalizeName'] = this.normalizeName;
    data['sortingSequence'] = this.sortingSequence;
    data['description'] = this.description;
    data['image'] = this.image;
    data['parentId'] = this.parentId;

    if (this.multiLanguageData != null) {
      data['multiLanguageData'] = this.multiLanguageData.toJson();
    }
    return data;
  }

  String getName() {
    return name;
  }

  static Future<List<Master>> getSubMaster(String code) async {
    List<Master> master = [];
    List<String> mapShape = [];
    List<Master> allShapes =
        await AppDatabase.instance.masterDao.getSubMasterFromCode(code);
    allShapes.forEach((item) {
      if (!mapShape.contains(item.webDisplay)) {
        dynamic filter =
            allShapes.where((element) => element.webDisplay == item.webDisplay);

        item.grouped = filter.toList();
        mapShape.add(item.webDisplay);
        master.add(item);
      }
    });

    if (code == MasterCode.origin) {
      //If Master is Rough Origin Remove FM/CM Manually
      Master filterIndex =
          master.firstWhere((element) => element.code == "FM2/CM");
      if (isNullEmptyOrFalse(filterIndex) == false) {
        master.remove(filterIndex);
      }
    }

    return master;
  }

  static Future<List<Master>> getSizeMaster() async {
    List<Master> master = [];
    List<String> mapShape = [];
    List<Master> allSizeMaster =
        await AppDatabase.instance.sizeMasterDao.getSubMasterFromCode();
    allSizeMaster.forEach((item) {
      if (!mapShape.contains(item.group ?? "")) {
        dynamic filter =
            allSizeMaster.where((element) => element.group == item.group);

        item.grouped = filter.toList();
        mapShape.add(item.group ?? "");
        master.add(item);
      }
    });
    
    return master;
  }

  Widget getShapeImage(bool isSelected) {
    String strCode = webDisplay.split(" ").join("");
    // if (isSelected) {
    //   return Image.asset(
    //     "assets/shape/${strCode.toLowerCase()}selected.png",
    //     color: appTheme.colorPrimary,
    //     width: getSize(28),
    //     height: getSize(28),
    //   );
    // }
    return Image.asset(
      "assets/shape/${strCode.toLowerCase()}.png",
      color: Colors.black,
      width: getSize(28),
      height: getSize(28),
    );
  }
}

class MasterRespData {
  String lastSyncDate;

  User loggedInUser;
  Masters sizeMaster;
  Masters masters;

  MasterRespData({
    this.lastSyncDate,
    this.loggedInUser,
    this.sizeMaster,
    this.masters,
  });

  MasterRespData.fromJson(Map<String, dynamic> json) {
    lastSyncDate = json['lastSyncDate'];
    loggedInUser = json['loggedInUser'] != null
        ? new User.fromJson(json['loggedInUser'])
        : null;
    sizeMaster = json['sizeMaster'] != null
        ? new Masters.fromJson(json['sizeMaster'])
        : null;
    masters =
        json['masters'] != null ? new Masters.fromJson(json['masters']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastSyncDate'] = this.lastSyncDate;
    if (this.loggedInUser != null) {
      data['loggedInUser'] = this.loggedInUser.toJson();
    }
    if (this.sizeMaster != null) {
      data['sizeMaster'] = this.sizeMaster.toJson();
    }
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
