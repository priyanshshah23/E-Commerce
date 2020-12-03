import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/models/SavedSearch/SavedSearchModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SaveAndSearchBottomSheet extends StatefulWidget {
  Function(String, bool) callBack;
  SavedSearchModel savedSearchModel;

  SaveAndSearchBottomSheet({this.callBack, this.savedSearchModel});

  @override
  _SaveAndSearchBottomSheetState createState() =>
      _SaveAndSearchBottomSheetState();
}

class _SaveAndSearchBottomSheetState extends State<SaveAndSearchBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool isNewSearch = false;

  @override
  void initState() {
    super.initState();
    if (!isNullEmptyOrFalse(widget.savedSearchModel)) {
      _titleController.text = widget.savedSearchModel.name ?? "-";
    }
  }

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
              R.string().screenTitle.savedAndSearch,
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
                SizedBox(height: getSize(8)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getSize(16)),
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
                !isNullEmptyOrFalse(widget.savedSearchModel)
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: getSize(16),
                            bottom: getSize(16),
                            left: getSize(16)),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isNewSearch = !isNewSearch;
                              if (isNewSearch) {
                                _titleController.text = "";
                              } else {
                                _titleController.text =
                                    widget.savedSearchModel.name ?? "-";
                              }
                            });
                          },
                          child: Row(children: [
                            Image.asset(
                              isNewSearch
                                  ? selectedCheckbox
                                  : unSelectedCheckbox,
                              width: getSize(16),
                              height: getSize(16),
                            ),
                            SizedBox(width: getSize(8)),
                            Text("New Search",
                                style: appTheme.black14TextStyle),
                          ]),
                        ))
                    : Container(),
              ],
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
                      if (_formKey.currentState.validate()) {
                        widget.callBack(
                            _titleController.text.trim(), isNewSearch);
                      } else {
                        setState(() {
                          _autoValidate = true;
                        });
                      }
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
}
