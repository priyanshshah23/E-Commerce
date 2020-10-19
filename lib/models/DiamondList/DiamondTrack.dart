class CreateDiamondTrackReq {
  int trackType;
  String remarks;
  String company;
  List<Diamonds> diamonds;

  CreateDiamondTrackReq({this.trackType, this.diamonds});

  CreateDiamondTrackReq.fromJson(Map<String, dynamic> json) {
    trackType = json['trackType'];
    remarks = json['remarks'];
    company = json['company'];
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
    if (this.remarks != null) data['remarks'] = this.remarks;
    if (this.company != null) data['company'] = this.company;
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
  String vStnId;
  String offerValidDate;
  num trackDiscount;
  num newPricePerCarat;
  num newAmount;
  num newDiscount;

  Diamonds(
      {this.diamond,
      this.trackPricePerCarat,
      this.trackAmount,
      this.newDiscount,
      this.trackDiscount,
      this.remarks});

  Diamonds.fromJson(Map<String, dynamic> json) {
    diamond = json['diamond'];
    diamond = json['offerValidDate'];
    trackPricePerCarat = json['trackPricePerCarat'];
    trackAmount = json['trackAmount'];
    newDiscount = json['newDiscount'];
    trackDiscount = json['trackDiscount'];
    remarks = json['remarks'];
    offerValidDate = json['offerValidDate'];
    newPricePerCarat = json['newPricePerCarat'];
    newAmount = json['newAmount'];
    vStnId = json['vStnId'];
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
    if (this.offerValidDate != null)
      data['offerValidDate'] = this.offerValidDate;
    if (this.newPricePerCarat != null)
      data['newPricePerCarat'] = this.newPricePerCarat;
    if (this.newAmount != null) data['newAmount'] = this.newAmount;
    if (this.vStnId != null) data['vStnId'] = this.vStnId;
    return data;
  }
}
class PlaceOrderReq {
  List<String> diamonds;
  String comment;
  String company;
  String date;

  PlaceOrderReq({this.diamonds, this.comment, this.company, this.date});

  PlaceOrderReq.fromJson(Map<String, dynamic> json) {
    diamonds = json['diamonds'].cast<String>();
    comment = json['comment'];
    company = json['company'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diamonds'] = this.diamonds;
    data['comment'] = this.comment;
    data['company'] = this.company;
    data['date'] = this.date;
    return data;
  }
}
