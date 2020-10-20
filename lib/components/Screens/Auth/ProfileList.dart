
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/theme/app_theme.dart';
import 'package:diamnow/components/Screens/Auth/ChangePassword.dart';
import 'package:diamnow/components/Screens/Auth/CompanyInformation.dart';
import 'package:diamnow/components/Screens/Auth/PersonalInformation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileList extends StatefulWidget {
  static const route = "ProfileList";

  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  PageController _controller = PageController();
  int sharedValue = 0;
  Map<int, Widget> pages;


  setPages() {
    pages = {
      0: getSegment("Personal", 0),
      1: getSegment("Business", 1),
      2: getSegment("Documents", 2),
    };
  }

  getSegment(String title, int index) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        title,
        style: AppTheme.of(context).theme.textTheme.body1.copyWith(
            color: index == sharedValue
                ? AppTheme.of(context).theme.accentColor
                : AppTheme.of(context).theme.primaryColor,
            fontSize: getFontSize(12),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setPages();
    return Scaffold(
      appBar: getAppBar(
        context,
        "My Profile",
        bgColor: appTheme.whiteColor,
        leadingButton: getBackButton(context),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(height: getSize(20),),
          SizedBox(
            width: MathUtilities.screenWidth(context),
            child: CupertinoSegmentedControl<int>(
              selectedColor: appTheme.colorPrimary,
              unselectedColor: AppTheme.of(context).theme.accentColor,
              borderColor: appTheme.colorPrimary,
              pressedColor: AppTheme.of(context).theme.accentColor,
              children: pages,
              onValueChanged: (int val) {
                setState(() {
                  sharedValue = val;
                });
                _controller.jumpToPage(sharedValue);
              },
              groupValue: sharedValue,
            ),
          ),
          SizedBox(height: getSize(20),),
          Expanded(
            child: PageView.builder(
              onPageChanged: (int val) {
                setState(() {
                  sharedValue = val;
                });
                _controller.jumpToPage(sharedValue);
              },
              //physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              itemCount: pages.length,
              itemBuilder: (context, position) {
                if (position == 0) {
                  return PersonalInformation();
                } else if (position == 1) {
                  return CompanyInformation();
                } else {
                  return ChangePassword();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
