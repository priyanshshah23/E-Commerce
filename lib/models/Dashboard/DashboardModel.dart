import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';

class DashboardResp extends BaseApiResp {
  DashboardModel data;

  DashboardResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = isNullEmptyOrFalse(json['data']) == false
        ? new DashboardModel.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class DashboardModel {
  DashboardModel({
    this.savedSearch,
    this.recentSearch,
    this.newArrival,
    this.featuredStone,
    this.seller,
    this.tracks,
    this.dashboardCount,
  });

  Seller seller;
  List<DiamondModel> featuredStone;
  List<DiamondModel> newArrival;
  List<SavedSearchModel> savedSearch;
  List<SavedSearchModel> recentSearch;
  Map<String, Track> tracks;
  List<DashboardCount> dashboardCount;

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    List<DiamondModel> arrFeaturestone = [];
    if (!isNullEmptyOrFalse(json["featuredStone"])) {
      if (json["featuredStone"] is List<dynamic>) {
        json["featuredStone"].forEach((element) {
          arrFeaturestone.add(DiamondModel.fromJson(element));
        });
      }
    }

    List<DiamondModel> arrNewArrivals = [];
    if (!isNullEmptyOrFalse(json["newArrival"])) {
      if (json["newArrival"] is List<dynamic>) {
        json["newArrival"].forEach((element) {
          arrNewArrivals.add(DiamondModel.fromJson(element));
        });
      }
    }
    return DashboardModel(
      seller: isNullEmptyOrFalse(json["seller"])
          ? null
          : Seller.fromJson(json["seller"]),
      featuredStone: arrFeaturestone,
      recentSearch: List<SavedSearchModel>.from(
          json["recentSearch"].map((x) => SavedSearchModel.fromJson(x))),
      savedSearch: List<SavedSearchModel>.from(
          json["savedSearch"].map((x) => SavedSearchModel.fromJson(x))),
      newArrival: arrNewArrivals,
      // // recentSearch: List<SavedSearchModel>.from(
      // //     json["recentSearch"].map((x) => SavedSearchModel.fromJson(x))),
      tracks: Map.from(json["tracks"])
          .map((k, v) => MapEntry<String, Track>(k, Track.fromJson(v))),
      dashboardCount: List<DashboardCount>.from(
          json["dashboardCount"].map((x) => DashboardCount.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "seller": seller.toJson(),
        "savedSearch": List<dynamic>.from(
          savedSearch.map((x) => x.toJson()),
        ),
        "featuredStone":
            List<dynamic>.from(featuredStone.map((x) => x.toJson())),
        "newArrival": List<dynamic>.from(
          newArrival.map(
            (x) => x.toJson(),
          ),
        ),
        "tracks": Map.from(tracks)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "dashboardCount":
            List<dynamic>.from(dashboardCount.map((x) => x.toJson())),
        "recentSearch": List<dynamic>.from(recentSearch.map((x) => x.toJson())),
      };
}

class NewArrival {
  NewArrival({
    this.list,
    this.count,
  });

  List<DiamondModel> list;
  int count;

  factory NewArrival.fromJson(Map<String, dynamic> json) => NewArrival(
        list: List<DiamondModel>.from(
            json["list"].map((x) => DiamondModel.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "count": count,
      };
}

class FeaturedStone {
  FeaturedStone({
    this.list,
    this.count,
  });

  List<DiamondModel> list;
  int count;

  factory FeaturedStone.fromJson(Map<String, dynamic> json) => FeaturedStone(
        list: List<DiamondModel>.from(
            json["list"].map((x) => DiamondModel.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "count": count,
      };
}

class Seller {
  Seller({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.whatsapp,
    this.mobile,
  });

  String id;
  String firstName;
  String lastName;
  String email;
  String whatsapp;
  String mobile;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"] ?? "-",
        whatsapp: json["whatsapp"] ?? "-",
        mobile: json["mobile"] ?? "-",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "whatsapp": whatsapp,
        "mobile": mobile,
      };
}

class Track {
  Track({
    this.pieces,
    this.carat,
    this.totals,
  });

  num pieces;
  num carat;
  num totals;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        pieces: json["pieces"],
        carat: json["carat"],
        totals: json["totals"],
      );

  Map<String, dynamic> toJson() => {
        "pieces": pieces,
        "carat": carat,
        "totals": totals,
      };
}

class DashboardCount {
  DashboardCount({
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
    this.updateIp,
    this.createIp,
    this.user,
    this.account,
  });

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
  String updateIp;
  String createIp;

  String user;
  String account;

  factory DashboardCount.fromJson(Map<String, dynamic> json) => DashboardCount(
        id: json["id"],
        name: json["name"],
        isSentReminder: json["isSentReminder"],
        normalizeName: json["normalizeName"],
        searchData: SearchData.fromJson(json["searchData"]),
        type: json["type"],
        expiryDate: json["expiryDate"],
        remark: json["remark"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        isSendNotification: json["isSendNotification"],
        isReturnSimilar: json["isReturnSimilar"],
        searchCount: json["searchCount"],
        updateIp: json["updateIp"],
        createIp: json["createIp"],
        user: json["user"],
        account: json["account"],
      );

  Map<String, dynamic> toJson() => {
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
        "searchCount": searchCount,
        "updateIp": updateIp,
        "createIp": createIp,
        "user": user,
        "account": account,
      };
}
