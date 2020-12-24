import 'package:diamnow/app/Helper/AppDatabase.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/app/utils/date_utils.dart';
import 'package:diamnow/models/DiamondList/DiamondModel.dart';
import 'package:sembast/sembast.dart';

class OfflineStockTrackModel {
  int trackType;
  String request;
  String uuid;
  bool isSync = false;
  String strDate;
  String diamonds;

  OfflineStockTrackModel({
    this.trackType,
    this.request,
    this.uuid,
    this.isSync,
    this.strDate,
    this.diamonds,
  });

  OfflineStockTrackModel.fromJson(Map<String, dynamic> json) {
    trackType = json['trackType'];
    request = json['request'];
    uuid = json['uuid'];
    isSync = json['isSync'] ?? false;
    strDate = json['strDate'] ??
        DateUtilities().getFormattedDateString(DateTime.now(),
            formatter: DateUtilities.kSourceFormat);
    diamonds = json['diamonds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trackType'] = this.trackType;
    data['request'] = this.request;
    data['uuid'] = this.uuid;
    data['isSync'] = this.isSync ?? false;
    data["strDate"] = this.strDate;
    data["diamonds"] = this.diamonds;
    return data;
  }
}

class OfflineStockTrackModelDao {
  static const String OFFLINE_STOCK_TRACK_STORE_NAME =
      'offlinestocktrackmodeldao';

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _offlineSearchStore =
      stringMapStoreFactory.store(OFFLINE_STOCK_TRACK_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future addOrUpdate(List<OfflineStockTrackModel> arrList) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    for (OfflineStockTrackModel searchHistory in arrList) {
      await _offlineSearchStore.record(searchHistory.uuid).put(
            await _db,
            searchHistory.toJson(),
            merge: true,
          );
    }
  }

  Future deleteAlldiamondModelItems() async {
    await _offlineSearchStore.delete(await _db);
  }

  Future delete(String strDate) async {
    final finder = Finder(filter: Filter.equal("date", strDate));
    await _offlineSearchStore.delete(await _db, finder: finder);
  }

  Future<List<OfflineStockTrackModel>> getOfflineStockTrack() async {
    // Finder object can also sort data.
    final finder = Finder(
      sortOrders: [
        SortOrder('strDate', false),
      ],
      filter: Filter.equal("isSync", false),
    );

    final recordSnapshots = await _offlineSearchStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final master = OfflineStockTrackModel.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      master.strDate = snapshot.key.toString();
      return master;
    }).toList();
  }
}
