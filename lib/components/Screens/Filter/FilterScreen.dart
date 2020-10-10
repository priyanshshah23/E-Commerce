import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        body: Stack(children: [
          Container(
            color: appTheme.headerBgColor,
            height: getSize(160),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _segmentedControl() {
    return Container(
      width: MathUtilities.screenWidth(context),
      child: CupertinoSegmentedControl<int>(
        selectedColor: appTheme.segmentSelectedColor,
        unselectedColor: Colors.transparent,
        borderColor: Colors.white,
        children: {
          0: Text(
            R.string().screenTitle.basic,
            style: TextStyle(
              fontSize: getFontSize(16),
              fontWeight: FontWeight.w500,
              color: segmentedControlValue == 0
                  ? appTheme.colorPrimary
                  : appTheme.whiteColor,
            ),
          ),
          1: Text(
            R.string().screenTitle.advanced,
            style: TextStyle(
              fontSize: getFontSize(16),
              fontWeight: FontWeight.w500,
              color: segmentedControlValue == 1
                  ? appTheme.colorPrimary
                  : appTheme.whiteColor,
            ),
          ),
          2: Text(
            R.string().screenTitle.stoneIdCertNo,
            style: TextStyle(
              fontSize: getFontSize(16),
              fontWeight: FontWeight.w500,
              color: segmentedControlValue == 1
                  ? appTheme.colorPrimary
                  : appTheme.whiteColor,
            ),
          ),
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
}
