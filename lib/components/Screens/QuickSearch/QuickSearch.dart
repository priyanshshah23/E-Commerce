import 'dart:collection';
import 'dart:math';

import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/Libraries/horizontalTableView/horizontal_data_table.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/base/BaseApiResp.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/Screens/Filter/Widget/CaratRangeWidget.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/models/QuickSearch/QuickSearchModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxbus/rxbus.dart';

class QuickSearchScreen extends StatefulWidget {
  static const route = "QuickSearchScreen";

  int moduleType = DiamondModuleConstant.MODULE_TYPE_SEARCH;
  bool isFromDrawer = false;

  QuickSearchScreen(Map<String, dynamic> arguments) {
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
  _QuickSearchScreenState createState() => _QuickSearchScreenState();
}

class _QuickSearchScreenState extends State<QuickSearchScreen> {
  List<FormBaseModel> arrData = [];

  Config config = Config();
  String flCode = "fl";
  String ifCode = "if";
  String si2Code = "si2";
  String si2DesCode = "si2-";
  var outPutWidth;
  double cellHeight = getSize(40);
  double rowWidth = getSize(60);
  List<Master> arrColors = [];
  List<Master> arrShape = [];
  List<Master> arrCarat = [];
  List<Master> arrClarity = [];
  List<CellModel> arrCount = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      config.getFilterJson().then((result) {
        setState(() {
          arrData = result
              .where((element) =>
                  element.viewType == ViewTypes.shapeWidget ||
                  element.viewType == ViewTypes.caratRange)
              .toList();

          for (var item in arrData) {
            if (item is SelectionModel) {
              item.isShowAll = false;
              if (item.viewType == ViewTypes.caratRange) {
                item.showFromTo = false;
                item.masters.removeWhere(
                    (element) => element.sId == item.allLableTitle);
                item.masters.first.isSelected = true;
              } else if (item.viewType == ViewTypes.shapeWidget) {
                item.masters.removeWhere(
                    (element) => element.sId == item.allLableTitle);
                item.masters.first.isSelected = true;
              }
            }
          }

          //Get carat MAster
          if (true) {
            FormBaseModel caratMaster = arrData.singleWhere(
                (element) => element.viewType == ViewTypes.caratRange);

            if (!isNullEmptyOrFalse(caratMaster)) {
              if (caratMaster is SelectionModel) {
                arrCarat = caratMaster.masters;
                Master model = caratMaster.masters.first;
                model.isSelected = true;
                for (var item in model.grouped) {
                  item.isSelected = model.isSelected;
                }
              }
            }
          }

          //Get Shape MAster
          if (true) {
            FormBaseModel shapeMaster = arrData.singleWhere(
                (element) => element.viewType == ViewTypes.shapeWidget);

            if (!isNullEmptyOrFalse(shapeMaster)) {
              if (shapeMaster is SelectionModel) {
                arrShape = shapeMaster.masters;
              }
            }
          }

          getCombineColors().then((value) {
            arrColors = value;
            List<Master> list;
            Master master;
            arrColors.forEach((element) {
              list = [];
              if (element.mergeModel != null) {
                element.grouped.addAll(master.mergeModel.grouped);
              }

              element.groupingIds = [];
              element.grouped.forEach((groupItem) {
                element.groupingIds.add(groupItem.sId);
              });
              if (!element.groupingIds.contains(element.sId)) {
                element.groupingIds.add(master.sId);
              }
            });
            getCombineClarity().then((value) {
              arrClarity = value;
              var test = (MathUtilities.screenWidth(context) - getSize(120)) /
                  arrClarity.length;
              outPutWidth = test < rowWidth ? rowWidth : test;

              for (var item in arrColors) {
                item.isSelected = true;
                list = [];
                arrClarity.forEach((element) {
                  master = Master.fromJson(element.toJson());
                  master.grouped = element.grouped;
                  if (master.mergeModel != null) {
                    master.grouped.addAll(master.mergeModel.grouped);
                  }

                  master.groupingIds = [];
                  master.grouped.forEach((element) {
                    master.groupingIds.add(element.sId);
                  });
                  if (!master.groupingIds.contains(master.sId)) {
                    master.groupingIds.add(master.sId);
                  }
                  list.add(master);
                });
                arrCount.add(CellModel(cellObj: item, dataArr: list));
              }
              callApiForQuickSearch();
            });
          });
        });
      });
    });
    registerRsBus();
  }

  @override
  void dispose() {
    RxBus.destroy(tag: eventForShareCaratRangeSelected);
    super.dispose();
  }

  registerRsBus() {
    RxBus.register<bool>(tag: eventForShareCaratRangeSelected).listen(
      (event) => setState(
        () {
          callApiForQuickSearch();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appTheme.whiteColor,
        appBar: getAppBar(
          context,
          R.string().screenTitle.quickSearch,
          bgColor: appTheme.whiteColor,
          leadingButton: getDrawerButton(context, true),
          centerTitle: false,
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: this.arrData.length,
              itemBuilder: (context, index) {
                return getWidgets(this.arrData[index]);
              },
            ),
            SizedBox(height: getSize(8)),
            isNullEmptyOrFalse(arrClarity)
                ? SizedBox()
                : getHorizontalDataWidget(),
          ],
        ));
  }

  Widget getWidgets(FormBaseModel model) {
    if (model.viewType == ViewTypes.shapeWidget) {
      return Padding(
        padding: EdgeInsets.only(
            left: getSize(16),
            right: getSize(16),
            top: getSize(8.0),
            bottom: getSize(8)),
        child: ShapeWidget(model),
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
    } else {
      return SizedBox();
    }
  }

  //Get Combine Clarity
  Future<List<Master>> getCombineClarity() async {
    List<Master> tempClarity = List<Master>();
    List<Master> clarity = await Master.getSubMaster(MasterCode.clarity);

    for (var item in clarity) {
      item.isSelected = true;
      if (item.webDisplay?.toLowerCase() == flCode) {
        List<Master> findIf = clarity
            .where((element) => element.webDisplay?.toLowerCase() == ifCode)
            .toList();
        if (!isNullEmptyOrFalse(findIf)) {
          item.mergeModel = findIf.first;
          tempClarity.add(item);
        }
      } else if (item.webDisplay?.toLowerCase() == si2Code) {
        List<Master> findSi2 = clarity
            .where((element) => element.webDisplay?.toLowerCase() == si2DesCode)
            .toList();
        if (!isNullEmptyOrFalse(findSi2)) {
          item.mergeModel = findSi2.first;
          tempClarity.add(item);
        }
      } else if (item.webDisplay?.toLowerCase() == ifCode) {
        print("IF");
      } else if (item.webDisplay?.toLowerCase() == si2DesCode) {
        print("SI2");
      } else {
        tempClarity.add(item);
      }
    }

    return tempClarity;
  }

  Future<List<Master>> getCombineColors() async {
    List<Master> tempColor = List<Master>();
    List<Master> color = await Master.getSubMaster(MasterCode.color);

    for (var item in color) {
      item.isSelected = true;
      List<String> arr = [
        "m",
        "n",
        "o",
        "p",
        "q",
        "r",
        "s",
        "t",
        "u",
        "v",
        "w",
        "x",
        "y",
        "z"
      ];

      if (item.webDisplay?.toLowerCase() == "m") {
        for (var str in arr) {
          List<Master> findIf = color
              .where((element) => element.webDisplay?.toLowerCase() == str)
              .toList();
          if (!isNullEmptyOrFalse(findIf)) {
            List<String> arrStr =
                findIf.first.grouped.map((e) => e.sId ?? "").toList();
            for (var id in arrStr) {
              item.groupingIds.add(id);
            }
          }
        }

        item.groupName = "M-Z";
        tempColor.add(item);
      } else if (!arr.contains(item.webDisplay?.toLowerCase() ?? "")) {
        item.groupName = item.webDisplay ?? "";
        tempColor.add(item);
      }
    }

    return tempColor;
  }

  Map<String, dynamic> getPriceRequest() {
    Map<String, dynamic> request = {};
    SelectionModel model = arrData
        .singleWhere((element) => element.viewType == ViewTypes.shapeWidget);
    request["shp"] = Master.getSelectedId(model.masters);

    SelectionModel model1 = arrData
        .singleWhere((element) => element.viewType == ViewTypes.caratRange);
    List<Master> selectedCarat =
        model1.masters.where((element) => element.isSelected).toList();

    var range = List<Map<String, dynamic>>();
    for (var item in selectedCarat) {
      List<num> arrMin = item.grouped.map((e) => e.fromCarat).toList();
      num minFrom = arrMin.reduce(min);

      List<num> arrMax = item.grouped.map((e) => e.toCarat).toList();
      num maxTo = arrMax.reduce(max);

      var rangeDic = Map<String, dynamic>();
      rangeDic["from"] = minFrom;
      rangeDic["to"] = maxTo;
      rangeDic["id"] = item.sId;
      range.add(rangeDic);
    }

    request["range"] = range;
    return request;
  }

  getHorizontalDataWidget() {
    return Padding(
      padding: EdgeInsets.all(getSize(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(getSize(10)),
          border: Border.all(
            width: getSize(1.0),
            color: appTheme.borderColor,
          ),
        ),
        child: HorizontalDataTable(
          elevation: 5,
          leftHandSideColumnWidth: getSize(60),
          rowSeparatorWidget: Divider(
            height: getSize(1),
            color: appTheme.borderColor,
          ),
          rightHandSideColumnWidth: this.arrClarity.length * outPutWidth,
          isFixedHeader: true,
          headerWidgets: _getHorizontalRow(),
          leftSideItemBuilder: _getVerticalColumn,
          rightSideItemBuilder: _generateRightHandSideColumnRow,
          itemCount: arrColors.length,
        ),
        height: (arrColors.length + 1) * cellHeight + 12,
      ),
    );
  }

  List<Widget> _getHorizontalRow() {
    return [
      Container(
        color: appTheme.lightBGColor,
        child: Text(
          R.string().commonString.colorGroup,
          textAlign: TextAlign.center,
          style: appTheme.primaryColor14TextStyle,
        ),
        width: 200,
        height: cellHeight,
        padding: EdgeInsets.only(left: 2, right: 2),
        alignment: Alignment.center,
      ),
      for (var item in arrClarity)
        _getTitleItemWidget(
          item.mergeModel != null && item.webDisplay?.toLowerCase() != "si2"
              ? "${item.webDisplay ?? ""} / ${item.mergeModel?.webDisplay ?? ""}"
              : item.webDisplay ?? "",
          outPutWidth,
        ),
    ];
  }

  Widget _getVerticalColumn(BuildContext context, int index) {
    return Container(
      color: appTheme.lightBGColor,
      child: Text(
        arrColors[index].webDisplay ?? "",
        style: appTheme.primaryColor14TextStyle,
      ),
      width: 100,
      height: cellHeight,
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
    );
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: getSize(0.5),
          color: appTheme.borderColor,
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: appTheme.blackNormal14TitleColorblack,
      ),
      width: width,
      height: cellHeight,
      padding: EdgeInsets.only(left: 2, right: 2),
      alignment: Alignment.center,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < arrCount[index].dataArr.length; i++)
          InkWell(
            onTap: () {
              if (arrCount[index].dataArr[i].count > 0) {
                prepareStoneRequest(
                    this.arrColors[index], arrCount[index].dataArr[i]);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: getSize(0.5),
                  color: appTheme.borderColor,
                ),
              ),
              child: Center(
                child: Text(
                  arrCount[index].dataArr[i].count?.toString() ?? "-",
                  style: appTheme.blackNormal14TitleColorblack,
                ),
              ),
              width: outPutWidth,
              height: cellHeight,
              padding: EdgeInsets.only(left: 4, right: 4),
              alignment: Alignment.center,
            ),
          ),
      ],
    );
  }

