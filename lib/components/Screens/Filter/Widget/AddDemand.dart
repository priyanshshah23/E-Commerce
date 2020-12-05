import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ColorConstant.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/network/NetworkCall.dart';
import 'package:diamnow/app/network/ServiceModule.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CommonTextfield.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/widgets/shared/CommonDateTimePicker.dart';
import 'package:diamnow/components/widgets/shared/buttons.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:diamnow/modules/Filter/gridviewlist/FilterRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddDemand extends StatefulWidget {
  String title;
  List<FormBaseModel> arrList;
  Function({String selectedDate, String diamondTitle}) applyCallBack;
  bool isShowTextField ;
  AddDemand({
    this.title,
    this.arrList,
    this.applyCallBack,
    this.isShowTextField = true,
  });

  @override
  _AddDemandState createState() =>
      _AddDemandState(applyCallBack: this.applyCallBack,title: this.title);
}

class _AddDemandState extends State<AddDemand> {
  List<FormBaseModel> arrList;
  Function({String selectedDate, String diamondTitle}) applyCallBack;
  _AddDemandState({this.arrList, this.applyCallBack,this.title});
  
  String title;
  DateTime _selectedDate = DateTime.now();
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
        padding: EdgeInsets.only(
            top: getSize(30),
            bottom: getSize(20),
            left: getSize(20),
            right: getSize(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: getSize(20)),
              child: Text(
                widget.title ?? "",
                style: appTheme.blackSemiBold18TitleColorblack,
              ),
            ),
            widget.isShowTextField
                ? Padding(
                    padding: EdgeInsets.only(bottom: getSize(20)),
                    child: Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: getDiamondTitleTextField(),
                    ),
                  )
                : SizedBox(),
            getDateRangePicker(),
            Padding(
              padding: EdgeInsets.only(top: getSize(20), bottom: getSize(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: appTheme.colorPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(getSize(5)),
                      ),
                      child: AppButton.flat(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        borderRadius: getSize(5),
                        text: R.string().commonString.cancel,
                        textColor: appTheme.colorPrimary,
                        backgroundColor: appTheme.lightColorPrimary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getSize(20),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: appTheme.colorPrimary,
                          borderRadius: BorderRadius.circular(getSize(5)),
                          boxShadow: getBoxShadow(context)),
                      child: AppButton.flat(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          if (widget.isShowTextField) {
                            if (_formKey.currentState.validate()) {
                              diamondTitle = _diamondTitleTextField.text ?? "";

                              print(_selectedDate);
                              print(_diamondTitleTextField.text);
                              // callApiForAddDemand();
                              _diamondTitleTextField.text = "";
                              Navigator.pop(context);
                              widget.applyCallBack(
                                  selectedDate: _selectedDate.toUtc().toIso8601String(),
                                  diamondTitle: diamondTitle);
                            } else {
                              _autoValidate = true;
                            }
                          } else {
                           
                            widget.applyCallBack(
                              selectedDate: _selectedDate.toUtc().toIso8601String(),
              
                            );
                             Navigator.pop(context);
                          }
                        },
                        borderRadius: getSize(5),
                        text: R.string().commonString.btnSubmit,
                      ),
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
    // _selectedDate = DateFormat('dd MMMM, yyyy').format(args.value);
    // SchedulerBinding.instance.addPostFrameCallback((duration) {
    //   setState(() {});
    // });
     DateTime dt = args.value;
    _selectedDate = DateTime(dt.year, dt.month, dt.day, _selectedDate.hour,
        _selectedDate.minute, _selectedDate.second, _selectedDate.millisecond);
    SchedulerBinding.instance.addPostFrameCallback((duration) {
//    setState(() {});addPostFrameCallback
//  });
    });
  }

  //  openDatePicker() {
  //   openDateTimeDialog(context, (manageClick) {
  //     setState(() {
  //       _selectedDate = manageClick.date;
  //       // _dateController.text = DateUtilities()
  //       //     .convertServerDateToFormatterString(selectedDate,
  //       //         formatter: DateUtilities.dd_mm_yyyy_);
  //     });
  //   },
  //       isTime: false,
  //       title: R.string().commonString.selectDate,
  //       );
  // }

  Widget getDateRangePicker() {
    return Container(
      height: getSize(250),
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
    );
  }

  getDiamondTitleTextField() {
    return CommonTextfield(
      focusNode: _focusDiamondTitleTextField,
      textOption: TextFieldOption(
        prefixWid: getCommonIconWidget(
            imageName: diamondIcon, imageType: IconSizeType.small),
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
