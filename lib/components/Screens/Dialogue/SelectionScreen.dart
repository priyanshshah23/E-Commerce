import 'package:diamnow/app/Helper/NetworkClient.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/CellModel.dart';
import 'package:diamnow/models/SalesPerson/CompanyListModel.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatefulWidget {
  Function({List<SelectionPopupModel> multiSelectedItem}) applyFilterCallBack;
  String title = "Select Item";
  String hintText = "Search Item";
  bool isSearchEnable;
  bool isMultiSelectionEnable;
  String positiveButtonTitle;
  String negativeButtonTitle;
  CellType type;

  SelectionScreen({
    this.applyFilterCallBack,
    this.hintText,
    this.title,
    this.isSearchEnable = true,
    this.isMultiSelectionEnable = false,
    this.negativeButtonTitle,
    this.positiveButtonTitle,
    this.type = CellType.Hold_Party,
  });

  @override
  _SelectionScreenState createState() => _SelectionScreenState(
        applyFilterCallBack,
        hintText,
        title,
        isSearchEnable,
        isMultiSelectionEnable,
        positiveButtonTitle,
        negativeButtonTitle,
        type,
      );
}

class _SelectionScreenState extends State<SelectionScreen> {
  TextEditingController searchController = TextEditingController();
  List<SelectionPopupModel> options = List();
  List<SelectionPopupModel> selectedOptions = List();
  CompanyListData companyListData;
  Function({List<SelectionPopupModel> multiSelectedItem}) applyFilterCallBack;
  String title = "Select Item";
  String hintText = "Search Item";
  bool isSearchEnable;
  bool isMultiSelectionEnable;
  String positiveButtonTitle;
  String negativeButtonTitle;
  bool isEmptyList = true;
  CellType type = CellType.Hold_Party;

  _SelectionScreenState(
    this.applyFilterCallBack,
    this.hintText,
    this.title,
    this.isSearchEnable,
    this.isMultiSelectionEnable,
    this.positiveButtonTitle,
    this.negativeButtonTitle,
    this.type,
  );

