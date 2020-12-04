import 'dart:collection';

import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomBorder.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/app/utils/price_utility.dart';
import 'package:diamnow/components/Screens/Auth/Widget/DialogueList.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondActionBottomSheet.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondActionScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondCompareScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Filter/Widget/DownLoadAndShareDialogue.dart';
import 'package:diamnow/components/Screens/More/OfferViewScreen.dart';
import 'package:diamnow/components/widgets/shared/CommonDateTimePicker.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/DiamondList/DiamondTrack.dart';
import 'package:diamnow/models/DiamondList/download.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../main.dart';

class DiamondCalculation {
  String totalCarat = "0";
  String totalDisc = "0";
  String totalPriceCrt = "0";
  String totalAmount = "0";
  String pcs = "0";
  bool isAccountTerm = false;

  setAverageCalculation(List<DiamondModel> arraDiamond,
      {bool isFinalCalculation = false}) {
    isAccountTerm = isFinalCalculation;
    double carat = 0.0;
    double avgDisc = 0.0;
    double avgRapCrt = 0.0;
    double avgPriceCrt = 0.0;
    double avgAmount = 0.0;
    double totalamt = 0.0;

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

    totalPriceCrt = PriceUtilities.getPrice(avgPriceCrt ?? 0);
    if (isAccountTerm) {
      totalDisc = PriceUtilities.getPercent(arrFinalValues[2] ?? 0);
      totalAmount = PriceUtilities.getPrice(arrFinalValues[1] ?? 0);
      totalPriceCrt = PriceUtilities.getPrice(arrFinalValues[0] ?? 0);
    } else {
      avgDisc = (1 - (avgPriceCrt / avgRapCrt)) * (-100);
      totalDisc = PriceUtilities.getPercent(avgDisc ?? 0);
      avgAmount = arrValues[1];
      totalAmount = PriceUtilities.getPrice(avgAmount ?? 0);
    }

    totalCarat = PriceUtilities.getDoubleValue(carat ?? 0);
    pcs = filterList.length.toString();
  }
}

class DiamondConfig {
  int moduleType;
  bool isCompare = false;
  List<BottomTabModel> arrMoreMenu;
  List<BottomTabModel> arrBottomTab;
  List<BottomTabModel> arrStatusMenu;
  BottomMenuSetting bottomMenuSetting;
  List<BottomTabModel> toolbarList = [];
  TrackBlockData trackBlockData;

  DiamondConfig(this.moduleType, {this.isCompare = false});

  initItems({bool isDetail = false}) {
    bottomMenuSetting = BottomMenuSetting(moduleType);
    toolbarList = getToolbarItem(isDetail: isDetail);
    arrBottomTab = bottomMenuSetting.getBottomMenuItems(moduleType,
        isDetail: isDetail, isCompare: isCompare);
    arrMoreMenu = bottomMenuSetting.getMoreMenuItems(
        isDetail: isDetail, isCompare: isCompare);
    if (!isDetail) {
      arrStatusMenu = bottomMenuSetting.getStatusMenuItems();
    }
  }

