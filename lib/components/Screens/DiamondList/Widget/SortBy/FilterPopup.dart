import 'dart:convert';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterBy extends StatefulWidget {
  @override
  _FilterByState createState() => _FilterByState();
}

class _FilterByState extends State<FilterBy> {
  List<FilterOptions> optionList = List<FilterOptions>();

  @override
  void initState() {
    super.initState();
    Config().getOptionsJson().then((result) {
        result.forEach((element) {
          if(element.isSelected) {
            optionList.add(element);
          }
        });
        setState(() {});
    });
//    optionList.add(FilterOptions(title: "Default", icon: filterUnionArrow));
//    optionList
//        .add(FilterOptions(title: "New Diamonds", icon: filterRightArrow));
//    optionList
//        .add(FilterOptions(title: "Price Low to High", icon: filterUpArrow));
//    optionList
//        .add(FilterOptions(title: "Price High to Low", icon: filterDownArrow));
//    optionList
//        .add(FilterOptions(title: "Discount Low to High", icon: filterUpArrow));
//    optionList.add(
//        FilterOptions(title: "Discount High to Low", icon: filterDownArrow));
//    optionList
//        .add(FilterOptions(title: "Color Low to High", icon: filterUpArrow));
//    optionList
//        .add(FilterOptions(title: "Color High to Low", icon: filterDownArrow));
//    optionList
//        .add(FilterOptions(title: "Carat Low to High", icon: filterUpArrow));
//    optionList
//        .add(FilterOptions(title: "Carat High to Low", icon: filterDownArrow));
//    optionList
//        .add(FilterOptions(title: "Clarity Low to High", icon: filterUpArrow));
//    optionList.add(
//        FilterOptions(title: "Clarity High to Low", icon: filterDownArrow));
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(getSize(15)),
          topLeft: Radius.circular(getSize(15)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: getSize(28), bottom: getSize(21)),
            child: Text("Filter By",
                style: appTheme.commonAlertDialogueTitleStyle),
          ),
          ListView.builder(
            padding: EdgeInsets.only(bottom: getSize(15)),
            shrinkWrap: true,
            itemCount: optionList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  optionList.forEach((element) {element.isSelected = false;});
                  optionList[index].isSelected = !optionList[index].isSelected;
                  setState(() {});
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getSize(12), horizontal: getSize(20)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: getSize(12),
                        width: getSize(12),
                        child: Image.asset(
                          optionList[index].icon,
                        ),
                      ),
                      SizedBox(
                        width: getSize(22),
                      ),
                      Expanded(
                        child: Text(optionList[index].title,
                            style: appTheme.black12TextStyle),
                      ),
                      Container(
                        height: getSize(16),
                        width: getSize(16),
                        child: Image.asset(
                          optionList[index].isSelected
                              ? selectedFilter
                              : unselectedFilter,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class FilterOptions {
  String title;
  bool isSelected;
  String icon;
  bool isActive;
  String apiKey;

  FilterOptions(
      {this.title,
      this.isSelected = false,
      this.icon,
      this.isActive = true,
      this.apiKey});

  FilterOptions.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    isSelected = json['isSelected'];
    icon = json['icon'];
    isActive = json['isActive'];
    apiKey = json['apiKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['isSelected'] = this.isSelected;
    data['icon'] = this.icon;
    data['isActive'] = this.isActive;
    data['apiKey'] = this.apiKey;
    return data;
  }
}
