import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/date_utils.dart';

class SlotResp extends BaseApiResp {
  Data data;

  SlotResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
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
  int count;
  List<SlotModel> list;

  Data({this.count, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['list'] != null) {
      list = new List<SlotModel>();
      json['list'].forEach((v) {
        list.add(new SlotModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotModel {
  String createdAt;
  String updatedAt;
  String id;
  String start;
  String end;
  int weekDay;
  int type;
  int slotDurationType;
  bool isActive;
  String appliedFrom;
  String appliedTo;
  String reason;
  bool isDeleted;
  String cabinId;
  bool disable;
  String startTime;
  String endTime;

  SlotModel(
      {this.createdAt,
      this.updatedAt,
      this.id,
      this.start,
      this.end,
      this.weekDay,
      this.type,
      this.slotDurationType,
      this.isActive,
      this.appliedFrom,
      this.appliedTo,
      this.reason,
      this.isDeleted,
      this.cabinId});

  SlotModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    start = json['start'];
    end = json['end'];
    weekDay = json['weekDay'];
    type = json['type'];
    slotDurationType = json['slotDurationType'];
    isActive = json['isActive'];
    appliedFrom = json['appliedFrom'];
    appliedTo = json['appliedTo'];
    reason = json['reason'];
    isDeleted = json['isDeleted'];

    cabinId = json['cabinId'];

    startTime = DateUtilities().convertServerDateToFormatterString(start,
        formatter: DateUtilities.hh_mm_a);

    endTime = DateUtilities().convertServerDateToFormatterString(end,
        formatter: DateUtilities.hh_mm_a);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['start'] = this.start;
    data['end'] = this.end;
    data['weekDay'] = this.weekDay;
    data['type'] = this.type;
    data['slotDurationType'] = this.slotDurationType;
    data['isActive'] = this.isActive;
    data['appliedFrom'] = this.appliedFrom;
    data['appliedTo'] = this.appliedTo;
    data['reason'] = this.reason;
    data['isDeleted'] = this.isDeleted;

    data['cabinId'] = this.cabinId;
    return data;
  }
}
