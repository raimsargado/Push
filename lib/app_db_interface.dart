import 'package:sembast/sembast.dart';

abstract class AppDatabaseApi {
  Future<Database> get database;

  Future<String> backup();

  Future<void> write(String dataAsText, String fileName);

  Future<String> read(String fileName);

  Future<int> delete(String fileName);

  Future<void> restore(String dataAsText);
}
