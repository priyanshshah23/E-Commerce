import 'dart:collection';
import 'dart:io';

import 'package:country_pickers/country_pickers.dart';
import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/Screens/Auth/ChangePassword.dart';
import 'package:diamnow/components/Screens/Auth/ProfileList.dart';
import 'package:diamnow/components/Screens/Auth/SignInWithMPINScreen.dart';
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
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
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
  bool isSwitchedTouchId = false, isSwitchedMpin = false;
  List<BiometricType> availableBiometrics;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isSwitchedTouchId = app.resolve<PrefUtils>().getBiometrcis() ?? false;
      isSwitchedMpin = app.resolve<PrefUtils>().getMpin() ?? false;
      availableBiometrics = await auth.getAvailableBiometrics();
      setState(() {});
    });
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
        case DiamondModuleConstant.MODULE_TYPE_CHANGEMPIN:
          changeMPin();
          break;
      }
      if (type != DiamondModuleConstant.MODULE_TYPE_LOGOUT) {
        setState(() {});
      }
    }
  }

  changeMPin() {
    Map<String, dynamic> arguments = {};
    arguments["enm"] = Mpin.changeMpin;
    arguments["askForVerifyMpin"] = true;
    arguments["verifyPinCallback"] = () {
      Map<String, dynamic> arguments = {};
      arguments["enm"] = Mpin.changeMpin;
      NavigationUtilities.pushRoute(SignInWithMPINScreen.route,
          args: arguments);
    };
    NavigationUtilities.pushRoute(SignInWithMPINScreen.route, args: arguments);
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
                  style: appTheme.blackNormal16TitleColorblack,
                ),
                Spacer(),
                returnWidgetAsPerModule(model),
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

  Widget returnWidgetAsPerModule(DrawerModel model) {
    if (model.type == DiamondModuleConstant.MODULE_TYPE_LOGOUT) {
      return SizedBox();
    }
    if (model.type == DiamondModuleConstant.MODULE_TYPE_TOUCH_ID) {
      return InkWell(
        onTap: () {},
        child: SizedBox(
          height: getSize(30),
          child: Switch(
            value: isSwitchedTouchId,
            onChanged: (value) {
              setState(() {
                // if (isSwitchedMpin) isSwitchedMpin = false;
                isSwitchedTouchId = !isSwitchedTouchId;

                if (isSwitchedTouchId == true) {
                  askForBioMetrics();
                }
              });
            },
            activeTrackColor: appTheme.borderColor,
            activeColor: appTheme.colorPrimary,
          ),
        ),
      );
    }

    if (model.type == DiamondModuleConstant.MODULE_TYPE_MPIN) {
      return InkWell(
        onTap: () {},
        child: SizedBox(
          height: getSize(30),
          child: Switch(
            value: isSwitchedMpin,
            onChanged: (value) {
              setState(() {
                // if (isSwitchedTouchId)
                //   isSwitchedTouchId = false;
                isSwitchedMpin = !isSwitchedMpin;

                if (isSwitchedMpin == true) {
                  askForMpin();
                } else {
                  app.resolve<PrefUtils>().setMpinisUsage(false);
                }
              });
            },
            activeTrackColor: appTheme.borderColor,
            activeColor: appTheme.colorPrimary,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: getSize(20),
        right: getSize(20),
      ),
      child: Container(
        child: Icon(
          Icons.arrow_forward_ios,
          size: getSize(14),
        ),
      ),
    );
  }

  askForBioMetrics() async {
    if (!isNullEmptyOrFalse(availableBiometrics)) {
      try {
        bool isAuthenticated = await auth.authenticateWithBiometrics(
          localizedReason:
              Platform.isIOS && availableBiometrics.contains(BiometricType.face)
                  ? R.string.commonString.enableFaceId
                  : R.string.commonString.enableTouchId,
          useErrorDialogs: false,
          stickyAuth: false,
        );
        if (isAuthenticated) {
          app.resolve<PrefUtils>().setBiometrcisUsage(true);
          app.resolve<PrefUtils>().setMpinisUsage(false);
          setState(() {
            isSwitchedTouchId = true;
            isSwitchedMpin = false;
          });
        } else {
          setState(() {
            isSwitchedTouchId = false;
          });
        }
      } on PlatformException catch (_) {
        setState(() {
          isSwitchedTouchId = false;
        });
      }
    } else {
      List<BiometricType> availableBiometrics;
      if (isNullEmptyOrFalse(availableBiometrics)) {
        showToast(
            "FaceId/TouchId is not enabled in your phone, Please enable to use this feature",
            context: context);
      }
      setState(() {
        isSwitchedTouchId = false;
      });
    }
  }

  askForMpin() async {
    Map<String, dynamic> args = {};
    args["askForVerifyMpin"] = true;
    args["enm"] = Mpin.myAccount;
    args["verifyPinCallback"] = () {
      print("Verified");
      isSwitchedMpin = true;
      isSwitchedTouchId = false;
      app.resolve<PrefUtils>().setMpinisUsage(true);
      app.resolve<PrefUtils>().setBiometrcisUsage(false);
      setState(() {});
    };

    NavigationUtilities.pushRoute(SignInWithMPINScreen.route, args: args);
    isSwitchedMpin = false;
    setState(() {});
    //
    // if (!isNullEmptyOrFalse(availableBiometrics)) {
    //   try {
    //     bool isAuthenticated = await auth.authenticateWithBiometrics(
    //       localizedReason:
    //           Platform.isIOS && availableBiometrics.contains(BiometricType.face)
    //               ? R.string().commonString.enableFaceId
    //               : R.string().commonString.enableTouchId,
    //       useErrorDialogs: false,
    //       stickyAuth: false,
    //     );
    //     if (isAuthenticated) {
    //       app.resolve<PrefUtils>().setBiometrcisUsage(true);
    //       setState(() {
    //         isSwitchedTouchId = true;
    //       });
    //     } else {
    //       setState(() {
    //         isSwitchedTouchId = false;
    //       });
    //     }
    //   } on PlatformException catch (_) {
    //     setState(() {
    //       isSwitchedTouchId = false;
    //     });
    //   }
    // } else {
    //   List<BiometricType> availableBiometrics;
    //   if (isNullEmptyOrFalse(availableBiometrics)) {
    //     showToast(
    //         "FaceId/TouchId is not enabled in your phone, Please enable to use this feature",
    //         context: context);
    //   }
    //   setState(() {
    //     isSwitchedTouchId = false;
    //   });
    // }
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
                              style: appTheme.blackMedium16TitleColorblack
                                  .copyWith(
                                fontWeight: FontWeight.w600,
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
                                style: appTheme.black14TextStyle,
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
                              style: appTheme.black14TextStyle,
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
        R.string.screenTitle.myAccount,
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
