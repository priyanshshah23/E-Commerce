import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SaveAndSearchBottomSheet extends StatefulWidget {
  Function(String) callBack;

  SaveAndSearchBottomSheet({this.callBack});

  @override
  _SaveAndSearchBottomSheetState createState() =>
      _SaveAndSearchBottomSheetState();
}

class _SaveAndSearchBottomSheetState extends State<SaveAndSearchBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: getSize(20)),
            child: Text(
              "Save & Search",
              style: appTheme.black16TextStyle,
            ),
          ),
          SizedBox(
            height: getSize(20),
          ),
          Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getFieldTitleText(R.string().screenTitle.searchTitle),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                  child: CommonTextfield(
                    autoFocus: false,
                    textOption: TextFieldOption(
                      inputController: _titleController,
                      hintText: R.string().screenTitle.enterSearchTitle,
                      formatter: [
                        //WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
                        BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
                      ],
                      //isSecureTextField: false
                    ),
                    textCallback: (text) {},
                    validation: (text) {
                      if (text.isEmpty) {
                        return "Please enter search title";
                      }
                    },
                    inputAction: TextInputAction.done,
                    onNextPress: () {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: getSize(10), left: getSize(26), bottom: getSize(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    textColor: appTheme.colorPrimary,
                    padding: EdgeInsets.all(getSize(0)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      R.string().commonString.cancel,
                      style: appTheme.black16TextStyle,
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    textColor: appTheme.colorPrimary,
                    padding: EdgeInsets.all(getSize(0)),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        widget.callBack(_titleController.text.trim());
                      } else {
                        setState(() {
                          _autoValidate = true;
                        });
                      }
                    },
                    child: Text(
                      R.string().commonString.btnSubmit,
                      style: appTheme.primary16TextStyle,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
