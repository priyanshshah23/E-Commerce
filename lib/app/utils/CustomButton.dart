import 'package:flutter/material.dart';

import '../app.export.dart';

class CustomButton extends StatelessWidget {
  // CustomButton({@required this.onPressed, @required this.text});

  CustomButton({
    Key key,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.rightPadding = 0,
    this.leftPadding = 0,
    this.isButtonEnabled = true,
    @required this.onPressed,
    @required this.text,
  }) : super(key: key);

  final GestureTapCallback onPressed;
  final String text;
  final double topPadding;
  final double rightPadding;
  final double leftPadding;
  final double bottomPadding;
  final bool isButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: topPadding,
          right: rightPadding,
          left: leftPadding,
          bottom: bottomPadding),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: Container(
          child: RawMaterialButton(
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(getSize(4)),
            ),
            fillColor: isButtonEnabled == true
                ? appTheme.colorPrimary
                : AppTheme.of(context).theme.disabledColor,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(text,
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: getSize(20),
                          color: isButtonEnabled
                              ? appTheme.colorPrimary
                              : AppTheme.of(context).theme.buttonColor)),
                ],
              ),
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
