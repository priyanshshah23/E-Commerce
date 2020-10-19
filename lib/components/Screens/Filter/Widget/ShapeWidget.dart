import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/material.dart';

class ShapeWidget extends StatefulWidget {
  SelectionModel selectionModel;
  ShapeWidget(this.selectionModel);

  @override
  _ShapeWidgetState createState() => _ShapeWidgetState();
}

class _ShapeWidgetState extends State<ShapeWidget> {
  //show when isShowMoreSelected=false;
  int elementsToShow = 11;
  List<Master> listOfMasterView = [];

  @override
  void initState() {
    super.initState();

    if (widget.selectionModel.isShowAll == true &&
        widget.selectionModel.orientation == DisplayTypes.vertical) {
      if (widget.selectionModel.masters
              .where((element) =>
                  element.sId == widget.selectionModel.allLableTitle)
              .toList()
              .length ==
          0) {
        Master allMaster = Master();
        allMaster.sId = widget.selectionModel.allLableTitle;
        allMaster.webDisplay = widget.selectionModel.allLableTitle;
        allMaster.isSelected = false;

        widget.selectionModel.masters.insert(0, allMaster);
      }
    }
    if (widget.selectionModel.isShowMore &&
        widget.selectionModel.orientation == DisplayTypes.vertical) {
      if (widget.selectionModel.masters
              .where((element) => element.sId == "ShowMore")
              .toList()
              .length ==
          0) {
        Master allMaster = Master();
        allMaster.sId = "ShowMore";
        allMaster.webDisplay = widget.selectionModel.isShowMoreSelected
            ? "Show More"
            : "Show Less";
        allMaster.isSelected = false;

        widget.selectionModel.masters
            .insert(widget.selectionModel.masters.length, allMaster);
      }
    }

    for (var masterIndex = 0; masterIndex < elementsToShow; masterIndex++) {
      listOfMasterView.add(widget.selectionModel.masters[masterIndex]);
    }
    listOfMasterView.add(widget
        .selectionModel.masters[widget.selectionModel.masters.length - 1]);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 220) / 2;
    final double itemWidth = size.width / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          widget.selectionModel.title ?? "-",
          style: appTheme.blackNormal18TitleColorblack,
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: getSize(20),
        ),
        widget.selectionModel.verticalScroll
            ? GridView.count(
                shrinkWrap: true,
                primary: false,
                childAspectRatio: (itemWidth / itemHeight),
                padding: EdgeInsets.all(getSize(2)),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                crossAxisCount: 4,
                children: List.generate(
                  getGridViewLength(widget.selectionModel),
                  (index) {
                    Master obj;
                    int totalIndex = getGridViewLength(widget.selectionModel);
                    if (totalIndex <= elementsToShow + 1)
                      obj = listOfMasterView[index];
                    else
                      obj = widget.selectionModel.masters[index];

                    if (index == 0 && widget.selectionModel.isShowAll == true) {
                      return InkWell(
                        onTap: () {
                          widget.selectionModel.isShowAllSelected =
                              !widget.selectionModel.isShowAllSelected;
                          if (widget.selectionModel.isShowAllSelected == true) {
                            widget.selectionModel.masters.forEach((element) {
                              if (element.sId != "ShowMore")
                                element.isSelected = true;
                            });
                          } else {
                            widget.selectionModel.masters.forEach((element) {
                              if (element.sId != "ShowMore")
                                element.isSelected = false;
                            });
                          }

                          setState(() {});
                        },
                        child: ShapeItemWidget(
                          txt: "All",
                          obj: obj,
                          selectionModel: widget.selectionModel,
                        ),
                      );
                    } else if (widget.selectionModel.isShowMoreSelected ==
                            false &&
                        widget.selectionModel.isShowMore &&
                        index == totalIndex - 1) {
                      obj.webDisplay = "Show Less";
                      return InkWell(
                        onTap: () {
                          widget.selectionModel.isShowMoreSelected = true;
                          setState(() {});
                        },
                        child: ShapeItemWidget(
                          txt: "Show Less",
                          obj: obj,
                          selectionModel: widget.selectionModel,
                        ),
                      );
                    } else if (widget.selectionModel.isShowMoreSelected ==
                            true &&
                        widget.selectionModel.isShowMore &&
                        index == totalIndex - 1) {
                      obj.webDisplay = "Show More";
                      return InkWell(
                        onTap: () {
                          widget.selectionModel.isShowMoreSelected = false;
                          setState(() {});
                        },
                        child: ShapeItemWidget(
                          txt: "Show More",
                          obj: obj,
                          selectionModel: widget.selectionModel,
                        ),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (widget.selectionModel.isShowAllSelected) {
                              widget.selectionModel.isShowAllSelected = false;
                            }
                            widget.selectionModel.masters.forEach((element) {
                              if (element.sId ==
                                      widget.selectionModel.allLableTitle &&
                                  element.isSelected &&
                                  obj.isSelected) {
                                element.isSelected = false;
                              }
                            });
                            obj.isSelected ^= true;
                            if (obj.isSelected) {
                              for (int i = 1;
                                  i < widget.selectionModel.masters.length - 1;
                                  i++) {
                                if (widget
                                    .selectionModel.masters[i].isSelected) {
                                  widget.selectionModel.isShowAllSelected =
                                      true;
                                } else {
                                  widget.selectionModel.isShowAllSelected =
                                      false;
                                  break;
                                }
                              }
                            }
                          });
                        },
                        child: ShapeItemWidget(
                          obj: obj,
                          selectionModel: widget.selectionModel,
                        ),
                      );
                    }
                  },
                ),
              )
            : SelectionWidget(widget.selectionModel),
      ],
    );
  }

  //Method for getting length of the gridview according to booleans.
  int getGridViewLength(SelectionModel selectionModel) {
    int length = 0;
    if (selectionModel.isShowAll && selectionModel.isShowMore) {
      if (selectionModel.isShowMoreSelected)
        length = listOfMasterView.length;
      else
        length = selectionModel.masters.length;
    } else if ((!selectionModel.isShowAll && selectionModel.isShowMore)) {
      if (selectionModel.isShowMoreSelected)
        length = listOfMasterView.length;
      else
        length = selectionModel.masters.length;
    } else if ((selectionModel.isShowAll && !selectionModel.isShowMore)) {
      length = selectionModel.masters.length;
    } else if (!selectionModel.isShowAll && !selectionModel.isShowMore) {
      length = selectionModel.masters.length;
    }

    return length;
  }
}

