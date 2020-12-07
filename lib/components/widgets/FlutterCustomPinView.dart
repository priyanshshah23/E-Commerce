library flutter_lock_screen;

import 'dart:async';
import 'dart:io';
import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/BaseDialog.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:flutter/material.dart';

typedef void DeleteCode();
typedef Future<bool> PassCodeVerify(List<int> passcode);

class FlutterCustomPinView extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback fingerFunction;
  final bool fingerVerify;
  final String title;
  final int passLength;
  final bool showWrongPassDialog;
  final bool showFingerPass;
  final String wrongPassTitle;
  final String wrongPassContent;
  final String wrongPassCancelButtonText;
  final String bgImage;
  final Color numColor;
  final String fingerPrintImage;
  final Color borderColor;
  final Color foregroundColor;
  final PassCodeVerify passCodeVerify;

  FlutterCustomPinView({
    this.onSuccess,
    this.title,
    this.borderColor,
    this.foregroundColor = Colors.transparent,
    this.passLength,
    this.passCodeVerify,
    this.fingerFunction,
    this.fingerVerify = false,
    this.showFingerPass = false,
    this.bgImage,
    this.numColor = Colors.black,
    this.fingerPrintImage,
    this.showWrongPassDialog = false,
    this.wrongPassTitle,
    this.wrongPassContent,
    this.wrongPassCancelButtonText,
  })  : assert(title != null),
        assert(passLength <= 8),
        assert(bgImage != null),
        assert(borderColor != null),
        assert(foregroundColor != null),
        assert(passCodeVerify != null),
        assert(onSuccess != null);

  @override
  _FlutterCustomPinViewState createState() => _FlutterCustomPinViewState();
}

class _FlutterCustomPinViewState extends State<FlutterCustomPinView> {
  var _currentCodeLength = 0;
  var _inputCodes = <int>[];
  var _currentState = 0;
  Color circleColor = Colors.white;

  _onCodeClick(int code) {
    if (_currentCodeLength < widget.passLength) {
      setState(() {
        _currentCodeLength++;
        _inputCodes.add(code);
      });

      if (_currentCodeLength == widget.passLength) {
        widget.passCodeVerify(_inputCodes).then((onValue) {
          if (onValue) {
            setState(() {
              _currentState = 1;
            });
            widget.onSuccess();
          } else {
            _currentState = 2;
            new Timer(new Duration(milliseconds: 1000), () {
              setState(() {
                _currentState = 0;
                _currentCodeLength = 0;
                _inputCodes.clear();
              });
            });
            if (widget.showWrongPassDialog) {
              app.resolve<CustomDialogs>().confirmDialog(
                    context,
                    barrierDismissible: true,
                    title: "Oops!",
                    desc: widget.wrongPassContent,
                    positiveBtnTitle: R.string().commonString.ok,
                    // negativeBtnTitle: R.string().commonString.cancel,
                    onClickCallback: (buttonType) {},
                  );
            }
          }
        });
      }
    }
  }

  _fingerPrint() {
    if (widget.fingerVerify) {
      widget.onSuccess();
    }
  }

  _deleteCode() {
    setState(() {
      if (_currentCodeLength > 0) {
        _currentState = 0;
        _currentCodeLength--;
        _inputCodes.removeAt(_currentCodeLength);
      }
    });
  }

