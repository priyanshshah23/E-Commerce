import 'dart:collection';

import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';

import 'package:diamnow/components/Screens/Filter/Widget/CertNoWidget.dart';

import 'package:diamnow/components/Screens/Filter/Widget/CaratRangeWidget.dart';

import 'package:diamnow/components/Screens/Filter/Widget/FromToWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SeperatorWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/FilterModel/TabModel.dart';
import 'package:diamnow/modules/Filter/gridviewlist/KeyToSymbol.dart';
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
  PageController controller = PageController();
  List<TabModel> arrTab = [];
  List<FormBaseModel> arrList = [];
  List<BottomTabModel> arrBottomTab;
  String filterId;

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
    arrBottomTab = BottomTabModel().getFilterScreenBottomTabs();
    setState(() {
      //
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
            appBar: getAppBar(
              context,
              R.string().screenTitle.searchDiamond,
              bgColor: appTheme.whiteColor,
              leadingButton: getBackButton(context),
              centerTitle: false,
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isNullEmptyOrFalse(arrTab)
                    ? SizedBox()
                    : SizedBox(height: getSize(16)),
                isNullEmptyOrFalse(arrTab) ? SizedBox() : _segmentedControl(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: getSize(16)),
                    color: Colors.transparent,
                    child: isNullEmptyOrFalse(arrList)
                        ? SizedBox()
                        : getPageView(),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: getBottomTab()),
      ),
    );
  }

  Widget getBottomTab() {
    if (arrBottomTab.length > 0) {
      return SafeArea(
        child: Container(
          height: getSize(56),
          color: appTheme.colorPrimary,
          child: Row(
            children: [
              for (var i = 0; i < arrBottomTab.length; i++)
                InkWell(
                  onTap: () {
                    //
                    if (arrBottomTab[i].code ==
                        BottomCodeConstant.savedSearch) {
                      //
                      print(arrBottomTab[i].code);
                    } else if (arrBottomTab[i].code ==
                        BottomCodeConstant.addDemamd) {
                      //
                      print(arrBottomTab[i].code);
                    } else if (arrBottomTab[i].code ==
                        BottomCodeConstant.search) {
                      //
                      print(arrBottomTab[i].code);
                    } else if (arrBottomTab[i].code ==
                        BottomCodeConstant.saveAndSearch) {
                      //
                      print(arrBottomTab[i].code);
                    } else if (arrBottomTab[i].code ==
                        BottomCodeConstant.matchPair) {
                      //
                      print(arrBottomTab[i].code);
                    }
                  },
                  child: Container(
                    width: MathUtilities.screenWidth(context) /
                        arrBottomTab.length,
                    color: arrBottomTab[i].getBackgroundColor(),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          arrBottomTab[i].isCenter
                              ? Container(
                                  // color:
                                  //     arrBottomTab[i].centerImageBackgroundColor,
                                  // color: Colors.white,
                                  decoration: new BoxDecoration(
                                    color: arrBottomTab[i]
                                        .getCenterImageBackgroundColor(),
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(5.0)),
                                  ),
                                  width: getSize(40),
                                  height: getSize(40),
                                  child: Center(
                                    child: Image.asset(arrBottomTab[i].image,
                                        width: getSize(20),
                                        height: getSize(20)),
                                  ))
                              : Image.asset(arrBottomTab[i].image,
                                  width: getSize(20), height: getSize(20)),
                          if (arrBottomTab[i].isCenter == false)
                            SizedBox(
                              height: getSize(5),
                            ),
                          if (arrBottomTab[i].isCenter == false)
                            Text(
                              arrBottomTab[i].title,
                              style: appTheme.getTabbarTextStyle(
                                  textColor: arrBottomTab[i].getTextColor()),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      return null;
    }
  }


  callApiForGetFilterId() {
    DiamondListReq req = DiamondListReq();
    req.isNotReturnTotal = true;
    req.isReturnCountOnly = true;
    SyncManager.instance.callApiForDiamondList(
      context,
      req,
          (diamondListResp) {
        filterId = diamondListResp.data.filter.id;
      },
          (onError) {
        //print("Error");
      },
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
        children: getSegmentChildren(),
        onValueChanged: (int val) {
          setState(() {
            segmentedControlValue = val;
            controller.animateToPage(segmentedControlValue,
                duration: Duration(milliseconds: 500),
                curve: Curves.bounceInOut);
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
        color: index != segmentedControlValue
            ? appTheme.colorPrimary
            : appTheme.whiteColor,
      ),
    );
  }

  getPageView() {
    return PageView.builder(
      controller: controller,
      itemCount: isNullEmptyOrFalse(arrTab) ? 1 : arrTab.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, position) {
        if (isNullEmptyOrFalse(arrTab)) {
          return FilterItem(arrList);
        }
        return FilterItem(arrList
            .where((element) => element.tab == arrTab[position].tab)
            .toList());
      },
    );
  }
}

class FilterItem extends StatefulWidget {
  List<FormBaseModel> arrList = [];
  FilterItem(this.arrList);

  @override
  _FilterItemState createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.arrList.length,
      itemBuilder: (context, index) {
        return getWidgets(widget.arrList[index]);
      },
    );
  }

  getWidgets(FormBaseModel model) {
    if (model.viewType == ViewTypes.seperator) {
      return SeperatorWidget(model);
    } else if (model.viewType == ViewTypes.selection) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: SelectionWidget(model),
      );
    } else if (model.viewType == ViewTypes.fromTo) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: FromToWidget(model),
      );
    } else if (model.viewType == ViewTypes.certNo) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: CertNoWidget(model),
      );
    } else if (model.viewType == ViewTypes.keytosymbol) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: KeyToSymbolWidget(model),
      );
    } else if (model.viewType == ViewTypes.colorWidget) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: CaratRangeWidget(model),
      );
    } else if (model.viewType == ViewTypes.caratRange) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: CaratRangeWidget(model),
      );
    } else if (model.viewType == ViewTypes.shapeWidget) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: ShapeWidget(model),
      );
    }
  }
}
