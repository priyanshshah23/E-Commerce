import 'package:sembast/sembast.dart';
import 'package:diamnow/app/Helper/AppDatabase.dart';
import 'package:diamnow/models/Master/Master.dart';

class MasterDao {
  static const String MASTER_STORE_NAME = 'master';

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _masterStore = stringMapStoreFactory.store(MASTER_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future addOrUpdate(List<Master> masters) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    if (masters != null && masters.length > 0) {
      for (Master master in masters) {
        await _masterStore.record(master.sId).put(await _db, master.toJson());
      }
    }
  }

  Future deleteAllMasterItems() async {
    await _masterStore.delete(await _db);
  }

  Future delete(List<String> ids) async {
    if (ids != null && ids.length > 0) {
      for (String str in ids) {
        await _masterStore.record(str).delete(await _db);
      }
    }
  }

  Future<List<Master>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _masterStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final master = Master.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      master.sId = snapshot.key.toString();
      return master;
    }).toList();
  }

  Future<List<Master>> getSubMasterFromParentCode(String code) async {
    // Finder object can also sort data.
    final finder = Finder(
      filter: Filter.and([
        Filter.equal('parentCode', code),
        Filter.notEqual('parentId', null),
        Filter.equal('isDeleted', false),
        Filter.equal('isWebVisible', true),
        Filter.equal('isActive', true),
      ]),
      sortOrders: [
        SortOrder('sortingSequence'),
      ],
    );

    final recordSnapshots = await _masterStore.find(
      await _db,
      finder: finder,
    );

    var arrMaster = recordSnapshots.map((snapshot) {
      final master = Master.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      master.sId = snapshot.key.toString();
      return master;
    }).toList();

    return arrMaster;
  }

  Future<List<Master>> getSubMasterFromCode(String code) async {
    // Finder object can also sort data.
    final finder = Finder(
      filter: Filter.equal('code', code),
      sortOrders: [
        SortOrder('sortingSequence'),
      ],
    );

    final recordSnapshots = await _masterStore.find(
      await _db,
      finder: finder,
    );

    var arrMaster = recordSnapshots.map((snapshot) {
      final master = Master.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      master.sId = snapshot.key.toString();
      return master;
    }).toList();

    if (arrMaster.length > 0) {
      // final finder2 = Finder(
      //   filter: Filter.equal('parentId', arrMaster.first.sId),
      // sortOrders: [
      //   SortOrder('sortingSequence'),
      // ],
      // );

      final finder2 = Finder(
        sortOrders: [
          SortOrder('sortingSequence'),
        ],
        filter: Filter.and([
          Filter.equal('parentId', arrMaster.first.sId),
          Filter.equal('isDeleted', false),
          Filter.equal('isActive', true),
        ]),
      );

      final subRecordSnapshots = await _masterStore.find(
        await _db,
        finder: finder2,
      );

      return subRecordSnapshots.map((snapshot) {
        final master = Master.fromJson(snapshot.value);
        // An ID is a key of a record from the database.
        master.sId = snapshot.key.toString();
        return master;
      }).toList();
    } else {
      return null;
    }
  }

  Future<Master> getMasterFromID(String id) async {
    // Finder object can also sort data.
    final finder = Finder(
      filter: Filter.equal('_id', id),
      // sortOrders: [
      //   SortOrder('sortingSequence'),
      // ],
    );

    final recordSnapshots = await _masterStore.find(
      await _db,
      finder: finder,
    );

    var arrMaster = recordSnapshots.map((snapshot) {
      final master = Master.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      master.sId = snapshot.key.toString();
      return master;
    }).toList();

    if (arrMaster.length > 0) {
      return arrMaster.first;
    } else {
      return null;
    }
  }

  Future<Master> getMasterFromCode(String code) async {
    // Finder object can also sort data.
    final finder = Finder(
      filter: Filter.equal('code', code),
    );

    final recordSnapshots = await _masterStore.find(
      await _db,
      finder: finder,
    );

    var arrMaster = recordSnapshots.map((snapshot) {
      final master = Master.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      master.sId = snapshot.key.toString();
      return master;
    }).toList();

    if (arrMaster.length > 0) {
      return arrMaster.first;
    } else {
      return null;
    }
  }
}
