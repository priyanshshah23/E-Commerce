import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:flutter/material.dart';

import 'DiamondTrack.dart';

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
  String fcColNm;
  bool videoFile;
  bool roughVdo;
  bool polVdo;
  bool hAFile;
  String mlkNm;
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
  num newPricePerCarat;
  String remarks;
  String purpose;
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
  String date;
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
  bool isGroupSelected = false;
  bool isMatchPair = false;
  int borderType;
  bool isAddToWatchList = false;
  bool isFinalCalculation = false;
  bool isAddToOffer = false;
  bool isUpdateOffer = false;
  bool isAddAppointment = false;
  bool isAddToBid = false;
  bool isMyBid = false;
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
  String createdAt;

  //Id's
  String shp;
  String flu;
  String col;
  String shd;
  String clr;
  String cut;
  String pol;
  String sym;
  String lb;
  String mlk;
  String brlncy;
  List<String> blkInc;
  List<String> inten;
  List<String> ovrtn;
  List<String> opInc;
  List<String> fcCol;
  String mixTint;
  String eCln;
  String grdl;
  String cult;
  String natural;
  String cultCond;
  String grdlCond;
  String blkTbl;
  String blkSd;
  String wTbl;
  String wSd;
  String opTbl;
  String opPav;
  String opCrwn;
  String mfgStnId;

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
  bool isNotes = false;
  bool isNoteEditable = false;
  bool isNoteUpdated = false;

  String strDate;
  String expiryDate;

  int status;

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
    date = json["date"] ?? "";
    strDate = json["strDate"] ?? "";
    expiryDate = json["expiryDate"] ?? "";

    remarks = json["remarks"];
    purpose = json["purpose"];
    createdAt = json["createdAt"];
    id = json['id'] ?? json['_id'];
    stoneId = json['stoneId'];
    pltId = json['pltId'] ?? "";
    arrowImgId = json['packet_no'] ?? "";
    wSts = json['wSts'];
    sSts = json['sSts'];
    rptNo = json['rptNo'];
    certFile = json['certFile'] ?? false;
    videoFile = json['videoFile'] ?? false;
    // polVdo = json['polVdo'] ?? false;
    // roughVdo = json['roughVdo'] ?? false;
    hAFile = json['hAFile'] ?? false;
    mlkNm = json['mlkNm'] ?? "-";
    clrNm = json['clrNm'];
    fcColNm = json['fcColNm'];

    colNm = json['colNm'];
    lbCmt = json['lbCmt'];
    cAng = json['cAng'];
    cHgt = json['cHgt'];
    cultNm = json['cultNm'];
    newDiscount = json["newDiscount"] ?? 0;
    newAmount = json["newAmount"];
    newPricePerCarat = json["newPricePerCarat"] ?? 0;
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
    pltFile = isNullEmptyOrFalse(json['pltFile']) ? false : json['pltFile'];
    groupNo = json['groupNo'];
    mfgStnId = json["mfgStnId"];

