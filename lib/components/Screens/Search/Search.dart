import 'dart:async';
import 'dart:collection';

import 'package:diamnow/app/Helper/NetworkClient.dart';
import 'package:diamnow/app/Helper/SyncManager.dart';
import 'package:diamnow/app/Helper/Themehelper.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/constant/ImageConstant.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/localization/app_locales.dart';
import 'package:diamnow/app/theme/app_theme.dart';
import 'package:diamnow/app/utils/CommonWidgets.dart';
import 'package:diamnow/app/utils/math_utils.dart';
import 'package:diamnow/components/Screens/DiamondList/DiamondListScreen.dart';
import 'package:diamnow/components/widgets/BaseStateFulWidget.dart';
import 'package:diamnow/models/DiamondList/DiamondConstants.dart';
import 'package:diamnow/models/Master/Master.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchScreen extends StatefulScreenWidget {
  static const route = "SearchScreen";
  bool isFromSearch;

  SearchScreen(
    Map<String, dynamic> arguments, {
    Key key,
  }) : super(key: key) {
    if (arguments != null) {
      this.isFromSearch = arguments["isFromSearch"] ?? false;
    }
  }

  @override
  _SearchScreenState createState() => _SearchScreenState(this.isFromSearch);
}

class _SearchScreenState extends StatefulScreenWidgetState {
  final TextEditingController _searchController = TextEditingController();
  var _focusSearch = FocusNode();
  var arrSuggestion = List<String>();
  String totalSearch = "";
  String searchText = "";
  bool isFromSearch;
  List<String> arrList = [];
  List<String> arrSelected = [];
  Timer timer;

