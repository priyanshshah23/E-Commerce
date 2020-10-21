import 'package:diamnow/app/app.export.dart';

class QuickSearchResp extends BaseApiResp {
  Data data;

  QuickSearchResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
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
  List<QuickSearchModel> list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<QuickSearchModel>();
      json['list'].forEach((v) {
        list.add(new QuickSearchModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuickSearchModel {
  String color;
  String clarity;
  String shape;
  String pointer;
  int count;
  num carat;
  num totalAmount;
  num minMarketingPricePerCarat;
  num maxMarketingPricePerCarat;
  Range range;

  QuickSearchModel(
      {this.color,
      this.clarity,
      this.shape,
      this.pointer,
      this.count,
      this.carat,
      this.totalAmount,
      this.minMarketingPricePerCarat,
      this.maxMarketingPricePerCarat,
      this.range});

  QuickSearchModel.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    clarity = json['clarity'];
    shape = json['shape'];
    pointer = json['pointer'];
    count = json['count'];
    carat = json['carat'];
    totalAmount = json['totalAmount'];
    minMarketingPricePerCarat = json['MinMarketingPricePerCarat'];
    maxMarketingPricePerCarat = json['MaxMarketingPricePerCarat'];
    range = json['range'] != null ? new Range.fromJson(json['range']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    data['clarity'] = this.clarity;
    data['shape'] = this.shape;
    data['pointer'] = this.pointer;
    data['count'] = this.count;
    data['carat'] = this.carat;
    data['totalAmount'] = this.totalAmount;
    data['MinMarketingPricePerCarat'] = this.minMarketingPricePerCarat;
    data['MaxMarketingPricePerCarat'] = this.maxMarketingPricePerCarat;
    if (this.range != null) {
      data['range'] = this.range.toJson();
    }
    return data;
  }
}

class Range {
  num from;
  num to;
  String id;

  Range({this.from, this.to, this.id});

  Range.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['to'] = this.to;
    data['id'] = this.id;
    return data;
  }
}
