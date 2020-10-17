import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/cupertino.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';

class ColorWhiteFancyWidget extends StatefulWidget {
  ColorModel colorModel;
  ColorWhiteFancyWidget(this.colorModel);

  @override
  _ColorWhiteFancyWidgetState createState() => _ColorWhiteFancyWidgetState();
}

class _ColorWhiteFancyWidgetState extends State<ColorWhiteFancyWidget> {
  @override
  void initState() {
    super.initState();
    widget.colorModel.title = "";
    if (widget.colorModel.isShowAll == true) {
      if (widget.colorModel.groupMaster
              .where(
                  (element) => element.sId == widget.colorModel.allLableTitle)
              .toList()
              .length ==
          0) {
        Master allMaster = Master();
        allMaster.sId = widget.colorModel.allLableTitle;
        allMaster.webDisplay = widget.colorModel.allLableTitle;
        allMaster.isSelected = false;

        widget.colorModel.groupMaster.insert(0, allMaster);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              "Color",
              style: appTheme.blackNormal18TitleColorblack,
              textAlign: TextAlign.left,
            ),
            Spacer(),
            InkWell(
              onTap: () {
                setState(() {
                  widget.colorModel.isGroupSelected = false;
                  widget.colorModel.masters = widget.colorModel.mainMasters;
                });
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      widget.colorModel.showRadio
                          ? Image.asset(
                              widget.colorModel.isGroupSelected == false
                                  ? selectedFilter
                                  : unselectedFilter,
                              width: getSize(24),
                              height: getSize(24),
                            )
                          : SizedBox(),
                      widget.colorModel.showRadio
                          ? SizedBox(width: getSize(8))
                          : SizedBox(),
                      Text(
                        "White",
                        style: appTheme.blackNormal14TitleColorblack,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  widget.colorModel.showRadio
                      ? SizedBox()
                      : SizedBox(height: getSize(4)),
                  widget.colorModel.showRadio
                      ? SizedBox()
                      : Center(
                          child: Container(
                            width: getSize(40),
                            height: getSize(1),
                            color: !widget.colorModel.isGroupSelected
                                ? appTheme.colorPrimary
                                : Colors.transparent,
                          ),
                        )
                ],
              ),
            ),
            SizedBox(width: getSize(8)),
            InkWell(
              onTap: () {
                setState(() {
                  widget.colorModel.isGroupSelected = true;
                  widget.colorModel.masters = widget.colorModel.groupMaster;

                  widget.colorModel.intensitySelection = SelectionModel(
                      title: "Intensity",
                      masters: widget.colorModel.intensity,
                      isShowAll: widget.colorModel.isShowAll,
                      orientation: widget.colorModel.orientation,
                      allLableTitle: widget.colorModel.allLableTitle,
                      verticalScroll: widget.colorModel.verticalScroll,
                      apiKey: "inten");

                  widget.colorModel.overtoneSelection = SelectionModel(
                      title: "Overtone",
                      masters: widget.colorModel.overtone,
                      isShowAll: widget.colorModel.isShowAll,
                      orientation: widget.colorModel.orientation,
                      allLableTitle: widget.colorModel.allLableTitle,
                      verticalScroll: widget.colorModel.verticalScroll,
                      apiKey: "ovrtn");
                });
              },
              child: Column(
                children: [
                  Row(
                    children: [
                      widget.colorModel.showRadio
                          ? Image.asset(
                              widget.colorModel.isGroupSelected == true
                                  ? selectedFilter
                                  : unselectedFilter,
                              width: getSize(24),
                              height: getSize(24),
                            )
                          : SizedBox(),
                      widget.colorModel.showRadio
                          ? SizedBox(width: getSize(8))
                          : SizedBox(),
                      Text(
                        "Fancy",
                        style: appTheme.blackNormal14TitleColorblack,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  widget.colorModel.showGroup
                      ? SizedBox(height: getSize(4))
                      : SizedBox(),
                  widget.colorModel.showRadio
                      ? SizedBox()
                      : SizedBox(height: getSize(4)),
                  widget.colorModel.showRadio
                      ? SizedBox()
                      : Center(
                          child: Container(
                            width: getSize(40),
                            height: getSize(1),
                            color: widget.colorModel.isGroupSelected
                                ? appTheme.colorPrimary
                                : Colors.transparent,
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: getSize(16)),
        SelectionWidget(widget.colorModel),
        widget.colorModel.isGroupSelected
            ? getOverToneIntensityViews()
            : SizedBox(),
      ],
    );
  }

  getOverToneIntensityViews() {
    return Column(children: [
      SizedBox(height: getSize(16)),
      SelectionWidget(widget.colorModel.intensitySelection),
      SizedBox(height: getSize(16)),
      SelectionWidget(widget.colorModel.overtoneSelection),
    ]);
  }
}
