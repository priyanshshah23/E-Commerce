// To parse this JSON data, do
//
//     final savedSearchResp = savedSearchRespFromJson(jsonString);

import 'package:diamnow/app/app.export.dart';

class SavedSearchResp extends BaseApiResp {
  SavedSearchResp({
    this.code,
    this.message,
    this.data,
  });

  String code;
  String message;
  Data data;

  SavedSearchResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
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
  Data({
    this.list,
    this.count,
  });

  List<SavedSearchModel> list;
  int count;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<SavedSearchModel>.from(
            json["list"].map((x) => SavedSearchModel.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "count": count,
      };
}

class SavedSearchModel {
  SavedSearchModel({
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
    this.displayData,
  });

  String createdAt;
  String updatedAt;
  String id;
  String name;
  bool isSentReminder;
  String normalizeName;
  DisplayDataClass searchData;
  int type;
  String expiryDate;
  String remark;
  bool isActive;
  bool isDeleted;
  bool isSendNotification;
  bool isReturnSimilar;
  DisplayDataClass displayData;

  factory SavedSearchModel.fromJson(Map<String, dynamic> json) =>
      SavedSearchModel(
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        id: json["id"],
        name: json["name"],
        isSentReminder: json["isSentReminder"],
        normalizeName: json["normalizeName"],
        searchData: json['searchData'] != null
            ? DisplayDataClass.fromJson(json["searchData"])
            : null,
        type: json["type"],
        expiryDate: json["expiryDate"],
        remark: json["remark"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        isSendNotification: json["isSendNotification"],
        isReturnSimilar: json["isReturnSimilar"],
        displayData: json['displayData'] != null
            ? DisplayDataClass.fromJson(json["displayData"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "id": id,
        "name": name,
        "isSentReminder": isSentReminder,
        "normalizeName": normalizeName,
        "searchData": searchData.toJson(),
        "type": type,
        "expiryDate": expiryDate,
        "remark": remark,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "isSendNotification": isSendNotification,
        "isReturnSimilar": isReturnSimilar,
        "displayData": displayData.toJson(),
      };
}

class DisplayDataClass {
  DisplayDataClass({
    this.shp,
    this.or,
    this.col,
    this.shd,
    this.clr,
    this.cut,
    this.pol,
    this.sym,
    this.hA,
    this.brlncy,
    this.wSts,
    this.ctPr,
    this.back,
    this.isCm,
    this.isDor,
    this.isFm,
    this.type2,
    this.tblPer,
    this.depPer,
    this.ratio,
    this.length,
    this.width,
    this.height,
    this.cAng,
    this.cHgt,
    this.grdlPer,
    this.pAng,
    this.pHgt,
    this.lwr,
    this.strLn,
    this.blkTbl,
    this.blkSd,
    this.wTbl,
    this.cult,
    this.wSd,
    this.opTbl,
    this.opPav,
    this.opCrwn,
    this.grdl,
    this.kToSArr,
  });

  List<String> shp;
  List<Or> or;
  List<String> col;
  List<String> shd;
  List<String> clr;
  List<String> cut;
  List<String> pol;
  List<String> sym;
  List<String> hA;
  List<String> brlncy;
  List<String> wSts;
  Back ctPr;
  Back back;
  List<String> isCm;
  List<String> isDor;
  List<String> isFm;
  Type2 type2;
  Back tblPer;
  Back depPer;
  Back ratio;
  Back length;
  Back width;
  Back height;
  Back cAng;
  Back cHgt;
  Back grdlPer;
  Back pAng;
  Back pHgt;
  Back lwr;
  Back strLn;
  List<String> blkTbl;
  List<String> blkSd;
  List<String> wTbl;
  List<String> cult;
  List<String> wSd;
  List<String> opTbl;
  List<String> opPav;
  List<String> opCrwn;
  List<String> grdl;
  KToSArr kToSArr;

  factory DisplayDataClass.fromJson(Map<String, dynamic> json) =>
      DisplayDataClass(
        shp: json["shp"] == null
            ? null
            : List<String>.from(json["shp"].map((x) => x)),
        or: json["or"] == null
            ? null
            : List<Or>.from(json["or"].map((x) => Or.fromJson(x))),
        col: json["col"] == null
            ? null
            : List<String>.from(json["col"].map((x) => x)),
        shd: json["shd"] == null
            ? null
            : List<String>.from(json["shd"].map((x) => x)),
        clr: json["clr"] == null
            ? null
            : List<String>.from(json["clr"].map((x) => x)),
        cut: json["cut"] == null
            ? null
            : List<String>.from(json["cut"].map((x) => x)),
        pol: json["pol"] == null
            ? null
            : List<String>.from(json["pol"].map((x) => x)),
        sym: json["sym"] == null
            ? null
            : List<String>.from(json["sym"].map((x) => x)),
        hA: json["hA"] == null
            ? null
            : List<String>.from(json["hA"].map((x) => x)),
        brlncy: json["brlncy"] == null
            ? null
            : List<String>.from(json["brlncy"].map((x) => x)),
        wSts: json["wSts"] == null
            ? null
            : List<String>.from(json["wSts"].map((x) => x)),
        ctPr: json["ctPr"] == null ? null : Back.fromJson(json["ctPr"]),
        back: json["back"] == null ? null : Back.fromJson(json["back"]),
        isCm: json["isCm"] == null
            ? null
            : List<String>.from(json["isCm"].map((x) => x)),
        isDor: json["isDor"] == null
            ? null
            : List<String>.from(json["isDor"].map((x) => x)),
        isFm: json["isFm"] == null
            ? null
            : List<String>.from(json["isFm"].map((x) => x)),
        type2: json["type2"] == null ? null : Type2.fromJson(json["type2"]),
        tblPer: json["tblPer"] == null ? null : Back.fromJson(json["tblPer"]),
        depPer: json["depPer"] == null ? null : Back.fromJson(json["depPer"]),
        ratio: json["ratio"] == null ? null : Back.fromJson(json["ratio"]),
        length: json["length"] == null ? null : Back.fromJson(json["length"]),
        width: json["width"] == null ? null : Back.fromJson(json["width"]),
        height: json["height"] == null ? null : Back.fromJson(json["height"]),
        cAng: json["cAng"] == null ? null : Back.fromJson(json["cAng"]),
        cHgt: json["cHgt"] == null ? null : Back.fromJson(json["cHgt"]),
        grdlPer:
            json["grdlPer"] == null ? null : Back.fromJson(json["grdlPer"]),
        pAng: json["pAng"] == null ? null : Back.fromJson(json["pAng"]),
        pHgt: json["pHgt"] == null ? null : Back.fromJson(json["pHgt"]),
        lwr: json["lwr"] == null ? null : Back.fromJson(json["lwr"]),
        strLn: json["strLn"] == null ? null : Back.fromJson(json["strLn"]),
        blkTbl: json["blkTbl"] == null
            ? null
            : List<String>.from(json["blkTbl"].map((x) => x)),
        blkSd: json["blkSd"] == null
            ? null
            : List<String>.from(json["blkSd"].map((x) => x)),
        wTbl: json["wTbl"] == null
            ? null
            : List<String>.from(json["wTbl"].map((x) => x)),
        cult: json["cult"] == null
            ? null
            : List<String>.from(json["cult"].map((x) => x)),
        wSd: json["wSd"] == null
            ? null
            : List<String>.from(json["wSd"].map((x) => x)),
        opTbl: json["opTbl"] == null
            ? null
            : List<String>.from(json["opTbl"].map((x) => x)),
        opPav: json["opPav"] == null
            ? null
            : List<String>.from(json["opPav"].map((x) => x)),
        opCrwn: json["opCrwn"] == null
            ? null
            : List<String>.from(json["opCrwn"].map((x) => x)),
        grdl: json["grdl"] == null
            ? null
            : List<String>.from(json["grdl"].map((x) => x)),
        kToSArr:
            json["kToSArr"] == null ? null : KToSArr.fromJson(json["kToSArr"]),
      );

  Map<String, dynamic> toJson() => {
        "shp": shp == null ? null : List<dynamic>.from(shp.map((x) => x)),
        "or": or == null ? null : List<dynamic>.from(or.map((x) => x.toJson())),
        "col": col == null ? null : List<dynamic>.from(col.map((x) => x)),
        "shd": shd == null ? null : List<dynamic>.from(shd.map((x) => x)),
        "clr": clr == null ? null : List<dynamic>.from(clr.map((x) => x)),
        "cut": cut == null ? null : List<dynamic>.from(cut.map((x) => x)),
        "pol": pol == null ? null : List<dynamic>.from(pol.map((x) => x)),
        "sym": sym == null ? null : List<dynamic>.from(sym.map((x) => x)),
        "hA": hA == null ? null : List<dynamic>.from(hA.map((x) => x)),
        "brlncy":
            brlncy == null ? null : List<dynamic>.from(brlncy.map((x) => x)),
        "wSts": wSts == null ? null : List<dynamic>.from(wSts.map((x) => x)),
        "ctPr": ctPr == null ? null : ctPr.toJson(),
        "back": back == null ? null : back.toJson(),
        "isCm": isCm == null ? null : List<dynamic>.from(isCm.map((x) => x)),
        "isDor": isDor == null ? null : List<dynamic>.from(isDor.map((x) => x)),
        "isFm": isFm == null ? null : List<dynamic>.from(isFm.map((x) => x)),
        "type2": type2 == null ? null : type2.toJson(),
        "tblPer": tblPer == null ? null : tblPer.toJson(),
        "depPer": depPer == null ? null : depPer.toJson(),
        "ratio": ratio == null ? null : ratio.toJson(),
        "length": length == null ? null : length.toJson(),
        "width": width == null ? null : width.toJson(),
        "height": height == null ? null : height.toJson(),
        "cAng": cAng == null ? null : cAng.toJson(),
        "cHgt": cHgt == null ? null : cHgt.toJson(),
        "grdlPer": grdlPer == null ? null : grdlPer.toJson(),
        "pAng": pAng == null ? null : pAng.toJson(),
        "pHgt": pHgt == null ? null : pHgt.toJson(),
        "lwr": lwr == null ? null : lwr.toJson(),
        "strLn": strLn == null ? null : strLn.toJson(),
        "blkTbl":
            blkTbl == null ? null : List<dynamic>.from(blkTbl.map((x) => x)),
        "blkSd": blkSd == null ? null : List<dynamic>.from(blkSd.map((x) => x)),
        "wTbl": wTbl == null ? null : List<dynamic>.from(wTbl.map((x) => x)),
        "cult": cult == null ? null : List<dynamic>.from(cult.map((x) => x)),
        "wSd": wSd == null ? null : List<dynamic>.from(wSd.map((x) => x)),
        "opTbl": opTbl == null ? null : List<dynamic>.from(opTbl.map((x) => x)),
        "opPav": opPav == null ? null : List<dynamic>.from(opPav.map((x) => x)),
        "opCrwn":
            opCrwn == null ? null : List<dynamic>.from(opCrwn.map((x) => x)),
        "grdl": grdl == null ? null : List<dynamic>.from(grdl.map((x) => x)),
        "kToSArr": kToSArr == null ? null : kToSArr.toJson(),
      };
}

class Back {
  Back({
    this.back,
    this.empty,
  });

  String back;
  String empty;

  factory Back.fromJson(Map<String, dynamic> json) => Back(
        back: json[">="],
        empty: json["<="],
      );

  Map<String, dynamic> toJson() => {
        ">=": back,
        "<=": empty,
      };
}

class KToSArr {
  KToSArr({
    this.kToSArrIn,
  });

  List<String> kToSArrIn;

  factory KToSArr.fromJson(Map<String, dynamic> json) => KToSArr(
        kToSArrIn: List<String>.from(json["in"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "in": List<dynamic>.from(kToSArrIn.map((x) => x)),
      };
}

class Or {
  Or({
    this.pairStkNo,
    this.crt,
  });

  List<String> pairStkNo;
  Back crt;

  factory Or.fromJson(Map<String, dynamic> json) => Or(
        pairStkNo: json["pairStkNo"] == null
            ? null
            : List<String>.from(json["pairStkNo"].map((x) => x)),
        crt: json["crt"] == null ? null : Back.fromJson(json["crt"]),
      );

  Map<String, dynamic> toJson() => {
        "pairStkNo": pairStkNo == null
            ? null
            : List<dynamic>.from(pairStkNo.map((x) => x)),
        "crt": crt == null ? null : crt.toJson(),
      };
}

class Type2 {
  Type2({
    this.empty,
  });

  dynamic empty;

  factory Type2.fromJson(Map<String, dynamic> json) => Type2(
        empty: json["!="],
      );

  Map<String, dynamic> toJson() => {
        "!=": empty,
      };
}