  @override
  void initState() {
    super.initState();
    if (type == CellType.SalesPersonName) {
      callApiForGetSalesmanList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      bottomNavigationBar: getBotoomButtons(),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: getSize(10),
              ),
              getBackButtonAndTitleText(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: getSize(20),
                      left: getSize(20),
                      top: isSearchEnable ? getSize(10) : getSize(00),
                      bottom: getSize(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      isSearchEnable ? getSearchTextField() : SizedBox(),
                      /*isEmptyList
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  "Record not found",
                                  style: appTheme.blackNormal18TitleColorblack,
                                ),
                              ),
                            )
                          :*/
                      getListView(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getBotoomButtons() {
    return Padding(
      padding: EdgeInsets.only(
          left: getSize(20), right: getSize(20), bottom: getSize(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: AppButton.flat(
              onTap: () {
                Navigator.pop(context);
              },
              text: negativeButtonTitle != null
                  ? negativeButtonTitle
                  : R.string.commonString.cancel,
              borderRadius: getSize(5),
              textColor: appTheme.colorPrimary,
              backgroundColor: Colors.transparent,
              fitWidth: true,
              isBorder: true,
            ),
          ),
          SizedBox(
            width: getSize(20),
          ),
          Expanded(
            child: AppButton.flat(
              onTap: () {
//                if (isMultiSelectionEnable) {
                List<SelectionPopupModel> dummyList =
                    List<SelectionPopupModel>();
                options.forEach((element) {
                  if (element.isSelected) {
                    dummyList.add(element);
                  }
                });
                applyFilterCallBack(multiSelectedItem: dummyList);
//                Navigator.pop(context);
                /*  } else {
                  for (int i = 0; i < selectionOptions.length; i++) {
                    if (selectionOptions[i].isSelected) {
                      applyFilterCallBack(selectedItem: selectionOptions[i]);
                      break;
                    }
                  }
                }*/
                Navigator.pop(context);
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
    );
  }

  getSearchTextField() {
    return Container(
      height: getSize(50),
      child: TextField(
        onChanged: (value) {
          if (value.length > 2) {
            callApiForGetCompanyList(value);
          } else {
            options.clear();
            isEmptyList = true;
            setState(() {});
          }
        },
        autofocus: true,
        controller: searchController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: getSize(20)),
            hintText: hintText,
            hintStyle: appTheme.blackNormal18TitleColorblack.copyWith(
              color: appTheme.placeholderColor,
            ),
            suffixIcon: getCommonIconWidget(
                imageName: search, imageType: IconSizeType.medium),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)))),
      ),
    );
  }

  getBackButtonAndTitleText() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          getBackButton(context),
          Text(
            title,
            style: appTheme.blackMedium20TitleColorblack,
          ),
        ],
      ),
    );
  }

  getListView() {
    if (isNullEmptyOrFalse(options)) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(getSize(20)),
          child: Container(
            child: Center(
              child: Text(
                  searchController.text.length > 2
                      ? R.string.noDataStrings.noDataFound
                      : R.string.screenTitle.typeWordsToSearch,
                  textAlign: TextAlign.center,
                  style: appTheme.black18TextStyle),
            ),
          ),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          vertical: getSize(10),
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          print("---------------${/*options[index].title +
              " | " +*/
              options[index]?.buyername}");
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              if (!isMultiSelectionEnable) {
                options.forEach((element) {
                  element.isSelected = false;
                });
              }
              options[index].isSelected = !options[index].isSelected;
              if (options[index].isSelected) {
                selectedOptions.add(options[index]);
              }
              setState(() {});
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: getSize(2),
              ),
              child: Container(
                decoration: options[index].isSelected
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          getSize(5),
                        ),
                        color: appTheme.colorPrimary,
                      )
                    : null,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getSize(10), horizontal: getSize(16)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        type == CellType.Company
                            ? options[index].title +
                                    " | " +
                                    options[index]?.buyername ??
                                ""
                            : options[index].title,
                        style: options[index].isSelected
                            ? appTheme.white18TextStyle
                            : appTheme.blackNormal18TitleColorblack,
                      )),
                      SizedBox(
                        width: getSize(10),
                      ),
                      Container(
                        child: options[index].isSelected
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
    );
  }

  callApiForGetCompanyList(String title) {
    Map<String, dynamic> dict = {};
    if (type == CellType.BrokerName || type == CellType.Memo_BrokerName) {
      dict["ledgerType"] = "broker";
    }
    dict["page"] = DEFAULT_PAGE;
    dict["limit"] = 15;
    dict["startWith"] = {
      "keyword": title,
      "keys": ["companyName", "name", "firstName", "lastName", "mobile"]
    };
    dict["sort"] = [
      {"createdAt": "DESC"}
    ];

    app.resolve<CustomDialogs>().showProgressDialog(context, "");

    NetworkClient.getInstance.callApi(
      context,
      baseURL,
      type == CellType.Hold_Buyer
          ? ApiConstants.buyerList
          : ApiConstants.companyList,
      MethodType.Post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      params: dict,
      successCallback: (response, message) {
        app.resolve<CustomDialogs>().hideProgressDialog();
        options.clear();
        companyListData = CompanyListData.fromJson(response);
        companyListData.list.forEach((element) {
          print("------------------------------------------${element.user.firstName + " " + element.user.lastName}");
          if (type == CellType.Hold_Buyer) {
            options.add(SelectionPopupModel(
              element.id,
              element.firstName + " " + element.lastName,
              subTitle: element.account.companyName,
              subId: element.account.id,
            ));
          } else if (type == CellType.Hold_Party || type == CellType.Company) {
//            if (element.seller != null || element.user != null) {
              options.add(SelectionPopupModel(
                element.id,
                element.firstName + " " + element.lastName,
                subTitle: element.seller?.name ?? "",
                subId: element.seller?.id ?? "",
                buyerId: element.user?.id ?? "",
                buyername: element.user.firstName + " " + element.user.lastName,
              ));
//            } else {
//              options.add(SelectionPopupModel(
//                element.id,
//                element.firstName + " " + element.lastName,
//              ));
//            }
          } else if (type == CellType.Memo_BrokerName) {
            options.add(SelectionPopupModel(
              element.id,
              element.firstName +
                  " " +
                  element.lastName +
                  " | " +
                  element.user.firstName +
                  " " +
                  element.user.lastName,
            ));
          } else {
            options.add(SelectionPopupModel(
              element.id,
              element.firstName + " " + element.lastName,
            ));
          }
        });
        setState(() {
          isEmptyList = false;
        });
      },
      failureCallback: (status, message) {
        app.resolve<CustomDialogs>().hideProgressDialog();
        print(message);
        setState(() {
          isEmptyList = true;
        });
      },
    );
  }

  callApiForGetSalesmanList() {
//    app.resolve<CustomDialogs>().showProgressDialog(context, "");

    NetworkClient.getInstance.callApi(
      context,
      baseURL,
      ApiConstants.salesmanList,
      MethodType.Post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) {
//        app.resolve<CustomDialogs>().hideProgressDialog();
        List<Broker> salesList = List();
        response.forEach((v) {
          salesList.add(new Broker.fromJson(v));
        });
        salesList.forEach((element) {
          options.add(SelectionPopupModel(
              element.id, element.firstName + " " + element.lastName));
        });
        setState(() {
          isEmptyList = false;
        });
      },
      failureCallback: (status, message) {
//        app.resolve<CustomDialogs>().hideProgressDialog();
        print(message);
        setState(() {
          isEmptyList = true;
        });
      },
    );
  }
}
