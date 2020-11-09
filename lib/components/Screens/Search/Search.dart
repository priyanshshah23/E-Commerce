import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/theme/app_theme.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/Master/Master.dart';
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
  var arrSuggestion = List<String>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      FocusScope.of(context).requestFocus(_focusSearch);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
          )),
    );
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
              textCapitalization: TextCapitalization.characters,
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

  prepareDataSource() async {
    //Shape
    var shapes = await Master.getSubMaster(MasterCode.shape);
    if (!isNullEmptyOrFalse(shapes)) {
      appendData(getNameWithLikeKeyword(shapes, false));
    }

    //Size master
    var sizemaster = await Master.getSizeMaster();
    if (!isNullEmptyOrFalse(sizemaster)) {
      appendData(sizemaster.map((e) => e.group ?? "").toList());
    }

    //Color
    var color = await Master.getSubMaster(MasterCode.color);
    if (!isNullEmptyOrFalse(color)) {
      appendData(getNameWithLikeKeyword(color, false));
    }

    //intensity
    var intensity = await Master.getSubMaster(MasterCode.intensity);
    if (!isNullEmptyOrFalse(intensity)) {
      appendData(getNameWithLikeKeyword(intensity, false));
    }

    //overTone
    var overTone = await Master.getSubMaster(MasterCode.overTone);
    if (!isNullEmptyOrFalse(intensity)) {
      appendData(getNameWithLikeKeyword(overTone, false));
    }

    //clarity
    var clarity = await Master.getSubMaster(MasterCode.clarity);
    if (!isNullEmptyOrFalse(clarity)) {
      appendData(getNameWithLikeKeyword(clarity, false));
    }

    //colorShade
    var colorShade = await Master.getSubMaster(MasterCode.colorShade);
    if (!isNullEmptyOrFalse(colorShade)) {
      appendData(getNameWithLikeKeyword(colorShade, false));
    }

    //cut
    var cut = await Master.getSubMaster(MasterCode.cut);
    if (!isNullEmptyOrFalse(cut)) {
      appendData(getNameWithLikeKeyword(cut, false));
    }

    //polish
    var polish = await Master.getSubMaster(MasterCode.polish);
    if (!isNullEmptyOrFalse(polish)) {
      appendData(getNameWithLikeKeyword(polish, false));
    }

    //symmetry
    var symmetry = await Master.getSubMaster(MasterCode.symmetry);
    if (!isNullEmptyOrFalse(symmetry)) {
      appendData(getNameWithLikeKeyword(symmetry, false));
    }

    //fluorescence
    var fluorescence = await Master.getSubMaster(MasterCode.fluorescence);
    if (!isNullEmptyOrFalse(fluorescence)) {
      appendData(getNameWithLikeKeyword(fluorescence, false));
    }

    //lab
    var lab = await Master.getSubMaster(MasterCode.lab);
    if (!isNullEmptyOrFalse(lab)) {
      appendData(getNameWithLikeKeyword(lab, false));
    }

    //location
    var location = await Master.getSubMaster(MasterCode.location);
    if (!isNullEmptyOrFalse(location)) {
      appendData(getNameWithLikeKeyword(location, false));
    }

    //blackTable
    var blackTable = await Master.getSubMaster(MasterCode.blackTable);
    if (!isNullEmptyOrFalse(blackTable)) {
      appendData(getNameWithLikeKeyword(blackTable, false));
    }

    //blackCrown
    var blackCrown = await Master.getSubMaster(MasterCode.blackCrown);
    if (!isNullEmptyOrFalse(blackCrown)) {
      appendData(getNameWithLikeKeyword(blackCrown, false));
    }

    //whiteTable
    var whiteTable = await Master.getSubMaster(MasterCode.whiteTable);
    if (!isNullEmptyOrFalse(whiteTable)) {
      appendData(getNameWithLikeKeyword(whiteTable, false));
    }

    //whiteCrown
    var whiteCrown = await Master.getSubMaster(MasterCode.whiteCrown);
    if (!isNullEmptyOrFalse(whiteCrown)) {
      appendData(getNameWithLikeKeyword(whiteCrown, false));
    }

    //milky
    var milky = await Master.getSubMaster(MasterCode.milky);
    if (!isNullEmptyOrFalse(milky)) {
      appendData(getNameWithLikeKeyword(milky, false));
    }

    //tableOpen
    var tableOpen = await Master.getSubMaster(MasterCode.tableOpen);
    if (!isNullEmptyOrFalse(tableOpen)) {
      appendData(getNameWithLikeKeyword(tableOpen, false));
    }

    //crownOpen
    var crownOpen = await Master.getSubMaster(MasterCode.crownOpen);
    if (!isNullEmptyOrFalse(crownOpen)) {
      appendData(getNameWithLikeKeyword(crownOpen, false));
    }

    //pavilionOpen
    var pavilionOpen = await Master.getSubMaster(MasterCode.pavilionOpen);
    if (!isNullEmptyOrFalse(pavilionOpen)) {
      appendData(getNameWithLikeKeyword(pavilionOpen, false));
    }

    //origin
    var origin = await Master.getSubMaster(MasterCode.origin);
    if (!isNullEmptyOrFalse(origin)) {
      appendData(getNameWithLikeKeyword(origin, false));
    }

    //eyeClean
    var eyeClean = await Master.getSubMaster(MasterCode.eyeClean);
    if (!isNullEmptyOrFalse(eyeClean)) {
      appendData(getNameWithLikeKeyword(eyeClean, false));
    }

    //hAndA
    var hAndA = await Master.getSubMaster(MasterCode.hAndA);
    if (!isNullEmptyOrFalse(hAndA)) {
      appendData(getNameWithLikeKeyword(hAndA, false));
    }

    //keyToSymbol
    var keyToSymbol = await Master.getSubMaster(MasterCode.keyToSymbol);
    if (!isNullEmptyOrFalse(keyToSymbol)) {
      appendData(getNameWithLikeKeyword(keyToSymbol, false));
    }

    appendData(["3EX", "2EX", "3VG+", "NO BGM"]);

    arrSuggestion = removeDuplicates(arrSuggestion);
  }

  appendData(List<String> array) {
    for (var item in array) {
      arrSuggestion.add(item);
    }
  }

  List<String> getNameWithLikeKeyword(
      List<Master> masters, bool isMarketingDisplay) {
    var names = List<String>();

    if (isMarketingDisplay) {
      names = masters.map((e) => e.marketingDisplay ?? "").toList();
    } else {
      names = masters.map((e) => e.webDisplay ?? "").toList();
    }

    for (var item in masters) {
      if (!isNullEmptyOrFalse(item.likeKeyWords)) {
        for (var keyWord in item.likeKeyWords) {
          names.add(keyWord);
        }
      }
    }

    return names;
  }

  List<String> removeDuplicates(List<String> array) {
    var encountered = Set<String>();
    List<String> result = [];
    for (var value in array) {
      if (encountered.contains(value)) {
        // Do not add a duplicate element.
      } else {
        // Add value to the set.
        encountered.add(value);
        // ... Append the value.
        result.add(value);
      }
    }
    return result;
  }

  List<String> getSearchDataSet(String searchText) {
    if (!isNullEmptyOrFalse(searchText)) {
      arrSuggestion.where((element) {
        var str = element.toLowerCase();
        if (str.contains(searchText)) {
          return true;
        }

        return false;
      });
    }

    return [];
  }

  openSuggestion(String text) {
    var array = text.split(" ");
    var filterData = getSearchDataSet(array.last);

    setState(() {});
  }
}
