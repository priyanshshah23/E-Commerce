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
  bool isAccountTerm = true;

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
    List<num> arrFinalValues =
        SyncManager.instance.getFinalCalculations(filterList);
    carat = arrValues[0];
    totalamt = arrValues[2];
    avgRapCrt = arrValues[3];
    avgPriceCrt = arrValues[4];
    termDiscAmount = arrValues[5];

    totalPriceCrt = PriceUtilities.getPrice(avgPriceCrt);
    totalAmount = PriceUtilities.getPrice(avgAmount);
    if (isAccountTerm) {
      print("Discount....$avgDisc");
      totalDisc = PriceUtilities.getPercent(arrFinalValues[2]);
      totalAmount = PriceUtilities.getPrice(arrFinalValues[1]);
      totalPriceCrt = PriceUtilities.getPrice(arrFinalValues[0]);
    } else {
      avgDisc = (1 - (avgPriceCrt / avgRapCrt)) * (-100);
      print("finalDiscount....$avgDisc");
      totalDisc = PriceUtilities.getPercent(avgDisc);
      avgAmount = arrValues[1];
    }
    totalCarat = PriceUtilities.getDoubleValue(carat);
    pcs = filterList.length.toString();
  }
}

class DiamondConfig {
  int moduleType;
  List<BottomTabModel> arrMoreMenu;
  List<BottomTabModel> arrBottomTab;
  List<BottomTabModel> arrStatusMenu;

  List<BottomTabModel> toolbarList = [];

  DiamondConfig(this.moduleType);

  initItems({bool isDetail = false}) {
    toolbarList = getToolbarItem(isDetail: isDetail);
    arrBottomTab = BottomMenuSetting().getBottomMenuItems(moduleType,isDetail: isDetail);
    arrMoreMenu = BottomMenuSetting().getMoreMenuItems(isDetail: isDetail);
    if (!isDetail) {
      arrStatusMenu = BottomMenuSetting().getStatusMenuItems();
    }
  }

  String getScreenTitle() {
    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_SEARCH:
        return R.string().screenTitle.searchDiamond;
      default:
        return R.string().screenTitle.searchDiamond;
    }
  }

  List<BottomTabModel> getToolbarItem({bool isDetail = false}) {
    List<BottomTabModel> list = [];
    if (isDetail) {

      list.add(BottomTabModel(
          title: "",
          image: selectAll,
          code: BottomCodeConstant.TBShare,
          sequence: 0,
          isCenter: true));
      list.add(BottomTabModel(
          title: "",
          image: clock,
          code: BottomCodeConstant.TBClock,
          sequence: 0,
          isCenter: true));
      list.add(BottomTabModel(
          title: "",
          image: download,
          code: BottomCodeConstant.TBDownloadView,
          sequence: 3,
          isCenter: true));

    } else {
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
    }
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
        actionPlaceOrder(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_COMMENT:
        actionComment(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_OFFER:
        actionOffer(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_APPOINTMENT:
        actionAppointment(context, list);
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
    callApiFoCreateTrack(context, list, DiamondTrackConstant.TRACK_TYPE_CART,
        title: "Added in Cart");
  }

  actionAddToEnquiry(BuildContext context, List<DiamondModel> list) {
    callApiFoCreateTrack(context, list, DiamondTrackConstant.TRACK_TYPE_ENQUIRY,
        title: "Added in Enquiry");
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
            isPop: true, title: "Added in Watchlist");
      }
    });
  }

  actionPlaceOrder(BuildContext context, List<DiamondModel> list) {
    showPlaceOrderDialog(context, (manageClick) {
      if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
        callApiFoPlaceOrder(context, list,
            isPop: true,
            remark: manageClick.remark,
            companyName: manageClick.companyName,
            date: manageClick.date);
      }
    });
  }

  actionComment(BuildContext context, List<DiamondModel> list) {
    showNotesDialog(context, (manageClick) {
      if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
        callApiFoCreateTrack(
            context, list, DiamondTrackConstant.TRACK_TYPE_COMMENT,
            isPop: true, remark: manageClick.remark);
      }
    });
  }

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

  actionAppointment(BuildContext context, List<DiamondModel> list) {
    showAppointmentDialog(context, (manageClick) {
      if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
        /*callApiFoCreateTrack(
            context, list, DiamondTrackConstant.TRACK_TYPE_APPOINTMENT,
            isPop: true);*/
      }
    });
  }

  actionHold(List<DiamondModel> list) {}

  actionDownload(List<DiamondModel> list) {}

  actionShare(List<DiamondModel> list) {}

  callApiFoCreateTrack(
      BuildContext context, List<DiamondModel> list, int trackType,
      {bool isPop = false, String remark, String companyName, String title}) {
    CreateDiamondTrackReq req = CreateDiamondTrackReq();
    req.trackType = trackType;
    switch (trackType) {
      case DiamondTrackConstant.TRACK_TYPE_OFFER:
        req.remarks = remark;
        req.company = companyName;
        break;
    }
    DateTime dateTimeNow = DateTime.now();
    req.diamonds = [];
    Diamonds diamonds;
    list.forEach((element) {
      diamonds = Diamonds(
          diamond: element.id,
          trackDiscount: element.back,
          newDiscount: num.parse(element.selectedBackPer),
          trackAmount: element.amt,
          trackPricePerCarat: element.ctPr);
      switch (trackType) {
        case DiamondTrackConstant.TRACK_TYPE_COMMENT:
          diamonds.remarks = remark;
          break;
        case DiamondTrackConstant.TRACK_TYPE_OFFER:
          diamonds.vStnId = element.vStnId;
          diamonds.newAmount = element.getFinalAmount();
          diamonds.newPricePerCarat = element.getFinalRate();
          dateTimeNow
              .add(Duration(hours: int.parse(element.selectedOfferHour)));
          diamonds.offerValidDate = dateTimeNow.toUtc().toIso8601String();
          break;
      }
      req.diamonds.add(diamonds);
    });
    SyncManager.instance.callApiForCreateDiamondTrack(
      context,
      req,
      (resp) {
        if (isPop) {
          Navigator.pop(context);
          if (trackType == DiamondTrackConstant.TRACK_TYPE_OFFER) {
            Navigator.pop(context);
          }
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

  callApiFoPlaceOrder(BuildContext context, List<DiamondModel> list,
      {bool isPop = false,
      String remark,
      String companyName,
      String title,
      String date}) {
    PlaceOrderReq req = PlaceOrderReq();
    req.company = companyName;
    req.comment = remark;
    req.date = date;
    req.diamonds = [];
    list.forEach((element) {
      req.diamonds.add(element.id);
    });
    SyncManager.instance.callApiForPlaceOrder(
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
