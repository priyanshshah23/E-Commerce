import 'package:diamnow/app/app.export.dart';

class ExclusiveCollection extends BaseApiResp {
  String code;
  String message;

  ExclusiveCollectionModel data;

  ExclusiveCollection({this.data, this.message, this.code});

  ExclusiveCollection.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null
        ? new ExclusiveCollectionModel.fromJson(json['data'])
        : null;
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

class ExclusiveCollectionModel {
  List<Collection> list;
  int count;
  // int gridColumns;

  ExclusiveCollectionModel({
    this.list,
    this.count,
  });

  ExclusiveCollectionModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<Collection>();
      json['list'].forEach((v) {
        list.add(new Collection.fromJson(v));
      });
    }
    count = json['count'];
    // gridColumns = json['gridColumns'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    // data['gridColumns'] = this.gridColumns ?? 0;
    return data;
  }
}

class Collection {
  String id;
  String name;

  Collection({this.id, this.name});

  Collection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
