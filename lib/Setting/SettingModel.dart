import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Home/DrawerModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';

class DrawerSetting {
  List<DrawerModel> getDrawerItems() {
    List<DrawerModel> drawerList = [];
    if (app.resolve<PrefUtils>().isUserCustomer() &&
        app
            .resolve<PrefUtils>()
            .getModulePermission(ModulePermissionConstant.permission_dashboard)
            .view)
      drawerList.add(DrawerModel(
        image: dashboard,
        title: R.string.screenTitle.home,
        isSelected: true,
        type: DiamondModuleConstant.MODULE_TYPE_HOME,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_searchDiamond)
        .view)
      drawerList.add(DrawerModel(
        image: drawerSearch,
        title: R.string.screenTitle.search,
        isSelected: true,
        type: DiamondModuleConstant.MODULE_TYPE_SEARCH,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_quickSearch)
        .view)
      drawerList.add(DrawerModel(
        image: quickSearch,
        title: R.string.screenTitle.quickSearch,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_exclusive)
        .view)
      drawerList.add(DrawerModel(
        image: exclusiveDiamonds,
        title: R.string.screenTitle.exclusiveDiamonds,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND,
        isShowCount: false,
        countBackgroundColor: fromHex("#288F5A"),
        count: 25,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_newGoods)
        .view)
      drawerList.add(DrawerModel(
        image: newArrival,
        title: R.string.screenTitle.newArrival,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL,
        isShowCount: false,
        countBackgroundColor: fromHex("#2193B0"),
        count: 250,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_auction)
        .view)
      drawerList.add(DrawerModel(
        image: diamondOnAuction,
        title: R.string.screenTitle.diamondOnAuction,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION,
        isShowCount: false,
        countBackgroundColor: fromHex("#9C2AC4"),
        count: 50,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(
            ModulePermissionConstant.permission_upcomingDiamonds)
        .view)
      drawerList.add(DrawerModel(
        image: upcoming,
        title: R.string.screenTitle.upcoming,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_UPCOMING,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(
            ModulePermissionConstant.permission_stone_of_the_day)
        .view)
      drawerList.add(DrawerModel(
        image: stoneOfTheDay,
        title: R.string.screenTitle.stoneOfTheDays,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY,
        isShowCount: false,
        countBackgroundColor: fromHex("#003365"),
        count: 15,
      )); //Best Buy

    /*drawerList.add(DrawerModel(
      image: stoneOfTheDay,
      title: "Price Calculator",
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_PRICE_CALCULATOR,
      isShowCount: false,
      countBackgroundColor: fromHex("#003365"),
    ));*/

    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_offline_stock)
        .view) {
      drawerList.add(DrawerModel(
        image: mySavedSearch,
        title: R.string.screenTitle.offlineStock,
        isSelected: false,
        isShowDivider: false,
        isShowUpperDivider: true,
        type: DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK,
      ));

      drawerList.add(DrawerModel(
        image: drawerSearch,
        title: R.string.screenTitle.offlineSearch,
        isSelected: false,
        isShowDivider: false,
        isShowUpperDivider: false,
        type: DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH,
      ));

      drawerList.add(DrawerModel(
        image: drawerSearch,
        title: R.string.screenTitle.searchHistory,
        isSelected: false,
        isShowDivider: false,
        isShowUpperDivider: false,
        type: DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH_HISTORY,
      ));
    }

    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_mySavedSearch)
        .view)
      drawerList.add(DrawerModel(
        image: mySavedSearch,
        title: R.string.screenTitle.mySavedSearch,
        isSelected: false,
        isShowDivider: false,
        isShowUpperDivider: true,
        type: DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH,
      ));

    drawerList.add(DrawerModel(
      image: userTheme,
      title: R.string.screenTitle.myAccount,
      isSelected: false,
      isShowDivider: true,
      isShowUpperDivider: false,
      type: DiamondModuleConstant.MODULE_TYPE_PROFILE,
    ));
    /*if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_mySavedSearch)
        .view)
      drawerList.add(DrawerModel(
        image: recentSearch,
        title: R.string.screenTitle.recentSearch,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_RECENT_SEARCH,
        isShowDivider: true,
      ));*/
    drawerList.add(DrawerModel(
      image: termsAndCondition,
      title: R.string.screenTitle.termsAndCondition,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_TERM_CONDITION,
    ));
    drawerList.add(DrawerModel(
      image: privacyPolicy,
      title: R.string.screenTitle.privacyPolicy,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_PRIVACY_POLICY,
    ));
    drawerList.add(DrawerModel(
      image: aboutUs,
      title: R.string.screenTitle.aboutUS,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_ABOUT_US,
    ));
    drawerList.add(DrawerModel(
      image: contactUs,
      title: R.string.screenTitle.contactUs,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_CONTACT_US,
    ));
    /*drawerList.add(DrawerModel(
      image: changePassword,
      title: R.string.screenTitle.changePassword,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_CHANGE_PASSWORD,
    ));
    drawerList.add(DrawerModel(
      image: user,
      title: R.string.screenTitle.myProfile,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_PROFILE,
    ));*/
    drawerList.add(DrawerModel(
      image: logout,
      title: R.string.screenTitle.logout,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_LOGOUT,
    ));
    return drawerList;
    /*return <DrawerModel>[
      DrawerModel(
        image: search,
        title: "Search",
        isSelected: true,
        type: DrawerConstant.MODULE_SEARCH,
      ),
      */ /*DrawerModel(
        image: drawer_logout,
        title: R.string.screenTitle.logout,
        isSelected: false,
        type: DrawerConstant.LOGOUT,
      ),*/ /*
    ];*/
  }

  List<DrawerModel> getAccountListItems() {
    List<DrawerModel> drawerList = [];
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_watchlist)
        .view)
      drawerList.add(DrawerModel(
        image: myWatchlist,
        title: R.string.screenTitle.myWatchlist,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_cart)
        .view)
      drawerList.add(DrawerModel(
          image: addToCartDrawer,
          title: R.string.screenTitle.myCart,
          imageColor: appTheme.colorPrimary,
          isSelected: false,
          type: DiamondModuleConstant.MODULE_TYPE_MY_CART));
    // if (app
    //     .resolve<PrefUtils>()
    //     .getModulePermission(ModulePermissionConstant.permission_bid)
    //     .view)
    drawerList.add(DrawerModel(
      image: bidImage,
      title: R.string.screenTitle.myBid,
      imageColor: appTheme.colorPrimary,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_MY_BID,
    ));
