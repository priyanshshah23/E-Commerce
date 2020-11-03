import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              height: getSize(150),
              child: GridView.count(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                crossAxisCount: 1,
//              childAspectRatio: 0.36,
                // without Price
                childAspectRatio: 0.7, // with Price
//              mainAxisSpacing: 10,
                children: List.generate( widget.recentSearch.length, (index) {
                  return InkWell(
                      onTap: () {
//                      moveToDetail();
                      },
                      child: getRecentItem(widget.recentSearch[index]));
                },
                ),
              ),
//              child: ListView.builder(
//                itemCount: widget.recentSearch.length,
//                scrollDirection: Axis.horizontal,
//                itemBuilder: (BuildContext context, int index) {
//                  return getRecentItem(widget.recentSearch[index]);
//                },)
          )
        ],
      ),
    );
  }

  getRecentItem(SavedSearchModel recentSearch) {
    return Container(
      margin: EdgeInsets.symmetric(vertical:getSize(10), horizontal: getSize(10)),
      padding: EdgeInsets.symmetric(vertical:getSize(10), horizontal: getSize(14)),
      decoration: BoxDecoration(
        color: appTheme.whiteColor,
        border: Border.all(color: appTheme.textGreyColor),
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           getText(recentSearch.getCreatedDate(), style: appTheme.black14TextStyle),
          Divider(color: appTheme.textGreyColor,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    getText(R.string().commonString.shape, style: appTheme.grey14TextStyle),
                    SizedBox(width : getSize(5)),
                    isNullEmptyOrFalse(recentSearch.displayData)  ||  isNullEmptyOrFalse(recentSearch.displayData.shp)
                        ?  getText("All", style: appTheme.black14TextStyle) : Flexible(
                      child: Text(
                        recentSearch.displayData.shp.map((item) {
                          return item;
                        }).toList().join(", "),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                          style: appTheme.black14TextStyle
                      ),
                    ),
                  ],
            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getText(R.string().commonString.carat, style: appTheme.grey14TextStyle),
                  SizedBox(width : getSize(5)),
                  isNullEmptyOrFalse(recentSearch.displayData) ||
                      isNullEmptyOrFalse(recentSearch.displayData.or) ||
                      isNullEmptyOrFalse(recentSearch.displayData.or.first)||
                      isNullEmptyOrFalse(recentSearch.displayData.or.first.crt)||
                      isNullEmptyOrFalse(recentSearch.displayData.or.first.crt.back)||
                      isNullEmptyOrFalse(recentSearch.displayData.or.first.crt.empty)
                      ? getText("All", style: appTheme.black14TextStyle) :
                  getText("${recentSearch.displayData.or.first.crt.back}, ${recentSearch.displayData.or.first.crt.empty}", style: appTheme.black14TextStyle)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      getText(R.string().commonString.color, style: appTheme.grey14TextStyle),
                      SizedBox(width : getSize(5)),
                      isNullEmptyOrFalse(recentSearch.displayData) ||  isNullEmptyOrFalse(recentSearch.displayData.col)
                          ? getText("All", style: appTheme.black14TextStyle) : Flexible(
                        child: Text(
                            recentSearch.displayData.col.map((item) {
                              return item;
                            }).toList().join(", "),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                            style: appTheme.black14TextStyle
                        ),
                      ),
                    ]
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
      softWrap: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style ?? appTheme.black14TextStyle,
    );
  }

}
