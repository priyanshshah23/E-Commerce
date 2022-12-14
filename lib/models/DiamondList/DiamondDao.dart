import 'package:diamnow/app/constant/EnumConstant.dart';
import 'package:diamnow/app/constant/constants.dart';
import 'package:diamnow/app/utils/string_utils.dart';
import 'package:diamnow/models/DiamondList/DiamondListModel.dart';
import 'package:diamnow/models/FilterModel/FilterModel.dart';
import 'package:sembast/sembast.dart';
import 'package:diamnow/app/Helper/AppDatabase.dart';
import 'package:diamnow/models/Master/Master.dart';

import 'DiamondModel.dart';

class DiamondDao {
  static const String DIAMOND_STORE_NAME = 'diamond';

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _diamondStore = stringMapStoreFactory.store(DIAMOND_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future addOrUpdate(List<DiamondModel> diamondModels) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    if (diamondModels != null && diamondModels.length > 0) {
      for (DiamondModel diamondModel in diamondModels) {
        await _diamondStore.record(diamondModel.id).put(
              await _db,
              diamondModel.toJson(),
              merge: true,
            );
      }
    }
  }

  Future deleteAlldiamondModelItems() async {
    await _diamondStore.delete(await _db);
  }

  Future deleteByDate(String strDate) async {
    final finder = Finder(filter: Filter.custom(
      (record) {
        if (record["strDate"] == strDate) {
          return true;
        }
        return false;
      },
    ));

    await _diamondStore.delete(await _db, finder: finder);
  }

  Future delete(List<String> ids) async {
    if (ids != null && ids.length > 0) {
      for (String str in ids) {
        await _diamondStore.record(str).delete(await _db);
      }
    }
  }

  int _tempDiamodTotalCount;

  Future<DiamondListResp> getDiamondListBySearchHistory(
      Map<String, dynamic> dict, String strDate) async {
    if (dict["page"] == DEFAULT_PAGE) {
      _tempDiamodTotalCount = null;
    }
    final finder = Finder(
        offset: (dict["page"] - 1) * dict["limit"],
        limit: dict["limit"],
        filter: Filter.custom(
          (record) {
            if (record["strDate"] == strDate) {
              return true;
            }
            return false;
          },
        ));
    final recordSnapshots = await _diamondStore.find(
      await _db,
      finder: finder,
    );

    if (_tempDiamodTotalCount == null) {
      _tempDiamodTotalCount = (await _diamondStore.find((await _db))).length;
    }

    var diamondList = recordSnapshots.map((snapshot) {
      final diamondModel = DiamondModel.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      diamondModel.id = snapshot.key.toString();
      return diamondModel;
    }).toList();

    return DiamondListResp(
      data:Data(count: _tempDiamodTotalCount, diamonds: diamondList),
    );
  }

