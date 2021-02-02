import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/CellModel.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/CommonTextField.dart';
import 'package:diamnow/components/Screens/SalesPerson/Widget/DropdownTextField.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:flutter/material.dart';

class HoldStoneScreen extends StatefulWidget {
  @override
  _HoldStoneScreenState createState() => _HoldStoneScreenState();
}

class _HoldStoneScreenState extends State<HoldStoneScreen> {
  DiamondCalculation diamondCalculation = DiamondCalculation();
  List<CellModel> _arrDropDown;
  bool _autovalidate = false;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() {
        _arrDropDown = getDropdownTextFieldList();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: appTheme.whiteColor,
        appBar: getAppBar(
          context,
          "Hold Stone",
          centerTitle: false,
          leadingButton: getBackButton(context),
        ),
        body: SafeArea(
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
                        return DropDownTextField(_arrDropDown[index]);
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
        bottomNavigationBar: getBottomButton(),
      ),
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
                onTap: () {},
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
                    _autovalidate = true;
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
        hintText: "Enter Hold Time (Hours)*",
        perfixImage: clock,
        emptyValidationText:
            "Please select and enter time.\nMin Hold Time: 1 | Max Hold Time: 72",
        patternValidationText: "Min Hold Time: 1 | Max Hold Time: 72",
        type: CellType.HoldTime,
        keyboardType: TextInputType.number,
      ),
      CellModel(
        hintText: "Comment",
//        perfixImage: clock,
        type: CellType.Comment,
        inputAction: TextInputAction.done,
        leftPadding: 20,
        maxLine: 5,
        isRequired: false,
      ),
    ];
  }
}
