import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BottomCodeConstant {
  //filter

  static const String filterSearchUpcoming = "FILTER_SEARCH_UPCOMING";
  static const String filterSearchNewArrival = "FILTER_SEARCH_NEW_ARRIVAL";
  static const String filterSavedSearch = "FILTER_SAVED_SEARCH";
  static const String filterAddDemamd = "FILTER_ADD_DEMAND";
  static const String filterSearch = "FILTER_SEARCH";
  static const String filterSaveAndSearch = "FILTER_SAVE_SEARCH";
  static const String filteMatchPair = "FILTER_MATCH_PAIR";
  static const String filterReset = "FILTER_RESET";

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
  static const String TBShare = "TB_SHARE";
  static const String TBClock = "TB_CLOCK";
  static const String TBCompanySelection = "TB_COMPANY_SELECTION";

  static const String TBProfile = "TB_PROFILE";
  static const String TBNotification = "TB_NOTIFICATION";
}

class TabConfiguration {
  Color imageColor;
  Color textColor;
  Color backgroundColor;
  Color centerImageBackgroundColor;

  TabConfiguration(
      {this.textColor,
      this.backgroundColor,
      this.centerImageBackgroundColor,
      this.imageColor});

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
  String selectedImage;
  String code;
  int type;
  int sequence;
  Color color;
  bool isCenter = true;
  bool isSelected;
  VoidCallback onTap;
  Widget widget;

  BottomTabModel({
    this.title,
    this.image,
    this.selectedImage,
    this.code,
    this.sequence,
    this.isCenter,
    this.type,
    this.color,
    this.isSelected = false,
    this.onTap,
    this.widget,
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

  static List<BottomTabModel> getFilterScreenBottomTabs(
      {bool isForEditSavedSearch = false}) {
    List<BottomTabModel> arrBootomTab = List<BottomTabModel>();
    arrBootomTab.add(
      BottomTabModel(
        title: R.string.screenTitle.upcoming,
        image: upcoming,
        code: BottomCodeConstant.filterSearchUpcoming,
        sequence: 0,
        isCenter: false,
        color: Colors.white,
      ),
    );
    arrBootomTab.add(
      BottomTabModel(
        title: R.string.screenTitle.newArrival,
        image: newArrival,
        code: BottomCodeConstant.filterSearchNewArrival,
        sequence: 1,
        isCenter: false,
        color: Colors.white,
      ),
    );
    // arrBootomTab.add(BottomTabModel(
    //     title: R.string.screenTitle.savedSearch,
    //     image: savedSearch,
    //     code: BottomCodeConstant.filterSavedSearch,
    //     sequence: 0,
    //     isCenter: false));

    arrBootomTab.add(BottomTabModel(
        title: "",
        image: search,
        code: BottomCodeConstant.filterSearch,
        sequence: 2,
        isCenter: true));
    arrBootomTab.add(BottomTabModel(
        title: isForEditSavedSearch
            ? R.string.screenTitle.updateAndSearch
            : R.string.screenTitle.savedAndSearch,
        image: saveAndSearch,
        code: BottomCodeConstant.filterSaveAndSearch,
        sequence: 3,
        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: R.string.screenTitle.addDemand,
        image: addDemand,
        code: BottomCodeConstant.filterAddDemamd,
        sequence: 1,
        isCenter: false));
//    arrBootomTab.add(BottomTabModel(
//        title: R.string.screenTitle.matchPair,
//        image: matchPair,
//        code: BottomCodeConstant.filteMatchPair,
//        sequence: 4,
//        isCenter: false));
    arrBootomTab.add(BottomTabModel(
        title: "Reset",
        image: reset,
        code: BottomCodeConstant.filterReset,
        sequence: 4,
        isCenter: false));
    return arrBootomTab;
  }
}