//    if (app
//        .resolve<PrefUtils>()
//        .getModulePermission(ModulePermissionConstant.permission_hold)
//        .view)
//      drawerList.add(DrawerModel(
//        image: myHold,
//        title: R.string.screenTitle.myHold,
//        imageColor: appTheme.colorPrimary,
//        isSelected: false,
//        type: DiamondModuleConstant.MODULE_TYPE_MY_HOLD,
//      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_enquiry)
        .view)
      drawerList.add(DrawerModel(
        image: enquiryDrawer,
        title: R.string.screenTitle.myEnquiry,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY,
      ));

    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_appointment)
        .view)
      drawerList.add(DrawerModel(
        image: myOffice,
        title: R.string.screenTitle.myOffice,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_MY_OFFICE,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_offer)
        .view)
      drawerList.add(DrawerModel(
        image: myOffer,
        title: R.string.screenTitle.myOffer,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_MY_OFFER,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_order)
        .view)
      drawerList.add(DrawerModel(
        image: confirmStones,
        title: R.string.screenTitle.confirmStone,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_MY_ORDER,
      ));

    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_purchase)
        .view)
      drawerList.add(DrawerModel(
        image: myOrder,
        title: R.string.screenTitle.myPurchased,
        isSelected: false,
        imageColor: appTheme.colorPrimary,
        type: DiamondModuleConstant.MODULE_TYPE_MY_PURCHASE,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_comment)
        .view)
      drawerList.add(DrawerModel(
          image: commentDrawer,
          title: R.string.screenTitle.myComments,
          imageColor: appTheme.colorPrimary,
          isSelected: false,
          type: DiamondModuleConstant.MODULE_TYPE_MY_COMMENT));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_reminder)
        .view)
      drawerList.add(DrawerModel(
          image: reminder,
          title: R.string.screenTitle.myReminder,
          imageColor: appTheme.colorPrimary,
          isSelected: false,
          type: DiamondModuleConstant.MODULE_TYPE_MY_REMINDER));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_myDemand)
        .view)
      drawerList.add(DrawerModel(
        image: myDemandImage,
        title: R.string.screenTitle.myDemand,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        isShowDivider: true,
        type: DiamondModuleConstant.MODULE_TYPE_MY_DEMAND,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_address)
        .view)
      drawerList.add(DrawerModel(
        image: manageAddress,
        title: R.string.screenTitle.manageAddress,
        isSelected: false,
        imageColor: appTheme.colorPrimary,
        type: DiamondModuleConstant.MODULE_TYPE_MANAGE_ADDRESS,
      ));
    // drawerList.add(DrawerModel(
    //   image: manageAddress,
    //   title: R.string.commonString.touchId,
    //   isSelected: false,
    //   imageColor: appTheme.colorPrimary,
    //   type: DiamondModuleConstant.MODULE_TYPE_TOUCH_ID,
    // ));
    // if (app.resolve<PrefUtils>().getUserDetails().isMpinAdded) {
    //   drawerList.add(DrawerModel(
    //     image: changePassword,
    //     title: R.string.commonString.mPin,
    //     isSelected: false,
    //     imageColor: appTheme.colorPrimary,
    //     type: DiamondModuleConstant.MODULE_TYPE_MPIN,
    //   ));
    // }
    drawerList.add(DrawerModel(
        image: changePassword,
        title: R.string.screenTitle.changePassword,
        isSelected: false,
        imageColor: appTheme.colorPrimary,
        type: DiamondModuleConstant.MODULE_TYPE_CHANGE_PASSWORD));

    // drawerList.add(DrawerModel(
    //   image: changePassword,
    //   title: app.resolve<PrefUtils>().getUserDetails().isMpinAdded == false
    //       ? "Create MPin"
    //       : "Change MPin",
    //   isSelected: false,
    //   imageColor: appTheme.colorPrimary,
    //   type: DiamondModuleConstant.MODULE_TYPE_CHANGEMPIN,
    // ));

    drawerList.add(DrawerModel(
      image: logout,
      title: R.string.screenTitle.logout,
      isSelected: false,
      imageColor: appTheme.colorPrimary,
      type: DiamondModuleConstant.MODULE_TYPE_LOGOUT,
    ));
    return drawerList;
  }
}

