import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class OpenDatePickerWidget extends StatefulWidget {
  Function(DateTime) onSubmit;
  DateTime selectedDate;

  OpenDatePickerWidget({this.onSubmit, this.selectedDate});

  @override
  _OpenDatePickerWidgetState createState() => _OpenDatePickerWidgetState();
}

class _OpenDatePickerWidgetState extends State<OpenDatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: getSize(30)),
          child: Text(
            R.string.commonString.selectDate,
            style: appTheme.blackSemiBold18TitleColorblack,
          ),
        ),
        getDateRangePicker(),
        Padding(
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
                      color: appTheme.colorPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(getSize(5)),
                    ),
                    child: Text(
                      R.string.commonString.cancel,
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
                    widget.onSubmit(widget.selectedDate);
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
                      R.string.commonString.btnSubmit,
                      textAlign: TextAlign.center,
                      style: appTheme.white16TextStyle,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget getDateRangePicker() {
    return Container(
      child: SfDateRangePicker(
        initialDisplayDate: DateTime.now(),
        minDate: DateTime.now(),
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.single,
        onSelectionChanged: selectionChanged,
      ),
    );
  }


  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    DateTime dt = args.value;
    widget.selectedDate = DateTime(dt.year, dt.month, dt.day, widget.selectedDate.hour,
        widget.selectedDate.minute, widget.selectedDate.second, widget.selectedDate.millisecond);
    SchedulerBinding.instance.addPostFrameCallback((duration) {
//    setState(() {});addPostFrameCallback
//  });
    });
  }

}
