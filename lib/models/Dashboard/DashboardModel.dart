import 'package:diamnow/app/app.export.dart';
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
  });

  List<SavedSearchModel> savedSearch;
  List<SavedSearchModel> recentSearch;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        savedSearch: List<SavedSearchModel>.from(
            json["savedSearch"].map((x) => SavedSearchModel.fromJson(x))),
        // recentSearch: List<SavedSearchModel>.from(
        //     json["recentSearch"].map((x) => SavedSearchModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "savedSearch": List<dynamic>.from(savedSearch.map((x) => x.toJson())),
        // "recentSearch": List<dynamic>.from(recentSearch.map((x) => x.toJson())),
      };
}
