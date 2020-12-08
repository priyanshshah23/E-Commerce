import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordResetSuccessfully extends StatefulWidget {
  static const route = "PasswordResetSuccessfully";

  @override
  _PasswordResetSuccessfullyState createState() => _PasswordResetSuccessfullyState();
}

class _PasswordResetSuccessfullyState extends State<PasswordResetSuccessfully> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(
          LoginScreen.route,
              (Route<dynamic> route) => false,
        );
        return null;
      },
      child: Scaffold(
        bottomNavigationBar:  Padding(
          padding: EdgeInsets.only(left: getSize(20), right: getSize(20), bottom: getSize(30)),
          child: Container(
            margin: EdgeInsets.only(
                top: getSize(15), left: getSize(0)),
            decoration: BoxDecoration(
                boxShadow: getBoxShadow(context)),
            child: AppButton.flat(
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(
                  LoginScreen.route,
                      (Route<dynamic> route) => false,
                );
              },
              //  backgroundColor: appTheme.buttonColor,
              borderRadius: getSize(5),
              fitWidth: true,
              text: R.string.authStrings.backToSignIn,
              //isButtonEnabled: enableDisableSigninButton(),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: getSize(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    right: getSize(132),
                    left: getSize(132),
                    bottom: getSize(19),),
                child: Image.asset(
                  passwordResetSuccessfully,
                  height: getSize(150),
                  width: getSize(150),
                ),
              ),
              Text(
                R.string.authStrings.passwordResetSuccessfully,
                style: appTheme.blackMedium20TitleColorblack,
                textAlign: TextAlign.center,
              ),
            ],
          )
        ),
      ),
    );
  }

}