isDisplayDelete(int moduleType) {
  bool isDisplay = false;
  switch (moduleType) {
    case DiamondModuleConstant.MODULE_TYPE_MY_CART:
      if (app
          .resolve<PrefUtils>()
          .getModulePermission(ModulePermissionConstant.permission_cart)
          .delete) isDisplay = true;
      break;
    case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
      if (app
          .resolve<PrefUtils>()
          .getModulePermission(ModulePermissionConstant.permission_comment)
          .delete) isDisplay = true;
      break;
    case DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST:
      if (app
          .resolve<PrefUtils>()
          .getModulePermission(ModulePermissionConstant.permission_watchlist)
          .delete) isDisplay = true;
      break;
    case DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY:
      if (app
          .resolve<PrefUtils>()
          .getModulePermission(ModulePermissionConstant.permission_enquiry)
          .delete) isDisplay = true;
      break;
    case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
      // if (app
      //     .resolve<PrefUtils>()
      //     .getModulePermission(ModulePermissionConstant.permission_offer)
      //     .delete) isDisplay = true;
      isDisplay = false;
      break;
    case DiamondModuleConstant.MODULE_TYPE_MY_REMINDER:
      if (app
          .resolve<PrefUtils>()
          .getModulePermission(ModulePermissionConstant.permission_reminder)
          .delete) isDisplay = true;
      break;
    case DiamondModuleConstant.MODULE_TYPE_MY_BID:
      if (app
          .resolve<PrefUtils>()
          .getModulePermission(ModulePermissionConstant.permission_bid)
          .delete) isDisplay = true;
      break;
    case DiamondModuleConstant.MODULE_TYPE_MY_OFFICE:
      if (app
          .resolve<PrefUtils>()
          .getModulePermission(ModulePermissionConstant.permission_appointment)
          .delete) isDisplay = true;
      break;
  }
  return isDisplay;
}

