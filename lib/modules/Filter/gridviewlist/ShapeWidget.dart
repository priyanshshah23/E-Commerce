import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ColorConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:flutter/material.dart';

import '../../../app/constant/ImageConstant.dart';
import '../../../app/utils/CommonWidgets.dart';
import '../../../models/FilterModel/FilterModel.dart';
import '../../../models/Master/Master.dart';

class ShapeWidget extends StatefulWidget {
  SelectionModel selectionModel;
  ShapeWidget(this.selectionModel);

  @override
  _ShapeWidgetState createState() => _ShapeWidgetState();
}

class _ShapeWidgetState extends State<ShapeWidget> {

  //show when isShowMoreSelected=false;
  int elementsToShow = 6;
  List<Master> listOfMasterView = [];

  @override
  void initState() {
    super.initState();
  
    if (widget.selectionModel.isShowAll == true) {
      Master allMaster = Master();
      allMaster.sId = R.string().commonString.all;
      allMaster.webDisplay = R.string().commonString.all;
      allMaster.isSelected = false;

      widget.selectionModel.masters.insert(0, allMaster);
    }
    if (widget.selectionModel.isShowMore) {
      Master allMaster = Master();
      allMaster.sId =
          widget.selectionModel.isShowMoreSelected ? "Show More" : "Show Less";
      allMaster.webDisplay =
          widget.selectionModel.isShowMoreSelected ? "Show More" : "Show Less";
      allMaster.isSelected = false;

      widget.selectionModel.masters.insert(widget.selectionModel.masters.length, allMaster);
    }

    for (var masterIndex = 0; masterIndex < elementsToShow; masterIndex++) {
      listOfMasterView.add(widget.selectionModel.masters[masterIndex]);
    }
    listOfMasterView
        .add(widget.selectionModel.masters[widget.selectionModel.masters.length - 1]);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 220) / 2;
    final double itemWidth = size.width / 2;

    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.selectionModel.title ?? "Shapes",
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
                padding: const EdgeInsets.all(2),
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
                          widget.selectionModel.masters.forEach((element) {
                            if (element.sId != "Show More" ||
                                element.sId != "Show Less")
                              element.isSelected = true;
                          });
                          widget.selectionModel.isShowAllSelected = true;
                          setState(() {});
                        },
                        child: CardItem(
                          txt: "All",
                          obj: obj,
                          selectionModel: widget.selectionModel,
                        ),
                      );
                    } else if (widget.selectionModel.isShowMoreSelected == false &&
                        widget.selectionModel.isShowMore &&
                        index == totalIndex - 1) {
                      obj.sId = "Show Less";
                      obj.webDisplay = "Show Less";
                      return InkWell(
                        onTap: () {
                          widget.selectionModel.isShowMoreSelected = true;
                          setState(() {});
                        },
                        child: CardItem(
                          txt: "Show Less",
                          obj: obj,
                          selectionModel: widget.selectionModel,
                        ),
                      );
                    } else if (widget.selectionModel.isShowMoreSelected == true &&
                        widget.selectionModel.isShowMore &&
                        index == totalIndex - 1) {
                      obj.sId = "Show More";
                      obj.webDisplay = "Show More";
                      return InkWell(
                        onTap: () {
                          widget.selectionModel.isShowMoreSelected = false;
                          setState(() {});
                        },
                        child: CardItem(
                          txt: "Show More",
                          obj: obj,
                          selectionModel: widget.selectionModel,
                        ),
                      );
                    } else {
                      // int tempIndex;
                      // if (widget.selectionModel.isShowAll)
                      //   tempIndex = index - 1;
                      // else
                      //   tempIndex = index;
                      return InkWell(
                        onTap: () {
                          if (widget.selectionModel.isShowAllSelected) {
                            widget.selectionModel.isShowAllSelected = false;
                          }
                          widget.selectionModel.masters.forEach((element) {
                            if (element.sId ==
                                    R.string().commonString.all &&
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
                              if (widget.selectionModel.masters[i].isSelected) {
                                widget.selectionModel.isShowAllSelected = true;
                              } else {
                                widget.selectionModel.isShowAllSelected = false;
                                break;
                              }
                            }
                          }
                          setState(() {});
                        },
                        child: CardItem(
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
class CardItem extends StatelessWidget {
  Master obj;
  String txt;
  SelectionModel selectionModel;

  CardItem({Key key, this.obj, this.txt, this.selectionModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ((obj.isSelected) || (selectionModel.isShowAllSelected)) &&
                  (obj.sId != "Show More" && obj.sId != "Show Less")
              ? Colors.blueAccent
              : Colors.teal[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorConstants.textGray)),
      padding: const EdgeInsets.all(8),
      child: obj != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                obj.image != null
                    ? Image.asset(
                        obj.image,
                        color: Colors.black,
                        width: getSize(28),
                        height: getSize(28),
                      )
                    : SizedBox(),
                Padding(
                  padding: EdgeInsets.only(top: getSize(8.0)),
                  child: Text(obj.webDisplay,
                      textAlign: TextAlign.center,
                      style: appTheme.blackNormal14TitleColorblack),
                ),
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: getTitleText(context, obj.webDisplay),
            ),
    );
  }
}
