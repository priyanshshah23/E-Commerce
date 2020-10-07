import 'package:flutter/material.dart';

import '../app.export.dart';

class View {
  static final FlushbarService flushbarService = app.resolve<FlushbarService>();

  static void hideKeyboard(context) {
    FocusScope.of(context).unfocus();
  }

  static void showKeyboard(context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  static void showMessage(BuildContext context, String message,
      {String title = "Alert!",
      DisplayType type = DisplayType.SNACKBAR,
      DisplayMode mode = DisplayMode.SUCCESS,
      List<DialogAction> actions}) {
    switch (type) {
      case DisplayType.ALERT:
        showDialog(
            context: context,
            builder: (context) {
              return CustomMessageDialog(
                  title: title, message: message, mode: mode, actions: actions);
            });
        break;
      case DisplayType.SNACKBAR:
        flushbarService.show(message: message, type: getFromType(mode));
        break;
      case DisplayType.BOTTOM_SHEET:
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          builder: (context) => BottomSheetWidget(
              title: title, message: message, mode: mode, actions: actions),
        );
        break;
    }
  }

  static FlushbarType getFromType(DisplayMode mode) {
    switch (mode) {
      case DisplayMode.SUCCESS:
        return FlushbarType.error;
        break;
      case DisplayMode.ERROR:
        return FlushbarType.error;
        break;
      case DisplayMode.INFO:
        return FlushbarType.info;
        break;
      case DisplayMode.WARNING:
        return FlushbarType.warning;
        break;
    }
  }
}

/// Builds a [CustomDialog] to inform about a feature being only available for
/// the pro version of app.
class CustomMessageDialog extends StatefulWidget {
  const CustomMessageDialog({
    @required this.title,
    @required this.message,
    this.mode,
    this.actions,
  });

  /// The name of the feature.
  final String title;
  final String message;
  final DisplayMode mode;
  final List<DialogAction> actions;

  @override
  _CustomMessageDialogState createState() => _CustomMessageDialogState();
}

class _CustomMessageDialogState extends State<CustomMessageDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: widget.title,
      body: Column(
        children: <Widget>[
          Text(
            widget.message,
          ),
          const SizedBox(height: 12),
        ],
      ),
      actions: widget.actions,
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({
    @required this.title,
    @required this.message,
    this.mode,
    this.actions,
  });

  /// The name of the feature.
  final String title;
  final String message;
  final DisplayMode mode;
  final List<DialogAction> actions;

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final ScrollPhysics scrollPhysics = const NeverScrollableScrollPhysics();

  List<Widget> _buildContent(TextTheme textTheme) {
    return <Widget>[
      if (widget.title != null) ...[
        Text(widget.title, style: textTheme.title, textAlign: TextAlign.center),
        const SizedBox(height: 12),
      ],
      if (widget.message != null) ...[
        Text(widget.message,
            style: textTheme.subtitle, textAlign: TextAlign.center),
        const SizedBox(height: 12),
      ],
      const SizedBox(height: 12),
    ];
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(widget.title),
              )
            ],
          ),
          Container(
            width: double.infinity,
            // less on the bottom to compensate for the button padding
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    physics: scrollPhysics,
                    children: _buildContent(textTheme),
                  ),
                ),
                _buildActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum DisplayType { ALERT, SNACKBAR, BOTTOM_SHEET }

enum DisplayMode { SUCCESS, ERROR, INFO, WARNING }