isDisplayDetail(int moduleType) {
  bool isDisplay = true;
  switch (moduleType) {
    case DiamondModuleConstant.MODULE_TYPE_MY_ORDER:
    case DiamondModuleConstant.MODULE_TYPE_MY_PURCHASE:
      isDisplay = false;
      break;
  }
  return isDisplay;
}

class BottomMenuSetting {
  int moduleType;

  BottomMenuSetting(this.moduleType);

  List<BottomTabModel> getMoreMenuItems(
      {bool isDetail = false, bool isCompare = false}) {
    List<BottomTabModel> moreMenuList = [];
    if (!app.resolve<PrefUtils>().isUserCustomer() &&
        moduleType != DiamondModuleConstant.MODULE_TYPE_MY_CART) {
      addCartInBottomMenu(moreMenuList);
    }
    if (!app.resolve<PrefUtils>().isUserCustomer()&&
        moduleType != DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST) {
      addWatchlistInBottomMenu(moreMenuList, home_watchlist);
    }

    if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_ORDER) {
      if (moduleType == DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY) {
        addPlaceOrderInBottomMenu(moreMenuList, placeOrder);
      }
    }
//    if ((app.resolve<PrefUtils>().getUserDetails().account?.isApproved ??
//            KYCStatus.pending) ==
//        KYCStatus.approved) {
    if (!isDetail && !isCompare) {
      if (moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION &&
          moduleType != DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK &&
          moduleType !=
              DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH) {
        addCompareInBottomMenu(moreMenuList, compare);
      }
    }
//    }
    if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY) {
      addEnquiryInBottomMenu(moreMenuList);
    }
    if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFICE &&
        moduleType != DiamondModuleConstant.MODULE_TYPE_MY_BID &&
        moduleType != DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL &&
        moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION &&
        app
            .resolve<PrefUtils>()
            .getModulePermission(ModulePermissionConstant.permission_office)
            .insert) {
      moreMenuList.add(BottomTabModel(
          image: myOffice,
          isCenter: false,
          title: R.string.screenTitle.officeView,
          type: ActionMenuConstant.ACTION_TYPE_APPOINTMENT));
    }
    if (moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION &&
        moduleType != DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK &&
        moduleType != DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH) {
      addCommentInBottomMenu(moreMenuList);
    }
    if (!isDetail && !isCompare) {
      addCompareInBottomMenu(moreMenuList, compare);
    }

//    if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_REMINDER) {
//      if (moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION) {
//        addReminderInBottomMenu(moreMenuList);
//      }
//    }
//    if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
//      if (moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION &&
//          moduleType != DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK &&
//          moduleType !=
//              DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH) {
//        if (isDiamondSearchModule(moduleType) && !isCompare) {
//          addOfferInBottomMenu(moreMenuList, offer);
//        }
//      }
//    }
    if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFICE) {
      if (moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION &&
          moduleType != DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK &&
          moduleType !=
              DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH) {
        addAppointmentInBottomMenu(moreMenuList);
      }
    }

//    addExcelBottomMenu(moreMenuList);

    /* moreMenuList.add(BottomTabModel(
        image: hold,
        title: R.string.screenTitle.hold,
        type: ActionMenuConstant.ACTION_TYPE_HOLD));*/
    if (!isCompare) {
      if (isDisplayDelete(moduleType)) {
        addDeleteInBottomMenu(moreMenuList);
      }
    }

    addDownloadInBottomMenu(moreMenuList, download);
