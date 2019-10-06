import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:strongr/bloc/app_bloc.dart';
import 'package:strongr/workout/data/workout_dao_interface.dart';
import 'package:strongr/root_view.dart';
import 'package:strongr/workout/data/workout_bloc.dart';
import 'package:strongr/workout/data/workout_dao.dart';
import 'package:strongr/workout/data/workset_bloc.dart';

// This is our global ServiceLocator
GetIt serviceLocator = GetIt.instance;

void main() {

  serviceLocator.registerSingleton<WorkoutDaoInterface>(WorkoutDao());
  serviceLocator.registerSingleton<AppBloc>(WorkoutBloc());

//  initDb();
  runApp(
    MultiProvider(
      providers: [
        Provider(builder: (context) => WorkoutBloc()),
        Provider(builder: (context) => WorkSetBloc()),
      ],
      child: RootView(),
    ),
  );
}

Future initDb() async {
  String dbPathOrName = 'strongr.db';
  // get the application documents directory
  var dir = await getApplicationDocumentsDirectory();
  // make sure it exists
  await dir.create(recursive: true);
  // build the database path
  var dbPath = join(dir.path, dbPathOrName);
  // open the database
  var db = await databaseFactoryIo.openDatabase(dbPath);

  print("workout repo: $dbPath");

  var mainStore = StoreRef<String, Map<String, dynamic>>.main();
  var userStore = StoreRef<String, dynamic>.main();
  var workoutsStore = StoreRef<String, dynamic>.main();
  var exerciseStore = StoreRef<String, dynamic>.main();
  var worksetStore = StoreRef<String, dynamic>.main();

  String mainStoreKey;
  String userStoreKey;
  String workoutsStoreKey;
  String exerciseStoreKey;
  String worksetStoreKey;

  final finder = Finder(filter: Filter.byKey('user'));
  var records = await userStore.find(db, finder: finder);
  if (records.isEmpty) {
    var key = await userStore.record('user').put(db, {
      "username": "John Doex",
      "hasAuth": false,
      "picUrl": "picUrl",
      "bio": "Bulking brah",
    });
  } else {
    await userStore.update(
      db,
      {
        "username": "John john dex",
        "hasAuth": false,
        "picUrl": "picUrl",
        "bio": "Unmodified",
      },
      finder: finder,
    );
  }
  print('records: $records');
}

class DbRef {
  final String key;
  final Database db;

  DbRef(this.key, this.db);
}
