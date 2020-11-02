import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';

class RecentSearchWidget extends StatefulWidget {
  List<SavedSearchModel> recentSearch;

  RecentSearchWidget({this.recentSearch});

  @override
  _RecentSearchWidgetState createState() => _RecentSearchWidgetState();
}

class _RecentSearchWidgetState extends State<RecentSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return isNullEmptyOrFalse(widget.recentSearch)
        ? SizedBox()
        :  Padding(
      padding: EdgeInsets.only(
        top: getSize(20),
        left: getSize(Spacing.leftPadding),
        right: getSize(Spacing.rightPadding),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              getTitleText(R.string().screenTitle.recentSearch),
              Spacer(),
              InkWell(
                onTap: () {
                  //
                },
                child: getViewAll(),
              ),
            ],
          ),
          SizedBox(
            height: getSize(20),
          ),
          Container(
              height: getSize(160),
              child: ListView.builder(
                itemCount: widget.recentSearch.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return getRecentItem(widget.recentSearch[index]);
                },)
          )
        ],
      ),
    );
  }

  getRecentItem(SavedSearchModel recentSearch) {
    return Padding(
      padding: EdgeInsets.only(
        top: getSize(10),
        right: getSize(20),
        bottom: getSize(20),
      ),
      child: Container(
        padding: EdgeInsets.all(getSize(10)),
        decoration: BoxDecoration(
          color: appTheme.whiteColor,
          border: Border.all(color: appTheme.textGreyColor),
        ),
        child: Column(
          children: [
           getText(recentSearch.getCreatedDate()),
            Divider(height: getSize(20),color: appTheme.textGreyColor,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Expanded(
                  child: Row(
                    children:  isNullEmptyOrFalse(recentSearch.searchData)
                        ? [
                      getText(R.string().commonString.shape, style: appTheme.grey12TextStyle),
                      SizedBox(width: getSize(5),),
                          getText("All")
                    ] :
                    getWidgets(recentSearch.searchData,recentSearch.searchData.shp,R.string().commonString.shape),
                  ),
                ),
                  Expanded(
                    child: Row(
                      children: [
                        getText(R.string().commonString.carat, style: appTheme.grey12TextStyle),
                        SizedBox(width: getSize(5),),
                        isNullEmptyOrFalse(recentSearch.searchData) ||
                            isNullEmptyOrFalse(recentSearch.searchData.or) ||
                            isNullEmptyOrFalse(recentSearch.searchData.or.first)||
                            isNullEmptyOrFalse(recentSearch.searchData.or.first.crt)||
                            isNullEmptyOrFalse(recentSearch.searchData.or.first.crt.back)||
                            isNullEmptyOrFalse(recentSearch.searchData.or.first.crt.empty)
                            ? getText("All") :
                        getText("${recentSearch.searchData.or.first.crt.back}, ${recentSearch.searchData.or.first.crt.empty}")
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: isNullEmptyOrFalse(recentSearch.searchData)
                          ? [
                        getText(R.string().commonString.color, style: appTheme.grey12TextStyle),
                        SizedBox(width: getSize(5),),
                            getText("All")
                      ] :
                        getWidgets(recentSearch.searchData,recentSearch.searchData.col,R.string().commonString.color),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  getTitleText(String title) {
    return Text(
      title,
      style: appTheme.blackNormal18TitleColorblack.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  getViewAll() {
    return Text(
      R.string().screenTitle.viewAll,
      style: appTheme.black14TextStyle.copyWith(
        fontWeight: FontWeight.w500,
        color: appTheme.colorPrimary,
      ),
    );
  }

  getText(String text, {TextStyle style}) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: style ?? appTheme.black12TextStyle,
    );
  }

  getDot() {
    return Padding(
      padding: EdgeInsets.only(left: getSize(4), right: getSize(4)),
      child: Container(
        height: getSize(4),
        width: getSize(4),
        decoration:
        BoxDecoration(color: appTheme.dividerColor, shape: BoxShape.circle),
      ),
    );
  }

  getWidgets(DisplayDataClass searchData, List<String> searchList, String title) {
    List<Widget> list = List();
    list.add( getText(title, style: appTheme.grey12TextStyle),);
    list.add( SizedBox(width: getSize(5),),);
    if(isNullEmptyOrFalse(searchData)) {
      list.add(getText("All"));
    } else if(isNullEmptyOrFalse(searchList)) {
      list.add(getText("All"));
    } else {
      for (var i = 0; i < searchList.length; i++) {
        i == searchList.length-1 ? list.add(getText(searchList[i])) : list.add(getText("${searchList[i]},"));
      }
    }
    return list;
  }

}
