import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/Auth/CompanyInformation.dart';
import 'package:diamnow/components/Screens/SavedSearch/RecentSearchScreen.dart';
import 'package:diamnow/components/Screens/SavedSearch/SavedSearchScreen.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabFileForSsAndRs extends StatefulScreenWidget {
  static const route = "TabFileForSsAndRs";
  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  bool isFromDrawer = false;

  TabFileForSsAndRs(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.ModuleType] != null) {
        moduleType = arguments[ArgumentConstant.ModuleType];
      }
      if (arguments[ArgumentConstant.IsFromDrawer] != null) {
        isFromDrawer = arguments[ArgumentConstant.IsFromDrawer];
      }
    }
  }

  @override
  _TabFileForSsAndRsState createState() => _TabFileForSsAndRsState(
        moduleType: moduleType,
        isFromDrawer: isFromDrawer,
      );
}

class _TabFileForSsAndRsState extends State<TabFileForSsAndRs> with AutomaticKeepAliveClientMixin<TabFileForSsAndRs>{
  int moduleType;
  bool isFromDrawer;

  PageController _controller = PageController();
  int sharedValue = 0;
  Map<int, Widget> pages;

  _TabFileForSsAndRsState({this.moduleType, this.isFromDrawer});

  @override
  void initState() {
    super.initState();
  }

  setPages() {
    pages = {
      0: getSegment("Saved Search", 0),
      1: getSegment("Recent Search", 1),
    };
  }

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
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        R.string().screenTitle.savedSearch,
        bgColor: appTheme.whiteColor,
        leadingButton: isFromDrawer
            ? getDrawerButton(context, true)
            : getBackButton(context),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: getSize(20),
          ),
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
          SizedBox(
            height: getSize(20),
          ),
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
                  // moduleType = DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
                  return SavedSearchScreen(moduleType:moduleType,isFromDrawer:widget.isFromDrawer);
                } else {
                  // moduleType = DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
                  return RecentSearchScreen(moduleType:widget.moduleType,isFromDrawer:widget.isFromDrawer);
                }
              },
            ),
          ),
        ],
      ),
    );
  }


  @override
  bool get wantKeepAlive => true;
}
