import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SeperatorWidget.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FilterScreen extends StatefulScreenWidget {
  static const route = "FilterScreen";
  FilterScreen({Key key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends StatefulScreenWidgetState {
  int segmentedControlValue = 0;

  List<FormBaseModel> arrList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Config().getFilterJson().then((result) {
        setState(() {
          arrList = result;
          print(arrList);
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: appTheme.headerBgColor,
              height: getSize(160),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: getSize(26)),
                      child: Row(
                        children: <Widget>[
                          getBackButton(context, isWhite: true),
                          SizedBox(
                            width: getSize(20),
                          ),
                          Text(
                            R.string().screenTitle.searchDiamond,
                            textAlign: TextAlign.left,
                            style: appTheme.black24TitleColorWhite,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: getSize(16)),
                    _segmentedControl(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // boxShadow: getContainerBoxShadow(context),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(getSize(30)),
                            topRight: Radius.circular(getSize(30))),
                      ),
                    ),
                  ]),
            ),
            Container(
              margin: EdgeInsets.only(top: getSize(150)),
              decoration: BoxDecoration(
                color: Colors.white,
                // boxShadow: getContainerBoxShadow(context),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(getSize(30)),
                    topRight: Radius.circular(getSize(30))),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: getSize(160)),
              color: Colors.transparent,
              child: isNullEmptyOrFalse(arrList)
                  ? SizedBox()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: arrList.length,
                      itemBuilder: (context, index) {
                        return getWidgets(arrList[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  getWidgets(FormBaseModel model) {
    if (model.viewType == ViewTypes.seperator) {
      return SeperatorWidget(model);
    } else if (model.viewType == ViewTypes.selection) {
      return Padding(
        padding: EdgeInsets.all(getSize(8.0)),
        child: SelectionWidget(model),
      );
    }
  }

  Widget _segmentedControl() {
    return Container(
      width: MathUtilities.screenWidth(context),
      child: CupertinoSegmentedControl<int>(
        selectedColor: appTheme.segmentSelectedColor,
        unselectedColor: Colors.transparent,
        pressedColor: Colors.transparent,
        borderColor: Colors.white,
        children: {
          0: getTextWidget(R.string().screenTitle.basic, 0),
          1: getTextWidget(R.string().screenTitle.advanced, 1),
          2: getTextWidget(R.string().screenTitle.stoneIdCertNo, 2),
        },
        onValueChanged: (int val) {
          setState(() {
            segmentedControlValue = val;
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
        color: index == segmentedControlValue
            ? appTheme.colorPrimary
            : appTheme.whiteColor,
      ),
    );
  }
}
