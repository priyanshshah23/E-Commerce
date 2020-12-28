import 'package:diamnow/app/app.export.dart';

class AnalyticsReq {
  String action;
  String page;
  String section;
  String description;

  AnalyticsReq({
    this.action,
    this.page,
    this.section,
    this.description,
  });

  AnalyticsReq.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    page = json['page'];
    section = json['section'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (!isNullEmptyOrFalse(this.action)) {
      data['action'] = this.action;
    }
    if (!isNullEmptyOrFalse(this.page)) {
      data['page'] = this.page;
    }
    if (!isNullEmptyOrFalse(this.section)) {
      data['section'] = this.section;
    }
    if (!isNullEmptyOrFalse(this.description)) {
      data['description'] = this.description;
    }
    return data;
  }
}
