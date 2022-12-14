import 'package:diamnow/app/localization/app_locales.dart';

class TabModel {
  String title;
  String tab;
  int sequence;

  TabModel({this.title, this.tab, this.sequence});

  TabModel.fromJson(Map<String, dynamic> json) {
    title = R.string?.dynamickeys?.byKey(
      json['title'],
    );
    tab = json['tab'];
    sequence = json['sequence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['tab'] = this.tab;
    data['sequence'] = this.sequence;
    return data;
  }
}
