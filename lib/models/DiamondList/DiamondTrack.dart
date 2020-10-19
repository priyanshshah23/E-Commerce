class CreateDiamondTrackReq {
  int trackType;
  List<Diamonds> diamonds;

  CreateDiamondTrackReq({this.trackType, this.diamonds});

  CreateDiamondTrackReq.fromJson(Map<String, dynamic> json) {
    trackType = json['trackType'];
    if (json['diamonds'] != null) {
      diamonds = new List<Diamonds>();
      json['diamonds'].forEach((v) {
        diamonds.add(new Diamonds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trackType'] = this.trackType;
    if (this.diamonds != null) {
      data['diamonds'] = this.diamonds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Diamonds {
  String diamond;
  String remarks;
  num trackPricePerCarat;
  num trackAmount;
  String newDiscount;
  num trackDiscount;

  Diamonds(
      {this.diamond,
      this.trackPricePerCarat,
      this.trackAmount,
      this.newDiscount,
      this.trackDiscount,
      this.remarks});

  Diamonds.fromJson(Map<String, dynamic> json) {
    diamond = json['diamond'];
    trackPricePerCarat = json['trackPricePerCarat'];
    trackAmount = json['trackAmount'];
    newDiscount = json['newDiscount'];
    trackDiscount = json['trackDiscount'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diamond'] = this.diamond;
    if (this.trackPricePerCarat != null)
      data['trackPricePerCarat'] = this.trackPricePerCarat;
    if (this.trackAmount != null) data['trackAmount'] = this.trackAmount;
    if (this.newDiscount != null) data['newDiscount'] = this.newDiscount;
    if (this.trackDiscount != null) data['trackDiscount'] = this.trackDiscount;
    if (this.remarks != null) data['remarks'] = this.remarks;
    return data;
  }
}