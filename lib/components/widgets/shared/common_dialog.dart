import 'package:flutter/material.dart';

import '../../../app/constant/ColorConstant.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/utils/math_utils.dart';
import 'buttons.dart';

Future _showLogInDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(getSize(8)))),
          title: Text(
            "Log In Error",
            textAlign: TextAlign.center,
            style: AppTheme.of(context).theme.textTheme.body1.copyWith(
                fontWeight: FontWeight.w500,
                color: colorConstants.colorPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: getSize(15),
              ),
              Text(
                "Email/mobile and password isn't matching.",
                textAlign: TextAlign.center,
                style: AppTheme.of(context)
                    .theme
                    .textTheme
                    .body2
                    .copyWith(color: ColorConstants.textGray),
              ),
              // SizedBox(height: getSize(20),),
              Container(
                margin: EdgeInsets.only(top: getSize(30)),
                child: AppButton.flat(
                  onTap: () {},
                  borderRadius: 14,
                  fitWidth: true,
                  text: "Try Again",
                  //isButtonEnabled: enableDisableSigninButton(),
                ),
              ),
            ],
          ),
        );
      });
}
