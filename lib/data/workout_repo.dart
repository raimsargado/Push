import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:strongr/workout/bloc/workout.dart';

class WorkoutRepo {
  final workoutList = List<Workout>();

  WorkoutRepo._privateConstructor() {
    initFirstStorage();
  }

  static final _instance = WorkoutRepo._privateConstructor();

  factory WorkoutRepo() {
    return _instance;
  }

  Future initFirstStorage() async {
    String dbPathOrName = 'workout.db';

    // get the application documents directory
    var dir = await getApplicationDocumentsDirectory();
    // make sure it exists
    await dir.create(recursive: true);
    // build the database path
    var dbPath = join(dir.path, dbPathOrName);
    // open the database
    var db = await databaseFactoryIo.openDatabase(dbPath);

    print("workout repo: $dbPath");

    // Use the main store for storing map data with an auto-generated
    // int key
    var store = intMapStoreFactory.store();

    // Add the data and get its new generated key
    int key;
    Transaction thisTxn;
    await db.transaction((txn) async {
      thisTxn = txn;
      key = await store.add(thisTxn, {
        'workout': 'Push Day',
        'exercises': {
          'bench press': {
            'w': {
              'previous': '80kgx5',
              'kg': '80kg',
              'reps': 'x5',
              'status': 'done',
            },
          },
          'ohp': {
            'w': {
              'previous': '80kgx5',
              'kg': '80kg',
              'reps': 'x5',
              'status': 'done',
            },
          },
          'french press': {
            'w': {
              'previous': '80kgx5',
              'kg': '80kg',
              'reps': 'x5',
              'status': 'done',
            },
          },
        }
      });
      return db;
    }).then((db) async {
      print("then db : $db");
      // Retrieve the record
      var record =  await store.record(key).getSnapshot(db);
      var workoutValue = record['workout'];
      var exercises = record['exercises'];
      print("read map: values: $workoutValue , $exercises");

    });

//    var storeRef = StoreRef()
  }
}
