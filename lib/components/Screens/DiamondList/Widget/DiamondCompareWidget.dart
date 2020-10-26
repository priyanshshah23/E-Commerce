import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/constant/ApiConstants.dart';
import 'package:diamnow/app/constant/ColorConstant.dart';
import 'package:diamnow/app/utils/ImageUtils.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/app/utils/string_utils.dart';
import 'package:diamnow/models/DiamondDetail/DiamondDetailUIModel.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

typedef DeleteWidget = Function(int);

class DiamondCompareWidget extends StatefulWidget {
  DiamondModel diamondModel;
  int index;
  Key key;
  Function onDelete;
  DeleteWidget deleteWidget;
  List<DiamondDetailUIModel> arrDiamondDetailUIModel =
      List<DiamondDetailUIModel>();

  List<String> ignorableApiKeys;

  ScrollController sc;

  DiamondCompareWidget(
      {this.diamondModel,
      this.index,
      this.key,
      this.deleteWidget,
      this.ignorableApiKeys,
      this.sc});

  @override
  _DiamondCompareWidgetState createState() => _DiamondCompareWidgetState(
      diamondModel: diamondModel,
      index: index,
      key: key,
      ignorableApiKeys: ignorableApiKeys);
}

class _DiamondCompareWidgetState extends State<DiamondCompareWidget> {
  DiamondModel diamondModel;
  int index;
  Key key;
  bool isShowLabel;
  List<String> ignorableApiKeys;

  List<DiamondDetailUIModel> arrDiamondDetailUIModel =
      List<DiamondDetailUIModel>();

  _DiamondCompareWidgetState(
      {this.diamondModel, this.index, this.key, this.ignorableApiKeys});

  @override
  void initState() {
    super.initState();

    if (index == 0) {
      isShowLabel = true;
    } else {
      isShowLabel = false;
    }

    Config().getDiamonCompareUIJson().then((result) {
      setState(() {
        setupDiamonDetail(result);
      });
    });
  }

  setupDiamonDetail(List<DiamondDetailUIModel> arrModel) {
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
        if (element.isActive) {
          if (isNullEmptyOrFalse(ignorableApiKeys) ||
              !ignorableApiKeys.contains(element.apiKey)) {
            var diamonDetailComponent = DiamondDetailUIComponentModel(
              title: element.title,
              apiKey: element.apiKey,
              sequence: element.sequence,
              isPercentage: element.isPercentage,
              isActive: element.isActive,
            );

            if (isStringEmpty(element.apiKey) == false) {
              dynamic valueElement = diamondModel.toJson()[element.apiKey];
              if (valueElement != null) {
                if (element.apiKey == DiamondDetailUIAPIKeys.pricePerCarat) {
                  //
                  diamonDetailComponent.value = diamondModel.getPricePerCarat();
                } else if (element.apiKey == DiamondDetailUIAPIKeys.amount) {
                  //
                  diamonDetailComponent.value = diamondModel.getAmount();
                } else if (valueElement is String) {
                  diamonDetailComponent.value = valueElement;
                } else if (valueElement is num) {
                  diamonDetailComponent.value = valueElement.toString();
                }
                if (element.isPercentage) {
                  diamonDetailComponent.value =
                      "${diamonDetailComponent.value}%";
                }
                diamondDetailUIModel.parameters.add(diamonDetailComponent);
              }
            }
            // arrDiamondDetailUIModel.add(diamondDetailUIModel);
          } else {
            // var diamonDetailComponent = DiamondDetailUIComponentModel(
            //   title: element.title,
            //   apiKey: element.apiKey,
            //   sequence: element.sequence,
            //   isPercentage: element.isPercentage,
            //   isActive: element.isActive,
            // );

            // if (isStringEmpty(element.apiKey) == false) {
            //   dynamic valueElement = diamondModel.toJson()[element.apiKey];
            //   if (valueElement != null) {
            //     if (element.apiKey == DiamondDetailUIAPIKeys.pricePerCarat) {
            //       //
            //       diamonDetailComponent.value = diamondModel.getPricePerCarat();
            //     } else if (element.apiKey == DiamondDetailUIAPIKeys.amount) {
            //       //
            //       diamonDetailComponent.value = diamondModel.getAmount();
            //     } else if (valueElement is String) {
            //       diamonDetailComponent.value = valueElement;
            //     } else if (valueElement is num) {
            //       diamonDetailComponent.value = valueElement.toString();
            //     }
            //     if (element.isPercentage) {
            //       diamonDetailComponent.value =
            //           "${diamonDetailComponent.value}%";
            //     }
            //     diamondDetailUIModel.parameters.add(diamonDetailComponent);
            //   }
            // }
          }
        }
      }

      //sort list according to sequence.
      // diamondDetailUIModel.parameters.sort((model1, model2) {
      //   return model1.sequence.compareTo(model2.sequence);
      // });

      arrDiamondDetailUIModel.add(diamondDetailUIModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isNullEmptyOrFalse(arrDiamondDetailUIModel)
        ? Column(
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
                        border: index == 0 || diamondModel.isSelected == true
                            ? (Border.all(
                                color: diamondModel.isSelected == true
                                    ? appTheme.colorPrimary
                                    : appTheme.dividerColor,
                              ))
                            : Border(
                                // left: BorderSide(
                                //     width: getSize(1),
                                //     color: appTheme.dividerColor),
                                top: BorderSide(
                                    width: getSize(1),
                                    color: appTheme.dividerColor),
                                bottom: BorderSide(
                                    width: getSize(1),
                                    color: appTheme.dividerColor),
                                right: BorderSide(
                                    width: getSize(1),
                                    color: appTheme.dividerColor),
                              )),
                    child: getImageView(
                        DiamondUrls.image + diamondModel.vStnId + ".jpg",
                        height: getSize(70),
                        width: getSize(40),
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
                          color: diamondModel.isSelected == true
                              ? appTheme.colorPrimary
                              : appTheme.textBlackColor,
                        ),
                        onPressed: () {
                          setState(() {
                            diamondModel.isSelected = !diamondModel.isSelected;
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
                          widget.deleteWidget(index);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: widget.sc,
                  child: Column(
                    children: <Widget>[
                      for (int i = 0; i < arrDiamondDetailUIModel.length; i++)
                        for (int j = 0;
                            j < arrDiamondDetailUIModel[i].parameters.length;
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
                                      color: ColorConstants
                                          .compareChangesRowBgColor,
                                      // border: Border(
                                      //   left: BorderSide(width: getSize(0.5)),
                                      //   right: BorderSide(width: getSize(0.5)),
                                      // ),
                                    ),
                                    child: isShowLabel
                                        ? Text(
                                            arrDiamondDetailUIModel[i]
                                                .parameters[j]
                                                .title,
                                            style: appTheme
                                                .blackNormal12TitleColorblack,
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
                                    arrDiamondDetailUIModel[i]
                                        .parameters[j]
                                        .value,
                                    style:
                                        appTheme.blackNormal14TitleColorblack,
                                  ),
                                )
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              )
            ],
          )
        : SizedBox();
    // return Image.asset(
    //   placeHolder,
    //   width: getSize(200),
    //   height: getSize(2000),
    //   key: Key(index.toString()),
    // );
  }
}
