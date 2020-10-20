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
      title: "Home",
      isSelected: true,
      type: DrawerConstant.HOME,
    ));
    drawerList.add(DrawerModel(
      image: search,
      title: "Search",
      isSelected: true,
      type: DrawerConstant.MODULE_SEARCH,
    ));
    drawerList.add(DrawerModel(
      image: search,
      title: "Upcoming",
      isSelected: false,
      type: DrawerConstant.MODULE_UPCOMING,
    ));
    drawerList.add(DrawerModel(
      image: search,
      title: R.string().screenTitle.myProfile,
      isSelected: false,
      type: DrawerConstant.MODULE_PROFILE,
    ));
    drawerList.add(DrawerModel(
      image: password,
      title: R.string().screenTitle.logout,
      isSelected: false,
      type: DrawerConstant.LOGOUT,
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
  List<BottomTabModel> getMoreMenuItems({bool isDetail = false}) {
    List<BottomTabModel> moreMenuList = [];
    moreMenuList.add(BottomTabModel(
        image: enquiry,
        title: R.string().screenTitle.enquiry,
        type: ActionMenuConstant.ACTION_TYPE_ENQUIRY));
    moreMenuList.add(BottomTabModel(
        image: placeOrder,
        title: R.string().screenTitle.placeOrder,
        type: ActionMenuConstant.ACTION_TYPE_PLACE_ORDER));
    moreMenuList.add(BottomTabModel(
        image: addToCart,
        title: R.string().screenTitle.addToCart,
        type: ActionMenuConstant.ACTION_TYPE_ADD_TO_CART));
    moreMenuList.add(BottomTabModel(
        image: addToWatchlist,
        title: R.string().screenTitle.addToWatchList,
        type: ActionMenuConstant.ACTION_TYPE_WISHLIST));
    moreMenuList.add(BottomTabModel(
        image: comment,
        title: R.string().screenTitle.comment,
        type: ActionMenuConstant.ACTION_TYPE_COMMENT));
    moreMenuList.add(BottomTabModel(
        image: offer,
        title: R.string().screenTitle.offer,
        type: ActionMenuConstant.ACTION_TYPE_OFFER));
    moreMenuList.add(BottomTabModel(
        image: company,
        title: R.string().screenTitle.officeView,
        type: ActionMenuConstant.ACTION_TYPE_APPOINTMENT));
    moreMenuList.add(BottomTabModel(
        image: hold,
        title: R.string().screenTitle.hold,
        type: ActionMenuConstant.ACTION_TYPE_HOLD));
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

  List<BottomTabModel> getBottomMenuItems(int moduleType,{bool isDetail = false}) {
    List<BottomTabModel> moreMenuList = [];
    if(moduleType!=DiamondModuleConstant.MODULE_TYPE_SEARCH)
    moreMenuList.add(BottomTabModel(
        image: enquiry,
        isCenter: false,
        title: R.string().screenTitle.enquiry,
        type: ActionMenuConstant.ACTION_TYPE_ENQUIRY));
    moreMenuList.add(BottomTabModel(
        image: addToWatchlist,
        isCenter: false,
        title: R.string().screenTitle.addToWatchList,
        type: ActionMenuConstant.ACTION_TYPE_WISHLIST));
    moreMenuList.add(BottomTabModel(
        image: addToCart,
        title: R.string().screenTitle.addToCart,
        isCenter: false,
        type: ActionMenuConstant.ACTION_TYPE_ADD_TO_CART));
    if (isDetail) {
      moreMenuList.add(BottomTabModel(
          image: offer,
          title: R.string().screenTitle.offer,
          isCenter: false,
          type: ActionMenuConstant.ACTION_TYPE_OFFER));
    }
    if (!isDetail) {
      moreMenuList.add(BottomTabModel(
          title: R.string().commonString.status,
          isCenter: false,
          image: status,
          type: ActionMenuConstant.ACTION_TYPE_STATUS));
    }
    moreMenuList.add(BottomTabModel(
      title: R.string().commonString.more,
      isCenter: false,
      image: plusIcon,
      type: ActionMenuConstant.ACTION_TYPE_MORE,
    ));

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
