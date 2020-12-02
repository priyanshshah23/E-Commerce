import 'dart:collection';

import 'package:country_pickers/country_pickers.dart';
import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/Screens/Auth/ChangePassword.dart';
import 'package:diamnow/components/Screens/Auth/ProfileList.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Home/DrawerModel.dart';
import 'package:diamnow/components/Screens/Home/HomeDrawer.dart';
import 'package:diamnow/components/Screens/Home/HomeScreen.dart';
import 'package:diamnow/components/Screens/MyDemand/MyDemandScreen.dart';
import 'package:diamnow/components/Screens/Order/OrderListScreen.dart';
import 'package:diamnow/components/Screens/SavedSearch/SavedSearchScreen.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:flutter/material.dart';
import 'package:rxbus/rxbus.dart';

class MyAccountScreen extends StatefulWidget {
  static const route = "MyAccountScreen";
  bool isFromDrawer;

  MyAccountScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.IsFromDrawer] != null) {
        isFromDrawer = arguments[ArgumentConstant.IsFromDrawer];
      }
    }
  }

  @override
  _MyAccountScreenState createState() =>
      _MyAccountScreenState(isFromDrawer: isFromDrawer);
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  List<DrawerModel> accountItems = DrawerSetting().getAccountListItems();
  bool isFromDrawer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  _MyAccountScreenState({this.isFromDrawer = false});

  manageDrawerClick(BuildContext context, int type, bool isPop) {
    if (context != null) {
      if (isPop) Navigator.pop(context);
//      if (selectedType == type) {
//        return;
//      }

      switch (type) {
        case DiamondModuleConstant.MODULE_TYPE_MY_ORDER:
        case DiamondModuleConstant.MODULE_TYPE_MY_PURCHASE:
          openDiamondOrderList(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_WATCH_LIST:
        case DiamondModuleConstant.MODULE_TYPE_MY_CART:
        case DiamondModuleConstant.MODULE_TYPE_MY_BID:
        case DiamondModuleConstant.MODULE_TYPE_MY_HOLD:
        case DiamondModuleConstant.MODULE_TYPE_MY_ENQUIRY:
        case DiamondModuleConstant.MODULE_TYPE_MY_OFFICE:
        case DiamondModuleConstant.MODULE_TYPE_MY_OFFER:
        case DiamondModuleConstant.MODULE_TYPE_MY_REMINDER:
        case DiamondModuleConstant.MODULE_TYPE_MY_COMMENT:
          openDiamondList(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_MY_DEMAND:
          openMyDemand(type);
          break;
        case DiamondModuleConstant.MODULE_TYPE_MANAGE_ADDRESS:
          break;
        case DiamondModuleConstant.MODULE_TYPE_CHANGE_PASSWORD:
          NavigationUtilities.pushRoute(ChangePassword.route);
          break;
        case DiamondModuleConstant.MODULE_TYPE_LOGOUT:
          logoutFromApp(context);
          break;
        case DiamondModuleConstant.MODULE_TYPE_PROFILE:
          openProfile();
          break;
      }
      if (type != DiamondModuleConstant.MODULE_TYPE_LOGOUT) {
        setState(() {});
      }
    }
  }

  openDiamondOrderList(int moduleType) {
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = moduleType;
    dict[ArgumentConstant.IsFromDrawer] = false;
    NavigationUtilities.pushRoute(OrderListScreen.route, args: dict);
  }

  openMyDemand(int moduleType) {
    // selectedType = moduleType;
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = moduleType;
    dict[ArgumentConstant.IsFromDrawer] = false;
    NavigationUtilities.pushRoute(MyDemandScreen.route, args: dict);
    // currentWidget = MyDemandScreen(dict);
  }

  openSavedSearch(int moduleType) {
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] =
        DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
    dict[ArgumentConstant.IsFromDrawer] = false;
    NavigationUtilities.pushRoute(SavedSearchScreen.route, args: dict);
  }

  openProfile() {
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.IsFromDrawer] = false;
    NavigationUtilities.pushRoute(MyAccountScreen.route, args: dict);
  }

  Widget getDrawerItem(
      BuildContext context, DrawerModel model, VoidCallback callback) {
    return InkWell(
      onTap: callback,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: getSize(20),
              right: getSize(20),
            ),
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(top: getSize(10), bottom: getSize(10)),
                  child: Image.asset(model.image,
                      // color: model.imageColor != null ? model.imageColor : null,
                      width: getSize(22),
                      height: getSize(22)),
                ),
                SizedBox(
                  width: getSize(12),
                ),
                Text(
                  model.title,
                  style: appTheme.blackNormal14TitleColorblack.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Container(
                    child: Icon(
                  Icons.arrow_forward_ios,
                  size: getSize(14),
                )),
              ],
            ),
          ),
          if (model.isShowDivider)
            Container(
              margin: EdgeInsets.symmetric(vertical: getSize(10)),
              height: getSize(1),
              width: MathUtilities.screenWidth(context),
              color: appTheme.dividerColor.withOpacity(0.5),
            )
        ],
      ),
    );
  }

  Widget _buildAvatarRow(BuildContext context) {
    User userAccount = app.resolve<PrefUtils>().getUserDetails();
    return InkWell(
      onTap: () {
        Map<String, dynamic> dict = new HashMap();
        dict[ArgumentConstant.IsFromDrawer] = false;
        NavigationUtilities.pushRoute(ProfileList.route, args: dict)
            .then((value) {
          setState(() {});
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          border: Border(bottom: BorderSide(color: appTheme.dividerColor)),
        ),
        padding: EdgeInsets.only(
          top: getSize(20),
          bottom: getSize(20),
          left: getSize(16),
          right: getSize(16),
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // circle avatar
                  Container(
                    height: getSize(50),
                    width: getSize(50),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.all(Radius.circular(getSize(25))),
                      child: getImageView(
                        userAccount.profileImage,
                        placeHolderImage: placeHolder,
                        fit: BoxFit.cover,
                        height: getSize(50),
                        width: getSize(50),
                      ),
                    ),
                  ),
                  SizedBox(width: getSize(10)),
                  //username
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              userAccount.getFullName() ?? "-",
                              style: appTheme.black16TextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: getSize(6)),
                        if (isStringEmpty(userAccount.email) == false)
                          Row(
                            children: [
                              Image.asset(
                                email,
                                height: getSize(12),
                                width: getSize(12),
                              ),
                              SizedBox(width: getSize(8)),
                              Text(
                                userAccount.email ?? "-",
                                style: appTheme.black12TextStyle,
                              ),
                            ],
                          ),
                        SizedBox(height: getSize(6)),
                        Row(
                          children: [
                            Image.asset(
                              phone,
                              height: getSize(14),
                              width: getSize(12),
                            ),
                            SizedBox(width: getSize(8)),
                            if (isStringEmpty(app
                                    .resolve<PrefUtils>()
                                    .getUserDetails()
                                    .countryCode) ==
                                false)
                              Image.asset(
                                CountryPickerUtils.getFlagImageAssetPath(
                                    CountryPickerUtils.getCountryByPhoneCode(
                                            userAccount.countryCode)
                                        .isoCode),
                                height: getSize(12),
                                width: getSize(16),
                                fit: BoxFit.fill,
                                package: "country_pickers",
                              ),
                            SizedBox(width: getSize(8)),
                            Text(
                              userAccount.mobile ?? "-",
                              style: appTheme.black12TextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getDrawerList(BuildContext context) {
    List<Widget> list = List<Widget>();

    list.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildAvatarRow(context),
      ],
    ));

    list.add(SizedBox(
      height: getSize(10),
    ));

    for (int i = 0; i < accountItems.length; i++) {
      list.add(getDrawerItem(context, accountItems[i], () {
        manageDrawerClick(context, accountItems[i].type, false);
      }));
    }

    list.add(
      Container(
        child: Padding(
          padding: EdgeInsets.only(
              left: getSize(20), top: getSize(16), bottom: getSize(30)),
          child: Text(
            "App Version 1.0.0",
            style: appTheme.blackNormal12TitleColorblack.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context,
        R.string().screenTitle.myAccount,
        bgColor: appTheme.whiteColor,
        leadingButton: isFromDrawer
            ? getDrawerButton(context, true)
            : getBackButton(context),
        centerTitle: false,
      ),
      body: Container(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(getSize(26)),
              bottomRight: Radius.circular(getSize(26))),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(26)),
              color: AppTheme.of(context).theme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // UserDrawerHeader(), // if you want to set static
                Expanded(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(
                          getSize(0), getSize(0), getSize(0), getSize(0)),
                      // color: AppTheme.of(context).theme.primaryColor,
                      child: ListView(
                          padding: EdgeInsets.all(getSize(0)),
                          //shrinkWrap: true,
                          children: getDrawerList(context))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  openDiamondList(int moduleType) {
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = moduleType;
    dict[ArgumentConstant.IsFromDrawer] = false;
    NavigationUtilities.pushRoute(DiamondListScreen.route, args: dict);
  }

  openMyWatchList(int type) {
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = type;
    dict[ArgumentConstant.IsFromDrawer] = false;
    NavigationUtilities.pushRoute(DiamondListScreen.route, args: dict);
  }

  openMyOffer(int type) {
    Map<String, dynamic> dict = new HashMap();
    dict[ArgumentConstant.ModuleType] = type;
    dict[ArgumentConstant.IsFromDrawer] = false;
    NavigationUtilities.pushRoute(DiamondListScreen.route, args: dict);
  }
}
