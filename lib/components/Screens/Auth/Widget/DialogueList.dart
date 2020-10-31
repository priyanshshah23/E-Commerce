import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';

class DialogueList extends StatefulWidget {
  List<SelectionPopupModel> selectionOptions;
  Function(SelectionPopupModel) applyFilterCallBack;
  String title = "Select Item";
  String hintText = "Search Item";

  DialogueList(
      {this.selectionOptions,
      this.applyFilterCallBack,
      this.hintText,
      this.title});

  @override
  _DialogueListState createState() =>
      _DialogueListState(selectionOptions, applyFilterCallBack,hintText,title);
}

class _DialogueListState extends State<DialogueList> {
  TextEditingController searchController = TextEditingController();
  List<SelectionPopupModel> selectionOptions;
  List<SelectionPopupModel> items = List();
  Function(SelectionPopupModel) applyFilterCallBack;
  String title = "Select Item";
  String hintText = "Search Item";

  _DialogueListState(
      this.selectionOptions, this.applyFilterCallBack, this.hintText, this.title);

  @override
  void initState() {
    items.addAll(selectionOptions);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: getSize(20),
            ),
            Container(
                child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getSize(20), vertical: getSize(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: appTheme.blackMedium20TitleColorblack,
                  ),
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getSize(20), vertical: getSize(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: getSize(50),
                    child: TextField(
                      onChanged: (value) {
                          filterSearchResults(value);
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: getSize(20)),
                          hintText: hintText,
                          hintStyle: appTheme.blackNormal18TitleColorblack,
                          suffixIcon: getCommonIconWidget(
                              imageName: search,
                              imageType: IconSizeType.medium),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)))),
                    ),
                  ),
                  SizedBox(
                    height: getSize(5),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: 50,
                        maxHeight: MathUtilities.screenHeight(context) - 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                              applyFilterCallBack(items[index]);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: getSize(10), horizontal: getSize(20)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                            items[index].title,
                                            style: items[index].isSelected
                                                ? appTheme
                                                    .blackNormal18TitleColorPrimary
                                                : appTheme
                                                    .blackNormal18TitleColorblack,
                                          )
                                ),
                                SizedBox(
                                  width: getSize(10),
                                ),
                                Container(
                                  height: getSize(16),
                                  width: getSize(16),
                                  child: items[index].isSelected
                                          ? Image.asset(selectedIcon)
                                          : Image.asset(unselectedIcon),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    query = query.toLowerCase();
    List<SelectionPopupModel> dummySearchList = List<SelectionPopupModel>();
    dummySearchList.addAll(selectionOptions);
    if (query.isNotEmpty) {
      List<SelectionPopupModel> dummyListData = List<SelectionPopupModel>();
      dummySearchList.forEach((item) {
          item.title = item.title.toLowerCase();
          if (item.title.contains(query)) {
            dummyListData.add(item);
          }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(selectionOptions);
      });
    }
  }

}
