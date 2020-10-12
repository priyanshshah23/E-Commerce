import 'package:diamnow/app/app.export.dart';
import 'package:flutter/material.dart';

class DiamondItemWidget extends StatefulWidget {
  @override
  _DiamondItemWidgetState createState() => _DiamondItemWidgetState();
}

class _DiamondItemWidgetState extends State<DiamondItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MathUtilities.screenWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(getSize(5)),
        boxShadow: getBoxShadow(context),
      ),
      child: Text("test"),
    );
  }
}
