import 'package:diamnow/app/Helper/NetworkClient.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Dialogue/SelectionScreen.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/CellModel.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/CommonTextField.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/DropdownTextField.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/material.dart';

class BuyNowScreen extends StatefulWidget {
  static const route = "BuyNowScreen";

  List<DiamondModel> diamondList;

  BuyNowScreen(
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
  _BuyNowScreenState createState() => _BuyNowScreenState();
}

class _BuyNowScreenState extends State<BuyNowScreen> {
  DiamondCalculation diamondCalculation = DiamondCalculation();
  List<CellModel> _arrDropDown;
  bool _autovalidate = false;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<SelectionPopupModel> arrBillType = List<SelectionPopupModel>();
  List<SelectionPopupModel> arrTermType = List<SelectionPopupModel>();
  List<SelectionPopupModel> arrInvoiceType = getInvoiceArr();

  @override
  void initState() {
    super.initState();
    _arrDropDown = getDropdownTextFieldList();
    getBillType();
    getTermType();
  }

  getBillType() async {
    List<Master> list = List();
    list = await AppDatabase.instance.masterDao
        .getSubMastersFromParentCode(MasterCode.billType);
    list.forEach((element) {
      arrBillType.add(SelectionPopupModel(element.sId, element.name));
    });
  }

