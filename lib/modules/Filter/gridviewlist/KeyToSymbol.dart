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
  // int elementsToShow = 6;
  // List<Master> listOfMasterView = [];
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

    //code for showMore & showLess functionality.
    // if (widget.keyToSymbol.isShowMore) {
    //   if (widget.keyToSymbol.masters
    //           .where((element) => element.sId == "ShowMore")
    //           .toList()
    //           .length ==
    //       0) {
    //     Master allMaster = Master();
    //     allMaster.sId = "ShowMore";
    //     allMaster.webDisplay =
    //         widget.keyToSymbol.isShowMoreSelected ? "Show More" : "Show Less";
    //     allMaster.isSelected = false;

    //     widget.keyToSymbol.masters
    //         .insert(widget.keyToSymbol.masters.length, allMaster);
    //   }
    // }

    if (_tags.isEmpty) {
      widget.keyToSymbol.masters.forEach((element) {
        _tags.add(Tag(
          // id: item.id,
          title: element.webDisplay,
          active: false,
        ));
      });
    }

    //code for showMore & showLess functionality.
    // for (var masterIndex = 0; masterIndex < elementsToShow; masterIndex++) {
    //   listOfMasterView.add(widget.keyToSymbol.masters[masterIndex]);
    // }
    // listOfMasterView
    //     .add(widget.keyToSymbol.masters[widget.keyToSymbol.masters.length - 1]);
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

        widget.keyToSymbol.verticalScroll?
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
                  if (tag.title != R.string().commonString.all) {
                    widget.keyToSymbol.masters.forEach((element) {
                      if (element.webDisplay == tag.title) {
                        element.isSelected ^= true;
                        if (!element.isSelected) {
                          widget.keyToSymbol.isShowAllSelected = false;
                        } else {
                          for (var element in widget.keyToSymbol.masters) {
                            if (element.sId != R.string().commonString.all) {
                              if (element.isSelected) {
                                widget.keyToSymbol.isShowAllSelected = true;
                              } else {
                                widget.keyToSymbol.isShowAllSelected = false;
                                break;
                              }
                            }
                          }
                        }
                      }
                    });
                    if (widget.keyToSymbol.isShowAllSelected) {
                      _tags.forEach((element) {
                        element.active = true;
                      });
                      widget.keyToSymbol.masters.forEach((element) {
                        element.isSelected = true;
                      });
                    } else {
                      _tags.forEach((element) {
                        if (element.title == R.string().commonString.all)
                          element.active = false;
                      });
                      widget.keyToSymbol.masters.forEach((element) {
                        if (element.sId == R.string().commonString.all)
                          element.isSelected = false;
                      });
                    }
                  }
                  if (tag.title == R.string().commonString.all) {
                    widget.keyToSymbol.isShowAllSelected ^= true;

                    if (widget.keyToSymbol.isShowAllSelected) {
                      _tags.forEach((element) {
                        element.active = true;
                      });
                      widget.keyToSymbol.masters.forEach((element) {
                        element.isSelected = true;
                      });
                    } else {
                      _tags.forEach((element) {
                        element.active = false;
                      });
                      widget.keyToSymbol.masters.forEach((element) {
                        element.isSelected = false;
                      });
                    }
                  }
                  setState(() {});
                },
              ):SelectionWidget(widget.keyToSymbol),
            

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

  getHorizontalView() {
    List<Tag> _list1 = [];
    List<Tag> _list2 = [];

    for (int i = 0; i < _tags.length / 2; i++) {
      _list1.add(_tags[i]);
    }
    // for (int i = _tags.length ~/ 2; i < _tags.length; i++) {
    //   _list2.add(_tags[i]);
    // }
    for (int i = 0; i < _tags.length; i++) {
      _list2.add(_tags[i]);
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            // crossAxisAlignment:CrossAxisAlignment.start,
              children: List.generate(_list1.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.red,
                ),
                child: Text(_list1[index].title),
              ),
            );
          })),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            // crossAxisAlignment:CrossAxisAlignment.start,
              children: List.generate(_list2.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: 
              Container(
                
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.green,
                ),
                child: Text(_list2[index].title),
              ),
            );
          })),
        ),
          ],
        )
      ],
    );
  }

  // getSelectableTag(Tag tag){
  //   return Tooltip(
  //     message: tag.title.toString(),
  //     child: Container(
  //         margin: widget.margin ??
  //             EdgeInsets.symmetric(horizontal: _initMargin, vertical: 6),
  //         width: (widget.symmetry) ? _widthCalc(row: row) : null,
  //         height: widget.height ?? 31 * (widget.fontSize / 14),
  //         padding: EdgeInsets.all(0.0),
  //         decoration: BoxDecoration(
  //           boxShadow: widget.boxShadow ?? null,
  //           borderRadius: BorderRadius.circular(
  //               widget.borderRadius ?? _initBorderRadius),
  //           color: tag.active
  //               ? (widget.activeColor ?? Colors.blueGrey)
  //               : (widget.color ?? Colors.white),
  //         ),
  //         child: OutlineButton(
  //             color: tag.active
  //                 ? (widget.activeColor ?? Colors.blueGrey)
  //                 : (widget.color ?? Colors.white),
  //             highlightColor: Colors.transparent,
  //             highlightedBorderColor: widget.activeColor ?? Colors.blueGrey,
  //             //disabledTextColor: Colors.red,
  //             borderSide: tag.active
  //                 ? BorderSide(color: appTheme.colorPrimary)
  //                 : null,
  //             // borderSide: widget.borderSide ??
  //             //     BorderSide(
  //             //         color: (widget.activeColor ?? Colors.blueGrey)),
  //             child: (tag.icon != null)
  //                 ? FittedBox(
  //                     child: Icon(
  //                       tag.icon,
  //                       size: widget.fontSize,
  //                       color: tag.active
  //                           ? (widget.textActiveColor ?? Colors.white)
  //                           : (widget.textColor ?? Colors.black),
  //                     ),
  //                   )
  //                 : FittedBox(
  //                     child: Text(
  //                       tag.title,
  //                       // overflow: widget.textOverflow ?? TextOverflow.fade,
  //                       softWrap: false,
  //                       style: TextStyle(
  //                           fontSize: widget.fontSize ?? null,
  //                           color: tag.active
  //                               ? (widget.textActiveColor ?? Colors.white)
  //                               : (widget.textColor ?? Colors.black),
  //                           fontWeight: FontWeight.normal),
  //                     ),
  //                   ),
  //             onPressed: () {
  //               if (widget.singleItem) _singleItem();

  //               setState(() {
  //                 (widget.singleItem)
  //                     ? tag.active = true
  //                     : tag.active = !tag.active;
  //                 widget.onPressed(tag);
  //               });
  //             },
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(
  //                     widget.borderRadius ?? _initBorderRadius)))),
  //   );

  // }
  // int getGridViewLength(KeyToSymbolModel keyToSymbol) {
  //   int length = 0;
  //   if (keyToSymbol.isShowAll && keyToSymbol.isShowMore) {
  //     if (keyToSymbol.isShowMoreSelected)
  //       length = listOfMasterView.length;
  //     else
  //       length = keyToSymbol.masters.length;
  //   } else if ((!keyToSymbol.isShowAll && keyToSymbol.isShowMore)) {
  //     if (keyToSymbol.isShowMoreSelected)
  //       length = listOfMasterView.length;
  //     else
  //       length = keyToSymbol.masters.length;
  //   } else if ((keyToSymbol.isShowAll && !keyToSymbol.isShowMore)) {
  //     length = keyToSymbol.masters.length;
  //   } else if (!keyToSymbol.isShowAll && !keyToSymbol.isShowMore) {
  //     length = keyToSymbol.masters.length;
  //   }

  //   return length;
  // }
}

// class CardItem extends StatelessWidget {
//   Master obj;
//   String txt;
//   KeyToSymbolModel keyToSymbol;

//   CardItem({Key key, this.obj, this.txt, this.keyToSymbol}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: obj.sId == "ShowMore"
//             ? appTheme.unSelectedBgColor
//             : ((obj.isSelected) || (keyToSymbol.isShowAllSelected))
//                 ? appTheme.selectedFilterColor
//                 : appTheme.unSelectedBgColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: obj.sId == "ShowMore"
//               ? appTheme.borderColor
//               : (obj.isSelected || keyToSymbol.isShowAllSelected)
//                   ? appTheme.colorPrimary
//                   : appTheme.borderColor,
//         ),
//       ),
//       // padding: const EdgeInsets.all(8),
//       child: Center(
//         child: Text(
//           obj.webDisplay.toLowerCase().capitalize(),
//           textAlign: TextAlign.center,
//           style: appTheme.blackNormal12TitleColorblack,
//         ),
//       ),
//     );
//   }
// }

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
