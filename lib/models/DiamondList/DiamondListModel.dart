import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxbus/rxbus.dart';

import 'DiamondTrack.dart';

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
        json['filter'] != null ? new Filter.fromJson(json['filter']) : null;
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
  bool roughVdo;
  bool polVdo;
  bool hAFile;
  String mlk;
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
  num back = 0;
  num ctPr;
  num amt;
  String shpNm;
  String shdNm;
  num strLn;
  String symNm;
  num tblPer;
  num newDiscount;
  num newAmount;
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
  String memoNo;
  String offerValidDate;
  int offerStatus;
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
  bool isMatchPair = false;
  int borderType;
  bool isAddToWatchList = false;
  bool isFinalCalculation = false;
  bool isAddToOffer = false;
  bool isAddToBid = false;
  String selectedBackPer;
  String selectedOfferPer = "0.5";
  String selectedOfferHour;
  bool pltFile;
  int groupNo;
  double marginTop = 0;
  double marginBottom = 0;
  num plusAmount = 0;
  num minusAmount = 0;
  bool bidPlus = false;
  String displayTitle;
  String displayDesc;
  bool showCheckBox = false;
  num bidAmount;
  String offeredDiscount;
  num offeredAmount;
  String offeredValiddate;
  String offeredPricePerCarat;

  TrackDiamonds trackItemCart;
  TrackDiamonds trackItemWatchList;
  TrackDiamonds trackItemEnquiry;
  TrackDiamonds trackItemOffer;
  TrackDiamonds trackItemReminder;
  TrackDiamonds trackItemComment;
  TrackDiamonds trackItemBid;
  TrackDiamonds trackItemOffice;
  bool isSectionOfferDisplay = false;
  bool isGrouping = false;

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

  getWatchlistPer() {
    List<String> list = [];
    if (back != null) {
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
    memoNo = json["memoNo"];
    offerStatus = json["offerStatus"];
    offerValidDate = json["offerValidDate"];
    id = json['id'];
    stoneId = json['stoneId'];
    pltId = json['pltId'] ?? "";
    arrowImgId = json['packet_no'] ?? "";
    wSts = json['wSts'];
    sSts = json['sSts'];
    rptNo = json['rptNo'];
    certFile = json['certFile'] ?? false;
    videoFile = json['videoFile'] ?? false;
    polVdo = json['polVdo'] ?? false;
    roughVdo = json['roughVdo'] ?? false;
    hAFile = json['hAFile'] ?? false;
    mlk = json['mlk'] ?? "-";
    clrNm = json['clrNm'];
    colNm = json['colNm'];
    lbCmt = json['lbCmt'];
    cAng = json['cAng'];
    cHgt = json['cHgt'];
    cultNm = json['cultNm'];
    newDiscount = json["newDiscount"] ?? 0;
    newAmount = json["newAmount"];
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
    rap = json['rap'] ?? 0;
    crt = json['crt'] ?? 0;
    back = json['back'];
    ctPr = json['ctPr'] ?? 0;
    amt = json['amt'] ?? 0;
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
    groupNo = json['groupNo'];

//    isSelected = json['isSelected'];
  }

  DiamondModel({bool isSelected = false}) {
    this.isSelected = isSelected;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data["newDiscount"] = this.newDiscount;
    data["newAmount"] = this.newAmount;
    data["memoNo"] = this.memoNo;
    data['stoneId'] = this.stoneId;
    data['pltId'] = this.pltId;
    data['report_no'] = this.certId;
    data['packet_no'] = this.arrowImgId;
    data['wSts'] = this.wSts;
    data['sSts'] = this.sSts;
    data['rptNo'] = this.rptNo;
    data['certFile'] = this.certFile;
    data['videoFile'] = this.videoFile;
    data['polVdo'] = this.polVdo;
    data['roughVdo'] = this.roughVdo;
    data['hAFile'] = this.hAFile;
    data['mlk'] = this.mlk;
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
    data['groupNo'] = this.groupNo;
//    data['isSelected'] = this.isSelected;
    return data;
  }

  Color getStatusColor() {
    Color color;
    switch (wSts) {
      case DiamondStatus.DIAMOND_STATUS_AVAILABLE:
        color = appTheme.darkBlue;
        break;
      case DiamondStatus.DIAMOND_STATUS_ON_MINE:
        color = appTheme.errorColor;
        break;
      case DiamondStatus.DIAMOND_STATUS_OFFER:
        color = appTheme.errorColor;
        break;
      case DiamondStatus.DIAMOND_STATUS_SHOW:
        color = appTheme.darkBlue;
        break;
    }
    return color;
  }

  setBidAmount() {
    this.bidAmount = this.ctPr;
  }

  String getDiamondImage() {
    if (isStringEmpty(vStnId) == false) {
      return diamondImageURL + vStnId + ".jpg";
    }
    //img
    return "";
  }

  num getFinalRate() {
    if (isAddToBid) {
      return ctPr;
    }
    if (isAddToOffer) {
      if (selectedOfferPer != null) {
        num quote = (-back + num.parse(selectedOfferPer));
        num pricePerCarat = rap - ((quote * rap) / 100);
        num lessAmt = ((pricePerCarat *
                (-app
                    .resolve<PrefUtils>()
                    .getUserDetails()
                    .accountTerm
                    .extraPer)) /
            100);
        num finalrate = pricePerCarat - lessAmt;
        return finalrate;
      } else {
        num quote = (-back + num.parse(selectedOfferPer));
        num pricePerCarat = rap - ((quote * rap) / 100);
        num lessAmt = ((pricePerCarat *
                (-app
                    .resolve<PrefUtils>()
                    .getUserDetails()
                    .accountTerm
                    .extraPer)) /
            100);
        num finalrate = pricePerCarat - lessAmt;
        return finalrate;
      }
    } else {
      DateTime now = DateTime.now();
      if (now.hour >= 15 || (now.hour <= 11 && now.month < 30)) {
        var totalctpr = this.ctPr *
            ((-app.resolve<PrefUtils>().getUserDetails().accountTerm.extraPer));
        var extractpr = totalctpr / 100;
        var dblExtractpr = extractpr * 0.5 / 100;
        return this.ctPr - extractpr - dblExtractpr;
      }
      var totalctpr = this.ctPr *
          (-app.resolve<PrefUtils>().getUserDetails().accountTerm.extraPer);
      var extractpr = totalctpr / 100;

      return this.ctPr - extractpr;
    }
  }

  num getBidFinalRate() {
    DateTime now = DateTime.now();
    if (now.hour >= 15 || (now.hour <= 10 && now.month < 30)) {
      return getFinalRate() -
          ((getFinalRate() *
                  ((-app
                          .resolve<PrefUtils>()
                          .getUserDetails()
                          .accountTerm
                          .extraPer) +
                      0.5)) /
              100);
    }
    return getFinalRate() -
        ((getFinalRate() *
                (-app
                    .resolve<PrefUtils>()
                    .getUserDetails()
                    .accountTerm
                    .extraPer)) /
            100);
  }

  num getbidFinalDiscount() {
    return (1 - (getBidFinalRate() / rap)) * (-100);
  }

  num getBidFinalAmount() {
    return crt * getBidFinalRate();
  }

  num getFinalDiscount() {
    return (1 - (getFinalRate() / rap)) * (-100);
  }

  num getFinalAmount() {
    return crt * getFinalRate();
  }

  num getbidAmount() {
    num plusAmt;
    print("ctpr-before--${ctPr}");
    if (bidPlus) {
      plusAmt = ctPr + plusAmount;
    } else {
      if ((ctPr - minusAmount) >= bidAmount) {
        plusAmt = ctPr - minusAmount;
      } else {
        plusAmt = ctPr;
      }
    }
    ctPr = plusAmt;
    return plusAmt;
  }

  String getAmount() {
    var amount =
        (amt.toStringAsFixed(2)).replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "");

    return PriceUtilities.getPrice(getFinalAmount()) + "/Amt" ?? "";
  }

  String getPricePerCarat() {
    var caratPerPrice =
        (ctPr.toStringAsFixed(2)).replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "");
    // return PriceUtilities.getPrice(getFinalRate()) + "Cts";
    return PriceUtilities.getPrice(getFinalRate()) + "/Cts" ?? "";
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

  //User user;
  DiamondModel diamond;

  List<DiamondModel> diamonds;
  List<CabinSlot> cabinSlot;
  String userAccount;
  String createdBy;

  TrackItem({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.enquiryNo,
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
  });

  TrackItem.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
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
    return data;
  }
}