  getTermType() async {
    List<Master> list = List();
    list = await AppDatabase.instance.masterDao
        .getSubMastersFromParentCode(MasterCode.dayTerm);
    list.forEach((element) {
      arrTermType.add(SelectionPopupModel(element.sId, element.name));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: getAppBar(
        context,
        "Buy Now",
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
                      if (_arrDropDown[index].textFieldType ==
                          TextFieldEnum.Normal) {
                        return CommonTextField(_arrDropDown[index]);
                      } else if (_arrDropDown[index].textFieldType ==
                          TextFieldEnum.DropDown) {
                        return DropDownTextField(
                          _arrDropDown[index],
                          onTapCallBack: (model) {
                            if (model.type == CellType.Party) {
                              openPartypopup();
                            } else if (model.type == CellType.BuyerName) {
                              openBuyerNamepopup();
                            } else if (model.type == CellType.SalesPersonName) {
                              openSalesmanPopup();
                            } else if (model.type == CellType.BrokerName) {
                              openBrokerNamepopup();
                            } else if (model.type == CellType.BillType) {
                              showBilltypeBottomSheet();
                            } else if (model.type == CellType.Invoice) {
                              showInvoiceBottomSheet();
                            } else if (model.type == CellType.Term) {
                              showTermtypeBottomSheet();
                            } else {
                              null;
                            }
                          },
                        );
                      } else {
                        return SizedBox();
                      }
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

  openPartypopup() {
    List<CellModel> arr = _arrDropDown
        .where((element) => element.type == CellType.Party)
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

  openBuyerNamepopup() {
    List<CellModel> arr = _arrDropDown
        .where((element) => element.type == CellType.BuyerName)
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
              type: CellType.BuyerName,
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
        .where((element) => element.type == CellType.BrokerName)
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
              type: CellType.BrokerName,
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

  //Show Billtype bottomsheet
  showBilltypeBottomSheet() {
    List<CellModel> arr = _arrDropDown
        .where((element) => element.type == CellType.BillType)
        .toList();

    if (arr.isNotEmpty) {
      modalBottomSheetMenu(context,
          title: "Select Bill Type",
          selectionOptions: arrBillType, callback: (model) {
        arrBillType.forEach((value) => value.isSelected = false);
        arrBillType.firstWhere((value) => value == model).isSelected = true;
        arr.first.userText = model.title;
        arr.first.id = model.id;
        setState(() {});
      });
    }
  }

  //Show Invoice bottomsheet
  showInvoiceBottomSheet() {
    List<CellModel> arr = _arrDropDown
        .where((element) => element.type == CellType.Invoice)
        .toList();

    if (arr.isNotEmpty) {
      modalBottomSheetMenu(context,
          title: "Select Invoice Type",
          selectionOptions: arrInvoiceType, callback: (model) {
        arrInvoiceType.forEach((value) => value.isSelected = false);
        arrInvoiceType.firstWhere((value) => value == model).isSelected = true;
        arr.first.userText = model.title;
        arr.first.id = model.id;
        setState(() {});
      });
    }
  }

  //Show Termtype bottomsheet
  showTermtypeBottomSheet() {
    List<CellModel> arr =
        _arrDropDown.where((element) => element.type == CellType.Term).toList();

    if (arr.isNotEmpty) {
      modalBottomSheetMenu(context,
          title: "Select Term Type",
          selectionOptions: arrTermType, callback: (model) {
        arrTermType.forEach((value) => value.isSelected = false);
        arrTermType.firstWhere((value) => value == model).isSelected = true;
        arr.first.userText = model.title;
        arr.first.id = model.id;
        setState(() {});
      });
    }
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
                      callApiForBuyNow();
                    } else {
                      setState(() {
                        _autovalidate = true;
                      });
                    }
//                    setState(() {});
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

  callApiForBuyNow() {
    Map<String, dynamic> dict = {};
    _arrDropDown.forEach((element) {
      if (element.type == CellType.Party) {
        dict["companyName"] = element.id;
      } else if (element.type == CellType.BuyerName) {
        dict["user"] = element.id;
      } else if (element.type == CellType.SalesPersonName) {
        dict["seller"] = element.id;
      } else if (element.type == CellType.BrokerName) {
        dict["account"] = element.id;
      } else if (element.type == CellType.Invoice) {
        dict["invoiceDate"] = element.id;
      } else if (element.type == CellType.BillType) {
        dict["billType"] = element.id;
      } else if (element.type == CellType.Term) {
        dict["terms"] = element.id;
      } else if (element.type == CellType.Comment) {
        if (element.userText.isNotEmpty) dict['comment'] = element.userText;
      }
    });
    List<String> list = [];
    widget.diamondList.forEach((element) {
      list.add(element.id);
    });
    dict["diamonds"] = list;
    print(dict);
    app.resolve<CustomDialogs>().showProgressDialog(context, "");

    NetworkClient.getInstance.callApi(
      context,
      baseURL,
      ApiConstants.buyNow,
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
        type: CellType.Party,
        textFieldType: TextFieldEnum.DropDown,
      ),
      CellModel(
        hintText: "Buyer Name*",
        perfixImage: buyer,
        emptyValidationText: "Please select and enter buyer name.",
        type: CellType.BuyerName,
        textFieldType: TextFieldEnum.DropDown,
      ),
      CellModel(
        hintText: "Salesman*",
        perfixImage: salesman,
        emptyValidationText: "Please select and enter salesman.",
        type: CellType.SalesPersonName,
        textFieldType: TextFieldEnum.DropDown,
      ),
      CellModel(
        hintText: "Broker",
        perfixImage: broker,
        isRequired: false,
        type: CellType.BrokerName,
        textFieldType: TextFieldEnum.DropDown,
      ),
      CellModel(
        hintText: "Invoice Date",
        perfixImage: calender,
        type: CellType.Invoice,
        textFieldType: TextFieldEnum.DropDown,
        isRequired: false,
      ),
      CellModel(
        hintText: "Bill Type",
        perfixImage: invoice,
        type: CellType.BillType,
        textFieldType: TextFieldEnum.DropDown,
        isRequired: false,
      ),
      CellModel(
        hintText: "Terms",
        perfixImage: clock,
        type: CellType.Term,
        textFieldType: TextFieldEnum.DropDown,
        isRequired: false,
      ),
      /* CellModel(
        hintText: "Enter Hold Time (Hours)*",
        perfixImage: clock,
        emptyValidationText:
        "Please select and enter time.\nMin Hold Time: 1 | Max Hold Time: 72",
        patternValidationText: "Min Hold Time: 1 | Max Hold Time: 72",
        type: CellType.HoldTime,
        keyboardType: TextInputType.number,
      ),*/
      CellModel(
        hintText: "Comment",
        type: CellType.Comment,
        inputAction: TextInputAction.done,
        leftPadding: 20,
        maxLine: 5,
        isRequired: false,
      ),
    ];
  }
}
