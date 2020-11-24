import 'package:diamnow/app/base/BaseApiResp.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';

class OrderListResp extends BaseApiResp{
  Data data;

  OrderListResp({ this.data});

  OrderListResp.fromJson(Map<String, dynamic> json): super.fromJson(json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<OrderItem> list;
  int count;

  Data({this.list, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<OrderItem>();
      json['list'].forEach((v) {
        list.add(new OrderItem.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class OrderItem {
  String createdAt;
  String updatedAt;
  String id;
  List<String> diamonds;
  String comment;
  num exchangeRate;
  bool isActive;
  int status;
  String memoNo;
  bool isDeleted;
  int deviceType;
  num totalAmount;
  num shippingCharge;
  String courierName;
  String bankRate;
  String hkId;
  String invoiceDate;
  String companyName;
  String updateIp;
  String createIp;
  String user;
  String seller;
  String billType;
  String sourceOfSale;
  List<DiamondModel> memoDetails;
  bool isSelected = false;

  OrderItem(
      {this.createdAt,
      this.updatedAt,
      this.id,
      this.diamonds,
      this.comment,
      this.exchangeRate,
      this.isActive,
      this.status,
      this.memoNo,
      this.isDeleted,
      this.deviceType,
      this.totalAmount,
      this.shippingCharge,
      this.courierName,
      this.bankRate,
      this.hkId,
      this.invoiceDate,
      this.companyName,
      this.updateIp,
      this.createIp,
      this.user,
      this.seller,
      this.billType,
      this.sourceOfSale,
      this.memoDetails});

  OrderItem.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    diamonds = json['diamonds'].cast<String>();
    comment = json['comment'];
    exchangeRate = json['exchangeRate'];
    isActive = json['isActive'];
    status = json['status'];
    memoNo = json['memoNo'];
    isDeleted = json['isDeleted'];
    deviceType = json['deviceType'];
    totalAmount = json['totalAmount'];
    shippingCharge = json['shippingCharge'];
    courierName = json['courierName'];
    bankRate = json['bankRate'];
    hkId = json['hkId'];
    invoiceDate = json['invoiceDate'];
    companyName = json['companyName'];
    updateIp = json['updateIp'];
    createIp = json['createIp'];
    user = json['user'];
    seller = json['seller'];
    billType = json['billType'];
    sourceOfSale = json['sourceOfSale'];
    if (json['memoDetails'] != null) {
      memoDetails = new List<DiamondModel>();
      json['memoDetails'].forEach((v) {
        memoDetails.add(new DiamondModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['diamonds'] = this.diamonds;
    data['comment'] = this.comment;
    data['exchangeRate'] = this.exchangeRate;
    data['isActive'] = this.isActive;
    data['status'] = this.status;
    data['memoNo'] = this.memoNo;
    data['isDeleted'] = this.isDeleted;
    data['deviceType'] = this.deviceType;
    data['totalAmount'] = this.totalAmount;
    data['shippingCharge'] = this.shippingCharge;
    data['courierName'] = this.courierName;
    data['bankRate'] = this.bankRate;
    data['hkId'] = this.hkId;
    data['invoiceDate'] = this.invoiceDate;
    data['companyName'] = this.companyName;
    data['updateIp'] = this.updateIp;
    data['createIp'] = this.createIp;
    data['user'] = this.user;
    data['seller'] = this.seller;
    data['billType'] = this.billType;
    data['sourceOfSale'] = this.sourceOfSale;
    if (this.memoDetails != null) {
      data['memoDetails'] = this.memoDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
