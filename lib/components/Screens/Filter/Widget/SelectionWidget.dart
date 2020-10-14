import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diamnow/app/app.export.dart';
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

    return widget.model.orientation == DisplayTypes.vertical
        ? getVerticalOrientation()
        : getHorizontalOrientation();
  }

  Widget getVerticalOrientation() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  getMultipleMasterSelections(int index) {
    //When Local data has added and multilple master has to select
    if (widget.model.isSingleSelection) {
      for (var item in widget.model.masters) {
        if (widget.model.masters[index].code != "NoBGM") {
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
        } else {
          widget.model.masters.forEach((element) {
            element.isSelected = false;
          });
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
          }
        }
      }
    }
  }
}
