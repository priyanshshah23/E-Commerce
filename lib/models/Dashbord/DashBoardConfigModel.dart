import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/material.dart';

class DashboardConfig {
  List<DashbordTopSection> arrTopSection;

  // List<BottomTabModel> arrBottomTab;
  // List<BottomTabModel> arrStatusMenu;
  // BottomMenuSetting bottomMenuSetting;
  // List<BottomTabModel> toolbarList = [];

  DashboardConfig();

  initItems({bool isDetail = false}) {
    arrTopSection = getTopSectionArr();
  }

  List<DashbordTopSection> getTopSectionArr() {
    List<DashbordTopSection> arr = List<DashbordTopSection>();
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_newGoods)
        .view)
      arr.add(DashbordTopSection(
        title: R.string.screenTitle.newArrival,
        value: "0",
        image: home_newArrival,
        bgImage: home_newArrivalBg,
        type: DiamondModuleConstant.MODULE_TYPE_NEW_ARRIVAL,
        sequence: 1,
        bgColor: fromHex("#E2F7FC"),
        textColor: fromHex("#2193B0"),
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(
            ModulePermissionConstant.permission_stone_of_the_day)
        .view)
      arr.add(DashbordTopSection(
        title: R.string.screenTitle.stoneOfTheDays,
        value: "0",
        image: home_stoneoftheday,
        bgImage: home_stoneofthedayBg,
        type: DiamondModuleConstant.MODULE_TYPE_STONE_OF_THE_DAY,
        sequence: 2,
        bgColor: fromHex("#FFE7DC"),
        textColor: fromHex("#E04300"),
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_watchlist)
        .view)
      arr.add(DashbordTopSection(
        title: R.string.screenTitle.watchlist,
        value: "0",
        image: home_watchlist,
        bgImage: home_watchlistBg,
        type: DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST,
        sequence: 3,
        bgColor: fromHex("#DAF5E7"),
        textColor: fromHex("#288F5A"),
      ));
    if (app
        .resolve<PrefUtils>()
        .getModulePermission(ModulePermissionConstant.permission_cart)
        .view)
      arr.add(DashbordTopSection(
        title: R.string.screenTitle.myCart,
        value: "0",
        image: home_cart,
        bgImage: home_cartBg,
        type: DiamondModuleConstant.MODULE_TYPE_MY_CART,
        sequence: 4,
        bgColor: fromHex("#FFF6D6"),
        textColor: fromHex("#B89000"),
      ));

    return arr;
  }
}

class DashbordTopSection {
  String title;
  String value;
  String image;
  String bgImage;
  int type;
  int sequence;
  Color bgColor;
  Color textColor;

  DashbordTopSection({
    this.title,
    this.value,
    this.image,
    this.bgImage,
    this.sequence,
    this.type,
    this.bgColor,
    this.textColor,
  });
}
