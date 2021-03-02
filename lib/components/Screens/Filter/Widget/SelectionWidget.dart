import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/extensions/eventbus.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Filter/Widget/ShapeWidget.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/modules/Filter/gridviewlist/selectable_tags.dart';
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
    return widget.selectionModel.verticalScroll &&
            widget.selectionModel.viewType == ViewTypes.shapeWidget
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
  List<Tag> _tags = []; //for keytosymbol

  int elementsToShow;
  List<Master> listOfMasterView = [];

  @override
  void initState() {
    super.initState();

    List<Master> allMaster = widget.model.masters
        .where((element) => element.sId == widget.model.allLableTitle)
        .toList();
    List<Master> arrSelectedMaster =
        widget.model.masters.where((element) => element.isSelected).toList();

    if (!isNullEmptyOrFalse(arrSelectedMaster)) {
      if (!isNullEmptyOrFalse(allMaster)) {
        arrSelectedMaster.length == widget.model.masters.length
            ? allMaster.first.isSelected = true
            : allMaster.first.isSelected = false;
      }
    }

    if (widget.model.masterCode.toLowerCase() ==
        MasterCode.keyToSymbol.toLowerCase()) {
      widget.model.title = "";

      if (isNullEmptyOrFalse(_tags)) {
        widget.model.masters.forEach((element) {
          _tags.add(Tag(
            // id: item.id,
            title: widget.model.valueKeyisCode
                ? (element.code ?? "-")
                : (element.webDisplay ?? "-"),
            active: false,
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.verticalScroll == false &&
        widget.model.viewType == ViewTypes.shapeWidget) {
      return getShapeWidgetHorizontal();
    }

    if (widget.model.verticalScroll == false &&
        widget.model.viewType == ViewTypes.keytosymbol) {
      return getKeytoSymbolWidgetHorizontal();
    }

    if (widget.model.masterCode.toLowerCase() ==
        MasterCode.arrivals.toLowerCase()) {
      return getArrivalsWidget();
    }

    if (widget.model.verticalScroll) {
      return getGridView(widget.model.gridViewItemCount);
    }

    return widget.model.orientation == DisplayTypes.vertical
        ? getVerticalOrientation()
        : getHorizontalOrientation();
  }

  Widget getGridView(int getGridViewItemCount) {
    var count = isPad() ? getGridViewItemCount + 1 : getGridViewItemCount;
    double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 2.5;
    int _crossAxisCount = count;

    double screenWidth = MediaQuery.of(context).size.width;

    var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var height = 35;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isNullEmptyOrFalse(widget.model.title)
            ? SizedBox()
            : Text(
                widget.model.title ?? "",
                style: appTheme.blackMedium16TitleColorblack,
                textAlign: TextAlign.left,
              ),
        isNullEmptyOrFalse(widget.model.title)
            ? SizedBox()
            : SizedBox(height: getSize(20)),
        GridView.count(
          shrinkWrap: true,
          primary: false,
          childAspectRatio: (width / height),
          // padding: EdgeInsets.all(getSize(2)),
          crossAxisSpacing: _crossAxisSpacing,
          mainAxisSpacing: _mainAxisSpacing,
          crossAxisCount: count,
          children: List.generate(
            getGridViewLength(widget.model),
            (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (widget.model.viewType == ViewTypes.caratRange) {
                      RxBus.post(true, tag: eventForShareCaratRangeSelected);
                    }

                    if (widget.model.isShowMoreSelected == false &&
                        widget.model.isShowMore &&
                        index == widget.model.masters.length - 1) {
                      print("Show less");
                      widget.model.isShowMoreSelected = true;
                    } else if (widget.model.isShowMoreSelected == true &&
                        widget.model.isShowMore &&
                        index ==
                            widget.model.showMoreTagAfterTotalItemCount - 1) {
                      print("Show more");
                      widget.model.isShowMoreSelected = false;
                    } else {
                      widget.model.masters[index].isSelected =
                          !widget.model.masters[index].isSelected;
                    }
                    widget.model.onSelectionClick(index);
                  });
                },
                child: !widget.model.isShowMoreHorizontal
                    ? index ==
                                widget.model.showMoreTagAfterTotalItemCount -
                                    1 &&
                            widget.model.isShowMoreSelected &&
                            widget.model.isShowMore
                        ? getSingleTagForGridview(
                            widget.model.masters.length - 1)
                        : getSingleTagForGridview(index)
                    : getSingleTagForGridview(index),
              );
            },
          ),
        ),
        if (widget.model.isShowMoreHorizontal &&
            widget.model.isShowMoreSelected == true &&
            widget.model.isShowMore)
          InkWell(
            onTap: () {
              widget.model.isShowMoreSelected = false;
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.only(top: getSize(16.0)),
              child: Container(
                height: getSize(26),
                decoration: BoxDecoration(
                  color: appTheme.selectedFilterColor,
                  borderRadius: BorderRadius.circular(getSize(5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      R.string.commonString.seeMore,
                      style: appTheme.black14TextStyle,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: getSize(6.0)),
                      child: Image.asset(downArrow,
                          width: getSize(9), height: getSize(5)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (widget.model.isShowMoreHorizontal &&
            widget.model.isShowMoreSelected == false &&
            widget.model.isShowMore)
          InkWell(
            onTap: () {
              widget.model.isShowMoreSelected = true;
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.only(top: getSize(16.0)),
              child: Container(
                height: getSize(26),
                decoration: BoxDecoration(
                  color: appTheme.selectedFilterColor,
                  borderRadius: BorderRadius.circular(getSize(5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      R.string.commonString.seeLess,
                      style: appTheme.black14TextStyle,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: getSize(6.0)),
                      child: Image.asset(upArrow,
                          width: getSize(9), height: getSize(5)),
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }

  int getGridViewLength(SelectionModel selectionModel) {
    if (selectionModel.isShowMore) {
      if (selectionModel.isShowMoreSelected) {
        return selectionModel.showMoreTagAfterTotalItemCount;
      } else {
        if (!selectionModel.isShowMoreHorizontal)
          return selectionModel.masters.length;
        else
          return selectionModel.masters.length - 1;
      }
    } else {
      return selectionModel.masters.length;
    }
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
            ? SizedBox(height: getSize(20))
            : SizedBox(),
        isNullEmptyOrFalse(widget.model.title)
            ? SizedBox()
            : Text(
                widget.model.title ?? "",
                style: appTheme.blackMedium16TitleColorblack,
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
                    if (widget.model.viewType == ViewTypes.caratRange) {
                      RxBus.post(true, tag: eventForShareCaratRangeSelected);
                    }
                    widget.model.masters[index].isSelected =
                        !widget.model.masters[index].isSelected;

                    widget.model.onSelectionClick(index);
                    getMultipleMasterSelections(index);
                  });
                },
              );
            },
          ),
        ),
        // SizedBox(height: getSize(12))
      ],
    );
  }

  Widget getHorizontalOrientation() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: getSize(80),
              child: Text(
                widget.model.title ?? "",
                style: appTheme.blackMedium16TitleColorblack.copyWith(
                  fontSize: getFontSize(14),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(width: getSize(30)),
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
        ),
        // SizedBox(height: getSize(8))
      ],
    );
  }

  getSingleTagForGridview(int index) {
    if (widget.model.isShowMore) {
      if (index == widget.model.masters.length - 1 &&
          !widget.model.isShowMoreSelected) {
        widget.model.masters[index].webDisplay = R.string.commonString.showLess;
        widget.model.masters[index].code = R.string.commonString.showLess;
      }
      if (widget.model.isShowMoreSelected) {
        widget.model.masters[widget.model.masters.length - 1].webDisplay =
            R.string.commonString.showMore;
        widget.model.masters[widget.model.masters.length - 1].code =
            R.string.commonString.showMore;
      }
    }
    return Container(
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
            top: getSize(6.0),
            bottom: getSize(6.0),
            right: getSize(12.0),
            left: getSize(12.0)),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              showWebDisplayAccordingToMaster(widget.model, index),
              style: widget.model.masters[index].isSelected
                  ? appTheme.whiteColor14TextStyle
                  : appTheme.blackNormal14TitleColorblack,
            ),
          ),
        ),
      ),
    );
  }

  getSingleTag(int index) {
    return Padding(
      padding: EdgeInsets.only(right: getSize(10.0)),
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
              top: getSize(6.0),
              bottom: getSize(6.0),
              right: getSize(12.0),
              left: getSize(12.0)),
          child: Center(
            child: Text(
              showWebDisplayAccordingToMaster(widget.model, index),
              style: widget.model.masters[index].isSelected
                  ? appTheme.whiteColor14TextStyle
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
            height: getSize(110),
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

                      widget.model.onSelectionClick(index);
                      getMultipleMasterSelections(index);
                    });
                  },
                );
              },
            ),
          ),
        ),
        SizedBox(height: getSize(12))
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
        SizedBox(height: getSize(8))
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
          hintText: R.string.commonString.fromLbl,
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
                  desc: R.string.errorString.selectFromDate,
                  positiveBtnTitle: R.string.commonString.ok,
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
    if (!isNullEmptyOrFalse(widget.model.masterSelection)) {
      Map<MasterSelection, bool> m = Map<MasterSelection, bool>();
      m[widget.model.masterSelection[index]] =
          widget.model.masters[index].isSelected;

      RxBus.post(m, tag: eventMasterSelection);
    }
    //When Local data has added and multilple master has to select
    if (widget.model.isSingleSelection) {
      for (var item in widget.model.masters) {
        if (item.code != MasterCode.noBgm) {
          if (item != widget.model.masters[index]) {
            item.isSelected = false;
          }
        }
      }
    } else {
      if (widget.model.masterCode.toLowerCase() ==
              MasterCode.cut.toLowerCase() ||
          widget.model.masterCode.toLowerCase() ==
              MasterCode.polish.toLowerCase() ||
          widget.model.masterCode.toLowerCase() ==
              MasterCode.symmetry.toLowerCase() ||
          widget.model.masterCode.toLowerCase() ==
              MasterCode.eyeClean.toLowerCase() ||
          widget.model.masterCode.toLowerCase() ==
              MasterCode.milky.toLowerCase() ||
          widget.model.masterCode.toLowerCase() ==
              MasterCode.colorShade.toLowerCase()) {
        RxBus.post(false, tag: eventMasterForDeSelectMake);
      }
      widget.model.onSelectionClick(index);
    }
  }

  //code of keytosymbol
  getKeytoSymbolWidgetHorizontal() {
    List<Tag> _list1 = [];
    List<Tag> _list2 = [];

    for (int i = 1; i < _tags.length; i++) {
      if (i % 2 == 0)
        _list1.add(_tags[i]);
      else
        _list2.add(_tags[i]);
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: getSize(105),
            child: getKeytoSymbolHorizontalView(_list1, _list2),
          ),
        ),
      ],
    );
  }

  //code of keytosymbol
  getKeytoSymbolHorizontalView(List<Tag> _list1, List<Tag> _list2) {
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: getSize(8),
                right: getSize(8),
                bottom: getSize(8),
              ),
              child: Row(
                  // crossAxisAlignment:CrossAxisAlignment.start,
                  children: List.generate(_list1.length, (index) {
                return InkWell(
                  child: getSingleTagForKeytoSymbol(_list1, index, index * 2),
                  onTap: () {
                    setState(() {
                      widget.model.masters[index * 2].isSelected =
                          !widget.model.masters[index * 2].isSelected;
                    });
                  },
                );
              })),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: getSize(8),
                right: getSize(8),
                bottom: getSize(8),
              ),
              child: Row(
                  // crossAxisAlignment:CrossAxisAlignment.start,
                  children: List.generate(_list2.length, (index) {
                return InkWell(
                  child:
                      getSingleTagForKeytoSymbol(_list2, index, index * 2 + 1),
                  onTap: () {
                    setState(() {
                      widget.model.masters[index * 2 + 1].isSelected =
                          !widget.model.masters[index * 2 + 1].isSelected;
                    });
                  },
                );
              })),
            ),
          ],
        )
      ],
    );
  }

  //code of keytosymbol
  getSingleTagForKeytoSymbol(List<Tag> list, int indexForTagList, int index) {
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
              list[indexForTagList].title,
              style: widget.model.masters[index].isSelected
                  ? appTheme.primaryColor14TextStyle
                  : appTheme.blackNormal14TitleColorblack,
            ),
          ),
        ),
      ),
    );
  }

  showWebDisplayAccordingToMaster(SelectionModel model, int index) {
    if (model.masterCode == MasterCode.cut ||
        model.masterCode == MasterCode.polish ||
        model.masterCode == MasterCode.symmetry) {
      if (model.masters[index].code.toLowerCase() == "ex") {
        return "EX";
      } else if (model.masters[index].code.toLowerCase() == "g") {
        return "G";
      } else if (model.masters[index].code.toLowerCase() == "vg") {
        return "VG";
      } else if (model.masters[index].code.toLowerCase() == "f") {
        return "F";
      }
    } else if (model.viewType == ViewTypes.caratRange) {
      return model.masters[index].group ?? "-";
    }

    return widget.model.valueKeyisCode
        ? (model.masters[index].code ?? "-")
        : (model.masters[index].webDisplay ?? "-");
  }
}
