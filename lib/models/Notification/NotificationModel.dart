import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/date_utils.dart';

class NotificationResp extends BaseApiResp {
  Data data;

  NotificationResp.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
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
  int unReadCount;
  int unVisitedCount;
  List<NotificationModel> list;

  Data({this.count, this.unReadCount, this.unVisitedCount, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    unReadCount = json['unReadCount'];
    unVisitedCount = json['unVisitedCount'];
    if (json['list'] != null) {
      list = new List<NotificationModel>();
      json['list'].forEach((v) {
        list.add(new NotificationModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['unReadCount'] = this.unReadCount;
    data['unVisitedCount'] = this.unVisitedCount;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationModel {
  String createdAt;
  String updatedAt;
  String id;
  int type;
  int module;
  String activityType;
  String title;
  String message;
  bool isActive;
  bool isRead;
  int level;
  String parentId;
  bool isVisited;
  // String user;
  String megaTitle;
  String strDate;
  bool flagForPastNotificationTime = true;

  NotificationModel({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.type,
    this.module,
    this.activityType,
    this.title,
    this.message,
    this.isActive,
    this.isRead,
    this.level,
    this.parentId,
    this.isVisited,
    // this.user,
    this.strDate,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    type = json['type'];
    module = json['module'];
    activityType = json['activityType'];
    title = json['title'];
    message = json['message'];
    isActive = json['isActive'];
    isRead = json['isRead'];
    level = json['level'];
    parentId = json['parentId'];
    isVisited = json['isVisited'];
    // user = json['user'];
    strDate = DateUtilities().convertServerDateToFormatterString(createdAt,
        formatter: DateUtilities.dd_mm_yyyy_);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['type'] = this.type;
    data['module'] = this.module;
    data['activityType'] = this.activityType;
    data['title'] = this.title;
    data['message'] = this.message;
    data['isActive'] = this.isActive;
    data['isRead'] = this.isRead;
    data['level'] = this.level;
    data['parentId'] = this.parentId;
    data['isVisited'] = this.isVisited;
    // data['user'] = this.user;
    return data;
  }
}
