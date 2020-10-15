import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/components/Screens/Auth/ChangePassword.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static const route = "Profile";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: getSize(20), vertical: getSize(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: getSize(40),
            ),
            Text("Profile",
                style: appTheme.commonAlertDialogueTitleStyle.copyWith(fontSize: getFontSize(22))),
            SizedBox(
              height: getSize(30),
            ),
            Text("Personal Information",
                style: appTheme.commonAlertDialogueTitleStyle),
            SizedBox(
              height: getSize(30),
            ),
            Text("Company Information",
                style: appTheme.commonAlertDialogueTitleStyle),
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
          ],
        ),
      ),
    );
  }
}
