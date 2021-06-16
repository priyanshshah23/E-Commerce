import 'package:diamnow/app/app.export.dart';

import 'DiamondModel.dart';

class DiamondListReq {
  int page;
  int limit;
  int trackType;
  ReqFilters filters;
  bool isNotReturnTotal;
  bool isReturnCountOnly;
  String sort;

  DiamondListReq({
    this.page,
    this.limit,
    this.trackType,
    this.filters,
    this.isNotReturnTotal,
    this.isReturnCountOnly,
    this.sort,
  });

  DiamondListReq.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    if (json['filters'] != null) {
      filters = json['filters'] != null
          ? new ReqFilters.fromJson(json['filters'])
          : null;
    }
    if (json['isNotReturnTotal'] != null) {
      isNotReturnTotal = json['isNotReturnTotal'];
    }
    if (json['isReturnCountOnly'] != null) {
      isReturnCountOnly = json['isReturnCountOnly'];
    }
    if (json['sort'] != null) {
      sort = json['sort'];
    }
    if (json['trackType'] != null) {
      trackType = json['trackType'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    if (this.filters != null) {
      data['filters'] = this.filters.toJson();
    }
    if (this.isNotReturnTotal != null) {
      data['isNotReturnTotal'] = this.isNotReturnTotal;
    }
    if (this.isReturnCountOnly != null) {
      data['isReturnCountOnly'] = this.isReturnCountOnly;
    }
    if (this.sort != null) {
      data['sort'] = this.sort;
    }
    if (this.trackType != null) {
      data['trackType'] = this.trackType;
    }
    return data;
  }
}

class ReqFilters {
  String diamondSearchId;
  String wSts;
  InDt inDt;

  ReqFilters({this.diamondSearchId});

  ReqFilters.fromJson(Map<String, dynamic> json) {
    if (json['diamondSearchId'] != null) {
      diamondSearchId = json['diamondSearchId'];
    }
    if (json['wSts'] != null) {
      wSts = json['wSts'];
    }
    inDt = json['inDt'] != null ? new InDt.fromJson(json['inDt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.diamondSearchId != null) {
      data['diamondSearchId'] = this.diamondSearchId;
    }
    if (this.wSts != null) {
      data['wSts'] = this.wSts;
    }
    if (this.inDt != null) {
      data['inDt'] = this.inDt.toJson();
    }
    return data;
  }
}

class InDt {
  String lessThan;

  InDt({this.lessThan});

  InDt.fromJson(Map<String, dynamic> json) {
    lessThan = json['lessThan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lessThan'] = this.lessThan;
    return data;
  }
}

class DiamondListResp extends BaseApiResp {
  Data data;

  DiamondListResp({this.data});

  DiamondListResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    try {
      data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    } catch (e) {
      if (json['data'] != null) {
        json['data'].forEach((v) {
          data = new Data.fromJson(v);
        });
      }
    }
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
  FilterResp filter;
  int count;
  bool maxLimit;

  List<TrackItem> list;
  List<DiamondModel> diamonds;

  Data({
    this.filter,
    this.count,
    this.maxLimit,
    this.diamonds,
  });

