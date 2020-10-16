import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/components/Screens/Home/DrawerModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';

class DrawerSetting{
   List<DrawerModel> getDrawerItems() {
     List<DrawerModel>drawerList=[];
     drawerList.add( DrawerModel(
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
      *//*DrawerModel(
        image: drawer_logout,
        title: R.string().screenTitle.logout,
        isSelected: false,
        type: DrawerConstant.LOGOUT,
      ),*//*
    ];*/
  }

  List<DrawerModel> getMoreMenuItems(){
     List<DrawerModel> moreMenuList = [];
      moreMenuList.add(DrawerModel(
        image:
      ));
  }
}