//    isSelected = json['isSelected'];

    //Id's
    shp = json['shp'];
    col = json['col'];
    shd = json['shd'];
    clr = json['clr'];
    cut = json['cut'];
    pol = json['pol'];
    sym = json['sym'];
    flu = json['flu'];
    lb = json['lb'];
    brlncy = json['brlncy'];
    wSts = json['wSts'];
    loc = json['loc'];
    fcCol = !isNullEmptyOrFalse(json['fcCol'])
        ? json['fcCol'].cast<String>()
        : null;
    blkInc = !isNullEmptyOrFalse(json['blkInc'])
        ? json['blkInc'].cast<String>()
        : null;
    inten = !isNullEmptyOrFalse(json['inten'])
        ? json['inten'].cast<String>()
        : null;
    ovrtn = !isNullEmptyOrFalse(json['ovrtn'])
        ? json['ovrtn'].cast<String>()
        : null;
    opInc = !isNullEmptyOrFalse(json['opInc'])
        ? json['opInc'].cast<String>()
        : null;
    mlk = json['mlk'];
    mixTint = json['mixTint'];
    hA = json['hA'];
    eCln = json['eCln'];
    grdl = json['grdl'];
    cult = json['cult'];
    natural = json['natural'];
    cultCond = json['cultCond'];
    grdlCond = json['grdlCond'];
    blkTbl = json['blkTbl'];
    blkSd = json['blkSd'];
    wTbl = json['wTbl'];
    wSd = json['wSd'];
    opTbl = json['opTbl'];
    opCrwn = json['opCrwn'];
    isNotes = json['isNotes'] ?? false;
    isNoteEditable = json['isNoteEditable'] ?? false;
  }

  String getOfferStatus() {
    if (offerStatus == OfferStatus.rejected) {
      return "REJECTED";
    } else if (offerStatus == OfferStatus.pending) {
      return "PENDING";
    } else if (offerStatus == OfferStatus.accepted) {
      return "ACCEPTED";
    }

    return "-";
  }

  Color getOfferStatusColor() {
    if (offerStatus == OfferStatus.rejected) {
      return appTheme.redColor;
    } else if (offerStatus == OfferStatus.pending) {
      return appTheme.colorPrimary;
    } else if (offerStatus == OfferStatus.accepted) {
      return appTheme.colorPrimary;
    }

    return appTheme.colorPrimary;
  }

  DiamondModel({bool isSelected = false}) {
    this.isSelected = isSelected;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data["newDiscount"] = this.newDiscount;
    data["newAmount"] = this.newAmount;
    data["newPricePerCarat"] = this.newPricePerCarat;
    data["remarks"] = this.remarks;
    data["purpose"] = this.purpose;
    data["createdAt"] = this.createdAt;
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
    data['mlkNm'] = this.mlkNm;
    data['clrNm'] = this.clrNm;
    data['colNm'] = this.colNm;
    data['lbCmt'] = this.lbCmt;
    data['cAng'] = this.cAng;
    data['cHgt'] = this.cHgt;
    data['cultNm'] = this.cultNm;
    data['cutNm'] = this.cutNm;
    data['depPer'] = this.depPer;
    data['fcColNm'] = this.fcColNm;
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
    data["expiryDate"] = this.expiryDate;
    data["strDate"] = this.strDate;
    data["mfgStnId"] = this.mfgStnId;

    //Id's
    data["shp"] = this.shp;
    data["col"] = this.col;
    data["shd"] = this.shd;
    data["clr"] = this.clr;
    data["cut"] = this.cut;
    data["pol"] = this.pol;
    data["sym"] = this.sym;
    data["flu"] = this.flu;
    data["lb"] = this.lb;
    data["brlncy"] = this.brlncy;
    data["wSts"] = this.wSts;
    data["loc"] = this.loc;
    data["blkInc"] = this.blkInc;
    data["inten"] = this.inten;
    data["ovrtn"] = this.ovrtn;
    data["opInc"] = this.opInc;
    data["fcCol"] = this.fcCol;
    data["mlk"] = this.mlk;
    data["mixTint"] = this.mixTint;
    data["eCln"] = this.eCln;
    data["grdl"] = this.grdl;
    data["cult"] = this.cult;
    data["natural"] = this.natural;
    data["cultCond"] = this.cultCond;
    data["grdlCond"] = this.grdlCond;
    data["blkTbl"] = this.blkTbl;
    data["blkSd"] = this.blkSd;
    data["wTbl"] = this.wTbl;
    data["wSd"] = this.wSd;
    data["opTbl"] = this.opTbl;
    data["opPav"] = this.opPav;
    data["opCrwn"] = this.opCrwn;
    data['offerValidDate'] = this.offerValidDate;
    data['isNotes'] = this.isNotes;
    data['isNoteEditable'] = this.isNoteEditable;
    return data;
  }

  Color getStatusColor() {
    Color color;
    switch (wSts) {
      case DiamondStatus.DIAMOND_STATUS_AVAILABLE:
        color = appTheme.darkBlue;
        break;
      case DiamondStatus.DIAMOND_STATUS_ON_MINE:
        color = appTheme.statusOnMemo;
        break;
      case DiamondStatus.DIAMOND_STATUS_OFFER:
        color = appTheme.errorColor;
        break;
      case DiamondStatus.DIAMOND_STATUS_SHOW:
        color = appTheme.darkBlue;
        break;
      case DiamondStatus.DIAMOND_STATUS_HOLD:
        color = appTheme.redColor;
        break;
      case DiamondStatus.DIAMOND_STONE_OF_THE_DAY:
        color = appTheme.statusOffer;
        break;
    }
    return color;
  }

  String getStatusText() {
    String color = "";
    switch (wSts) {
      case DiamondStatus.DIAMOND_STATUS_AVAILABLE:
        color = R.string.screenTitle.statusAvailable;
        break;
      case DiamondStatus.DIAMOND_STATUS_ON_MINE:
        color = R.string.screenTitle.statusOnMemo;
        break;
      case DiamondStatus.DIAMOND_STATUS_OFFER:
        color = R.string.screenTitle.statusOffer;
        break;
      case DiamondStatus.DIAMOND_STATUS_SHOW:
        ///////////////////change in status to => show
        color = R.string.screenTitle.statusAvailable;
        //////////////////////////////////////////////////
        break;
      case DiamondStatus.DIAMOND_STATUS_HOLD:
        color = R.string.screenTitle.statusHold;
        break;
      case DiamondStatus.DIAMOND_STONE_OF_THE_DAY:
        color = R.string.screenTitle.stoneOfDay;
        break;
    }
    return color;
  }

  String getColorName() {
    if (!isNullEmptyOrFalse(this.isFcCol)) {
      if (this.isFcCol) {
        if (!isNullEmptyOrFalse(this.fcColNm)) {
          return this.fcColNm;
        }
        return "-";
      }
    }
    return colNm ?? "-";
  }

  setBidAmount() {
    this.bidAmount = this.ctPr;
  }

  String getDiamondImage() {
    // element.url = DiamondUrls.image + item.vStnId + "/" + "still.jpg";

    if (isStringEmpty(vStnId) == false) {
      return DiamondUrls.image + vStnId + ".jpg";
    }
    //img
    return "";
  }

  String getCertificateImage() {
    if (isStringEmpty(rptNo) == false) {
      return DiamondUrls.certificate + rptNo + ".pdf";
    }
    //img
    return "";
  }

  num getFinalRate() {
    if (isAddToBid) {
      return ctPr ?? 0;
    }
    // if (isAddToOffer) {
    //   if (selectedOfferPer != null) {
    //     num quote = (-back + num.parse(selectedOfferPer));
    //     num pricePerCarat = rap - ((quote * rap) / 100);
    //     num lessAmt = ((pricePerCarat *
    //             (-app
    //                 .resolve<PrefUtils>()
    //                 .getUserDetails()
    //                 .accountTerm
    //                 .extraPer)) /
    //         100);
    //     num finalrate = pricePerCarat - lessAmt;
    //     return finalrate;
    //   } else {
    //     num quote = (-back + num.parse(selectedOfferPer));
    //     num pricePerCarat = rap - ((quote * rap) / 100);
    //     num lessAmt = ((pricePerCarat *
    //             (-app
    //                 .resolve<PrefUtils>()
    //                 .getUserDetails()
    //                 .accountTerm
    //                 .extraPer)) /
    //         100);
    //     num finalrate = pricePerCarat - lessAmt;
    //     return finalrate;
    //   }
    // } else {
    // DateTime now = DateTime.now();
    // if (now.hour >= 15 || (now.hour <= 11 && now.month < 30)) {
    //   var totalctpr = this.ctPr *
    //       ((-app.resolve<PrefUtils>().getUserDetails().accountTerm.extraPer));
    //   var extractpr = totalctpr / 100;
    //   var dblExtractpr = extractpr * 0.5 / 100;
    //   return this.ctPr - extractpr - dblExtractpr;
    // }
    // var totalctpr = this.ctPr *
    //     (-app.resolve<PrefUtils>().getUserDetails().accountTerm.extraPer);
    // var extractpr = this.ctPr / 100;

    return this.ctPr??0;
    // - extractpr;
    // }
  }

  num getBidFinalRate() {
    DateTime now = DateTime.now();
    return 0;
//    if (now.hour >= 15 || (now.hour <= 10 && now.month < 30)) {
//      return getFinalRate() -
//          ((getFinalRate() *
//                  ((-app
//                          .resolve<PrefUtils>()
//                          .getUserDetails()
//                          .accountTerm
//                          .extraPer) +
//                      0.5)) /
//              100);
//    }
//    return getFinalRate() -
//        ((getFinalRate() *
//                (-app
//                    .resolve<PrefUtils>()
//                    .getUserDetails()
//                    .accountTerm
//                    .extraPer)) /
//            100);
  }

  num getbidFinalDiscount() {
    return (1 - (getBidFinalRate() / rap)) * (-100);
  }

  num getBidFinalAmount() {
    return crt * getBidFinalRate();
  }

  num getFinalDiscount() {
    num val = (1 - (getFinalRate() / rap)) * (-100);
    return val.isNaN || val.isInfinite ? 0 : val;
  }

  num getFinalAmount() {
    return (crt ?? 0) * getFinalRate();
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
    /*  var amount =
        (amt.toStringAsFixed(2)).replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "");
*/
    return PriceUtilities.getPrice(getFinalAmount()) + "/Amt" ?? "";
  }

  String getPricePerCarat() {
    //var caratPerPrice =
    // (ctPr.toStringAsFixed(2)).replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "");
    // return PriceUtilities.getPrice(getFinalRate()) + "Cts";
    return PriceUtilities.getPrice(getFinalRate()) + "/Cts" ?? "";
  }
}
