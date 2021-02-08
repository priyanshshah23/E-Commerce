import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/AnalyticsReport.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/CommonWidget/OverlayScreen.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondDetail/DiamondDetailUIModel.dart';
import 'package:diamnow/models/DiamondList/DiamondCompare.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class DiamondCompareScreen extends StatefulScreenWidget {
  static const route = "/DiamondCompareScreen";

  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  List<DiamondModel> arrayDiamond;

  DiamondCompareScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.ModuleType] != null) {
        moduleType = arguments[ArgumentConstant.ModuleType];
      }
      if (arguments[ArgumentConstant.DiamondList] != null) {
        arrayDiamond = arguments[ArgumentConstant.DiamondList];
      }
    }
  }

  @override
  _DiamondCompareScreenState createState() => _DiamondCompareScreenState(
      moduleType: moduleType, arrayDiamondlist: arrayDiamond);
}

class _DiamondCompareScreenState extends StatefulScreenWidgetState {
  int moduleType;
  List<DiamondModel> arrayDiamondlist;
  bool isCheckBoxChecked = false;
  double viewHeight = 1000;

  List<DiamondCompare> compareDetailList = [];

  //will store all apikeys of not unique value.
  List<String> ignorableApiKeys = [];

  // ScrollController sc;
  LinkedScrollControllerGroup _controllers;

  _DiamondCompareScreenState({this.moduleType, this.arrayDiamondlist});

  DiamondConfig diamondConfig;

