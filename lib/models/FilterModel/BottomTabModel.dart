import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BottomCodeConstant {
  static const String savedSearch = "SAVED_SEARCH";
  static const String addDemamd = "ADD_DEMAND";
  static const String search = "SEARCH";
  static const String saveAndSearch = "SAVE_SEARCH";
  static const String matchPair = "MATCH_PAIR";
}

class TabConfiguration {
  Color textColor;
  Color backgroundColor;
  Color centerImageBackgroundColor;

  TabConfiguration(
      {this.textColor, this.backgroundColor, this.centerImageBackgroundColor});

  TabConfiguration.fromJson(Map<String, dynamic> json) {
    textColor = fromHex(
        json['textColor'] ?? "#${appTheme.whiteColor.value.toRadixString(16)}");
    backgroundColor = fromHex(json['backgroundColor'] ??
        "#${appTheme.colorPrimary.value.toRadixString(16)}");
    centerImageBackgroundColor = fromHex(json['centerImageBackgroundColor'] ??
        "#${appTheme.whiteColor.value.toRadixString(16)}");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['textColor'] = this.textColor;
    data['backgroundColor'] = this.backgroundColor;
    data['centerImageBackgroundColor'] = this.centerImageBackgroundColor;
    return data;
  }

  Color getBackgroundColor() {
    return backgroundColor ??
        fromHex("#${appTheme.colorPrimary.value.toRadixString(16)}");
  }

  Color getTextColor() {
    return backgroundColor ??
        fromHex("#${appTheme.whiteColor.value.toRadixString(16)}");
  }

  Color getCenterImageBackgroundColor() {
    return backgroundColor ??
        fromHex("#${appTheme.whiteColor.value.toRadixString(16)}");
  }
}

class BottomTabModel extends TabConfiguration {
  String title;
  String image;
  String code;
  int sequence;
  bool isCenter;

  BottomTabModel({
    this.title,
    this.image,
    this.code,
    this.sequence,
    this.isCenter,
  });

  BottomTabModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    title = json['title'];
    image = json['image'];
    sequence = json['sequence'];
    isCenter = json['isCenter'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['title'] = this.title;
    data['image'] = this.image;
    data['sequence'] = this.sequence;
    data['isCenter'] = this.isCenter;
    return data;
  }

  List<BottomTabModel> getFilterScreenBottomTabs() {
    List<BottomTabModel> arrBootomTab = List<BottomTabModel>();
    arrBootomTab.add(BottomTabModel(
        title: "Saved Search",
        image: savedSearch,
        code: BottomCodeConstant.savedSearch,
        sequence: 0,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "Add Demand",
        image: addDemand,
        code: BottomCodeConstant.addDemamd,
        sequence: 1,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "",
        image: search,
        code: BottomCodeConstant.search,
        sequence: 2,
        isCenter: true));
    arrBootomTab.add(BottomTabModel(
        title: "Save & Search",
        image: saveAndSearch,
        code: BottomCodeConstant.savedSearch,
        sequence: 3,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "Match Pair",
        image: matchPair,
        code: BottomCodeConstant.matchPair,
        sequence: 4,
        isCenter: false));

    return arrBootomTab;
  }
}
