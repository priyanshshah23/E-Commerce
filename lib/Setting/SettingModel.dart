import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Home/DrawerModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';

class DrawerSetting {
  List<DrawerModel> getDrawerItems() {
    List<DrawerModel> drawerList = [];
    drawerList.add(DrawerModel(
      image: search,
      title: "Search",
      isSelected: true,
      type: DrawerConstant.MODULE_SEARCH,
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
  List<BottomTabModel> getMoreMenuItems() {
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
        image: addToCart,
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
        type: ActionMenuConstant.ACTION_TYPE_OFFER_VIEW));
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
}
