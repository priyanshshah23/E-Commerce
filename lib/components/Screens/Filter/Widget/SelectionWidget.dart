import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rxbus/rxbus.dart';

class SelectionWidget extends StatefulWidget {
  SelectionModel selectionModel;
  SelectionWidget(this.selectionModel);

  @override
  _SelectionWidgetState createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.selectionModel.verticalScroll
        ? ShapeWidget(widget.selectionModel)
        : TagWidget(widget.selectionModel);
  }
}

class TagWidget extends StatefulWidget {
  SelectionModel model;
  TagWidget(this.model);

  @override
  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  var _focusMinValue = FocusNode();
  var _focusMaxValue = FocusNode();
  String oldValueForFrom;
  String oldValueForTo;
  var myFormat = DateFormat('d-MM-yyyy');
  DateTime fromDate, toDate;

  @override
  void initState() {
    super.initState();
    if (widget.model.isShowAll == true) {
      if (widget.model.masters
              .where((element) => element.sId == widget.model.allLableTitle)
              .toList()
              .length ==
          0) {
        Master allMaster = Master();
        allMaster.sId = widget.model.allLableTitle;
        allMaster.webDisplay = widget.model.allLableTitle;
        allMaster.isSelected = false;

        widget.model.masters.insert(0, allMaster);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.verticalScroll == false &&
        widget.model.viewType == ViewTypes.shapeWidget) {
      return getShapeWidgetHorizontal();
    }

    if (widget.model.masterCode == MasterCode.arrivals) {
      return getArrivalsWidget();
    }

    return widget.model.orientation == DisplayTypes.vertical
        ? getVerticalOrientation()
        : getHorizontalOrientation();
  }

  Widget getVerticalOrientation() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isNullEmptyOrFalse(widget.model.megaTitle)
            ? SizedBox()
            : Text(
                widget.model.megaTitle ?? "",
                style: appTheme.blackNormal18TitleColorblack.copyWith(
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
        !isNullEmptyOrFalse(widget.model.megaTitle)
            ? SizedBox(height: getSize(16))
            : SizedBox(),
        isNullEmptyOrFalse(widget.model.title)
            ? SizedBox()
            : Text(
                widget.model.title ?? "",
                style: appTheme.blackNormal18TitleColorblack,
                textAlign: TextAlign.left,
              ),
        isNullEmptyOrFalse(widget.model.title)
            ? SizedBox()
            : SizedBox(height: getSize(20)),
        Container(
          height: getSize(40),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.model.masters.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: getSingleTag(index),
                onTap: () {
                  setState(() {
                    widget.model.masters[index].isSelected =
                        !widget.model.masters[index].isSelected;

                    onSelectionClick(index);
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget getHorizontalOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        isNullEmptyOrFalse(widget.model.title)
            ? SizedBox()
            : Container(
                width: getSize(80),
                child: Text(
                  widget.model.title ?? "",
                  style: appTheme.blackNormal14TitleColorblack,
                  textAlign: TextAlign.left,
                ),
              ),
        isNullEmptyOrFalse(widget.model.title)
            ? SizedBox()
            : SizedBox(width: getSize(30)),
        Expanded(
          child: Container(
            height: getSize(40),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.model.masters.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: getSingleTag(index),
                  onTap: () {
                    setState(() {
                      widget.model.masters[index].isSelected =
                          !widget.model.masters[index].isSelected;

                      getMultipleMasterSelections(index);
                    });
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  getSingleTag(int index) {
    return Padding(
      padding: EdgeInsets.only(right: getSize(8.0)),
      child: Container(
        decoration: BoxDecoration(
          color: widget.model.masters[index].isSelected
              ? appTheme.selectedFilterColor
              : appTheme.unSelectedBgColor,
          border: Border.all(
            width: getSize(1.0),
            color: widget.model.masters[index].isSelected
                ? appTheme.colorPrimary
                : appTheme.borderColor,
          ),
          borderRadius: BorderRadius.circular(
            getSize(5),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: getSize(8.0),
              bottom: getSize(8.0),
              right: getSize(16.0),
              left: getSize(16.0)),
          child: Center(
            child: Text(
              widget.model.masters[index].webDisplay,
              style: widget.model.masters[index].isSelected
                  ? appTheme.primaryColor14TextStyle
                  : appTheme.blackNormal14TitleColorblack,
            ),
          ),
        ),
      ),
    );
  }

  getShapeWidgetHorizontal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: getSize(100),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.model.masters.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(right: getSize(8)),
                    child: ShapeItemWidget(
                      obj: widget.model.masters[index],
                      selectionModel: widget.model,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      widget.model.masters[index].isSelected =
                          !widget.model.masters[index].isSelected;

                      onSelectionClick(index);
                    });
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  getArrivalsWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isNullEmptyOrFalse(widget.model.title)
            ? SizedBox()
            : Row(
                children: [
                  Text(
                    widget.model.title ?? "",
                    style: appTheme.blackNormal18TitleColorblack,
                    textAlign: TextAlign.left,
                  ),
                  Spacer(),
                  getFromTextField(),
                  SizedBox(
                    width: getSize(8),
                  ),
                  getToTextField(),
                ],
              ),
        isNullEmptyOrFalse(widget.model.title)
            ? SizedBox()
            : SizedBox(height: getSize(20)),
        Container(
          height: getSize(40),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.model.masters.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: getSingleTag(index),
                onTap: () {
                  setState(() {
                    widget.model.masters[index].isSelected =
                        !widget.model.masters[index].isSelected;

                    getMultipleMasterSelections(index);
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  getFromTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(getSize(10)),
        border: Border.all(
          width: getSize(1.0),
          color: widget.model.fromToStyle.showUnderline
              ? Colors.transparent
              : appTheme.borderColor,
        ),
      ),
      width: getSize(100),
      height: getSize(40),
      child: TextField(
        readOnly: true,
        textAlign: widget.model.fromToStyle.showUnderline
            ? TextAlign.left
            : TextAlign.center,
        onTap: () {
          _selectFromDate(context);
        },
        style: appTheme.blackNormal14TitleColorblack,
        focusNode: _focusMinValue,
        controller: _fromDateController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          focusedBorder: widget.model.fromToStyle.showUnderline
              ? new UnderlineInputBorder(
                  borderSide: new BorderSide(
                  color: widget.model.fromToStyle.underlineColor,
                ))
              : InputBorder.none,
          enabledBorder: widget.model.fromToStyle.showUnderline
              ? new UnderlineInputBorder(
                  borderSide: new BorderSide(
                  color: widget.model.fromToStyle.underlineColor,
                ))
              : InputBorder.none,
          hintText: "From",
          hintStyle: appTheme.grey14HintTextStyle,
        ),
      ),
    );
  }

  getToTextField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(getSize(10)),
        border: Border.all(
          width: getSize(1.0),
          color: widget.model.fromToStyle.showUnderline
              ? Colors.transparent
              : appTheme.borderColor,
        ),
      ),
      width: getSize(100),
      height: getSize(40),
      child: TextField(
        readOnly: true,
        textAlign: widget.model.fromToStyle.showUnderline
            ? TextAlign.left
            : TextAlign.center,
        onTap: () {
          if (!isNullEmptyOrFalse(_fromDateController.text)) {
            _selectToDate(context);
          } else {
            app.resolve<CustomDialogs>().confirmDialog(
                  context,
                  title: "Warning",
                  desc: "select fromdate first",
                  positiveBtnTitle: "Try Again",
                );
          }
        },
        focusNode: _focusMaxValue,
        controller: _toDateController,
        style: appTheme.blackNormal14TitleColorblack,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          focusedBorder: widget.model.fromToStyle.showUnderline
              ? new UnderlineInputBorder(
                  borderSide: new BorderSide(
                  color: widget.model.fromToStyle.underlineColor,
                ))
              : InputBorder.none,
          enabledBorder: widget.model.fromToStyle.showUnderline
              ? new UnderlineInputBorder(
                  borderSide: new BorderSide(
                  color: widget.model.fromToStyle.underlineColor,
                ))
              : InputBorder.none,
          hintText: "To",
          hintStyle: appTheme.grey14HintTextStyle,
        ),
      ),
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    setState(() {
      if (!isNullEmptyOrFalse(picked)) {
        fromDate = picked;
        _fromDateController.text = myFormat.format(picked);
      }
      ;
      print("From Date====>" + fromDate.toString());
    });
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: fromDate,
      lastDate: DateTime(2101),
    );
    setState(() {
      if (!isNullEmptyOrFalse(picked)) {
        toDate = picked;
        _toDateController.text = myFormat.format(picked);
      }
      ;
      print("To Date====>" + toDate.toString());
    });
  }

  getMultipleMasterSelections(int index) {
    //When Local data has added and multilple master has to select
    if (widget.model.isSingleSelection) {
      for (var item in widget.model.masters) {
        if (item.code != MasterCode.noBgm) {
          if (item != widget.model.masters[index]) {
            item.isSelected = false;
          }
        }
      }

      if (!isNullEmptyOrFalse(widget.model.masterSelection)) {
        Map<MasterSelection, bool> m = Map<MasterSelection, bool>();
        m[widget.model.masterSelection[index]] =
            widget.model.masters[index].isSelected;

        RxBus.post(m, tag: eventMasterSelection);
      }
    } else {
      if (widget.model.masterCode == MasterCode.cut ||
          widget.model.masterCode == MasterCode.polish ||
          widget.model.masterCode == MasterCode.symmetry) {
        RxBus.post(false, tag: eventMasterForDeSelectMake);
      }
      onSelectionClick(index);
    }
  }

  void onSelectionClick(int index) {
    if (widget.model.isShowAll == true) {
      if (widget.model.masters[index].sId == widget.model.allLableTitle) {
        if (widget.model.masters[0].isSelected == true) {
          widget.model.masters.forEach((element) {
            element.isSelected = true;
          });

          //Group Logic is Selected
          if (widget.model.viewType == ViewTypes.groupWidget) {
            Map<String, bool> m = Map<String, bool>();
            m[widget.model.masterCode] = widget.model.masters[index].isSelected;
            RxBus.post(m, tag: eventMasterForGroupWidgetSelectAll);
          }
        } else {
          widget.model.masters.forEach((element) {
            element.isSelected = false;
          });

          //Group Logic is Selected
          if (widget.model.viewType == ViewTypes.groupWidget) {
            Map<String, bool> m = Map<String, bool>();
            m[widget.model.masterCode] = widget.model.masters[index].isSelected;
            RxBus.post(m, tag: eventMasterForGroupWidgetSelectAll);
          }
        }
      } else {
        if (widget.model.masters[index].sId == widget.model.allLableTitle) {
          widget.model.masters.forEach((element) {
            element.isSelected = false;
          });
        } else {
          if (widget.model.masters
                  .where((element) =>
                      element.isSelected == true &&
                      element.sId != widget.model.allLableTitle)
                  .toList()
                  .length ==
              widget.model.masters.length - 1) {
            widget.model.masters[0].isSelected = true;
          } else {
            widget.model.masters[0].isSelected = false;
            Map<String, dynamic> m = Map<String, dynamic>();
            m["masterCode"] = widget.model.masterCode;
            m["isSelected"] = widget.model.masters[index].isSelected;
            m["selectedMasterCode"] = widget.model.masters[index].code;
            m["masterSelection"] = widget.model.masterSelection;
            if (widget.model.viewType == ViewTypes.groupWidget) {
              m["isGroupSelected"] =
                  (widget.model as ColorModel).isGroupSelected;
              RxBus.post(m, tag: eventMasterForSingleItemOfGroupSelection);
            }
          }
        }
      }
    }
  }
}
