import 'package:sembast/sembast.dart';

abstract class AppDatabaseApi{
  Future<Database> get database;
}