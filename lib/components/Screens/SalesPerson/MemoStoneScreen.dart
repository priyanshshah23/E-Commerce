import 'package:diamnow/app/Helper/NetworkClient.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Dialogue/SelectionScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/CellModel.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/DropdownTextField.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/SalesPerson/CompanyListModel.dart';
import 'package:flutter/material.dart';

class MemoStoneScreen extends StatefulWidget {
  static const route = "MemoStoneScreen";

  List<DiamondModel> diamondList;

  MemoStoneScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      if (arguments[ArgumentConstant.DiamondList] != null) {
        diamondList = arguments[ArgumentConstant.DiamondList];
      }
    }
  }

  @override
  _MemoStoneScreenState createState() => _MemoStoneScreenState();
}

class _MemoStoneScreenState extends State<MemoStoneScreen> {
  DiamondCalculation diamondCalculation = DiamondCalculation();
  List<CellModel> _arrDropDown;
  bool _autovalidate = false;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _arrDropDown = getDropdownTextFieldList();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
//        _arrDropDown = getDropdownTextFieldList();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        "Memo Stone",
        centerTitle: false,
        leadingButton: getBackButton(context),
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Form(
            key: _formkey,
            autovalidate: _autovalidate,
            child: Column(
              children: [
                DiamondListHeader(
                  diamondCalculation: diamondCalculation,
//            moduleType: moduleType,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: getSize(16), vertical: getSize(20)),
                    itemCount: _arrDropDown.length,
                    itemBuilder: (context, index) {
                      return DropDownTextField(
                        _arrDropDown[index],
                        onTapCallBack: (model) {
                          if (model.type == CellType.Hold_Party) {
                            openPartypopup();
                          } else if (model.type == CellType.Hold_Buyer) {
                            openBuyerNamepopup();
                          } else if (model.type == CellType.SalesPersonName) {
                            openSalesmanPopup();
                          } else if (model.type == CellType.Memo_BrokerName) {
                            openBrokerNamepopup();
                          } else {
                            null;
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: getBottomButton(),
    );
  }

  getBottomButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: getSize(20), top: getSize(5)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: getSize(20),
                right: getSize(20),
              ),
              child: AppButton.flat(
                onTap: () {
                  Navigator.pop(context);
                },
                text: R.string.commonString.cancel,
                borderRadius: getSize(5),
                textColor: appTheme.colorPrimary,
                backgroundColor: appTheme.whiteColor,
                fitWidth: true,
                isBorder: true,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: getSize(20),
              ),
              child: Material(
                shadowColor: fromHex("#4EB45E4D"),
                child: AppButton.flat(
                  onTap: () {
                    if (_formkey.currentState.validate()) {
                      callApiForMemoDiamond();
                    } else {
                      _autovalidate = true;
                    }
                    setState(() {});
                  },
                  text: R.string.commonString.btnSubmit,
                  backgroundColor: appTheme.colorPrimary,
                  borderRadius: getSize(5),
                  fitWidth: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  openPartypopup() {
    List<CellModel> arr = _arrDropDown
        .where((element) => element.type == CellType.Hold_Party)
        .toList();
    if (arr != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return SelectionScreen(
              title: "Select Party",
              hintText: "Min. 3 Chars",
              positiveButtonTitle: "Done",
              negativeButtonTitle: "Cancel",
              isSearchEnable: true,
              type: CellType.Hold_Party,
              isMultiSelectionEnable: false,
              applyFilterCallBack: (
                  {List<SelectionPopupModel> multiSelectedItem}) {
                List<CellModel> arr1 = _arrDropDown
                    .where(
                        (element) => element.type == CellType.SalesPersonName)
                    .toList();
                List<CellModel> arr2 = _arrDropDown
                    .where((element) => element.type == CellType.Hold_Buyer)
                    .toList();
                setState(() {
                  arr.first.userText = multiSelectedItem.first.title;
                  arr.first.id = multiSelectedItem.first.id;
                  arr1.first.userText = multiSelectedItem.first.subTitle;
                  arr1.first.id = multiSelectedItem.first.subId;
                  arr2.first.userText = multiSelectedItem.first.buyername;
                  arr2.first.id = multiSelectedItem.first.buyerId;
                });
//                callApiForGetBuyerDetail(arr.first.id);
              },
            );
          },
        ),
      );
    }
  }

  openBuyerNamepopup() {
    List<CellModel> arr = _arrDropDown
        .where((element) => element.type == CellType.Hold_Buyer)
        .toList();
    if (arr != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return SelectionScreen(
              title: "Select Buyer",
              hintText: "Min. 3 Chars",
              positiveButtonTitle: "Done",
              negativeButtonTitle: "Cancel",
              isSearchEnable: true,
              type: CellType.Hold_Buyer,
              isMultiSelectionEnable: false,
              applyFilterCallBack: (
                  {List<SelectionPopupModel> multiSelectedItem}) {
                List<CellModel> arr1 = _arrDropDown
                    .where((element) => element.type == CellType.Hold_Party)
                    .toList();
                print("----------------------");
                setState(() {
                  arr.first.userText = multiSelectedItem.first.title;
                  arr.first.id = multiSelectedItem.first.id;
                  arr1.first.userText = multiSelectedItem.first.subTitle;
                  arr1.first.id = multiSelectedItem.first.subId;
                });
              },
            );
          },
        ),
      );
    }
  }

  openSalesmanPopup() {
    List<CellModel> arr = _arrDropDown
        .where((element) => element.type == CellType.SalesPersonName)
        .toList();
    if (arr != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return SelectionScreen(
              title: "Select Salesman",
              hintText: "Min. 3 Chars",
              positiveButtonTitle: "Done",
              negativeButtonTitle: "Cancel",
              isSearchEnable: false,
              type: CellType.SalesPersonName,
              isMultiSelectionEnable: false,
              applyFilterCallBack: (
                  {List<SelectionPopupModel> multiSelectedItem}) {
                arr.first.userText = multiSelectedItem.first.title;
                arr.first.id = multiSelectedItem.first.id;
                setState(() {});
              },
            );
          },
        ),
      );
    }
  }

  openBrokerNamepopup() {
    List<CellModel> arr = _arrDropDown
        .where((element) => element.type == CellType.Memo_BrokerName)
        .toList();
    if (arr != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return SelectionScreen(
              title: "Select Broker",
              hintText: "Min. 3 Chars",
              positiveButtonTitle: "Done",
              negativeButtonTitle: "Cancel",
              isSearchEnable: true,
              type: CellType.Memo_BrokerName,
              isMultiSelectionEnable: false,
              applyFilterCallBack: (
                  {List<SelectionPopupModel> multiSelectedItem}) {
                setState(() {
                  arr.first.userText = multiSelectedItem.first.title;
                  arr.first.id = multiSelectedItem.first.id;
                });
              },
            );
          },
        ),
      );
    }
  }

  callApiForGetBuyerDetail(String id) {
    print(id);
    List<CellModel> arr = _arrDropDown
        .where((element) => element.type == CellType.Hold_Buyer)
        .toList();
    Map<String, dynamic> dict = {};

    dict["filter"] = {"account": id};
    dict["page"] = DEFAULT_PAGE;
    dict["limit"] = 15;
    dict["startWith"] = {
      "keys": ["companyName", "name", "firstName", "lastName", "mobile"]
    };
    dict["sort"] = [
      {"createdAt": "DESC"}
    ];

    NetworkClient.getInstance.callApi(
      context,
      baseURL,
      ApiConstants.buyerList,
      MethodType.Post,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      params: dict,
      successCallback: (response, message) {
        CompanyListData companyListData;
        companyListData = CompanyListData.fromJson(response);
        arr.first.userText = companyListData.list.first.name;
        arr.first.id = companyListData.list.first.id;
        setState(() {});
      },
      failureCallback: (status, message) {
        print(message);
        setState(() {});
      },
    );
  }

  callApiForMemoDiamond() {
    Map<String, dynamic> dict = {};

    _arrDropDown.forEach((element) {
      if (element.type == CellType.Hold_Party) {
        dict["userAccount"] = element.id;
      } else if (element.type == CellType.Hold_Buyer) {
        dict["user"] = element.id;
      } else if (element.type == CellType.SalesPersonName) {
        dict["seller"] = element.id;
      } else if (element.type == CellType.Memo_BrokerName) {
        dict["broker"] = element.id;
      }
    });

    dict['blockType'] = BlockType.MEMO;
    dict['blockSetting'] = BlockSetting.MEMO;
    List<Map<String, dynamic>> diamonds = [];

    List<String> list = [];
    widget.diamondList.forEach((element) {
      Map<String, dynamic> dict = {};
      dict["diamond"] = element.id;
      dict["blockPricePerCarat"] = 0;
      dict["blockAmount"] = 0;
      dict["vnd"] = null;
      dict["vStnId"] = element.vStnId;
      diamonds.add(dict);
    });

    dict['diamonds'] = diamonds;
    print(dict);
    app.resolve<CustomDialogs>().showProgressDialog(context, "");

    NetworkClient.getInstance.callApi(
      context,
      baseURL,
      ApiConstants.holdDiamond,
      MethodType.Post,
      params: dict,
      headers: NetworkClient.getInstance.getAuthHeaders(),
      successCallback: (response, message) {
        app.resolve<CustomDialogs>().hideProgressDialog();
        app.resolve<CustomDialogs>().confirmDialog(
          context,
          title: "",
          desc: message,
          positiveBtnTitle: R.string.commonString.ok,
        );
      },
      failureCallback: (status, message) {
        app.resolve<CustomDialogs>().hideProgressDialog();
        app.resolve<CustomDialogs>().confirmDialog(
          context,
          title: "",
          desc: message,
          positiveBtnTitle: R.string.commonString.ok,
        );
      },
    );
  }

  List<CellModel> getDropdownTextFieldList() {
    return [
      CellModel(
        hintText: "Party*",
        perfixImage: buildingIcon,
        emptyValidationText: "Please select and enter party.",
        type: CellType.Hold_Party,
      ),
      CellModel(
        hintText: "Buyer Name*",
        perfixImage: buyer,
        emptyValidationText: "Please select and enter buyer name.",
        type: CellType.Hold_Buyer,
      ),
      CellModel(
        hintText: "Salesman*",
        perfixImage: salesman,
        emptyValidationText: "Please select and enter salesman.",
        type: CellType.SalesPersonName,
      ),
      CellModel(
        hintText: "Broker",
        perfixImage: broker,
        isRequired: false,
        type: CellType.Memo_BrokerName,
      ),
    ];
  }
}
