import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/components/Screens/DiamondList/Widget/CommonHeader.dart';
import 'package:diamnow/components/Screens/MemoStone/Widget/CellModel.dart';
import 'package:diamnow/components/Screens/MemoStone/Widget/DropdownTextField.dart';
import 'package:diamnow/models/DiamondList/DiamondConfig.dart';
import 'package:flutter/material.dart';

class MemoStoneScreen extends StatefulWidget {
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
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => setState(() {
            _arrDropDown = getDropdownTextFieldList();
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
      body: SafeArea(
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
                  padding: EdgeInsets.symmetric(horizontal: getSize(16)),
                  itemCount: _arrDropDown.length,
                  itemBuilder: (context, index) {
                    return DropDownTextField(_arrDropDown[index]);
                  },
                ),
              ),
              AppButton.flat(
                onTap: (){

                },
                text: "jhjhdsfr",
              )
            ],
          ),
        ),
      ),
    );
  }

  List<CellModel> getDropdownTextFieldList() {
    return [
      CellModel(
        hintText: "Party*",
        perfixImage: buyer,
        emptyValidationText: "Please select and enter party.",
      ),
      CellModel(
        hintText: "Buyer Name*",
        perfixImage: buyer,
        emptyValidationText: "Please select and enter buyer name.",
      ),
      CellModel(
        hintText: "Salesman*",
        perfixImage: salesman,
        emptyValidationText: "Please select and enter salesman.",
      ),
      CellModel(
        hintText: "Party*",
        perfixImage: broker,
        isRequired: false,
      ),
    ];
  }
}
