class UpcomingDiamondListReq {
  int page;
  int limit;
  List<Filters> filters;
  List<Sort> sort;

  UpcomingDiamondListReq({this.page, this.limit, this.filters, this.sort});

  UpcomingDiamondListReq.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    if (json['filters'] != null) {
      filters = new List<Filters>();
      json['filters'].forEach((v) {
        filters.add(new Filters.fromJson(v));
      });
    }
    if (json['sort'] != null) {
      sort = new List<Sort>();
      json['sort'].forEach((v) {
        sort.add(new Sort.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    if (this.filters != null) {
      data['filters'] = this.filters.map((v) => v.toJson()).toList();
    }
    if (this.sort != null) {
      data['sort'] = this.sort.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Filters {
  String wSts;
  InDt inDt;

  Filters({this.wSts, this.inDt});

  Filters.fromJson(Map<String, dynamic> json) {
    wSts = json['wSts'];
    inDt = json['inDt'] != null ? new InDt.fromJson(json['inDt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wSts'] = this.wSts;
    if (this.inDt != null) {
      data['inDt'] = this.inDt.toJson();
    }
    return data;
  }
}

class InDt {
  String greterThan;

  InDt({this.greterThan});

  InDt.fromJson(Map<String, dynamic> json) {
    greterThan = json['greterThan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['greterThan'] = this.greterThan;
    return data;
  }
}

class Sort {
  String inDt;

  Sort({this.inDt});

  Sort.fromJson(Map<String, dynamic> json) {
    inDt = json['inDt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inDt'] = this.inDt;
    return data;
  }
}
