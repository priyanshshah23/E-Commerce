import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';

class DashboardResp extends BaseApiResp {
  DashboardModel data;

  DashboardResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data =
        json['data'] != null ? new DashboardModel.fromJson(json['data']) : null;
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
    this.featuredStone,
    this.seller,
    this.tracks,
  });

  Seller seller;
  List<FeaturedStone> featuredStone;
  List<SavedSearchModel> savedSearch;
  List<SavedSearchModel> recentSearch;
  Map<String, Track> tracks;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        seller: Seller.fromJson(json["seller"]),
        featuredStone: List<FeaturedStone>.from(
            json["featuredStone"].map((x) => FeaturedStone.fromJson(x))),

        savedSearch: List<SavedSearchModel>.from(
            json["savedSearch"].map((x) => SavedSearchModel.fromJson(x))),
        // recentSearch: List<SavedSearchModel>.from(
        //     json["recentSearch"].map((x) => SavedSearchModel.fromJson(x))),
        tracks: Map.from(json["tracks"])
            .map((k, v) => MapEntry<String, Track>(k, Track.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "seller": seller.toJson(),
        "savedSearch": List<dynamic>.from(savedSearch.map((x) => x.toJson())),
        "featuredStone":
            List<dynamic>.from(featuredStone.map((x) => x.toJson())),
        "tracks": Map.from(tracks)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),

        // "recentSearch": List<dynamic>.from(recentSearch.map((x) => x.toJson())),
      };
}

class FeaturedStone {
  FeaturedStone({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.stoneId,
    this.featuredPair,
    this.image,
    this.isActive,
    this.type,
    this.addedBy,
    this.updatedBy,
  });

  DateTime createdAt;
  DateTime updatedAt;
  String id;
  DiamondModel stoneId;
  List<DiamondModel> featuredPair;
  String image;
  bool isActive;
  String type;
  dynamic addedBy;
  dynamic updatedBy;

  factory FeaturedStone.fromJson(Map<String, dynamic> json) => FeaturedStone(
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
        stoneId: DiamondModel.fromJson(json["stoneId"]),
        featuredPair: List<DiamondModel>.from(
            json["featuredPair"].map((x) => DiamondModel.fromJson(x))),
        image: json["image"],
        isActive: json["isActive"],
        type: json["type"],
        addedBy: json["addedBy"],
        updatedBy: json["updatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "id": id,
        "stoneId": stoneId.toJson(),
        "featuredPair": List<dynamic>.from(featuredPair.map((x) => x.toJson())),
        "image": image,
        "isActive": isActive,
        "type": type,
        "addedBy": addedBy,
        "updatedBy": updatedBy,
      };
}

class Seller {
  Seller({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.whatsapp,
  });

  String id;
  String firstName;
  String lastName;
  String email;
  String whatsapp;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        whatsapp: json["whatsapp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "whatsapp": whatsapp,
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
