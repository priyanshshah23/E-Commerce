import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
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
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [fromHex("#DED9F2"), fromHex("#F5F4FC")])),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getSize(160)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: getSize(125),
                        height: getSize(125),
                        child: Image.asset(
                          splashLogo,
                          width: getSize(125),
                          height: getSize(125),
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
              child: Text(R.string().commonString.applicationUpdate,
                  style: AppTheme.of(context)
                      .theme
                      .primaryTextTheme
                      .bodyText1
                      .copyWith(
                    fontSize: getSize(28),
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(getSize(16)),
              child: Text(
                R.string().commonString.newVersionMessage,
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
              padding: EdgeInsets.only(top: getSize(16)),
              child: AppButton.flat(
                onTap: () {
                  StoreRedirect.redirect(
                      androidAppId: "com.threeeco.driver",
                      iOSAppId: "1516454400");
                },
                borderRadius: 14,
                fitWidth: true,
                text: R.string().commonString.btnUpdate,
              ),
            ),
            widget.isHardUpdate
                ? Padding(
              padding: EdgeInsets.only(top: getSize(16)),
              child: AppButton.flat(
                onTap: () {
                  widget.oncomplete();
                },
                borderRadius: 14,
                fitWidth: true,
                text: R.string().commonString.btnSkip,
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
