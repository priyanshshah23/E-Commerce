import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/app/utils/string_utils.dart';
import 'package:diamnow/components/Screens/Filter/FilterScreen.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceCalculator extends StatefulWidget {
  static const route = "PriceCalculator";
  bool isFromDrawer;

  PriceCalculator(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.IsFromDrawer] != null) {
        isFromDrawer = arguments[ArgumentConstant.IsFromDrawer];
      }
    }
  }

  @override
  _PriceCalculatorState createState() => _PriceCalculatorState();
}

class _PriceCalculatorState extends State<PriceCalculator> {
  List<Master> arrColors = [];
  List<Master> arrShape = [];
  List<Master> arrClarity = [];
  Config config = Config();
  List<FormBaseModel> arrData = [];
  String flCode = "fl";
  String ifCode = "if";
  String si2Code = "si2";
  String si2DesCode = "si2-";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      config.getFilterJson().then((result) {
        setState(() {
          arrData = result
              .where((element) => element.viewType == ViewTypes.shapeWidget)
              .toList();

          //Get Shape MAster
          if (true) {
            FormBaseModel shapeMaster = arrData.singleWhere(
                (element) => element.viewType == ViewTypes.shapeWidget);

            if (!isNullEmptyOrFalse(shapeMaster)) {
              if (shapeMaster is SelectionModel) {
                shapeMaster.verticalScroll = false;
                shapeMaster.orientation = DisplayTypes.horizontal;
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
              // var test = (MathUtilities.screenWidth(context) - getSize(120)) /
              //     arrClarity.length;
              // outPutWidth = test < rowWidth ? rowWidth : test;

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
              }

              setState(() {});
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        "Price Calculator",
        // bgColor: appTheme.whiteColor,
        leadingButton: getDrawerButton(context, true),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(
          getSize(16),
        ),
        child: Column(
          children: [
            getShapeColorClarityContainer(),
          ],
        ),
      ),
    );
  }

  getShapeColorClarityContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            getSize(10),
          ),
          color: appTheme.colorPrimary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterItem(
            arrData,
            moduleType: DiamondModuleConstant.MODULE_TYPE_PRICE_CALCULATOR,
          ),
          getColorClarityPickerView(),
        ],
      ),
    );
  }

  //get Color and Clarity pickerview
  getColorClarityPickerView() {
    return Container(
      height: getSize(100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isNullEmptyOrFalse(arrColors) == false
              ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        getSize(16), getSize(16), getSize(16), getSize(16)),
                    child: Container(
                      width: getSize(100),
                      child: CupertinoPicker.builder(
                        itemExtent: getSize(20),
                        childCount: arrColors.length,
                        onSelectedItemChanged: (index) {},
                        itemBuilder: (context, index) {
                          return Text(
                            arrColors[index].getName(),
                            style: appTheme.black14TextStyle,
                          );
                        },
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          isNullEmptyOrFalse(arrClarity) == false
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: getSize(100),
                      child: CupertinoPicker.builder(
                        itemExtent: getSize(20),
                        childCount: arrClarity.length,
                        onSelectedItemChanged: (index) {},
                        itemBuilder: (context, index) {
                          return Text(
                            arrClarity[index].getName(),
                            style: appTheme.black14TextStyle,
                          );
                        },
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
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
}
