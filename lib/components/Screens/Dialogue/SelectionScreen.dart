import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/models/Address/CityListModel.dart';
import 'package:diamnow/models/Address/CountryListModel.dart';
import 'package:diamnow/models/Address/StateListModel.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatefulWidget {
  List<SelectionPopupModel> selectionOptions = List();
  Function(
      {SelectionPopupModel selectedItem,
      List<SelectionPopupModel> multiSelectedItem}) applyFilterCallBack;
  String title = "Select Item";
  String hintText = "Search Item";
  bool isSearchEnable;
  bool isMultiSelectionEnable;
  String positiveButtonTitle;
  String negativeButtonTitle;

  SelectionScreen(
      {this.selectionOptions,
      this.applyFilterCallBack,
      this.hintText,
      this.title,
      this.isSearchEnable = true,
      this.isMultiSelectionEnable = false,
      this.negativeButtonTitle,
      this.positiveButtonTitle});

  @override
  _SelectionScreenState createState() => _SelectionScreenState(
      selectionOptions,
      applyFilterCallBack,
      hintText,
      title,
      isSearchEnable,
      isMultiSelectionEnable,
      positiveButtonTitle,
      negativeButtonTitle);
}

class _SelectionScreenState extends State<SelectionScreen> {
  TextEditingController searchController = TextEditingController();
  List<SelectionPopupModel> selectionOptions = List();
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

  _SelectionScreenState(
      this.selectionOptions,
      this.applyFilterCallBack,
      this.hintText,
      this.title,
      this.isSearchEnable,
      this.isMultiSelectionEnable,
      this.positiveButtonTitle,
      this.negativeButtonTitle);

  @override
  void initState() {
    if (selectionOptions != null) {
      items.addAll(selectionOptions);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                    padding: isSearchEnable
                        ? EdgeInsets.symmetric(
                            horizontal: getSize(16), vertical: getSize(10))
                        : EdgeInsets.only(
                            left: getSize(16),
                            right: getSize(16),
                            top: getSize(10),
                          ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          title,
                          style: appTheme.blackMedium20TitleColorblack,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: getSize(20),
                      left: getSize(20),
                      top: isSearchEnable ? getSize(10) : getSize(00),
                      bottom: getSize(10)),
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
                                    hintStyle: appTheme
                                        .blackNormal18TitleColorblack
                                        .copyWith(
                                      color: appTheme.placeholderColor,
                                    ),
                                    suffixIcon: getCommonIconWidget(
                                        imageName: search,
                                        imageType: IconSizeType.medium),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)))),
                              ),
                            )
                          : SizedBox(),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                          vertical: getSize(10),
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (!isMultiSelectionEnable) {
                                items.forEach((element) {
                                  element.isSelected = false;
                                });
                              }
                              items[index].isSelected =
                                  !items[index].isSelected;
                              setState(() {});
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: getSize(2),
                              ),
                              child: Container(
                                decoration: items[index].isSelected
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          getSize(5),
                                        ),
                                        color: appTheme.colorPrimary,
                                      )
                                    : null,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(10),
                                      horizontal: getSize(16)),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(
                                        items[index].title,
                                        style: items[index].isSelected
                                            ? appTheme.white18TextStyle
                                            : appTheme
                                                .blackNormal18TitleColorblack,
                                      )),
                                      SizedBox(
                                        width: getSize(10),
                                      ),
                                      Container(
                                        child: items[index].isSelected
                                            ? Icon(
                                                Icons.check,
                                                color: appTheme.whiteColor,
                                              )
                                            : SizedBox(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: getSize(5),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: AppButton.flat(
                              onTap: () {
//                                  Navigator.pop(context);
                              },
                              borderRadius: getSize(5),
                              fitWidth: true,
                              text: negativeButtonTitle != null
                                  ? negativeButtonTitle
                                  : R.string.commonString.cancel,
                              //isButtonEnabled: enableDisableSigninButton(),
                            ),
                          ),
                          SizedBox(
                            width: getSize(20),
                          ),
                          Expanded(
                            child: AppButton.flat(
                              onTap: () {
//                                  Navigator.pop(context);
                                if (isMultiSelectionEnable) {
                                  List<SelectionPopupModel> dummyList =
                                      List<SelectionPopupModel>();
                                  items.forEach((element) {
                                    if (element.isSelected) {
                                      print("-------multi----${element.title}");
                                      dummyList.add(element);
                                    }
                                  });
//                                      applyFilterCallBack(
//                                          multiSelectedItem: dummyList);
                                } else {
                                  for (int i = 0; i < items.length; i++) {
                                    if (items[i].isSelected) {
                                      print("-------one----${items[i].title}");
                                      applyFilterCallBack(
                                          selectedItem: items[i]);
                                      break;
                                    }
                                  }
                                }
                              },
                              borderRadius: getSize(5),
                              fitWidth: true,
                              text: positiveButtonTitle != null
                                  ? positiveButtonTitle
                                  : R.string.commonString.btnSubmit,
                              //isButtonEnabled: enableDisableSigninButton(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
