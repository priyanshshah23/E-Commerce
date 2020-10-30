import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';

class DialogueList extends StatefulWidget {
  final List duplicateItems;
  final Function(
      {CityList cityList,
      CountryList countryList,
      StateList stateList,
      SavedSearchModel savedSearchModel,
      }) applyFilterCallBack;
  var selectedItem;
  DialogueListType type;

  DialogueList(
      {this.duplicateItems,
      this.applyFilterCallBack,
      this.selectedItem,
      this.type});

  @override
  _DialogueListState createState() =>
      _DialogueListState(duplicateItems, applyFilterCallBack, selectedItem);
}

class _DialogueListState extends State<DialogueList> {
  TextEditingController searchController = TextEditingController();
  final List duplicateItems;
  List items = List();
  Function({CityList cityList, CountryList countryList, StateList stateList, SavedSearchModel savedSearchModel,})
      applyFilterCallBack;
  var selectedItem;

  _DialogueListState(
      this.duplicateItems, this.applyFilterCallBack, this.selectedItem);

  @override
  void initState() {
    items.addAll(duplicateItems);
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
                        getTitle(),
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
                          hintText: getHintText(),
                          hintStyle: appTheme.blackNormal18TitleColorblack,
                          suffixIcon:  getCommonIconWidget(
                              imageName: search, imageType: IconSizeType.medium),
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
                            if (widget.type == DialogueListType.City) {
                              applyFilterCallBack(cityList: items[index]);
                            } else if (widget.type == DialogueListType.State) {
                              applyFilterCallBack(stateList: items[index]);
                            } else if (widget.type ==
                                DialogueListType.Country) {
                              applyFilterCallBack(countryList: items[index]);
                            } else if (widget.type ==
                                DialogueListType.SAVEDSEARCH) {
                              applyFilterCallBack(savedSearchModel: items[index]);
                            }
                            items[index].isActive = true;
                           
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: getSize(10), horizontal: getSize(20)),
                            child: Row(
                              children: <Widget>[
                                Expanded(child: Text(items[index].name, style: selectedItem != null && selectedItem.name == items[index].name ? appTheme.blackNormal18TitleColorPrimary : appTheme.blackNormal18TitleColorblack,)),
                                SizedBox(
                                  width: getSize(10),
                                ),
                                Container(
                                  height: getSize(16),
                                  width: getSize(16),
                                  child: selectedItem != null && selectedItem.name == items[index].name ?  Image.asset(selectedIcon) :  Image.asset(unselectedIcon),
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
    List dummySearchList = List();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List dummyListData = List();
      dummySearchList.forEach((item) {
        item.name = item.name.toLowerCase();
        if (item.name.contains(query)) {
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
        items.addAll(duplicateItems);
      });
    }
  }

  String getTitle() {
    if (widget.type == DialogueListType.City) {
      return R.string().commonString.selectCity;
    } else if (widget.type == DialogueListType.State) {
      return R.string().commonString.selectState;
    } else if (widget.type == DialogueListType.Country) {
      return R.string().commonString.selectCountry;
    } else if(widget.type == DialogueListType.SAVEDSEARCH) {
      return R.string().commonString.savedSearch;
    }
    return "";
  }

  String getHintText() {
    if (widget.type == DialogueListType.City) {
      return R.string().commonString.searchCity;
    } else if (widget.type == DialogueListType.State) {
      return R.string().commonString.searchState;
    } else if (widget.type == DialogueListType.Country) {
      return R.string().commonString.searchCountry;
    } else if (widget.type == DialogueListType.SAVEDSEARCH) {
      return R.string().commonString.searchSavedSearch;
    }
    return "";
  }
}