  String getScreenTitle() {
    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_MY_CART:
        return R.string().screenTitle.myCart;
      case DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST:
        return R.string().screenTitle.myWatchlist;
      case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
        return R.string().screenTitle.myOffer;
      case DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY:
        return R.string().screenTitle.myEnquiry;
      case DiamondModuleConstant.MODULE_TYPE_MY_REMINDER:
        return R.string().screenTitle.myReminder;
      case DiamondModuleConstant.MODULE_TYPE_MY_BID:
        return R.string().screenTitle.myBid;
      case DiamondModuleConstant.MODULE_TYPE_MY_HOLD:
        return R.string().screenTitle.myHold;
      case DiamondModuleConstant.MODULE_TYPE_MY_ORDER:
        return R.string().screenTitle.myOrder;
      case DiamondModuleConstant.MODULE_TYPE_MY_OFFICE:
        return R.string().screenTitle.myOffice;
      case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
        return R.string().screenTitle.myOffer;
      case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
        return R.string().screenTitle.myComment;
      case DiamondModuleConstant.MODULE_TYPE_MY_PURCHASE:
        return R.string().screenTitle.myPurchased;
      case DiamondModuleConstant.MODULE_TYPE_HOME:
        return R.string().screenTitle.home;
      case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
        return R.string().screenTitle.diamondOnAuction;
      case DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL:
        return R.string().screenTitle.newArrival;
      case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND:
        return R.string().screenTitle.exclusiveDiamonds;
      case DiamondModuleConstant.MODULE_TYPE_UPCOMING:
        return R.string().screenTitle.upcoming;
      case DiamondModuleConstant.MODULE_TYPE_PROFILE:
        return R.string().screenTitle.myProfile;
      case DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY:
        return R.string().screenTitle.stoneOfDay;
      default:
        return R.string().screenTitle.searchDiamond;
    }
  }

  String getActionScreenTitle(int actionType) {
    switch (actionType) {
      case DiamondTrackConstant.TRACK_TYPE_WATCH_LIST:
        return R.string().screenTitle.addToWatchList;
      case DiamondTrackConstant.TRACK_TYPE_CART:
        return R.string().screenTitle.addToCart;
      case DiamondTrackConstant.TRACK_TYPE_OFFER:
        return R.string().screenTitle.placeAnOffer;
      case DiamondTrackConstant.TRACK_TYPE_BID:
        return R.string().screenTitle.bidStone;
      case DiamondTrackConstant.TRACK_TYPE_PLACE_ORDER:
        return R.string().screenTitle.confirmStone;
      case DiamondTrackConstant.TRACK_TYPE_FINAL_CALCULATION:
        return R.string().screenTitle.finalCalculation;
      case DiamondTrackConstant.TRACK_TYPE_OFFICE:
        return R.string().screenTitle.bookOffice;
      default:
        return R.string().screenTitle.addToWatchList;
    }
  }

  Future<DiamondListResp> getApiCall(
      int moduleType, Map<String, dynamic> dict) {
    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_SEARCH:
      case DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL:
      case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND:
      case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
      case DiamondModuleConstant.MODULE_TYPE_UPCOMING:
      case DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH:
      case DiamondModuleConstant.MODULE_TYPE_MY_DEMAND:
      case DiamondModuleConstant.MODULE_TYPE_RECENT_SEARCH:
      case DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH:
        return app
            .resolve<ServiceModule>()
            .networkService()
            .diamondListPaginate(dict);

      case DiamondModuleConstant.MODULE_TYPE_MY_CART:
      case DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST:
      case DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY:
      case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
      case DiamondModuleConstant.MODULE_TYPE_MY_REMINDER:
        return app
            .resolve<ServiceModule>()
            .networkService()
            .diamondTrackList(dict);
      case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
        return app
            .resolve<ServiceModule>()
            .networkService()
            .diamondCommentList(dict);
      case DiamondModuleConstant.MODULE_TYPE_MY_BID:
        return app
            .resolve<ServiceModule>()
            .networkService()
            .diamondBidList(dict);
      case DiamondModuleConstant.MODULE_TYPE_MATCH_PAIR:
        return app
            .resolve<ServiceModule>()
            .networkService()
            .diamondMatchPairList(dict);
      case DiamondModuleConstant.MODULE_TYPE_MY_OFFICE:
        return app
            .resolve<ServiceModule>()
            .networkService()
            .diamondOfficeList(dict);

      case DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY:
        return app
            .resolve<ServiceModule>()
            .networkService()
            .stoneOfTheDay(dict);
    }
  }

  List<BottomTabModel> getToolbarItem({bool isDetail = false}) {
    List<BottomTabModel> list = [];

    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_HOME:
        if (app
            .resolve<PrefUtils>()
            .getModulePermission(
                ModulePermissionConstant.permission_notification)
            .view)
          list.add(BottomTabModel(
              title: "",
              image: notification,
              code: BottomCodeConstant.TBNotification,
              sequence: 1,
              isCenter: true));
        list.add(BottomTabModel(
            title: "",
            image: userTemp,
            code: BottomCodeConstant.TBProfile,
            sequence: 2,
            isCenter: true));

        break;

      default:
        if (isCompare) {
          list.add(BottomTabModel(
              title: "",
              image: download,
              code: BottomCodeConstant.TBDownloadView,
              sequence: 3,
              isCenter: true));
        } else if (isDetail) {
          list.add(BottomTabModel(
              title: "",
              image: share,
              code: BottomCodeConstant.TBShare,
              sequence: 0,
              isCenter: true));
          // list.add(BottomTabModel(
          //     title: "",
          //     image: clock,
          //     code: BottomCodeConstant.TBClock,
          //     sequence: 0,
          //     isCenter: true));
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
              selectedImage: selectList,
              code: BottomCodeConstant.TBSelectAll,
              sequence: 0,
              isCenter: true));
          if (moduleType != DiamondModuleConstant.MODULE_TYPE_MATCH_PAIR &&
              moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFER &&
              moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFICE) {
            list.add(BottomTabModel(
                title: "",
                image: gridView,
                code: BottomCodeConstant.TBGrideView,
                sequence: 1,
                isCenter: true));
          }
          if (moduleType != DiamondModuleConstant.MODULE_TYPE_UPCOMING) {
            list.add(BottomTabModel(
                title: "",
                image: filter,
                code: BottomCodeConstant.TBSortView,
                sequence: 2,
                isCenter: true));
          }
          list.add(BottomTabModel(
              title: "",
              image: download,
              code: BottomCodeConstant.TBDownloadView,
              sequence: 3,
              isCenter: true));
        }
        break;
    }

    return list;
  }

  manageDiamondAction(BuildContext context, List<DiamondModel> list,
      BottomTabModel bottomTabModel, Function refreshList,
      {int moduleType}) async {
    switch (bottomTabModel.type) {
      case ActionMenuConstant.ACTION_TYPE_FINAL_CALCULATION:
        actionForFinalCalculation(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_DELETE:
        actionDelete(context, list, moduleType, refreshList);
        break;
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
        actionPlaceOrder(context, list, refreshList);
        break;
      case ActionMenuConstant.ACTION_TYPE_REMINDER:
        actionReminder(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_COMMENT:
        actionComment(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_OFFER:
        actionOffer(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_BID:
        actionBid(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_APPOINTMENT:
        actionAppointment(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_HOLD:
        actionHold(list);
        break;
      case ActionMenuConstant.ACTION_TYPE_DOWNLOAD:
        actionDownload(context, list);
        break;
      case ActionMenuConstant.ACTION_TYPE_SHARE:
        actionDownload(context, list, isForShare: true);
        break;
      case ActionMenuConstant.ACTION_TYPE_COMPARE:
        if (list.length < 2) {
          app.resolve<CustomDialogs>().confirmDialog(
                context,
                title: "",
                desc: R.string().commonString.enter2Stone,
                positiveBtnTitle: R.string().commonString.ok,
              );
          return;
        }
        var dict = Map<String, dynamic>();
        dict[ArgumentConstant.DiamondList] = list;
        dict[ArgumentConstant.ModuleType] = moduleType;
        // NavigationUtilities.pushRoute(DiamondCompareScreen.route, args: dict);
        bool isBack = await Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: DiamondCompareScreen.route),
          builder: (context) => DiamondCompareScreen(dict),
        ));
        if (isBack != null && isBack) {
          refreshList();
        }
        break;
    }
  }

  actionAddToCart(BuildContext context, List<DiamondModel> list) {
    callApiFoCreateTrack(context, list, DiamondTrackConstant.TRACK_TYPE_CART,
        isPop: false, title: R.string().screenTitle.addedInCart);
    // List<DiamondModel> selectedList = [];
    // DiamondModel model;
    // list.forEach((element) {
    //   model = DiamondModel.fromJson(element.toJson());
    //   selectedList.add(model);
    // });

    // openDiamondActionAcreen(
    //     context, DiamondTrackConstant.TRACK_TYPE_CART, selectedList);
  }

  actionForFinalCalculation(BuildContext context, List<DiamondModel> list) {
    List<DiamondModel> selectedList = [];
    DiamondModel model;
    list.forEach((element) {
      model = DiamondModel.fromJson(element.toJson());
      model.isFinalCalculation = true;
      selectedList.add(model);
    });
    openDiamondActionAcreen(context,
        DiamondTrackConstant.TRACK_TYPE_FINAL_CALCULATION, selectedList);
  }

  actionDelete(BuildContext context, List<DiamondModel> list, int moduleType,
      Function refreshList) {
    app.resolve<CustomDialogs>().confirmDialog(context,
        title: "",
        desc: R.string().errorString.deleteStoneMsg,
        positiveBtnTitle: R.string().commonString.yes,
        negativeBtnTitle: R.string().commonString.no,
        onClickCallback: (PositveButtonClick) {
      if (PositveButtonClick == ButtonType.PositveButtonClick) {
        callApiForDeleteTrack(context, list, moduleType, refreshList);
      }
    });
  }

  actionAddToEnquiry(BuildContext context, List<DiamondModel> list) {
    showEnquiryDialog(context, (manageClick) {
      if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
        callApiFoCreateTrack(
            context, list, DiamondTrackConstant.TRACK_TYPE_ENQUIRY,
            isPop: true, remark: manageClick.remark, title: "Added in Enquiry");
      }
    });
  }

  actionAddToWishList(BuildContext context, List<DiamondModel> list) {
    // List<DiamondModel> selectedList = [];
    // DiamondModel model;
    // list.forEach((element) {
    //   model = DiamondModel.fromJson(element.toJson());
    //   model.isAddToWatchList = true;
    //   selectedList.add(model);
    // });
    // openDiamondActionAcreen(
    //     context, DiamondTrackConstant.TRACK_TYPE_WATCH_LIST, selectedList);
    // if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
    callApiFoCreateTrack(
        context, list, DiamondTrackConstant.TRACK_TYPE_WATCH_LIST,
        isPop: false, title: "Added in Watchlist");
    // }
    /*showWatchListDialog(context, selectedList, (manageClick) {
      if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
        callApiFoCreateTrack(
            context, list, DiamondTrackConstant.TRACK_TYPE_WATCH_LIST,
            isPop: true, title: "Added in Watchlist");
      }
    });*/
  }

  openDiamondActionAcreen(
      BuildContext context, int actionType, List<DiamondModel> list,
      {Function placeOrder}) async {
    var dict = Map<String, dynamic>();
    dict[ArgumentConstant.DiamondList] = list;
    dict[ArgumentConstant.ModuleType] = moduleType;
    dict[ArgumentConstant.ActionType] = actionType;
    bool isBack = await Navigator.of(context).push(MaterialPageRoute(
      settings: RouteSettings(name: DiamondActionScreen.route),
      builder: (context) => DiamondActionScreen(dict),
    ));
    if (isBack != null && isBack && placeOrder != null) {
      placeOrder();
    }
  }

  actionPlaceOrder(
      BuildContext context, List<DiamondModel> list, Function placeOrder) {
    List<DiamondModel> selectedList = [];
    DiamondModel model;
    list.forEach((element) {
      model = DiamondModel.fromJson(element.toJson());
      selectedList.add(model);
    });

    openDiamondActionAcreen(
        context, DiamondTrackConstant.TRACK_TYPE_PLACE_ORDER, selectedList,
        placeOrder: placeOrder);
    /*showPlaceOrderDialog(context, (manageClick) {
      if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
        callApiFoPlaceOrder(context, list, placeOrder,
            isPop: true,
            remark: manageClick.remark,
            companyName: manageClick.companyName,
            date: manageClick.date);
      }
    });*/
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

    openDiamondActionAcreen(
        context, DiamondTrackConstant.TRACK_TYPE_OFFER, selectedList);
    /* showOfferListDialog(context, selectedList, (manageClick) {
      if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
        callApiFoCreateTrack(
            context, list, DiamondTrackConstant.TRACK_TYPE_OFFER,
            remark: manageClick.remark,
            companyName: manageClick.companyName,
            isPop: true);
      }
    });*/
  }

  actionAll(BuildContext context, List<DiamondModel> list, int trackType,
      {String remark, String companyName, String date}) {
    switch (trackType) {
      case DiamondTrackConstant.TRACK_TYPE_WATCH_LIST:
        callApiFoCreateTrack(
            context, list, DiamondTrackConstant.TRACK_TYPE_WATCH_LIST,
            isPop: true, title: R.string().screenTitle.addedInWatchList);
        break;
      case DiamondTrackConstant.TRACK_TYPE_CART:
        callApiFoCreateTrack(
            context, list, DiamondTrackConstant.TRACK_TYPE_CART,
            isPop: true, title: R.string().screenTitle.addedInCart);
        break;
      case DiamondTrackConstant.TRACK_TYPE_OFFER:
        callApiFoCreateTrack(
            context, list, DiamondTrackConstant.TRACK_TYPE_OFFER,
            remark: remark,
            isPop: true,
            date: date,
            title: R.string().screenTitle.addedInOffer);
        break;
      case DiamondTrackConstant.TRACK_TYPE_BID:
        callApiFoCreateTrack(context, list, DiamondTrackConstant.TRACK_TYPE_BID,
            isPop: true, title: R.string().screenTitle.addedInBid);
        break;
      case DiamondTrackConstant.TRACK_TYPE_PLACE_ORDER:
        callApiFoPlaceOrder(context, list, () {
          Navigator.pop(context, true);
        }, isPop: true, remark: remark, companyName: companyName, date: date);
        break;
    }
  }

  actionBid(BuildContext context, List<DiamondModel> list) {
    List<DiamondModel> selectedList = [];
    DiamondModel model;
    list.forEach((element) {
      model = DiamondModel.fromJson(element.toJson());
      model.isAddToBid = true;
      selectedList.add(model);
    });
    app.resolve<CustomDialogs>().confirmDialog(context,
        title: R.string().screenTitle.declaimer,
        desc: R.string().commonString.packetNo +
            list.map((item) => item.vStnId).toList().join(', ') +
            R.string().commonString.bidDesc,
        negativeBtnTitle: R.string().commonString.quit,
        positiveBtnTitle: R.string().commonString.agree,
        onClickCallback: (buttonType) {
      if (buttonType == ButtonType.PositveButtonClick) {
        openDiamondActionAcreen(
            context, DiamondTrackConstant.TRACK_TYPE_BID, selectedList);
        /*showBidListDialog(context, selectedList, (manageClick) {
          if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
            callApiFoCreateTrack(
                context, selectedList, DiamondTrackConstant.TRACK_TYPE_BID,
                isPop: true);
          }
        });*/
      }
    });
  }

  actionAppointment(BuildContext context, List<DiamondModel> list) {
    List<DiamondModel> selectedList = [];
    DiamondModel model;
    list.forEach((element) {
      model = DiamondModel.fromJson(element.toJson());
      model.isAddAppointment = true;
      selectedList.add(model);
    });

    openDiamondActionAcreen(
        context, DiamondTrackConstant.TRACK_TYPE_OFFICE, selectedList);
    /* showOfferListDialog(context, selectedList, (manageClick) {
      if (manageClick.type == clickConstant.CLICK_TYPE_CONFIRM) {
        callApiFoCreateTrack(
            context, list, DiamondTrackConstant.TRACK_TYPE_OFFER,
            remark: manageClick.remark,
            companyName: manageClick.companyName,
            isPop: true);
      }
    });*/
  }

  actionHold(List<DiamondModel> list) {}

  actionDownload(
    BuildContext context,
    List<DiamondModel> list, {
    bool isForShare = false,
  }) {
    List<SelectionPopupModel> downloadOptionList = List<SelectionPopupModel>();
    List<SelectionPopupModel> selectedOptions = List<SelectionPopupModel>();
    downloadOptionList.add(SelectionPopupModel("1", "Excel",
        fileType: DownloadAndShareDialogueConstant.excel));
    downloadOptionList.add(SelectionPopupModel("2", "Certificate",
        fileType: DownloadAndShareDialogueConstant.certificate));
    downloadOptionList.add(SelectionPopupModel("3", "Real Image",
        fileType: DownloadAndShareDialogueConstant.realImage1));
    // downloadOptionList.add(SelectionPopupModel("4", "Plotting Image",
    //     fileType: DownloadAndShareDialogueConstant.plottingImg));
    downloadOptionList.add(SelectionPopupModel("4", "Heart Image",
        fileType: DownloadAndShareDialogueConstant.heartAndArrowImg));
    downloadOptionList.add(SelectionPopupModel("5", "Arrow Image",
        fileType: DownloadAndShareDialogueConstant.arrowImg));
    downloadOptionList.add(SelectionPopupModel("6", "Asset Scope",
        fileType: DownloadAndShareDialogueConstant.assetScopeImg));
    downloadOptionList.add(SelectionPopupModel("7", "Video",
        fileType: DownloadAndShareDialogueConstant.video1));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: getSize(20), vertical: getSize(5)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(getSize(25)),
            ),
            child: SelectionDialogue(
              isSearchEnable: false,
              title: isForShare
                  ? R.string().commonString.share
                  : R.string().commonString.download,
              isMultiSelectionEnable: true,
              positiveButtonTitle: isForShare
                  ? R.string().commonString.share
                  : R.string().commonString.download,
              selectionOptions: downloadOptionList,
              applyFilterCallBack: (
                  {SelectionPopupModel selectedItem,
                  List<SelectionPopupModel> multiSelectedItem}) {
                selectedOptions = multiSelectedItem;
                // Navigator.pop(context);
                //check condition for only excel,if so then redirect to static page
                //else show showDialog method.
                if (isForShare) {
                  _onShare(context, list, isForShare, selectedOptions);
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return WillPopScope(
                          onWillPop: () {
                            return Future.value(false);
                          },
                          child: Dialog(
                            insetPadding: EdgeInsets.symmetric(
                                horizontal: getSize(20), vertical: getSize(20)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(getSize(25)),
                            ),
                            child: Download(
                              allDiamondPreviewThings: selectedOptions,
                              diamondList: list,
                            ),
                          ),
                        );
                      });
                }
              },
            ),
