import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
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
              R.string().commonString.color,
              style: appTheme.blackMedium16TitleColorblack,
              textAlign: TextAlign.left,
            ),
            Spacer(),
            InkWell(
              onTap: () {
                setState(() {
                  widget.colorModel.isGroupSelected = false;
                  widget.colorModel.gridViewItemCount = 5;
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
                              width: getSize(18),
                              height: getSize(18),
                            )
                          : SizedBox(),
                      widget.colorModel.showRadio
                          ? SizedBox(width: getSize(8))
                          : SizedBox(),
                      Text(
                        R.string().commonString.colorWhite,
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
                  widget.colorModel.gridViewItemCount = 3;
                  widget.colorModel.intensitySelection = SelectionModel(
                      title: R.string().commonString.intensity,
                      masters: widget.colorModel.intensity,
                      isShowAll: widget.colorModel.isShowAll,
                      orientation: widget.colorModel.orientation,
                      allLableTitle: widget.colorModel.allLableTitle,
                      masterCode: MasterCode.intensity,
                      verticalScroll: widget.colorModel.verticalScroll,
                      gridViewItemCount: 3,
                      showMoreTagAfterTotalItemCount: 6,
                      viewType: widget.colorModel.viewType,
                      isShowMore: widget.colorModel.isShowMore,
                      isShowMoreHorizontal:
                          widget.colorModel.isShowMoreHorizontal,
                      apiKey: "inten");

                  widget.colorModel.overtoneSelection = SelectionModel(
                      masterCode: MasterCode.overTone,
                      title: R.string().commonString.overtone,
                      masters: widget.colorModel.overtone,
                      isShowAll: widget.colorModel.isShowAll,
                      orientation: widget.colorModel.orientation,
                      allLableTitle: widget.colorModel.allLableTitle,
                      viewType: widget.colorModel.viewType,
                      showMoreTagAfterTotalItemCount: 6,
                      verticalScroll: widget.colorModel.verticalScroll,
                      isShowMore: widget.colorModel.isShowMore,
                      isShowMoreHorizontal:
                          widget.colorModel.isShowMoreHorizontal,
                      gridViewItemCount: 3,
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
                              width: getSize(18),
                              height: getSize(18),
                            )
                          : SizedBox(),
                      widget.colorModel.showRadio
                          ? SizedBox(width: getSize(8))
                          : SizedBox(),
                      Text(
                        R.string().commonString.colorFancy,
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
            : SizedBox(height: getSize(8)),
      ],
    );
  }

  getOverToneIntensityViews() {
    return Column(children: [
      SizedBox(height: getSize(32)),
      SelectionWidget(widget.colorModel.intensitySelection),
      SizedBox(height: getSize(32)),
      SelectionWidget(widget.colorModel.overtoneSelection),
      SizedBox(height: getSize(8)),
    ]);
  }
}
