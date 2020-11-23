import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Home/DrawerModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/LoginModel.dart';

class DrawerSetting {
  List<DrawerModel> getDrawerItems() {
    List<DrawerModel> drawerList = [];
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_dashboard)
        .view)
      drawerList.add(DrawerModel(
        image: home,
        title: R.string().screenTitle.home,
        isSelected: true,
        type: DiamondModuleConstant.MODULE_TYPE_HOME,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_searchDiamond)
        .view)
      drawerList.add(DrawerModel(
        image: drawerSearch,
        title: R.string().screenTitle.search,
        isSelected: true,
        type: DiamondModuleConstant.MODULE_TYPE_SEARCH,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_quickSearch)
        .view)
      drawerList.add(DrawerModel(
        image: quickSearch,
        title: R.string().screenTitle.quickSearch,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_newGoods)
        .view)
      drawerList.add(DrawerModel(
        image: newArrival,
        title: R.string().screenTitle.newArrival,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL,
        isShowCount: false,
        countBackgroundColor: fromHex("#2193B0"),
        count: 250,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_exclusive)
        .view)
      drawerList.add(DrawerModel(
        image: exclusiveDiamonds,
        title: R.string().screenTitle.exclusiveDiamonds,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND,
        isShowCount: true,
        countBackgroundColor: fromHex("#288F5A"),
        count: 25,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_auction)
        .view)
      drawerList.add(DrawerModel(
        image: diamondOnAuction,
        title: R.string().screenTitle.diamondOnAuction,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION,
        isShowCount: true,
        countBackgroundColor: fromHex("#9C2AC4"),
        count: 50,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(
            ModulePermissionConstant.permission_upcomingDiamonds)
        .view)
      drawerList.add(DrawerModel(
        image: quickSearch,
        title: R.string().screenTitle.upcoming,
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
        title: R.string().screenTitle.stoneOfTheDays,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY,
        isShowCount: false,
        countBackgroundColor: fromHex("#003365"),
        count: 15,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_mySavedSearch)
        .view)
      drawerList.add(DrawerModel(
        image: mySavedSearch,
        title: R.string().screenTitle.mySavedSearch,
        isSelected: false,
        isShowDivider: true,
        isShowUpperDivider: true,
        type: DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH,
      ));
    /*if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_mySavedSearch)
        .view)
      drawerList.add(DrawerModel(
        image: recentSearch,
        title: R.string().screenTitle.recentSearch,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_RECENT_SEARCH,
        isShowDivider: true,
      ));*/
    drawerList.add(DrawerModel(
      image: termsAndCondition,
      title: R.string().screenTitle.termsAndCondition,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_TERM_CONDITION,
    ));
    drawerList.add(DrawerModel(
      image: privacyPolicy,
      title: R.string().screenTitle.privacyPolicy,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_PRIVACY_POLICY,
    ));
    drawerList.add(DrawerModel(
      image: aboutUs,
      title: R.string().screenTitle.aboutUs,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_ABOUT_US,
    ));
    drawerList.add(DrawerModel(
      image: contactUs,
      title: R.string().screenTitle.contactUs,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_CONTACT_US,
    ));
    /*drawerList.add(DrawerModel(
      image: changePassword,
      title: R.string().screenTitle.changePassword,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_CHANGE_PASSWORD,
    ));
    drawerList.add(DrawerModel(
      image: user,
      title: R.string().screenTitle.myProfile,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_PROFILE,
    ));*/
    drawerList.add(DrawerModel(
      image: logout,
      title: R.string().screenTitle.logout,
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
        title: R.string().screenTitle.logout,
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
        title: R.string().screenTitle.myWatchlist,
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
          title: R.string().screenTitle.myCart,
          imageColor: appTheme.colorPrimary,
          isSelected: false,
          type: DiamondModuleConstant.MODULE_TYPE_MY_CART));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_bid)
        .view)
      drawerList.add(DrawerModel(
        image: bidImage,
        title: R.string().screenTitle.myBid,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_MY_BID,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_hold)
        .view)
      drawerList.add(DrawerModel(
        image: myHold,
        title: R.string().screenTitle.myHold,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_MY_HOLD,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_enquiry)
        .view)
      drawerList.add(DrawerModel(
        image: enquiryDrawer,
        title: R.string().screenTitle.myEnquiry,
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
        title: R.string().screenTitle.myOffice,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_MY_OFFICE,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_order)
        .view)
      drawerList.add(DrawerModel(
        image: myOrder,
        title: R.string().screenTitle.myOrder,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_MY_ORDER,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_offer)
        .view)
      drawerList.add(DrawerModel(
        image: myOffer,
        title: R.string().screenTitle.myOffer,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_MY_OFFER,
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_purchase)
        .view)
      drawerList.add(DrawerModel(
        image: myPurchased,
        title: R.string().screenTitle.myPurchased,
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
          title: R.string().screenTitle.myComments,
          imageColor: appTheme.colorPrimary,
          isSelected: false,
          type: DiamondModuleConstant.MODULE_TYPE_MY_COMMENT));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_reminder)
        .view)
      drawerList.add(DrawerModel(
          image: reminder,
          title: R.string().screenTitle.myReminder,
          imageColor: appTheme.colorPrimary,
          isSelected: false,
          type: DiamondModuleConstant.MODULE_TYPE_MY_REMINDER));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_myDemand)
        .view)
      drawerList.add(DrawerModel(
        image: myDemandImage,
        title: R.string().screenTitle.myDemand,
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
        title: R.string().screenTitle.manageAddress,
        isSelected: false,
        imageColor: appTheme.colorPrimary,
        type: DiamondModuleConstant.MODULE_TYPE_MANAGE_ADDRESS,
      ));
    drawerList.add(DrawerModel(
      image: changePassword,
      title: R.string().screenTitle.changePassword,
      isSelected: false,
      imageColor: appTheme.colorPrimary,
      type: DiamondModuleConstant.MODULE_TYPE_CHANGE_PASSWORD,
    ));

    drawerList.add(DrawerModel(
      image: logout,
      title: R.string().screenTitle.logout,
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
      if (app
          .resolve<PrefUtils>()
          .getModulePermission(ModulePermissionConstant.permission_offer)
          .delete) isDisplay = true;
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
  }
  return isDisplay;
}