//    addClearSelectionInBottomMenu(moreMenuList, clearSelection);
    addShareInBottomMenu(moreMenuList, share);
    return moreMenuList;
  }

  List<BottomTabModel> getBottomMenuItems(int moduleType,
      {bool isDetail = false, bool isCompare = false}) {
    List<BottomTabModel> moreMenuList = [];
    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_MY_ORDER:
      case DiamondModuleConstant.MODULE_TYPE_MY_PURCHASE:
        addShareInBottomMenu(moreMenuList, shareWhite, isCenter: false);
        addDownloadInBottomMenu(moreMenuList, downloadWhite, isCenter: false);

        break;
      case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
        addBidStoneInBottomMenu(moreMenuList);

        addWatchlistInBottomMenu(moreMenuList, addToWatchlist, isCenter: false);
        addFinalCalculationInBottomMenu(moreMenuList);
        if (!isDetail && !isCompare) {
          addCompareInBottomMenu(moreMenuList, compare, isCenter: false);
        }

        moreMenuList.add(BottomTabModel(
          title: R.string.commonString.more,
          isCenter: false,
          image: plusIcon,
          type: ActionMenuConstant.ACTION_TYPE_MORE,
        ));
        break;
      case DiamondModuleConstant.MODULE_TYPE_MY_BID:
        addConfirmStone(moreMenuList,
            title: "Update Stone",
            image: updateStones,
            type: ActionMenuConstant.ACTION_TYPE_UPDATE_NOTE);
        addEnquiryInBottomMenu(moreMenuList);
        addCompareInBottomMenu(moreMenuList, compare, isCenter: false);
        addShareInBottomMenu(moreMenuList, shareWhite, isCenter: false);
        addDownloadInBottomMenu(moreMenuList, downloadWhite, isCenter: false);
        break;
      case DiamondModuleConstant.MODULE_TYPE_UPCOMING:
        if (!isDetail && !isCompare) {
          addCompareInBottomMenu(moreMenuList, compare, isCenter: false);
          addClearSelectionInBottomMenu(moreMenuList, clearSelectionWhite,
              isCenter: false);
        }
        addShareInBottomMenu(moreMenuList, shareWhite, isCenter: false);
        addDownloadInBottomMenu(moreMenuList, downloadWhite, isCenter: false);

        break;

      case DiamondModuleConstant.MODULE_TYPE_FINAL_CALCULATION:
        addPlaceOrderInBottomMenu(moreMenuList, placeOrder, isCenter: false);

        moreMenuList.add(BottomTabModel(
            image: cancelStone,
            title: R.string.screenTitle.cancelStone,
            isCenter: false,
            type: ActionMenuConstant.ACTION_TYPE_CANCEL_STONE));
        addShareInBottomMenu(moreMenuList, shareWhite, isCenter: false);

        break;
      default:
        if (!app.resolve<PrefUtils>().isUserCustomer()) {
          if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY ||
              moduleType == DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST ||
              moduleType == DiamondModuleConstant.MODULE_TYPE_MY_CART ||
              moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER ||
              moduleType == DiamondModuleConstant.MODULE_TYPE_SEARCH ||
              moduleType == DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL ||
              moduleType == DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH ||
              moduleType == DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK) {
            addPlaceOrderInBottomMenu(moreMenuList, placeOrder,
                isCenter: false);
            // if (app
            //   .resolve<PrefUtils>()
            //   .getModulePermission(ModulePermissionConstant.permission_bid)
            //   .insert)
            // moreMenuList.add(BottomTabModel(
            //     image: bidImage,
            //     isCenter: false,
            //     title: R.string.screenTitle.myBid,
            //     type: ActionMenuConstant.ACTION_TYPE_MY_BID));
          }

//
          if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_HOLD) {
            addHoldInBottomMenu(moreMenuList, sale_hold, isCenter: false);
          }

          if (moduleType != DiamondModuleConstant.MODULE_TYPE_MEMO) {
            addMemoInBottomMenu(
              moreMenuList,
              sale_note,
              isCenter: false,
            );
          }
//        if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST) {
//          addWatchlistInBottomMenu(moreMenuList, addToWatchlist,
//              isCenter: false);
//        }
//          if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY) {
//            addEnquiryInBottomMenu(moreMenuList);
//          }
          if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_CART) {
            addCartInBottomMenu(moreMenuList);
          }

          if (!isDiamondSearchModule(moduleType)) {
            if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFER &&
                moduleType != DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK &&
                moduleType !=
                    DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH) {
              addOfferInBottomMenu(moreMenuList, offerWhite, isCenter: false);
            }
          }
          if (isDiamondSearchModule(moduleType) && isDetail) {
            addOfferInBottomMenu(moreMenuList, offerWhite, isCenter: false);
          }