  @override
  void initState() {
    super.initState();
    diamondConfig = DiamondConfig(moduleType, isCompare: true);
    diamondConfig.initItems();
    Config().getDiamonCompareUIJson().then((result) {
      setState(() {
        viewHeight = 0;
        result.toList().forEach((element) {
          viewHeight +=
              element.parameters.where((element) => element.isActive).length *
                  (getSize(40) + getSize(14));
        });
        viewHeight += getSize(90);
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setCompareList();
    });

    AnalyticsReport.shared.sendAnalyticsData(
      buildContext: context,
      page: PageAnalytics.COMPARE,
      section: SectionAnalytics.COMPARE,
      action: ActionAnalytics.OPEN,
    );
    // sc = ScrollController();
    _controllers = LinkedScrollControllerGroup();
  }

  setCompareList() {
    Config().getDiamonCompareUIJson().then((result) {
      if (compareDetailList.length == 0) {
        arrayDiamondlist.forEach((element) {
          compareDetailList.add(DiamondCompare(diamondModel: element));
        });
      }
      compareDetailList.forEach((element) {
        setupDiamonDetail(result, element);
      });
      DiamondCompare compareModel = compareDetailList[0];
      viewHeight = 0;
      for (int i = 0; i < compareModel.compareDetailList.length; i++) {
        viewHeight +=
            compareModel.compareDetailList[i].parameters.length * (getSize(70));
      }
      viewHeight += getSize(150);
      setState(() {});
    });
  }

  setupDiamonDetail(
      List<DiamondDetailUIModel> arrModel, DiamondCompare compareModel) {
    List<DiamondDetailUIModel> arrDiamondDetailUIModel = [];
    for (int i = 0; i < arrModel.length; i++) {
      var diamondDetailItem = arrModel[i];
      var diamondDetailUIModel = DiamondDetailUIModel(
          title: diamondDetailItem.title,
          sequence: diamondDetailItem.sequence,
          isExpand: diamondDetailItem.isExpand,
          columns: diamondDetailItem.columns,
          orientation: diamondDetailItem.orientation);

      diamondDetailUIModel.parameters = List<DiamondDetailUIComponentModel>();

      for (DiamondDetailUIComponentModel element
          in diamondDetailItem.parameters) {
        //
        var diamonDetailComponent = DiamondDetailUIComponentModel(
          title: element.title,
          apiKey: element.apiKey,
          sequence: element.sequence,
          isPercentage: element.isPercentage,
          isActive: element.isActive,
        );

        if (isStringEmpty(element.apiKey) == false) {
          dynamic valueElement =
              compareModel.diamondModel.toJson()[element.apiKey];
          if (valueElement != null) {
            if (element.apiKey == DiamondDetailUIAPIKeys.pricePerCarat) {
              //
              diamonDetailComponent.value =
                  compareModel.diamondModel.getPricePerCarat();
            } else if (element.apiKey == DiamondDetailUIAPIKeys.amount) {
              //
              diamonDetailComponent.value =
                  compareModel.diamondModel.getAmount();
            } else if (valueElement is String) {
              diamonDetailComponent.value = valueElement;
            } else if (valueElement is num) {
              diamonDetailComponent.value = valueElement.toString();
            }
            if (element.isPercentage) {
              diamonDetailComponent.value = "${diamonDetailComponent.value}%";
            }
          }
        }
        if (element.isActive) {
          if (isCheckBoxChecked) {
            if (!ignorableApiKeys.contains(element.apiKey)) {
              diamondDetailUIModel.parameters.add(diamonDetailComponent);
            }
          } else {
            diamondDetailUIModel.parameters.add(diamonDetailComponent);
          }
        }
      }

      arrDiamondDetailUIModel.add(diamondDetailUIModel);
    }
    compareModel.compareDetailList = arrDiamondDetailUIModel;
  }

  List<Widget> getToolbarItem() {
    List<Widget> list = [];
    diamondConfig.toolbarList.forEach((element) {
      list.add(GestureDetector(
        onTap: () {
          manageToolbarClick(element);
        },
        child: Padding(
            padding: EdgeInsets.only(right: getSize(20.0)),
            child: Container(
              child: Row(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          isCheckBoxChecked = !isCheckBoxChecked;
                          whenCheckBoxIsChecked();
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(getSize(3))),
                          width: getSize(21),
                          height: getSize(21),
                          child: Image.asset(
                            isCheckBoxChecked
                                ? selectedCheckbox
                                : unSelectedCheckbox,
                            height: getSize(20),
                            width: getSize(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getSize(5),
                      ),
                      Text(
                        "Show only difference",
                        style: appTheme.blackNormal14TitleColorblack,
                      )
                    ],
                  ),

                  // Transform.scale(
                  //   scale: 1,
                  //   child: Checkbox(
                  //     value: this.isCheckBoxChecked,
                  //     activeColor: appTheme.colorPrimary,
                  //     onChanged: (bool value) {
                  //       this.isCheckBoxChecked = value;
                  //       whenCheckBoxIsChecked();
                  //     },
                  //   ),
                  // ),
                  // // SizedBox(width: getSize(5),),
                  // Text(
                  //   "Show only difference",
                  //   style: appTheme.blackNormal12TitleColorblack,
                  // ),
                ],
              ),
            )),
      ));
    });
    return list;
  }

  manageRowClick(int index, int type) {
    switch (type) {
      case clickConstant.CLICK_TYPE_SELECTION:
        setState(() {
          compareDetailList[index].isSelected =
              !compareDetailList[index].isSelected;
        });
        break;
    }
  }

  manageToolbarClick(BottomTabModel model) {
    switch (model.code) {
      case BottomCodeConstant.TBDownloadView:
        List<DiamondModel> selectedList =
            arrayDiamondlist.where((element) => element.isSelected).toList();
        if (!isNullEmptyOrFalse(selectedList)) {
          diamondConfig.manageDiamondAction(
              context, selectedList, model, () {});
        } else {
          app.resolve<CustomDialogs>().confirmDialog(
                context,
                title: "",
                desc: R.string.errorString.diamondSelectionError,
                positiveBtnTitle: R.string.commonString.ok,
              );
        }

        break;
    }
  }

  whenCheckBoxIsChecked() {
    Map<String, Set<String>> map = {};
    for (int i = 0; i < compareDetailList.length; i++) {
      if (map[DiamondDetailUIAPIKeys.pricePerCarat] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.getPricePerCarat().toString());
        map[DiamondDetailUIAPIKeys.pricePerCarat] = s;
      } else {
        map[DiamondDetailUIAPIKeys.pricePerCarat].add(
            compareDetailList[i].diamondModel.getPricePerCarat().toString());
      }

      if (map[DiamondDetailUIAPIKeys.amount] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.getAmount().toString());
        map[DiamondDetailUIAPIKeys.amount] = s;
      } else {
        map[DiamondDetailUIAPIKeys.amount]
            .add(compareDetailList[i].diamondModel.getAmount().toString());
      }

      if (map[DiamondDetailUIAPIKeys.stoneId] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.stoneId.toString());
        map[DiamondDetailUIAPIKeys.stoneId] = s;
      } else {
        map[DiamondDetailUIAPIKeys.stoneId]
            .add(compareDetailList[i].diamondModel.stoneId.toString());
      }
      // print
      if (map[DiamondDetailUIAPIKeys.shpNm] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.shpNm.toString());
        map[DiamondDetailUIAPIKeys.shpNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.shpNm]
            .add(compareDetailList[i].diamondModel.shpNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.crt] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.crt.toString());
        map[DiamondDetailUIAPIKeys.crt] = s;
      } else {
        map[DiamondDetailUIAPIKeys.crt]
            .add(compareDetailList[i].diamondModel.crt.toString());
      }

      if (map[DiamondDetailUIAPIKeys.shdNm] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.shdNm.toString());
        map[DiamondDetailUIAPIKeys.shdNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.shdNm]
            .add(compareDetailList[i].diamondModel.shdNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.cutNm] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.cutNm.toString());
        map[DiamondDetailUIAPIKeys.cutNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.cutNm]
            .add(compareDetailList[i].diamondModel.cutNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.polNm] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.polNm.toString());
        map[DiamondDetailUIAPIKeys.polNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.polNm]
            .add(compareDetailList[i].diamondModel.polNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.symNm] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.symNm.toString());
        map[DiamondDetailUIAPIKeys.symNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.symNm]
            .add(compareDetailList[i].diamondModel.symNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.fluNm] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.fluNm.toString());
        map[DiamondDetailUIAPIKeys.fluNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.fluNm]
            .add(compareDetailList[i].diamondModel.fluNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.lbNm] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.lbNm.toString());
        map[DiamondDetailUIAPIKeys.lbNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.lbNm]
            .add(compareDetailList[i].diamondModel.lbNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.rptNo] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.rptNo.toString());
        map[DiamondDetailUIAPIKeys.rptNo] = s;
      } else {
        map[DiamondDetailUIAPIKeys.rptNo]
            .add(compareDetailList[i].diamondModel.rptNo.toString());
      }

      if (map[DiamondDetailUIAPIKeys.back] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.back.toString());
        map[DiamondDetailUIAPIKeys.back] = s;
      } else {
        map[DiamondDetailUIAPIKeys.back]
            .add(compareDetailList[i].diamondModel.back.toString());
      }

      if (map[DiamondDetailUIAPIKeys.eClnNm] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.eClnNm.toString());
        map[DiamondDetailUIAPIKeys.eClnNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.eClnNm]
            .add(compareDetailList[i].diamondModel.eClnNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.length] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.length.toString());
        map[DiamondDetailUIAPIKeys.length] = s;
      } else {
        map[DiamondDetailUIAPIKeys.length]
            .add(compareDetailList[i].diamondModel.length.toString());
      }

      if (map[DiamondDetailUIAPIKeys.width] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.width.toString());
        map[DiamondDetailUIAPIKeys.width] = s;
      } else {
        map[DiamondDetailUIAPIKeys.width]
            .add(compareDetailList[i].diamondModel.width.toString());
      }

      if (map[DiamondDetailUIAPIKeys.height] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.height.toString());
        map[DiamondDetailUIAPIKeys.height] = s;
      } else {
        map[DiamondDetailUIAPIKeys.height]
            .add(compareDetailList[i].diamondModel.height.toString());
      }

      if (map[DiamondDetailUIAPIKeys.ratio] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.ratio.toString());
        map[DiamondDetailUIAPIKeys.ratio] = s;
      } else {
        map[DiamondDetailUIAPIKeys.ratio]
            .add(compareDetailList[i].diamondModel.ratio.toString());
      }

      if (map[DiamondDetailUIAPIKeys.depPer] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.depPer.toString());
        map[DiamondDetailUIAPIKeys.depPer] = s;
      } else {
        map[DiamondDetailUIAPIKeys.depPer]
            .add(compareDetailList[i].diamondModel.depPer.toString());
      }

      if (map[DiamondDetailUIAPIKeys.tblPer] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.tblPer.toString());
        map[DiamondDetailUIAPIKeys.tblPer] = s;
      } else {
        map[DiamondDetailUIAPIKeys.tblPer]
            .add(compareDetailList[i].diamondModel.tblPer.toString());
      }

      if (map[DiamondDetailUIAPIKeys.cHgt] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.cHgt.toString());
        map[DiamondDetailUIAPIKeys.cHgt] = s;
      } else {
        map[DiamondDetailUIAPIKeys.cHgt]
            .add(compareDetailList[i].diamondModel.cHgt.toString());
      }

      if (map[DiamondDetailUIAPIKeys.cAng] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.cAng.toString());
        map[DiamondDetailUIAPIKeys.cAng] = s;
      } else {
        map[DiamondDetailUIAPIKeys.cAng]
            .add(compareDetailList[i].diamondModel.cAng.toString());
      }

      if (map[DiamondDetailUIAPIKeys.pAng] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.pAng.toString());
        map[DiamondDetailUIAPIKeys.pAng] = s;
      } else {
        map[DiamondDetailUIAPIKeys.pAng]
            .add(compareDetailList[i].diamondModel.pAng.toString());
      }

      if (map[DiamondDetailUIAPIKeys.girdleStr] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.girdleStr.toString());
        map[DiamondDetailUIAPIKeys.girdleStr] = s;
      } else {
        map[DiamondDetailUIAPIKeys.girdleStr]
            .add(compareDetailList[i].diamondModel.girdleStr.toString());
      }

      if (map[DiamondDetailUIAPIKeys.grdlCondNm] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.grdlCondNm.toString());
        map[DiamondDetailUIAPIKeys.grdlCondNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.grdlCondNm]
            .add(compareDetailList[i].diamondModel.grdlCondNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.cultNm] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.cultNm.toString());
        map[DiamondDetailUIAPIKeys.cultNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.cultNm]
            .add(compareDetailList[i].diamondModel.cultNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.hANm] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.hANm.toString());
        map[DiamondDetailUIAPIKeys.hANm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.hANm]
            .add(compareDetailList[i].diamondModel.hANm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.kToSStr] == null) {
        Set<String> s = {};
        s.add(compareDetailList[i].diamondModel.kToSStr.toString());
        map[DiamondDetailUIAPIKeys.kToSStr] = s;
      } else {
        map[DiamondDetailUIAPIKeys.kToSStr]
            .add(compareDetailList[i].diamondModel.kToSStr.toString());
      }
    }

    for (int i = 0; i < map.length; i++) {
      if (map[DiamondDetailUIAPIKeys.amount].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.amount);
      if (map[DiamondDetailUIAPIKeys.pricePerCarat].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.pricePerCarat);
      if (map[DiamondDetailUIAPIKeys.stoneId].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.stoneId);
      if (map[DiamondDetailUIAPIKeys.shpNm].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.shpNm);
      if (map[DiamondDetailUIAPIKeys.crt].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.crt);
      if (map[DiamondDetailUIAPIKeys.shdNm].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.shdNm);
      if (map[DiamondDetailUIAPIKeys.cutNm].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.cutNm);
      if (map[DiamondDetailUIAPIKeys.polNm].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.polNm);
      if (map[DiamondDetailUIAPIKeys.symNm].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.symNm);
      if (map[DiamondDetailUIAPIKeys.fluNm].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.fluNm);
      if (map[DiamondDetailUIAPIKeys.lbNm].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.lbNm);
      if (map[DiamondDetailUIAPIKeys.rptNo].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.rptNo);
      if (map[DiamondDetailUIAPIKeys.back].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.back);
      if (map[DiamondDetailUIAPIKeys.eClnNm].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.eClnNm);
      if (map[DiamondDetailUIAPIKeys.length].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.length);
      if (map[DiamondDetailUIAPIKeys.width].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.width);
      if (map[DiamondDetailUIAPIKeys.height].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.height);
      if (map[DiamondDetailUIAPIKeys.ratio].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.ratio);
      if (map[DiamondDetailUIAPIKeys.depPer].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.depPer);
      if (map[DiamondDetailUIAPIKeys.tblPer].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.tblPer);
      if (map[DiamondDetailUIAPIKeys.cHgt].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.cHgt);
      if (map[DiamondDetailUIAPIKeys.cAng].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.cAng);
      if (map[DiamondDetailUIAPIKeys.pAng].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.pAng);
      if (map[DiamondDetailUIAPIKeys.girdleStr].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.girdleStr);
      if (map[DiamondDetailUIAPIKeys.grdlCondNm].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.grdlCondNm);
      if (map[DiamondDetailUIAPIKeys.cultNm].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.cultNm);
      if (map[DiamondDetailUIAPIKeys.hANm].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.hANm);
      if (map[DiamondDetailUIAPIKeys.kToSStr].length <= 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.kToSStr);
    }
    setCompareList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: appTheme.whiteColor,
          appBar: getAppBar(
            context,
            R.string.screenTitle.compareStones,
            textalign: TextAlign.left,
            bgColor: appTheme.whiteColor,
            leadingButton: getBackButton(context),
            centerTitle: false,
            actionItems: getToolbarItem(),
          ),
          bottomNavigationBar: getBottomTab(),
          body: SingleChildScrollView(
            child: Container(
              height: viewHeight,
              child: Padding(
                padding: EdgeInsets.only(left: getSize(20), right: getSize(20)),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: compareDetailList.length == 0
                      ? Container()
                      : ReorderableListView(
                          onReorder: (int oldIndex, int newIndex) {
                            setState(
                              () {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                final DiamondCompare item =
                                    compareDetailList[oldIndex];
                                compareDetailList.removeAt(oldIndex);
                                compareDetailList.insert(newIndex, item);
                              },
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          children: List.generate(
                            compareDetailList.length,
                            (index) {
                              return getDiamondCompareItem(
                                  index,
                                  Key(index.toString()),
                                  compareDetailList[index]);
                            },
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        (app.resolve<PrefUtils>().getBool(PrefUtils().keyCompareStoneTour) ==
                false)
            ? OverlayScreen(
                DiamondModuleConstant.MODULE_TYPE_COMPARE,
                finishTakeTour: () {
                  setState(() {});
                },
                scrollIndex: (index) {},
              )
            : SizedBox(),
      ],
    );
  }

  removeDiamond(int index) {
    if (compareDetailList.length > 2) {
      compareDetailList.removeAt(index);
      setState(() {});
    } else {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: "",
            desc: R.string.errorString.diamondCompareRemove,
            positiveBtnTitle: R.string.commonString.ok,
          );
    }
  }

  Widget getBottomTab() {
    return BottomTabbarWidget(
      arrBottomTab: diamondConfig.arrBottomTab,
      onClickCallback: (obj) {
        if (obj.type == ActionMenuConstant.ACTION_TYPE_MORE) {
          List<DiamondCompare> selectedList =
              compareDetailList.where((element) => element.isSelected).toList();
          if (!isNullEmptyOrFalse(selectedList)) {
            showBottomSheetForMenu(context, diamondConfig.arrMoreMenu,
                (manageClick) {
              manageBottomMenuClick(manageClick.bottomTabModel);
            }, R.string.commonString.more, isDisplaySelection: false);
          } else {
            app.resolve<CustomDialogs>().confirmDialog(
                  context,
                  title: "",
                  desc: R.string.errorString.diamondSelectionError,
                  positiveBtnTitle: R.string.commonString.ok,
                );
          }
        } else {
          manageBottomMenuClick(obj);
        }
      },
    );
  }

  manageBottomMenuClick(BottomTabModel bottomTabModel) {
    List<DiamondCompare> selectedList =
        compareDetailList.where((element) => element.isSelected).toList();

    if (!isNullEmptyOrFalse(selectedList)) {
      List<DiamondModel> list = [];
      selectedList.forEach((element) {
        list.add(element.diamondModel);
      });
      diamondConfig.manageDiamondAction(context, list, bottomTabModel, () {
        Navigator.pop(context, true);
      });
    } else {
      app.resolve<CustomDialogs>().confirmDialog(
            context,
            title: "",
            desc: R.string.errorString.diamondSelectionError,
            positiveBtnTitle: R.string.commonString.ok,
          );
    }
  }

  getDiamondCompareItem(int index, Key key, DiamondCompare compareModel) {
    return Column(
      key: key,
      children: <Widget>[
        Stack(
          children: [
            Container(
              width: getSize(150),
              height: getSize(90),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  // color: Colors.yellow,
                  border: index == 0 || compareModel.isSelected
                      ? (Border.all(
                          color: compareModel.isSelected
                              ? appTheme.colorPrimary
                              : appTheme.dividerColor,
                        ))
                      : Border(
                          // left: BorderSide(
                          //     width: getSize(1),
                          //     color: appTheme.dividerColor),
                          top: BorderSide(
                              width: getSize(1), color: appTheme.dividerColor),
                          bottom: BorderSide(
                              width: getSize(1), color: appTheme.dividerColor),
                          right: BorderSide(
                              width: getSize(1), color: appTheme.dividerColor),
                        )),
              child: getImageView(
                  DiamondUrls.image +
                      compareModel.diamondModel.mfgStnId +
                      "/" +
                      "still.jpg",
                  height: getSize(120),
                  width: getSize(60),
                  fit: BoxFit.scaleDown),
            ),
            Positioned(
              top: 0,
              left: 2,
              child: Container(
                // color: Colors.red,
                // padding: EdgeInsets.only(left:getSize(14)),
                alignment: Alignment.topCenter,
                width: getSize(30),
                height: getSize(30),
                child: IconButton(
                  icon: Icon(
                    Icons.done,
                    size: getSize(18),
                    color: compareModel.isSelected == true
                        ? appTheme.colorPrimary
                        : appTheme.textBlackColor,
                  ),
                  onPressed: () {
                    setState(() {
                      compareModel.isSelected = !compareModel.isSelected;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                // color: Colors.red,
                alignment: Alignment.center,
                width: getSize(30),
                height: getSize(30),
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: getSize(18),
                  ),
                  onPressed: () {
                    removeDiamond(index);
                    ;
                  },
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              for (int i = 0; i < compareModel.compareDetailList.length; i++)
                for (int j = 0;
                    j < compareModel.compareDetailList[i].parameters.length;
                    j++)
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(left: getSize(14)),
                            alignment: Alignment.centerLeft,
                            height: getSize(30),
                            width: getSize(150),
                            decoration: BoxDecoration(
                              color: ColorConstants.compareChangesRowBgColor,
                              // border: Border(
                              //   left: BorderSide(width: getSize(0.5)),
                              //   right: BorderSide(width: getSize(0.5)),
                              // ),
                            ),
                            child: index == 0
                                ? Text(
                                    compareModel.compareDetailList[i]
                                        .parameters[j].title,
                                    style:
                                        appTheme.blackNormal12TitleColorblack,
                                  )
                                : SizedBox()),
                        Container(
                          padding: EdgeInsets.only(left: getSize(14)),
                          alignment: Alignment.centerLeft,
                          height: getSize(40),
                          width: getSize(150),
                          decoration: BoxDecoration(
                            color: ColorConstants.white,
                            border: index == 0
                                ? Border(
                                    left: BorderSide(
                                        width: getSize(1),
                                        color: appTheme.dividerColor),
                                    right: BorderSide(
                                        width: getSize(1),
                                        color: appTheme.dividerColor),
                                  )
                                : Border(
                                    right: BorderSide(
                                        width: getSize(1),
                                        color: appTheme.dividerColor),
                                  ),
                          ),
                          child: Text(
                            compareModel
                                    .compareDetailList[i].parameters[j].value ??
                                "-",
                            style: appTheme.blackNormal14TitleColorblack,
                          ),
                        )
                      ],
                    ),
                  ),
            ],
          ),
        )
      ],
    );
  }
}