//          child: DownLoadAndShareDialogue(
//            title: R.string().commonString.download,
//          ),
          ),
        );
      },
    );
  }

  _onShare(BuildContext context, List<DiamondModel> list, bool isForShare,
      List<SelectionPopupModel> selectedOptions) async {
    List<String> links = List<String>();

    for (int i = 0; i < list.length; i++) {
      DiamondModel model = list[i];
      String diamondDetailUrl = baseURL + "diamond-detail" + model.id;
      links.add(diamondDetailUrl);


      // selectedOptions.forEach((element) {
      //   if (element.fileType == DownloadAndShareDialogueConstant.realImage1 &&
      //       element.isSelected) {
      //     element.url = DiamondUrls.image + model.vStnId + "/" + "still.jpg";
      //   } else if (element.fileType ==
      //           DownloadAndShareDialogueConstant.arrowImg &&
      //       element.isSelected) {
      //     element.url =
      //         DiamondUrls.arroImage + model.vStnId + "/" + "Arrow_Black_BG.jpg";
      //   } else if (element.fileType ==
      //           DownloadAndShareDialogueConstant.assetScopeImg &&
      //       element.isSelected) {
      //     element.url = DiamondUrls.image +
      //         model.vStnId +
      //         "/" +
      //         "Office_Light_Black_BG.jpg";
      //   } else if (element.fileType ==
      //           DownloadAndShareDialogueConstant.heartAndArrowImg &&
      //       element.isSelected) {
      //     element.url = DiamondUrls.heartImage +
      //         model.vStnId +
      //         "/" +
      //         "Heart_Black_BG.jpg";
      //   } else if (element.fileType ==
      //           DownloadAndShareDialogueConstant.video1 &&
      //       element.isSelected) {
      //     element.url =
      //         DiamondUrls.video + model.vStnId + "/" + model.vStnId + ".html";
      //   } else if (element.fileType ==
      //           DownloadAndShareDialogueConstant.certificate &&
      //       element.isSelected) {
      //     element.url = DiamondUrls.certificate + model.rptNo + ".pdf";
      //   }
      // });

      // selectedOptions.forEach((element) {
      //   if (element.isSelected &&
      //       element.fileType != DownloadAndShareDialogueConstant.excel) {
      //     links.add(element.url);
      //   }
      // });
    }

    var filter = selectedOptions
        .where((element) =>
            element.fileType == DownloadAndShareDialogueConstant.excel &&
            element.isSelected == true)
        .toList();
    if (isNullEmptyOrFalse(filter)) {
      shareURls(links);
    } else {
      SyncManager syncManager = SyncManager();
      syncManager.callApiForExcel(context, list, isForShare: isForShare,
          callback: (url) async {
        links.add("\nExcelFile :- ");
        links.add(url);
        shareURls(links);
      });
    }
  }

  shareURls(
    List<String> links,
  ) async {
    List<String> urls = [];
    for (int i = 0; i < links.length; i++) {
      urls.add(links[i]);
    }

    String strUrlToShare = "Pn Shah\nDiamond Details\n\n" + urls.join("\n");

    if (!isNullEmptyOrFalse(strUrlToShare)) {
      await Share.share(
        "$APPNAME : $strUrlToShare",
        // subject: "DiamNow",
        // sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
    }
  }

  actionShare(BuildContext context, List<DiamondModel> list) {
//    _onShare(context, list);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: getSize(20), vertical: getSize(20)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getSize(25)),
          ),
          child: DownLoadAndShareDialogue(
            title: R.string().commonString.share,
            diamondList: list,
          ),
        );
      },
    );
