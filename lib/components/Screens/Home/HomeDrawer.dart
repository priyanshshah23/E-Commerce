import 'package:diamnow/Setting/SettingModel.dart';
import 'package:diamnow/components/Screens/Home/DrawerModel.dart';
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
                color: ColorConstants.colorPrimary,
                width: getSize(22),
                height: getSize(22)),
          ),
          Text(
            title,
            style: AppTheme.of(context).theme.textTheme.body1.copyWith(
                fontSize: getFontSize(16),
                fontWeight: FontWeight.bold,
                color: ColorConstants.textGray),
          )
        ],
      ),
    );
  }

  List<Widget> getDrawerList(BuildContext context) {
    List<Widget> list = List<Widget>();
    for (int i = 0; i < drawerItems.length; i++) {
      list.add(getDrawerItem(context, drawerItems[i].image,
          drawerItems[i].title, drawerItems[i].type, () {
        RxBus.post(DrawerEvent(drawerItems[i].type, true), tag: eventBusTag);
      }));
    }
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
                  color: AppTheme.of(context).theme.accentColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // UserDrawerHeader(),
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
/*
/// The [UserDrawerHeader] that contains information about the logged in [User].
class UserDrawerHeader extends StatelessWidget {
  const UserDrawerHeader();

//this.user
//  final User user;

  Future<void> _navigateToUserScreen(BuildContext context,int index) async {
    //await Navigator.of(context).maybePop();
    RxBus.post(DrawerEvent(index, true),
        tag: eventBusTag);
  }

  Widget _buildAvatarRow(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // circle avatar
              GestureDetector(
                onTap: () => _navigateToUserScreen(context,DrawerConstant.MY_PROFILE),
                child: Container(
                  height: getSize(48),
                  width: getSize(48),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: getSize(1),
                      color: AppTheme.of(context).primaryColor,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(getSize(24))),
                    child: isStringEmpty(app
                                .resolve<PrefUtils>()
                                .getUserDetails()
                                .image) ==
                            false
                        ? CachedNetworkImage(
                            imageUrl: ApiConstants.imageBaseURL +
                                app.resolve<PrefUtils>().getUserDetails().image,
                            fit: BoxFit.cover,
                            placeholder: (BuildContext context, String url) {
                              return getUserPlaceHolderImage();
                            },
                          )
                        : getUserPlaceHolderImage(),
                  ),
                ),
              ),
              SizedBox(width: getSize(10)),
              //username
              Expanded(
                child: GestureDetector(
                  onTap: () => _navigateToUserScreen(context,DrawerConstant.MY_PROFILE),
                  child: Text(
                    app.resolve<PrefUtils>().getUserDetails().getFullName(),
                    maxLines: 2,
                    style: AppTheme.of(context).theme.textTheme.title.copyWith(
                        fontSize: getFontSize(18),
                        color: AppTheme.of(context).theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0),
                  ),
                ),
              ),
              //bell icon
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  NavigationUtilities.pushRoute(NotificationList.route,
                      type: RouteType.fade);
                },
                child: Padding(
                  padding: EdgeInsets.all(getSize(10)),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: getSize(6)),
                        child: Image.asset(notifications,
                            width: getSize(28), height: getSize(28)),
                      ),
                      Container(
                        height: getSize(20),
                        width: getSize(20),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.of(context).theme.primaryColor),
                        child: Center(
                          child: Text(
                            getNotifications(),
                            style: AppTheme.of(context)
                                .theme
                                .textTheme
                                .display3
                                .copyWith(
                                    fontSize: getSize(10),
                                    color:
                                        AppTheme.of(context).theme.accentColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: getSize(0), right: getSize(10), top: getSize(25)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () => _navigateToUserScreen(context,DrawerConstant.SUMMARY_TIMESHEET),
                child: getHeaderItem(context, clock, getOnlineHours(),
                    R.string().authStrings.hoursAvailable),
              ),
              Spacer(),
              InkWell(
                onTap: () => _navigateToUserScreen(context,DrawerConstant.RIDE_HISTORY),
                child: getHeaderItem(context, trips, getTotalTrips(),
                    R.string().authStrings.totalTrips),
              ),
              Spacer(),
              InkWell(
                onTap: () => _navigateToUserScreen(context,DrawerConstant.RIDE_SUMMARY),
                child: getHeaderItem(context, incentive, getTotalKm(),
                    R.string().authStrings.totalKMs),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget getHeaderItem(
      BuildContext context, String icon, String title, String description) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(getSize(8)),
          child: Image.asset(icon,
              color: AppTheme.of(context).theme.primaryColor,
              width: getSize(20),
              height: getSize(20)),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTheme.of(context).theme.textTheme.title.copyWith(
              color: ColorConstants.white,
              fontSize: getFontSize(18),
              fontWeight: FontWeight.bold),
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          style: AppTheme.of(context).theme.textTheme.body1.copyWith(
              color: ColorConstants.drawer_bottom_text,
              fontSize: getFontSize(12),
              fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.fromLTRB(
          getSize(20),
          getSize(35), // + statusbar height
          getSize(20),
          getSize(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAvatarRow(context),
//           SizedBox(
//             width: double.infinity,
//             child: Container(),
// //              FollowersCount(user)
//           ),
          ],
        ),
      ),
    );
  }

  String getOnlineHours() {
    int totalSec =
        app.resolve<PrefUtils>()?.getRideSummary()?.totalTime?.toInt() ?? 0;
    print('time - 0');
    Duration duration = Duration(seconds: totalSec);
    int hour = duration.inHours;
    int min = duration.inMinutes.remainder(60);
    String hourMinStr = addPrefixZero(hour) + 'h:' + addPrefixZero(min) + 'm';
    return hourMinStr;
  }

  String getTotalKm() {
    return app
            .resolve<PrefUtils>()
            ?.getRideSummary()
            ?.totalDistance
            ?.toStringAsFixed(2)
            ?.toString() ??
        '0';
  }

  String getTotalTrips() {
    return app.resolve<PrefUtils>()?.getRideSummary()?.totalRide?.toString() ??
        '0';
  }

  String getNotifications() {
    return app
            .resolve<PrefUtils>()
            ?.getRideSummary()
            ?.totalUnreadNotifications
            ?.toString() ??
        '0';
  }
}*/
