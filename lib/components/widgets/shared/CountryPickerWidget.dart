import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:flutter/material.dart';

import '../../../app/constant/ColorConstant.dart';
import '../../../app/utils/math_utils.dart';
import '../../../app/utils/math_utils.dart';

typedef OnSelectCountry(Country country);

class CountryPickerWidget extends StatefulWidget {
  Country selectedDialogCountry;
  bool isEnabled = true;
  final OnSelectCountry onSelectCountry;

  CountryPickerWidget({
    this.onSelectCountry,
    this.selectedDialogCountry,
    this.isEnabled = true,
  });

  @override
  _CountryPickerWidgetState createState() => _CountryPickerWidgetState();
}

class _CountryPickerWidgetState extends State<CountryPickerWidget> {
  Country _selectedDialogCountry;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDialogCountry != null) {
      _selectedDialogCountry = widget.selectedDialogCountry;
    } else {
      _selectedDialogCountry = CountryPickerUtils.getCountryByPhoneCode('1');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedDialogCountry != null) {
      _selectedDialogCountry = widget.selectedDialogCountry;
    }
    return getTextFieldPrefix();
  }

  getTextFieldPrefix() {
    return InkWell(
      onTap: () async {
        if (widget.isEnabled) {
          _openCountryPickerDialog();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: getSize(0)),
        child: Container(
          //  color: ColorConstants.fromHex("#F5F7FB"),
          child: Padding(
            padding: EdgeInsets.only(left: getSize(10), bottom: getSize(2)),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                CountryPickerUtils.getDefaultFlagImage(_selectedDialogCountry),
                Padding(
                  padding: EdgeInsets.only(left: getSize(8)),
                ),
                Text(
                  "+${_selectedDialogCountry.phoneCode}",
                  style: appTheme.black16TextStyle,
                ),
                Container(
                  margin: EdgeInsets.only(left: getSize(5)),
                  height: getSize(20),
                  width: getSize(2),
                  color: appTheme.dividerColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: AppTheme.of(context)
                .theme
                .copyWith(primaryColor: AppTheme.of(context).errorColor),
            child: CountryPickerDialog(
              titlePadding: EdgeInsets.all(6.0),
              searchCursorColor: AppTheme.of(context).theme.accentColor,
              searchInputDecoration: InputDecoration(
                hintText: R.string.authStrings.searchHint,
              ),
              isSearchable: true,
              title: Text(R.string.authStrings.selectYourCountry,
                  style: AppTheme.of(context).theme.textTheme.subhead),
              onValuePicked: (Country country) {
                setState(() {
                  widget.onSelectCountry(country);
                  _selectedDialogCountry = country;
                });
              },
              // onValuePicked: (Country country) => setState(
              //   () => _selectedDialogCountry = country,
              //   onSelectCountry(_selectedDialogCountry),
              // ),
              itemBuilder: _buildDialogItem,
            )),
      );

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text(
            "+${country.phoneCode}",
            style: AppTheme.of(context).theme.textTheme.display1,
          ),
          SizedBox(width: 10.0),
          Flexible(
              child: Text(country.name,
                  style: AppTheme.of(context)
                      .theme
                      .textTheme
                      .display1
                      .copyWith(fontWeight: FontWeight.w300)))
        ],
      );
}