//          For Compare special
          if (isCompare) {
            addOfferInBottomMenu(moreMenuList, offerWhite, isCenter: false);
          }
          if (!isCompare && !isDetail) {
            if (moduleType !=
                    DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION &&
                moduleType != DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK &&
                moduleType !=
                    DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH) {
              moreMenuList.add(BottomTabModel(
                  title: R.string.commonString.status,
                  isCenter: false,
                  image: status,
                  type: ActionMenuConstant.ACTION_TYPE_STATUS));
            }
          }

          if (moduleType == DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK ||
              moduleType ==
                  DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH) {
            addCompareInBottomMenu(moreMenuList, compare, isCenter: false);
          }
          moreMenuList.add(BottomTabModel(
            title: R.string.commonString.more,
            isCenter: false,
            image: plusIcon,
            type: ActionMenuConstant.ACTION_TYPE_MORE,
          ));
        } else {
          if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_PURCHASE) {
            addConfirmStone(moreMenuList);
          }
          if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
            addOfferInBottomMenu(moreMenuList, offer,
                isCenter: false, title: R.string.screenTitle.offer);
          }
          if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST) {
            addWatchlistInBottomMenu(moreMenuList, addToWatchlist,
                isCenter: false);
          }
//          if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY) {
//            addEnquiryInBottomMenu(moreMenuList);
//          }
          if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_CART) {
            addCartInBottomMenu(moreMenuList);
          }

//          if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY ||
//              moduleType == DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST ||
//              moduleType == DiamondModuleConstant.MODULE_TYPE_MY_CART ||
//              moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER ||
//              moduleType == DiamondModuleConstant.MODULE_TYPE_SEARCH ||
//              moduleType == DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL ||
//              moduleType == DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH ||
//              moduleType == DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK) {
//            addEnquiryInBottomMenu(moreMenuList);
//          }

//          if (!isDiamondSearchModule(moduleType)) {
//            if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFER &&
//                moduleType != DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK &&
//                moduleType !=
//                    DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH) {
//              addOfferInBottomMenu(moreMenuList, offerWhite, isCenter: false);
//            }
//          }
//          if (isDiamondSearchModule(moduleType) && isDetail) {
//            addOfferInBottomMenu(moreMenuList, offerWhite, isCenter: false);
//          }

          //For Compare special
