import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/theme/app_theme.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchScreen extends StatefulScreenWidget {
  static const route = "SearchScreen";
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends StatefulScreenWidgetState {
  final TextEditingController _searchController = TextEditingController();
  var _focusSearch = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appTheme.whiteColor,
        appBar: getAppBar(
          context,
          R.string().screenTitle.search,
          bgColor: appTheme.whiteColor,
          leadingButton: getBackButton(context),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              getSarchTextField(),
            ],
          ),
        ));
  }

  getSarchTextField() {
    return Hero(
      tag: 'searchTextField',
      child: Material(
        child: Padding(
          padding: EdgeInsets.only(
            left: getSize(Spacing.leftPadding),
            right: getSize(Spacing.rightPadding),
          ),
          child: Container(
            height: getSize(40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(getSize(5)),
              border:
                  Border.all(color: appTheme.colorPrimary, width: getSize(1)),
            ),
            child: TextField(
              textAlignVertical: TextAlignVertical(y: 1.0),
              textInputAction: TextInputAction.done,
              focusNode: _focusSearch,
              autofocus: false,
              controller: _searchController,
              obscureText: false,
              style: appTheme.black16TextStyle,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
              cursorColor: appTheme.colorPrimary,
              inputFormatters: [
                WhitelistingTextInputFormatter(new RegExp(alphaRegEx)),
                BlacklistingTextInputFormatter(RegExp(RegexForEmoji))
              ],
              decoration: InputDecoration(
                fillColor: fromHex("#FFEFEF"),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(getSize(5))),
                  borderSide: BorderSide(
                      color: appTheme.dividerColor, width: getSize(1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(getSize(5))),
                  borderSide: BorderSide(
                      color: appTheme.dividerColor, width: getSize(1)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(getSize(5))),
                  borderSide: BorderSide(
                      color: appTheme.dividerColor, width: getSize(1)),
                ),

                hintStyle: appTheme.grey16HintTextStyle,
                hintText: "Search",
                labelStyle: TextStyle(
                  color: appTheme.textColor,
                  fontSize: getFontSize(16),
                ),
                // suffix: widget.textOption.postfixWidOnFocus,
                suffixIcon: Padding(
                    padding: EdgeInsets.all(getSize(10)),
                    child: Image.asset(search)),
              ),
              // onFieldSubmitted: (String text) {
              //   //
              // },
              onChanged: (String text) {
                //
              },
              onEditingComplete: () {},
            ),
          ),
        ),
      ),
    );
  }
}
