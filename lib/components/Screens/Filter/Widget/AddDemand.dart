import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ColorConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CommonTextfield.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/widgets/shared/buttons.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/modules/Filter/gridviewlist/FilterRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddDemand extends StatefulWidget {
  List<FormBaseModel> arrList;
  Function({String selectedDate,String diamondTitle})
      applyCallBack;
  AddDemand({
    this.arrList,
    this.applyCallBack,
  });

  @override
  _AddDemandState createState() => _AddDemandState(applyCallBack:this.applyCallBack);
}

class _AddDemandState extends State<AddDemand> {
  List<FormBaseModel> arrList;
  Function({String selectedDate,String diamondTitle})
      applyCallBack;
  _AddDemandState({
    this.arrList,
    this.applyCallBack
  });

  String _selectedDate;
  String diamondTitle;
  final TextEditingController _diamondTitleTextField = TextEditingController();
  var _focusDiamondTitleTextField = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MathUtilities.screenWidth(context),
        padding: EdgeInsets.symmetric(
            horizontal: getSize(20), vertical: getSize(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: getSize(20)),
              child: Text(
                R.string().commonString.addDemand,
                style: appTheme.blackSemiBold18TitleColorblack,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: getSize(10)),
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: getDiamondTitleTextField(),
              ),
            ),
            getDateRangePicker(),
            Padding(
              padding: EdgeInsets.only(top: getSize(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(getSize(5))),
                    width: getSize(130),
                    height: getSize(50),
                    child: AppButton.flat(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      text: R.string().commonString.cancel,
                      textColor: ColorConstants.colorPrimary,
                      backgroundColor:
                          ColorConstants.backgroundColorForCancleButton,
                    ),
                  ),
                  Container(
                    width: getSize(130),
                    height: getSize(50),
                    child: AppButton.flat(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState.validate()) {
                          diamondTitle = _diamondTitleTextField.text ?? "";

                          print(_selectedDate);
                          print(_diamondTitleTextField.text);
                          // callApiForAddDemand();
                          _diamondTitleTextField.text = "";
                          Navigator.pop(context);
                          widget.applyCallBack(selectedDate: _selectedDate,diamondTitle:diamondTitle);
                        } else {
                          _autoValidate = true;
                        }
                      },
                      text: R.string().commonString.btnSubmit,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    _selectedDate = DateFormat('dd MMMM, yyyy').format(args.value);
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {});
    });
  }

  Widget getDateRangePicker() {
    return Container(
      height: getSize(250),
      child: Card(
        child: SfDateRangePicker(
          initialDisplayDate: DateTime.now(),
          minDate: DateTime.now(),
          selectionColor: appTheme.colorPrimary,
          todayHighlightColor: appTheme.colorPrimary,
          initialSelectedDate: DateTime.now(),
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.single,
          onSelectionChanged: selectionChanged,
        ),
      ),
    );
  }

  getDiamondTitleTextField() {
    return CommonTextfield(
      focusNode: _focusDiamondTitleTextField,
      textOption: TextFieldOption(
        prefixWid: getCommonIconWidget(
            imageName: saved_icon, imageType: IconSizeType.small),
        hintText: R.string().commonString.demandTitle,
        maxLine: 1,
        formatter: [BlacklistingTextInputFormatter(RegExp(RegexForEmoji))],
        keyboardType: TextInputType.text,
        inputController: _diamondTitleTextField,
      ),
      textCallback: (text) {},
      validation: (text) {
        if (text.isEmpty) {
          return R.string().commonString.pleaseEnterDemandTitle;
        } else {
          return null;
        }
      },
      inputAction: TextInputAction.next,
      onNextPress: () {
        _focusDiamondTitleTextField.unfocus();
        FocusScope.of(context).requestFocus(_focusDiamondTitleTextField);
      },
    );
  }

}