  _deleteAllCode() {
    setState(() {
      if (_currentCodeLength > 0) {
        _currentState = 0;
        _currentCodeLength = 0;
        _inputCodes.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 200), () {
      _fingerPrint();
    });
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CodePanel(
                      codeLength: widget.passLength,
                      currentLength: _currentCodeLength,
                      borderColor: widget.borderColor,
                      foregroundColor: widget.foregroundColor,
                      deleteCode: _deleteCode,
                      fingerVerify: widget.fingerVerify,
                      status: _currentState,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getSize(40),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 0, top: 0),
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                      return null;
                    },
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 2.3,
                      mainAxisSpacing: 35,
                      padding: EdgeInsets.all(4),
                      children: <Widget>[
                        buildContainerCircle(1),
                        buildContainerCircle(2),
                        buildContainerCircle(3),
                        buildContainerCircle(4),
                        buildContainerCircle(5),
                        buildContainerCircle(6),
                        buildContainerCircle(7),
                        buildContainerCircle(8),
                        buildContainerCircle(9),
                        buildRemoveIcon(Icons.close),
                        buildContainerCircle(0),
                        buildContainerIcon(Icons.arrow_back),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainerCircle(int number) {
    return InkResponse(
      highlightColor: appTheme.greenColor,
      onTap: () {
        FocusScope.of(context).unfocus();
        _onCodeClick(number);
      },
      child: Container(
        height: getSize(50),
        width: getSize(50),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: appTheme.greenColor.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: Offset(0.0, 6.0))
            ]),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: widget.numColor),
          ),
        ),
      ),
    );
  }

  Widget buildRemoveIcon(IconData icon) {
    return InkResponse(
      onTap: () {
        if (0 < _currentCodeLength) {
          _deleteAllCode();
        }
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: appTheme.greenColor.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: Offset(0.0, 6.0))
            ]),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: widget.numColor,
          ),
        ),
      ),
    );
  }

  Widget buildContainerIcon(IconData icon) {
    return InkResponse(
      onTap: () {
        if (0 < _currentCodeLength) {
          setState(() {
            circleColor = Colors.grey.shade300;
          });
          Future.delayed(Duration(milliseconds: 200)).then((func) {
            setState(() {
              circleColor = Colors.white;
            });
          });
        }
        _deleteCode();
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: appTheme.greenColor.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: Offset(0.0, 6.0))
            ]),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: widget.numColor,
          ),
        ),
      ),
    );
  }
}

class CodePanel extends StatelessWidget {
  final codeLength;
  final currentLength;
  final borderColor;
  final bool fingerVerify;
  final foregroundColor;
  final H = 20.0;
  final W = 20.0;
  final DeleteCode deleteCode;
  final int status;
  CodePanel(
      {this.codeLength,
      this.currentLength,
      this.borderColor,
      this.foregroundColor,
      this.deleteCode,
      this.fingerVerify,
      this.status})
      : assert(codeLength > 0),
        assert(currentLength >= 0),
        assert(currentLength <= codeLength),
        assert(deleteCode != null),
        assert(status == 0 || status == 1 || status == 2);

  @override
  Widget build(BuildContext context) {
    var circles = <Widget>[];
    var color = borderColor;
    int circlePice = 1;

    if (fingerVerify == true) {
      do {
        circles.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getSize(4)),
            child: SizedBox(
              width: W,
              height: H,
              child: new Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(color: color, width: 1.0),
                  color: Colors.green.shade500,
                ),
              ),
            ),
          ),
        );
        circlePice++;
      } while (circlePice <= codeLength);
    } else {
      if (status == 1) {
        color = Colors.green.shade500;
      }
      if (status == 2) {
        color = Colors.red.shade500;
      }
      for (int i = 1; i <= codeLength; i++) {
        if (i > currentLength) {
          circles.add(
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getSize(4)),
              child: SizedBox(
                width: W,
                height: H,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 1.0),
                      color: appTheme.textGreyColor),
                ),
              ),
            ),
          );
        } else {
          circles.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: getSize(4)),
            child: SizedBox(
              width: W,
              height: H,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 1.0),
                  color: appTheme.greenColor,
                ),
              ),
            ),
          ));
        }
      }
    }

    return new SizedBox.fromSize(
      //  size: new Size(MediaQuery.of(context).size.width, 30.0),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox.fromSize(
                // size: new Size(40.0 * codeLength, H),
                child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: circles,
            )),
          ]),
    );
  }
}

class BgClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height / 1.5);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
