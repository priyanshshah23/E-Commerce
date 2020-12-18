import 'package:diamnow/app/Helper/AppDatabase.dart';
import 'package:diamnow/app/app.export.dart';
import 'package:diamnow/models/OfflineSearchHistory/OfflineSearchHistoryModel.dart';
import 'package:sembast/sembast.dart';

class OfflineSearchHistoryDao {
  static const String SEARCH_HISTORY_STORE_NAME = 'searchhistorystore';

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _offlineSearchStore =
      stringMapStoreFactory.store(SEARCH_HISTORY_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future addOrUpdate(List<OfflineSearchHistoryModel> arrList) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    for (OfflineSearchHistoryModel searchHistory in arrList) {
      await _offlineSearchStore.record(searchHistory.date).put(
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

  Future<List<OfflineSearchHistoryModel>> getSearchHistory() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('date', false),
    ]);

    final recordSnapshots = await _offlineSearchStore.find(
      await _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final master = OfflineSearchHistoryModel.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      master.date = snapshot.key.toString();
      return master;
    }).toList();
  }
}
