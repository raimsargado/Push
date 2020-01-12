import 'package:sembast/sembast.dart';
import 'package:strongr/app_db_interface.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workset/models/workset.dart';

class WorkSetDao {
  StoreRef _workSetStore;

  Future<Database> get _database async =>
      await serviceLocator.get<AppDatabaseApi>().database;

  Future addWorkSet(WorkSet workSet) async {
    await _workSetStore.add(await _database, workSet.toMap());
  }
  Future updateSet(WorkSet workSet) async {
    final finder = Finder(filter: Filter.byKey(workSet.id));
    await _workSetStore.update(
      await _database,
      workSet.toMap(),
      finder: finder,
    );
  }

  void deleteWorkSet(WorkSet workSet) {
    // TODO: implement updateSet
  }

  // TODO: implement workSet
  WorkSet get workSet => null;

  // TODO: implement workSets
  Future<List<WorkSet>> getWorkSets(
      String workoutName, String exerciseName) async {
    //INIT THE STORE , [workoutName] + [exerciseName] as store ref
    _workSetStore = intMapStoreFactory.store(workoutName + exerciseName);

    // Finder object can also sort data.

    final recordSnapshots = await _workSetStore.find(await _database);

    // Making a List<Workout> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final workSet = WorkSet.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      workSet.id = snapshot.key;
      return workSet;
    }).toList();
  }
}