// card item for each type.
class ShapeItemWidget extends StatelessWidget {
  Master obj;
  String txt;
  SelectionModel selectionModel;

  ShapeItemWidget({Key key, this.obj, this.txt, this.selectionModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: selectionModel.orientation == DisplayTypes.horizontal
          ? getSize(90)
          : 0,
      decoration: BoxDecoration(
          color: obj.sId == "ShowMore"
              ? appTheme.unSelectedBgColor
              : ((obj.isSelected) || (selectionModel.isShowAllSelected))
                  ? appTheme.selectedFilterColor
                  : appTheme.unSelectedBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: obj.sId == "ShowMore"
                ? appTheme.borderColor
                : (obj.isSelected || selectionModel.isShowAllSelected)
                    ? appTheme.colorPrimary
                    : appTheme.borderColor,
          )),
      padding: const EdgeInsets.all(8),
      child: obj != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                obj.sId != selectionModel.allLableTitle &&
                        (obj.sId != "ShowMore")
                    ? obj.getShapeImage(obj.isSelected)
                    : SizedBox(),
                Padding(
                  padding: EdgeInsets.only(top: getSize(12.0)),
                  child: Text(obj.webDisplay.toLowerCase().capitalize(),
                      textAlign: TextAlign.center,
                      style: appTheme.blackNormal12TitleColorblack),
                ),
              ],
            )
          : SizedBox(),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}