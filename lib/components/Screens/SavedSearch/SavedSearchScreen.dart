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
import 'package:diamnow/components/Screens/SavedSearch/SavedSearchItem.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavedSearchScreen extends StatefulScreenWidget {
  static const route = "SavedSearchScreen";
  int moduleType = DiamondModuleConstant.MODULE_TYPE_MY_SAVED_SEARCH;
  bool isFromDrawer = false;

  SavedSearchScreen(
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
  _SavedSearchScreenState createState() => _SavedSearchScreenState(
        moduleType: moduleType,
        isFromDrawer: isFromDrawer,
      );
}

class _SavedSearchScreenState extends State<SavedSearchScreen>
    with AutomaticKeepAliveClientMixin<SavedSearchScreen> {
  int moduleType;
  bool isFromDrawer;

  PageController _controller = PageController();
  int segmentedControlValue = 0;
  bool keepAlive = false;
  PageController controller = PageController();
  _SavedSearchScreenState({this.moduleType, this.isFromDrawer});

  Future doAsyncStuff() async {
    keepAlive = true;
    updateKeepAlive();

    await Future.delayed(Duration(seconds: 10));

    keepAlive = false;
    updateKeepAlive();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          _segmentedControl(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: getSize(16)),
              color: Colors.transparent,
              child: getPageView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _segmentedControl() {
    return Container(
      width: MathUtilities.screenWidth(context),
      child: CupertinoSegmentedControl<int>(
        selectedColor: appTheme.colorPrimary,
        unselectedColor: Colors.white,
        pressedColor: Colors.transparent,
        borderColor: appTheme.colorPrimary,
        children: {
          0: getTextWidget("Saved Search", 0),
          1: getTextWidget("Recent Search", 1)
        },
        onValueChanged: (int val) {
          setState(() {
            segmentedControlValue = val;
            controller.animateToPage(segmentedControlValue,
                duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          });
        },
        groupValue: segmentedControlValue,
      ),
    );
  }

  getTextWidget(String text, int index) {
    return Text(
      text,
      style: TextStyle(
        fontSize: getFontSize(14),
        fontWeight: FontWeight.w500,
        color: index != segmentedControlValue
            ? appTheme.colorPrimary
            : appTheme.whiteColor,
      ),
    );
  }

  getPageView() {
    return PageView.builder(
      controller: controller,
      itemCount: 2,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, position) {
        if (segmentedControlValue == 0) {
          return SavedSearchItemWidget(SavedSearchType.savedSearch);
        }
        return SavedSearchItemWidget(SavedSearchType.recentSearch);
      },
    );
  }
}