  Future<DiamondListResp> getDiamondList(Map<String, dynamic> dict,
      {List<FormBaseModel> list}) async {
    if (dict["page"] == DEFAULT_PAGE) {
      _tempDiamodTotalCount = null;
    }

    List<Filter> arrFilter = [];
    if (!isNullEmptyOrFalse(list)) {
      for (var element in list) {
        //Selection Widget
        if (element.viewType == ViewTypes.shapeWidget ||
            element.viewType == ViewTypes.selection) {
          SelectionModel selectionModel = element as SelectionModel;

          List<Master> arrList = selectionModel.masters
              .where((element) => element.isSelected == true)
              .toList();

          if (!isNullEmptyOrFalse(arrList)) {
            if (selectionModel.masterCode == MasterCode.newarrivalsgroup) {
              for (var item in arrList) {
                if (item.code == MasterCode.newarrivals) {
                  arrFilter.add(Filter.equal("wSts", "B"));
                }
              }
            } else {
              List<String> arrMaster = arrList.map((e) => e.sId).toList();

              for (var str in arrMaster) {
                arrFilter.add(Filter.equal(selectionModel.apiKey, str));
                arrFilter.add(Filter.matches(selectionModel.apiKey, str,
                    anyInList: true));
              }
            }
          }
        } else
        //Carat Range
        if (element.viewType == ViewTypes.caratRange) {
          List<Map<String, dynamic>> caratRequest =
              Master.getSelectedCarat((element as SelectionModel).masters) ??
                  [];

          for (var item in caratRequest) {
            Map<String, dynamic> map = item["crt"];

            arrFilter.add(
              Filter.custom(
                (record) {
                  if (record["crt"] >= num.parse(map[">="]) &&
                      record["crt"] <= num.parse(map["<="])) {
                    return true;
                  }
                  return false;
                },
              ),
            );
          }

          //Chips to select
          if (!isNullEmptyOrFalse(
              (element as SelectionModel).caratRangeChipsToShow)) {
            for (var item
                in (element as SelectionModel).caratRangeChipsToShow) {
              arrFilter.add(
                Filter.custom(
                  (record) {
                    if (record["crt"] >= num.parse(item.split("-")[0]) &&
                        record["crt"] <= num.parse(item.split("-")[1])) {
                      return true;
                    }
                    return false;
                  },
                ),
              );
            }
          }
        } else
        //From to widget
        if (element.viewType == ViewTypes.fromTo) {
          if (element is FromToModel) {
            if (!isNullEmptyOrFalse(element.valueFrom) &&
                !isNullEmptyOrFalse(element.valueTo)) {
              arrFilter.add(
                Filter.custom(
                  (record) {
                    if (record[element.apiKey] >=
                            num.parse(element.valueFrom) &&
                        record[element.apiKey] <= num.parse(element.valueTo)) {
                      return true;
                    }
                    return false;
                  },
                ),
              );
            }
          }
        }
        //Group widget
        else if (element.viewType == ViewTypes.groupWidget) {
          if ((element is ColorModel)) {
            if (element.groupMasterCode == MasterCode.colorGroup) {
              //Master selection
              if (element.isGroupSelected == false) {
                if (true) {
                  List<Master> arrList = element.masters
                      .where((element) => element.isSelected == true)
                      .toList();

                  if (!isNullEmptyOrFalse(arrList)) {
                    List<String> arrMaster = arrList.map((e) => e.sId).toList();

                    for (var str in arrMaster) {
                      arrFilter.add(Filter.equal("col", str));
                    }
                  }
                }
              } else {
                if (true) {
                  List<Master> arrList = element.groupMaster
                      .where((element) => element.isSelected == true)
                      .toList();

                  if (!isNullEmptyOrFalse(arrList)) {
                    List<String> arrMaster = arrList.map((e) => e.sId).toList();

                    for (var str in arrMaster) {
                      arrFilter
                          .add(Filter.matches("fcCol", str, anyInList: true));
                    }
                  }
                }
              }

              if (true) {
                List<Master> arrList = element.overtone
                    .where((element) => element.isSelected == true)
                    .toList();

                if (!isNullEmptyOrFalse(arrList)) {
                  List<String> arrMaster = arrList.map((e) => e.sId).toList();

                  for (var str in arrMaster) {
                    arrFilter
                        .add(Filter.matches("ovrtn", str, anyInList: true));
                  }
                }
              }

              if (true) {
                List<Master> arrList = element.intensity
                    .where((element) => element.isSelected == true)
                    .toList();

                if (!isNullEmptyOrFalse(arrList)) {
                  List<String> arrMaster = arrList.map((e) => e.sId).toList();

                  for (var str in arrMaster) {
                    arrFilter
                        .add(Filter.matches("inten", str, anyInList: true));
                  }
                }
              }
            }
          }
        } else
        //Key to symbol
        if (element.viewType == ViewTypes.keytosymbol) {
          List<RadioButton> listOfSelectedRadioButton =
              (element as KeyToSymbolModel)
                  .listOfRadio
                  .where(
                    (element) => element.isSelected == true,
                  )
                  .toList();

          if (!isNullEmptyOrFalse(listOfSelectedRadioButton)) {
            var list =
                Master.getSelectedId((element as SelectionModel).masters);
            if (!isNullEmptyOrFalse(list)) {
              // mapOfSelectedRadioButton[listOfSelectedRadioButton.first.apiKey] =
              //     Master.getSelectedId((element as SelectionModel).masters);
              if (listOfSelectedRadioButton.first.apiKey.toLowerCase() ==
                  "in") {
                for (var selectedMaster in Master.getSelectedId(
                    (element as SelectionModel).masters)) {
                  arrFilter.add(Filter.matches(element.apiKey, selectedMaster,
                      anyInList: true));
                }
              } else {
                for (var selectedMaster
                    in (element as SelectionModel).masters) {
                  if (selectedMaster.isSelected == false) {
                    arrFilter.add(Filter.matches(
                        element.apiKey, selectedMaster.sId,
                        anyInList: true));
                  }
                }
              }
            }
          }
        }
      }
    }
    final finder = Finder(
      offset: (dict["page"] - 1) * dict["limit"],
      limit: dict["limit"],
    );

    if (!isNullEmptyOrFalse(arrFilter)) {
      finder.filter = Filter.or(arrFilter);
    }

    if (_tempDiamodTotalCount == null) {
      _tempDiamodTotalCount = (await _diamondStore.find((await _db))).length;
    }

    final recordSnapshots = await _diamondStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    var diamondList = recordSnapshots.map((snapshot) {
      final diamondModel = DiamondModel.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      diamondModel.id = snapshot.key.toString();
      return diamondModel;
    }).toList();

    return DiamondListResp(
      data: Data(count: _tempDiamodTotalCount, diamonds: diamondList),
    );
  }
}
