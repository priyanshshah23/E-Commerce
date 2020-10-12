import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/CustomDialog.dart';
import 'package:diamnow/components/Screens/Auth/Login.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatefulWidget {
  static const route = "DemoScreen";

  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  num maxValue;
  num minValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: getSize(20),
            ),
            // SearchComponent(
            //   title: "amount",
            //   min: 00,
            //   max: 300,
            //   setValue: changeValuesOfMinMax,
            // ),
            // SearchComponent(
            //   title: "data",
            //   min: -10,
            //   max: 300.50,
            //   setValue: changeValuesOfMinMax,
            // ),
            SizedBox(
              height: getSize(20),
            ),
            Container(
              margin: EdgeInsets.only(
                  right: getSize(20), left: getSize(20), top: getSize(30)),
              child: AppButton.flat(
                onTap: () {
                  if (maxValue != null && minValue != null) {
                    if (maxValue < minValue) {
                      app.resolve<CustomDialogs>().confirmDialog(
                            context,
                            title: "Value Error",
                            desc:
                                "Max Value should be grater than or equal to min value",
                            positiveBtnTitle: "Try Again",
                          );
                    } else {
                      NavigationUtilities.pushRoute(LoginScreen.route);
                    }
                  }
                },
                textColor: appTheme.colorPrimary,
                backgroundColor: appTheme.colorPrimary.withOpacity(0.1),
                borderRadius: 14,
                fitWidth: true,
                text: "Search",
                //isButtonEnabled: enableDisableSigninButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  changeValuesOfMinMax(num min, num max) {
    minValue = min;
    maxValue = max;
    setState(() {});
  }
}