//    openSharePopUp(context);
  }

  actionReminder(BuildContext context, List<DiamondModel> list) {
    openAddReminder(context, (manageClick) {
      callApiFoCreateTrack(
          context, list, DiamondTrackConstant.TRACK_TYPE_REMINDER,
          date: manageClick.date);
    });
  }

  callApiFoCreateTrack(
      BuildContext context, List<DiamondModel> list, int trackType,
      {bool isPop = false,
      String remark,
      String companyName,
      String date,
      String title}) {
    CreateDiamondTrackReq req = CreateDiamondTrackReq();
    switch (trackType) {
      case DiamondTrackConstant.TRACK_TYPE_OFFER:
        req.remarks = remark ?? "";
        req.trackType = trackType;
        break;
      case DiamondTrackConstant.TRACK_TYPE_CART:
      case DiamondTrackConstant.TRACK_TYPE_ENQUIRY:
      case DiamondTrackConstant.TRACK_TYPE_WATCH_LIST:
      case DiamondTrackConstant.TRACK_TYPE_REMINDER:
        req.trackType = trackType;
        break;
      case DiamondTrackConstant.TRACK_TYPE_BID:
        req.bidType = BidConstant.BID_TYPE_ADD;
        break;
    }
    req.diamonds = [];
    Diamonds diamonds;
    list.forEach((element) {
      diamonds = Diamonds(
          diamond: element.id,
          trackDiscount: element.back,
          trackAmount: element.amt,
          trackPricePerCarat: element.ctPr);
      switch (trackType) {
        // case DiamondTrackConstant.TRACK_TYPE_WATCH_LIST:
        //   diamonds.newDiscount = num.parse(element.selectedBackPer);
        //   break;
        case DiamondTrackConstant.TRACK_TYPE_COMMENT:
        case DiamondTrackConstant.TRACK_TYPE_ENQUIRY:
          diamonds.remarks = remark;
          break;
        case DiamondTrackConstant.TRACK_TYPE_OFFER:
          diamonds.vStnId = element.vStnId;
          diamonds.newDiscount = num.parse(element.offeredDiscount);
          diamonds.newAmount = element.offeredAmount;
          diamonds.newPricePerCarat = num.parse(element.offeredPricePerCarat);
          diamonds.offerValidDate = date;

          break;
        case DiamondTrackConstant.TRACK_TYPE_BID:
          diamonds.vStnId = element.vStnId;
          diamonds.bidAmount = element.getBidFinalAmount();
          diamonds.bidPricePerCarat = element.getBidFinalRate();
          diamonds.bidDiscount = element.getbidFinalDiscount();
          break;

        case DiamondTrackConstant.TRACK_TYPE_REMINDER:
          diamonds.reminderDate = date;
          break;
      }
      req.diamonds.add(diamonds);
    });
    SyncManager.instance.callApiForCreateDiamondTrack(
      context,
      trackType,
      req,
      (resp) {
        if (isPop) {
          Navigator.pop(context);
        }
        app.resolve<CustomDialogs>().confirmDialog(context,
            title: title,
            desc: resp.message,
            positiveBtnTitle: R.string().commonString.ok,
            negativeBtnTitle: getNegativeButtonTitle(trackType),
            onClickCallback: (type) {
          if (type == ButtonType.NagativeButtonClick) {
            openDiamondList(trackType);
          }
        });
      },
      (onError) {
        if (onError.message != null) {
          app.resolve<CustomDialogs>().confirmDialog(
                context,
                title: "",
                desc: onError.message,
                positiveBtnTitle: R.string().commonString.ok,
              );
        }
      },
    );
  }

  String getNegativeButtonTitle(int trackType) {
    switch (trackType) {
      case DiamondTrackConstant.TRACK_TYPE_WATCH_LIST:
        return R.string().commonString.goToMyWatchList;

      case DiamondTrackConstant.TRACK_TYPE_COMMENT:
        return R.string().commonString.gotToMyComments;
      case DiamondTrackConstant.TRACK_TYPE_ENQUIRY:
        return R.string().commonString.gotToMyEnquiry;
      case DiamondTrackConstant.TRACK_TYPE_OFFER:
        return R.string().commonString.gotToMyOffer;
      case DiamondTrackConstant.TRACK_TYPE_BID:
        return R.string().commonString.gotToMyBid;

      case DiamondTrackConstant.TRACK_TYPE_REMINDER:
        return R.string().commonString.gotToMyReminder;

      case DiamondTrackConstant.TRACK_TYPE_PLACE_ORDER:
        return R.string().commonString.goToMyOrder;
      default:
        return null;
    }
  }

  openDiamondList(int trackType) {
    Map<String, dynamic> dict = new HashMap();
    switch (trackType) {
      case DiamondTrackConstant.TRACK_TYPE_WATCH_LIST:
        dict[ArgumentConstant.ModuleType] =
            DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST;
        break;

      case DiamondTrackConstant.TRACK_TYPE_COMMENT:
        dict[ArgumentConstant.ModuleType] =
            DiamondModuleConstant.MODULE_TYPE_MY_COMMENT;
        break;

      case DiamondTrackConstant.TRACK_TYPE_ENQUIRY:
        dict[ArgumentConstant.ModuleType] =
            DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY;
        break;

      case DiamondTrackConstant.TRACK_TYPE_OFFER:
        dict[ArgumentConstant.ModuleType] =
            DiamondModuleConstant.MODULE_TYPE_MY_OFFER;
        break;

      case DiamondTrackConstant.TRACK_TYPE_BID:
        dict[ArgumentConstant.ModuleType] =
            DiamondModuleConstant.MODULE_TYPE_MY_BID;
        break;

      case DiamondTrackConstant.TRACK_TYPE_REMINDER:
        dict[ArgumentConstant.ModuleType] =
            DiamondModuleConstant.MODULE_TYPE_MY_REMINDER;
        break;

      case DiamondTrackConstant.TRACK_TYPE_PLACE_ORDER:
        dict[ArgumentConstant.ModuleType] =
            DiamondModuleConstant.MODULE_TYPE_MY_ORDER;
        break;

      default:
        dict[ArgumentConstant.ModuleType] =
            DiamondModuleConstant.MODULE_TYPE_SEARCH;
        break;
    }

    dict[ArgumentConstant.IsFromDrawer] = false;
    NavigationUtilities.pushRoute(DiamondListScreen.route, args: dict);
  }

  callApiForDeleteTrack(BuildContext context, List<DiamondModel> list,
      int moduleType, Function refreshList) {
    TrackDelReq req = TrackDelReq();
    int trackType;
    req.id = [];
    list.forEach((element) {
      switch (moduleType) {
        case DiamondModuleConstant.MODULE_TYPE_MY_CART:
          req.trackType = DiamondTrackConstant.TRACK_TYPE_CART;
          req.id.add(element.trackItemCart?.trackId ?? "");
          trackType = req.trackType;
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST:
          req.trackType = DiamondTrackConstant.TRACK_TYPE_WATCH_LIST;
          req.id.add(element.trackItemWatchList?.trackId ?? "");
          trackType = req.trackType;
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY:
          req.trackType = DiamondTrackConstant.TRACK_TYPE_ENQUIRY;
          req.id.add(element.trackItemEnquiry?.trackId ?? "");
          trackType = req.trackType;
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
          req.trackType = DiamondTrackConstant.TRACK_TYPE_OFFER;
          req.id.add(element.trackItemOffer?.trackId ?? "");
          trackType = req.trackType;
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_REMINDER:
          req.trackType = DiamondTrackConstant.TRACK_TYPE_REMINDER;
          req.id.add(element.trackItemReminder?.trackId ?? "");
          trackType = req.trackType;
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
          req.id.add(element.trackItemComment?.trackId ?? "");
          trackType = DiamondTrackConstant.TRACK_TYPE_COMMENT;
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_BID:
          req.id.add(element.trackItemBid?.trackId ?? "");
          trackType = DiamondTrackConstant.TRACK_TYPE_BID;
          break;
      }
    });
    SyncManager.instance.callApiForDeleteDiamondTrack(
      context,
      trackType,
      req,
      (resp) {
        app.resolve<CustomDialogs>().errorDialog(context, "", resp.message,
            btntitle: R.string().commonString.ok,
            dismissPopup: false, voidCallBack: () {
          Navigator.pop(context);
          refreshList();
        });
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

  callApiFoPlaceOrder(
      BuildContext context, List<DiamondModel> list, Function placeOrder,
      {bool isPop = false,
      String remark,
      String companyName,
      String title,
      String date}) {
    PlaceOrderReq req = PlaceOrderReq();
    req.company = companyName;
    req.comment = remark;
    switch (date) {
      case InvoiceTypesString.today:
        req.date = OrderInvoiceData.today.toString();
        break;
      case InvoiceTypesString.tomorrow:
        req.date = OrderInvoiceData.tommorow.toString();
        break;
      case InvoiceTypesString.later:
        req.date = OrderInvoiceData.later.toString();
        break;
    }

    req.diamonds = [];
    list.forEach((element) {
      req.diamonds.add(element.id);
    });
    SyncManager.instance.callApiForPlaceOrder(
      context,
      req,
      (resp) {
        app.resolve<CustomDialogs>().confirmDialog(context,
            barrierDismissible: true,
            title: "",
            desc: resp.message,
            positiveBtnTitle: R.string().commonString.ok,
            onClickCallback: (buttonType) {
          if (buttonType == ButtonType.PositveButtonClick) {
            placeOrder();
          }
        });
      },
      (onError) {
        if (onError.message != null) {
          app.resolve<CustomDialogs>().confirmDialog(
                context,
                barrierDismissible: true,
                title: "",
                desc: onError.message,
                positiveBtnTitle: R.string().commonString.ok,
              );
        }
      },
    );
  }

  callApiForBlock(BuildContext context, List<DiamondModel> list,
      Function(TrackBlockData) success,
      {bool isProgress = false}) {
    TrackDataReq req =
        TrackDataReq(blockType: [DiamondBlockType.HOLD, DiamondBlockType.MEMO]);
    SyncManager.instance.callApiForBlock(context, req, (resp) {
      trackBlockData = resp.data;
      setBlockDetail(resp.data, list, success);
    }, (onError) {}, isProgress: isProgress);
  }

  setBlockDetail(TrackBlockData trackBlockData, List<DiamondModel> list,
      Function(TrackBlockData) success) {
    for (int i = 0; i < list.length; i++) {
      trackBlockData.inTrackDiamonds.forEach((element) {
        element.diamonds.forEach((diamond) {
          if (list[i].id == diamond.id)
            switch (element.iId) {
              case DiamondTrackConstant.TRACK_TYPE_CART:
                list[i].trackItemCart = diamond;
                break;
              case DiamondTrackConstant.TRACK_TYPE_WATCH_LIST:
                list[i].trackItemWatchList = diamond;
                break;
              case DiamondTrackConstant.TRACK_TYPE_ENQUIRY:
                list[i].trackItemEnquiry = diamond;
                break;
              case DiamondTrackConstant.TRACK_TYPE_OFFER:
                list[i].trackItemOffer = diamond;
                break;
              case DiamondTrackConstant.TRACK_TYPE_REMINDER:
                list[i].trackItemReminder = diamond;
                break;
              case DiamondTrackConstant.TRACK_TYPE_COMMENT:
                list[i].trackItemComment = diamond;
                break;
              case DiamondTrackConstant.TRACK_TYPE_BID:
                list[i].trackItemBid = diamond;
                break;
            }
        });
      });
    }
    success(trackBlockData);
  }

  List<Map<String, dynamic>> getExclusiveDiamondReq() {
    List<Map<String, dynamic>> caratRequest = [];
    Map<String, dynamic> mainDic = Map<String, dynamic>();
    Map<String, dynamic> dict = Map<String, dynamic>();
    dict[">="] = "5.0";
    dict["<="] = "5.99";
    mainDic["crt"] = dict;
    caratRequest.add(mainDic);
    Map<String, dynamic> mainDic1 = Map<String, dynamic>();
    Map<String, dynamic> dict1 = Map<String, dynamic>();
    dict1[">="] = "6.0";
    dict1["<="] = "9.99";
    mainDic1["crt"] = dict1;
    caratRequest.add(mainDic1);
    Map<String, dynamic> mainDic2 = Map<String, dynamic>();
    Map<String, dynamic> dict2 = Map<String, dynamic>();
    dict2[">="] = "10.0";
    dict2["<="] = "19.99";
    mainDic2["crt"] = dict2;
    caratRequest.add(mainDic2);
    Map<String, dynamic> mainDic3 = Map<String, dynamic>();
    Map<String, dynamic> dict3 = Map<String, dynamic>();
    dict3[">="] = "20.0";
    dict3["<="] = "100";
    mainDic3["crt"] = dict3;
    caratRequest.add(mainDic3);
    return caratRequest;
  }

  void setMatchPairItem(List<DiamondModel> arraDiamond) {
    if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
      for (int i = 0; i < arraDiamond.length; i++) {
        if (i == 0 || (arraDiamond[i].memoNo != arraDiamond[i - 1].memoNo)) {
          arraDiamond[i].displayTitle = "#${arraDiamond[i].memoNo}";
          arraDiamond[i].displayDesc = DateUtilities()
              .convertServerDateToFormatterString(arraDiamond[i].createdAt,
                  formatter: DateUtilities.dd_mm_yyyy_hh_mm_ss);
          arraDiamond[i].showCheckBox = true;
        }

        if (arraDiamond.length == 1) {
          arraDiamond[i].isSectionOfferDisplay = true;
        } else if (i > 0 &&
            (arraDiamond[i].memoNo != arraDiamond[i - 1].memoNo)) {
          arraDiamond[i - 1].isSectionOfferDisplay = true;
        } else if (i == arraDiamond.length - 1) {
          arraDiamond[i].isSectionOfferDisplay = true;
        }
        arraDiamond[i].isGrouping = true;
      }
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFICE) {
      for (int i = 0; i < arraDiamond.length; i++) {
        if (i == 0 || (arraDiamond[i].memoNo != arraDiamond[i - 1].memoNo)) {
          arraDiamond[i].displayTitle = "#${arraDiamond[i].memoNo}";
          arraDiamond[i].displayDesc = DateUtilities()
              .convertServerDateToFormatterString(arraDiamond[i].createdAt,
                  formatter: DateUtilities.dd_mm_yyyy_hh_mm_ss);
          arraDiamond[i].showCheckBox = true;
        }

        if (arraDiamond.length == 1) {
          arraDiamond[i].isSectionOfferDisplay = true;
        } else if (i > 0 &&
            (arraDiamond[i].memoNo != arraDiamond[i - 1].memoNo)) {
          arraDiamond[i - 1].isSectionOfferDisplay = true;
        } else if (i == arraDiamond.length - 1) {
          arraDiamond[i].isSectionOfferDisplay = true;
        }
        arraDiamond[i].isGrouping = true;
      }
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_UPCOMING) {
      for (int i = 0; i < arraDiamond.length; i++) {
        if (i == 0 || (arraDiamond[i].inDt != arraDiamond[i - 1].inDt)) {
          arraDiamond[i].displayTitle = DateUtilities()
              .convertServerDateToFormatterString(arraDiamond[i].inDt,
                  formatter: DateUtilities.dd_mm_yyyy);
        }
      }
    } else if (moduleType == DiamondModuleConstant.MODULE_TYPE_MATCH_PAIR) {
      DiamondModel diamondItem;
      if (arraDiamond.length == 1) {
        diamondItem = arraDiamond[0];
        diamondItem.isMatchPair = true;
        diamondItem.borderType = BorderConstant.BORDER_NONE;
        diamondItem.marginTop = BorderConstant.BORDER_MARGIN;
        diamondItem.marginBottom = BorderConstant.BORDER_MARGIN;
      } else {
        for (int i = 0; i < arraDiamond.length; i++) {
          diamondItem = arraDiamond[i];
          diamondItem.isMatchPair = true;
          if (i == 0) {
            if (arraDiamond[i + 1].groupNo > diamondItem.groupNo) {
              diamondItem.borderType = BorderConstant.BORDER_NONE;
              diamondItem.marginTop = BorderConstant.BORDER_MARGIN;
              diamondItem.marginBottom = BorderConstant.BORDER_MARGIN;
            } else {
              diamondItem.borderType = BorderConstant.BORDER_TOP;
              diamondItem.marginTop = BorderConstant.BORDER_MARGIN;
            }
          } else if (i == arraDiamond.length - 1) {
            if (arraDiamond[i - 1].groupNo < diamondItem.groupNo) {
              diamondItem.borderType = BorderConstant.BORDER_NONE;
              diamondItem.marginTop = BorderConstant.BORDER_MARGIN;
              diamondItem.marginBottom = BorderConstant.BORDER_MARGIN;
            } else {
              diamondItem.borderType = BorderConstant.BORDER_BOTTOM;
              diamondItem.marginBottom = BorderConstant.BORDER_MARGIN;
            }
          } else {
            if (arraDiamond[i - 1].groupNo < diamondItem.groupNo &&
                arraDiamond[i + 1].groupNo > diamondItem.groupNo) {
              diamondItem.borderType = BorderConstant.BORDER_NONE;
              diamondItem.marginTop = BorderConstant.BORDER_MARGIN;
              diamondItem.marginBottom = BorderConstant.BORDER_MARGIN;
            } else if (arraDiamond[i - 1].groupNo < diamondItem.groupNo) {
              diamondItem.borderType = BorderConstant.BORDER_TOP;
              diamondItem.marginTop = BorderConstant.BORDER_MARGIN;
            } else if (arraDiamond[i + 1].groupNo > diamondItem.groupNo) {
              diamondItem.borderType = BorderConstant.BORDER_BOTTOM;
              diamondItem.marginBottom = BorderConstant.BORDER_MARGIN;
            } else {
              diamondItem.borderType = BorderConstant.BORDER_LEFT_RIGHT;
            }
          }
        }
      }
    }
  }

  getLinks(List<String> link) {
    link.forEach((element) {
      return element.split(",");
    });
  }
}

RoundedBorderPainter getPaintingType(BuildContext context, int type) {
  switch (type) {
    case BorderConstant.BORDER_TOP:
      return RoundedBorderPainter(
        topRadius: 6,
        bottomRadius: 0,
        strokeWidth: 1,
        bottomBorderColor: Colors.transparent,
        leftBorderColor: appTheme.colorPrimary,
        rightBorderColor: appTheme.colorPrimary,
        topBorderColor: appTheme.colorPrimary,
      );

    case BorderConstant.BORDER_BOTTOM:
      return RoundedBorderPainter(
        topRadius: 0,
        bottomRadius: 6,
        strokeWidth: 1,
        bottomBorderColor: appTheme.colorPrimary,
        leftBorderColor: appTheme.colorPrimary,
        rightBorderColor: appTheme.colorPrimary,
        topBorderColor: Colors.transparent,
      );

    case BorderConstant.BORDER_LEFT_RIGHT:
      return RoundedBorderPainter(
        topRadius: 0,
        bottomRadius: 0,
        strokeWidth: 1,
        bottomBorderColor: Colors.transparent,
        leftBorderColor: appTheme.colorPrimary,
        rightBorderColor: appTheme.colorPrimary,
        topBorderColor: Colors.transparent,
      );

    case BorderConstant.BORDER_NONE:
      return RoundedBorderPainter(
        topRadius: 6,
        bottomRadius: 6,
        strokeWidth: 1,
        bottomBorderColor: appTheme.colorPrimary,
        leftBorderColor: appTheme.colorPrimary,
        rightBorderColor: appTheme.colorPrimary,
        topBorderColor: appTheme.colorPrimary,
      );

    default:
      return RoundedBorderPainter(
        topRadius: 0,
        bottomRadius: 0,
        strokeWidth: 1,
        bottomBorderColor: Colors.transparent,
        leftBorderColor: Colors.transparent,
        rightBorderColor: Colors.transparent,
        topBorderColor: Colors.transparent,
      );
  }
}

openSharePopUp(BuildContext context) {
  List<StoneModel> stoneList = [
    StoneModel(1, "Stock"),
    StoneModel(2, "Cerificate"),
    StoneModel(3, "Real Image"),
    StoneModel(4, "Plotting Image"),
    StoneModel(5, "Heart & Arrow"),
    StoneModel(6, "Asset Scope"),
    StoneModel(7, "Video"),
  ];

  Future<void> share() async {
    // var url = await createDynamicLink(
    //     referalId: PrefUtilities.getInstance().getUser().referralCode);

    var link = ApiConstants.shareAndEarn;
    Share.share(
        "876654878\n"
        "Invite code : 655765757"
        "App link : $link", //------------------------------------------------------------------------------------------------------------------
        subject: R.string().screenTitle.share,
        sharePositionOrigin:
            Rect.fromCenter(center: Offset.zero, width: 100, height: 100));
  }

  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (context, StateSetter setsetter) {
              return Padding(
                padding: EdgeInsets.all(getSize(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      R.string().screenTitle.shareStone,
                      style: appTheme.black16TextStyle,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: stoneList.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            setsetter(() {
                              stoneList[i].isSelected =
                                  !stoneList[i].isSelected;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: getSize(20), bottom: getSize(10)),
                            child: Row(
                              children: [
                                Image.asset(
                                  stoneList[i].isSelected
                                      ? selectedCheckbox
                                      : unSelectedCheckbox,
                                  height: getSize(20),
                                  width: getSize(20),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: getSize(10)),
                                  child: Text(
                                    stoneList[i].title,
                                    style: appTheme.black14TextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              // alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.symmetric(
                                vertical: getSize(15),
                              ),
                              decoration: BoxDecoration(
                                color: appTheme.colorPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(getSize(5)),
                              ),
                              child: Text(
                                R.string().commonString.cancel,
                                textAlign: TextAlign.center,
                                style: appTheme.blue14TextStyle
                                    .copyWith(fontSize: getFontSize(16)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getSize(20),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              //alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.symmetric(
                                vertical: getSize(15),
                              ),
                              decoration: BoxDecoration(
                                  color: appTheme.colorPrimary,
                                  borderRadius:
                                      BorderRadius.circular(getSize(5)),
                                  boxShadow: getBoxShadow(context)),
                              child: Text(
                                R.string().screenTitle.share,
                                textAlign: TextAlign.center,
                                style: appTheme.white16TextStyle,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      });
}

openAddReminder(BuildContext context, ActionClick actionClick) {
  DateUtilities dateUtilities = DateUtilities();
  List<StoneModel> reminderList = [
    StoneModel(
        ReminderType.ReminderTypeToday, R.string().commonString.laterToday,
        subtitle: "6:00 pm", image: sunrise),
    StoneModel(
        ReminderType.ReminderTypeTomorrow, R.string().commonString.toMorrow,
        subtitle: " ${dateUtilities.getTomorrowDay(DateTime.now())} 8:00 am",
        image: sun),
    StoneModel(
        ReminderType.ReminderTypeNextWeek, R.string().commonString.nextWeek,
        subtitle: "${dateUtilities.getNextWeekDay(DateTime.now())} 8:00 am",
        image: calender_week),
    StoneModel(
        ReminderType.ReminderTypeCustom, R.string().commonString.chooseAnother,
        subtitle: R.string().commonString.dateTime, image: calender),
  ];
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(
            horizontal: getSize(20), vertical: getSize(20)),
        // contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getSize(15)),
        ),
        backgroundColor: appTheme.whiteColor,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(top: getSize(30), bottom: getSize(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    R.string().screenTitle.addRemider,
                    style: appTheme.black18TextStyle,
                  ),
                  SizedBox(height: getSize(20)),
                  GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: reminderList.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            if (reminderList[i].id !=
                                ReminderType.ReminderTypeCustom) {
                              reminderList.forEach((element) {
                                element.isSelected = false;
                              });
                              reminderList[i].isSelected =
                                  !reminderList[i].isSelected;
                            } else {
                              openDateTimeDialog(context, (manageClick) {
                                reminderList.forEach((element) {
                                  element.isSelected = false;
                                  if (element.id ==
                                      ReminderType.ReminderTypeCustom) {
                                    element.isSelected = true;
                                    element.selectedDate = manageClick.date;
                                    element.subtitle = DateUtilities()
                                        .convertServerDateToFormatterString(
                                            element.selectedDate,
                                            formatter: DateUtilities
                                                .dd_mm_yyyy_hh_mm_ss);
                                  }
                                });

                                setState(() {});
                              });
                            }
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: getSize(20)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: getSize(8)),
                                  child: Image.asset(
                                    reminderList[i].image,
                                    height: getSize(40),
                                    width: getSize(40),
                                    color: reminderList[i].isSelected
                                        ? appTheme.colorPrimary
                                        : appTheme.textBlackColor,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(5)),
                                  child: Text(
                                    reminderList[i].title,
                                    style: appTheme.black16TextStyle.copyWith(
                                      color: reminderList[i].isSelected
                                          ? appTheme.colorPrimary
                                          : appTheme.textBlackColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  reminderList[i].subtitle,
                                  style: appTheme.black12TextStyle.copyWith(
                                    color: reminderList[i].isSelected
                                        ? appTheme.colorPrimary
                                        : appTheme.textBlackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getSize(Spacing.leftPadding),
                        vertical: getSize(16)),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              // alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.symmetric(
                                vertical: getSize(15),
                              ),
                              decoration: BoxDecoration(
                                color: appTheme.colorPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(getSize(5)),
                              ),
                              child: Text(
                                R.string().commonString.cancel,
                                textAlign: TextAlign.center,
                                style: appTheme.blue14TextStyle
                                    .copyWith(fontSize: getFontSize(16)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getSize(20),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              StoneModel stoneModel;
                              reminderList.forEach((element) {
                                if (element.isSelected) {
                                  stoneModel = element;
                                }
                              });
                              if (stoneModel != null) {
                                DateTime dateTime = DateTime.now();

                                String date =
                                    dateTime.toUtc().toIso8601String();
                                switch (stoneModel.id) {
                                  case ReminderType.ReminderTypeToday:
                                    DateTime dt = DateTime(dateTime.year,
                                        dateTime.month, dateTime.day, 18, 0, 0);
                                    date = dt.toUtc().toIso8601String();
                                    break;
                                  case ReminderType.ReminderTypeTomorrow:
                                    DateTime dt = DateTime(
                                        dateTime.year,
                                        dateTime.month,
                                        dateTime.day + 1,
                                        8,
                                        0,
                                        0);
                                    dt.add(Duration(days: 1));
                                    date = dt.toUtc().toIso8601String();
                                    break;
                                  case ReminderType.ReminderTypeNextWeek:
                                    DateTime dt = DateTime(
                                        dateTime.year,
                                        dateTime.month,
                                        dateTime.day + 7,
                                        8,
                                        0,
                                        0);

                                    date = dt.toUtc().toIso8601String();
                                    break;
                                  case ReminderType.ReminderTypeCustom:
                                    date = stoneModel.selectedDate;
                                    break;
                                }
                                Navigator.pop(context);
                                actionClick(ManageCLick(
                                    type: clickConstant.CLICK_TYPE_CONFIRM,
                                    date: date));
                              } else {}
                            },
                            child: Container(
                              //alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.symmetric(
                                vertical: getSize(15),
                              ),
                              decoration: BoxDecoration(
                                  color: appTheme.colorPrimary,
                                  borderRadius:
                                      BorderRadius.circular(getSize(5)),
                                  boxShadow: getBoxShadow(context)),
                              child: Text(
                                R.string().commonString.btnSubmit,
                                textAlign: TextAlign.center,
                                style: appTheme.white16TextStyle,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

class StoneModel {
  int id;
  String title;
  String subtitle;
  String image;
  bool isSelected;
  String selectedDate;

  StoneModel(
    this.id,
    this.title, {
    this.subtitle,
    this.image = "",
    this.isSelected = false,
  });
}
