//import 'dart:html';

import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Future openDateTimeDialog(BuildContext context, ActionClick actionClick) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: appTheme.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getSize(15)),
          ),
          child: DateTimeDialog(actionClick),
        );
      });
}

class DateTimeDialog extends StatefulWidget {
  ActionClick actionClick;

  DateTimeDialog(this.actionClick);

  @override
  _DateTimeDialogState createState() => _DateTimeDialogState();
}

class _DateTimeDialogState extends State<DateTimeDialog>
    with SingleTickerProviderStateMixin {
  PageController _controller = PageController();
  TabController _tabController;
  int sharedValue = 0;
  DateTime selectedDate = DateTime.now();
  List<TabTitle> tabList;

  @override
  void initState() {
    _initTabData();
    _tabController = new TabController(length: tabList.length, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        print(_tabController.index);
        tabList.forEach(
          (item) => item.isSelected = false,
        );
        setState(() {
          tabList[_tabController.index].isSelected = true;
        });
        _onPageChange(_tabController.index, p: _controller);
      }
    });
    super.initState();
  }

  _onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      await _controller.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    } else {
      _tabController.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: getSize(20)),
            child: Text(
              "Select Date & Time",
              style: appTheme.black16TextStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: getSize(20), bottom: getSize(20)),
            child: TabBar(
              onTap: (index) {
                _controller.jumpToPage(index);
              },
              isScrollable: true,
              controller: _tabController,
//            labelStyle: Theme.of(context)
//                .textTheme
//                .headline
//                .copyWith(fontSize: getSize(18)),
              unselectedLabelColor: Colors.black,
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: LineTabIndicator(
                  color: appTheme.colorPrimary,
                  height: getSize(3),
                  width: getSize(30)),
              tabs: tabList.map((item) {
                return Padding(
                  padding: EdgeInsets.only(bottom: getSize(10)),
                  child: Text(
                    item.title,
                    style: appTheme.black16TextStyle,
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            height: getSize(350),
            child: PageView.builder(
              onPageChanged: (index) {
                _onPageChange(index);
              },
              //physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              itemCount: tabList.length,
              itemBuilder: (context, position) {
                if (position == 0) {
                  return getDateRangePicker();
                } else {
                  return getTimeRangePicker();
                }
              },
            ),
          ),
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
                        R.string().commonString.cancel,
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
                      Navigator.pop(context);
                      widget.actionClick(ManageCLick(
                          date: selectedDate.toUtc().toIso8601String()));
                    },
                    child: Container(
                      //alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.symmetric(
                        vertical: getSize(15),
                      ),
                      decoration: BoxDecoration(
                          color: appTheme.colorPrimary,
                          borderRadius: BorderRadius.circular(getSize(5)),
                          boxShadow: getBoxShadow(context)),
                      child: Text(
                        R.string().commonString.btnSubmit,
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
      ),
    );
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    DateTime dt = args.value;
    selectedDate = DateTime(dt.year, dt.month, dt.day, selectedDate.hour,
        selectedDate.minute, selectedDate.second, selectedDate.millisecond);
    SchedulerBinding.instance.addPostFrameCallback((duration) {
//    setState(() {});addPostFrameCallback
//  });
    });
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

  Widget getTimeRangePicker() {
    return Column(
      children: [
        Text(
          DateUtilities().convertServerDateToFormatterString(
              selectedDate.toIso8601String(),
              formatter: DateUtilities.hh_mm_a),
          style: appTheme.blackMedium20TitleColorblack,
        ),
        TimePickerSpinner(
          is24HourMode: false,
          normalTextStyle: appTheme.black16TextStyle,
          highlightedTextStyle: appTheme.blue20TextStyle,
          spacing: 50,
          itemHeight: 80,
          isForce2Digits: true,
          onTimeChange: (time) {
            setState(() {
              selectedDate = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  time.hour,
                  time.minute,
                  time.second,
                  time.millisecond);
            });
          },
        ),
      ],
    );
  }

  _initTabData() {
    tabList = [
      new TabTitle("Select Date", 0, isSelected: true),
      new TabTitle(
        "Select Time",
        1,
      ),
    ];
  }
}

class LineTabIndicator extends Decoration {
  final BoxPainter _painter;

  LineTabIndicator(
      {@required Color color, @required double height, @required double width})
      : _painter = _IndicatorPainter(color, height, width);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _IndicatorPainter extends BoxPainter {
  final Paint _paint;
  final double height;
  final double width;

  _IndicatorPainter(Color color, this.height, this.width)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - height - 5);
    Rect rect = Rect.fromLTWH(
        circleOffset.dx - width / 2, circleOffset.dy - height, width, height);
    canvas.drawRect(rect, _paint);
    Path path = Path();
    path.addRect(rect);
    canvas.drawShadow(path, _paint.color.withAlpha(80), height, true);
  }
}

class TabTitle {
  String title;
  bool isSelected;
  int id;

  TabTitle(
    this.title,
    this.id, {
    this.isSelected = false,
  });
}
