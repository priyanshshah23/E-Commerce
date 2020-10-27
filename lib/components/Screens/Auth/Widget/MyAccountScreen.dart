import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/components/Screens/Home/DrawerModel.dart';
import 'package:diamnow/components/Screens/Home/HomeDrawer.dart';
import 'package:diamnow/components/Screens/Home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:rxbus/rxbus.dart';

class MyAccountScreen extends StatefulWidget {
  static const route = "MyAccountScreen";

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  List<DrawerModel> accountItems = DrawerSetting().getAccountListItems();

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
                  padding: EdgeInsets.only(top: getSize(10), bottom: getSize(10)),
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
          if(model.isShowDivider)
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

    list.add(UserDrawerHeader());
    for (int i = 0; i < accountItems.length; i++) {
      list.add(getDrawerItem(context, accountItems[i], () {
        //RxBus.post(DrawerEvent(accountItems[i].type, true), tag: eventBusTag);
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
    return Scaffold(
      body: Container(
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
    ),
    );
  }


}
