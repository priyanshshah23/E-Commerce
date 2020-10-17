import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BottomCodeConstant {
  //filter
  static const String filterSavedSearch = "FILTER_SAVED_SEARCH";
  static const String filterAddDemamd = "FILTER_ADD_DEMAND";
  static const String filterSearch = "FILTER_SEARCH";
  static const String filterSaveAndSearch = "FILTER_SAVE_SEARCH";
  static const String filteMatchPair = "FILTER_MATCH_PAIR";

  //DIAMOND LIST
  static const String dLShowSelected = "DL_SHOWSELECTED";
  static const String dLCompare = "DL_COMPARE";
  static const String dLMore = "DL_MORE";
  static const String dLStatus = "DL_STATUS";

//DIAMOND DETAIL
  static const String dDEnquiry = "DD_ENQUIRY";
  static const String dDAddToCart = "DD_ADD_TO_CART";
  static const String dDAddToWatchlist = "DD_ADD_TO_WATCHLIST";
  static const String dDPlaceOrder = "DD_PLACEORDER";
  static const String dDComment = "DD_COMMENT";
  static const String dDMore = "DD_MORE";

  //Toolbar Constant

  static const String TBSelectAll = "TB_SELECT_ALL";
  static const String TBGrideView = "TB_GRIDE_VIEW";
  static const String TBSortView = "TB_SORT_VIEW";
  static const String TBDownloadView = "TB_DOWNLOAD_VIEW";
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
    return backgroundColor ?? appTheme.colorPrimary;
  }

  Color getTextColor() {
    return backgroundColor ?? appTheme.whiteColor;
  }

  Color getCenterImageBackgroundColor() {
    return backgroundColor ?? appTheme.whiteColor;
  }
}

class BottomTabModel extends TabConfiguration {
  String title;
  String image;
  String code;
  int type;
  int sequence;
  bool isCenter;
  bool isSelected;

  BottomTabModel({
    this.title,
    this.image,
    this.code,
    this.sequence,
    this.isCenter,
    this.type,
    this.isSelected = false,
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
}

class BottomTabBar {
  //

  static List<BottomTabModel> getFilterScreenBottomTabs() {
    List<BottomTabModel> arrBootomTab = List<BottomTabModel>();
    arrBootomTab.add(BottomTabModel(
        title: "Saved Search",
        image: savedSearch,
        code: BottomCodeConstant.filterSavedSearch,
        sequence: 0,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "Add Demand",
        image: addDemand,
        code: BottomCodeConstant.filterAddDemamd,
        sequence: 1,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "",
        image: search,
        code: BottomCodeConstant.filterSearch,
        sequence: 2,
        isCenter: true));
    arrBootomTab.add(BottomTabModel(
        title: "Save & Search",
        image: saveAndSearch,
        code: BottomCodeConstant.filterSaveAndSearch,
        sequence: 3,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "Match Pair",
        image: matchPair,
        code: BottomCodeConstant.filteMatchPair,
        sequence: 4,
        isCenter: false));

    return arrBootomTab;
  }

  static List<BottomTabModel> getDiamondListScreenBottomTabs() {
    List<BottomTabModel> arrBootomTab = List<BottomTabModel>();
    arrBootomTab.add(BottomTabModel(
        title: "Show Selected",
        image: showSelected,
        code: BottomCodeConstant.dLShowSelected,
        sequence: 0,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "Compare",
        image: compare,
        code: BottomCodeConstant.dLCompare,
        sequence: 1,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "More",
        image: plusIcon,
        code: BottomCodeConstant.dLMore,
        sequence: 2,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "Status",
        image: status,
        code: BottomCodeConstant.dLStatus,
        sequence: 3,
        isCenter: false));

    return arrBootomTab;
  }

  static List<BottomTabModel> getDiamondDetailScreenBottomTabs() {
    List<BottomTabModel> arrBootomTab = List<BottomTabModel>();
    arrBootomTab.add(BottomTabModel(
        title: "Enquiry",
        image: enquiry,
        code: BottomCodeConstant.dDEnquiry,
        sequence: 0,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "Add to Cart",
        image: addToCart,
        code: BottomCodeConstant.dDAddToCart,
        sequence: 1,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "More",
        image: plusIcon,
        code: BottomCodeConstant.dDMore,
        sequence: 2,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "Place Order",
        image: placeOrder,
        code: BottomCodeConstant.dDPlaceOrder,
        sequence: 3,
        isCenter: false));
    // arrBootomTab.add(BottomTabModel(
    //     title: "Comment",
    //     image: comment,
    //     code: BottomCodeConstant.dDComment,
    //     sequence: 4,
    //     isCenter: false));

    return arrBootomTab;
  }

  List<BottomTabModel> getTimeSlotList(){
    List<BottomTabModel> arrTimeList=[];
    arrTimeList.add(BottomTabModel(
      title: "9:00AM - 9:30AM",
    ));
  }
}