//          if (isCompare) {
//            addOfferInBottomMenu(moreMenuList, offerWhite, isCenter: false);
//          }
//          if (!isCompare && !isDetail) {
//            if (moduleType !=
//                    DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION &&
//                moduleType != DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK &&
//                moduleType !=
//                    DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH) {
//              moreMenuList.add(BottomTabModel(
//                  title: R.string.commonString.status,
//                  isCenter: false,
//                  image: status,
//                  type: ActionMenuConstant.ACTION_TYPE_STATUS));
//            }
//          }

          if (moduleType == DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK ||
              moduleType ==
                  DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK_SEARCH) {
            addCompareInBottomMenu(moreMenuList, compare, isCenter: false);
          }
          moreMenuList.add(BottomTabModel(
            title: R.string.commonString.more,
            isCenter: false,
            image: plusIcon,
            type: ActionMenuConstant.ACTION_TYPE_MORE,
          ));
        }
        break;
    }
    // moreMenuList.forEach((element) {
    //   element.imageColor = appTheme.whiteColor;
    // });

    return moreMenuList;
  }

  List<BottomTabModel> getStatusMenuItems() {
    List<BottomTabModel> moreMenuList = [];
    BottomTabModel model = BottomTabModel(
        image: diamond,
        isCenter: false,
        title: R.string.screenTitle.statusAvailable);
    model.imageColor = appTheme.statusAvailable;
    moreMenuList.add(model);
    model = BottomTabModel(
        image: diamond, isCenter: false, title: R.string.screenTitle.statusNew);
    model.imageColor = appTheme.statusNew;
    moreMenuList.add(model);
    model = BottomTabModel(
        image: diamond,
        isCenter: false,
        title: R.string.screenTitle.statusHold);
    model.imageColor = appTheme.statusHold;
    moreMenuList.add(model);
    model = BottomTabModel(
        image: diamond,
        isCenter: false,
        title: R.string.screenTitle.statusOnMemo);
    model.imageColor = appTheme.statusOnMemo;
    moreMenuList.add(model);

    model = BottomTabModel(
        image: diamond,
        isCenter: false,
        title: R.string.screenTitle.stoneOfTheDays);
    model.imageColor = appTheme.statusOffer;
    moreMenuList.add(model);

    return moreMenuList;
  }

  addCartInBottomMenu(List<BottomTabModel> moreMenuList) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_cart)
        .insert) {
      moreMenuList.add(BottomTabModel(
          image: addToCart,
          isCenter: false,
          title: R.string.screenTitle.addToCart,
          type: ActionMenuConstant.ACTION_TYPE_ADD_TO_CART));
    }
  }

  addEnquiryInBottomMenu(List<BottomTabModel> moreMenuList) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_enquiry)
        .insert) {
      moreMenuList.add(BottomTabModel(
          image: enquiry,
          title: R.string.screenTitle.addEnquiry,
          isCenter: false,
          type: ActionMenuConstant.ACTION_TYPE_ENQUIRY));
    }
  }

  addFinalCalculationInBottomMenu(List<BottomTabModel> moreMenuList) {
    moreMenuList.add(BottomTabModel(
        image: finalCalculation,
        isCenter: false,
        title: R.string.screenTitle.finalCalculation,
        type: ActionMenuConstant.ACTION_TYPE_FINAL_CALCULATION));
  }

  addWatchlistInBottomMenu(List<BottomTabModel> moreMenuList, String image,
      {bool isCenter: true}) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_watchlist)
        .insert) {
      moreMenuList.add(BottomTabModel(
          image: image,
          isCenter: isCenter,
          title: R.string.screenTitle.addToWatchList,
          type: ActionMenuConstant.ACTION_TYPE_WISHLIST));
    }
  }

  addConfirmStone(
    List<BottomTabModel> moreMenuList, {
    bool isCenter: true,
    String title,
    String image,
    int type,
  }) {
//    if (app
//        .resolve<PrefUtils>()
//        .getModulePermission(ModulePermissionConstant.permission_confirm_stone)
//        .insert) {
    moreMenuList.add(BottomTabModel(
      title: title ?? R.string.commonString.confirmStone,
      isCenter: false,
      image: image ?? confirmStone,
      type: type ?? ActionMenuConstant.ACTION_TYPE_PLACE_ORDER,
    ));
//    }
  }

  addQuoteStone(List<BottomTabModel> moreMenuList) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_confirm_stone)
        .insert) {
      moreMenuList.add(BottomTabModel(
        title: R.string.commonString.confirmStone,
        isCenter: false,
        image: confirmStone,
        type: ActionMenuConstant.ACTION_TYPE_PLACE_ORDER,
      ));
    }
  }

  addHoldInBottomMenu(List<BottomTabModel> moreMenuList, String image,
      {bool isCenter: true}) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_hold)
        .insert) {
      moreMenuList.add(BottomTabModel(
          image: image,
          isCenter: isCenter,
          title: R.string.screenTitle.hold,
          type: ActionMenuConstant.ACTION_TYPE_HOLD));
    }
  }

  addMemoInBottomMenu(List<BottomTabModel> moreMenuList, String image,
      {bool isCenter: true}) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_memo)
        .insert) {
      moreMenuList.add(BottomTabModel(
          image: image,
          isCenter: isCenter,
          title: R.string.screenTitle.memo,
          type: ActionMenuConstant.ACTION_TYPE_MEMO));
    }
  }

  addBidStoneInBottomMenu(List<BottomTabModel> moreMenuList) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_bid)
        .insert) {
      moreMenuList.add(BottomTabModel(
          title: R.string.screenTitle.bidStone,
          isCenter: false,
          image: myBidWhite,
          type: ActionMenuConstant.ACTION_TYPE_BID));
    }
  }

  addPlaceOrderInBottomMenu(List<BottomTabModel> moreMenuList, String image,
      {bool isCenter: true}) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_order)
        .insert) {
      moreMenuList.add(BottomTabModel(
          image: image,
          isCenter: isCenter,
          title: R.string.screenTitle.buyNow,
          type: ActionMenuConstant.ACTION_TYPE_PLACE_ORDER));
    }
  }

  addCompareInBottomMenu(List<BottomTabModel> moreMenuList, String image,
      {bool isCenter: true}) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_compare)
        .view) {
      moreMenuList.add(BottomTabModel(
          image: image,
          isCenter: isCenter,
          title: R.string.screenTitle.compareStones,
          type: ActionMenuConstant.ACTION_TYPE_COMPARE));
    }
  }

  addCommentInBottomMenu(List<BottomTabModel> moreMenuList) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_comment)
        .insert) {
      moreMenuList.add(BottomTabModel(
          image: comment,
          title: R.string.screenTitle.comment,
          type: ActionMenuConstant.ACTION_TYPE_COMMENT));
    }
  }

  addReminderInBottomMenu(List<BottomTabModel> moreMenuList) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_reminder)
        .insert) {
      moreMenuList.add(BottomTabModel(
          image: reminder,
          title: R.string.screenTitle.reminder,
          type: ActionMenuConstant.ACTION_TYPE_REMINDER));
    }
  }

  addOfferInBottomMenu(List<BottomTabModel> moreMenuList, String image,
      {bool isCenter: true, String title}) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_offer)
        .insert) {
      moreMenuList.add(BottomTabModel(
          image: image,
          isCenter: isCenter,
          title: title ?? R.string.screenTitle.offer,
          color: appTheme.whiteColor,
          type: ActionMenuConstant.ACTION_TYPE_OFFER));
    }
  }

  addAppointmentInBottomMenu(List<BottomTabModel> moreMenuList) {
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_appointment)
        .insert) {
      moreMenuList.add(BottomTabModel(
          image: company,
          title: R.string.screenTitle.officeView,
          type: ActionMenuConstant.ACTION_TYPE_APPOINTMENT));
    }
  }

  addExcelBottomMenu(List<BottomTabModel> moreMenuList) {
    // if (app
    //     .resolve<PrefUtils>()
    //     .getModulePermission(ModulePermissionConstant.permission_excel)
    //     .downloadExcel) {
    if ((app.resolve<PrefUtils>().getUserDetails().account?.isApproved ??
            KYCStatus.pending) ==
        KYCStatus.approved) {
      moreMenuList.add(BottomTabModel(
          image: excelImage,
          title: "Excel",
          type: ActionMenuConstant.ACTION_TYPE_EXCEL));
    }
    // }
  }

  addDeleteInBottomMenu(List<BottomTabModel> moreMenuList) {
    moreMenuList.add(BottomTabModel(
        image: home_delete,
        title: R.string.screenTitle.delete,
        type: ActionMenuConstant.ACTION_TYPE_DELETE));
  }

  addDownloadInBottomMenu(List<BottomTabModel> moreMenuList, String image,
      {bool isCenter: true}) {
    // if (app
    //     .resolve<PrefUtils>()
    //     .getModulePermission(getPermissionFromModuleType(moduleType))
    //     .downloadExcel && moduleType != DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK) {
//    if ((app.resolve<PrefUtils>().getUserDetails().account?.isApproved ??
//            KYCStatus.pending) ==
//        KYCStatus.approved) {
    moreMenuList.add(BottomTabModel(
        image: image,
        isCenter: isCenter,
        title: R.string.screenTitle.download,
        type: ActionMenuConstant.ACTION_TYPE_DOWNLOAD));
//    }
  }

  addClearSelectionInBottomMenu(List<BottomTabModel> moreMenuList, String image,
      {bool isCenter: true}) {
    moreMenuList.add(BottomTabModel(
        image: image,
        isCenter: isCenter,
        title: R.string.screenTitle.clearSelection,
        type: ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION));
  }

  addShareInBottomMenu(List<BottomTabModel> moreMenuList, String image,
      {bool isCenter: true}) {
    moreMenuList.add(BottomTabModel(
        image: image,
        title: R.string.screenTitle.share,
        isCenter: isCenter,
        type: ActionMenuConstant.ACTION_TYPE_SHARE));
  }
}

bool isDiamondSearchModule(int moduleType) {
  switch (moduleType) {
    case DiamondModuleConstant.MODULE_TYPE_SEARCH:
    case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
    case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND:
    case DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL:
    case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
    case DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH:
    case DiamondModuleConstant.MODULE_TYPE_OFFLINE_STOCK:
      return true;
    default:
      return false;
  }
}
