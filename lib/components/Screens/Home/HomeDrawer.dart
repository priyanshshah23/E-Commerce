import 'package:country_pickers/country_pickers.dart';
import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/Screens/Home/DrawerModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/LoginModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rxbus/rxbus.dart';

import '../../../app/app.export.dart';
import 'HomeScreen.dart';

/// The [Drawer] shown in the [HomeScreen].
///
/// It displays the logged in [User] on the top and allows to navigate to
/// different parts of the app and logout.
class HomeDrawer extends StatelessWidget {
  List<DrawerModel> drawerItems = DrawerSetting().getDrawerItems();

  Widget getDrawerItem(
      BuildContext context, DrawerModel model, VoidCallback callback) {
    return InkWell(
      onTap: callback,
      child: Column(
        children: [
          if (model.isShowUpperDivider)
            Container(
              margin: EdgeInsets.symmetric(vertical: getSize(10)),
              height: getSize(1),
              width: MathUtilities.screenWidth(context),
              color: appTheme.dividerColor.withOpacity(0.5),
            ),
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
                      color: model.imageColor != null ? model.imageColor : null,
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
                if (model.isShowCount && model.count > 0)
                  Container(
                    decoration: BoxDecoration(
                        color: model.countBackgroundColor,
                        borderRadius: BorderRadius.circular(
                          getSize(5),
                        )),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: getSize(6),
                          right: getSize(6),
                          top: getSize(4),
                          bottom: getSize(4)),
                      child: Text(
                        model.count.toString(),
                        style: appTheme.blackNormal14TitleColorblack.copyWith(
                          fontWeight: FontWeight.w500,
                          color: appTheme.whiteColor,
                        ),
                      ),
                    ),
                  ),
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

  List<Widget> getDrawerList(BuildContext context) {
    List<Widget> list = List<Widget>();

//    list.add(UserDrawerHeader());

    list.add(Container(
      color: appTheme.drawerTitleColor,
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: getSize(10),
              bottom: getSize(10),
              left: getSize(20),
              right: getSize(20),
            ),
            child: Image.asset(drawerLogo,
                width: getSize(22), height: getSize(22)),
          ),
          SizedBox(
            width: getSize(12),
          ),
          Text(
            R.string().commonString.diamNow,
            style: appTheme.blackNormal14TitleColorblack.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ));

    list.add(SizedBox(
      height: getSize(10),
    ));

    for (int i = 0; i < drawerItems.length; i++) {
      list.add(getDrawerItem(context, drawerItems[i], () {
        RxBus.post(DrawerEvent(drawerItems[i].type, true), tag: eventBusTag);
      }));
    }

    list.add(
      Container(
        child: Padding(
          padding: EdgeInsets.only(
              left: getSize(20), top: getSize(16), bottom: getSize(10)),
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
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          margin: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(getSize(26)),
                bottomRight: Radius.circular(getSize(26))),
            child: Drawer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(26)),
                  color: AppTheme.of(context).theme.primaryColor,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: Image.asset(bottomGradient),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // UserDrawerHeader(), // if you want to set static
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.fromLTRB(getSize(0),
                                  getSize(12), getSize(0), getSize(0)),
                              // color: AppTheme.of(context).theme.primaryColor,
                              child: ListView(
                                  padding: EdgeInsets.all(getSize(0)),
                                  //shrinkWrap: true,
                                  children: getDrawerList(context))),
                        )
                      ],
                    ),
                    //
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The [UserDrawerHeader] that contains information about the logged in [User].
class UserDrawerHeader extends StatelessWidget {
  // const UserDrawerHeader();

//this.user
  // User user;

  // @override
  // void initState() {
  //   super.initState();
  // }

  Future<void> _navigateToUserScreen() async {
    //await Navigator.of(context).maybePop();
    RxBus.post(DrawerEvent(DiamondModuleConstant.MODULE_TYPE_PROFILE, true),
        tag: eventBusTag);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.fromLTRB(
          getSize(20),
          getSize(26), // + statusbar height
          getSize(20),
          getSize(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAvatarRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarRow(BuildContext context) {
    return Material(
      // elevation: 10,
      // shadowColor: appTheme.shadowColor,
      borderRadius: BorderRadius.circular(getSize(5)),
      child: InkWell(
        onTap: () => _navigateToUserScreen(),
        child: Container(
          decoration: BoxDecoration(
            color: appTheme.whiteColor,
            borderRadius: BorderRadius.circular(getSize(5)),
            //  border: Border.all(color: appTheme.dividerColor),
            // boxShadow: [
            //   BoxShadow(
            //     color: appTheme.shadowColor,
            //     spreadRadius: 1,
            //     blurRadius: 20,
            //     offset: Offset(0, 3), // changes position of shadow
            //   ),
            // ],
          ),
          padding: EdgeInsets.only(
            top: getSize(20),
            bottom: getSize(20),
//          left: getSize(16),
            right: getSize(16),
          ),
          child: Column(
            children: <Widget>[
              Container(
                child: InkWell(
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
                            app.resolve<PrefUtils>().getUserDetails().photoId,
                            placeHolderImage: userTemp,
                            height: getSize(50),
                            width: getSize(50),
                            fit: BoxFit.cover,
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
                                  app
                                          .resolve<PrefUtils>()
                                          .getUserDetails()
                                          .getFullName() ??
                                      "",
                                  style: appTheme.black16TextStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Image.asset(
                                    cancel,
                                    height: getSize(18),
                                    width: getSize(18),
                                  ),
                                ),
                              ],
                            ),
//                        SizedBox(height: getSize(6)),
//                        if (isStringEmpty(app
//                                .resolve<PrefUtils>()
//                                .getUserDetails()
//                                .email) ==
//                            false)
//                          Row(
//                            children: [
//                              Image.asset(
//                                email,
//                                height: getSize(12),
//                                width: getSize(12),
//                              ),
//                              SizedBox(width: getSize(8)),
//                              Expanded(
//                                child: Text(
//                                  app
//                                          .resolve<PrefUtils>()
//                                          .getUserDetails()
//                                          .email ??
//                                      "-",
//                                  style: appTheme.black12TextStyle,
//                                ),
//                              ),
//                            ],
//                          ),
//                        SizedBox(height: getSize(6)),
//                        Row(
//                          children: [
//                            Image.asset(
//                              phone,
//                              height: getSize(14),
//                              width: getSize(12),
//                            ),
//                            SizedBox(width: getSize(8)),
//                            if (isStringEmpty(app
//                                    .resolve<PrefUtils>()
//                                    .getUserDetails()
//                                    .countryCode) ==
//                                false)
//                              Image.asset(
//                                CountryPickerUtils.getFlagImageAssetPath(
//                                    CountryPickerUtils.getCountryByPhoneCode(app
//                                            .resolve<PrefUtils>()
//                                            .getUserDetails()
//                                            .countryCode)
//                                        .isoCode),
//                                height: getSize(12),
//                                width: getSize(16),
//                                fit: BoxFit.fill,
//                                package: "country_pickers",
//                              ),
//                            SizedBox(width: getSize(8)),
//                            Text(
//                              app.resolve<PrefUtils>().getUserDetails().phone ??
//                                  "-",
//                              style: appTheme.black12TextStyle,
//                            ),
//                          ],
//                        ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
