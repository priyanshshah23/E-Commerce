import 'dart:collection';

import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceSearch extends StatefulScreenWidget {
  static const route = "VoiceSearch";

  VoiceSearch({Key key}) : super(key: key);
  @override
  _VoiceSearchState createState() => _VoiceSearchState();
}

class _VoiceSearchState extends StatefulScreenWidgetState {
  SpeechToText speech = SpeechToText();
  bool isSpeechToTextEnabled;
  bool isMicTapped = false;
  var strText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      speech
          .initialize(
              onStatus: statusListener,
              onError: errorListener,
              debugLogging: true)
          .then((value) {
        setState(() {
          isSpeechToTextEnabled = value;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      bottomNavigationBar: getBottomButton(),
      appBar: getAppBar(context, R.string.screenTitle.voiceSearch,
          leadingButton: IconButton(
            padding: EdgeInsets.all(3),
            onPressed: () {
              speech.stop();
              Navigator.of(context).pop();
            },
            icon: Image.asset(
              back,
              color: appTheme.textBlackColor,
              width: getSize(22),
              height: getSize(22),
            ),
          ),
          centerTitle: false),
      body: Padding(
        padding: EdgeInsets.only(
          left: getSize(Spacing.leftPadding),
          right: getSize(Spacing.rightPadding),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isMicTapped && speech.isListening
                  ? Container(
                      alignment: Alignment.center,
                      width: getSize(100),
                      height: getSize(100),
                      child: Lottie.asset(
                        'assets/Json/microphoneLottie.json',
                        fit: BoxFit.fill,
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        if (isSpeechToTextEnabled != null &&
                            isSpeechToTextEnabled == true) {
                          setState(() {
                            strText = "";
                            speech.listen(
                                onResult: resultListener,
                                listenFor: Duration(seconds: 10),
                                cancelOnError: true,
                                partialResults: true);
                            isMicTapped = true;
                          });
                        }
                      },
                      child: Image.asset(
                        microphone,
                        width: getSize(100),
                        height: getSize(100),
                        fit: BoxFit.fill,
                      ),
                    ),
              isSpeechToTextEnabled != null
                  ? Padding(
                      padding: EdgeInsets.all(getSize(50)),
                      child: isSpeechToTextEnabled == false
                          ? Text(
                              "Permission Denied! Please enable microphone and speech recogniser permissions.",
                              textAlign: TextAlign.center,
                              style: appTheme.primary16TextStyle,
                            )
                          : Text(
                              isMicTapped && speech.isListening
                                  ? "I am listening..."
                                  : R.string.screenTitle.tapMictoSpeak,
                              textAlign: TextAlign.center,
                              style: appTheme.primary16TextStyle.copyWith(
                                fontSize: getFontSize(28),
                              ),
                            ),
                    )
                  : SizedBox(),
              isNullEmptyOrFalse(strText)
                  ? SizedBox()
                  : Text(
                      strText,
                      textAlign: TextAlign.center,
                      style: appTheme.black16TextStyle.copyWith(
                        fontSize: getFontSize(28),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      strText = result.recognizedWords;
    });
  }

  getBottomButton() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(getSize(16)),
        child: AppButton.flat(
          onTap: () {
            callCountApi();
          },
          borderRadius: getSize(5),
          fitWidth: true,
          text: R.string.commonString.search,
          isButtonEnabled: !isNullEmptyOrFalse(strText),
        ),
      ),
    );
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      print('${error.errorMsg} - ${error.permanent}');
    });
  }

  void statusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      print('$status');
    });
  }

  callCountApi() {
    SyncManager.instance.callApiForDiamondList(
      context,
      {},
      (diamondListResp) {
        Map<String, dynamic> dict = new HashMap();

        dict["filterId"] = diamondListResp.data.filter.id;

        dict[ArgumentConstant.ModuleType] =
            DiamondModuleConstant.MODULE_TYPE_SEARCH;
        NavigationUtilities.pushRoute(DiamondListScreen.route, args: dict);
      },
      (onError) {
        //print("Error");
      },
      searchText: strText,
    );
  }
}
