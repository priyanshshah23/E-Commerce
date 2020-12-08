import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/BottomSheet.dart';

enum ButtonType { PositveButtonClick, PositveButtonClick2, NagativeButtonClick }

typedef OnClickCallback(ButtonType type);

typedef OnDateClickCallback(ButtonType type, String fromDate, String toDate);

class CommonAlertDialog extends StatefulWidget {
  final OnClickCallback onClickCallback;
  final String title;
  final String message;
  final String positiveBtnText;
  final String nagativeBtnText;

  CommonAlertDialog({
    Key key,
    this.title,
    this.message,
    this.positiveBtnText,
    this.nagativeBtnText,
    this.onClickCallback,
  }) : super(key: key);

  @override
  _CommonAlertDialogState createState() => _CommonAlertDialogState();
}

class _CommonAlertDialogState extends State<CommonAlertDialog>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _dialogContent(context),
    );
  }

  _dialogContent(BuildContext context) {
    List<Widget> contents = [];

    if (widget.title != null) {
      contents.add(getTitle());
    }

    if (widget.message != null) {
      contents.add(getDescription());
    }

    contents.add(
      Container(
        height: 1,
        color: appTheme.dividerColor,
      ),
    );

    if (widget.nagativeBtnText != null) {
      contents.add(
        Padding(
          padding:
              EdgeInsets.only(top: getSize(5), right: 0, bottom: 0, left: 0),
          child: Row(
            children: <Widget>[
              Container(
                width: (MathUtilities.screenWidth(context) / 2) - 10,
                child: GestureDetector(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: getSize(10), bottom: getSize(10)),
                    child: Text(
                      widget.nagativeBtnText ?? "No",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontSize: getFontSize(16),
                            // color: AppTheme.of(context)
                            // .backgroundComplimentaryColor
                          ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.onClickCallback != null) {
                      widget.onClickCallback(ButtonType.NagativeButtonClick);
                    }
                  },
                ),
              ),
              Container(
                width: (MathUtilities.screenWidth(context) / 2) - 10,
                child: GestureDetector(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: getSize(10), bottom: getSize(10)),
                    child: Text(widget.positiveBtnText ?? "Yes",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title.copyWith(
                            fontSize: getFontSize(16),
                            color: appTheme.colorPrimary)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.onClickCallback != null) {
                      widget.onClickCallback(ButtonType.PositveButtonClick);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      contents.add(
        Padding(
          padding:
              EdgeInsets.only(top: getSize(5), right: 0, bottom: 0, left: 0),
          child: Container(
            width: MathUtilities.screenWidth(context),
            child: GestureDetector(
              child: Padding(
                padding: EdgeInsets.all(getSize(10)),
                child: Text(
                  widget.positiveBtnText ?? "Yes",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title.copyWith(
                      fontSize: getFontSize(16),
                      color: appTheme.colorPrimary),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                if (widget.onClickCallback != null) {
                  widget.onClickCallback(ButtonType.PositveButtonClick);
                }
              },
            ),
          ),
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: appTheme.colorPrimary,
            shape: BoxShape.rectangle,
            boxShadow: getBoxShadow(context),
          ),
          width: MathUtilities.screenWidth(context),
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: contents,
            ),
          ),
        ),
      ],
    );
  }

  Widget getTitle() {
    return Padding(
      padding: EdgeInsets.only(top: getSize(10), bottom: getSize(20)),
      child: Text(widget.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1.copyWith(
                fontSize: getFontSize(20),
                // color: AppTheme.of(context).backgroundComplimentaryColor
              )),
    );
  }

  Widget getDescription() {
    return Padding(
      padding: EdgeInsets.only(
          top: getSize(20),
          right: getSize(10),
          bottom: getSize(20),
          left: getSize(10)),
      child: Text(
        widget.message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.body2.copyWith(
              fontSize: getFontSize(18),
              // color: AppTheme.of(context).backgroundComplimentaryColor
            ),
      ),
    );
  }
}

class CustomAlertDialog extends StatefulWidget {
  final List<DialogAction> actions;

  final String message;

  CustomAlertDialog({
    Key key,
    this.message,
    this.actions,
  }) : super(key: key);

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _dialogContent(context),
    );
  }

  _dialogContent(BuildContext context) {
    List<Widget> contents = [];

    if (widget.message != null) {
      contents.add(getDescription());
    }

    contents.add(
      Container(
        height: 1,
        color: appTheme.dividerColor,
      ),
    );

    contents.add(_buildActions());

    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: appTheme.colorPrimary,
            shape: BoxShape.rectangle,
            boxShadow: getBoxShadow(context),
          ),
          width: MathUtilities.screenWidth(context),
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: contents,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    if (widget.actions.length > 1) {
      return SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          children: widget.actions,
        ),
      );
    } else if (widget.actions.length == 1) {
      return widget.actions.first;
    } else {
      return Container();
    }
  }

  Widget getDescription() {
    return Padding(
      padding: EdgeInsets.only(
          top: getSize(20),
          right: getSize(10),
          bottom: getSize(20),
          left: getSize(10)),
      child: Text(
        widget.message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.body2.copyWith(
              fontSize: getFontSize(18),
              // color: AppTheme.of(context).backgroundComplimentaryColor
            ),
      ),
    );
  }
}