  Data.fromJson(Map<String, dynamic> json) {
    filter =
        json['filter'] != null ? new FilterResp.fromJson(json['filter']) : null;
    count = json['count'];
    maxLimit = json['maxLimit'];
    if (json['diamonds'] != null) {
      diamonds = new List<DiamondModel>();
      json['diamonds'].forEach((v) {
        diamonds.add(new DiamondModel.fromJson(v));
      });
    }
    if (json['list'] != null) {
      list = new List<TrackItem>();
      diamonds = new List<DiamondModel>();
      json['list'].forEach((v) {
        if (v["diamond"] != null || v["diamonds"] != null) {
          list.add(new TrackItem.fromJson(v));
        } else {
          diamonds.add(new DiamondModel.fromJson(v));
          print("-------------${diamonds.length}");
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filter != null) {
      data['filter'] = this.filter.toJson();
    }
    data['count'] = this.count;
    data['maxLimit'] = this.maxLimit;
    if (this.diamonds != null) {
      data['diamonds'] = this.diamonds.map((v) => v.toJson()).toList();
    }
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterResp {
  String createdAt;
  String updatedAt;
  String id;
  String name;
  bool isSentReminder;
  String normalizeName;
  SearchData searchData;
  int type;
  String expiryDate;
  String remark;
  bool isActive;
  bool isDeleted;
  bool isSendNotification;
  bool isReturnSimilar;
  int searchCount;
  int articleSeq;
  String updateIp;
  String createIp;
  String user;
  String account;

  FilterResp({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.name,
    this.isSentReminder,
    this.normalizeName,
    this.searchData,
    this.type,
    this.expiryDate,
    this.remark,
    this.isActive,
    this.isDeleted,
    this.isSendNotification,
    this.isReturnSimilar,
    this.searchCount,
    this.articleSeq,
    this.updateIp,
    this.createIp,
    this.user,
    this.account,
  });

  FilterResp.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    name = json['name'];
    isSentReminder = json['isSentReminder'];
    normalizeName = json['normalizeName'];
    searchData = json['searchData'] != null
        ? new SearchData.fromJson(json['searchData'])
        : null;
    type = json['type'];
    expiryDate = json['expiryDate'];
    remark = json['remark'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isSendNotification = json['isSendNotification'];
    isReturnSimilar = json['isReturnSimilar'];
    searchCount = json['searchCount'];
    articleSeq = json['articleSeq'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];
    user = json['user'];
    account = json['account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['isSentReminder'] = this.isSentReminder;
    data['normalizeName'] = this.normalizeName;
    if (this.searchData != null) {
      data['searchData'] = this.searchData.toJson();
    }
    data['type'] = this.type;
    data['expiryDate'] = this.expiryDate;
    data['remark'] = this.remark;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['isSendNotification'] = this.isSendNotification;
    data['isReturnSimilar'] = this.isReturnSimilar;
    data['searchCount'] = this.searchCount;
    data['articleSeq'] = this.articleSeq;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
    data['user'] = this.user;
    data['account'] = this.account;
    return data;
  }
}

class SearchData {
  String pktType;
  bool isDeleted;

  // List<String> wSts;
//  List<bool> isSearchVisible;

  // bool isSearchVisible;

  SearchData({
    this.pktType,
    this.isDeleted,
//    this.isSearchVisible,
  });

  SearchData.fromJson(Map<String, dynamic> json) {
    pktType = json['pktType'];
    isDeleted = json['isDeleted'];
    // wSts = json['wSts'].cast<String>();
//    isSearchVisible = json['isSearchVisible'].cast<bool>();
    // isSearchVisible = json['isSearchVisible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pktType'] = this.pktType;
    data['isDeleted'] = this.isDeleted;
    // data['wSts'] = this.wSts;
//    data['isSearchVisible'] = this.isSearchVisible;
    return data;
  }
}

class CabinSlot {
  String createdAt;
  String updatedAt;
  String id;
  String start;
  String end;
  int weekDay;
  int type;
  int slotDurationType;
  bool isActive;
  String appliedFrom;
  String appliedTo;
  String reason;
  bool isDeleted;
  Null addedBy;
  Null updatedBy;
  Null createdBy;
  String cabinId;

  CabinSlot(
      {this.createdAt,
      this.updatedAt,
      this.id,
      this.start,
      this.end,
      this.weekDay,
      this.type,
      this.slotDurationType,
      this.isActive,
      this.appliedFrom,
      this.appliedTo,
      this.reason,
      this.isDeleted,
      this.addedBy,
      this.updatedBy,
      this.createdBy,
      this.cabinId});

  CabinSlot.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    start = json['start'];
    end = json['end'];
    weekDay = json['weekDay'];
    type = json['type'];
    slotDurationType = json['slotDurationType'];
    isActive = json['isActive'];
    appliedFrom = json['appliedFrom'];
    appliedTo = json['appliedTo'];
    reason = json['reason'];
    isDeleted = json['isDeleted'];
    addedBy = json['addedBy'];
    updatedBy = json['updatedBy'];
    createdBy = json['createdBy'];
    cabinId = json['cabinId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['start'] = this.start;
    data['end'] = this.end;
    data['weekDay'] = this.weekDay;
    data['type'] = this.type;
    data['slotDurationType'] = this.slotDurationType;
    data['isActive'] = this.isActive;
    data['appliedFrom'] = this.appliedFrom;
    data['appliedTo'] = this.appliedTo;
    data['reason'] = this.reason;
    data['isDeleted'] = this.isDeleted;
    data['addedBy'] = this.addedBy;
    data['updatedBy'] = this.updatedBy;
    data['createdBy'] = this.createdBy;
    data['cabinId'] = this.cabinId;
    return data;
  }
}

class TrackItem {
  String createdAt;
  String updatedAt;
  String id;
  String enquiryNo;
  int trackType;
  String name;
  String trackTxnId;
  String memoNo;
  String reminderDate;
  num trackPricePerCarat;
  num trackDiscount;
  num trackAmount;
  num newPricePerCarat;
  num newDiscount;
  num newAmount;
  int offerStatus;
  String offerValidDate;
  String date;
  String purpose;
  bool isCounterOffer;
  String remarks;
  bool isActive;
  bool isDeleted;
  bool isSystemDeleted;
  bool isNameDeleted;
  int deviceType;
  int status;
  String updateIp;
  String createIp;
  bool isSentReminder;
  String addedBy;
  num bidPricePerCarat;

  //User user;
  DiamondModel diamond;

  List<DiamondModel> diamonds;
  List<CabinSlot> cabinSlot;
  String userAccount;
  String createdBy;
  List<BargainTrack> bargainTrack;

  TrackItem(
      {this.createdAt,
      this.updatedAt,
      this.id,
      this.enquiryNo,
      this.purpose,
      this.trackType,
      this.name,
      this.trackTxnId,
      this.memoNo,
      this.reminderDate,
      this.trackPricePerCarat,
      this.trackDiscount,
      this.trackAmount,
      this.newPricePerCarat,
      this.newDiscount,
      this.newAmount,
      this.offerStatus,
      this.offerValidDate,
      this.isCounterOffer,
      this.remarks,
      this.isActive,
      this.isDeleted,
      this.isSystemDeleted,
      this.isNameDeleted,
      this.deviceType,
      this.status,
      this.updateIp,
      this.createIp,
      this.isSentReminder,
      this.addedBy,
      //  this.user,
      this.diamond,
      this.userAccount,
      this.createdBy,
      this.date,
      this.bargainTrack});

  TrackItem.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    purpose = json["purpose"];
    date = json["date"];
    enquiryNo = json['enquiryNo'];
    trackType = json['trackType'];
    name = json['name'];
    trackTxnId = json['trackTxnId'];
    memoNo = json['memoNo'];
    reminderDate = json['reminderDate'];
    trackPricePerCarat = json['trackPricePerCarat'];
    trackDiscount = json['trackDiscount'] ?? 0;
    trackAmount = json['trackAmount'];
    newPricePerCarat = json['newPricePerCarat'];
    newDiscount = json['newDiscount'] ?? 0;
    newAmount = json['newAmount'];
    offerStatus = json['offerStatus'];
    offerValidDate = json['offerValidDate'];
    isCounterOffer = json['isCounterOffer'];
    remarks = json['remarks'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    isSystemDeleted = json['isSystemDeleted'];
    isNameDeleted = json['isNameDeleted'];
    deviceType = json['deviceType'];
    status = json['status'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];
    isSentReminder = json['isSentReminder'];
    addedBy = json['addedBy'];
    // user = json['user'] != null ? new User.fromJson(json['user']) : null;
    diamond = json['diamond'] != null
        ? new DiamondModel.fromJson(json['diamond'])
        : null;

    if (json['cabinSlot'] != null) {
      cabinSlot = new List<CabinSlot>();
      json['cabinSlot'].forEach((v) {
        cabinSlot.add(new CabinSlot.fromJson(v));
      });
    }
    if (json['diamonds'] != null) {
      diamonds = new List<DiamondModel>();
      json['diamonds'].forEach((v) {
        diamonds.add(new DiamondModel.fromJson(v));
      });
    }
    userAccount = json['userAccount'];
    createdBy = json['createdBy'];
    if (json['bargainTrack'] != null) {
      bargainTrack = new List<BargainTrack>();
      json['bargainTrack'].forEach((v) {
        bargainTrack.add(new BargainTrack.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data["date"] = this.date;
    data["purpose"] = this.purpose;
    data['enquiryNo'] = this.enquiryNo;
    data['trackType'] = this.trackType;
    data['name'] = this.name;
    data['trackTxnId'] = this.trackTxnId;
    data['memoNo'] = this.memoNo;
    data['reminderDate'] = this.reminderDate;
    data['trackPricePerCarat'] = this.trackPricePerCarat;
    data['trackDiscount'] = this.trackDiscount;
    data['trackAmount'] = this.trackAmount;
    data['newPricePerCarat'] = this.newPricePerCarat;
    data['newDiscount'] = this.newDiscount;
    data['newAmount'] = this.newAmount;
    data['offerStatus'] = this.offerStatus;
    data['offerValidDate'] = this.offerValidDate;
    data['isCounterOffer'] = this.isCounterOffer;
    data['remarks'] = this.remarks;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['isSystemDeleted'] = this.isSystemDeleted;
    data['isNameDeleted'] = this.isNameDeleted;
    data['deviceType'] = this.deviceType;
    data['status'] = this.status;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
    data['isSentReminder'] = this.isSentReminder;
    data['addedBy'] = this.addedBy;
    /*if (this.user != null) {
      data['user'] = this.user.toJson();
    }*/
    if (this.diamond != null) {
      data['diamond'] = this.diamond.toJson();
    }
    data['userAccount'] = this.userAccount;
    data['createdBy'] = this.createdBy;
    if (this.bargainTrack != null) {
      data['bargainTrack'] = this.bargainTrack.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class BargainTrack {
  num trackPricePerCarat;
  num trackAmount;
  num trackDiscount;
  String createdBy;
  int userType;
  String updatedAt;

  BargainTrack(
      {this.trackPricePerCarat,
      this.trackAmount,
      this.trackDiscount,
      this.createdBy,
      this.updatedAt,
      this.userType});

  BargainTrack.fromJson(Map<String, dynamic> json) {
    trackPricePerCarat = json['trackPricePerCarat'];
    trackAmount = json['trackAmount'];
    trackDiscount = json['trackDiscount'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trackPricePerCarat'] = this.trackPricePerCarat;
    data['trackAmount'] = this.trackAmount;
    data['trackDiscount'] = this.trackDiscount;
    data['createdBy'] = this.createdBy;
    data['updatedAt'] = this.updatedAt;
    data['userType'] = this.userType;
    return data;
  }
}
