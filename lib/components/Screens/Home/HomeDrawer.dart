import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../app/app.export.dart';

/// The [Drawer] shown in the [HomeScreen].
///
/// It displays the logged in [User] on the top and allows to navigate to
/// different parts of the app and logout.
class HomeDrawer extends StatelessWidget {
  //List<BottomNavModel> drawerItems = BottomNavModel.getDrawerItems();

  Widget getDrawerItem(BuildContext context, String icon, String title,
      int type, VoidCallback callback) {
    return InkWell(
      onTap: callback,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: getSize(20),
                right: getSize(16),
                top: getSize(18),
                bottom: getSize(18)),
            child: Image.asset(icon,
                color: appTheme.whiteColor,
                width: getSize(22), height: getSize(22)),
          ),
          Text(
            title,
            style: AppTheme.of(context).theme.textTheme.body1.copyWith(
                fontSize: getFontSize(16),
                fontWeight: FontWeight.bold,
                color: appTheme.whiteColor),
          )
        ],
      ),
    );
  }

  List<Widget> getDrawerList(BuildContext context) {
    List<Widget> list = List<Widget>();
//    for (int i = 0; i < drawerItems.length; i++) {
//      list.add(getDrawerItem(context, drawerItems[i].image,
//          drawerItems[i].title, drawerItems[i].type, () {
//            RxBus.post(DrawerEvent(drawerItems[i].type, true), tag: eventBusTag);
//          }));
//    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context,StateSetter setState){
        /* SyncManager.instance
            .callMasterSync(NavigationUtilities.key.currentContext, () {
          setState(() {
          });
        }, () {}, isNetworkError: false, isProgress: false).then((value){
        });*/

        return Container(
          margin: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(getSize(26)),
                bottomRight: Radius.circular(getSize(26))),
            child: Drawer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(26)),
                  color: AppTheme.of(context).theme.accentColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(
                              getSize(0), getSize(12), getSize(16), getSize(0)),
                          color: AppTheme.of(context).theme.primaryColor,
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
      },
    );
  }
}
