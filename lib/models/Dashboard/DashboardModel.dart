import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';

class AdminDashboardResp extends BaseApiResp {
  AdminDashboardModel data;

  AdminDashboardResp({this.data});

  AdminDashboardResp.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['data'] != null
        ? new AdminDashboardModel.fromJson(json['data'])
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

class AdminDashboardModel {
//  TotalDiamond totalDiamond;
//  TotalDiamond totalSupplier;
//  TotalDiamond totalCarat;
//  TotalDiamond totalValue;
//  TotalDiamond recentLoginUsers;
//  TotalDiamond recentSearch;
//  TotalDiamond analytics;
//  TotalDiamond recentEnquiryTracksAndNotes;
  Counts counts;

  AdminDashboardModel({
//    this.totalDiamond,
//    this.totalSupplier,
//    this.totalCarat,
//    this.totalValue,
//    this.recentLoginUsers,
//    this.recentSearch,
//    this.analytics,
//    this.recentEnquiryTracksAndNotes,
    this.counts,
  });

  AdminDashboardModel.fromJson(Map<String, dynamic> json) {
//    totalDiamond = json['totalDiamond'] != null ? new TotalDiamond.fromJson(json['totalDiamond']) : null;
//    totalSupplier = json['totalSupplier'] != null ? new TotalDiamond.fromJson(json['totalSupplier']) : null;
//    totalCarat = json['totalCarat'] != null ? new TotalDiamond.fromJson(json['totalCarat']) : null;
//    totalValue = json['totalValue'] != null ? new TotalDiamond.fromJson(json['totalValue']) : null;
//    recentLoginUsers = json['recentLoginUsers'] != null ? new TotalDiamond.fromJson(json['recentLoginUsers']) : null;
//    recentSearch = json['recentSearch'] != null ? new TotalDiamond.fromJson(json['recentSearch']) : null;
//    analytics = json['analytics'] != null ? new TotalDiamond.fromJson(json['analytics']) : null;
//    recentEnquiryTracksAndNotes = json['recentEnquiryTracksAndNotes'] != null ? new TotalDiamond.fromJson(json['recentEnquiryTracksAndNotes']) : null;
    counts =
        json['counts'] != null ? new Counts.fromJson(json['counts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
//    if (this.totalDiamond != null) {
//      data['totalDiamond'] = this.totalDiamond.toJson();
//    }
//    if (this.totalSupplier != null) {
//      data['totalSupplier'] = this.totalSupplier.toJson();
//    }
//    if (this.totalCarat != null) {
//      data['totalCarat'] = this.totalCarat.toJson();
//    }
//    if (this.totalValue != null) {
//      data['totalValue'] = this.totalValue.toJson();
//    }
//    if (this.recentLoginUsers != null) {
//      data['recentLoginUsers'] = this.recentLoginUsers.toJson();
//    }
//    if (this.recentSearch != null) {
//      data['recentSearch'] = this.recentSearch.toJson();
//    }
//    if (this.analytics != null) {
//      data['analytics'] = this.analytics.toJson();
//    }
//    if (this.recentEnquiryTracksAndNotes != null) {
//      data['recentEnquiryTracksAndNotes'] = this.recentEnquiryTracksAndNotes.toJson();
//    }
    if (this.counts != null) {
      data['counts'] = this.counts.toJson();
    }
    return data;
  }
}

class Counts {
  int cart;
  int watchlist;
  int offer;
  int office;
  int order;
  int memo;

  Counts(
      {this.cart,
      this.watchlist,
      this.offer,
      this.office,
      this.order,
      this.memo});

  Counts.fromJson(Map<String, dynamic> json) {
    cart = json['Cart'];
    watchlist = json['Watchlist'];
    offer = json['Offer'];
    office = json['Office'];
    order = json['Order'];
    memo = json['Memo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Cart'] = this.cart;
    data['Watchlist'] = this.watchlist;
    data['Offer'] = this.offer;
    data['Office'] = this.office;
    data['Order'] = this.order;
    data['Memo'] = this.memo;
    return data;
  }
}

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

// class BannerModel {
//   List<Banners> banners;

//   BannerModel({this.banners});

//   BannerModel.fromJson(Map<String, dynamic> json) {
//     if (json['banners'] != null) {
//       banners = new List<Banners>();
//       json['banners'].forEach((v) {
//         banners.add(new Banners.fromJson(v));
//       });
//     }
//     print(banners.length);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.banners != null) {
//       data['banners'] = this.banners.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class DashboardModel {
  DashboardModel({
    this.savedSearch,
    this.recentSearch,
    this.newArrival,
    this.featuredStone,
    this.seller,
    this.tracks,
    this.dashboardCount,
    this.banners,
  });

  Seller seller;
  List<DiamondModel> featuredStone;
  List<DiamondModel> newArrival;
  List<SavedSearchModel> savedSearch;
  List<SavedSearchModel> recentSearch;
  Map<String, Track> tracks;
  List<Banners> banners;
  List<DashboardCount> dashboardCount;

  Banners getBannerDetails(String type) {
    for (int i = 0; i < banners.length; i++) {
      if (type == banners[i].type) {
        return banners[i];
      }
    }
    return null;
  }

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    List<DiamondModel> arrFeaturestone = [];
    if (!isNullEmptyOrFalse(json["featuredStone"])) {
      if (json["featuredStone"] is List<dynamic>) {
        json["featuredStone"].forEach((element) {
          arrFeaturestone.add(DiamondModel.fromJson(element));
        });
      }
    }
    List<Banners> banners = [];
    if (json['banners'] != null) {
      banners = new List<Banners>();
      json['banners'].forEach((v) {
        banners.add(new Banners.fromJson(v));
      });
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
      banners:
          List<Banners>.from(json["banners"].map((x) => Banners.fromJson(x))),
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
        "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
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

class DashboardBannerModel {
  String type;
  Banners banners;
  List<DashboardBannerDetail> itemList;

  DashboardBannerModel(
    this.type,
    this.banners,
    this.itemList  );
}

class DashboardBannerDetail {
  String type;
  Banners banners;

  DashboardBannerDetail(
    this.type,
    this.banners,
  );
}

List<DashboardBannerModel> dBannerModel() {
  List<DashboardBannerModel> banners;

  Banners getBannerDetails(String type) {
    for (int i = 0; i < banners.length; i++) {
      if (type == banners[i].type) {
        print(banners[i]);
      }
    }
    return null;
  }
}

