import 'package:diamnow/app/app.export.dart';

class CreateDiamondTrackReq {
  int trackType;
  int bidType;
  String remarks;
  String company;
  List<Diamonds> diamonds;

  CreateDiamondTrackReq({this.trackType, this.diamonds});

  CreateDiamondTrackReq.fromJson(Map<String, dynamic> json) {
    trackType = json['trackType'];
    bidType = json['bidType'];
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

    if (this.bidType != null) data['bidType'] = this.bidType;
    if (this.trackType != null) data['trackType'] = this.trackType;
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

  num bidPricePerCarat;
  num bidAmount;
  num bidDiscount;
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
      this.bidPricePerCarat,
      this.bidAmount,
      this.bidDiscount,
      this.remarks});

  Diamonds.fromJson(Map<String, dynamic> json) {
    diamond = json['diamond'];
    diamond = json['offerValidDate'];
    bidPricePerCarat = json['bidPricePerCarat'];
    bidAmount = json['bidAmount'];
    bidDiscount = json['bidDiscount'];
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

    if (this.bidPricePerCarat != null)
      data['bidPricePerCarat'] = this.bidPricePerCarat;
    if (this.bidAmount != null) data['trackPricePerCarat'] = this.bidAmount;
    if (this.bidDiscount != null) data['bidDiscount'] = this.bidDiscount;
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

class TrackDelReq {
  int trackType;
  List<String> id;

  TrackDelReq({this.trackType, this.id});

  TrackDelReq.fromJson(Map<String, dynamic> json) {
    trackType = json['trackType'];
    id = json['id'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (trackType != null) data['trackType'] = this.trackType;
    if (id != null) data['id'] = this.id;
    return data;
  }
}

class TrackDataReq {
  List<int> blockType;

  TrackDataReq({this.blockType});

  TrackDataReq.fromJson(Map<String, dynamic> json) {
    blockType = json['blockType'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (blockType != null) data['blockType'] = this.blockType;
    return data;
  }
}

class TrackBlockResp extends BaseApiResp {
  TrackBlockData data;

  TrackBlockResp({this.data});

  TrackBlockResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['data'] != null ? new TrackBlockData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class TrackBlockData {
  int count;
  List<InTrackDiamonds> inTrackDiamonds;

  TrackBlockData({this.count, this.inTrackDiamonds});

  TrackBlockData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['inTrackDiamonds'] != null) {
      inTrackDiamonds = new List<InTrackDiamonds>();
      json['inTrackDiamonds'].forEach((v) {
        inTrackDiamonds.add(new InTrackDiamonds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.inTrackDiamonds != null) {
      data['inTrackDiamonds'] =
          this.inTrackDiamonds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InTrackDiamonds {
  int iId;
  List<TrackDiamonds> diamonds;

  InTrackDiamonds({this.iId, this.diamonds});

  InTrackDiamonds.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    if (json['diamonds'] != null) {
      diamonds = new List<TrackDiamonds>();
      json['diamonds'].forEach((v) {
        diamonds.add(new TrackDiamonds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    if (this.diamonds != null) {
      data['diamonds'] = this.diamonds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrackDiamonds {
  String id;
  String trackId;
  String remarks;
  String reminderDate;
  String commentColor;

  TrackDiamonds(
      {this.id,
      this.trackId,
      this.remarks,
      this.reminderDate,
      this.commentColor});

  TrackDiamonds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trackId = json['trackId'];
    remarks = json['remarks'];
    reminderDate = json['reminderDate'];
    commentColor = json['commentColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['trackId'] = this.trackId;
    data['remarks'] = this.remarks;
    data['reminderDate'] = this.reminderDate;
    data['commentColor'] = this.commentColor;
    return data;
  }
}
