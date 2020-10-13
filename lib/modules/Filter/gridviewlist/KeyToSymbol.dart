import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/material.dart';

class KeyToSymbolWidget extends StatefulWidget {
  final KeyToSymbolModel keyToSymbol;

  KeyToSymbolWidget(this.keyToSymbol);

  @override
  _KeyToSymbolWidgetState createState() => _KeyToSymbolWidgetState();
}

class _KeyToSymbolWidgetState extends State<KeyToSymbolWidget> {
  int elementsToShow = 6;
  List<Master> listOfMasterView = [];

  @override
  void initState() {
    super.initState();

    widget.keyToSymbol.title = "";

    if (widget.keyToSymbol.isShowAll == true) {
      if (widget.keyToSymbol.masters
              .where((element) => element.sId == R.string().commonString.all)
              .toList()
              .length ==
          0) {
        Master allMaster = Master();
        allMaster.sId = R.string().commonString.all;
        allMaster.webDisplay = R.string().commonString.all;
        allMaster.isSelected = false;

        widget.keyToSymbol.masters.insert(0, allMaster);
      }
    }
    if (widget.keyToSymbol.isShowMore) {
      if (widget.keyToSymbol.masters
              .where((element) => element.sId == "ShowMore")
              .toList()
              .length ==
          0) {
        Master allMaster = Master();
        allMaster.sId = "ShowMore";
        allMaster.webDisplay =
            widget.keyToSymbol.isShowMoreSelected ? "Show More" : "Show Less";
        allMaster.isSelected = false;

        widget.keyToSymbol.masters
            .insert(widget.keyToSymbol.masters.length, allMaster);
      }
    }

    for (var masterIndex = 0; masterIndex < elementsToShow; masterIndex++) {
      listOfMasterView.add(widget.keyToSymbol.masters[masterIndex]);
    }
    listOfMasterView
        .add(widget.keyToSymbol.masters[widget.keyToSymbol.masters.length - 1]);
  }

  int _radioValue = 0;

  void _handleRadioValueChange(int value){
    setState(() {
      _radioValue = value;

      if(_radioValue==0){
        widget.keyToSymbol.listOfRadio[0].isSelected = true;
      } else{
        widget.keyToSymbol.listOfRadio[1].isSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "KeyToSymbol",
              style: appTheme.blackNormal14TitleColorblack,
              textAlign: TextAlign.left,
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                Text(widget.keyToSymbol.listOfRadio[0].title,
                ),
                Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                Text(widget.keyToSymbol.listOfRadio[1].title),
              ],
            )
          ],
        )
      ],
    );
  }
}
