import 'dart:collection';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/components/Screens/Auth/ChangePassword.dart';
import 'package:diamnow/components/Screens/Auth/CompanyInformation.dart';
import 'package:diamnow/components/Screens/Auth/PersonalInformation.dart';
import 'package:diamnow/components/Screens/Home/HomeDrawer.dart';
import 'package:diamnow/components/Screens/StaticPage/StaticPage.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static const route = "Profile";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      key: _scaffoldKey,
      appBar: getAppBar(
        context,
        "",
  leadingButton: getDrawerButton(context, true),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getSize(20), vertical: getSize(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: getSize(40),
            ),
            Text("Profile",
                style: appTheme.commonAlertDialogueTitleStyle
                    .copyWith(fontSize: getFontSize(22))),
            SizedBox(
              height: getSize(30),
            ),
            GestureDetector(
              onTap: () {
                NavigationUtilities.pushRoute(PersonalInformation.route);
              },
              child: Text("Personal Information",
                  style: appTheme.commonAlertDialogueTitleStyle),
            ),
            SizedBox(
              height: getSize(30),
            ),
            GestureDetector(
              onTap: () {
                NavigationUtilities.pushRoute(CompanyInformation.route);
              },
              child: Text("Company Information",
                  style: appTheme.commonAlertDialogueTitleStyle),
            ),
            SizedBox(
              height: getSize(30),
            ),
            GestureDetector(
              onTap: () {
                NavigationUtilities.pushRoute(ChangePassword.route);
              },
              child: Text("Change Password",
                  style: appTheme.commonAlertDialogueTitleStyle),
            ),
            SizedBox(
              height: getSize(30),
            ),
            GestureDetector(
              onTap: () {
                Map<String, dynamic> dict = new HashMap();
                dict["type"] = StaticPageConstant.ABOUT_US;
                NavigationUtilities.pushRoute(StaticPageScreen.route,
                    type: RouteType.fade, args: dict);
              },
              child: Text("About Us",
                  style: appTheme.commonAlertDialogueTitleStyle),
            ),
            SizedBox(
              height: getSize(30),
            ),
            GestureDetector(
              onTap: () {
                Map<String, dynamic> dict = new HashMap();
                dict["type"] = StaticPageConstant.PRIVACY_POLICY;
                NavigationUtilities.pushRoute(StaticPageScreen.route,
                    type: RouteType.fade, args: dict);
              },
              child: Text("Privacy Policy",
                  style: appTheme.commonAlertDialogueTitleStyle),
            ),
            SizedBox(
              height: getSize(30),
            ),
            GestureDetector(
              onTap: () {
                Map<String, dynamic> dict = new HashMap();
                dict["type"] = StaticPageConstant.TERMS_CONDITION;
                NavigationUtilities.pushRoute(StaticPageScreen.route,
                    type: RouteType.fade, args: dict);
              },
              child: Text("Terms & Conditions",
                  style: appTheme.commonAlertDialogueTitleStyle),
            ),
          ],
        ),
      ),
    );
  }
}
