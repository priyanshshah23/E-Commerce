import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/app.export.dart';

abstract class StatefulScreenWidget extends StatefulWidget {
  StatefulScreenWidget({
    Key key,
  }) : super(key: key);
}

abstract class StatefulScreenWidgetState extends State<StatefulScreenWidget> {
  @override
  void initState() {
    super.initState();
    changeNavigationandBottomBarColor();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    changeNavigationandBottomBarColor();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground();
  }

  changeNavigationandBottomBarColor(
      {bool isCustomColor, Color statusBarColor, Color bottomBarColor}) {
    if (isCustomColor != null && isCustomColor == true) {
      changeStatusColor(statusBarColor);
      changeNavigationColor(bottomBarColor);
    } else {
      changeStatusColor(ColorConstants.textGray.withOpacity(0.1));
      changeNavigationColor(Colors.black);
      // if (app.resolve<PrefUtils>().isUserLogin() == true) {
      //   changeStatusColor(ColorConstants.colorPrimary);
      //   changeNavigationColor(Colors.black);
      // } else {
      //   changeStatusColor(ColorConstants.textGray.withOpacity(0.1));
      //   changeNavigationColor(Colors.black);
      // }
    }

    print("Base class method called");
  }
}
