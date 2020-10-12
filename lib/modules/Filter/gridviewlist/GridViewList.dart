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
  int elementsToShow = 5;
  List<Master> listOfMasterView = [];

  //selectionModel for handling UI
  SelectionModel selectionModel = SelectionModel(
    isShowAll: true,
    isShowMore: true,
    isShowAllSelected: false,
    isShowMoreSelected: false,
    // orientation:"horizontal",
    verticalScroll: true,
  );

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      Master obj = Master();
      obj.image = splashLogo;
      obj.name = "diamond" + i.toString();
      obj.isSelected = false;
      listOfMaster.add(obj);
    }

    if (selectionModel.isShowAll == true) {
      Master allMaster = Master();
      allMaster.sId = R.string().commonString.all;
      allMaster.webDisplay = R.string().commonString.all;
      allMaster.isSelected = false;

      selectionModel.masters.insert(0, allMaster);
    }

    selectionModel.masters = listOfMaster;

    for (var masterIndex = 1; masterIndex < elementsToShow; masterIndex++) {
      listOfMasterView.add(selectionModel.masters[masterIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context,
        "GridViewList for filter",
      ),
      body:selectionModel.verticalScroll ?
      GridView.count(
        primary: false,
        padding: const EdgeInsets.all(2),
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 4,
        children: List.generate(
          getGridViewLength(selectionModel),
          (index) {
            int totalIndex = getGridViewLength(selectionModel);
            if (index == 0 && selectionModel.isShowAll == true) {
              return InkWell(
                onTap: () {
                  selectionModel.masters.forEach((element) {
                    element.isSelected = true;
                  });
                  selectionModel.isShowAllSelected = true;
                  setState(() {});
                },
                child: CardItem(
                  txt: "All",
                  selectionModel: selectionModel,
                ),
              );
            } else if (selectionModel.isShowMoreSelected == false &&
                selectionModel.isShowMore &&
                index == totalIndex - 1) {
              return InkWell(
                onTap: () {
                  selectionModel.isShowMoreSelected = true;
                  setState(() {});
                },
                child: CardItem(
                  txt: "Show Less",
                  selectionModel: selectionModel,
                ),
              );
            } else if (selectionModel.isShowMoreSelected == true &&
                selectionModel.isShowMore &&
                index == totalIndex - 1) {
              return InkWell(
                onTap: () {
                  selectionModel.isShowMoreSelected = false;
                  setState(() {});
                },
                child: CardItem(
                  txt: "Show More",
                  selectionModel: selectionModel,
                ),
              );
            } else {
              int tempIndex;
              if (selectionModel.isShowAll)
                tempIndex = index - 1;
              else
                tempIndex = index;
              Master obj = selectionModel.masters[tempIndex];
              return InkWell(
                onTap: () {
                  if (selectionModel.isShowAllSelected) {
                    selectionModel.isShowAllSelected=false;
                  }

                  obj.isSelected ^= true;
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
      ) :
      SelectionWidget(selectionModel),
    );
  }

  //Method for getting length of the gridview according to booleans.
  int getGridViewLength(SelectionModel selectionModel) {
    int length = 0;
    if (selectionModel.isShowAll && selectionModel.isShowMore) {
      if (selectionModel.isShowMoreSelected)
        length = listOfMasterView.length + 2;
      else
        length = selectionModel.masters.length + 2;
    } else if ((!selectionModel.isShowAll && selectionModel.isShowMore)) {
      if (selectionModel.isShowMoreSelected)
        length = listOfMasterView.length + 1;
      else
        length = selectionModel.masters.length + 1;
    } else if ((selectionModel.isShowAll && !selectionModel.isShowMore)) {
      length = selectionModel.masters.length + 1;
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

  CardItem({Key key, this.obj, this.txt,this.selectionModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            (obj != null && obj.isSelected) || (selectionModel.isShowAllSelected)
                ? Colors.blueAccent
                : Colors.teal[50],
      ),
      padding: const EdgeInsets.all(8),
      child: obj != null
          ? Column(
              children: <Widget>[
                Expanded(
                    child: Image.asset(
                  obj.image,
                  color: Colors.black,
                )),
                Text(obj.name),
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: getTitleText(context, txt),
            ),
    );
  }
}
