import 'dart:async';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxbus/rxbus.dart';

import 'HomeDrawer.dart';

/// The [HomeScreen] showing after a user has logged in.
///
class DrawerEvent {
  int index;
  bool isPop;

  DrawerEvent(this.index, this.isPop);
}

class HomeScreen extends StatefulWidget {
  static const route = "home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isExpand = false;
  bool isSwitched = false;
  double bottomPadding = 0;
  Widget currentWidget;
  int selectedType = DrawerConstant.MODULE_SEARCH;

  @override
  void initState() {
    super.initState();
    //SocketManager.instance.connect();
    currentWidget = FilterScreen();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      RxBus.register<DrawerEvent>(tag: eventBusTag).listen((event) {
        if (event.index == DrawerConstant.OPEN_DRAWER) {
          _scaffoldKey?.currentState?.openDrawer();
        } else {
          manageDrawerClick(context, event.index, event.isPop);
        }
      });
      RxBus.register<bool>(tag: eventBusLogout).listen((event) {
        //app.resolve<PrefUtils>().resetAndLogout(context);
      });

      /*Timer(
        Duration(seconds: 2),
        () => (checkVersionUpdate(context)),
      );*/
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop(BuildContext context) {
    if (!Navigator.of(context).canPop()) {
      if (true) {
        app.resolve<CustomDialogs>().confirmDialog(context,
            title: APPNAME,
            desc: R.string().commonString.lblAppExit,
            positiveBtnTitle: R.string().commonString.lblExit,
            negativeBtnTitle: R.string().commonString.cancel,
            onClickCallback: (btnType) {
          if (btnType == ButtonType.PositveButtonClick) {
            //  Navigator.pop(context);
            SystemNavigator.pop();
          }
        });
      } else {
        manageDrawerClick(context, DrawerConstant.MODULE_SEARCH, false);
      }
    } else {
      return Future.value(true);
    }
  }

  openSearch() {
    selectedType = DrawerConstant.MODULE_SEARCH;
    currentWidget = FilterScreen();
  }

  manageDrawerClick(BuildContext context, int type, bool isPop) {
    if (context != null) {
      if (isPop) Navigator.pop(context);
      if (selectedType == type) {
        return;
      }
      switch (type) {
        case DrawerConstant.MODULE_SEARCH:
          openSearch();
          break;

        case DrawerConstant.LOGOUT:
          logout(context);
          break;
      }
      if (type != DrawerConstant.LOGOUT) {
        setState(() {});
      }
    }
  }

  logout(BuildContext context) {
    app.resolve<CustomDialogs>().confirmDialog(context,
        title: R.string().commonString.lbllogout,
        desc: R.string().authStrings.logoutConfirmationMsg,
        positiveBtnTitle: R.string().commonString.yes,
        negativeBtnTitle: R.string().commonString.no,
        onClickCallback: (buttonType) {
      if (buttonType == ButtonType.PositveButtonClick) {
        calllogout(context);
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        ThemeSettingsModel.of(context).updateSystemUi(isLogin: true);
      }
    });
  }

  calllogout(BuildContext context) {
    /*NetworkCall<BaseApiResp>()
        .makeCall(() => app.resolve<ServiceModule>().networkService().logout(),
            context,
            isProgress: true)
        .then((response) {
      app.resolve<PrefUtils>().resetAndLogout(context);
    }).catchError((onError) {
      if (onError is ErrorResp) {
        showToast(onError.message);
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    ThemeSettingsModel.of(context).updateSystemUi(isLogin: false);
    return AppBackground(
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: Scaffold(
            drawer: HomeDrawer(),
            key: _scaffoldKey,
            body: currentWidget,
            // bottomNavigationBar: getBottomViewForHome(),
          ),
        ),
      ),
    );
  }
}
