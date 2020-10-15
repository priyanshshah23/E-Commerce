import 'dart:collection';

import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';

import 'package:diamnow/components/Screens/Filter/Widget/CertNoWidget.dart';

import 'package:diamnow/components/Screens/Filter/Widget/CaratRangeWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ColorWidget.dart';

import 'package:diamnow/components/Screens/Filter/Widget/FromToWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SeperatorWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/FilterModel/TabModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/modules/Filter/gridviewlist/KeyToSymbol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxbus/rxbus.dart';

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
    registerRsBus();
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
    arrBottomTab = BottomTabBar.getFilterScreenBottomTabs();
    setState(() {
      //
    });
  }

  registerRsBus() {
    RxBus.register<Map<MasterSelection, bool>>(tag: eventMasterSelection)
        .listen(
      (event) => setState(
        () {
          List<SelectionModel> list = arrList
              .where((element) => element.viewType == ViewTypes.selection)
              .toList()
              .cast<SelectionModel>();

          event.keys.first.masterToSelect.forEach((element) {
            SelectionModel temp = list.firstWhere((mainElement) {
              return mainElement.masterCode == element.code;
            });
            if (!isNullEmptyOrFalse(temp)) {
              temp.masters.forEach((elementSubMaster) {
                elementSubMaster.isSelected = false;

                if (element.subMasters.contains(elementSubMaster.code)) {
                  elementSubMaster.isSelected = event.values.first;
                }
              });
            }
          });
        },
      ),
    );

    RxBus.register<bool>(tag: eventMasterForDeSelectMake).listen(
      (event) => setState(
        () {
          List<SelectionModel> list = arrList
              .where((element) => element.viewType == ViewTypes.selection)
              .toList()
              .cast<SelectionModel>();

          list.forEach((element) {
            if (element.masterCode == MasterCode.make) {
              element.masters.forEach((element) {
                if (element.code != MasterCode.noBgm)
                  element.isSelected = false;
              });
            }
          });
        },
      ),
    );
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
    return BottomTabbarWidget(
      arrBottomTab: arrBottomTab,
      onClickCallback: (obj) {
        //
        if (obj.code == BottomCodeConstant.filterSavedSearch) {
          //
          print(obj.code);
        } else if (obj.code == BottomCodeConstant.filterAddDemamd) {
          //
          print(obj.code);
        } else if (obj.code == BottomCodeConstant.filterSearch) {
          //
          print(obj.code);
           callApiForGetFilterId();
        } else if (obj.code == BottomCodeConstant.filterSaveAndSearch) {
          //
          print(obj.code);
        } else if (obj.code == BottomCodeConstant.filteMatchPair) {
          //
          print(obj.code);
        }
      },
    );
  }

  callApiForGetFilterId() {
    DiamondListReq req = DiamondListReq();
    req.isNotReturnTotal = true;
    req.isReturnCountOnly = true;
    SyncManager.instance.callApiForDiamondList(
      context,
      req,
      (diamondListResp) {
        Map<String, dynamic> dict = new HashMap();
        dict["filterId"] = diamondListResp.data.filter.id;
        NavigationUtilities.pushRoute(DiamondListScreen.route, args: dict);
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
    } else if (model.viewType == ViewTypes.groupWidget) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: ColorWidget(model),
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