class BottomMenuSetting {
  int moduleType;

  BottomMenuSetting(this.moduleType);

  List<BottomTabModel> getMoreMenuItems(
      {bool isDetail = false, bool isCompare = false}) {
    List<BottomTabModel> moreMenuList = [];
    // if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_ORDER) {
    //   if (moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION) {
    //     if (app
    //         .resolve<PrefUtils>()
    //         .getModulePermission(ModulePermissionConstant.permission_order)
    //         .insert)
    //       moreMenuList.add(BottomTabModel(
    //           image: placeOrder,
    //           title: R.string().screenTitle.placeOrder,
    //           type: ActionMenuConstant.ACTION_TYPE_PLACE_ORDER));
    //   }
    // }
    if (!isDetail && !isCompare) {
      if (moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION) {
        if (app
            .resolve<PrefUtils>()
            .getModulePermission(ModulePermissionConstant.permission_compare)
            .view)
          moreMenuList.add(BottomTabModel(
              image: compare,
              title: R.string().screenTitle.compare,
              type: ActionMenuConstant.ACTION_TYPE_COMPARE));
      }
    }
    if (moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION) {
      if (app
          .resolve<PrefUtils>()
          .getModulePermission(ModulePermissionConstant.permission_comment)
          .insert)
        moreMenuList.add(BottomTabModel(
            image: comment,
            title: R.string().screenTitle.comment,
            type: ActionMenuConstant.ACTION_TYPE_COMMENT));
    }

    if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_REMINDER) {
      if (moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION) {
        if (app
            .resolve<PrefUtils>()
            .getModulePermission(ModulePermissionConstant.permission_reminder)
            .insert)
          moreMenuList.add(BottomTabModel(
              image: reminder,
              title: R.string().screenTitle.reminder,
              type: ActionMenuConstant.ACTION_TYPE_REMINDER));
      }
    }
    if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
      if (moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION) {
        if (moduleType == DiamondModuleConstant.MODULE_TYPE_SEARCH) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(ModulePermissionConstant.permission_offer)
              .insert)
            moreMenuList.add(BottomTabModel(
                image: offer,
                title: R.string().screenTitle.offer,
                type: ActionMenuConstant.ACTION_TYPE_OFFER));
        }
      }
    }
    if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFICE) {
      if (moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION) {
        if (app
            .resolve<PrefUtils>()
            .getModulePermission(
                ModulePermissionConstant.permission_appointment)
            .insert)
          moreMenuList.add(BottomTabModel(
              image: company,
              title: R.string().screenTitle.officeView,
              type: ActionMenuConstant.ACTION_TYPE_APPOINTMENT));
      }
    }
    /* moreMenuList.add(BottomTabModel(
        image: hold,
        title: R.string().screenTitle.hold,
        type: ActionMenuConstant.ACTION_TYPE_HOLD));*/
    if (!isCompare) {
      if (isDisplayDelete(moduleType)) {
        moreMenuList.add(BottomTabModel(
            image: home_delete,
            title: R.string().screenTitle.delete,
            type: ActionMenuConstant.ACTION_TYPE_DELETE));
      }
    }
    moreMenuList.add(BottomTabModel(
        image: download,
        title: R.string().screenTitle.download,
        type: ActionMenuConstant.ACTION_TYPE_DOWNLOAD));
    moreMenuList.add(BottomTabModel(
        image: clearSelection,
        title: R.string().screenTitle.clearSelection,
        type: ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION));
    moreMenuList.add(BottomTabModel(
        image: share,
        title: R.string().screenTitle.share,
        type: ActionMenuConstant.ACTION_TYPE_SHARE));
    return moreMenuList;
  }

  List<BottomTabModel> getBottomMenuItems(int moduleType,
      {bool isDetail = false, bool isCompare = false}) {
    List<BottomTabModel> moreMenuList = [];

    switch (moduleType) {
      case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
        if (app
            .resolve<PrefUtils>()
            .getModulePermission(ModulePermissionConstant.permission_bid)
            .insert)
          moreMenuList.add(BottomTabModel(
              title: R.string().screenTitle.bidStone,
              isCenter: false,
              image: myBidWhite,
              type: ActionMenuConstant.ACTION_TYPE_BID));

        if (app
            .resolve<PrefUtils>()
            .getModulePermission(ModulePermissionConstant.permission_watchlist)
            .insert)
          moreMenuList.add(BottomTabModel(
              image: addToWatchlist,
              isCenter: false,
              title: R.string().screenTitle.addToWatchList,
              type: ActionMenuConstant.ACTION_TYPE_WISHLIST));
        moreMenuList.add(BottomTabModel(
            image: finalCalculation,
            isCenter: false,
            title: R.string().screenTitle.finalCalculation,
            type: ActionMenuConstant.ACTION_TYPE_FINAL_CALCULATION));
        if (!isDetail && !isCompare) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(ModulePermissionConstant.permission_compare)
              .view)
            moreMenuList.add(BottomTabModel(
                title: R.string().screenTitle.compare,
                isCenter: false,
                image: compare,
                type: ActionMenuConstant.ACTION_TYPE_COMPARE));
        }
        moreMenuList.add(BottomTabModel(
          title: R.string().commonString.more,
          isCenter: false,
          image: plusIcon,
          type: ActionMenuConstant.ACTION_TYPE_MORE,
        ));
        break;
      case DiamondModuleConstant.MODULE_TYPE_UPCOMING:
        if (!isDetail && !isCompare) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(ModulePermissionConstant.permission_compare)
              .view)
            moreMenuList.add(BottomTabModel(
                title: R.string().screenTitle.compare,
                isCenter: false,
                image: compare,
                type: ActionMenuConstant.ACTION_TYPE_COMPARE));
          moreMenuList.add(BottomTabModel(
              title: R.string().screenTitle.clearSelection,
              isCenter: false,
              image: clearSelectionWhite,
              type: ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION));
        }
        moreMenuList.add(BottomTabModel(
            title: R.string().screenTitle.share,
            isCenter: false,
            image: shareWhite,
            type: ActionMenuConstant.ACTION_TYPE_SHARE));
        moreMenuList.add(BottomTabModel(
            title: R.string().screenTitle.download,
            isCenter: false,
            image: downloadWhite,
            type: ActionMenuConstant.ACTION_TYPE_DOWNLOAD));
        break;

      case DiamondModuleConstant.MODULE_TYPE_FINAL_CALCULATION:
        if (app
            .resolve<PrefUtils>()
            .getModulePermission(ModulePermissionConstant.permission_order)
            .insert) {
          moreMenuList.add(BottomTabModel(
              image: placeOrder,
              title: R.string().screenTitle.placeOrder,
              isCenter: false,
              type: ActionMenuConstant.ACTION_TYPE_PLACE_ORDER));
        }
        moreMenuList.add(BottomTabModel(
            image: cancelStone,
            title: R.string().screenTitle.cancelStone,
            isCenter: false,
            type: ActionMenuConstant.ACTION_TYPE_CANCEL_STONE));
        moreMenuList.add(BottomTabModel(
            title: R.string().screenTitle.share,
            isCenter: false,
            image: shareWhite,
            type: ActionMenuConstant.ACTION_TYPE_SHARE));

        break;
      default:
        if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(
                  ModulePermissionConstant.permission_watchlist)
              .insert)
            moreMenuList.add(BottomTabModel(
                image: addToWatchlist,
                isCenter: false,
                title: R.string().screenTitle.addToWatchList,
                type: ActionMenuConstant.ACTION_TYPE_WISHLIST));
        }
        if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(ModulePermissionConstant.permission_enquiry)
              .insert)
            moreMenuList.add(BottomTabModel(
                image: enquiry,
                isCenter: false,
                title: R.string().screenTitle.enquiry,
                type: ActionMenuConstant.ACTION_TYPE_ENQUIRY));
        }
        if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_CART) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(ModulePermissionConstant.permission_cart)
              .insert)
            moreMenuList.add(BottomTabModel(
                image: addToCart,
                title: R.string().screenTitle.addToCart,
                isCenter: false,
                type: ActionMenuConstant.ACTION_TYPE_ADD_TO_CART));
        }

        if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY ||
            moduleType == DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST ||
            moduleType == DiamondModuleConstant.MODULE_TYPE_MY_CART ||
            moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER ||
            moduleType == DiamondModuleConstant.MODULE_TYPE_SEARCH) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(ModulePermissionConstant.permission_order)
              .insert)
            moreMenuList.add(BottomTabModel(
                image: placeOrder,
                title: R.string().screenTitle.buyNow,
                isCenter: false,
                type: ActionMenuConstant.ACTION_TYPE_PLACE_ORDER));
        }
        if (!isDiamondSearchModule(moduleType)) {
          if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
            if (app
                .resolve<PrefUtils>()
                .getModulePermission(ModulePermissionConstant.permission_offer)
                .insert)
              moreMenuList.add(BottomTabModel(
                  image: offerWhite,
                  title: R.string().screenTitle.offer,
                  isCenter: false,
                  type: ActionMenuConstant.ACTION_TYPE_OFFER));
          }
        }
        if (isDiamondSearchModule(moduleType) && isDetail) {
          if (app
              .resolve<PrefUtils>()
              .getModulePermission(ModulePermissionConstant.permission_offer)
              .insert)
            moreMenuList.add(BottomTabModel(
                image: offerWhite,
                title: R.string().screenTitle.offer,
                isCenter: false,
                type: ActionMenuConstant.ACTION_TYPE_OFFER));
        }
        if (!isCompare && !isDetail) {
          if (moduleType != DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION) {
            moreMenuList.add(BottomTabModel(
                title: R.string().commonString.status,
                isCenter: false,
                image: status,
                type: ActionMenuConstant.ACTION_TYPE_STATUS));
          }
        }

        moreMenuList.add(BottomTabModel(
          title: R.string().commonString.more,
          isCenter: false,
          image: plusIcon,
          type: ActionMenuConstant.ACTION_TYPE_MORE,
        ));
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
        title: R.string().screenTitle.statusHold);
    model.imageColor = appTheme.statusHold;
    moreMenuList.add(model);
    model = BottomTabModel(
        image: diamond,
        isCenter: false,
        title: R.string().screenTitle.statusOnMemo);
    model.imageColor = appTheme.statusOnMemo;
    moreMenuList.add(model);
    model = BottomTabModel(
        image: diamond,
        isCenter: false,
        title: R.string().screenTitle.statusAvailable);
    model.imageColor = appTheme.statusAvailable;
    moreMenuList.add(model);
    model = BottomTabModel(
        image: diamond,
        isCenter: false,
        title: R.string().screenTitle.statusNew);
    model.imageColor = appTheme.statusNew;
    moreMenuList.add(model);
    model = BottomTabModel(
        image: diamond,
        isCenter: false,
        title: R.string().screenTitle.statusOffer);
    model.imageColor = appTheme.statusOffer;
    moreMenuList.add(model);
    // model = BottomTabModel(
    //     image: diamond,
    //     isCenter: false,
    //     title: R.string().screenTitle.statusMyHold);
    // model.imageColor = appTheme.statusMyHold;
    // moreMenuList.add(model);

    return moreMenuList;
  }
}

bool isDiamondSearchModule(int moduleType) {
  switch (moduleType) {
    case DiamondModuleConstant.MODULE_TYPE_SEARCH:
    case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
    case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND:
    case DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL:
    case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
    case DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY:
    case DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH:
      return true;
    default:
      return false;
  }
}
