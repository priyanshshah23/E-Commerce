import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Auth/FromToWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SeperatorWidget.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/FilterModel/TabModel.dart';
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

  List<TabModel> arrTab = [];
  List<FormBaseModel> arrList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Config().getFilterJson().then((result) {
        setState(() {
          arrList = result;
        });
      });

      Config().getTabJson().then((result) {
        setState(() {
          arrTab = result;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AppBackground(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                color: appTheme.headerBgColor,
                height: isNullEmptyOrFalse(arrTab) ? getSize(80) : getSize(140),
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
                      isNullEmptyOrFalse(arrTab)
                          ? SizedBox()
                          : SizedBox(height: getSize(16)),
                      isNullEmptyOrFalse(arrTab)
                          ? SizedBox()
                          : _segmentedControl(),
                    ]),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: isNullEmptyOrFalse(arrTab) ? getSize(80) : getSize(140),
                ),
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
    } else if (model.viewType == ViewTypes.fromTo) {
      return Padding(
        padding: EdgeInsets.all(getSize(8.0)),
        child: FromToWidget(model),
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
        children: getSegmentChildren(),
        onValueChanged: (int val) {
          setState(() {
            segmentedControlValue = val;
          });
        },
        groupValue: segmentedControlValue,
      ),
    );
  }

  Map<int, Widget> getSegmentChildren() {
    Map<int, Widget> tab = Map<int, Widget>();
    for (int i = 0; i < arrTab.length; i++) {
      tab[i] = getTextWidget(arrTab[i].title, i);
    }

    return tab;
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
