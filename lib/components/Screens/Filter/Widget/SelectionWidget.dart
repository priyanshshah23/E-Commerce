import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diamnow/app/app.export.dart';

class SelectionWidget extends StatefulWidget {
  SelectionModel selectionModel;
  SelectionWidget(this.selectionModel);

  @override
  _SelectionWidgetState createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return TagWidget(widget.selectionModel);
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
      Master allMaster = Master();
      allMaster.sId = R.string().commonString.all;
      allMaster.webDisplay = R.string().commonString.all;
      allMaster.isSelected = false;

      widget.model.masters.insert(0, allMaster);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.model.orientation == "vertical"
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
                style: appTheme.blackNormal14TitleColorblack,
                textAlign: TextAlign.left,
              ),
        isNullEmptyOrFalse(widget.model.title)
            ? SizedBox()
            : SizedBox(height: getSize(16)),
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
                width: getSize(60),
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

  getSingleTag(int index) {
    return Padding(
      padding: EdgeInsets.only(left: getSize(8.0)),
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
          child: Text(
            widget.model.masters[index].webDisplay,
            style: widget.model.masters[index].isSelected
                ? appTheme.primaryColor14TextStyle
                : appTheme.blackNormal14TitleColorblack,
          ),
        ),
      ),
    );
  }

  void onSelectionClick(int index) {
    if (widget.model.isShowAll == true) {
      if (widget.model.masters[index].sId == R.string().commonString.all) {
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
        if (widget.model.masters[index].sId == R.string().commonString.all) {
          widget.model.masters.forEach((element) {
            element.isSelected = false;
          });
        } else {
          if (widget.model.masters
                  .where((element) =>
                      element.isSelected == true &&
                      element.sId != R.string().commonString.all)
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

class ColorWidget extends StatefulWidget {
  ColorModel colorModel;
  ColorWidget({Key key}) : super(key: key);

  @override
  _ColorWidgetState createState() => _ColorWidgetState();
}

class _ColorWidgetState extends State<ColorWidget> {
  @override
  void initState() {
    super.initState();
    widget.colorModel.title = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Text(
            "Color",
            style: appTheme.blackNormal14TitleColorblack,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: getSize(16)),
          SelectionWidget(widget.colorModel)
        ],
      ),
    );
  }
}
