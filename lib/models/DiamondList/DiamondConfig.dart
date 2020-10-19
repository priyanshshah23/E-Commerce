import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondActionBottomSheet.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondTrack.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:flutter/cupertino.dart';

import '../../main.dart';

class DiamondCalculation {
  String totalCarat = "0";
  String totalDisc = "0";
  String totalPriceCrt = "0";
  String totalAmount = "0";
  String pcs = "0";
  bool isAccountTerm = false;

  setAverageCalculation(List<DiamondModel> arraDiamond) {
    double carat = 0.0;
    double avgDisc = 0.0;
    double avgRapCrt = 0.0;
    double avgPriceCrt = 0.0;
    double avgAmount = 0.0;
    double totalamt = 0.0;
    double termDiscAmount = 0.0;

    List<DiamondModel> filterList = [];
    Iterable<DiamondModel> list = arraDiamond.where((item) {
      return item.isSelected == true;
    });
    if (list == null || list.length == 0) {
      filterList = arraDiamond;
    } else {
      filterList = list.toList();
    }
    List<num> arrValues =
        SyncManager.instance.getTotalCaratAvgRapAmount(filterList);
    carat = arrValues[0];
    totalamt = arrValues[2];
    avgRapCrt = arrValues[3];
    avgPriceCrt = arrValues[4];
    termDiscAmount = arrValues[5];
    avgAmount = arrValues[2];
    totalPriceCrt = PriceUtilities.getPrice(avgPriceCrt);
    totalAmount = PriceUtilities.getPrice(avgAmount);
    if (isAccountTerm) {
      avgDisc = arrValues[6];
      print("Discount....$avgDisc");
      totalDisc = PriceUtilities.getPercent(avgDisc);
    } else {
      avgDisc = (1 - (avgPriceCrt / avgRapCrt)) * (-100);
      print("finalDiscount....$avgDisc");
      totalDisc = PriceUtilities.getPercent(avgDisc);
    }
    totalCarat = PriceUtilities.getDoubleValue(carat);
    pcs = filterList.length.toString();
  }
}

class DiamondConfig {
  int moduleType;
  List<BottomTabModel> arrMoreMenu;
  List<BottomTabModel> arrBottomTab;

  List<BottomTabModel> toolbarList = [];

  DiamondConfig(this.moduleType);

  initItems() {
    toolbarList = getToolbarItem();
    arrMoreMenu = BottomMenuSetting().getMoreMenuItems();
    arrBottomTab = BottomMenuSetting().getBottomMenuItems();
  }

  String getScreenTitle() {
    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_SEARCH:
        return R.string().screenTitle.searchDiamond;
      default:
        return R.string().screenTitle.searchDiamond;
    }
  }

  List<BottomTabModel> getToolbarItem() {
    List<BottomTabModel> list = [];
    list.add(BottomTabModel(
        title: "",
        image: selectAll,
        code: BottomCodeConstant.TBSelectAll,
        sequence: 0,
        isCenter: true));
    list.add(BottomTabModel(
        title: "",
        image: gridView,
        code: BottomCodeConstant.TBGrideView,
        sequence: 1,
        isCenter: true));
    list.add(BottomTabModel(
        title: "",
        image: filter,
        code: BottomCodeConstant.TBSortView,
        sequence: 2,
        isCenter: true));
    list.add(BottomTabModel(
        title: "",
        image: download,
        code: BottomCodeConstant.TBDownloadView,
        sequence: 3,
        isCenter: true));
    return list;
  }

  manageDiamondAction(BuildContext context, List<DiamondModel> list,
      BottomTabModel bottomTabModel) {
    switch (bottomTabModel.type) {
      case ActionMenuConstant.ACTION_TYPE_ADD_TO_CART:
        actionAddToCart(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_ENQUIRY:
        actionAddToEnquiry(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_WISHLIST:
        actionAddToWishList(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_PLACE_ORDER:
        actionPlaceOrder(list);
        break;
      case ActionMenuConstant.ACTION_TYPE_COMMENT:
        actionComment(list);
        break;
      case ActionMenuConstant.ACTION_TYPE_OFFER:
        actionOffer(context,list);
        break;
      case ActionMenuConstant.ACTION_TYPE_OFFER_VIEW:
        actionOfferView(list);
        break;
      case ActionMenuConstant.ACTION_TYPE_HOLD:
        actionHold(list);
        break;
      case ActionMenuConstant.ACTION_TYPE_DOWNLOAD:
        actionDownload(list);
        break;
      case ActionMenuConstant.ACTION_TYPE_SHARE:
        actionShare(list);
        break;
    }
  }

  actionAddToCart(BuildContext context, List<DiamondModel> list) {
    callApiFoCreateTrack(context, list, DiamondTrackConstant.TRACK_TYPE_CART,title: "Added in Cart");
  }

  actionAddToEnquiry(BuildContext context, List<DiamondModel> list) {
    callApiFoCreateTrack(
        context, list, DiamondTrackConstant.TRACK_TYPE_ENQUIRY,title:"Added in Enquiry");
  }

  actionAddToWishList(BuildContext context, List<DiamondModel> list) {
    List<DiamondModel> selectedList = [];
    DiamondModel model;
    list.forEach((element) {
      model = DiamondModel.fromJson(element.toJson());
      model.isAddToWatchList = true;
      selectedList.add(model);
    });
    showWatchListDialog(context, selectedList, (manageClick) {
      if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
        callApiFoCreateTrack(
            context, list, DiamondTrackConstant.TRACK_TYPE_WATCH_LIST,
            isPop: true,title: "Added in Watchlist");
      }
    });
  }

  actionPlaceOrder(List<DiamondModel> list) {}

  actionComment(List<DiamondModel> list) {}

  actionOffer(BuildContext context, List<DiamondModel> list) {
    List<DiamondModel> selectedList = [];
    DiamondModel model;
    list.forEach((element) {
      model = DiamondModel.fromJson(element.toJson());
      model.isAddToOffer = true;
      selectedList.add(model);
    });
    showOfferListDialog(context, selectedList, (manageClick) {
      if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
        callApiFoCreateTrack(
            context, list, DiamondTrackConstant.TRACK_TYPE_OFFER,
            isPop: true);
      }
    });
  }

  actionOfferView(List<DiamondModel> list) {}

  actionHold(List<DiamondModel> list) {}

  actionDownload(List<DiamondModel> list) {}

  actionShare(List<DiamondModel> list) {}

  callApiFoCreateTrack(
      BuildContext context, List<DiamondModel> list, int trackType,
      {bool isPop = false, String title}) {
    CreateDiamondTrackReq req = CreateDiamondTrackReq();
    req.trackType = trackType;
    req.diamonds = [];
    list.forEach((element) {
      req.diamonds.add(Diamonds(
          diamond: element.id,
          trackDiscount: element.back,
          newDiscount: element.selectedBackPer,
          trackAmount: element.amt,
          trackPricePerCarat: element.ctPr));
    });
    SyncManager.instance.callApiForCreateDiamondTrack(
      context,
      req,
      (resp) {
        if (isPop) {
          Navigator.pop(context);
        }
        app.resolve<CustomDialogs>().errorDialog(
              context,
              title,
              resp.message,
              btntitle: R.string().commonString.ok,
            );
      },
      (onError) {
        if (onError.message != null) {
          app.resolve<CustomDialogs>().errorDialog(
                context,
                "",
                onError.message,
                btntitle: R.string().commonString.ok,
              );
        }
      },
    );
  }
}
