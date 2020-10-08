import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchComponent extends StatefulWidget {
  String title;
  int max;
  int min;
  int maxValue;
  int minValue;

  SearchComponent({
    this.title,
    this.max,
    this.min,
    this.maxValue,
    this.minValue,
  });

  @override
  _SearchComponentState createState() => _SearchComponentState(
        title: title,
        max: max,
        maxValue: maxValue,
        min: min,
        minValue: minValue,
      );
}

class _SearchComponentState extends State<SearchComponent> {
  String title;
  int max;
  int min;
  int maxValue;
  int minValue;
  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _maxValueController = TextEditingController();
  var _focusMinValue = FocusNode();
  var _focusMaxValue = FocusNode();

  _SearchComponentState({
    this.title,
    this.max,
    this.min,
    this.maxValue,
    this.minValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getSize(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title),
              Row(
                children: <Widget>[
                  Expanded(
                    child:TextField(
                      focusNode: _focusMinValue,
                      controller: _minValueController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(),
                          hintText: "From",
                          hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.red)
                      ),

                    ),
                  ),
                  SizedBox(
                    width: getSize(15),
                  ),
                  Expanded(
                    child:TextField(
                      focusNode: _focusMaxValue,
                      controller: _maxValueController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(),
                          hintText: "To",
                          hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.red)
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
