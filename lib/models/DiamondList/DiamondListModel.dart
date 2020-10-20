import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:flutter/cupertino.dart';

class DiamondListReq {
  int page;
  int limit;
  ReqFilters filters;
  bool isNotReturnTotal;
  bool isReturnCountOnly;
  String sort;

  DiamondListReq({
    this.page,
    this.limit,
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
  Filter filter;
  int count;
  bool maxLimit;
  List<DiamondModel> diamonds;

  Data({
    this.filter,
    this.count,
    this.maxLimit,
    this.diamonds,
  });

  Data.fromJson(Map<String, dynamic> json) {
    filter =
        json['filter'] != null ? new Filter.fromJson(json['filter']) : null;
    count = json['count'];
    maxLimit = json['maxLimit'];
    if (json['diamonds'] != null) {
      diamonds = new List<DiamondModel>();
      json['diamonds'].forEach((v) {
        diamonds.add(new DiamondModel.fromJson(v));
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
    return data;
  }
}

class Filter {
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

  Filter({
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

  Filter.fromJson(Map<String, dynamic> json) {
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
  bool isSearchVisible;

  SearchData({this.pktType, this.isDeleted, this.isSearchVisible});

  SearchData.fromJson(Map<String, dynamic> json) {
    pktType = json['pktType'];
    isDeleted = json['isDeleted'];
    // wSts = json['wSts'].cast<String>();
    isSearchVisible = json['isSearchVisible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pktType'] = this.pktType;
    data['isDeleted'] = this.isDeleted;
    // data['wSts'] = this.wSts;
    data['isSearchVisible'] = this.isSearchVisible;
    return data;
  }
}

class DiamondModel {
  String id;
  String stoneId;
  String pltId;
  String certId;
  String arrowImgId;
  String wSts;
  String sSts;
  String rptNo;
  bool certFile;
  bool videoFile;
  bool hAFile;
  String clrNm;
  String colNm;
  String lbCmt;
  num cAng;
  num cHgt;
  String cultNm;
  String cutNm;
  num depPer;
  bool img;
  String eClnNm;
  bool isFcCol;
  String fluNm;
  num grdlPer;
  String grdlThnNm;
  String grdlThkNm;
  String grdlCondNm;
  List<String> kToSArr;
  String kToSStr;
  String lbNm;
  String msrmnt;
  num length;
  num width;
  num height;
  num pAng;
  num pHgt;
  String polNm;
  num rap;
  num crt;
  num back;
  num ctPr;
  num amt;
  String shpNm;
  String shdNm;
  num strLn;
  String symNm;
  num tblPer;
  String pktType;
  String hANm;
  String vStnId;
  String locNm;
  num lwrHal;
  String org;
  String blkTblNm;
  String blkSdNm;
  String wTblNm;
  String wSdNm;
  String opCrwnNm;
  String opPavNm;
  String opTblNm;
  String isDor;
  String type2;
  String mines;
  bool isSeal;
  String inDt;
  String brlncyNm;
  bool isXray;
  bool arrowFile;
  bool assetFile;
  String hA;
  String loc;
  String girdleStr;
  int legendStatus;
  String countryCode;
  String lsrInc;
  String city;
  String country;
  String state;
  String fluColNm;
  String isCm;
  String fcColDesc;
  num ratio;
  bool isSelected = false;
  bool isAddToWatchList = false;
  bool isAddToOffer = false;
  String selectedBackPer;
  String selectedOfferPer;
  String selectedOfferHour;
  bool pltFile;

  getSelectedDetail(int type) {
    switch (type) {
      case DropDownItem.BACK_PER:
        return (selectedBackPer ?? "0") + "%";
      case DropDownItem.QUOTE:
        return (selectedOfferPer ?? "0");
      case DropDownItem.HOURS:
        return (selectedOfferHour ?? "0");
    }
  }

  getFinalOffer() {
    if (selectedOfferPer == null) {
      getOfferPer();
    }
    if (back >= 0) {
      return (back + num.parse(selectedOfferPer));
    } else {
      return (back - num.parse(selectedOfferPer));
    }
  }

  getFinalDisc() {
    return 0;
  }

<<<<<<< HEAD
  // getFinalRate() {
  //   return 0;
  // }

=======
>>>>>>> 047b40e09e6f7f410a02daa7487d25900fcb2b0b
  getFinalValue() {
    return 0;
  }

  getWatchlistPer() {
    List<String> list = [];
    if (back >= 0) {
      if (selectedBackPer == null) {
        selectedBackPer = (back + 1).toString();
      }
      list.add((back + 1).toString());
      list.add((back + 2).toString());
      list.add((back + 3).toString());
    } else {
      if (selectedBackPer == null) {
        selectedBackPer = (back - 1).toString();
      }
      list.add((back - 1).toString());
      list.add((back - 2).toString());
      list.add((back - 3).toString());
    }
    return list;
  }

  getOfferPer() {
    List<String> list = [];
    if (selectedOfferPer == null) {
      selectedOfferPer = (1).toString();
    }
    list.add((0.5).toString());
    list.add((1).toString());
    return list;
  }

  getOfferHour() {
    List<String> list = [];
    if (selectedOfferHour == null) {
      selectedOfferHour = (2).toString();
    }
    list.add((2).toString());
    list.add((4).toString());
    list.add((8).toString());
    list.add((10).toString());
    list.add((24).toString());
    list.add((48).toString());
    return list;
  }

  DiamondModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stoneId = json['stoneId'];
    pltId = json['pltId'] ?? "";
    arrowImgId = json['packet_no'] ?? "";
    wSts = json['wSts'];
    sSts = json['sSts'];
    rptNo = json['rptNo'];
    certFile = json['certFile'] ?? false;
    videoFile = json['videoFile'] ?? false;
    hAFile = json['hAFile'] ?? false;
    clrNm = json['clrNm'];
    colNm = json['colNm'];
    lbCmt = json['lbCmt'];
    cAng = json['cAng'];
    cHgt = json['cHgt'];
    cultNm = json['cultNm'];
    cutNm = json['cutNm'];
    depPer = json['depPer'];
    img = json['img'] ?? false;
    eClnNm = json['eClnNm'];
    isFcCol = json['isFcCol'];
    fluNm = json['fluNm'];
    grdlPer = json['grdlPer'];
    grdlThnNm = json['grdlThnNm'];
    grdlThkNm = json['grdlThkNm'];
    grdlCondNm = json['grdlCondNm'];
    kToSArr = json['kToSArr'].cast<String>();
    kToSStr = json['kToSStr'];
    lbNm = json['lbNm'];
    msrmnt = json['msrmnt'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    pAng = json['pAng'];
    pHgt = json['pHgt'];
    polNm = json['polNm'];
    rap = json['rap'];
    crt = json['crt'];
    back = json['back'];
    ctPr = json['ctPr'];
    amt = json['amt'];
    shpNm = json['shpNm'];
    shdNm = json['shdNm'];
    strLn = json['strLn'];
    symNm = json['symNm'];
    tblPer = json['tblPer'];
    pktType = json['pktType'];
    hANm = json['hANm'];
    vStnId = json['vStnId'];
    locNm = json['locNm'];
    lwrHal = json['lwrHal'];
    org = json['org'];
    blkTblNm = json['blkTblNm'];
    blkSdNm = json['blkSdNm'];
    wTblNm = json['wTblNm'];
    wSdNm = json['wSdNm'];
    opCrwnNm = json['opCrwnNm'];
    opPavNm = json['opPavNm'];
    opTblNm = json['opTblNm'];
    isDor = json['isDor'];
    type2 = json['type2'];
    mines = json['mines'];
    isSeal = json['isSeal'];
    inDt = json['inDt'];
    brlncyNm = json['brlncyNm'];
    isXray = json['isXray'];
    arrowFile = json['arrowFile'] ?? false;
    assetFile = json['assetFile'];
    hA = json['hA'];
    loc = json['loc'];
    girdleStr = json['girdleStr'];
    legendStatus = json['legendStatus'];
    countryCode = json['countryCode'];
    lsrInc = json['lsrInc'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    fluColNm = json['fluColNm'];
    isCm = json['isCm'];
    fcColDesc = json['fcColDesc'];
    ratio = json['ratio'];
    pltFile = json['pltFile'] ?? false;
//    isSelected = json['isSelected'];
  }

  DiamondModel({bool isSelected = false}) {
    this.isSelected = isSelected;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stoneId'] = this.stoneId;
    data['pltId'] = this.pltId;
    data['report_no'] = this.certId;
    data['packet_no'] = this.arrowImgId;
    data['wSts'] = this.wSts;
    data['sSts'] = this.sSts;
    data['rptNo'] = this.rptNo;
    data['certFile'] = this.certFile;
    data['videoFile'] = this.videoFile;
    data['hAFile'] = this.hAFile;
    data['clrNm'] = this.clrNm;
    data['colNm'] = this.colNm;
    data['lbCmt'] = this.lbCmt;
    data['cAng'] = this.cAng;
    data['cHgt'] = this.cHgt;
    data['cultNm'] = this.cultNm;
    data['cutNm'] = this.cutNm;
    data['depPer'] = this.depPer;
    data['img'] = this.img;
    data['eClnNm'] = this.eClnNm;
    data['isFcCol'] = this.isFcCol;
    data['fluNm'] = this.fluNm;
    data['grdlPer'] = this.grdlPer;
    data['grdlThnNm'] = this.grdlThnNm;
    data['grdlThkNm'] = this.grdlThkNm;
    data['grdlCondNm'] = this.grdlCondNm;
    data['kToSArr'] = this.kToSArr;
    data['kToSStr'] = this.kToSStr;
    data['lbNm'] = this.lbNm;
    data['msrmnt'] = this.msrmnt;
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['pAng'] = this.pAng;
    data['pHgt'] = this.pHgt;
    data['polNm'] = this.polNm;
    data['rap'] = this.rap;
    data['crt'] = this.crt;
    data['back'] = this.back;
    data['ctPr'] = this.ctPr;
    data['amt'] = this.amt;
    data['shpNm'] = this.shpNm;
    data['shdNm'] = this.shdNm;
    data['strLn'] = this.strLn;
    data['symNm'] = this.symNm;
    data['tblPer'] = this.tblPer;
    data['pktType'] = this.pktType;
    data['hANm'] = this.hANm;
    data['vStnId'] = this.vStnId;
    data['locNm'] = this.locNm;
    data['lwrHal'] = this.lwrHal;
    data['org'] = this.org;
    data['blkTblNm'] = this.blkTblNm;
    data['blkSdNm'] = this.blkSdNm;
    data['wTblNm'] = this.wTblNm;
    data['wSdNm'] = this.wSdNm;
    data['opCrwnNm'] = this.opCrwnNm;
    data['opPavNm'] = this.opPavNm;
    data['opTblNm'] = this.opTblNm;
    data['isDor'] = this.isDor;
    data['type2'] = this.type2;
    data['mines'] = this.mines;
    data['isSeal'] = this.isSeal;
    data['inDt'] = this.inDt;
    data['brlncyNm'] = this.brlncyNm;
    data['isXray'] = this.isXray;
    data['arrowFile'] = this.arrowFile;
    data['assetFile'] = this.assetFile;
    data['hA'] = this.hA;
    data['loc'] = this.loc;
    data['girdleStr'] = this.girdleStr;
    data['legendStatus'] = this.legendStatus;
    data['countryCode'] = this.countryCode;
    data['lsrInc'] = this.lsrInc;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['fluColNm'] = this.fluColNm;
    data['isCm'] = this.isCm;
    data['fcColDesc'] = this.fcColDesc;
    data['ratio'] = this.ratio;
    data['pltFile'] = this.pltFile;
//    data['isSelected'] = this.isSelected;
    return data;
  }

  Color getStatusColor() {
    Color color;
    switch (wSts) {
      case DiamondStatus.available:
        color = appTheme.darkBlue;
        break;
      case DiamondStatus.onMine:
        color = appTheme.errorColor;
        break;
      case DiamondStatus.office:
        color = appTheme.errorColor;
        break;
      case DiamondStatus.show:
        color = appTheme.darkBlue;
        break;
    }
    return color;
  }

  String getDiamondImage() {
    if (isStringEmpty(vStnId) == false) {
      return diamondImageURL + vStnId + ".jpg";
    }
    //img
    return "";
  }

  String getAmount() {
    var amount =
        (amt.toStringAsFixed(2)).replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "");

    return R.string().commonString.doller + amount + "/Amt" ?? "";
  }

  String getPricePerCarat() {
    var caratPerPrice =
        (ctPr.toStringAsFixed(2)).replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "");

    return R.string().commonString.doller + caratPerPrice + "/Cts" ?? "";
  }

  num getFinalRate() {
    return this.ctPr - ((this.ctPr * 2) / 100);
  }

  num getFinalDiscount() {
    return (1 - (getFinalRate() / rap)) * (-100);
  }

  num getFinalAmount() {
    return crt * getFinalRate();
  }
}
