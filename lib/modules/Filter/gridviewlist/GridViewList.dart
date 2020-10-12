import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ColorConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/Filter/Widget/SelectionWidget.dart';
import 'package:flutter/material.dart';

import '../../../app/constant/ImageConstant.dart';
import '../../../app/utils/CommonWidgets.dart';
import '../../../models/FilterModel/FilterModel.dart';
import '../../../models/Master/Master.dart';

class GridViewList extends StatefulWidget {
  @override
  _GridViewListState createState() => _GridViewListState();
}

class _GridViewListState extends State<GridViewList> {
  
  List<Master> listOfMaster = [];

  //show when isShowMoreSelected=false;
  int elementsToShow = 6;
  List<Master> listOfMasterView = [];

  //selectionModel for handling UI
  SelectionModel selectionModel = SelectionModel(
    isShowAll: true,
    isShowMore: true,
    isShowAllSelected: false,
    isShowMoreSelected: true,
    // orientation:"horizontal",
    verticalScroll: true,
  );

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 30; i++) {
      Master obj = Master();
      obj.image = splashLogo;
      obj.webDisplay = "diamond" + i.toString();
      obj.isSelected = false;
      listOfMaster.add(obj);
    }

    selectionModel.masters = listOfMaster;

    if (selectionModel.isShowAll == true) {
      Master allMaster = Master();
      allMaster.sId = R.string().commonString.all;
      allMaster.webDisplay = R.string().commonString.all;
      allMaster.isSelected = false;

      selectionModel.masters.insert(0, allMaster);
    }
    if (selectionModel.isShowMore) {
      Master allMaster = Master();
      allMaster.sId =
          selectionModel.isShowMoreSelected ? "Show More" : "Show Less";
      allMaster.webDisplay =
          selectionModel.isShowMoreSelected ? "Show More" : "Show Less";
      allMaster.isSelected = false;

      selectionModel.masters.insert(selectionModel.masters.length, allMaster);
    }

    for (var masterIndex = 0; masterIndex < elementsToShow; masterIndex++) {
      listOfMasterView.add(selectionModel.masters[masterIndex]);
    }
    listOfMasterView
        .add(selectionModel.masters[selectionModel.masters.length - 1]);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 220) / 2;
    final double itemWidth = size.width / 2;



    return Scaffold(
      appBar: getAppBar(
        context,
        "GridViewList for filter",
      ),
      body: selectionModel.verticalScroll
          ? GridView.count(
              primary: false,
              childAspectRatio: (itemWidth / itemHeight),
              padding: const EdgeInsets.all(2),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              crossAxisCount: 4,
              children: List.generate(
                getGridViewLength(selectionModel),
                (index) {
                  Master obj;
                  int totalIndex = getGridViewLength(selectionModel);
                  if (totalIndex <= elementsToShow + 1)
                    obj = listOfMasterView[index];
                  else
                    obj = selectionModel.masters[index];

                  if (index == 0 && selectionModel.isShowAll == true) {
                    return InkWell(
                      onTap: () {
                        selectionModel.masters.forEach((element) {
                          if (element.sId != "Show More" ||
                              element.sId != "Show Less")
                            element.isSelected = true;
                        });
                        selectionModel.isShowAllSelected = true;
                        setState(() {});
                      },
                      child: CardItem(
                        txt: "All",
                        obj: obj,
                        selectionModel: selectionModel,
                      ),
                    );
                  } else if (selectionModel.isShowMoreSelected == false &&
                      selectionModel.isShowMore &&
                      index == totalIndex - 1) {
                    obj.sId = "Show Less";
                    obj.webDisplay = "Show Less";
                    return InkWell(
                      onTap: () {
                        selectionModel.isShowMoreSelected = true;
                        setState(() {});
                      },
                      child: CardItem(
                        txt: "Show Less",
                        obj: obj,
                        selectionModel: selectionModel,
                      ),
                    );
                  } else if (selectionModel.isShowMoreSelected == true &&
                      selectionModel.isShowMore &&
                      index == totalIndex - 1) {
                    obj.sId = "Show More";
                    obj.webDisplay = "Show More";
                    return InkWell(
                      onTap: () {
                        selectionModel.isShowMoreSelected = false;
                        setState(() {});
                      },
                      child: CardItem(
                        txt: "Show More",
                        obj: obj,
                        selectionModel: selectionModel,
                      ),
                    );
                  } else {
                    // int tempIndex;
                    // if (selectionModel.isShowAll)
                    //   tempIndex = index - 1;
                    // else
                    //   tempIndex = index;
                    return InkWell(
                      onTap: () {
                        if (selectionModel.isShowAllSelected) {
                          selectionModel.isShowAllSelected = false;
                        }
                        selectionModel.masters.forEach((element) {
                          if (element.sId == R.string().commonString.all &&
                              element.isSelected &&
                              obj.isSelected) {
                            element.isSelected = false;
                          }
                        });
                        obj.isSelected ^= true;
                        if (obj.isSelected) {
                          for (int i = 1;
                              i < selectionModel.masters.length - 1;
                              i++) {
                            if (selectionModel.masters[i].isSelected) {
                              selectionModel.isShowAllSelected = true;
                            } else {
                              selectionModel.isShowAllSelected = false;
                              break;
                            }
                          }
                        }
                        setState(() {});
                      },
                      child: CardItem(
                        obj: obj,
                        selectionModel: selectionModel,
                      ),
                    );
                  }
                },
              ),
            )
          : SelectionWidget(selectionModel),
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
                  child: Text(
                    obj.webDisplay,
                    textAlign: TextAlign.center,
                    style: appTheme.blackNormal14TitleColorblack
                  ),
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
