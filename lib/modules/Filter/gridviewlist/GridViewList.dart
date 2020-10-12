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
  int elementsToShow = 5;
  List<Master> listOfMasterView = [];
  SelectionModel selectionModel = SelectionModel(
    isShowAll: true,
    isShowMore: true,
    isShowAllSelected: false,
    isShowMoreSelected: false,
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
    selectionModel.masters = listOfMaster;

    for (var masterIndex = 0; masterIndex < elementsToShow; masterIndex++) {
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
      body: GridView.count(
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
                    selectionModel.isShowAllSelected = false;
                    selectionModel.masters.forEach((element) {
                      element.isSelected = false;
                    });
                  }

                  obj.isSelected ^= true;
                  setState(() {});
                },
                child: CardItem(obj: obj),
              );
            }
          },
        ),
      ),
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

  CardItem({Key key, this.obj, this.txt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            obj != null && obj.isSelected ? Colors.blueAccent : Colors.teal[50],
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
