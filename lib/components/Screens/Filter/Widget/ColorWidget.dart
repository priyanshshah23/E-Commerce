import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/cupertino.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';

class ColorWidget extends StatefulWidget {
  ColorModel colorModel;
  ColorWidget(this.colorModel);

  @override
  _ColorWidgetState createState() => _ColorWidgetState();
}

class _ColorWidgetState extends State<ColorWidget> {
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

        List<Master> arrSelectedMaster = widget.colorModel.masters
            .where((element) => element.isSelected)
            .toList();
        if (!isNullEmptyOrFalse(arrSelectedMaster)) {
          arrSelectedMaster.length == widget.colorModel.masters.length
              ? allMaster.isSelected = true
              : allMaster.isSelected = false;

          if (allMaster.isSelected == true) {
            widget.colorModel.groupMaster.forEach((element) {
              element.isSelected = true;
            });
          }
        }
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
              widget.colorModel.masterCode == MasterCode.color
                  ? R.string().commonString.color
                  : R.string().commonString.clarity,
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
                        widget.colorModel.masterCode == MasterCode.color
                            ? R.string().commonString.color
                            : R.string().commonString.clarity,
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
                        widget.colorModel.masterCode == MasterCode.color
                            ? R.string().commonString.colorGroup
                            : R.string().commonString.clarityGroup,
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
                            width: getSize(90),
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
        SelectionWidget(widget.colorModel)
      ],
    );
  }
}