//Get Stone Request
  prepareStoneRequest(Master color, Master clarity) {
    Map<String, dynamic> request = Map<String, dynamic>();
    request["shp"] = Master.getSelectedId(arrShape);

    request["or"] = Master.getSelectedCarat(arrCarat);
    //request["col"] = Master.getSelectedId([color]);
    request["col"] = color.groupingIds;

    /*List<String> clarityRequest = Master.getSelectedId([clarity]);
    if (isNullEmptyOrFalse(clarity.mergeModel)) {
      Master mergerModel = clarity.mergeModel;
      clarityRequest.add(mergerModel.sId ?? "");
      for (var item in mergerModel.grouped) {
        if (!clarityRequest.contains(item.sId ?? "")) {
          clarityRequest?.add(item.sId ?? "");
        }
      }
    }
*/
    request["clr"] = clarity.groupingIds;
    SyncManager.instance.callApiForDiamondList(
      context,
      request,
      (diamondListResp) {
        Map<String, dynamic> dict = new HashMap();

        dict["filterId"] = diamondListResp.data.filter.id;
        dict["filters"] = request;
        dict[ArgumentConstant.ModuleType] =
            DiamondModuleConstant.MODULE_TYPE_QUICK_SEARCH;
        NavigationUtilities.pushRoute(DiamondListScreen.route, args: dict);
      },
      (onError) {
        //print("Error");
      },
    );
  }

  callApiForQuickSearch() {
    for (var item in arrCount) {
      List<Master> clarity = item.dataArr;
      for (var clr in clarity) {
        clr.count = 0;
      }
    }

    NetworkCall<QuickSearchResp>()
        .makeCall(
      () => app
          .resolve<ServiceModule>()
          .networkService()
          .quickSearch(getPriceRequest()),
      context,
      isProgress: true,
    )
        .then((resp) async {
      callDiamondCount(resp.data.list);
      /*for (var item in this.arrCount) {
        Master color = item.cellObj;
        List<String> colorId = List<String>();
        if (color.groupingIds.length > 0) {
          colorId = color.groupingIds;
          colorId.add(color.sId);
        } else {
          colorId = color.grouped.map((e) => e.sId).toList();
          colorId.add(color.sId);
        }

        for (var count in resp.data.list) {
          //Color
          if (colorId.contains(count.color)) {
            List<Master> claritys = item.dataArr;

            for (var clarity in claritys) {
              if (clarity.webDisplay?.toLowerCase() == this.flCode ||
                  clarity.webDisplay?.toLowerCase() == this.si2Code) {
                //Merge Clarity
                List<String> clarityId =
                    clarity.grouped.map((e) => e.sId).toList();
                clarityId.add(clarity.sId);

                List<String> mergeClarity =
                    clarity.mergeModel?.grouped?.map((e) => e.sId)?.toList() ??
                        [];
                mergeClarity.add(clarity.mergeModel?.sId);

                if (clarityId.contains(count.clarity) ||
                    mergeClarity.contains(count.clarity)) {
                  clarity.count += count.count;
                  // clarity.totalAmount += count.totalAmount
                  // clarity.carat += count.carat
                  // clarity.arrPrice.append(count.maxPrice)
                  // clarity.arrPrice.append(count.minPrice)
                }
              } else {
                //Another
                List<String> clarityId =
                    clarity.grouped.map((e) => e.sId).toList();
                clarityId.add(clarity.sId);

                if (clarityId.contains(count.clarity)) {
                  clarity.count += count.count;
                  // clarity.totalAmount += count.totalAmount
                  // clarity.carat += count.carat
                  // clarity.arrPrice.append(count.maxPrice)
                  // clarity.arrPrice.append(count.minPrice)

                }
              }
            }
          }
        }
      }*/

      setState(() {});
    }).catchError((onError) {
      print(onError);
    });
  }

  callDiamondCount(List<QuickSearchModel> qsResultList) {
    arrCount.forEach((colorItem) {
      colorItem.dataArr.forEach((clarityItem) {
        clarityItem.count = 0;
      });
    });
    qsResultList.forEach((qsResultItem) {
      arrCount.forEach((colorItem) {
        colorItem.dataArr.forEach((clarityItem) {
          if (clarityItem.groupingIds.contains(qsResultItem.clarity) &&
              colorItem.cellObj.groupingIds.contains(qsResultItem.color)) {
            clarityItem.count += qsResultItem.count;
          }
        });
      });
    });
  }
}

class CellModel {
  Master cellObj;
  List<Master> dataArr;

  CellModel({this.cellObj, this.dataArr});
}
