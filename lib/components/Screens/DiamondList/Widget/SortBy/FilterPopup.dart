import 'dart:convert';

import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterBy extends StatefulWidget {
  List<FilterOptions> optionList;
  Function(List<Map<String,dynamic>> request) callBack;
  FilterBy({this.optionList, this.callBack});

  @override
  _FilterByState createState() => _FilterByState();
}

class _FilterByState extends State<FilterBy> {
  @override
  void initState() {
    super.initState();
    SyncManager.instance.callAnalytics(context,
        page: PageAnalytics.OFFLINE_DOWNLOAD,
        section: SectionAnalytics.VIEW,
        action: ActionAnalytics.OPEN);
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
            child:
                Text("Sort By", style: appTheme.commonAlertDialogueTitleStyle),
          ),
          ListView.builder(
            padding: EdgeInsets.only(bottom: getSize(15)),
            shrinkWrap: true,
            itemCount: widget.optionList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  widget.optionList.forEach((element) {
                    element.isSelected = false;
                  });
                  widget.optionList[index].isSelected =
                      !widget.optionList[index].isSelected;
                  setState(() {});

                  Navigator.pop(context);
                  widget.callBack(widget.optionList[index].request);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getSize(12), horizontal: getSize(20)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: getSize(14),
                        width: getSize(14),
                        child: Image.asset(
                          filterPopUpPath + widget.optionList[index].icon,
                        ),
                      ),
                      SizedBox(
                        width: getSize(22),
                      ),
                      Expanded(
                        child: Text(widget.optionList[index].title,
                            style: appTheme.black14TextStyle),
                      ),
                      Container(
                        height: getSize(16),
                        width: getSize(16),
                        child: Image.asset(
                          widget.optionList[index].isSelected
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
  List<Map<String, dynamic>> request;

  FilterOptions({
    this.title,
    this.isSelected = false,
    this.icon,
    this.isActive = true,
    this.apiKey,
    this.request,
  });

  FilterOptions.fromJson(Map<String, dynamic> json) {
    title =  R.string?.dynamickeys?.byKey(
      json['title'],
    );
    isSelected = json['isSelected'];
    icon = json['icon'];
    isActive = json['isActive'];
    apiKey = json['apiKey'];
    request = json["request"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['isSelected'] = this.isSelected;
    data['icon'] = this.icon;
    data['isActive'] = this.isActive;
    data['apiKey'] = this.apiKey;
    data["request"] = this.request;
    return data;
  }
}
