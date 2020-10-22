import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Home/DrawerModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';

class DrawerSetting {
  List<DrawerModel> getDrawerItems() {
    List<DrawerModel> drawerList = [];
    drawerList.add(DrawerModel(
      image: home,
      title: R.string().screenTitle.home,
      isSelected: true,
      type: DiamondModuleConstant.MODULE_TYPE_HOME,
    ));
    drawerList.add(DrawerModel(
      image: drawerSearch,
      title: R.string().screenTitle.search,
      isSelected: true,
      type: DiamondModuleConstant.MODULE_TYPE_SEARCH,
    ));
    drawerList.add(DrawerModel(
      image: quickSearch,
      title: R.string().screenTitle.quickSearch,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH,
    ));

    drawerList.add(DrawerModel(
      image: newArrival,
      title: R.string().screenTitle.newArrival,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL,
      isShowCount: true,
      countBackgroundColor: fromHex("#2193B0"),
      count: 250,
    ));

    drawerList.add(DrawerModel(
      image: exclusiveDiamonds,
      title: R.string().screenTitle.exclusiveDiamonds,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND,
      isShowCount: true,
      countBackgroundColor: fromHex("#288F5A"),
      count: 25,
    ));

    drawerList.add(DrawerModel(
      image: diamondOnAuction,
      title: R.string().screenTitle.diamondOnAuction,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION,
      isShowCount: true,
      countBackgroundColor: fromHex("#9C2AC4"),
      count: 50,
    ));

    drawerList.add(DrawerModel(
      image: stoneOfTheDay,
      title: R.string().screenTitle.stoneOfTheDays,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY,
      isShowCount: true,
      countBackgroundColor: fromHex("#003365"),
      count: 15,
    ));

    drawerList.add(DrawerModel(
      image: diamond,
      title: R.string().screenTitle.upcoming,
      imageColor: appTheme.colorPrimary,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_UPCOMING,
    ));
    drawerList.add(DrawerModel(
      image: enquiry,
      title: R.string().screenTitle.myEnquiry,
      imageColor: appTheme.colorPrimary,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY,
    ));
    drawerList.add(DrawerModel(
      image: myWatchlist,
      title: R.string().screenTitle.myWatchlist,
      imageColor: appTheme.colorPrimary,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST,
    ));

    drawerList.add(DrawerModel(
        image: addToCart,
        title: R.string().screenTitle.myCart,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_MY_CART));
    drawerList.add(DrawerModel(
        image: comment,
        title: R.string().screenTitle.myComment,
        imageColor: appTheme.colorPrimary,
        isSelected: false,
        type: DiamondModuleConstant.MODULE_TYPE_MY_COMMENT));

    drawerList.add(DrawerModel(
      image: myBid,
      title: R.string().screenTitle.myBid,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_MY_BID,
    ));

    drawerList.add(DrawerModel(
      image: myHold,
      title: R.string().screenTitle.myHold,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_MY_HOLD,
    ));

    drawerList.add(DrawerModel(
      image: myOrder,
      title: R.string().screenTitle.myOrder,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_MY_ORDER,
    ));

    drawerList.add(DrawerModel(
      image: myOffice,
      title: R.string().screenTitle.myOffice,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_MY_OFFICE,
    ));

    drawerList.add(DrawerModel(
      image: myOffer,
      title: R.string().screenTitle.myOffer,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_MY_OFFER,
    ));

    drawerList.add(DrawerModel(
      image: myPurchased,
      title: R.string().screenTitle.myPurchased,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_MY_PURCHASE,
    ));

    drawerList.add(DrawerModel(
      image: mySavedSearch,
      title: R.string().screenTitle.mySavedSearch,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH,
    ));

    drawerList.add(DrawerModel(
      image: myDemand,
      title: R.string().screenTitle.myDemand,
      isSelected: false,
      type: DiamondModuleConstant.MODULE_TYPE_MY_DEMAND,
    ));
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
    drawerList.add(DrawerModel(
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
    ));
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
}

class BottomMenuSetting {
  int moduleType;

  BottomMenuSetting(this.moduleType);

