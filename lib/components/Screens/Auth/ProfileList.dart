
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/theme/app_theme.dart';
import 'package:diamnow/components/Screens/Auth/ChangePassword.dart';
import 'package:diamnow/components/Screens/Auth/CompanyInformation.dart';
import 'package:diamnow/components/Screens/Auth/PersonalInformation.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileList extends StatefulWidget {
  static const route = "ProfileList";
  bool isFromDrawer;


  ProfileList(
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
  _ProfileListState createState() => _ProfileListState(isFromDrawer: isFromDrawer);
}

class _ProfileListState extends State<ProfileList> {
  PageController _controller = PageController();
  int sharedValue = 0;
  Map<int, Widget> pages;
  bool isFromDrawer = false;


  setPages() {
    pages = {
      0: getSegment(R.string().commonString.personal, 0),
      1: getSegment(R.string().commonString.business, 1),
      2: getSegment(R.string().commonString.documents, 2),
    };
  }

  _ProfileListState({this.isFromDrawer});

  getSegment(String title, int index) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: getFontSize(14),
          fontWeight: FontWeight.w500,
          color: index != sharedValue
              ? appTheme.colorPrimary
              : appTheme.whiteColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setPages();
    return Scaffold(
      appBar: getAppBar(
        context,
        R.string().commonString.profile,
        bgColor: appTheme.whiteColor,
        leadingButton: isFromDrawer
            ? getDrawerButton(context, true)
            : getBackButton(context),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(height: getSize(20),),
          SizedBox(
            width: MathUtilities.screenWidth(context),
            child: CupertinoSegmentedControl<int>(
              selectedColor: appTheme.colorPrimary,
              unselectedColor: Colors.white,
              pressedColor: Colors.transparent,
              borderColor: appTheme.colorPrimary,
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
                  return Scaffold(
                    body: Center(
                      child: Text("No Documents Found"),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
