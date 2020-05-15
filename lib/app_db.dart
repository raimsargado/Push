import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:push/app_db_interface.dart';
import 'package:sembast/utils/sembast_import_export.dart';

class AppDatabase extends AppDatabaseApi {
  //Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database> _dbOpenCompleter;

  // Database object accessor
  Future<Database> get database async {
    print("dbcompleter: $_dbOpenCompleter");
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
    // Path with the form: /platform-specific-directory/push.main.db
    final dbPath = join(appDocumentDir.path, 'push.db');

    var db = await databaseFactoryIo.openDatabase(dbPath);

    print("dbPath: $dbPath");
    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter.complete(db);
  }

  @override
  Future<String> backup() async {
    var content = await exportDatabase(await database);
// Save as text
    var saved = jsonEncode(content);
    print("backupDb: ${saved}");
    return saved;
  }

  @override
  Future<void> write(String dataAsText, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$fileName.txt');
    await file.writeAsString(dataAsText);
  }

  @override
  Future<String> read(String fileName) async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$fileName.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }

  @override
  Future<int> delete(String fileName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$fileName.txt');
      await file.delete();
      return 1;
    } catch (e) {
      print("Couldn't delete file");
      return 0;
    }
  }

  @override
  Future<void> restore(String dataAsText) async {
    var oldDb = await database;
    var map = jsonDecode(dataAsText) as Map;
    var db = await importDatabase(map, databaseFactoryIo, oldDb.path);
    _dbOpenCompleter = null;
    print("RESTORE : $db");
    return null;
  }
}


