import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:flutter/material.dart';

class DialogueList extends StatefulWidget {
  final List duplicateItems;
  final Function({CityList cityList, CountryList countryList, StateList stateList}) applyFilterCallBack;
  var selectedItem;
  DialogueListType type;

  DialogueList(
      {this.duplicateItems, this.applyFilterCallBack, this.selectedItem, this.type});

  @override
  _DialogueListState createState() =>
      _DialogueListState(duplicateItems, applyFilterCallBack, selectedItem);
}

class _DialogueListState extends State<DialogueList> {
  TextEditingController searchController = TextEditingController();
  final List duplicateItems;
  List items = List();
  Function({CityList cityList, CountryList countryList, StateList stateList}) applyFilterCallBack;
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
            Container(
                decoration: BoxDecoration(
                  color: appTheme.textBlackColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(getSize(25)),
                      topRight: Radius.circular(getSize(25))),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getSize(20), vertical: getSize(20)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          getTitle(),
                          style: AppTheme.of(context)
                              .theme
                              .textTheme
                              .subhead
                              .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstants.white),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.clear,
                            size: getSize(16),
                            color: ColorConstants.white,
                          ))
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
                          filled: true,
                          fillColor: appTheme.textFieldBorderColor,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: getSize(20)),
                          hintText: R.string().commonString.search,
                          suffixIcon: Icon(
                            Icons.search,
                            color: appTheme.textGreyColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)))),
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
                            if(widget.type == DialogueListType.City) {
                              applyFilterCallBack(cityList: items[index]);
                            } else if(widget.type == DialogueListType.State) {
                              applyFilterCallBack(stateList: items[index]);
                            } else if(widget.type == DialogueListType.Country) {
                              applyFilterCallBack(countryList: items[index]);
                            }
                            items[index].isActive = true;
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: getSize(10)),
                            child: Row(
                              children: <Widget>[
                                Expanded(child: Text(items[index].name)),
                                selectedItem.name == items[index].name
                                    ? Icon(Icons.done)
                                    : SizedBox()
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
    if(widget.type == DialogueListType.City) {
      return R.string().commonString.selectCity;
    } else if(widget.type == DialogueListType.State) {
      return R.string().commonString.selectState;
    } else if(widget.type == DialogueListType.Country) {
      return R.string().commonString.selectCountry;
    }
  }
}
