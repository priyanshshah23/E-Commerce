import 'package:diamnow/app/app.export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_redirect/store_redirect.dart';

class VersionUpdate extends StatefulWidget {
  static const route = "VersionUpdate";
  bool isHardUpdate;
  VoidCallback oncomplete;

  VersionUpdate(Map<String, dynamic> arguments) {
    this.isHardUpdate = arguments['isHardUpdate'] ?? false;
    this.oncomplete = arguments['oncomplete'];
  }

  @override
  _VersionUpdateState createState() => _VersionUpdateState();
}

class _VersionUpdateState extends State<VersionUpdate> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init");
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: AppTheme.of(context).theme.primaryColor,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MathUtilities.screenHeight(context),
                  width: MathUtilities.screenWidth(context),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getSize(160)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: getSize(210),
                        height: getSize(210),
                        child: Image.asset(
                          splashLogo,
                        ),
                      ),
                    ],
                  ),
                ),
                getBottomView(),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: getBottomNavigationBar(),
      ),
    );
  }

  getBottomView() {
    return Positioned(
      bottom: getSize(16),
      right: getSize(16),
      left: getSize(16),
      child: Padding(
        padding: EdgeInsets.all(getSize(16)),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(getSize(16)),
              child: Text(
                "Application Update",
                style: AppTheme.of(context)
                    .theme
                    .primaryTextTheme
                    .bodyText1
                    .copyWith(
                      fontSize: getSize(28),
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(getSize(16)),
              child: Text(
                "A new version of application is available",
                textAlign: TextAlign.center,
                style: AppTheme.of(context)
                    .theme
                    .primaryTextTheme
                    .subtitle1
                    .copyWith(
                      color: AppTheme.of(context).theme.disabledColor,
                      fontSize: getSize(20),
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: getSize(16),
                bottom: getSize(30),
              ),
              child: AppButton.flat(
                onTap: () {
                  StoreRedirect.redirect(
                    androidAppId: "com.fly.scooter",
                    iOSAppId: "1516454400",
                  );
                },
                borderRadius: 14,
                fitWidth: true,
                text: "Update",
              ),
            ),
//            widget.isHardUpdate == false
//                ? Padding(
//                    padding: EdgeInsets.only(top: getSize(16)),
//                    child: AppButton.flat(
//                      onTap: () {
//                        widget.oncomplete();
//                      },
//                      borderRadius: 14,
//                      fitWidth: true,
//                      text: R.string().commonString.btnSkip,
//                    ),
//                  )
//                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
