import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/CellModel.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/DropdownTextField.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
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
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Form(
            key: _formkey,
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
                      return DropDownTextField(_arrDropDown[index]);
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
                    _formkey.currentState.validate();
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

  List<CellModel> getDropdownTextFieldList() {
    return [
      CellModel(
        hintText: "Party*",
        perfixImage: buildingIcon,
        emptyValidationText: "Please select and enter party.",
        type: CellType.Party,
      ),
      CellModel(
        hintText: "Buyer Name*",
        perfixImage: buyer,
        emptyValidationText: "Please select and enter buyer name.",
        type: CellType.BuyerName,
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
        type: CellType.BrokerName,
      ),
    ];
  }
}
