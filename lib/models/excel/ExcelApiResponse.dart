import 'package:diamnow/app/base/BaseApiResp.dart';

class ExcelApiResponse extends BaseApiResp{
  String code;
  String message;
  Data data;

  ExcelApiResponse({this.code, this.message, this.data});

  ExcelApiResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
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
  String data;
  String excelPath;
  String excelName;
  String message;

  Data({this.data, this.excelPath, this.excelName, this.message});

  Data.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    excelPath = json['excelPath'];
    excelName = json['excelName'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['excelPath'] = this.excelPath;
    data['excelName'] = this.excelName;
    data['message'] = this.message;
    return data;
  }
}