  List<BottomTabModel> getMoreMenuItems(
      {bool isDetail = false, bool isCompare = false}) {
    List<BottomTabModel> moreMenuList = [];
    if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_ORDER)
      moreMenuList.add(BottomTabModel(
          image: placeOrder,
          title: R.string().screenTitle.placeOrder,
          type: ActionMenuConstant.ACTION_TYPE_PLACE_ORDER));
    if (!isDetail && !isCompare)
      moreMenuList.add(BottomTabModel(
          image: compare,
          title: R.string().screenTitle.compare,
          type: ActionMenuConstant.ACTION_TYPE_COMPARE));
    moreMenuList.add(BottomTabModel(
        image: comment,
        title: R.string().screenTitle.comment,
        type: ActionMenuConstant.ACTION_TYPE_COMMENT));
    if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFER)
      moreMenuList.add(BottomTabModel(
          image: offer,
          title: R.string().screenTitle.offer,
          type: ActionMenuConstant.ACTION_TYPE_OFFER));
    if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFICE)
      moreMenuList.add(BottomTabModel(
          image: company,
          title: R.string().screenTitle.officeView,
          type: ActionMenuConstant.ACTION_TYPE_APPOINTMENT));
    /* moreMenuList.add(BottomTabModel(
        image: hold,
        title: R.string().screenTitle.hold,
        type: ActionMenuConstant.ACTION_TYPE_HOLD));*/
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
      case DiamondModuleConstant.MODULE_TYPE_UPCOMING:
        if (!isDetail && !isCompare) {
          moreMenuList.add(BottomTabModel(
              title: R.string().screenTitle.compare,
              isCenter: false,
              image: compare,
              type: ActionMenuConstant.ACTION_TYPE_COMPARE));
          moreMenuList.add(BottomTabModel(
              title: R.string().screenTitle.clearSelection,
              isCenter: false,
              image: clearSelection,
              type: ActionMenuConstant.ACTION_TYPE_CLEAR_SELECTION));
        }
        moreMenuList.add(BottomTabModel(
            title: R.string().screenTitle.share,
            isCenter: false,
            image: share,
            type: ActionMenuConstant.ACTION_TYPE_SHARE));
        moreMenuList.add(BottomTabModel(
            title: R.string().screenTitle.download,
            isCenter: false,
            image: download,
            type: ActionMenuConstant.ACTION_TYPE_DOWNLOAD));
        break;
      default:
        if (moduleType == DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL) {
          moreMenuList.add(BottomTabModel(
              title: R.string().screenTitle.bidStone,
              isCenter: false,
              image: myBid,
              type: ActionMenuConstant.ACTION_TYPE_BID));
        }
        if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY)
          moreMenuList.add(BottomTabModel(
              image: enquiry,
              isCenter: false,
              title: R.string().screenTitle.enquiry,
              type: ActionMenuConstant.ACTION_TYPE_ENQUIRY));
        if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST)
          moreMenuList.add(BottomTabModel(
              image: addToWatchlist,
              isCenter: false,
              title: R.string().screenTitle.addToWatchList,
              type: ActionMenuConstant.ACTION_TYPE_WISHLIST));
        if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_CART)
          moreMenuList.add(BottomTabModel(
              image: addToCart,
              title: R.string().screenTitle.addToCart,
              isCenter: false,
              type: ActionMenuConstant.ACTION_TYPE_ADD_TO_CART));

        if (moduleType == DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY ||
            moduleType == DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST ||
            moduleType == DiamondModuleConstant.MODULE_TYPE_MY_CART ||
            moduleType == DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
          moreMenuList.add(BottomTabModel(
              image: placeOrder,
              title: R.string().screenTitle.placeOrder,
              isCenter: false,
              type: ActionMenuConstant.ACTION_TYPE_PLACE_ORDER));
        }
        if (!isDiamondSearchModule(moduleType)) {
          if (moduleType != DiamondModuleConstant.MODULE_TYPE_MY_OFFER) {
            moreMenuList.add(BottomTabModel(
                image: offer,
                title: R.string().screenTitle.offer,
                isCenter: false,
                type: ActionMenuConstant.ACTION_TYPE_OFFER));
          }
        }
        if (isDiamondSearchModule(moduleType) && isDetail) {
          moreMenuList.add(BottomTabModel(
              image: offer,
              title: R.string().screenTitle.offer,
              isCenter: false,
              type: ActionMenuConstant.ACTION_TYPE_OFFER));
        }
        if (!isCompare && !isDetail && isDiamondSearchModule(moduleType)) {
          if (moduleType != DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL) {
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
    moreMenuList.forEach((element) {
      element.imageColor = appTheme.whiteColor;
    });

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
    model = BottomTabModel(
        image: diamond,
        isCenter: false,
        title: R.string().screenTitle.statusMyHold);
    model.imageColor = appTheme.statusMyHold;
    moreMenuList.add(model);

    return moreMenuList;
  }
}

bool isDiamondSearchModule(int moduleType) {
  switch (moduleType) {
    case DiamondModuleConstant.MODULE_TYPE_SEARCH:
    case DiamondModuleConstant.MODULE_TYPE_DIAMOND_AUCTION:
    case DiamondModuleConstant.MODULE_TYPE_EXCLUSIVE_DIAMOND:
    case DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL:
    case DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY:
    case DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH:
      return true;
    default:
      return false;
  }
}
