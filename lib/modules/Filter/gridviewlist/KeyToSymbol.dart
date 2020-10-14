import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:diamnow/modules/Filter/gridviewlist/selectable_tags.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_tags/selectable_tags.dart';

class KeyToSymbolWidget extends StatefulWidget {
  final KeyToSymbolModel keyToSymbol;
  KeyToSymbolWidget(this.keyToSymbol);

  @override
  _KeyToSymbolWidgetState createState() => _KeyToSymbolWidgetState();
}

class _KeyToSymbolWidgetState extends State<KeyToSymbolWidget> {
  int elementsToShow = 6;
  List<Master> listOfMasterView = [];
  List<Tag> _tags = [];

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

    if (_tags.isEmpty) {
      widget.keyToSymbol.masters.forEach((element) {
        _tags.add(Tag(
          // id: item.id,
          title: element.webDisplay,
          active: false,
        ));
      });
    }

    for (var masterIndex = 0; masterIndex < elementsToShow; masterIndex++) {
      listOfMasterView.add(widget.keyToSymbol.masters[masterIndex]);
    }
    listOfMasterView
        .add(widget.keyToSymbol.masters[widget.keyToSymbol.masters.length - 1]);
  }

  int _radioValue = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      if (_radioValue == 0) {
        widget.keyToSymbol.listOfRadio[0].isSelected = true;
        widget.keyToSymbol.listOfRadio[1].isSelected = false;
      } else {
        widget.keyToSymbol.listOfRadio[1].isSelected = true;
        widget.keyToSymbol.listOfRadio[0].isSelected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 400) / 2;
    final double itemWidth = size.width / 2;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "KeyToSymbol",
              style: appTheme.blackNormal18TitleColorblack,
              textAlign: TextAlign.left,
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                Text(
                  widget.keyToSymbol.listOfRadio[0].title,
                  style: appTheme.blackNormal14TitleColorblack,
                ),
                Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                Text(
                  widget.keyToSymbol.listOfRadio[1].title,
                  style: appTheme.blackNormal14TitleColorblack,
                ),
              ],
            ),
            SizedBox(
              height: getSize(15.0),
            ),
          ],
        ),

        SelectableTags(
          tags: _tags,
          columns: 3, // default 4
          // symmetry: true,
          // borderSide: BorderSide(color: appTheme.),
          textActiveColor: appTheme.colorPrimary,
          // borderSide: _tags.map((element) { 
          //   if(element.active){
          //     return BorderSide(color: appTheme.colorPrimary);
              
          //   }
          // }),
          
          
                   
                  // : appTheme.blackNormal14TitleColorblack,
          color: appTheme.unSelectedBgColor,
          activeColor: appTheme.selectedFilterColor, // default false
          onPressed: (tag) {
            widget.keyToSymbol.masters.forEach((element) {
              if (element.webDisplay == tag.title) {
                element.isSelected ^= true;
              }
            });
          },
        )

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisSize: MainAxisSize.min,
        //   children: <Widget>[
        //     widget.keyToSymbol.verticalScroll
        //         ? GridView.count(
        //             shrinkWrap: true,
        //             primary: false,
        //             childAspectRatio: (itemWidth / itemHeight),
        //             padding: EdgeInsets.all(getSize(2)),
        //             crossAxisSpacing: 8,
        //             mainAxisSpacing: 8,
        //             crossAxisCount: 4,
        //             children: List.generate(
        //               getGridViewLength(widget.keyToSymbol),
        //               (index) {
        //                 Master obj;
        //                 int totalIndex = getGridViewLength(widget.keyToSymbol);
        //                 if (totalIndex <= elementsToShow + 1)
        //                   obj = listOfMasterView[index];
        //                 else
        //                   obj = widget.keyToSymbol.masters[index];

        //                 if (index == 0 &&
        //                     widget.keyToSymbol.isShowAll == true) {
        //                   return InkWell(
        //                     onTap: () {
        //                       widget.keyToSymbol.isShowAllSelected =
        //                           !widget.keyToSymbol.isShowAllSelected;
        //                       if (widget.keyToSymbol.isShowAllSelected ==
        //                           true) {
        //                         widget.keyToSymbol.masters.forEach((element) {
        //                           if (element.sId != "ShowMore")
        //                             element.isSelected = true;
        //                         });
        //                       } else {
        //                         widget.keyToSymbol.masters.forEach((element) {
        //                           if (element.sId != "ShowMore")
        //                             element.isSelected = false;
        //                         });
        //                       }

        //                       setState(() {});
        //                     },
        //                     child: CardItem(
        //                       txt: "All",
        //                       obj: obj,
        //                       keyToSymbol: widget.keyToSymbol,
        //                     ),
        //                   );
        //                 } else if (widget.keyToSymbol.isShowMoreSelected ==
        //                         false &&
        //                     widget.keyToSymbol.isShowMore &&
        //                     index == totalIndex - 1) {
        //                   obj.webDisplay = "Show Less";
        //                   return InkWell(
        //                     onTap: () {
        //                       widget.keyToSymbol.isShowMoreSelected = true;
        //                       setState(() {});
        //                     },
        //                     child: CardItem(
        //                       txt: "Show Less",
        //                       obj: obj,
        //                       keyToSymbol: widget.keyToSymbol,
        //                     ),
        //                   );
        //                 } else if (widget.keyToSymbol.isShowMoreSelected ==
        //                         true &&
        //                     widget.keyToSymbol.isShowMore &&
        //                     index == totalIndex - 1) {
        //                   obj.webDisplay = "Show More";
        //                   return InkWell(
        //                     onTap: () {
        //                       widget.keyToSymbol.isShowMoreSelected = false;
        //                       setState(() {});
        //                     },
        //                     child: CardItem(
        //                       txt: "Show More",
        //                       obj: obj,
        //                       keyToSymbol: widget.keyToSymbol,
        //                     ),
        //                   );
        //                 } else {
        //                   return InkWell(
        //                     onTap: () {
        //                       setState(() {
        //                         if (widget.keyToSymbol.isShowAllSelected) {
        //                           widget.keyToSymbol.isShowAllSelected = false;
        //                         }
        //                         widget.keyToSymbol.masters.forEach((element) {
        //                           if (element.sId ==
        //                                   R.string().commonString.all &&
        //                               element.isSelected &&
        //                               obj.isSelected) {
        //                             element.isSelected = false;
        //                           }
        //                         });
        //                         obj.isSelected ^= true;
        //                         if (obj.isSelected) {
        //                           for (int i = 1;
        //                               i < widget.keyToSymbol.masters.length - 1;
        //                               i++) {
        //                             if (widget
        //                                 .keyToSymbol.masters[i].isSelected) {
        //                               widget.keyToSymbol.isShowAllSelected =
        //                                   true;
        //                             } else {
        //                               widget.keyToSymbol.isShowAllSelected =
        //                                   false;
        //                               break;
        //                             }
        //                           }
        //                         }
        //                       });
        //                     },
        //                     child: CardItem(
        //                       obj: obj,
        //                       keyToSymbol: widget.keyToSymbol,
        //                     ),
        //                   );
        //                 }
        //               },
        //             ),
        //           )
        //         : SelectionWidget(widget.keyToSymbol),
        //   ],
        // ),
      ],
    );
  }

  int getGridViewLength(KeyToSymbolModel keyToSymbol) {
    int length = 0;
    if (keyToSymbol.isShowAll && keyToSymbol.isShowMore) {
      if (keyToSymbol.isShowMoreSelected)
        length = listOfMasterView.length;
      else
        length = keyToSymbol.masters.length;
    } else if ((!keyToSymbol.isShowAll && keyToSymbol.isShowMore)) {
      if (keyToSymbol.isShowMoreSelected)
        length = listOfMasterView.length;
      else
        length = keyToSymbol.masters.length;
    } else if ((keyToSymbol.isShowAll && !keyToSymbol.isShowMore)) {
      length = keyToSymbol.masters.length;
    } else if (!keyToSymbol.isShowAll && !keyToSymbol.isShowMore) {
      length = keyToSymbol.masters.length;
    }

    return length;
  }
}

class CardItem extends StatelessWidget {
  Master obj;
  String txt;
  KeyToSymbolModel keyToSymbol;

  CardItem({Key key, this.obj, this.txt, this.keyToSymbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: obj.sId == "ShowMore"
            ? appTheme.unSelectedBgColor
            : ((obj.isSelected) || (keyToSymbol.isShowAllSelected))
                ? appTheme.selectedFilterColor
                : appTheme.unSelectedBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: obj.sId == "ShowMore"
              ? appTheme.borderColor
              : (obj.isSelected || keyToSymbol.isShowAllSelected)
                  ? appTheme.colorPrimary
                  : appTheme.borderColor,
        ),
      ),
      // padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          obj.webDisplay.toLowerCase().capitalize(),
          textAlign: TextAlign.center,
          style: appTheme.blackNormal12TitleColorblack,
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