  _SearchScreenState(this.isFromSearch);
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      FocusScope.of(context).requestFocus(_focusSearch);
    });

    if (isFromSearch == false) {
      prepareDataSource();
    }
  }

  @override
  void dispose() {
    if (isFromSearch == true) {
      timer.cancel();
    }
    super.dispose();
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
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(getSize(16)),
            decoration: BoxDecoration(boxShadow: getBoxShadow(context)),
            child: AppButton.flat(
              onTap: () {
                FocusScope.of(context).unfocus();
                callCountApi();
              },
              borderRadius: getSize(5),
              fitWidth: true,
              text: R.string().commonString.search,
            ),
          ),
          body: SafeArea(
            child: isFromSearch
                ? showListView()
                : ListView(
                    children: [
                      getSearchTextField(),
                      openSuggestion(),
                    ],
                  ),
          )),
    );
  }

  getSearchTextField() {
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
            child: TextFormField(
              maxLines: 1,
              textAlignVertical: TextAlignVertical(y: 1.0),
              textInputAction: TextInputAction.search,
              focusNode: _focusSearch,
              autofocus: false,
              controller: _searchController,
              obscureText: false,
              style: appTheme.black16TextStyle,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              cursorColor: appTheme.colorPrimary,
              inputFormatters: [
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
                hintText: R.string().authStrings.searchHint,
                labelStyle: TextStyle(
                  color: appTheme.textColor,
                  fontSize: getFontSize(16),
                ),
                // suffix: widget.textOption.postfixWidOnFocus,
                suffixIcon: Padding(
                    padding: EdgeInsets.all(getSize(12)),
                    child: Image.asset(search,
                        height: getSize(16), width: getSize(16))),
              ),
              onChanged: (String text) {
                if (!isFromSearch) {
                  this.searchText = text;
                  openSuggestion();
                  setState(() {});
                } else {
                  if (text.length > 2) {
                    if (timer != null) timer.cancel();
                    timer = Timer(Duration(seconds: 2), () {
                      callApiForSearchStoneId(text);
                    });
                  }
                }
              },
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                callCountApi();
              },
            ),
          ),
        ),
      ),
    );
  }

  prepareDataSource() async {
    //Shape
    List<Master> shapes = await Master.getSubMaster(MasterCode.shape);
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

  List<String> getSearchDataSet(String searchData) {
    if (!isNullEmptyOrFalse(searchData)) {
      return arrSuggestion.where((element) {
        var str = element.toLowerCase();
        if (str.contains(searchData.toLowerCase())) {
          return true;
        }

        return false;
      }).toList();
    }

    return [];
  }

  openSuggestion() {
    var array = searchText.split(" ");
    var filterData = getSearchDataSet(array.last);

    if (isNullEmptyOrFalse(filterData)) {
      return Container(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Center(
          child: Text(
              _searchController.text.length > 0
                  ? "No Data Found"
                  : "Type to search",
              textAlign: TextAlign.center,
              style: appTheme.black18TextStyle),
        ),
      );
    }

    return !isNullEmptyOrFalse(filterData)
        ? Padding(
            padding: EdgeInsets.all(getSize(16)),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filterData.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    array.removeLast();

                    searchText = "${array.join(" ")} ${filterData[index]} ";
                    _searchController.text = searchText;

                    _searchController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _searchController.text.length));

                    filterData = [];

                    setState(() {});
                  },
                  child: getWidget(filterData[index]),
                );
              },
            ),
          )
        : Container();
  }

  getWidget(String data) {
    return Padding(
      padding:
          EdgeInsets.only(top: getSize(8), left: getSize(8), right: getSize(8)),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                data,
                style: appTheme.black14TextStyle,
              ),
            ],
          ),
          Divider(
            color: appTheme.dividerColor,
            thickness: 2,
          )
        ],
      ),
    );
  }

  showListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getSearchTextField(),
        Padding(
          padding: EdgeInsets.only(
            top: getSize(16),
            left: getSize(16),
            right: getSize(16),
          ),
          child: getChips(),
        ),
        Expanded(
          child: getList(),
        )
      ],
    );
  }

  getChips() {
    if (isNullEmptyOrFalse(arrSelected)) {
      return Container();
    }
    return Wrap(
      spacing: getSize(6),
      runSpacing: getSize(0),
      children: List<Widget>.generate(arrSelected.length, (int index) {
        return Chip(
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(getSize(10))),
          label: Text(
            arrSelected[index],
            style: appTheme.blackMedium14TitleColorblack,
          ),
          backgroundColor: appTheme.unSelectedBgColor,
          deleteIcon: Icon(
            Icons.clear,
            color: appTheme.textColor,
            size: getSize(16),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(getSize(5)),
              side: BorderSide(color: appTheme.colorPrimary)),
          onDeleted: () {
            setState(() {
              arrSelected.removeWhere((entry) {
                return entry == arrSelected[index];
              });
            });
          },
        );
      }),
    );
  }

  getList() {
    if (isNullEmptyOrFalse(arrList)) {
      return Container(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Center(
          child: Text(
              _searchController.text.length > 0
                  ? "No Data Found"
                  : "Type at least 3 characters to \nsearch stones",
              textAlign: TextAlign.center,
              style: appTheme.black18TextStyle),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(getSize(16)),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: arrList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  getSize(0),
                  getSize(16),
                  getSize(16),
                  getSize(20),
                ),
                child: InkWell(
                  onTap: () {
                    if (arrSelected.contains(arrList[index])) {
                      arrSelected.removeWhere((entry) {
                        return entry == arrList[index];
                      });
                    } else {
                      arrSelected.add(arrList[index]);
                      _searchController.text = "";
                    }

                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Text(
                        arrList[index],
                        style: appTheme.blackMedium16TitleColorblack,
                      ),
                      Spacer(),
                      Image.asset(
                        arrSelected.contains(arrList[index])
                            ? tickSelected
                            : tickUnSelected,
                        width: getSize(16),
                        height: getSize(16),
                        color: !arrSelected.contains(arrList[index])
                            ? appTheme.textGreyColor
                            : appTheme.colorPrimary,
                      )
                    ],
                  ),
                ),
              ),
              Divider(height: getSize(1), color: appTheme.borderColor),
            ],
          );
        },
      ),
    );
  }

  callCountApi() {
    Map<String, dynamic> req = {};
    req = {
      "or": [
        {"stoneId": arrSelected},
        {"rptNo": arrSelected},
        {"vStnId": arrSelected}
      ]
    };

    SyncManager.instance.callApiForDiamondList(
      context,
      isFromSearch ? req : {},
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
      searchText: isFromSearch ? null : _searchController.text.trim(),
    );
  }

  callApiForSearchStoneId(String searchText) {
    Map<String, dynamic> req = {};

    req["startWith"] = {
      "keyword": searchText,
      "keys": ["rptNo", "vStnId", "stoneId"]
    };
    req["sort"] = [
      {"createdAt": "DESC"}
    ];

    NetworkClient.getInstance.callApi(
        context, baseURL, ApiConstants.searchReportNo, MethodType.Post,
        headers: NetworkClient.getInstance.getAuthHeaders(),
        params: req, successCallback: (response, message) {
      arrList = [];
      if (response is List<dynamic>) {
        for (var item in response) {
          arrList.add(item);
        }
      }
      setState(() {});
    }, failureCallback: (status, message) {
      print(message);
    });
  }
}
