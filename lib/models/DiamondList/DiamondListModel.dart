class DiamondListReq {
  Filters filters;
  bool isNotReturnTotal;
  bool isReturnCountOnly;

  DiamondListReq({this.filters, this.isNotReturnTotal, this.isReturnCountOnly});

  DiamondListReq.fromJson(Map<String, dynamic> json) {
    if (json['filters'] != null) {
      filters = json['filters'] != null
          ? new Filters.fromJson(json['filters'])
          : null;
    }
    if (json['isNotReturnTotal'] != null) {
      isNotReturnTotal = json['isNotReturnTotal'];
    }
    if (json['isReturnCountOnly'] != null) {
      isReturnCountOnly = json['isReturnCountOnly'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.filters != null) {
      data['filters'] = this.filters.toJson();
    }
    if (this.isNotReturnTotal != null) {
      data['isNotReturnTotal'] = this.isNotReturnTotal;
    }
    if (this.isReturnCountOnly != null) {
      data['isReturnCountOnly'] = this.isReturnCountOnly;
    }
    return data;
  }
}

class Filters {
  String diamondSearchId;

  Filters({this.diamondSearchId});

  Filters.fromJson(Map<String, dynamic> json) {
    diamondSearchId = json['diamondSearchId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diamondSearchId'] = this.diamondSearchId;
    return data;
  }
}
