import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:strongr/app_db_interface.dart';

class AppDatabase extends AppDatabaseApi {

  //Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database> _dbOpenCompleter;

  // Database object accessor
  Future<Database> get database async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter.future;
  }

  Future _openDatabase() async {
    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // make sure it exists
    await appDocumentDir.create(recursive: true);
    // Path with the form: /platform-specific-directory/strongr.main.db
    final dbPath = join(appDocumentDir.path, 'strongr.db');

    final database = await databaseFactoryIo.openDatabase(dbPath);

    print("dbPath: $dbPath");
    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter.complete(database);
  }
}
