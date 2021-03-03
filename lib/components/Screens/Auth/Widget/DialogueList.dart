import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';

class SelectionDialogue extends StatefulWidget {
  List<SelectionPopupModel> selectionOptions;
  Function(
      {SelectionPopupModel selectedItem,
      List<SelectionPopupModel> multiSelectedItem}) applyFilterCallBack;
  String title = "Select Item";
  String hintText = "Search Item";
  bool isSearchEnable;
  bool isMultiSelectionEnable;
  String positiveButtonTitle;
  String negativeButtonTitle;
  bool showViewAllButton;
  VoidCallback showViewAllButtonCallBack;
  SelectionDialogue(
      {this.selectionOptions,
      this.applyFilterCallBack,
      this.hintText,
      this.title,
      this.isSearchEnable = true,
      this.isMultiSelectionEnable = false,
      this.negativeButtonTitle,
      this.positiveButtonTitle,
      this.showViewAllButton = false,
      this.showViewAllButtonCallBack});

  @override
  _SelectionDialogueState createState() => _SelectionDialogueState(
        selectionOptions,
        applyFilterCallBack,
        hintText,
        title,
        isSearchEnable,
        isMultiSelectionEnable,
        positiveButtonTitle,
        negativeButtonTitle,
        showViewAllButton,
        showViewAllButtonCallBack,
      );
}

class _SelectionDialogueState extends State<SelectionDialogue> {
  TextEditingController searchController = TextEditingController();
  List<SelectionPopupModel> selectionOptions;
  List<SelectionPopupModel> items = List();
  Function(
      {SelectionPopupModel selectedItem,
      List<SelectionPopupModel> multiSelectedItem}) applyFilterCallBack;
  String title = "Select Item";
  String hintText = "Search Item";
  bool isSearchEnable;
  bool isMultiSelectionEnable;
  String positiveButtonTitle;
  String negativeButtonTitle;
  bool showViewAllButton;
  VoidCallback showViewAllButtonCallBack;
  _SelectionDialogueState(
    this.selectionOptions,
    this.applyFilterCallBack,
    this.hintText,
    this.title,
    this.isSearchEnable,
    this.isMultiSelectionEnable,
    this.positiveButtonTitle,
    this.negativeButtonTitle,
    this.showViewAllButton,
    this.showViewAllButtonCallBack,
  );

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
                  horizontal: getSize(16), vertical: getSize(10)),
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
                  isSearchEnable
                      ? Container(
                          height: getSize(50),
                          child: TextField(
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                            controller: searchController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: getSize(20)),
                                hintText: hintText,
                                hintStyle: appTheme.blackNormal18TitleColorblack
                                    .copyWith(
                                  color: appTheme.placeholderColor,
                                ),
                                suffixIcon: getCommonIconWidget(
                                    imageName: search,
                                    imageType: IconSizeType.medium),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0))),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0)))),
                          ),
                        )
                      : SizedBox(),
                  isSearchEnable
                      ? SizedBox(
                          height: getSize(5),
                        )
                      : SizedBox(),
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
                            if (isMultiSelectionEnable) {
                              items[index].isSelected =
                                  !items[index].isSelected;
                              setState(() {});
                            } else {
                              Navigator.of(context).pop();

                              applyFilterCallBack(selectedItem: items[index]);
                            }
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
                                      ? appTheme.blackNormal18TitleColorPrimary
                                      : appTheme.blackNormal18TitleColorblack,
                                )),
                                SizedBox(
                                  width: getSize(10),
                                ),
                                isMultiSelectionEnable
                                    ? Container(
                                        height: getSize(16),
                                        width: getSize(16),
                                        child: items[index].isSelected
                                            ? Image.asset(selectedIcon)
                                            : Image.asset(unselectedIcon),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  showViewAllButton
                      ? Container(
                          height: getSize(50),
                          child: AppButton.flat(
                            onTap: () {
                              showViewAllButtonCallBack();
                            },
                            text: R.string.screenTitle.viewAll,
                          ),
                        )
                      : SizedBox(),
                  isMultiSelectionEnable
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getSize(Spacing.leftPadding),
                              vertical: getSize(16)),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    // alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.symmetric(
                                      vertical: getSize(15),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: appTheme.colorPrimary,
                                          width: getSize(1)),
                                      borderRadius:
                                          BorderRadius.circular(getSize(5)),
                                    ),
                                    child: Text(
                                      negativeButtonTitle != null
                                          ? negativeButtonTitle
                                          : R.string.commonString.cancel,
                                      textAlign: TextAlign.center,
                                      style: appTheme.blue14TextStyle
                                          .copyWith(fontSize: getFontSize(16)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: getSize(20),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    List<SelectionPopupModel> dummyList =
                                        List<SelectionPopupModel>();
                                    items.forEach((element) {
                                      if (element.isSelected) {
                                        dummyList.add(element);
                                      }
                                    });

                                    applyFilterCallBack(
                                        multiSelectedItem: dummyList);
                                  },
                                  child: Container(
                                    //alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.symmetric(
                                      vertical: getSize(15),
                                    ),
                                    decoration: BoxDecoration(
                                        color: appTheme.colorPrimary,
                                        borderRadius:
                                            BorderRadius.circular(getSize(5)),
                                        boxShadow: getBoxShadow(context)),
                                    child: Text(
                                      positiveButtonTitle != null
                                          ? positiveButtonTitle
                                          : R.string.commonString.btnSubmit,
                                      textAlign: TextAlign.center,
                                      style: appTheme.white16TextStyle,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
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
