import 'dart:ffi';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseList.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/CommonWidget/BottomTabbarWidget.dart';
import 'package:diamnow/components/Screens/DiamondDetail/DiamondDetailScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondCompareWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondItemGridWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/DiamondListItemWidget.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/SortBy/FilterPopup.dart';
import 'package:diamnow/components/Screens/More/BottomsheetForMoreMenu.dart';
import 'package:diamnow/components/Screens/More/DiamondBottomSheets.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondDetail/DiamondDetailUIModel.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/BottomTabModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class DiamondCompareScreen extends StatefulScreenWidget {
  static const route = "Diamond Compare Screen";

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
      moduleType: moduleType, arrayDiamond: arrayDiamond);
}

class _DiamondCompareScreenState extends StatefulScreenWidgetState {
  int moduleType;
  List<DiamondModel> arrayDiamond;
  bool isCheckBoxChecked = false;

  //will store all apikeys of not unique value.
  List<String> ignorableApiKeys = [];
  // ScrollController sc;
  LinkedScrollControllerGroup _controllers;

  _DiamondCompareScreenState({this.moduleType, this.arrayDiamond});

  DiamondConfig diamondConfig;

  @override
  void initState() {
    super.initState();
    diamondConfig = DiamondConfig(moduleType, isCompare: true);
    diamondConfig.initItems();

    // sc = ScrollController();
    _controllers = LinkedScrollControllerGroup();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
      () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final DiamondModel item = arrayDiamond.removeAt(oldIndex);
        arrayDiamond.insert(newIndex, item);
      },
    );
  }

  List<Widget> getToolbarItem() {
    List<Widget> list = [];
    diamondConfig.toolbarList.forEach((element) {
      list.add(GestureDetector(
        onTap: () {
          manageToolbarClick(element);
        },
        child: Padding(
            padding: EdgeInsets.only(right: getSize(8.0)),
            child: Container(
              child: Row(
                children: <Widget>[
                  Transform.scale(
                    scale: 1,
                    child: Checkbox(
                      value: this.isCheckBoxChecked,
                      activeColor: appTheme.colorPrimary,
                      onChanged: (bool value) {
                        setState(
                          () {
                            this.isCheckBoxChecked = value;
                            whenCheckBoxIsChecked();
                          },
                        );
                      },
                    ),
                  ),
                  // SizedBox(width: getSize(5),),
                  Text(
                    "Show only difference",
                    style: appTheme.blackNormal12TitleColorblack,
                  ),
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
          arrayDiamond[index].isSelected = !arrayDiamond[index].isSelected;
        });
        break;
    }
  }

  manageToolbarClick(BottomTabModel model) {
    switch (model.code) {
      case BottomCodeConstant.TBDownloadView:
        break;
    }
  }

  whenCheckBoxIsChecked() {
    Map<String, Set<String>> map = {};
    for (int i = 0; i < arrayDiamond.length; i++) {
      if (map[DiamondDetailUIAPIKeys.pricePerCarat] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].getPricePerCarat().toString());
        map[DiamondDetailUIAPIKeys.pricePerCarat] = s;
      } else {
        map[DiamondDetailUIAPIKeys.pricePerCarat]
            .add(arrayDiamond[i].getPricePerCarat().toString());
      }

      if (map[DiamondDetailUIAPIKeys.amount] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].getAmount().toString());
        map[DiamondDetailUIAPIKeys.amount] = s;
      } else {
        map[DiamondDetailUIAPIKeys.amount]
            .add(arrayDiamond[i].getAmount().toString());
      }

      if (map[DiamondDetailUIAPIKeys.stoneId] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].stoneId.toString());
        map[DiamondDetailUIAPIKeys.stoneId] = s;
      } else {
        map[DiamondDetailUIAPIKeys.stoneId]
            .add(arrayDiamond[i].stoneId.toString());
      }
      // print
      if (map[DiamondDetailUIAPIKeys.shpNm] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].shpNm.toString());
        map[DiamondDetailUIAPIKeys.shpNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.shpNm].add(arrayDiamond[i].shpNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.crt] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].crt.toString());
        map[DiamondDetailUIAPIKeys.crt] = s;
      } else {
        map[DiamondDetailUIAPIKeys.crt].add(arrayDiamond[i].crt.toString());
      }

      if (map[DiamondDetailUIAPIKeys.shdNm] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].shdNm.toString());
        map[DiamondDetailUIAPIKeys.shdNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.shdNm].add(arrayDiamond[i].shdNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.cutNm] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].cutNm.toString());
        map[DiamondDetailUIAPIKeys.cutNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.cutNm].add(arrayDiamond[i].cutNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.polNm] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].polNm.toString());
        map[DiamondDetailUIAPIKeys.polNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.polNm].add(arrayDiamond[i].polNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.symNm] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].symNm.toString());
        map[DiamondDetailUIAPIKeys.symNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.symNm].add(arrayDiamond[i].symNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.fluNm] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].fluNm.toString());
        map[DiamondDetailUIAPIKeys.fluNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.fluNm].add(arrayDiamond[i].fluNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.lbNm] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].lbNm.toString());
        map[DiamondDetailUIAPIKeys.lbNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.lbNm].add(arrayDiamond[i].lbNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.rptNo] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].rptNo.toString());
        map[DiamondDetailUIAPIKeys.rptNo] = s;
      } else {
        map[DiamondDetailUIAPIKeys.rptNo].add(arrayDiamond[i].rptNo.toString());
      }

      if (map[DiamondDetailUIAPIKeys.back] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].back.toString());
        map[DiamondDetailUIAPIKeys.back] = s;
      } else {
        map[DiamondDetailUIAPIKeys.back].add(arrayDiamond[i].back.toString());
      }

      if (map[DiamondDetailUIAPIKeys.eClnNm] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].eClnNm.toString());
        map[DiamondDetailUIAPIKeys.eClnNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.eClnNm]
            .add(arrayDiamond[i].eClnNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.length] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].length.toString());
        map[DiamondDetailUIAPIKeys.length] = s;
      } else {
        map[DiamondDetailUIAPIKeys.length]
            .add(arrayDiamond[i].length.toString());
      }

      if (map[DiamondDetailUIAPIKeys.width] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].width.toString());
        map[DiamondDetailUIAPIKeys.width] = s;
      } else {
        map[DiamondDetailUIAPIKeys.width].add(arrayDiamond[i].width.toString());
      }

      if (map[DiamondDetailUIAPIKeys.height] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].height.toString());
        map[DiamondDetailUIAPIKeys.height] = s;
      } else {
        map[DiamondDetailUIAPIKeys.height]
            .add(arrayDiamond[i].height.toString());
      }

      if (map[DiamondDetailUIAPIKeys.ratio] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].ratio.toString());
        map[DiamondDetailUIAPIKeys.ratio] = s;
      } else {
        map[DiamondDetailUIAPIKeys.ratio].add(arrayDiamond[i].ratio.toString());
      }

      if (map[DiamondDetailUIAPIKeys.depPer] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].depPer.toString());
        map[DiamondDetailUIAPIKeys.depPer] = s;
      } else {
        map[DiamondDetailUIAPIKeys.depPer]
            .add(arrayDiamond[i].depPer.toString());
      }

      if (map[DiamondDetailUIAPIKeys.tblPer] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].tblPer.toString());
        map[DiamondDetailUIAPIKeys.tblPer] = s;
      } else {
        map[DiamondDetailUIAPIKeys.tblPer]
            .add(arrayDiamond[i].tblPer.toString());
      }

      if (map[DiamondDetailUIAPIKeys.cHgt] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].cHgt.toString());
        map[DiamondDetailUIAPIKeys.cHgt] = s;
      } else {
        map[DiamondDetailUIAPIKeys.cHgt].add(arrayDiamond[i].cHgt.toString());
      }

      if (map[DiamondDetailUIAPIKeys.cAng] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].cAng.toString());
        map[DiamondDetailUIAPIKeys.cAng] = s;
      } else {
        map[DiamondDetailUIAPIKeys.cAng].add(arrayDiamond[i].cAng.toString());
      }

      if (map[DiamondDetailUIAPIKeys.pAng] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].pAng.toString());
        map[DiamondDetailUIAPIKeys.pAng] = s;
      } else {
        map[DiamondDetailUIAPIKeys.pAng].add(arrayDiamond[i].pAng.toString());
      }

      if (map[DiamondDetailUIAPIKeys.girdleStr] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].girdleStr.toString());
        map[DiamondDetailUIAPIKeys.girdleStr] = s;
      } else {
        map[DiamondDetailUIAPIKeys.girdleStr]
            .add(arrayDiamond[i].girdleStr.toString());
      }

      if (map[DiamondDetailUIAPIKeys.grdlCondNm] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].grdlCondNm.toString());
        map[DiamondDetailUIAPIKeys.grdlCondNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.grdlCondNm]
            .add(arrayDiamond[i].grdlCondNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.cultNm] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].cultNm.toString());
        map[DiamondDetailUIAPIKeys.cultNm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.cultNm]
            .add(arrayDiamond[i].cultNm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.hANm] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].hANm.toString());
        map[DiamondDetailUIAPIKeys.hANm] = s;
      } else {
        map[DiamondDetailUIAPIKeys.hANm].add(arrayDiamond[i].hANm.toString());
      }

      if (map[DiamondDetailUIAPIKeys.kToSStr] == null) {
        Set<String> s = {};
        s.add(arrayDiamond[i].kToSStr.toString());
        map[DiamondDetailUIAPIKeys.kToSStr] = s;
      } else {
        map[DiamondDetailUIAPIKeys.kToSStr]
            .add(arrayDiamond[i].kToSStr.toString());
      }
      // map[DiamondDetailUIAPIKeys.shpNm].add(arrayDiamond[i].shpNm.toString());
      // map[DiamondDetailUIAPIKeys.crt].add(arrayDiamond[i].crt.toString());
      // map[DiamondDetailUIAPIKeys.shdNm].add(arrayDiamond[i].shdNm.toString());
      // map[DiamondDetailUIAPIKeys.cutNm].add(arrayDiamond[i].cutNm.toString());
      // map[DiamondDetailUIAPIKeys.polNm].add(arrayDiamond[i].polNm.toString());
      // map[DiamondDetailUIAPIKeys.symNm].add(arrayDiamond[i].symNm.toString());
      // map[DiamondDetailUIAPIKeys.fluNm].add(arrayDiamond[i].fluNm.toString());
      // map[DiamondDetailUIAPIKeys.lbNm].add(arrayDiamond[i].lbNm.toString());
      // map[DiamondDetailUIAPIKeys.rptNo].add(arrayDiamond[i].rptNo.toString());
      // map[DiamondDetailUIAPIKeys.back].add(arrayDiamond[i].back.toString());
      // map[DiamondDetailUIAPIKeys.mlkNm].add(arrayDiamond[i].);
      // map[DiamondDetailUIAPIKeys.eClnNm].add(arrayDiamond[i].eClnNm.toString());
      // map[DiamondDetailUIAPIKeys.length].add(arrayDiamond[i].length.toString());
      // map[DiamondDetailUIAPIKeys.width].add(arrayDiamond[i].width.toString());
      // map[DiamondDetailUIAPIKeys.height].add(arrayDiamond[i].height.toString());
      // map[DiamondDetailUIAPIKeys.ratio].add(arrayDiamond[i].ratio.toString());
      // map[DiamondDetailUIAPIKeys.depPer].add(arrayDiamond[i].depPer.toString());
      // map[DiamondDetailUIAPIKeys.tblPer].add(arrayDiamond[i].tblPer.toString());
      // map[DiamondDetailUIAPIKeys.cHgt].add(arrayDiamond[i].cHgt.toString());
      // map[DiamondDetailUIAPIKeys.cAng].add(arrayDiamond[i].cAng.toString());
      // map[DiamondDetailUIAPIKeys.pAng].add(arrayDiamond[i].pAng.toString());
      // map[DiamondDetailUIAPIKeys.girdleStr].add(arrayDiamond[i].girdleStr.toString());
      // map[DiamondDetailUIAPIKeys.grdlCondNm].add(arrayDiamond[i].grdlCondNm.toString());
      // map[DiamondDetailUIAPIKeys.cultNm].add(arrayDiamond[i].cultNm.toString());
      // // map[DiamondDetailUIAPIKeys.cultCondNm].add(arrayDiamond[i].cultCondNm);
      // map[DiamondDetailUIAPIKeys.hANm].add(arrayDiamond[i].hANm.toString());
      // // map[DiamondDetailUIAPIKeys.comments].add(arrayDiamond[i].comments);
      // map[DiamondDetailUIAPIKeys.kToSStr].add(arrayDiamond[i].kToSStr.toString());

    }

    for (int i = 0; i < map.length; i++) {
      if (map[DiamondDetailUIAPIKeys.amount].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.amount);
      if (map[DiamondDetailUIAPIKeys.pricePerCarat].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.pricePerCarat);
      if (map[DiamondDetailUIAPIKeys.stoneId].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.stoneId);
      if (map[DiamondDetailUIAPIKeys.shpNm].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.shpNm);
      if (map[DiamondDetailUIAPIKeys.crt].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.crt);
      if (map[DiamondDetailUIAPIKeys.shdNm].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.shdNm);
      if (map[DiamondDetailUIAPIKeys.cutNm].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.cutNm);
      if (map[DiamondDetailUIAPIKeys.polNm].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.polNm);
      if (map[DiamondDetailUIAPIKeys.symNm].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.symNm);
      if (map[DiamondDetailUIAPIKeys.fluNm].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.fluNm);
      if (map[DiamondDetailUIAPIKeys.lbNm].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.lbNm);
      if (map[DiamondDetailUIAPIKeys.rptNo].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.rptNo);
      if (map[DiamondDetailUIAPIKeys.back].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.back);
      if (map[DiamondDetailUIAPIKeys.eClnNm].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.eClnNm);
      if (map[DiamondDetailUIAPIKeys.length].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.length);
      if (map[DiamondDetailUIAPIKeys.width].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.width);
      if (map[DiamondDetailUIAPIKeys.height].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.height);
      if (map[DiamondDetailUIAPIKeys.ratio].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.ratio);
      if (map[DiamondDetailUIAPIKeys.depPer].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.depPer);
      if (map[DiamondDetailUIAPIKeys.tblPer].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.tblPer);
      if (map[DiamondDetailUIAPIKeys.cHgt].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.cHgt);
      if (map[DiamondDetailUIAPIKeys.cAng].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.cAng);
      if (map[DiamondDetailUIAPIKeys.pAng].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.pAng);
      if (map[DiamondDetailUIAPIKeys.girdleStr].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.girdleStr);
      if (map[DiamondDetailUIAPIKeys.grdlCondNm].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.grdlCondNm);
      if (map[DiamondDetailUIAPIKeys.cultNm].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.cultNm);
      if (map[DiamondDetailUIAPIKeys.hANm].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.hANm);
      if (map[DiamondDetailUIAPIKeys.kToSStr].length == 1)
        ignorableApiKeys.add(DiamondDetailUIAPIKeys.kToSStr);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        R.string().screenTitle.compareStones,
        textalign: TextAlign.left,
        bgColor: appTheme.whiteColor,
        leadingButton: getBackButton(context),
        centerTitle: false,
        actionItems: getToolbarItem(),
      ),
      bottomNavigationBar: getBottomTab(),
      body: Padding(
        padding: EdgeInsets.only(left: getSize(20), right: getSize(20)),
        child: Directionality(
          textDirection: TextDirection.ltr,
                  child: ReorderableListView(

            scrollController: ScrollController(initialScrollOffset: 50),
            onReorder: _onReorder,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            children: List.generate(
              arrayDiamond.length,
              (index) {
                ScrollController sc  = _controllers.addAndGet();
                return !isCheckBoxChecked || arrayDiamond.length==1
                    ? DiamondCompareWidget(
                        sc:sc,
                        diamondModel: this.arrayDiamond[index],
                        index: index,
                        key: Key(index.toString()),
                        deleteWidget: (index) {
                          setState(() {
                            arrayDiamond.removeAt(index);
                            if(arrayDiamond.length==1){
                              Navigator.of(context).pop();
                            }
                          });
                        },
                      )
                    : DiamondCompareWidget(
                        sc: sc,
                        ignorableApiKeys: ignorableApiKeys,
                        diamondModel: this.arrayDiamond[index],
                        index: index,
                        key: Key(index.toString()),
                        deleteWidget: (index) {
                          setState(() {
                            arrayDiamond.removeAt(index);
                            if(arrayDiamond.length==1){
                              Navigator.of(context).pop();
                            }
                          });
                        },
                      );
                // return Image.asset(
                //   placeHolder,
                //   width: getSize(200),
                //   height: getSize(2000),
                //   key: Key(index.toString()),
                // );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getBottomTab() {
    return BottomTabbarWidget(
      arrBottomTab: diamondConfig.arrBottomTab,
      onClickCallback: (obj) {
        if (obj.type == ActionMenuConstant.ACTION_TYPE_MORE) {
          showBottomSheetForMenu(context, diamondConfig.arrMoreMenu,
              (manageClick) {
            manageBottomMenuClick(manageClick.bottomTabModel);
          }, R.string().commonString.more, isDisplaySelection: false);
        } else {
          manageBottomMenuClick(obj);
        }
      },
    );
  }

  manageBottomMenuClick(BottomTabModel bottomTabModel) {
    List<DiamondModel> selectedList =
        arrayDiamond.where((element) => element.isSelected).toList();
    if (selectedList != null && selectedList.length > 0) {
      diamondConfig.manageDiamondAction(context, selectedList, bottomTabModel);
    } else {
      app.resolve<CustomDialogs>().errorDialog(
          context, "Selection", "Please select at least one stone.",
          btntitle: R.string().commonString.ok);
    }
  }
}
