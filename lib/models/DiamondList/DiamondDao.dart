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
        await _diamondStore
            .record(diamondModel.id)
            .put(await _db, diamondModel.toJson());
      }
    }
  }

  Future deleteAlldiamondModelItems() async {
    await _diamondStore.delete(await _db);
  }

  Future delete(List<String> ids) async {
    if (ids != null && ids.length > 0) {
      for (String str in ids) {
        await _diamondStore.record(str).delete(await _db);
      }
    }
  }

  int _tempDiamodTotalCount;

  Future<DiamondListResp> getDiamondList(Map<String, dynamic> dict,
      {List<FormBaseModel> list}) async {
    if (dict["page"] == DEFAULT_PAGE) {
      _tempDiamodTotalCount = null;
    }

    List<Filter> arrFilter = [];
    if (!isNullEmptyOrFalse(list)) {
      for (var element in list) {
        //Shape Widget
        if (element.viewType == ViewTypes.shapeWidget) {
          SelectionModel selectionModel = element as SelectionModel;
          List<String> arrMaster = selectionModel.masters
              .where((element) => element.isSelected == true)
              .toList()
              .map((e) => e.name)
              .toList();

          for (var str in arrMaster) {
            if (selectionModel.masterCode == MasterCode.shape) {
              arrFilter.add(Filter.equal("shpNm", str));
            }
          }
        } else if (element.viewType == ViewTypes.caratRange) {
          List<Map<String, dynamic>> caratRequest =
              Master.getSelectedCarat((element as SelectionModel).masters) ??
                  [];

          // for (var item in caratRequest) {
          //   arrFilter
          //       .add(Filter.greaterThanOrEquals("crt", item.from));
          //   arrFilter.add(Filter.lessThanOrEquals("crt", item.split("-")[1]));
          // }
          if (!isNullEmptyOrFalse(
              (element as SelectionModel).caratRangeChipsToShow)) {
            for (var item
                in (element as SelectionModel).caratRangeChipsToShow) {
              arrFilter
                  .add(Filter.greaterThanOrEquals("crt", item.split("-")[0]));
              arrFilter.add(Filter.lessThanOrEquals("crt", item.split("-")[1]));
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
}
